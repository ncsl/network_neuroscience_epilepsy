'''
Linearmodels.py
@By: Adam Li
@Date: 10/16/17

@Description: Class designed for holding the coherence models described
in the publication: 


@Methods:

'''

# Imports necessary for this function
import numpy as np
import math
from scipy.signal import filtfilt
from scipy.interpolate import interp1d
from scipy.integrate import cumtrapz

from eztrack.signalprocessing import *

import os
import logging.config
import yaml

class Model():
    def __init__(self, winsize, stepsize):
        self.winsize = winsize
        self.stepsize = stepsize

    def setup_logging(self, default_path='logging_linearmodels.yaml', default_level=logging.INFO, env_key='LOG_CFG'):
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

    def run_svd(self, adjmats):
        numwins = adjmats.shape[0]
        svdU = np.zeros((adjmats.shape), dtype='complex')

        for iwin in range(0, numwins):
            svdU[iwin, :, :] = self.svd_decomposition(adjmats[0,:,:].squeeze())

        return svdU

    def svd_decomposition(self, A):
        # get the shape of A
        numchans = A.shape[0]

        # perform SVD
        np.nan_to_num(A, copy=False)

        if np.sum(np.sum(np.abs(A))) > 0:
            U, _, _ = np.linalg.svd(A)
        else:
            U = np.eye(A.shape)

        return U

    def return_seizmarks(self, timepoints, onsetms, offsetms, samplerate=1000):
        onsetmark = np.where(timepoints[:,1] - onsetms * samplerate / 1000 >= 0)[0][0]
        offsetmark = np.where(timepoints[:,1] - offsetms * samplerate / 1000 >= 0)[0][0]
        return onsetmark, offsetmark
    def return_timepoints(self, numsignals, numwinsamps, numstepsamps):
        # create array of indices of window start times
        timestarts = np.arange(0, numsignals-numwinsamps+1, numstepsamps, dtype=np.int32)
        # create array of indices of window end times
        timeends = np.arange(numwinsamps-1, numsignals, numstepsamps, dtype=np.int32)
        # create the timepoints array for entire data array
        timepoints = np.append(timestarts.reshape(len(timestarts), 1), timeends.reshape(len(timestarts), 1), axis=1)

        return timepoints

    def vector_to_matrix(self, vector, numchans):
        # reorganize vector into the 2D array
        A = np.diag(vector[0:numchans])

        # go through and fill the non-diagonals
        pointer = numchans
        for i in range(0, numchans-1):
            A[i, i+1:numchans] = vector[pointer:pointer+numchans-i-1]
            A[i+1:numchans, i] = A[i, i+1:numchans]

            # update pointer to next point along vector
            pointer = pointer+numchans-i-1

        return A

