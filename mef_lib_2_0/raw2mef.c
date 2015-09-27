/*

 *  raw2mef.c
 *  
 
 Multiscale electrophysiology format example program
 Program to read raw 32bit integers and save data in mef format (v.2) 
 
 To compile for a 64-bit intel system: (options will vary depending on your particular compiler and platform)
 Intel Compiler: icc raw2mef.c RED_encode.c mef_lib.c endian_functions.c AES_encryption.c crc_32.c -o raw2mef -fast -m64
 GCC: gcc raw2mef.c RED_encode.c mef_lib.c endian_functions.c AES_encryption.c crc_32.c -o raw2mef -O3 -arch x86_64
 
 
 This software is made freely available under the GNU public license: http://www.gnu.org/licenses/gpl-3.0.txt
 
 Thanks to all who acknowledge the Mayo Systems Electrophysiology Laboratory, Rochester, MN
 in academic publications of their work facilitated by this software.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <time.h>
#include <math.h>

#include "size_types.h"
#include "mef_header_2_0.h"
#include "RED_codec.h"


int main (int argc, const char * argv[]) {
	si4  *in_data, *idp, i, num, numBlocks, l, value, RED_block_size, num_entries, max_block_size; 
	si4 read_size, discontinuity_flag, max_value, min_value, byte_offset;
	ui8 numEntries, inDataLength, bytesDecoded, entryCounter, dataCounter, size, block_hdr_time, index_data_offset;
	si1 subject_password[32], session_password[32], outFileName[200], path[200], headerFileName[200];
	si1 line[200], encryptionKey[240];
	ui1 *hdr_bk, *data, *dp, *diff_buffer, *dbp, byte_padding[8];
	FILE *fp;
	MEF_HEADER_INFO header;
	RED_BLOCK_HDR_INFO RED_bk_hdr;
	INDEX_DATA *index_block, *ip;
	void AES_KeyExpansion();
	unsigned long RED_compress_block();

	memset(&header, 0, sizeof(MEF_HEADER_INFO));
	memset(subject_password, 0, 32);
	memset(session_password, 0, 32);
	memset(encryptionKey, 0, 240);
	
	//set defaults
	*headerFileName = 0;
	*session_password = 0;
	*subject_password = 0;
	header.sampling_frequency = 32556.0;
	header.block_interval = 1.0; //seconds
	header.byte_order_code = 1; //We assume little-endian
	header.header_version_major = 2;
	header.header_version_minor = 0;
	header.subject_encryption_used = 0;
	header.session_encryption_used = 0;
	
	if (argc < 2) 
	{
		(void) printf("USAGE: %s file_name [options]\n", argv[0]);
		(void) printf("Options:\n \t-h [filename]\t\t[h]eader text file\n");
		(void) printf("\t-s [pwd] \t\t[s]ession password\n");
		(void) printf("\t-b [pwd]\t\tsu[b]ject password\n");
		(void) printf("\t-f [#]\t\tsampling [f]requency (Hz)\n");
		(void) printf("\t-c [name]\t\t[c]hannel name\n");
		(void) printf("\t-i [#]\t\tblock interval (sec)\n");
		return(1);
	}

	for (i = 1; i < argc; i++)
	{
		if (*argv[i] == '-') {
			switch (argv[i][1]) {
					
				case 'h':
					strcpy(headerFileName, argv[i+1]);
					break;
				case 's':
					strcpy(session_password, argv[i+1]);
					break;
				case 'b':
					strcpy(subject_password, argv[i+1]);
					break;
				case 'f':	
					header.sampling_frequency = atof(argv[i+1]);
					break;
				case 'c':
					strcpy(header.channel_name, argv[i+1]);
					break;
				case 't':
					header.block_interval = 1000000*atof(argv[i+1]);
					break;
			}
		}
	}
	
	
	if (*session_password)
	{
		//check password length
		if (strlen(session_password) > 16) {
			fprintf(stderr, "Error: Password cannot exceed 16 characters\n");
			return(1);
		}
		header.session_encryption_used = 1;
		strcpy(header.session_password, session_password);
		//RED block header encryption is used here: comment next two lines to disable
		AES_KeyExpansion(4, 10, encryptionKey, header.session_password); 
		header.data_encryption_used = 1;
	}

	if (*subject_password)
	{
		//check password length
		if (strlen(subject_password) > 16) {
			fprintf(stderr, "Error: Password cannot exceed 16 characters\n");
			return(1);
		}
		header.subject_encryption_used = 1;
	}
	
	if (*headerFileName) {
		fp = fopen(headerFileName, "r");
		if (fp == NULL) {
			fprintf(stderr, "Error opening file %s\n", argv[1]);
			return 1;
		}
		//read header text file
		fgets(header.institution, INSTITUTION_LENGTH, fp);l=strlen(header.institution); header.institution[l-1] = 0;
		fgets(header.subject_first_name, SUBJECT_FIRST_NAME_LENGTH, fp);l=strlen(header.subject_first_name); header.subject_first_name[l-1] = 0;
		fgets(header.subject_second_name, SUBJECT_SECOND_NAME_LENGTH, fp);l=strlen(header.subject_second_name); header.subject_second_name[l-1] = 0;
		fgets(header.subject_third_name, SUBJECT_THIRD_NAME_LENGTH, fp);l=strlen(header.subject_third_name); header.subject_third_name[l-1] = 0;
		fgets(header.subject_id, SUBJECT_ID_LENGTH, fp); l=strlen(header.subject_id); header.subject_id[l-1] = 0; 
		fgets(header.channel_name, CHANNEL_NAME_LENGTH, fp);l=strlen(header.channel_name); header.channel_name[l-1] = 0;
		fgets(line, sizeof(line), fp); header.recording_start_time = atoi(line);
		fgets(line, sizeof(line), fp); header.sampling_frequency = atof(line);
		fgets(line, sizeof(line), fp); header.low_frequency_filter_setting = atof(line);
		fgets(line, sizeof(line), fp); header.high_frequency_filter_setting = atof(line);
		fgets(line, sizeof(line), fp); header.notch_filter_frequency = atof(line);
		fgets(line, sizeof(line), fp); header.voltage_conversion_factor = atof(line);		
		fgets(header.acquisition_system, ACQUISITION_SYSTEM_LENGTH, fp);l=strlen(header.acquisition_system); header.acquisition_system[l-1] = 0;
		fgets(header.channel_comments, ACQUISITION_SYSTEM_LENGTH, fp);l=strlen(header.channel_comments); header.channel_comments[l-1] = 0;
		fgets(header.study_comments, ACQUISITION_SYSTEM_LENGTH, fp);l=strlen(header.study_comments); header.study_comments[l-1] = 0;
		fgets(line, sizeof(line), fp); header.physical_channel_number = atof(line);		
		fgets(line, sizeof(line), fp); header.block_interval = atof(line);

		fclose(fp);
	}

	//Open raw data file and check size
	fp = fopen(argv[1], "r");
	if (fp == NULL) {
		fprintf(stderr, "Error opening file %s\n", argv[1]);
		return 1;
	}
	fseek(fp, 0, SEEK_END);
	size = ftell(fp);
	fseek(fp, 0, SEEK_SET);
	
	header.number_of_samples = size/4; //calculate number of entries in file
	header.maximum_block_length = header.block_interval * header.sampling_frequency;
	numBlocks = ceil((double)header.number_of_samples/header.maximum_block_length);


	in_data = malloc(size);
	data = malloc(size);//compressed data size unknown- malloc enough for uncompressed data, to be safe
	index_block = (INDEX_DATA *)calloc(3*numBlocks, sizeof(ui8));
	if (data == NULL || in_data == NULL || index_block == NULL) {
		fprintf(stderr, "malloc error\n");
		return 1;
	}

	num = fread(in_data, 4, header.number_of_samples, fp);
	if (num != header.number_of_samples) {
		fprintf(stderr, "Data read error \n");
		return 1;
	}
	fclose(fp);
		

	dp = data;	idp = in_data; ip = index_block;
	dataCounter = 0; entryCounter=0; discontinuity_flag = 1;
	max_value = 1<<31; min_value = max_value-1; max_block_size = 0;
	num_entries = header.maximum_block_length;
	for (i=0; i<numBlocks; i++)
	{
		if (i != 0) {
			discontinuity_flag = 0; 
			ip++;
		}
		
		ip->time = header.recording_start_time + i * header.block_interval*1000000;
		ip->file_offset = dataCounter + MEF_HEADER_LENGTH; 
		ip->sample_number = i * header.maximum_block_length;
		
		if (header.number_of_samples - entryCounter < header.maximum_block_length)
			num_entries = header.number_of_samples - entryCounter;		
		
		RED_block_size = RED_compress_block(idp, dp, num_entries, ip->time, 
											(ui1)discontinuity_flag, encryptionKey, &RED_bk_hdr);
		dp += RED_block_size; 
		dataCounter += RED_block_size;
		idp += RED_bk_hdr.sample_count;
		entryCounter += RED_bk_hdr.sample_count;

		if (RED_bk_hdr.max_value > max_value) max_value = RED_bk_hdr.max_value;
		if (RED_bk_hdr.min_value < min_value) min_value = RED_bk_hdr.min_value;
		if (RED_block_size > max_block_size) max_block_size = RED_block_size;
	}
	free(in_data); in_data = NULL;

	header.maximum_data_value = max_value; 
	header.minimum_data_value = min_value;
	header.maximum_compressed_block_size = max_block_size;
	header.number_of_index_entries = numBlocks;
	header.index_data_offset = dataCounter + MEF_HEADER_LENGTH;
	header.recording_end_time = ip->time + (unsigned long)((double)num_entries*1000000.0/header.sampling_frequency + 0.5);
	sprintf(header.compression_algorithm, "Range Encoded Differences (RED)");
	sprintf(header.encryption_algorithm,  "AES %d-bit", ENCRYPTION_BLOCK_BITS);
	
	hdr_bk = calloc(sizeof(ui1), MEF_HEADER_LENGTH);
	memset(hdr_bk, 0, MEF_HEADER_LENGTH);
	
	//generate output file name
	l = (int)strlen(argv[1]);
	memcpy(path, argv[1], l-6);
	path[l-6] = '\0';
	sprintf(outFileName, "%s_raw.mef", path);
	
	fp = fopen(outFileName, "w");
	if (fp == NULL) {
		fprintf(stderr, "Error opening file %s\n", outFileName);
		return 1;
	}

	fprintf(stdout, "\n\nWriting file %s: %ld entries \n", outFileName, entryCounter);
	
	//write blank header block as a place holder
	num = fwrite(hdr_bk, 1, MEF_HEADER_LENGTH, fp);
	
	num = fwrite(data, sizeof(ui1), dataCounter, fp);
	if (num != dataCounter) {
		fprintf(stderr, "Error writing file %s\n", outFileName);
		fclose(fp); free(data); free(index_block);
		return 1;
	}

	//byte align index data if needed
	index_data_offset = ftell(fp);
	byte_offset = index_data_offset % 8;
	if (byte_offset) {
		memset(byte_padding, 0, 8);
		fwrite(byte_padding, sizeof(ui1), 8 - byte_offset, fp);
		index_data_offset += 8 - byte_offset;
	}
	header.index_data_offset = index_data_offset;
	
	num = fwrite(index_block, sizeof(INDEX_DATA), numBlocks, fp);
	if (num != numBlocks) {
		fprintf(stderr, "Error writing file %s\n", outFileName);
		fclose(fp); free(data); free(index_block);
		return 1;
	}
	
	//write header
	fseek(fp, 0, SEEK_SET);
	build_mef_header_block(hdr_bk, &header, subject_password);
	num = fwrite(hdr_bk, 1, MEF_HEADER_LENGTH, fp);
	
	fclose(fp);
	free(index_block);
	free(data);
	return 0;
}

