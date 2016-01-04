function intervals = cdf_intervals(num_electrodes, area)
    % Extract the variables for CDF (10-d feature vectors)
    % 'intervals' is the number of electrodes by length of cdf
    
    cdf = 0.1:0.1:1;           % Domain of CDF: Used to create intervals
    length_cdf = length(cdf);

    intervals = zeros(num_electrodes, length_cdf);
    for i = 1:num_electrodes
        for j = 1:length_cdf
            intervals(i,j) = find(area(i, :) <= cdf(j), 1, 'last');
        end
    end
end

