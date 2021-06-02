function testing_labjack(varargin)
% testing labJack connection and optionally stimulation
addpath([pwd '/bin']);
clear lj;

lj = Setup_LabJack;
lj.timedTTL(1,1000);
lj.timedTTL(0,1000);
if nargin == 1 && strcmp(varargin{1},'stim')
    disp('testing stimulation');
    WaitSecs(0.5) 
    lj.timedTTL(4,500);
end

end

