# EZTrack for Fellows

## Complete the Patient Info File

• Get the research identifier used for the patient, e.g. PY12N008, from Christophe Jouny.
• Use Excel or similar to open the `patient_info.csv` template.
• Fill in the required fields.
• Save the file as patient_name.csv


## Copy the file to the EZTrack server

scp the file to your home directory on the server: `scp /local/path/PY12N008.csv <fellowsname>@eztrack.jhu.edu:~/`

ssh into the server: `ssh <fellowsname>@eztrack.jhu.edu`

run EZTrack: `eztrack PY12N008`

EZTrack typically takes about 30 minutes to run. When it finishes, you'll find the name of the heatmap it produced as
the last line in the program output, e.g. `/home/eztrack/tools/output/heatmap/PY15N012_iEEG_temporal_results_14-Nov-2015.csv`

scp this heatmap to your machine: `scp <fellowsname>@eztrack.jhu.edu:/home/eztrack/tools/output/heatmap/PY15N012_iEEG_temporal_results_14-Nov-2015.csv`

You can now open the heatmap in Excel or a similar tool to view the results.

