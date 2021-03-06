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
`signals2eeg`    -> `paste -d ',' *.txt > patient_id_077_eeg.csv`
                    `paste` combines files column-wise. Columns are electrodes, rows are signals.
`signals2labels` -> create the patient_id_077_labels.csv file based on the same signals and order used in `ascii2eeg`.

Test EZTrack after we have the required label and eeg files:

• Add required inputs to the patient_info.mat file for the mef patient based on the signals that are saved.
• If there's an error, fall back to testing PY12N008 with the eeg input.


## mef2ascii

Uncompress the channel readings to 32-bit ascii ints (`mef_lib`)

`ls *.mef | xargs -n 1 -P 8 mef2ascii`cd ~/dev/clients/cognitect/pershing

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

_For 0.0.1, assume one seizure per hour._

### Determine the seconds to save

start_time
onset_time-60s (or start_time, whichever is smaller)
offset_time+60s (or end_time, whichever is smaller)
end_time

### Compute the position in the file based on the frequency

Timestamps in MEF are stored in Microsecond Coordinated Universal Time (UTC), which is a variation of standard Unix or Posix UTC time defined by the number of microseconds since midnight January 1, 1970, GMT. (http://www.ncbi.nlm.nih.gov/pmc/articles/PMC2841504/)

Using the times from http://www.epochconverter.com:

recording_start_time = 1439842164810500 (Mon, 17 Aug 2015 20:09:24 GMT)
seizure_onset_time   = 1439842617000000 (Mon, 17 Aug 2015 20:16:57 GMT)
seizure_end_time     = 1439842917000000 (Mon, 17 Aug 2015 20:21:57 GMT)
recording_end_time   = 1439845764810000 (Mon, 17 Aug 2015 21:09:24 GMT)

signal_to_start = onset - start = 1439842617000000 - 1439842164810500 = 452189500 / 1000000 = 452
start = signal_to_start * frequency = 452 * 1000 = 452000
seizure_end_time - seizure_onset_time = 300000000 / 1000 = 300000

TODO: See the updated algo in the Trello card.

## channel_stats

## channel_filter

For each file, create the header, compute the stats, then cat the header and stats together as a `summary` file.
More notes in https://trello.com/c/D1kLkg4U/60-channel-filter


TODO: It would be interesting to run this filter on the retrospective study data to see what the stats are of the channels that are known to provide good inputs.


## signals2eeg

`signals2eeg`    -> `paste -d ',' *.txt > patient_id_077_eeg.csv`
                    `paste` combines files column-wise.

## signals2labels

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
