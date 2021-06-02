function DrawImage(TrialStruct, n)

% set up text and balls 
baserect = [0 0 30 30];
maxDiameter = max(baserect) * 1.01;
[Xcent, Ycent] = RectCenter(TrialStruct.Rect)
 
textLoc = [Xcent - 280 , Ycent + 440;
    Xcent - 180 , Ycent + 390;
    Xcent + 20, Ycent + 390;
    Xcent + 170 , Ycent +  440];

bL = [textLoc(:,1)+[50,75,50,50]', textLoc(:,2) + 50]

%kB = CenterRectOnPointd(baserect, Xcent, Ycent)
% draw image 
Screen('DrawTexture', TrialStruct.MainWindow, TrialStruct.Stim.(char(TrialStruct.Trials(n).Stimulus)).Texture);
Screen('TextFont', TrialStruct.MainWindow, 'Helvetica');
Screen('TextSize', TrialStruct.MainWindow, 50);
DrawFormattedText(TrialStruct.MainWindow, 'How likely was this face ever followed by a shock?', 'Center', TrialStruct.yRes*0.1, [255 255 255]);

Screen('TextFont', TrialStruct.MainWindow, 'Helvetica');
Screen('TextSize', TrialStruct.MainWindow, 20);
[nx1, ny1, bbox1] = DrawFormattedText(TrialStruct.MainWindow, 'Very unlikely', textLoc(1,1), textLoc(1,2), [255 255 255], 60);
[nx2, ny2, bbox2] = DrawFormattedText(TrialStruct.MainWindow, 'Somewhat unlikely', textLoc(2,1), textLoc(2,2), [255 255 255], 60);
[nx3, ny3, bbox3] = DrawFormattedText(TrialStruct.MainWindow, 'Somewhat likely', textLoc(3,1), textLoc(3,2), [255 255 255], 60);
[nx4, ny4, bbox4] = DrawFormattedText(TrialStruct.MainWindow, 'Very likely', textLoc(4,1), textLoc(4,2), [255 255 255], 60);
save('bbox', 'bbox1','bbox2','bbox3','bbox4')
rB = CenterRectOnPointd(baserect, mean([bbox1(1),bbox1(3)]),textLoc(1,2)+50); rC = [1 0 0];
gB = CenterRectOnPointd(baserect, mean([bbox2(1),bbox2(3)]),textLoc(2,2)+50); gC = [0 1 0];
yB = CenterRectOnPointd(baserect, mean([bbox3(1),bbox3(3)]),textLoc(3,2)+50); yC = [1 1 0];
bB = CenterRectOnPointd(baserect, mean([bbox4(1),bbox4(3)]),textLoc(4,2)+50); bC = [0 0 1];


Screen('FillOval',TrialStruct.MainWindow, rC,rB, maxDiameter);
Screen('FillOval',TrialStruct.MainWindow, gC,gB, maxDiameter);
Screen('FillOval',TrialStruct.MainWindow, yC,yB, maxDiameter);
Screen('FillOval',TrialStruct.MainWindow, bC,bB, maxDiameter);
%Screen('FillOval',TrialStruct.MainWindow, [0,0,0],kB, maxDiameter);
Screen('Flip',TrialStruct.MainWindow, 0, 0);
end
