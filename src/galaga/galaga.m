%% Video 4
%% Matlab Gaming: Galage

clear all
close all
clc

speed = .5;
dir = 0;

screensize = get(groot,'Screensize');
dim = [(screensize(3)-screensize(4))/2 0 screensize(4)/3 screensize(4)/3];

mapSize = 40;

xPos = gpuArray([0 1 2]);
yPos = gpuArray([0 1 0]);
% Contains the x values for the first row of enemies
% # enemies x 3 array, where each of the three values in a row
% represents the horizontal position of each of the points
% on the triangular enemies
enemyXStart = ...
    gpuArray([-5 -4 -3;
    -1 0 1;
    3 4 5]);
% The height at which enemies will ALWAYS start
enemyYStart = ...
    gpuArray([mapSize/2 - 1, mapSize/2 - 2, mapSize/2 - 1]);
% Start the first row at the correct place
enemyYValues = enemyYStart;
% Set the horizontal movement speed of the enemies
% Each entry represents the speed of a single row of enemies
enemyRowMove = gpuArray([rand]);
% Contains the x values for each row of enemies
% One key represents a row of enemies, and the value is:
% # enemies x 3 array, where each of the three values in a row
% represents the horizontal position of each of the points
% on the triangular enemies
rowValues = containers.Map({1}, {enemyXStart});
% Keeps track of the number of rows
totalRows = 1;
% TODO: Keeps track of friendly bullet positions
bulletsX = gpuArray([]);
bulletsY = gpuArray([]);
% Initial movement directions of the player
xMove = .1;
yMove = 0;

scatter(xPos,yPos,'filled','b')
hold on
xlim([-mapSize/2 mapSize/2])
ylim([-1 mapSize/2])
hold on
set(gcf,'position',dim);
colors = ['r' 'y' 'k' 'o'];

set(gcf,'KeyPressFcn',@stroke)

% Try to implement the parfor loop for collision detection. Not sure that
% this is even possible. Collision steps:
% 1. Get row values from object
% 2. Check if leftmost or righmost points have overlapped boundaries
%   - Maybe there is a way to vectorize this check by moving the boundaries
%       into an array and checking the entire array for being greater than
%       the right boundary or less than the left boundary. Maybe ignore
%       step 3 if this is the case and move down on any boundary impact.
%       ** Move all points and check if array > right || array < left 
% 3. If yes, check if the overlapping dot was in the bottom-most row
%   - Need to update bottom-most row in the future when a row is gone


while xPos(1) > -mapSize/2 & ... 
        xPos(end) < mapSize/2
    
    dir = get(gcf,'CurrentKey');

    switch dir
        case 'rightarrow'
            xMove = .1;
            yMove = 0;
        case 'leftarrow'
            xMove = -.1;
            yMove = 0;
    end

    for j = 1:length(xPos)
        xPos(j) = xPos(j) + xMove;
    end
    
    if sum((xPos(end) == xPos(1:end-1)).*(yPos(end) == yPos(1:end-1))) > 0
        xPos(end) = mapSize;
    end
    
    rows = rowValues.keys;
    for i = 1:length(rows)
        row = rowValues(rows{i});
        leftValue = row(1:1, 1);
        rightValue = row(end:end, end);
        if rightValue + enemyRowMove(i) > mapSize / 2 |...
                leftValue + enemyRowMove(i) < - mapSize / 2
            enemyRowMove(i) = -(enemyRowMove(i) + .1);
                enemyYValues = enemyYValues - .2;
            if enemyYValues(end) - 1 < mapSize / 2 - 3
                totalRows = totalRows + 1;
                enemyYValues = gpuArray([enemyYValues; enemyYStart]);
                rowValues(totalRows) = enemyXStart;
                enemyRowMove = gpuArray([enemyRowMove rand]);
            end
        end
        rowValues(i) = rowValues(i) + enemyRowMove(i);
    end
    
    clf
    
    for i = 1:length(rows)
        row = rowValues(rows{i});
        for j = 1:size(row, 1)
            scatter(row(j:j,:), enemyYValues(i:i,:), 'filled', colors(mod(i, length(colors)) + 1))
            hold on
        end
    end
    
    xlim([-mapSize/2 mapSize/2])
    ylim([-1 mapSize/2])
    hold on
    
    scatter(xPos,yPos,'filled','b')
    xlim([-mapSize/2 mapSize/2])
    ylim([-1 mapSize/2])
    hold on    
    
    drawnow
       
end

clf   
xlim([-mapSize/2 mapSize/2])
ylim([-mapSize/2 mapSize/2])
hold on

scatter(xPos,yPos,'filled','b')
annotation('textbox',[.5 .5 .3 .3],'String','BRUH','FitBoxToText','on')
xlim([-mapSize/2 mapSize/2])
ylim([-1 mapSize/2])
hold on

function dir = stroke(src,event)
end