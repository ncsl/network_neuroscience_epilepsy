function [dat,filters] = buttfilt(dat,freqrange,samplerate,filttype,order)
%BUTTFILT - Wrapper to Butterworth filter.
%
% Butterworth filter wrapper function with zero phase distortion.
%
% FUNCTION:
%   y = buttfilt(dat,freqrange,samplerate,filttype,order)
%   y = buttfilt(dat,filters)
%
% INPUT ARGS: (defaults shown):
%   dat = dat;                % data to be filtered (if data is a matrix, BUTTFILT filters across rows)
%   freqrange = [58 62];      % filter range (depends on type)
%   samplerate = 256;         % sampling frequency
%   filttype = 'stop';        % type of filter ('bandpass','low','high','stop') 
%   order = 4;                % order of the butterworth filter
%   filters = {B,A};          % a set of filters to use on data (created by a previous buttfilt call)
%
% OUTPUT ARGS::
%   y = the filtered data
%

% 12/1/04 - PBS - Will now filter multiple times if requested

if ~exist('filttype','var') || isempty(filttype)
    filttype = 'stop';
elseif strcmp(filttype, 'bandpass') && isvector(freqrange)
    if freqrange(1) <= 0
        filttype = 'low';
        freqrange = freqrange(2);
    elseif isinf(freqrange(2))
        filttype = 'high';
        freqrange = freqrange(1);
    end
end

if ~exist('order','var') || isempty(order)
    order = 4;
end

if( ~iscell(freqrange) )
    % premade filters were not passed in, so make filters
    nyq = samplerate/2; % Nyquist frequency

    filters = cell(size(freqrange,1),1);
    for i = 1:size(freqrange,1)
        [filters{i,1}, filters{i,2}] = butter(order, freqrange(i,:)/nyq, filttype);
    end
else
    % premade filters were passed in as second argument, so use them
    filters = freqrange;
end

% run the filtfilt for zero phase distortion
for i = 1:size(filters,1)
    if( size(dat,2) ~= 1 )
        % we don't have a column vector, so filter all rows
        dat = filtfilt2(filters{i,1},filters{i,2},dat')'; % filtfilt runs over columns
    else
        % we have a column vector
        dat = filtfilt(filters{i,1},filters{i,2},dat);
    end
end
