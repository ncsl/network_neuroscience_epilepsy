SHELL = /usr/bin/env bash

matlab_exe := "/Applications/MATLAB_R2014b.app/bin/matlab"
matlab := $(matlab_exe) -nodesktop -nosplash -nojvm -r

test_classifier:
	cd $(PROJECT_HOME)/tests/fsv2heatmap && $(matlab) "classifier_test; exit"
