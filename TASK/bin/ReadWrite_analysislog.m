% Open file.
% adjusted for CS2

input_file =  '/Users/laurituominen/Desktop/CS_feargen/DATA/eroo_has_cs2/eroo_has_cs2gen32016_03_13_18_20_09.csv' 
output_file = '/Users/laurituominen/Desktop/CS_feargen/DATA/eroo_CS2_has/eroo_CS2_has_gen_analog.csv'

fid = fopen(input_file);

% Read in column names. 
formatSpec = repmat('%s',1,16);

headers = textscan(fid, formatSpec, 1, 'Delimiter', ',');
headers = [headers{1:numel(headers)}]


raw_trials = textscan(fid, '%d %f %f %f %s %s %s %s %d %f %f %f %f %f %f %f', 'Delimiter', ',', ...,
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

fclose(fid);


fid = fopen(output_file, 'w');

fprintf(fid, '%s%s%s\n', 'Onset ', 'Duration ', 'Stimulus' );


for row = 1:numel(TrialStruct.Trials)
    
    text1 = {num2str(TrialStruct.Trials(row).TrialOnset), num2str(TrialStruct.Trials(row).FixOnset-TrialStruct.Trials(row).TrialOnset), char(TrialStruct.Trials(row).Stimulus)};
    
    for i =1:length(text1)
        
        fprintf(fid, '%s ',text1{i});
    
    end
    
    fprintf(fid, '\n');
    
    if findstr(num2str(TrialStruct.Trials(row).ShockOnset), 'NaN')
        ITI='ITI';
    else
        ITI='ITIshock';
    end
    
    text2 = {num2str(TrialStruct.Trials(row).FixOnset),num2str(TrialStruct.Trials(row).FixOffset-TrialStruct.Trials(row).FixOnset), ITI};
   
    for i =1:length(text1)
        
        fprintf(fid,'%s ',text2{i});
    
    end
    
    fprintf(fid, '\n');
    
end

fclose(fid);

