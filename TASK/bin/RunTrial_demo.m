function [TrialStruct, flag] = RunTrial_demo( TrialStruct, n )
% Runs a single trial of the PE task.

%% Begin timing.
start = GetSecs();
ShockTime = 0.5;

response = 0;
keypress = 0;
flag=0;
exitKey =  KbName( 'ESCAPE' );


Screen('DrawTexture', TrialStruct.MainWindow, TrialStruct.Stim.(char(TrialStruct.Trials(n).Stimulus)).Texture);
Screen('Flip',TrialStruct.MainWindow, 0, 0);
TrialStruct.Trials(n).TrialOnset = GetSecs() - TrialStruct.StartTime;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Draw face. Wait.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if TrialStruct.Trials(n).NodTime ~= 0
    
    % Wait.
    while GetSecs-start < TrialStruct.Trials(n).NodTime
        [keyIsDown, ~, keyCode] = KbCheck(-3);
        
        if keyIsDown
            if keyCode(exitKey)
                flag=1 ;
                break
            end
        end
    end
    
    if flag
        return
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% nod
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    NodStart = GetSecs();
    
    [TrialStruct, response, keypress] = nod(TrialStruct, n, response, NodStart, keypress);
    
    NodOver = GetSecs()-NodStart;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Draw the face again.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Screen('DrawTexture', TrialStruct.MainWindow, TrialStruct.Stim.(char(TrialStruct.Trials(n).Stimulus)).Texture);
    Screen('Flip',TrialStruct.MainWindow, 0, 0);
    
    while GetSecs-start < TrialStruct.Trials(n).StimTime
        [keyIsDown, secs, keyCode] = KbCheck(-3);
        
        if keyIsDown
            
            if keyCode(exitKey)
                flag=1 ;
                break
            end
            
            if response == 0
                keypress = secs-NodStart;
                response=1;
            end
            
        end
        
    end
    
    if flag
        return
    end
    
    
    TrialStruct.Trials(n).Keypress = keypress;
    TrialStruct.Trials(n).NodStart = NodStart-start;
    TrialStruct.Trials(n).NodOver = NodOver;
    
    
else
    %% in case there is no nod:
    TrialStruct.Trials(n).NodStart = 0;
    while GetSecs-start < TrialStruct.Trials(n).StimTime
        [keyIsDown, secs, keyCode] = KbCheck(-3);
        
        if keyIsDown
            if keyCode(exitKey)
                flag=1 ;
                break
            end
            
            if response == 0
                keypress = secs-start;
                response=1;
            end
            
        end
    end
    
    if flag
        return
    end
    
     TrialStruct.Trials(n).Keypress = keypress;
    
end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Draw fixation cross shock and wait ITI.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ITIstart = GetSecs();
          
    Screen('DrawTexture', TrialStruct.MainWindow, TrialStruct.Stim.(char(TrialStruct.Trials(n).ITIcross)).Texture);
    Screen('Flip',TrialStruct.MainWindow, 0, 0);
    
    if TrialStruct.Trials(n).NodStart == 0
        comp = start;
    else
        comp = NodStart; 
    end
  
    
    
    
    % Record fixation onset time.
    TrialStruct.Trials(n).FixOnset = GetSecs() - TrialStruct.StartTime;
    st = GetSecs();
    
    % If shock is to be delivered...
    if TrialStruct.Trials(n).Shock == 1
        
        % Setup triggers for next segment of trial.
       
        % Record shock onset and write triggers.
        TrialStruct.Trials(n).ShockOnset = GetSecs() - TrialStruct.StartTime;
        
        % Wait and turn off shock.
        timelapse = GetSecs() - st;
        beep
        WaitSecs(ShockTime - timelapse);
        
        
        
        while GetSecs-ITIstart < TrialStruct.Trials(n).ITI
            [keyIsDown, secs, keyCode] = KbCheck(-3);
            
            if keyIsDown
                if keyCode(exitKey)
                    flag=1 ;
                    break
                end
                
                if response == 0
                    keypress = secs-comp;
                    response=1;
                end
                
            end
        end
        
        TrialStruct.Trials(n).Keypress = keypress;
        TrialStruct.Trials(n).FixOffset = GetSecs() - TrialStruct.StartTime;
        
    else
        
        %%%%%% Wait ITI, accounting for computational lag.
        
        while GetSecs-ITIstart < TrialStruct.Trials(n).ITI
            [keyIsDown, secs, keyCode] = KbCheck(-3);
            
            if keyIsDown
                if keyCode(exitKey)
                    flag=1 ;
                    break
                end
                
                if response == 0
                    keypress = secs-comp;
                    response=1;
                end
                
            end
        end
        
        TrialStruct.Trials(n).FixOffset = GetSecs() - TrialStruct.StartTime;
        TrialStruct.Trials(n).Keypress = keypress;
    
    end
    

    
end






