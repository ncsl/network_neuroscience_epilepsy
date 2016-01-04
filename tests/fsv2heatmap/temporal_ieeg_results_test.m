expected = fileread([getenv('HOME') '/dev/eztrack/tests/fsv2heatmap/expected_weights_PY04N007.csv']);
actual = fileread(temporal_ieeg_results('PY04N007'));
assert(isequal(actual, expected));