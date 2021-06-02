function [TrialStruct, response, keypress] = nod( TrialStruct, n, response, NodStart, keypress )

%% Define parameters.
StimTime = 0.1; % Duration of each nod image (in seconds)
%keypress = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Draw first nod.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Screen('DrawTexture', TrialStruct.MainWindow, TrialStruct.Stim.(char(TrialStruct.Trials(n).Nod1)).Texture);
Screen('Flip',TrialStruct.MainWindow, 0, 0);

timelapse = GetSecs() - NodStart;

PollTime = GetSecs();
while GetSecs-PollTime < (StimTime - timelapse)
    [keyIsDown, secs, keyCode] = KbCheck(-3);
    
    if keyIsDown
      
            if response == 0
                keypress = secs-NodStart;
                response=1;
            end
      
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Draw second nod.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
st = GetSecs();
Screen('DrawTexture', TrialStruct.MainWindow, TrialStruct.Stim.(char(TrialStruct.Trials(n).Nod2)).Texture);
Screen('Flip',TrialStruct.MainWindow, 0, 0);
timelapse = GetSecs() - st;

PollTime = GetSecs();
while GetSecs-PollTime < (StimTime - timelapse)
    [keyIsDown, secs, keyCode] = KbCheck(-3);
    
    if keyIsDown
      
            if response == 0
                keypress = secs-NodStart;
                response=1;
            end
   
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Draw third nod.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
st = GetSecs();
Screen('DrawTexture', TrialStruct.MainWindow, TrialStruct.Stim.(char(TrialStruct.Trials(n).Nod1)).Texture);
Screen('Flip',TrialStruct.MainWindow, 0, 0);
timelapse = GetSecs() - st;

PollTime = GetSecs();
while GetSecs-PollTime < (StimTime - timelapse)
    [keyIsDown, secs, keyCode] = KbCheck(-3);
    
    if keyIsDown
      
            if response == 0
                keypress = secs-NodStart;
                response=1;
            end
       
    end
end

end