clear;
home = getenv('HOME');
fsv_path = [home '/dev/eztrack/tools/output/fsv'];
f_info = load([home '/dev/eztrack/tools/data/patient_info.mat']);
sample = [32 34 35 36 38 39 41 42 43 44 45 47 50 51 52];

test_element = 32;
points = pcspace(fsv_path, f_info, sample, test_element);
patient_type = 1;
number_heatmap_colors = 20;
output = electrode_classifier(patient_type, test_element, f_info, points, number_heatmap_colors);
