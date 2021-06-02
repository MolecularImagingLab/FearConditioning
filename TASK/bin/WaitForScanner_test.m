function TrialStruct = WaitForScanner_test( TrialStruct )
% Convenience function to sync experiment with fMRI scanner. Waits to
% receive signal (5) from scanner.

%% Place 'Waiting for scanner...' text on screen. Wait.
%WaitText = 'Waiting for scanner...';
%Screen('TextFont', TrialStruct.MainWindow, 'Helvetica');
%Screen('TextSize', TrialStruct.MainWindow, 24);
%DrawFormattedText(TrialStruct.MainWindow, WaitText, 'center', 'center',...
%                  [255 255 255], 60);
%Screen('Flip',TrialStruct.MainWindow);

% Sample from keyboard. Wait for equals sign. Record start time.
KbName('UnifyKeyNames')
[a,b,c]=GetKeyboardIndices('Current Designs, Inc. Trainer (R1292)')
%devIdx = find(strcmp(b, 'Current Designs, Inc. Trainer (R1292)'))
devIdx = a
keyCode=KbName('7&')
keyCodes = zeros(1, 256);
keyCodes(keyCode) = 1;
KbQueueCreate(devIdx, keyCodes);
secs = KbQueueWait(devIdx);
KbQueueStop(devIdx);
KbQueueRelease(devIdx);

% KbQueueCreate(devIdx)    
% KbQueueStart(devIdx);
% KbQueueFlush(devIdx);
% %while 1
% StartTime=KbQueueWait(devIdx)
% KbStrokeWait(devIdx)
% display('Yay')
% 
% 
% KbTriggerWait(KbName('7&'), devIdx)
% 
% %devIdx =9
% KbQueueCreate(devIdx);  
% %KbQueueFlush(devIdx);
% KbQueueStart(devIdx);
% %While 1 
% %p = KbQueueCheck()
% A=KbQueueWait(devIdx);
% KbWait(-1)
end