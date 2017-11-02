# EZTrack

EZTrack produces electrode weights and heatmap scores from EEG signals in EDF or MEF files.

## Python 2.7 Code Run 
### Date: 11/2/2017
### Author: Adam Li
I provide an untested (although individual parts are tested) version of code for the paper in Python 2.7. This is a much more object oriented approach to the code provided in the paper as everything is segmented into its individual parts.

The following modules are provided:
### 1. Data Conversion
I define a class EDFConverter, which will read in EDF files (if they are incorrectly formatted, try converting EDF+D -> EDF+C within edfbrowser). It has capabability to then process the data into individual files that store different parts of the data:

i) rawdata: stored in a .npy file, which is the CxT channels time series data
ii) channels data: stored in a .csv file that stores information about the channels, and each channel label
iii) annotations data: stored in a .csv file that stores annotations on the edf file for this recording segment. Can include onset/offset times if there is a seizure present.
iv) headers data: stores in a .csv file for any other meta data within the edf file. For example, birth date, gender, equipment, sampling rate, etc. can be stored here.

### 2. Signal Processing
I define some useful functions for filtering the data. Here I write two functions for notch filtering. The main one I use in my research is the butterworth filter of order 1. This can be adapted to add more filtering functions.

### 3. Models
This is the meat of the entire paper. It contains the models used.

Currently, these are the models within this section:
i) powercoherence: this module defines a parent class 'Model', which provides some basic functions and members for the other classes to use. Then the PowerCoherenceModel is used to provide the user interfacing with the rawdata and computation of the coherence model for certain frequency bands (default is 'gamma'). It computes the crosspower and defines the coherence of each window/step size provided, and then computes and saves the SVD left eigenvector matrix. The EVCModel is used to compute the ranked EVC and perform various normalizations. 

Afterwards, the EVCModel can be decomposed using PCA.

ii) gaussianmodels: this module defines the gaussian weighting function used to analyze and estimate 'EZ' likelihood from PCA analysis of the ranked EVC. It defines a GaussianWeightModel to interface and define the gaussian weighting function. It also defines a TrainingModel to perform Leave-One-Out training on a set of patients, and their rankedEVC computations to define the (x,y) coordinates of the origin of the Gaussian weighting function in PCA space. 

### 4. Utility 
This defines a module to interface with the datasets and metadata provided through DataConversion. Various useful functions are to extract data and umbrella all the relevant data under 1 object.

## Possible Extensions:
Some possible extensions for this work include looking at other frequency bands, moving into 3D PCA space, or defining a different Gaussian weighting function.

This work can be compared with other linear models.

-------------------------------------------------------------------------------

## Usage (By: Adam Li)
### Extract Signals From EDF Files
Given EDF files from the 4 different centers in this study (Cleveland Clinic, NIH, Johns Hopkins Hospital, University of Maryland Medical Clinic), you will save them in `data/edf` directory.

1. Run edf2eeg.sh to extract the signals and channels from the EDF files.
For UMMC files: `./edf2eeg.sh pt1sz2 rest`
For all else, use `butlast`

This will create `output/eeg/pt1sz2/pt1sz2_eeg.csv` and `output/eeg/pt1sz2/pt1sz2_labels.csv`.

```
patient_id,date,recording_start,onset_time,offset_time,recording_duration,num_channels,included_channels
pt1sz2,4/19/16,19:35:19,19:36:44,19:38:01,269,98,[1:36 42 43 46:54 56:69 72:95]
```

The fields have the following meaning:

patient_id: matches the file name

date: recording start date in m/dd/yy format. Viewable in EDFbrowser.

recording_start: recording start time in hh:mm:ss format. Viewable in EDFbrowser.

onset_time: clinical onset time in hh:mm:ss format. Provided by clinician.

offset_time: clinical offset time in hh:mm:ss format. Provided by clinician.

recording_duration: the length of the file in seconds. Viewable in EDFbrowser.

num_channels: total number of channels contained in the file. Provided by the length of `output/eeg/pt1sz2/pt1sz2_labels.csv`.

included_channels: indexes of the channels to include in the heatmap in MATLAB vector notation. Use [EDFbrowser](www.teuniz.net/edfbrowser/) to verify which signals to include. Channels to filter out include DC, grounds, channels with missing labels, or channels with noise. "Amplitude -> Fit to Pane" and "Timescale -> 10s/page" are useful settings when viewing channels.

NIH files are in EDF+D vs. EDF+C. Use "Tools->Convert EDF+D to EDF+C" in EDFbrowser to open the files.

### Create the Heatmap
Run `./eztrack-main pt1sz2`

Output will be saved to `output/heatmap/pt1sz2_iEEG_temporal_results_<date>.csv`

