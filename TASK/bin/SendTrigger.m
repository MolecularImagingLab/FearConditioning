function SendTrigger( TrialStruct, TriggerCode, PortIdx )
%SENDTRIGGERS Summary of this function goes here
%   Detailed explanation goes here

%% Set up trigger code.
% Reverse trigger code.
TriggerCode = fliplr( TriggerCode );
% Write string.
TriggerCode = strrep(num2str(TriggerCode), ' ', '');
% Convert to decimal representation.
TriggerCode = bin2dec(TriggerCode);
%% Write out.
DaqDOut(TrialStruct.DaqIndex, PortIdx, TriggerCode);
end

