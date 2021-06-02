function TrialStruct = Setup_LabJack( TrialStruct )
% Utility function to setup communication between the LabJack DAQ device
% and the laptop. Uses optika communications tools. Needs to be
% run only once, after calibrating the DAQ with the Instacal program.

addpath('/home/lauri/matlab/downloads/opticka/communication')

lj = labJack('verbrose', true);

if lj.isOpen
    disp('LabJack detected')
    TrialStruct.LabJack = lj;
    lj.ledOFF;
    WaitSecs(0.5);
    lj.ledON

else
    disp('No LabJack detected!')
end


end
