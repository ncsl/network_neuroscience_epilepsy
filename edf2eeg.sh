#!/usr/bin/env bash

PROJECT_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

usage="Usage: $0 <patient_id (e.g. PY12N008) [rest|butlast]>"
patient_id=$1
[[ ! -z "$patient_id" ]] || { echo $usage ; exit 1 ; }

# edf2eeg can be run with @rest or @butlast depending on where the annotation channel appears.
strategy=$2
[[ ! -z "$strategy" ]] || { echo $usage ; exit 1 ; }

set -eu

matlab_jvm="matlab -nodesktop -nosplash -r"
[[ ! -z "`which matlab`" ]] || \
    { echo "MATLAB not found on the PATH; please check the Getting Started section in the README" ; exit 1 ; }

edf_input=$PROJECT_HOME/data/edf/${patient_id}.edf

eeg_output=$PROJECT_HOME/output/eeg/$patient_id
mkdir -p $eeg_output

printf "\n== edf2eeg ==\n"
cd $PROJECT_HOME/edf2eeg && $matlab_jvm "edf2eeg('$edf_input', '$eeg_output', @$strategy); exit"
