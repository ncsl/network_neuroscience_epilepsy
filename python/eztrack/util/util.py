# Imports necessary for this function 
import numpy as np 
import pandas as pd 
import math

import csv
import h5py
import os
import logging.config
import yaml
import re

from eztrack.signalprocessing import buttfilt

def splitpatient(patient):
    stringtest = patient.find('seiz')

    if stringtest == -1:
        stringtest = patient.find('sz')
    if stringtest == -1:
        stringtest = patient.find('aw')
    if stringtest == -1:
        stringtest = patient.find('aslp')
    if stringtest == -1:
        stringtest = patient.find('_')
    if stringtest == -1:
        print "Not sz, seiz, aslp, or aw! Please add additional naming possibilities, or tell data gatherers to rename datasets."
    else:
        pat_id = patient[0:stringtest]
        seiz_id = patient[stringtest:]

        # remove any underscores
        pat_id = re.sub('_', '', pat_id)
        seiz_id = re.sub('_', '', seiz_id)
    return pat_id, seiz_id

def returnindices(pat_id, seiz_id):
    included_indices = None

    if pat_id == 'pt1':
        included_indices = np.concatenate((np.arange(0,36), np.arange(41,43), np.arange(45,69), np.arange(71,95)))
    elif pat_id == 'pt2':
        included_indices = np.concatenate((np.arange(0,36), np.arange(41,43), np.arange(45,69), np.arange(71,95)))
    elif pat_id == 'pt3':
        included_indices = np.concatenate((np.arange(0,36), np.arange(41,43), np.arange(45,69), np.arange(71,95)))

    return included_indices  

class Container:
    def __init__(self, data, **kwargs):
        self.data = data
        self.metadata = kwargs

def loadarray(filename):
    with h5py.File(filename, 'r') as infile:
        dataset = infile['data']
        arraydata = dataset[...] # get the numpy array

        metadata = dict()
        for attr in dataset.attrs:
            metadata[attr] = dataset.attrs[attr]
        
        container = Container(arraydata, **metadata)
        return container
def savearray(array, filename, **kwargs):
    container = Container(array, **kwargs)
    
    # open file for writing
    with h5py.File(filename, 'w') as outfile:
        dataset = outfile.create_dataset('data', data=container.data)

        # set attributes
        for key in container.metadata.keys():
            dataset.attrs[key] = container.metadata[key]

class PatientIEEG:
    '''
    A class describing a dataset that is within our framework. This object will help set up the
    data for computation and any meta data necessary to link the computations together.

    This creates also the logger for running any computations on the dataset.

    Elements:
    - p_id: the patient identifier (can be pt1, or say pt1sz2)
    '''

    def __init__(self, patient, clinoutcome=None, engelscore=None, logfile='logging_models.yaml'):
        self.patient = patient
        self.clinoutcome = clinoutcome
        self.engelscore = engelscore

        # initialize logger configuration for EDFConverter
        self.setup_logging(logfile)

        # create and initialize logger
        self.logger = logging.getLogger(__name__)
        self.logger.info('Initialized Patient IEEG object. Should run channels, metadata and annotations next!')

        # try:
        #     self.setchannels
        # except Exception as e:
        #     raise
        # else:
        #     pass
        # finally:
        #     pass

    def setup_logging(self, default_path='logging_models.yaml', default_level=logging.INFO, env_key='LOG_CFG'):
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

    def setchannels(self, channelsfile, includedchans=None):
        # read in the csv file into pandas
        chanheaders = pd.read_csv(channelsfile)

        # read in labels
        chanlabels = chanheaders['Labels']

        self.chanlabels = chanlabels
        if not includedchans:
            self.includedchans = np.arange(0,len(chanlabels))
        else:
            self.includedchans = includedchans
        self.logger.info('Ran setup of channels data!')

    def setmetadata(self, headersfile):
        # read in the file headers into pandas
        fileheaders = pd.read_csv(headersfile)
        
        # get important meta data (ADD ELEMENTS HERE TO ADD TO CLASS)
        birthdate = fileheaders['Birth Date']
        daterecording = fileheaders['Start Date (D-M-Y)']
        gender = fileheaders['Gender']
        equipment = fileheaders['Equipment']
        samplefreq = fileheaders['Sample Frequency']
        recordduration = fileheaders['Data Record Duration (s)']
        
        # set metadata members of this class
        self.birthdate = birthdate
        self.daterecording = daterecording
        self.gender = gender
        self.equipment = equipment
        self.samplefreq = samplefreq
        self.recordduration = recordduration
        self.logger.info('Ran setup of meta data!')
        
    def setannotations(self, annotationsfile):
        # read in the clinical annotations into pandas
        annotations = pd.read_csv(annotationsfile)
        
        # read in the onset if available
        onset_rows = annotations[annotations.values == 'onset']
        onset_time = onset_rows['Time (sec)']

        # read in the offset if available
        offset_rows = annotations[annotations.values == 'offset']
        offset_time = offset_rows['Time (sec)']
        
        # set onset/offset times and markers
        self.onset_time = onset_time
        self.offset_time = offset_time
        self.logger.info('Ran setup of annotations data!')

    def loadrawdata(self, rawdatafile, reference=None):
        # load numpy array data
        rawdata = np.load(rawdatafile)

        # if signals by channels -> transpose
        if rawdata.shape[0] > rawdata.shape[1]:
            rawdata = rawdata.T

        # perform average referencing
        if reference == 'avg':
            # average over each row
            avg = np.mean(rawdata, axis=1, keepdims=True)
            rawdata = rawdata - avg

        self.logger.info('Loaded raw data!')

        return rawdata

    def filterrawdata(self, raweeg, filttype='notch'):
        ######################### FILTERING ################################
        samplerate = self.samplefreq.values
        # perform notch filtering at 60 Hz and its harmonics
        freqrange = np.array((59.5, 60.5))
        if filttype == 'notch':
            raweeg, filters = buttfilt(raweeg, freqrange, samplerate, 'stop', 1)
            raweeg, _ = buttfilt(raweeg, freqrange*2, samplerate, 'stop', 1)
            if samplerate >= 250:
                raweeg, _ = buttfilt(raweeg, freqrange*3, samplerate, 'stop', 1)
                raweeg, _ = buttfilt(raweeg, freqrange*4, samplerate, 'stop', 1)
                if samplerate >= 500:
                    raweeg, _ = buttfilt(raweeg, freqrange*5, samplerate, 'stop', 1)
                    raweeg, _ = buttfilt(raweeg, freqrange*6, samplerate, 'stop', 1)
                    raweeg, _ = buttfilt(raweeg, freqrange*7, samplerate, 'stop', 1)
                    raweeg, _ = buttfilt(raweeg, freqrange*8, samplerate, 'stop', 1)
        else:
            self.logger.info('No filtering has been implemented yet!')

        self.logger.info('Finished filtering with %s filter', filttype)

        return raweeg
