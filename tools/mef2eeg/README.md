# mef2eeg

`mef2eeg` is a tool to parse mef files and produce a labels.csv and eeg.csv compatible with `eeg2fsv`.
mef provides about 10x compression. A one hour segment with 2.5GB of data will become 25 GB uncompressed.
As such, early signal filtering is critical to maintain acceptable performance of EZTrack running in under
one hour.

`mef2ascii`      -> convert to plain ascii values
`downsample`     -> Start with a simple 2kHz to 1kHz downsample: `awk 'NR % 2 == 0' file > newfile`.
                    NB: Should move to http://www.mathworks.com/help/signal/ref/decimate.html in the future.
`time_filter`    -> extract only the rows we need; delete the original ascii.
`channel_filter` -> extract headers and compute stats for each channel. Remove those without a high snr (or similar metric)
`ascii2eeg`      -> `paste -d ',' *.txt > patient_id_077_eeg.csv`
                    `paste` combines files column-wise. Columns are electrodes, rows are signals.
`labels`         -> create the patient_id_077_labels.csv file based on the same signals and order used in `ascii2eeg`.

Test EZTrack after we have the required label and eeg files:

• Add required inputs to the patient_info.mat file for the mef patient based on the signals that are saved.
• If there's an error, fall back to testing PY12N008 with the eeg input.


## mef2ascii

Uncompress the channel readings to 32-bit ascii ints (`mef_lib`)

`ls *.mef | xargs -n 1 -P 8 mef2ascii`

...takes about 5 minutes for a one hour segment.


## downsample

`downsample`     -> Apply a simple 2kHz to 1kHz downsample: `awk 'NR % 2 == 0' file > newfile`.

| file                        | kHz |   lines |         max |          min |       range |      mean |        std |      snr |
|-----------------------------+-----+---------+-------------+--------------+-------------+-----------+------------+----------|
| PY15N012_PTO4_0077.txt      |   2 | 7200000 | 2454.980469 | -2421.972656 | 4876.953125 | 56.723143 | 202.659581 | 0.279894 |
| PY15N012_PTO4_0077_1khz.txt |   1 | 3600000 | 2447.363281 | -2421.972656 | 4869.335937 | 56.722267 | 202.659608 | 0.279889 |
|                             |     |         |             |              |             |           |            |          |

_NB: Should move to http://www.mathworks.com/help/signal/ref/decimate.html in the future._


## time_filter

Decide which time-slice to take based on the inputs from the clinical notes.

For 0.0.1, we're going to assume one seizure per hour.

### Determine the seconds to save

start_time
onset_time-60s (or start_time, whichever is smaller)
offset_time+60s (or end_time, whichever is smaller)
end_time

### Compute the position in the file based on the frequency

start: onset - start_time
end:   start + duration

Then use head and tail to carve out this portion of the file.

Also see the notes and times in https://trello.com/c/RktHxAsU/61-time-filter


## channel_filter

For each file, create the header, compute the stats, then cat the header and stats together as a `summary` file.
More notes in https://trello.com/c/D1kLkg4U/60-channel-filter

```
fields="channel_name|maximum_data_value|minimum_data_value|number_of_samples|physical_channel_number|recording_end_time|recording_start_time|sampling_frequency|subject_id"
headers=`echo $fields | sed 's/|/,/g'`

read_mef_header PY15N012_LPT83_0077.mef | \ # read the mef header
egrep $fields | \ # keep only the fields that interest us
sort | \ # sort these fields to match the sort order in $fields
cut -d " " -f 3 | \ # keep only the values in these x = y pairs
tr '\n' ',' | sed '$s/,$//' \ # transform into a comma-delimited list, using sed to remove the trailing comma
> testing_header.txt
```

## signals2eeg

`signals2eeg`    -> `paste -d ',' *.txt > patient_id_077_eeg.csv`
                    `paste` combines files column-wise.

## labels

`labels`         -> create the patient_id_077_labels.csv file.

Algo TBD


## Misc Notes

• notch_filter_frequency = 60.000000  - is this important anywhere in power_coherence?

• Comparing stats in MATLAB

The `awk` script computes the same value that matlab does for std: http://www.mathworks.com/help/matlab/ref/std.html#moreabout

```
fileID = fopen('/Users/bnorton/dev/eztrack/tools/data/mef/PY15N012/PY15N012_LPT83_0077.txt','r');
A = fscanf(fileID,'%f');
```

## Future Work

### check_mef_ascii

Run validations against the ascii values using the header results (`lein-exec`)

• Given an mef file with 28,800,000 bytes;
• According to the header, there are 7.2M samples;

Given a one hour sample of 3600s, assert that `3600 * frequency = number_of_samples` with `wc -l`

Validate the range of values with `sort -n <values_file>`, then take the head and tail to get the min and max values.
