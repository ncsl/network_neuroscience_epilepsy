eztrack_home = [getenv('HOME') '/dev/eztrack'];
expected = fileread([getenv('HOME') '/dev/eztrack/tests/fsv2heatmap/expected_weights_PY04N007.csv']);
% label_filename, start_marks, and end_marks aren't needed here since this is a reference patient.
% production clients will pass in these values.
actual = fileread(temporal_ieeg_results(eztrack_home, 'PY04N007', '', 0, 0));
assert(isequal(actual, expected));