Make sure `iEEG_temporal_CV_results...csv` file is in `output/heatmap` directory. This is the data that was used to generate the PCA space that all other datasets were compared on.

### Analysis of Results
In directory `Paper Code`, there will be code to reproduce and statistically analyze the computed results.


-------------------------------------------------------------------------------

## Usage (Bobby)

### Extract Signals

Download the EDF files and save in `data/edf`.

Run edf2eeg.sh to extract signals and channels from the EDF files.

For NIH files: `./edf2eeg.sh pt1sz2 butlast`

For UMMC files: `./edf2eeg.sh pt1sz2 rest`

The `butlast` argument means to extract all but the last channel of the signals...in the EDF+ file format used by NIH, the last channel contains annotations. The script can also take the argument `rest` to handle EDF formats in which the first channel contains annotations, so only the rest of the channels after the first should be retained.

This will create `output/eeg/pt1sz2/pt1sz2_eeg.csv` and `output/eeg/pt1sz2/pt1sz2_labels.csv`.

Copy `output/eeg/pt1sz2/pt1sz2_labels.csv` to `data/patients/pt1sz2_channels.csv`. Edit the file to remove any channel labels that aren't in the `included_channels` filter in `data/patients/pt1sz2.csv`.


*Create patient input files to match the EZTrack spec and save in data/patients.* For example, data/patients/pt1sz2.csv contains the following columns:

```
patient_id,date,recording_start,onset_time,offset_time,recording_duration,num_channels,included_channels
pt1sz2,4/19/16,19:35:19,19:36:44,19:38:01,269,98,[1:36 42 43 46:54 56:69 72:95]
```

The fields have the following meaning:

patient_id: matches the file name

date: recording start date in m/dd/yy format. Viewable in EDFbrowser.

recording_start: recording start time in hh:mm:ss format. Viewable in EDFbrowser.

onset_time: clinical onset time in hh:mm:ss format. Provided by clinician.

offset_time: clinical offset time in hh:mm:ss format. Provided by clinician.

recording_duration: the length of the file in seconds. Viewable in EDFbrowser.

num_channels: total number of channels contained in the file. Provided by the length of `output/eeg/pt1sz2/pt1sz2_labels.csv`.

included_channels: indexes of the channels to include in the heatmap in MATLAB vector notation. Use [EDFbrowser](www.teuniz.net/edfbrowser/) to verify which signals to include. Channels to filter out include DC, grounds, channels with missing labels, or channels with noise. "Amplitude -> Fit to Pane" and "Timescale -> 10s/page" are useful settings when viewing channels.

NIH files are in EDF+D vs. EDF+C. Use "Tools->Convert EDF+D to EDF+C" in EDFbrowser to open the files.


### Create the Heatmap

Run `./eztrack-main pt1sz2`

Output will be saved to `output/heatmap/pt1sz2_iEEG_temporal_results_<date>.csv`



## Development Guide

### Clone the repository

```
git clone git@github.com:testedminds/eztrack.git
cd eztrack
```

### Access the Server

* Log in to http://my.jh.edu to ensure your JHED ID and password are correct.

* Set up Google Authenticator to get access to the server. Ask Kyle for an access code, download Google Authenticator, then create a new entry in the app using that code. You will now have a six-digit verification code that will refresh every minute.

* Run `make ssh`. Enter your Google Authenticator code for the Verification Code and use your JHED password for Password.


### Change the Code

`source .env`

`make check-deps`

If this step succeeds, you are ready to run the tests.

### Handling "MATLAB not found" errors

The path to matlab is stored in a variable called `matlab_exe`.

If the default path doesn't match your path, you can override it.
Replace the path below with the path to your matlab executable:

`make -e matlab_exe=/Applications/MATLAB_R2014b.app/bin/matlab check-deps`

## Testing

After making changes to the code, run the tests to ensure things are still working:

`make test`

Don't forget to source the .env file if you close your terminal: This file sets
some environment variables that are used by the rest of the build scripts.


## Deploying EZTrack Code Changes to the ICM Server

`make deploy-prod`


### Connecting to Hopkins - Hopkins SSH / sFTP

ssh <user>@128.220.76.216 -p 5527

sftp -oPort=5527 <user>@128.220.76.216


### Christophe Jouny's MEF File Server

• MEF file server is mounted at /mnt/smb.

• Test files on local Hackerman eztrack system are in /mnt/disk01/tmp/

• Host operating system
    cat /etc/redhat-release
        CentOS Linux release 7.2.1511 (Core)

    uname -a
        Linux eztrack01 3.10.0-229.20.1.el7.x86_64 #1 SMP Tue Nov 3 19:10:07 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

    rpm -q --whatprovides /etc/redhat-release
        centos-release-7-2.1511.el7.centos.2.10.x86_64
