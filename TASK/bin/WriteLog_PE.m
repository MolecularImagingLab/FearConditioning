function WriteLog_PE(TrialStruct,Filename,TrialsFile)
% Dumps all fields in TrialStruct.Trials to a tab-separated file.

%% Extract field data. Transpose.
fields = fieldnames(TrialStruct.Trials)';
nfields = numel(fields);
%% Extract values. Convert all numerical values to strings. Transpose.
values = struct2cell(TrialStruct.Trials);
idx = cellfun(@isnumeric, values); 
values(idx) = cellfun(@num2str, values(idx), 'UniformOutput', 0);
idx = cellfun(@iscell, values);
values(idx) = cellfun(@char, values(idx), 'UniformOutput', 0);
values = values(:,:)';

%% Write fields to file
% Open file.
fid = fopen(Filename, 'w');
% Define formatting.
formatSpec = repmat('%s,',1,nfields);
formatSpec = strcat(formatSpec(1:end-1),'\n');
% Write headers.
fprintf(fid, '%s\n', TrialsFile);
fprintf(fid,formatSpec,fields{:});
%% Write values.
[nrows,~] = size(values);
for row = 1:nrows
    
    fprintf(fid,formatSpec,values{row,:});
end

fclose(fid);