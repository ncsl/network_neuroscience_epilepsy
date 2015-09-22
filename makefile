SHELL = /usr/bin/env bash

matlab_exe := "/Applications/MATLAB_R2014b.app/bin/matlab"
matlab     := $(matlab_exe) -nodesktop -nosplash -nojvm -r
matlab_jvm := $(matlab_exe) -nodesktop -nosplash -r

heatmap_output    := $(PROJECT_HOME)/output/heatmap
reference_heatmap := iEEG_temporal_CV_results_20-Sep-2015

all: reference-heatmap-csv tests

reference-heatmap-csv:
	cd $(PROJECT_HOME)/tests/fsv2heatmap && \
		$(matlab) "heatmap_file_to_csv('$(heatmap_output)/', '$(reference_heatmap)'); exit"

tests: test-classifier test-fsv2heatmap

test-classifier:
	cd $(PROJECT_HOME)/tests/fsv2heatmap && \
		$(matlab) "classifier_test; exit"

test-fsv2heatmap:
	cd $(PROJECT_HOME)/tests/fsv2heatmap && \
		$(matlab_jvm) "csv_file = temporal_ieeg_results; display(csv_file); exit" > /tmp/eztrack-$@
	diff `grep $(PROJECT_HOME) /tmp/eztrack-$@` $(heatmap_output)/$(reference_heatmap).csv
