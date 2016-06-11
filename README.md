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

## NIH

### Data Preparation

*Download the EDF files from the NIH Secure File Transfer and save in `data/edf`.*


*Run edf2eeg.sh to extract signals and channels from the EDF files:* `./edf2eeg.sh pt1sz2`

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

included_channels: indexes of the channels to include in the heatmap in MATLAB vector notation. Use [EDFbrowser](www.teuniz.net/edfbrowser/) to verify which signals to include. Channels to filter out include DC, grounds, channels with missing labels, or channels with noise.

NIH files are in EDF+D vs. EDF+C. Use "Tools->Convert EDF+D to EDF+C" in EDFbrowser to open the files.


### Create the Heatmap

Run `./nih-main pt1sz2`

Output will be saved to `output/heatmap/pt1sz2_iEEG_temporal_results_<date>.csv`




## Deploying EZTrack Code Changes to the ICM Server

Open Junos Pulse and sign in to the VPN using your JHED ID. If you need to setup your VPN for the first time, visit http://my.jh.edu and https://portalcontent.johnshopkins.edu/JHPulse/faq.html .

`make deploy-prod`


### Connecting to Hopkins - Hopkins SSH / sFTP

ssh <user>@128.220.76.216 -p 5527

sftp -oPort=5527 <user>@128.220.76.216


### MEF File Server

• MEF file server is mounted at /mnt/smb.

• Test files on local Hackerman eztrack system are in /mnt/disk01/tmp/

• Host operating system
    cat /etc/redhat-release
        CentOS Linux release 7.2.1511 (Core)

    uname -a
        Linux eztrack01 3.10.0-229.20.1.el7.x86_64 #1 SMP Tue Nov 3 19:10:07 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

    rpm -q --whatprovides /etc/redhat-release
        centos-release-7-2.1511.el7.centos.2.10.x86_64

