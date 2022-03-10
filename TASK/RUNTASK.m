function RUNTASK(trialName, varargin)
% conditioning paradigm
%
% usage: RUNTASK('TrialsFile', optional arguments)
% 
% required arguments:
%       TrialsName         csv-file without the .csv 
%
% optional arguments:      
%       demo               nowait, nolabJack, use when demoing 
%
%       noscanner          Does not wait for scanner, but delivers shocks, only for trouble shooting
%       nolabJack          Does not send triggers or shocks, but waits for scanner, only for trouble shooting
%
% TrialsFiles are .csv-files found in the trialfiles folder. Choose one of
% those. That is A, B, C, D, E or Z. Please note Z option is extended 1.5x.  
% TrialsFile should be written without the .csv extension.
% 
% Example: RUNTASK('A')
% 

%% set environment
addpath([pwd '/bin'])
clear('Screen');
PsychDefaultSetup(2);
Screen('Preference', 'Verbosity', 1);
KbName('UnifyKeyNames')
Priority(9);
% Turn on labjack & scanner sync
isLJ =1;
scanner =1; 

%% Check arguments, turn off scanner sync and/or labJack if requested  
narginchk(1,3)
legalTrialNames = {'A', 'B', 'C', 'D', 'E', 'Z'};
if isempty(find(strcmp( legalTrialNames, trialName )));
    help RUNTASK.m
    return
end

if nargin > 1 
        if find(strcmp(varargin,'noscanner')); scanner =0; end
        if find(strcmp(varargin,'nolabJack')); isLJ =0; end
        if find(strcmp(varargin,'demo')); isLJ =0; scanner=0; end
end

%% Open dialog box. Query for subject ID
Inputs = inputdlg({'Enter subject ID:'}, 'Input',[1 30]);           
SubjectID = Inputs{1};

%% Generate output filepaths.
timestring = datestr(round(clock),'yyyy_mm_dd_HH_MM_SS');
TrialsFile = ['trialfiles/' trialName '.csv'];
[~,NN,~] = fileparts(TrialsFile);
Output = ['DATA' filesep SubjectID filesep SubjectID '.' NN '.'  timestring '.csv'] ;
sDir=[pwd '/DATA/' SubjectID '/stimuli' ];

%% Setup experiment environment.
TrialStruct = BuildTrialStruct(TrialsFile);

%% Open windoscaw. Predraw stimuli as textures.
try
    TrialStruct = PredrawStimuli(TrialStruct, sDir );
    HideCursor();
catch err
    Screen('CloseAll');
    rethrow(err);
end

%% Set up labJack.
clear lj;

if isLJ == 1
    try
        lj = Setup_LabJack();
        % Notify biopac of a new run
        lj.timedTTL(0,100)
    catch err
        Screen('CloseAll'); ShowCursor();
        error('Error in setting up LabJack. Please check equipment.');
    end
    
    if lj.isOpen == 0
        Screen('CloseAll'); ShowCursor();
        error('lj.isOpen = 0. Please check labJack.');
    end
    
else
    lj=0;
end

%% Wait to sync with scanner.
% Global start time recorded via this command.
if scanner
    TrialStruct = WaitForScanner( TrialStruct );
else
    TrialStruct.StartTime = GetSecs();
end

%% Go thorough Trials.
nTrials = numel(TrialStruct.Trials);
currentTrial = 1;

while currentTrial <= nTrials
    try
        [TrialStruct, flag] = RunTrial(TrialStruct, currentTrial, lj, isLJ);
        currentTrial = currentTrial + 1;
        
        if flag
            WriteLog_PE(TrialStruct,Output,TrialsFile);
            break;
        end
        
    catch err
        Screen('CloseAll');
        WriteLog_PE(TrialStruct,Output,TrialsFile);
        rethrow(err);
    end
end
    

if flag
    Screen('CloseAll')
    return
    clc;
end

%% send a pulse 
if isLJ; lj.timedTTL(0,100); end

%% Save data.
WriteLog_PE(TrialStruct,Output,TrialsFile);
WritePar(TrialStruct,Output)

%% Close screens.
Screen('CloseAll');
fclose all;
clear lj;
clc

end

