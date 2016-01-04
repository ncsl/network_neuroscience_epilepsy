function rankcent = rank_centrality(cent, num_electrodes, duration, pre_duration, post_duration)
    window = 21;           % smoothing window proportional to the length of the window, ~60%
    max_dur = 500;         % Maximum seizure duration set to 500 seconds for Hopkins

    % Converting eigenvector centrality to rank centrality
    rankcent = ranking(cent(:, duration), 'ascend');
    flank1   = ranking(cent(:, pre_duration), 'ascend');
    flank2   = ranking(cent(:, post_duration), 'ascend');

    %checking for any illegal entries in the electrode rank centrality matrix
    if ~(isempty(find(rankcent > num_electrodes, 1))...
            || isempty(find(flank1 > num_electrodes, 1))...
            || isempty(find(flank2 > num_electrodes, 1))...
            || isempty(find(rankcent < 1, 1))...
            || isempty(find(flank1 < 1, 1))...
            || isempty(find(flank2 < 1, 1)))
        error('Error in rank centrality: Illegal entries in the matrix');
    end

    % Normalize in length (#time points)
    if length(duration) ~= max_dur
        interval = linspace(1, length(duration), max_dur);
        rankcent = interp1(1:length(duration), rankcent', interval, 'linear')';
    end

    if ~(isempty(find(rankcent > num_electrodes, 1)) || isempty(find(rankcent < 1, 1)))
        error('Error in rank centrality interpolation: Illegal matrix entries');
    end

    % concatenate pre and post seizure activity to define the signal of interest
    rankcent = cat(2, flank1, rankcent, flank2);

    % Smooth the rank signal with a sliding window
    for etd = 1:num_electrodes
        rankcent(etd,:) = smooth(rankcent(etd,:), window, 'moving');
    end

    % Normalize y-axis
    rankcent = rankcent ./ num_electrodes;

    % TODO: Validation: rankcent should now only have values from 0 to 1
end