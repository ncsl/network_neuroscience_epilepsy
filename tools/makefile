SHELL := /usr/bin/env bash

matlab_exe := /Applications/MATLAB_R2014b.app/bin/matlab
matlab     := $(matlab_exe) -nodesktop -nosplash -nojvm -r
matlab_jvm := $(matlab_exe) -nodesktop -nosplash -r

heatmap_output    := $(PROJECT_HOME)/output/heatmap
reference_heatmap := iEEG_temporal_CV_results_20-Sep-2015
temporal_out 			:= /tmp/eztrack-temporal

all: check-deps reference-heatmap-csv tests

.SILENT: *check-matlab
check-deps: *check-matlab

*check-matlab:
	[[ ! -z "`which $(matlab_exe)`" ]] || \
		{ echo "MATLAB not found at $(matlab_exe); please check the Getting Started section in the README" ; exit 1 ; }

reference-heatmap-csv:
	cd $(PROJECT_HOME)/tests/fsv2heatmap && \
		$(matlab) "heatmap_file_to_csv('$(heatmap_output)/', '$(reference_heatmap)'); exit"

test: tests

tests: check-deps test-classifier test-fsv2heatmap

test-classifier:
	cd $(PROJECT_HOME)/tests/fsv2heatmap && \
		$(matlab) "classifier_test; exit"

temporal:
	cd $(PROJECT_HOME)/fsv2heatmap && \
		$(matlab_jvm) "csv_file = temporal_ieeg_results; display(csv_file); exit" > $(temporal_out)

test-fsv2heatmap: temporal
	diff `grep $(PROJECT_HOME) $(temporal_out)` $(heatmap_output)/$(reference_heatmap).csv


go: test-eeg2fsv

test-eeg2fsv:
	ls $(PROJECT_HOME)/output/eeg/PY12N008/adj_pwr | xargs -I% cmp $(PROJECT_HOME)/output/eeg/PY12N008/adj_pwr/% \
		"$$HOME/Desktop/EZTrack Reference Data/PY12N008/adj_pwr/%"
