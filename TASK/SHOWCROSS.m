function SHOWCROSS
% Will display a white ITI cross

clear('Screen');
Screen('Preference', 'SkipSyncTests', 0); % here 1 is for testing, remove when you don't need it anymore.
Screen('Preference', 'Verbosity', 0);
addpath([pwd filesep '/bin'])

%% Setup experiment environment.
TrialsFile = [pwd filesep '/trialfiles' filesep 'showcross.csv']; 
TrialStruct = BuildTrialStruct(TrialsFile);

%% Open windoscaw. Predraw stimuli as textures.
try
    TrialStruct = PredrawStimuli(TrialStruct);
    HideCursor();
catch err
    Screen('CloseAll')
    rethrow(err)
end

equalSign = KbName('=+');
n = 1

Screen('DrawTexture', TrialStruct.MainWindow, TrialStruct.Stim.(char(TrialStruct.Trials(n).ITIcross)).Texture);
Screen('Flip',TrialStruct.MainWindow, 0, 0);
st = GetSecs();

while GetSecs-st < 3000
    [keyDown,~,keyCode] = KbCheck;
    
    if (keyDown)
        if keyCode(equalSign) ~= 1
            break
        end
        
    end
end

Screen('CloseAll');
clc

end
