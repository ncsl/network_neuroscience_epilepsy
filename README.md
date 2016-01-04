# EZTrack

EZTrack produces electrode weights and heatmap scores from EEG signals in EDF or MEF files.

## Getting Started

`source .env`

`make check-deps`

If this step succeeds, you are ready to run the tests.

### MATLAB not found

The path to matlab is stored in a variable called `matlab_exe`.

If the default path doesn't match your path, you can override it.
Replace the path below with the path to your matlab executable:

`make -e matlab_exe=/Applications/MATLAB_R2014b.app/bin/matlab check-deps`

## Development

After making changes to the code, run the tests to ensure things are still working:

`make test`

Don't forget to source the .env file if you close your terminal: This file sets
some environment variables that are used by the rest of the build scripts.

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
