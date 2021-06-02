function TrialStruct = WaitForScanner( TrialStruct )
% Convenience function to sync experiment with fMRI scanner. Waits to
% receive signal (5) from scanner.

%% Place 'Waiting for scanner...' text on screen. Wait.
WaitText = 'Waiting for scanner...';
Screen('TextFont', TrialStruct.MainWindow, 'Helvetica');
Screen('TextSize', TrialStruct.MainWindow, 24);
DrawFormattedText(TrialStruct.MainWindow, WaitText, 'center', 'center',...
                  [255 255 255], 60);
Screen('Flip',TrialStruct.MainWindow);
KbName('UnifyKeyNames')
devIdx=GetKeyboardIndices('Current Designs, Inc. 932');
keyCode=KbName('5%');
keyCodes = zeros(1, 256);
keyCodes(keyCode) = 1;
KbQueueCreate(devIdx, keyCodes);
TrialStruct.StartTime = KbQueueWait(devIdx);
KbQueueStop(devIdx);
KbQueueRelease(devIdx);
end