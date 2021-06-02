function TrialStruct = PredrawStimuli_recall( TrialStruct , sDir)
% Function to setup presentation of experiment. This includes opening the
% first window, and loading the images (called textures).
%
% NOTE: Assumes a stimuli folder within the experiment folder that contains
% all of the images. 

% Get the screen numbers
screens = Screen('Screens');
screenNumber = max(screens);
TrialStruct.Black = BlackIndex(screenNumber);
TrialStruct.White = WhiteIndex(screenNumber);
TrialStructure.Grey = TrialStruct.White/ 2;

[TrialStruct.MainWindow, TrialStruct.Rect] = PsychImaging('OpenWindow', screenNumber, TrialStructure.Grey);

Screen('BlendFunction', TrialStruct.MainWindow, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
[TrialStruct.xRes, TrialStruct.yRes] = Screen('WindowSize', TrialStruct.MainWindow);
                                    
%% Locate stimuli in folder. 

StimStruct = dir([sDir '/*.jpg']);
Stimuli = {StimStruct.name};

%% Predraw Windows
for n = 1:numel(Stimuli)
    StimPath = [sDir, Stimuli{n} ]; 
    % Load stimuli.
    Image = imread(StimPath, 'jpg'); 
    % Rescale stimuli to 75% of the screen size
    scale60 = TrialStruct.Rect * .60;
    if max(size(Image)) > max(scale60)
       scaleX = scale60(3) / size(Image,2);
       scaleY = scale60(4) / size(Image,1);
       Image = imresize(Image,min([scaleX scaleY]));    
    end
    
    if max(size(Image)) < max(scale60)
       scaleX = scale60(3) / size(Image,2);
       scaleY = scale60(4) / size(Image,1);
       Image = imresize(Image,max([scaleX scaleY]));    
    end
    
    % Assign pointers to stimuli.
    Fieldname = Stimuli{n}( 1:end-4 );
    TrialStruct.Stim.(Fieldname).Texture = Screen('MakeTexture', ...
                                                    TrialStruct.MainWindow, ...
                                                    Image ); 
    
                                                                                  
end  

end