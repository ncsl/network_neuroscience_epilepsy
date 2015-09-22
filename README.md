# EZTrack

EZTrack produces electrode weights and heatmap scores from EEG signals in EDF or MEF files.


## Running

Check the `makefile` for available targets to run EZTrack in development mode.


## Structure

The code is organized as a data processing toolchain:

## data

Sourced input data to EZTrack.

• raw EDF files

• (temporarily) patient_info.mat - a database of patient information including seizure start and end marks
  and other patient metadata.


## edf2eeg

### Input

Raw EDF data files.

`data/edf/<patient id>`

### Output

A .mat file containing a struct of EEG events in a format compatible with subsequent EZTrack processing steps.

Example: `output/eeg/PY12N008/PY12N008_07_23_2012_08-41-30_729sec.mat`


## eeg2fsv

### Input

.mat files from edf2eeg

### Output

FSV: First singular values of each seizure event for each patient.

Example: `output/eeg/PY12N008/adj_pwr/svd_vectors/fsv_pwrPY12N008.mat`


## fsv2heatmap

Run with fsv2heatmap in Matlab command window or with `make temporal` to run against known
temporal lobe patients.

### Input

output from eeg2fsv

### Output

.mat and .csv files containing electrode labels, weights, and heat map color codes.

Example: `output/heatmap/iEEG_temporal_CV_results_04-Sep-2015.mat`