class CoherenceModel(Model):
    def __init__(self, winsize=2.5, stepsize=1., recordduration=100, samplerate=1000, freqbands='all', logger=None, default_path='logging_mvarmodels.yaml'):
        # super(MVARModel, self).__init__(winsize, stepsize)
        Model.__init__(self, winsize, stepsize)

        # initialize logger configuration for Linear Model
        if not logger:
            self.setup_logging(default_path=default_path)

        # create and initialize logger
        self.logger = logger or logging.getLogger(__name__)
        self.logger.info('Initialized Coherence model!')

        # initialize frequency bands to use
        if freqbands == 'all':
            self.freqbands = [
                        np.arange(0, 5), # Delta
                        np.arange(4, 9), # Theta
                        np.arange(8, 14), # Alpha
                        np.arange(13, 31), # Beta
                        np.arange(30, 91) # Gamma
                    ]
        else:
            self.freqbands = dict(
                        delta=np.arange(0, 5), # Delta
                        theta=np.arange(4, 9), # Theta
                        alpha=np.arange(8, 14), # Alpha
                        beta=np.arange(13, 31), # Beta
                        gamma=np.arange(30, 91) # Gamma
                    )
            self.freqbands = self.freqbands[freqbands]
        self.samplerate = int(samplerate)
        self.recordduration = recordduration

    def run_model(self, raweeg, window=0, numwins=None):
        # get size of window of data to analyze
        numchans, numsamps = raweeg.shape

        # number of samples to analyze per window
        nsamples = int(np.round(self.winsize * self.samplerate))

        # set the window function for the periodograms
        # Sabatino chose these parameters in his research based on periodigrams and a modified FFT.
        freqlist = np.arange(1, self.samplerate+1)
        convwin = 0.54 - 0.46 * np.cos((2*np.pi*freqlist) / (self.samplerate-1))

        # set the pointer to the last byte before the one to be accessed now
        lastwindow = 0;
        limit = np.fix((self.recordduration - (nsamples - self.stepsize*self.samplerate)) /\
                     (self.stepsize*self.samplerate));


        # step 0: check if the current pointer is the offset or not. If it is
        #         the offset then the transient response induced by the notch 
        #         filter cannot be attenuated. Otherwise, extract max 400 extra
        #         samples of data before the required samples
        if lastwindow != 0:
            tmpwindow = 400
            if self.samplerate == 250:
                tmpwidndow = 200
        else:
            tmpwindow = 0

        # get array of time points for the windows in samples. To convert to seconds -> divide by samplerate
        winsamps = self.winsize * self.samplerate
        stepsamps = self.stepsize * self.samplerate
        timepoints = self.return_timepoints(numsamps, winsamps, stepsamps)

        if not numwins:
            numwins = timepoints.shape[0]

        timepoints = timepoints[0:numwins, :]

        self.logger.info('Evaluating cross power for %s windows', numwins)        
        self.logger.info('Evaluating cross power in %s %s frequency band', self.freqbands[0], self.freqbands[-1])        
        
        # loop through each window and compute coherence model
        A = np.zeros((numwins, numchans, numchans), dtype='complex')
        for iwin in range(0, numwins):
            power = self.computecoherencemodel(raweeg, timepoints, convwin, iwin)
            A[iwin, :, :] = self.vector_to_matrix(power, numchans)

        self.logger.info('Finished cross power in %s %s frequency band', self.freqbands[0], self.freqbands[-1])        

        return A, timepoints

    def computecoherencemodel(self, raweeg, timepoints, convwin, iwin):
        # set the range of frequencies for the periodograms (Hz)
        freqrange = (self.samplerate/2) * np.linspace(0,1,self.samplerate/2);
        freqstoanalyze = self.freqbands

        # set the step size for the sub-sections (number of samples)
        freqstepsize = round(self.samplerate/4)

        self.logger.info('Computing cross power for %s window!', iwin)

        # step 1: extract the data and apply the notch filter. Note that column
        #         #i in the extracted matrix is filled by data samples from the
        #         recording channel #i.
        # get the data depending on if it's the last window or not
        data = raweeg[:, timepoints[iwin, 0] : timepoints[iwin, 1]+1]

        # apply the notch filter to this window of data
        # data = notchfilt(tmpdata, self.samplerate)

        # step 2: pre-process the data by normalize each window. For each channel, subtract the mean
        #         value and divide by the standard deviation. Note that this
        #         step NORMALIZES the data
        chanavge = np.mean(data, axis=1)
        chanstd = np.std(data, axis=1)

        # perform actual z transform normalization
        normdata = data - chanavge[:, None]
        normdata = normdata / chanstd[:, None]
        np.nan_to_num(data, copy=False);

        # step 3: split the data into overlapping sub-sections
        nsections = np.ceil((normdata.shape[1] - \
            (self.samplerate-freqstepsize))/freqstepsize);

        # step 4: compute the cross-power spectra
        cross_power = self.computecrosspower(normdata, nsections, freqstepsize, convwin)

        # Step 5: Evaluate the cumulative power in freq band and save it
        # only get the cross_power within the frequency range
        freq_cross_power = cross_power[:, np.where((freqrange >= freqstoanalyze[0]) &\
                                            (freqrange < freqstoanalyze[-1]))[0]]
        power = np.sum(freq_cross_power, axis=1, dtype='complex')

        # save power computed in vectorized form, since power is symmetric, stores C*(C+1)/2
        return power

    def computecrosspower(self, windoweddata, nsections, freqstepsize, convwin):
        numchans, numsamps = windoweddata.shape

        # initialize array of cross power, which will store the triangle of cross_power and the diagonal
        cross_power = np.zeros((numchans*(numchans+1)/2, int(self.samplerate)/2))

        # loop through each section
        for i in np.arange(0, nsections):
            # extract the current sub-section
            datasec = windoweddata[:, int(i*freqstepsize) : int(min( i*freqstepsize + self.samplerate, windoweddata.shape[1]))]
    
            if (np.sum(np.sum(np.abs(datasec))) == 0):
                self.logging.info('All data in computecrosspower are zeros!')
                # avoid computation if the data are all zeros
                continue;
           
            # compute the fft. Note: size(X) = (fs/2) x #-of-channels
            convwinbuff = convwin[ 0: min(self.samplerate, datasec.shape[1])]
            temp = np.matlib.repmat(convwinbuff, numchans, 1)
            dataset = np.multiply(temp, datasec)

            # get the FT
            X = np.fft.fft(dataset, self.samplerate); 
            X = X[:, 0:self.samplerate/2];

            # set temporary matrices for the computation of the cross-power spectra
            Y = np.zeros((numchans * (numchans-1)/2, self.samplerate/2), dtype='complex')
            Z = np.zeros((numchans * (numchans-1)/2, self.samplerate/2), dtype='complex')
            pointer = 0

            for j in np.arange(0,numchans-1):
                Y[pointer:pointer+numchans-j-1,:] = X[j+1:numchans,:];
                Z[pointer:pointer+numchans-j-1,:] = np.matlib.repmat(X[j,:],numchans-j-1,1)

                pointer = pointer+numchans-j-1

            # set up the computation for cross power
            conjX = np.conj(X)
            conjY = np.conj(Y)
            XconjX = np.multiply(X, np.conj(X))
            ZconjY = np.multiply(Z, np.conj(Y))

            cross_power = cross_power + np.concatenate((XconjX, np.absolute(ZconjY)), axis=0)

        cross_power = cross_power / nsections

        return cross_power

