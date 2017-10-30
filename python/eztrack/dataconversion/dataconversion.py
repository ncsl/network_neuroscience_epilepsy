# Imports necessary for this function
from __future__ import division, absolute_import
import numpy as np
import pandas as pd
import pyedflib

import os
import logging.config
import yaml

# sets up logging configuration based on a yaml file
def setup_logging(default_path='logging_dataconversion.yaml', default_level=logging.INFO, env_key='LOG_CFG'):
    """Setup logging configuration for any loggers created
    """
    path = default_path
    value = os.getenv(env_key, None)

    # set path to the logger file
    if value:
        path = value
    if os.path.exists(path):
        with open(path, 'rt') as f:
            config = yaml.safe_load(f.read())
        logging.config.dictConfig(config)
    else:
        logging.basicConfig(level=default_level)


class EDFConverter:
    '''
    A class for converting edf files with ieeg recording data, meta data and annotations into files easily readable by python.

    '''
    def __init__(self, edffile, logger=None):
        # initialize logger configuration for EDFConverter
        setup_logging()

        # create and initialize logger
        self.logger = logger or logging.getLogger(__name__)
        self.logger.info('Initialized EDFConverter object.')

        # check if the file is edf format!
        if not edffile.endswith('.edf'):
            self.logger.error('File is not in edf format: %s', edffile)

        self.edffile = edffile
        # self.logfile = logfile

    def edffilecheck(self, edffile, logger=None):
        numchans = edffile.signals_in_file
        samp_freq_old = edffile.getSampleFrequency(0)
        samples_old = edffile.getNSamples()[0]
        phys_dim_old = edffile.getPhysicalDimension(0)

        # do a check on the sampling freqs
        for i in range(1, numchans):
            samp_freq_new = edffile.getSampleFrequency(i)
            samples_new = edffile.getNSamples()[i]
            phys_dim_new = edffile.getPhysicalDimension(i)
            
            if phys_dim_old != phys_dim_new:
                logger.error('Physical dimension of records are not the same. Dimensions are: %s and %s', phys_dim_old, phys_dim_new)
            if samples_old != samples_new:
                logger.error('Not same samples in this recording. Number of samples are: %s and %s', samples_old, samples_new)
            if samp_freq_old != samp_freq_new:
                logger.error('Not same sampling freq. Sampling freqs are: %s and %s', samp_freq_old, samp_freq_new)


    def edfrawtocsv(self, outputdatafile, VERBOSE=False):
    # Function Header:
    # Name: edfrawtocsv
    # Date Created: July 16, 2017
    # Data Modified: August 8, 2017
    # 
    # Description: Converts imported EDF file into a .CSV file to be read in 
    # Microsoft Excel. The EDF file contains the raw data, meta data on the recording and the data on the recording channels.
    # 
    # Inputs: 
    # 1. edffile: input path of EDF file to convert
    # 2. outputdatafile: output path of EDF data 
    # 3. VERBOSE (optional): debug input and output files
    #
    # Outputs:
    # 1. CSV file of EDF data in outputData path

        # open input file if closed
        try:
            edffile = pyedflib.EdfReader(self.edffile)
        except Exception, e:
            logger.error('Failed to read edf file', exc_info=True)
            edffile._close()

        # perform basic error check on the file
        self.edffilecheck(edffile)

        # get the total number of channels in the file
        numchans = edffile.signals_in_file

        # create zero array the shape of num of signals per channel by num channels
        raweeg = np.zeros((edffile.getNSamples()[0], numchans))

        # read in each signal for each channel
        for iSig in np.arange(numchans):
            raweeg[:, iSig] = edffile.readSignal(iSig)

        # create dataframe from array of signals by channels and create csv
        raweeg_df = pd.DataFrame(data=raweeg, index=None)
        raweeg_df.to_csv(outputdatafile, index=False, header=False) 

        self.logger.info('Closing edf file! Raw data should be saved at %s', outputdatafile)
        # close the file
        edffile._close()

    def edfrawtonumpy(self, outputdatafile, VERBOSE=False):
    # Function Header:
    # Name: edfrawtocsv
    # Date Created: July 16, 2017
    # Data Modified: August 8, 2017
    # 
    # Description: Converts imported EDF file into a .CSV file to be read in 
    # Microsoft Excel. The EDF file contains the raw data, meta data on the recording and the data on the recording channels.
    # 
    # Inputs: 
    # 1. edffile: input path of EDF file to convert
    # 2. outputdatafile: output path of EDF data 
    # 3. VERBOSE (optional): debug input and output files
    #
    # Outputs:
    # 1. CSV file of EDF data in outputData path

        # open input file if closed
        try:
            edffile = pyedflib.EdfReader(self.edffile)
        except Exception, e:
            self.logger.error('Failed to read edf file', exc_info=True)

        # perform basic error check on the file
        self.edffilecheck(edffile)

        # get the total number of channels in the file
        numchans = edffile.signals_in_file

        # create zero array the shape of num of signals per channel by num channels
        raweeg = np.zeros((edffile.getNSamples()[0], numchans))

        # read in each signal for each channel
        for iSig in np.arange(numchans):
            raweeg[:, iSig] = edffile.readSignal(iSig)

        # open output Numpy file to write
        npfile = open(outputdatafile, 'w')
        np.save(npfile, raweeg)

        self.logger.info('Closing edf file! Raw data should be saved as numpy at %s', outputdatafile)
        # close the file
        edffile._close()

    def edfmetatocsv(self, outputheadersfile, outputchanfile, outputannotationsfile, VERBOSE=False):
    # Function Header:
    # Name: edfmetatocsv
    # Date Created: July 16, 2017
    # Data Modified: August 8, 2017
    # 
    # Description: Converts imported EDF file into a .CSV file to be read in 
    # Microsoft Excel. The EDF file contains the raw data, meta data on the recording and the data on the recording channels.
    # 
    # Inputs: 
    # 1. edffile: input path of EDF file to convert
    # 2. outputheadersfile: output path of EDF file headers
    # 3. outputchanfile: output path of EDF channel headers
    # 4. outputannotationsfile: output path for EDF annotations
    # 5. VERBOSE (optional): debug input and output files
    #
    # Outputs:
    # 1. CSV file of EDF file headers in outputFileHeaders path
    # 2. CSV file of EDF channel headers in outputChanHeaders path

        # open input file if closed
        try:
            edffile = pyedflib.EdfReader(self.edffile)
        except Exception, e:
            self.logger.error('Failed to read edf file', exc_info=True)
            edffile._close()

        self.edffilecheck(edffile)

        numchans = edffile.signals_in_file

        ######################### 1. Import file headers ########################
        # create list with dataframe column file header names
        fileheaders = [[
            'pyedfib Version',
            'Birth Date',
            'Gender', 
            'Start Date (D-M-Y)', 
            'Start Time (H-M-S)',
            'Patient Code', 
            'Equipment', 
            'Data Record Duration (s)',
            'Number of Data Records in File', 
            'Number of Annotations in File', 
            'Sample Frequency', 
            'Samples in File', 
            'Physical Dimension'
        ]]

        # append file header data for each dataframe column to list
        startdate = str(edffile.getStartdatetime().day) + '-' + str(edffile.getStartdatetime().month) + '-' + str(edffile.getStartdatetime().year)
        starttime = str(edffile.getStartdatetime().hour) + '-' + str(edffile.getStartdatetime().minute) + '-' + str(edffile.getStartdatetime().second)

        fileheaders.append([
            pyedflib.version.version, 
            edffile.birthdate,
            edffile.gender,
            startdate, 
            starttime, 
            edffile.getPatientCode(), 
            edffile.getEquipment(),
            edffile.getFileDuration(), 
            edffile.datarecords_in_file, 
            edffile.annotations_in_file, 
            edffile.getSampleFrequency(0), 
            edffile.getNSamples()[0],  
            edffile.getPhysicalDimension(0), 
        ])         

        ##################### 2. Import channel headers ########################
        # create list with dataframe column channel header names
        channelheaders = [[
            'Channel Number', 
            'Labels',
            'Physical Maximum',
            'Physical Minimum', 
            'Digital Maximum',
            'Digital Minimum'
        ]]

        # get the channel labels of file and convert to list of strings
        # -> also gets rid of excessive characters
        chanlabels = [str(x).replace('POL', '').replace(' ', '') for x in edffile.getSignalLabels()]

        # read chan header data from each chan for each column and append to list
        for i in range(numchans):
            channelheaders.append([
                i+1, 
                chanlabels[i],
                edffile.getPhysicalMaximum(i), 
                edffile.getPhysicalMinimum(i), 
                edffile.getDigitalMaximum(i), 
                edffile.getDigitalMinimum(i)
            ])         

        ##################### 3. Import File Annotations ########################
        # create list 
        annotationheaders = [[
            'Time (sec)',
            'Duration',
            'Description'
        ]]

        annotations = edffile.readAnnotations()
        for n in np.arange(edffile.annotations_in_file):
            annotationheaders.append([
                annotations[0][n],
                annotations[1][n],
                annotations[2][n]
            ])

        # create dataframes from array of meta data
        fileheaders_df = pd.DataFrame(data=fileheaders) 
        channelheaders_df = pd.DataFrame(data=channelheaders)
        annotationheaders_df = pd.DataFrame(data=annotationheaders)

        # create CSV file of file header names and data
        fileheaders_df.to_csv(outputheadersfile, index=False, header=False) 
        # create CSV file of channel header names and data
        channelheaders_df.to_csv(outputchanfile, index=False, header=False)
        # create CSV file of channel header names and data
        annotationheaders_df.to_csv(outputannotationsfile, index=False, header=False)

        # output logging statements
        self.logger.info('Closing edf file! Headers meta data should be saved as csv at %s', outputheadersfile)
        self.logger.info('Channel meta data should be saved as csv at %s', outputchanfile)
        self.logger.info('Annotations meta data should be saved as csv at %s', outputannotationsfile)

        edffile._close()