function [TrialStruct, flag] = RunTrial( TrialStruct, n, lj, isLJ )
% Runs a single trial of the task.

%% Begin timing.
start = GetSecs();

%% Define parameters.
response = 0;
flag=0;
exitKey =  KbName( 'ESCAPE' );
keypress = 0;
accepted = [KbName( '1!' )  KbName( '2@' )  KbName( '3#' )  KbName( '4$' ) KbName( '6^' )  KbName( '7&' )  KbName( '8*' )  KbName( '9(' )];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Draw face. Wait.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Draw first scene. record onset
Screen('DrawTexture', TrialStruct.MainWindow, TrialStruct.Stim.(char(TrialStruct.Trials(n).Stimulus)).Texture);
Screen('Flip',TrialStruct.MainWindow, 0, 0);
TrialStruct.Trials(n).TrialOnset = GetSecs() - TrialStruct.StartTime;

% Trigger by stimulus type
csplus = 'p';
ifcsplus = endsWith(TrialStruct.Trials(n).Stimulus, csplus);
if isLJ
    % CS plus shock
    if ifcsplus == 1 && TrialStruct.Trials(n).Shock == 1;
        lj.timedTTL(1,100);
    % CS plus only
    elseif ifcsplus == 1;
        lj.timedTTL(6,100);
    % CS minus only
    else
        lj.timedTTL(7,100);
    end
end

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

            if response == 0 && sum(keyCode(accepted))
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
    %% in case there is no nod

    while GetSecs-start < TrialStruct.Trials(n).StimTime
        [keyIsDown, secs, keyCode] = KbCheck(-3);

        if keyIsDown
            if keyCode(exitKey)
                flag=1 ;
                break
            end

            if response == 0 && sum(keyCode(accepted))
                keypress = secs-start;
                response=1;
            end

        end
    end

    if flag
        return
    end

    TrialStruct.Trials(n).Keypress = keypress;
    TrialStruct.Trials(n).NodStart = 0;
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

    % If shock is to be delivered...
    if TrialStruct.Trials(n).Shock == 1

        %shock for 500ms
        if isLJ; lj.timedTTL(4,500); end

        % Record shock onset and write triggers.
        TrialStruct.Trials(n).ShockOnset = GetSecs() - TrialStruct.StartTime;

        while GetSecs-ITIstart < TrialStruct.Trials(n).ITI
            [keyIsDown, secs, keyCode] = KbCheck(-3);

            if keyIsDown
                if keyCode(exitKey)
                    flag=1 ;
                    break
                end

                if response == 0 && sum(keyCode(accepted))
                    keypress = secs-comp;
                    response=1;
                end

            end
        end

        TrialStruct.Trials(n).Keypress = keypress;
        TrialStruct.Trials(n).FixOffset = GetSecs() - TrialStruct.StartTime;

    else

        while GetSecs-ITIstart < TrialStruct.Trials(n).ITI
            [keyIsDown, secs, keyCode] = KbCheck(-3);

            if keyIsDown
                if keyCode(exitKey)
                    flag=1 ;
                    break
                end

                if response == 0 && sum(keyCode(accepted))
                    keypress = secs-comp;
                    response=1;
                end

            end
        end

        TrialStruct.Trials(n).FixOffset = GetSecs() - TrialStruct.StartTime;
        TrialStruct.Trials(n).Keypress = keypress;

    end



end
