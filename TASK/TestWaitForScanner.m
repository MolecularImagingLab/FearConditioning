function TestWaitForScanner()
% Convenience function to sync experiment with fMRI scanner. Waits to
% receive signal (5) from scanner.
KbName('UnifyKeyNames')
%% Place 'Waiting for scanner...' text on screen. Wait.
WaitText = 'Waiting for scanner...';
disp(WaitText)

devIdx=GetKeyboardIndices('Current Designs, Inc. 932');
if isempty(devIdx); devIdx = GetKeyboardIndices('Current Designs, Inc. Trainer (R1292)'); end

keyCode=KbName('5%');
keyCodes = zeros(1, 256);
keyCodes(keyCode) = 1;
KbQueueCreate(devIdx, keyCodes);
StartTime = KbQueueWait(devIdx);
KbQueueStop(devIdx);
KbQueueRelease(devIdx);
end