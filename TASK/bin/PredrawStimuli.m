function TrialStruct = PredrawStimuli( TrialStruct , sDir )
% Function to setup presentation of experiment. This includes opening the
% first window, and loading the images (called textures).
%
% NOTE: Assumes a stimuli folder within the subject folder that contains
% all of the images. 

%% Setup screen parameters.

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
StimStruct = dir([sDir filesep '*.jpg']);
Stimuli = {StimStruct.name};

%% Predraw Windows
for n = 1:numel(Stimuli)
    S = [sDir '/' Stimuli{n}]; 
    % Load stimuli.
    Image = imread(S); 
    % Rescale stimuli as needed.
    if max(size(Image)) > max(TrialStruct.Rect)
       scaleX = TrialStruct.xRes / size(Image,2);
       scaleY = TrialStruct.yRes / size(Image,1);
       Image = imresize(Image,min([scaleX scaleY]));    
    end
    
    if max(size(Image)) < max(TrialStruct.Rect)
       scaleX = TrialStruct.xRes / size(Image,2);
       scaleY = TrialStruct.yRes / size(Image,1);
       Image = imresize(Image,max([scaleX scaleY]));    
    end
    
    % Assign pointers to stimuli.
    Fieldname = Stimuli{n}( 1:end-4 );
    TrialStruct.Stim.(Fieldname).Texture = Screen('MakeTexture', ...
                                                    TrialStruct.MainWindow, ...
                                                    Image ); 
    
                                                                                  
end  

end