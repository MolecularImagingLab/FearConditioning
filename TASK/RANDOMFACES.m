function RANDOMFACES
% Run this always first for each participant. This program creates the subject folder, 
% randomizes the face stimuli and copies them to subject's stimulus folder. 

Inputs = inputdlg({'Enter subject ID:'}, 'Input',[1 30]);           
SubjectID = Inputs{1};
mkdir(['DATA/' SubjectID]);
sDir = ['DATA/' SubjectID '/stimuli/'];
mkdir(sDir);

StimPath = [pwd '/stimuli/']; 
StimStruct = dir([StimPath '*.jpg']);
Stimuli = {StimStruct.name};

Stimuli = setdiff(Stimuli, 'ITIwhitecross.jpg');
Origin = cellfun(@(Stimuli) Stimuli(1:4), Stimuli, 'Uniform', 0);
Origin = unique(Origin);
nOrigin = numel(Origin);

copyfile([StimPath 'ITIwhitecross.jpg' ],[sDir 'ITIwhitecross.jpg']);

% New order 
rng('shuffle')
randOrder = Origin(randperm(nOrigin));


for i = 1:nOrigin
    copyfile([StimPath Origin{i} '.jpg'],[sDir randOrder{i} '.jpg']);
    copyfile([StimPath Origin{i} '_1.jpg'],[sDir randOrder{i} '_1.jpg']);
    copyfile([StimPath Origin{i} '_2.jpg'],[sDir randOrder{i} '_2.jpg']);
end

save([sDir 'new_order_of_stimuli.mat'], 'randOrder', 'Origin')

end
