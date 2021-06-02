function WritePar(TrialStruct,Filename)
% Writes an space separted txt file with onset, durations and eventnames.

[p,n,e] =fileparts(Filename);
logname =[p '/' n '.par']
fid = fopen(logname, 'w');

%fprintf(fid, '%s%s%s\n', 'Onset ', 'Duration ', 'Stimulus' );

for row = 1:numel(TrialStruct.Trials)
    
    % event
    O = round(TrialStruct.Trials(row).TrialOnset,1);
    T = char(TrialStruct.Trials(row).Stimulus);
    D = round(TrialStruct.Trials(row).FixOnset-TrialStruct.Trials(row).TrialOnset,1);
    W = 1;
    
    if strfind(T,'CSp'); T = 1; end
    if strfind(T,'CSm'); T = 2; end
    if strfind(T,'ITI'); T = 0; end
    if isempty(TrialStruct.Trials(row).ShockOnset) == 0; T = 3; end
    
    fprintf(fid, '%.1f %d %.1f %d\n', O, T, D, W);
    % iti
    
    O = round(TrialStruct.Trials(row).FixOnset,1);
    D = round(TrialStruct.Trials(row).FixOffset-TrialStruct.Trials(row).FixOnset,1);
    T = 0;
    W = 1;
    
    fprintf(fid, '%.1f %d %.1f %d\n', O, T, D, W);
    
end

fclose(fid);

end
