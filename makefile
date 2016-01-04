SHELL := /usr/bin/env bash

matlab_exe := matlab
matlab     := $(matlab_exe) -nodesktop -nosplash -nojvm -r
matlab_jvm := $(matlab_exe) -nodesktop -nosplash -r

patient_id				:= PY12N008
heatmap_output    := $(PROJECT_HOME)/output/heatmap
temporal_out 			:= /tmp/eztrack-temporal
eeg2fsv_out			  := $(PROJECT_HOME)/output/eeg/$(patient_id)/adj_pwr/
reference 			  := $(PROJECT_HOME)/data/reference
reference_heatmap := $(patient_id)_iEEG_temporal_results_28-Aug-2015.csv

target						:= $(PROJECT_HOME)/target
version 					:= $(shell git rev-parse --short HEAD)
package					  := $(target)/eztrack-$(version).tgz
remote	          := rnorton6@10.162.38.216
remote_home				:= /home/WIN/rnorton6

clean:
	find $(PROJECT_HOME)/output -name adj_pwr | xargs rm -rf
	rm -rf $(target)

test: tests

smoke: check-deps test-temporal-ieeg-results

tests: smoke pipeline

# NB: Leaving edf2eeg out of the pipeline for performance reasons.
pipeline: test-eeg2fsv copy-fsv-output test-fsv2heatmap revert-fsv-output

.SILENT: *check-matlab *check-reference-data
check-deps: *check-matlab *check-reference-data

*check-reference-data:
	[[ -d $(reference) ]] || \
		{ echo "EZTrack reference data not found at $(reference); please check the Getting Started section in the README" ; exit 1 ; }

*check-matlab:
	[[ ! -z "`which $(matlab_exe)`" ]] || \
		{ echo "MATLAB not found at $(matlab_exe); please check the Getting Started section in the README" ; exit 1 ; }

test-temporal-ieeg-results:
	cd $(PROJECT_HOME)/tests/fsv2heatmap && $(matlab_jvm) "temporal_ieeg_results_test; exit"

temporal:
	cd $(PROJECT_HOME)/fsv2heatmap && $(matlab_jvm) "csv_file = temporal_ieeg_results('$(patient_id)'); display(csv_file); exit" > $(temporal_out)

test-fsv2heatmap: temporal
	diff `grep $(PROJECT_HOME) $(temporal_out)` $(heatmap_output)/$(reference_heatmap)

test-eeg2fsv:
	rm -rf $(eeg2fsv_out)
	cd $(PROJECT_HOME)/tests/eeg2fsv && $(matlab_jvm) "eeg2fsv_test; exit"

copy-fsv-output:
	cp $(eeg2fsv_out)svd_vectors/fsv_pwr$(patient_id).mat $(PROJECT_HOME)/output/fsv

revert-fsv-output:
	git co $(PROJECT_HOME)/output/fsv

test-edf2eeg:
	cd $(PROJECT_HOME)/tests/edf2eeg && $(matlab) "edf2eeg_test; exit"

$(target):
	mkdir -p $(target)

$(package): $(target)
	git archive -o $@ HEAD

build: $(package)

deploy: $(package)
	scp $(package) $(remote):$(remote_home)
	ssh $(remote) 'mkdir -p eztrack-$(version) && tar xzvf eztrack-$(version).tgz -C eztrack-$(version) && ln -sfn eztrack-$(version) eztrack'
	# TODO: Run make in mef_lib_2_1
	# resume with testing other eztrack commands

ssh:
	ssh $(remote)
