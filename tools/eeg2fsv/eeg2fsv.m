% Inputs ----------------------------------------------------------------------

fs = 1000;
pos = 0;

home = getenv('HOME');
eegHome = '/dev/eztrack/tools/output/eeg/';
patient = 'PY12N008';
patientFile = 'PY12N008_07_21_2012_14-05-48_640sec';
pathval = [home eegHome patient];

% nChannels depends on the patient - this will need to be an input parameter: 
% length(channels)?
% some of the hard-coded channels don't match this in the original impl.

% There are reference channels that are removed later in the process.
% Some channels are also removed from the analysis if they are consistently 
% noisy or don't change during a seizure.
% TODO: Try leaving in all channels to compare the results.

% NB: Cleveland is more complicated because some channels are in white matter,
% and should be excluded.
nChannels = 89;

%------------------------------------------------------------------------------
% 1. Compute Adjacency matrix sequence
power_coherence(pathval, patientFile, nChannels, fs, pos)

%               - matrices are stored into 1-D arrays
%------------------------------------------------------------------------------

% 2. Compute ranked-Eigenvector Centrality (rEVC) sequence
% TODO: If we're going to filter channels, this fn takes a parameter to do so.
svd_decomposition([pathval '/adj_pwr'], patientFile, nChannels)
svdVectorPath = sprintf('%s%s%s/adj_pwr/svd_vectors', home, eegHome, patient);
svdVectorFile = 'svd_l_pwr_PY12N008_07_21_2012_14-05-48_640sec_gamma.dat';
extraction_vectors(svdVectorPath, svdVectorFile, nChannels)

% Quick test: Check that all signs are the same in each column
% There are also cases of extremely small values that should be zero.

%------------------------------------------------------------------------------