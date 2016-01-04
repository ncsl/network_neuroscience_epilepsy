function integration = normalize_area(rankcent)
%% Normalizes the area so that each row of rankcent integrates to 1.
    integration = cumtrapz(rankcent, 2);
    for i = 1:size(rankcent, 1)
        rankcent(i, :) = rankcent(i, :) ./ integration(i, end);
        integration(i, :) = integration(i, :) ./ integration(i, end);
    end

    if ~(isempty(find(integration(:, end) ~= 1, 1)))
        error('Error in area normalization: Illegal matrix entries');
    end
end

