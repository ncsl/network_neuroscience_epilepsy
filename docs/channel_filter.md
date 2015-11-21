# Channel Filter Development


## Getting Started

```
cd ~/dev
git clone git@github.com:bobbyno/eztrack.git
```

Download the dataset from Google Drive: https://drive.google.com/open?id=0B0brB8m4HLpANE9MbndxcUFLU2s

This dataset contains the signals and labels for four events from PY12N008. This dataset has been completely deidentified,
including treatment dates. This data is not subject to HIPAA data handling restrictions, making dropbox a suitable alternative.

To extract the archive:

```
cd ~/dev/eztrack/tools/output/eeg/
mv ~/Downloads/PY12N008.bz2 !$
cd !$
tar -xjvf PY12N008.bz2
```

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

## Analysis

Open the EZTrack project in Matlab. Open the `tools/tests/eeg2fsv` folder.

In the Command Window, run `eeg = channel_filter_test`.


