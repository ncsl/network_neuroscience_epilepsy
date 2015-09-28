/*

 Program to read mef format file (v.2) and save data as raw 32bit integers
 Reads entire input file, decodes, and then saves entire output file.

 To compile for a 64-bit intel system: (options will vary depending on your particular compiler and platform)
 Intel Compiler: icc mef2raw32.c mef_lib.c endian_functions.c AES_encryption.c RED_decode.c RED_encode.c crc_32.c -o mef2raw -fast -m64
 GCC: gcc mef2raw32.c mef_lib.c endian_functions.c AES_encryption.c RED_decode.c RED_encode.c crc_32.c -o mef2raw -O3 -arch x86_64

 For 32-bit systems write over size_types.h with size_types_32.h before compiling. You will also need to change compiler flags.

 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "size_types.h"
#include "mef_header_2_0.h"
#include "RED_codec.h"
#include "mef_lib.h"

int main (int argc, const char * argv[]) {
  si4 i, num, numBlocks, l;
  si4 *data, *dp;
  ui8 numEntries, inDataLength, bytesDecoded, entryCounter;
  si1 password[16], outFileName[200], path[200], encryptionKey[240];
  ui1 *hdr_block, *in_data, *idp, *diff_buffer, *dbp;
  FILE *fp;
  MEF_HEADER_INFO header;
  RED_BLOCK_HDR_INFO RED_bk_hdr;
  void AES_KeyExpansion();



  memset(password, 0, 16);

  if (argc < 2 || argc > 4)
  {
    (void) printf("USAGE: %s file_name [password] \n", argv[0]);
    return(1);
  }

  if (argc > 2) { //check input arguments for password
    strncpy(password, argv[2], 16);
  }

  //allocate memory for (encrypted) header block
  hdr_block = calloc(sizeof(ui1), MEF_HEADER_LENGTH);

  fp = fopen(argv[1], "r");
  if (fp == NULL) {
    fprintf(stderr, "Error opening file %s\n", argv[1]);
    return 1;
  }

  num = fread(hdr_block, 1, MEF_HEADER_LENGTH, fp);
  if (num != MEF_HEADER_LENGTH) {
    fprintf(stderr, "Error reading file %s\n", argv[1]);
    return 1;
  }

  read_mef_header_block(hdr_block, &header, password);

  if (header.session_encryption_used && validate_password(hdr_block, password)==0) {
    fprintf(stderr, "Can not decrypt MEF header\n");
    free(hdr_block);
    return 1;
  }

  numBlocks = header.number_of_index_entries;
  numEntries = header.number_of_samples;
  inDataLength = header.index_data_offset - header.header_length;
  if (header.data_encryption_used) {
    AES_KeyExpansion(4, 10, encryptionKey, header.session_password);
  }
  else
    *encryptionKey = 0;

  free(hdr_block);

  diff_buffer = malloc(header.maximum_block_length * 4);
  in_data = malloc(inDataLength);
  data = calloc(sizeof(ui4), numEntries);
  if (data == NULL || in_data == NULL || diff_buffer == NULL) {
    fprintf(stderr, "malloc error\n");
    return 1;
  }

  fprintf(stdout, "\n\nReading file %s \n", argv[1]);
  num = fread(in_data, 1, inDataLength, fp);
  if (num != inDataLength) {
    fprintf(stderr, "Data read error \n");
    return 1;
  }
  fclose(fp);

  fprintf(stdout, "Starting decompression loop with %d blocks\n", numBlocks);

  dp = data;	idp = in_data;	dbp = diff_buffer;
  entryCounter = 0;
  for (i=0; i<numBlocks; i++)
  {
    bytesDecoded = RED_decompress_block(idp, dp, dbp, encryptionKey, 0, &RED_bk_hdr);
    idp += bytesDecoded;
    dp += RED_bk_hdr.sample_count;
    dbp = diff_buffer; //don't need to save diff_buffer- write over
    entryCounter += RED_bk_hdr.sample_count;

  }
  free(in_data); in_data = NULL;
  free(diff_buffer); diff_buffer = NULL;
  fprintf(stdout, "Decompression complete\n");

  //Assemble output filename
  l = (int)strlen(argv[1]);
  memcpy(path, argv[1], l-4);
  path[l-4] = '\0';
  sprintf(outFileName, "%s.raw32", path);

  fp = fopen(outFileName, "w");
  if (fp == NULL) {
    fprintf(stderr, "Error opening file %s\n", outFileName);
    return 1;
  }
  fprintf(stdout, "\n\nWriting file %s: %ld entries \n", outFileName, entryCounter);
  num = fwrite(data, sizeof(si4), entryCounter, fp);
  if (num != entryCounter) {
    fprintf(stderr, "Error writing file %s\n", argv[1]);
    return 1;
  }
  fclose(fp);

  free(data);
  return 0;
}
