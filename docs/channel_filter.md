# Channel Filter Development

Recall that the original edf files were deleted when they were processed to extract the eeg values and channel labels to .mat workspace files.
As such, we have five sets of .mat files for patients that were included in the Hopkins retrospective study:

    PY12N005
    PY12N008
    PY13N003
    PY13N011
    PY14N004

The attached Excel doc contains the breakdown of the included and excluded channels for these patients.
The 'channels from raw data' worksheet contains the list of all channel labels in the .mat files.
The 'heatmap-8-28' worksheet contains the reference retrospective study heatmap that I've been using to validate the system. If a channel
doesn't appear in this heatmap for a particular patient, it was filtered out either from the original EDF file or from the .mat file and is
marked 'true' in the spreadsheet's 'excluded' column.

The channels in the heatmap are the same as the channels included in the patient_info.mat file for that patient entry, e.g. PY12N008.labels,
but there is no record of why these channels were omitted. The channel filter we create should match the filter used in the retrospective study
exactly; if it differs, the changes must not substantially change the 'red hot' regions of the resulting heatmap.

The EZTrack code now has unit tests for the new filter function in eztrack/tools/tests/eeg2fsv/channel_filter_tests.m. Each of these load an
event from the above patient list and compares the result of the filter to the channel names in data/patient_info.mat, the database that
contains the list of patient parameters used in the retrospective study.


## Getting Started

• Update the EZTrack code from github:

    cd ~/dev/eztrack
    # Stash any local changes you might have.
    git stash
    git pull origin master

• Download the eeg data from Google Drive: https://drive.google.com/open?id=0B0brB8m4HLpAb3hOaXh2empMUDg

This dataset has been completely deidentified, including treatment dates. As such, this data is not subject to HIPAA data handling restrictions.

• Extract the archive. Assuming you saved to "~/Downloads"...

    mv ~/Downloads/... ~/dev/eztrack/tools/data/channel_filter
    tar -xjvf channel_filter_data.bz2

• Open EZTrack in Matlab and ensure that 'tools' and its subfolders are on the path.

• Run `channel_filter_tests` from the command window to see the failing unit test.

• Add filter code to `tools/eeg2fsv/filter_channels.m` to make the tests pass.


## Data Description

Each of the four events for this patient are organized in two files ending with "_labels.csv" and "_eeg.csv".

The eeg files contain signals as rows and electrodes by column. The order of the columns corresponds with the order in the
labels files. Each file has a number of rows equal to (1000 x the number of seconds appearing in the filename): PY12N008_737sec_eeg.csv
has 737,000 rows.

The "..._labels.csv" files contain a single row of electrode labels stored in csv format. There are four label files due to
the script that extracted this data from the .mat workspace files, but all label files are identical.

There are 89 labels in the original dataset.

As you can see from dev/eztrack/tools/data/patient_info.mat, only 87 channels were used in the retrospective study. Comparing the list
in PY12N008.labels.values with the list in PY12N008_737sec_labels.csv, channels FTG7 and FTG8 are excluded.
