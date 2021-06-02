function lj = Setup_LabJack()
% Utility function to setup communication between the LabJack DAQ device
% and the laptop. Uses optika communications tools. Needs to be
% run only once, after calibrating the DAQ with the Instacal program.

addpath('/home/lauri/matlab/downloads/opticka/communication');
    
lj = labJack();

if lj.isOpen
    disp('LabJack detected')
    lj.ledOFF;
    WaitSecs(0.5);
    lj.ledON;

else
    error('No LabJack detected in system!');
end


end
