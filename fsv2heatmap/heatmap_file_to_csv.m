function heatmap_file_to_csv(output_path, output_filename)
% Convert EZTrack heatmap results stored in Matlab workspace files to CSV.

heatmap_file = [output_path output_filename '.mat'];
heatmaps_to_csv(load(heatmap_file), output_path, output_filename);

end