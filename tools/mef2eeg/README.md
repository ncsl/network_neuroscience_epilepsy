# MEF Processing

For each mef file, apply the following tools in parallel:

`read_mef_header`: save the header info to use as channel metadata (`mef_lib`)
`mef2ascii`: uncompress the channel readings to 32-bit ascii ints (`mef_lib`)
`check_mef_ascii`: run validations against the ascii values using the header results (`lein-exec`)

Finally, call `ascii2eeg` to convert the ascii ints to the eeg format EZTrack expects (`lein-exec`).

We then resume with the rest of the EZTrack pipeline:

eeg2fsv
fsv2heatmap

## read_mef_header

Save the header info to use as channel metadata: (`mef_lib`)

Use the `read_mef_header` utility to parse the header for each file. Save the values that we will
use for validation in an ascii file based on the original file name.

number samples: 7200000
frequency: 2000.000000
minimum_data_value = -32069
maximum_data_value = 15370

## mef2ascii

Uncompress the channel readings to 32-bit ascii ints (`mef_lib`)

## check_mef_ascii

Run validations against the ascii values using the header results (`lein-exec`)

• Given an mef file with 28,800,000 bytes;
• According to the header, there are 7.2M samples;

Given a one hour sample of 3600s, assert that `3600 * frequency = number_of_samples` with `wc -l`

Validate the range of values with `sort -n <values_file>`, then take the head and tail to get the min and max values.


## ascii2eeg

convert the ascii ints to the eeg format EZTrack expects (`lein-exec`)

Note that this may involve downsampling, decimation, or low-pass filtering to get from 2kHz to 1kHz.
See eeg2fsv/power_coherence.m
The output of ascii2eeg is a CSV usable by eeg2fsv.
