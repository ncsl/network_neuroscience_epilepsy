function labels2csv(labels, labels_file)

labels_file_id = fopen(labels_file, 'w');
fprintf(labels_file_id, strjoin(labels,','));
fclose(labels_file_id);

end

