# EZTrack

EZTrack produces electrode weights and heatmap scores from EEG signals in EDF or MEF files.

## Getting Started

`source .env`

`make check-deps`

If this step succeeds, you are ready to run the tests.

### MATLAB not found

The path to matlab is stored in a variable called `matlab_exe`.

If the default path doesn't match your path, you can override it.
Replace the path below with the path to your matlab executable:

`make -e matlab_exe=/Applications/MATLAB_R2014b.app/bin/matlab check-deps`

## Development

After making changes to the code, run the tests to ensure things are still working:

`make test`

Don't forget to source the .env file if you close your terminal: This file sets
some environment variables that are used by the rest of the build scripts.

## Structure

The code is organized as a data processing toolchain orchestrated by the `hopkins-main`
or `ummc-main` bash scripts. Refer to these files to understand the data flow of the program.
