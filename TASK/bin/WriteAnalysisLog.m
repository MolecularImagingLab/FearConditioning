function WriteAnalysisLog(TrialStruct,Filename)
% Writes an space separted txt file with onset, durations and eventnames.

[p,n,e] =fileparts(Filename)
logname =[p '/' n '_AnalysisLog' e]
fid = fopen(logname, 'w');

fprintf(fid, '%s%s%s\n', 'Onset ', 'Duration ', 'Stimulus' );


for row = 1:numel(TrialStruct.Trials)
    
    text1 = {num2str(TrialStruct.Trials(row).TrialOnset), num2str(TrialStruct.Trials(row).FixOnset-TrialStruct.Trials(row).TrialOnset), char(TrialStruct.Trials(row).Stimulus)};
    
    for i =1:length(text1)
        
        fprintf(fid, '%s ',text1{i});
    
    end
    
    fprintf(fid, '\n');
    
    if isempty(num2str(TrialStruct.Trials(row).ShockOnset))
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

end
