SHELL := /usr/bin/env bash

matlab_exe := /Applications/MATLAB_R2014b.app/bin/matlab
matlab     := $(matlab_exe) -nodesktop -nosplash -nojvm -r
matlab_jvm := $(matlab_exe) -nodesktop -nosplash -r

heatmap_output    := $(PROJECT_HOME)/output/heatmap
reference_heatmap := iEEG_temporal_CV_results_20-Sep-2015
temporal_out 			:= /tmp/eztrack-temporal
eeg2fsv_out			  := $(PROJECT_HOME)/output/eeg/PY12N008/adj_pwr/
reference 			  := $(PROJECT_HOME)/data/reference

all: check-deps reference-heatmap-csv tests

.SILENT: *check-matlab *check-reference-data
check-deps: *check-matlab *check-reference-data

*check-reference-data:
	[[ -d $(reference) ]] || \
		{ echo "EZTrack reference data not found at $(reference); please check the Getting Started section in the README" ; exit 1 ; }

*check-matlab:
	[[ ! -z "`which $(matlab_exe)`" ]] || \
		{ echo "MATLAB not found at $(matlab_exe); please check the Getting Started section in the README" ; exit 1 ; }

reference-heatmap-csv:
	cd $(PROJECT_HOME)/tests/fsv2heatmap && \
		$(matlab) "heatmap_file_to_csv('$(heatmap_output)/', '$(reference_heatmap)'); exit"

test: tests

tests: check-deps test-classifier test-fsv2heatmap test-eeg2fsv

test-classifier:
	cd $(PROJECT_HOME)/tests/fsv2heatmap && \
		$(matlab) "classifier_test; exit"

temporal:
	cd $(PROJECT_HOME)/fsv2heatmap && \
		$(matlab_jvm) "csv_file = temporal_ieeg_results; display(csv_file); exit" > $(temporal_out)

test-fsv2heatmap: temporal
	diff `grep $(PROJECT_HOME) $(temporal_out)` $(heatmap_output)/$(reference_heatmap).csv

test-eeg2fsv:
	rm -rf $(eeg2fsv_out)

	cd $(PROJECT_HOME)/tests/eeg2fsv && \
		$(matlab_jvm) "eeg2fsv_test; exit"

	cd $(eeg2fsv_out) && \
		ls *.dat | xargs -I% cmp % "$(reference)/PY12N008/adj_pwr/%"
