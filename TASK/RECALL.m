function RECALL
%
% This function will show twice each face in the stims_temp folder and ask
% for likelihood that the face was ever associated with the shock. Responses are
% collected on a likert scale using a with a 4-button box. Remember to use the same ID as you used
% for the fMRI task
%
% Currently accepting only 6,7,8, or 9 as inputs 
% 9 = very unlikely
% 8 = somewhat unlikely
% 7 somewhat likely
% 6 very likely
%
% usage: RECALL
%
% parameters: none
%

KbName('UnifyKeyNames')
PsychDefaultSetup(2);
clear('Screen');
addpath([pwd '/bin'])

%% Open dialog box. Query for subject ID'TrialStruct'
Inputs = inputdlg({'Enter subject ID:'}, 'Input',[1 30]);
SubjectID = Inputs{1};
timestring = datestr(round(clock),'yyyy_mm_dd_HH_MM_SS');
sDir=[pwd '/DATA/' SubjectID '/stimuli/' ];
if exist(sDir) ~= 7
    help RECALL.m
    return
end

Output = ['DATA' filesep SubjectID filesep SubjectID '.RECALL.' timestring '.csv'];

%% Setup experiment environment.

CSp = strcat({'A' 'B' 'C' 'D', 'E'}, {'CSp'});
CSm = strcat({'A' 'B' 'C' 'D', 'E'}, {'CSm'});
SS = repmat([CSp CSm],1,2);
SS = SS(randperm(numel(SS)));

% Build trial fields
TrialStruct = struct();
for n=1:numel(SS)
    TrialStruct.Trials(n).Stimulus = SS{n};
end

%% Open windoscaw. Predraw stimuli as textures.
try
    TrialStruct = PredrawStimuli_recall(TrialStruct, sDir);
    HideCursor();
catch err
    Screen('CloseAll')
    rethrow(err)
end

exitKey =  KbName( 'ESCAPE' );
accepted = [KbName( '6^' )  KbName( '7&' )  KbName( '8*' )  KbName( '9(' )];

%% Start task 
WaitText = 'Press any key to continue...';
Screen('TextFont', TrialStruct.MainWindow, 'Helvetica');
Screen('TextSize', TrialStruct.MainWindow, 24);
DrawFormattedText(TrialStruct.MainWindow, WaitText, 'center', 'center',...
    [255 255 255], 60);
Screen('Flip',TrialStruct.MainWindow);

% Press any key but not 6, 7, 8, or 9
while 1
    [keyIsDown,secs,keyCode] = KbCheck;
    if keyIsDown
        if isempty(find(keyCode(accepted)))
            TrialStruct.StartTime = secs;
            break
        end
    end
end

    
for n = 1:numel(TrialStruct.Trials)
    try
        
        DrawImage(TrialStruct, n) 
        
    catch err
        
        Screen('CloseAll')
        rethrow(err)
        
    end
    
    st = GetSecs();
    
    while 1
        [keyIsDown,secs,keyCode] = KbCheck;
        
        if keyIsDown
            if keyCode(exitKey)
                Screen('CloseAll');
                return;
            elseif find(keyCode(accepted))
                TrialStruct.Trials(n).response = KbName(keyCode)
                TrialStruct.Trials(n).time = secs-st
                break
            end
        end
    end
         
    % ITI
    ITI = '+';
    Screen('TextFont', TrialStruct.MainWindow, 'Helvetica');
    Screen('TextSize', TrialStruct.MainWindow, 60);
    DrawFormattedText(TrialStruct.MainWindow, ITI, 'center', 'center',...
        [255 255 255], 60);
    Screen('Flip',TrialStruct.MainWindow);
    
    st = GetSecs();
    
    while GetSecs-st < 1
        [keyIsDown,secs,keyCode] = KbCheck;
        
        if keyIsDown
            if keyCode(exitKey)
                Screen('CloseAll');
                return;
            end
        end
    end
     
end


% create a RECALL file
fid = fopen(Output, 'w');
fprintf(fid, '%s,%s,%s\n', 'Stimulus', 'Response', 'RT');
for i =1:numel(TrialStruct.Trials) 
    
    switch str2num(TrialStruct.Trials(i).response(1))
        case 9
            r = 'very_unlikely';
        case 8
            r = 'somewhat_unlikely';
        case 7
            r = 'somewhat_likely';
        case 6 
            r= 'very_likely';
    end
    fprintf(fid, '%s,%s,%f\n',TrialStruct.Trials(i).Stimulus,r,TrialStruct.Trials(i).time);
end

fclose(fid);
Screen('CloseAll')
clc;

