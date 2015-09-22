function heatmap_file_to_csv(output_path, output_filename)
% Convert EZTrack heatmap results stored in Matlab workspace files to CSV.

heatmap_file = [output_path output_filename '.mat'];
csv_file = [output_path output_filename '.csv'];

heatmap_to_csv(load(heatmap_file), csv_file);

end