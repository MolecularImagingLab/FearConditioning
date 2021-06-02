function TrialStruct = BuildTrialStruct( file )
% Function builds a Matlab structure containing a single field, trials, which
% contains all of the necessary trial information passed to it via a CSV file. 
% Function assumes all information is stored in the CSV file such that each
% row corresponds to a given trial, and each column represents some
% relevant information about that trial. The resulting struct contains all
% information for a given trial within a field.
%

%% Import trials data.
% Open file.
fid = fopen(file);

% Read in column names. (there should be ten)
headers = textscan(fid, '%s %s %s %s %s %s %s %s', 1, 'Delimiter', ',');
headers = [headers{1:numel(headers)}];

%% Read in the rest of the rows. Assumes the following format:
% - ITI (float)
% - StimTime (float)
% - NodTime (float)
% - ITIcross (string)
% - Stimulus (string)
% - Nod1
% - Nod2
% - Shock (int)
raw_trials = textscan(fid, '%f %f %f %s %s %s %s %d', 'Delimiter', ',', ...,
                      'HeaderLines', 1);

%% Place trials in struct.
% Find number of trials.
nTrials = numel(raw_trials{1});
% Create empty structure.
TrialStruct = struct();

% Iteratively build trial fields containing the four columns of information.
for n=1:nTrials
    for m=1:numel(headers)
        TrialStruct.Trials(n).(headers{m}) = raw_trials{m}(n);
    end
end

end