class PCAModel(Model):
    def __init__(self, winsize=2.5, stepsize=1., samplerate=1000, freqbands='all', logger=None, default_path='logging_mvarmodels.yaml'):
        # super(MVARModel, self).__init__(winsize, stepsize)
        Model.__init__(self, winsize, stepsize)

        # initialize logger configuration for Linear Model
        if not logger:
            self.setup_logging(default_path=default_path)

        # create and initialize logger
        self.samplerate = samplerate
        self.logger = logger or logging.getLogger(__name__)
        self.logger.info('Initialized PCAmodel!')

    def run_pca(self, evcmat):
         # rank the EVC
        rankedevcmat = self.rank_centrality(evcmat)

        numpyfile = os.path.join(datadir, 'numpy', patient) + '/' + patient+'_rawnpy.npy'
        # load raw data
        rawdata = patieeg.loadrawdata(numpyfile)
        rawdata = rawdata[included_indices,:]
        _, numsamps = rawdata.shape
        winsamps = self.winsize * self.samplerate
        stepsamps = self.stepsize * self.samplerate
        timepoints = self.return_timepoints(numsamps, winsamps, stepsamps)


        onsetms = int(patieeg.onset_time.values[0]*patieeg.samplefreq.values)
        offsetms = int(patieeg.offset_time.values[0]*patieeg.samplefreq.values)
        seizonmark, seizoffmark = self.return_seizmarks(timepoints, onsetms, offsetms, patieeg.samplefreq.values)

        # normalize in time the seizure time
        pre_rankedevcmat = rankedevcmat[:, 0:seizonmark]
        post_rankedevcmat = rankedevcmat[:, seizoffmark:]
        seiz_rankedevcmat = rankedevcmat[:, seizonmark:seizoffmark]
        seiz_rankedevcmat = self.normalize_time(seiz_rankedevcmat, maxduration=500)

        rankedvcmat = np.concatenate((pre_rankedevcmat, seiz_rankedevcmat, post_rankedevcmat), axis=1)
        
        # # normalize in channels
        rankedevcmat = self.normalize_chans(rankedevcmat)

        # normalize area, so each row of ranked centrality integrates to 1
        area_mat = self.normalize_area(rankedevcmat)

        # return the final rankedEVC that is normalized in time, channels and integrates to 1
        return area_mat

    def rank_centrality(self, evcmat):
        '''
        For a CxT EVC matrix, rank each column, so that instead of floats, there are
        a set of numbers {1,...C} for each column.
        '''
        # get dimensions of data
        numchans, numwins = evcmat.shape

        # convert eigenvector centrality to rank centrality. first get indices
        sortedind = np.argsort(-evcmat, axis=0) # sort along columns in ascend

        # ranked centrality is the ascending sort from 1 to N
        rankevcmat = sortedind+1 

        return rankevcmat

    def create_cdfint(self, numchans, area):
        '''
        
        '''
        # create a linearly spaced cumulative distribution function
        cdf = np.arange(0.1, 1, 0.1)

        # create discrete intervals that channels are matched to
        intervals = np.zeros((numchans, len(cdf)))
        for i in range(0, numchans):
            for j in range(0, len(cdf)):
                intervals[i,j] = np.where(area[i,:] <= cdf[j])[0][-1]

        return intervals

    def normalize_area(self, rankedevcmat):
        '''
        Normalize all rows, so that they integrate to 1
        '''
        integration = cumtrapz(rankedevcmat, axis=1)

        # get the cumulative integration for each row/channel
        cumint = integration[:, -1]

        for i in range(0, rankedevcmat.shape[0]):
            integration[i, :] = integration[i, :] / cumint[i]

        return integration

    def normalize_time(self, rankedevcmat, maxduration=500):
        '''
        For the ranked EVC matrix (C x W) channels x windows, normalize all signals, 
        so that there are even number of windows in the seizure event (500 seconds)

        Only call with normalize_time(rankedevcmat[:, onset:offset])
        '''
        # get length of each steps in seconds
        stepsize = self.stepsize

        # get dimensions of rankedevcmat
        numchans, numwins = rankedevcmat.shape

        # compare length of rankedevcmat vs maxduration it can have 
        maxwins = maxduration / stepsize
        if numwins != maxwins:
            interval = np.linspace(0, numwins-1, maxwins)

            # create interpolation instance
            interp_mat = interp1d(np.arange(0, numwins), rankedevcmat, kind='linear')
            norm_rankcent = interp_mat(interval)

        return norm_rankcent

    def normalize_chans(self, rankedevcmat):
        '''
        For the ranked EVC matrix (C x W) channels x windows, normalize each channel
        Each signal will be divided by the total number of channels
        '''
        numchans, _ = rankedevcmat.shape
        rankedevcmat = rankedevcmat / numchans

        return rankedevcmat
