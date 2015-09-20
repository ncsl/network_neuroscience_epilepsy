function heatmaps_to_csv(heatmaps, output_path, output_filename)
% Save EZTrack heatmap struct as CSV.

csv_file = [output_path output_filename '.csv'];

file_id = fopen(csv_file, 'w');
header = {'patient_id', 'label', 'weight', 'heatmap_color'};
header_format = '%s,%s,%s,%s\n';
fprintf(file_id, header_format, header{1,:});

row_format = '%s,%s,%0.4f,%d\n';

patients = fieldnames(heatmaps);
num_patients = length(patients);

for id = 1:num_patients
    name = patients{id};
    num_electrodes = length(heatmaps.(name).E_Weights);
    for e = 1:num_electrodes
        label = heatmaps.(name).E_labels{e};
        weight = heatmaps.(name).E_Weights(e);
        color = heatmaps.(name).E_HeatCodes(e);
        row = {name, label, weight, color};
        fprintf(file_id, row_format, row{1,:});
    end    
end

fclose(file_id);

end