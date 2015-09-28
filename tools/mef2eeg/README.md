# MEF processing algorithm

For each mef file in parallel, leverage the following tools:

`read_mef_header`: save the header info for metadata (`mef_lib`)
`mef2txt`: uncompress the channel readings to 32-bit ascii ints (`mef_lib`)
`check_mef_txt`: run validations against the ascii values using the header results (`lein-exec`)
`mef_txt2eeg`: convert the ascii ints to the eeg format EZTrack expects (`lein-exec`)

We then resume with the rest of the EZTrack pipeline:

eeg2fsv
fsv2heatmap

## MEF file validations

Use the `read_mef_header` utility to parse the header for each file and get a breakdown
of verification statistics.

number samples: 7200000
frequency: 2000.000000
minimum_data_value = -32069
maximum_data_value = 15370

### File size validation after mef2int32

• Given a int32 file has 28,800,000 bytes.
• According to the header, there are 7.2M samples.
• With 32 bit integers, that equates to 4 bytes per sample.

Compare actual file size to expected `4 * n_samples`.

Also, given a one hour sample of 3600s, assert that `3600 * frequency = number_of_samples`

### int32toAscii range validation

`sort -n <values_file>`...take the head and tail to get the min and max values.

## Compression Experiment

If compression is one of the main goals of MEF, it seems like a failure.

`tar -jcvf values.tar.bz2 values`

 33M  values
 27M  data/PY15N012_LPT100_0077.raw32
 13M  v.tgz
 10M  data/PY15N012_LPT100_0077.mef
 9.1M values.tar.bz2

## Visualization options

• Dygraphs gallery: http://dygraphs.com/gallery/# - apparently optimized for large data sets.

• InfluxDB + Grafana might be a storage option: http://grafana.org/features/

## Downsampling options

Do we actually need a 2 kHz sampling frequency? This should probably be done before sending
the data over the wire.

https://blog.datamarket.com/2014/02/28/downsampling-data-not-a-trivial-task/
