from scipy.signal import butter, filtfilt
import numpy as np

def buttfilt(raw_data, freqrange, samplerate, filttype='stop', order=4):
# Butterworth filter wrapper function with zero phase distortion.
# FUNCTION:
#   y = buttfilt(dat,freqrange,samplerate,filttype,order)
#
# INPUT ARGS: (defaults shown):
#   raw_data = dat;           % data to be filtered (if data is a matrix, BUTTFILT filters across rows)
#   freqrange = [58 62];      % filter range (depends on type)
#   samplerate = 256;         % sampling frequency
#   filttype = 'stop';        % type of filter ('bandpass','low','high','stop') 
#   order = 4;                % order of the butterworth filter
#   filters = {B,A};          % a set of filters to use on data (created by a previous buttfilt call)

# OUTPUT ARGS::
#   data = the filtered data

    # the Nyquist frequency
    nyq = samplerate/2 
    
    # create a butterworth filter with specified order, freqs, type
    a, b = butter(order, freqrange/nyq, filttype)
    filters = np.array((a,b))
    
    # run filtfilt for zero phase distortion
    data = filtfilt(a, b, raw_data)
    
    return data, filters

def notchfilt(raweeg, samplerate):
    # notch filter (stop frequency: 60Hz; stop-band: 4Hz)
    # represented by a transfer function: polynomial / polynomial
    # continuous second-order equations, in this case.
    if samplerate == 1000:
        # sampling frequency: 1000Hz). Note that the filter induces a transient
        # oscillation of about 400 samples which must be removed from the data
        dennotch = [1, -1.847737249430546, 0.987291867964730]
        numnotch = [0.993645933982365, -1.847737249430546, 0.993645933982365]

        raweeg = filtfilt(numnotch,dennotch,raweeg)
    elif samplerate == 200:
        # sampling frequency: 200Hz). Note that the filter induces a
        # transient oscillation of about 100 samples which must be removed
        dennotch = [1, 0.598862049930572, 0.937958302720205]
        numnotch = [0.968979151360102, 0.598862049930572, 0.968979151360103]

        raweeg = filtfilt(numnotch,dennotch,raweeg.T)
        raweeg = raweeg.T
    else:
        print('Not using original notch filter')

        raweeg = buttfilt(raweeg, np.array((59.5, 60.5)), samplerate,'stop',1)

    return raweeg