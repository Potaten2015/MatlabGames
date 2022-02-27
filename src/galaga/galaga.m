%% Video 4
%% Matlab Gaming: Galaga

clear all
close all
clc

speed = .5;
dir = 0;

screensize = get(groot,'Screensize');
dim = [(screensize(3)-screensize(4))/2 0 screensize(4)/3 screensize(4)/3];

mapSize = 40;

xPos = [0 1 2];
yPos = [0 1 0];
% Contains the x values for the first row of enemies
% # enemies x 3 array, where each of the three values in a row
% represents the horizontal position of each of the points
% on the triangular enemies
enemyXStart = [-5 -4 -3;
    -1 0 1;
    3 4 5];
% The height at which enemies will ALWAYS start
enemyYStart = ...
    [mapSize/2 - 1, mapSize/2 - 2, mapSize/2 - 1];
% Start the first row at the correct place
enemyYValues = containers.Map({1},{enemyYStart});
% Set the horizontal movement speed of the enemies
% Each entry represents the speed of a single row of enemies
enemyRowMove = [rand];
% Contains the x values for each row of enemies
% One key represents a row of enemies, and the value is:
% # enemies x 3 array, where each of the three values in a row
% represents the horizontal position of each of the points
% on the triangular enemies
rowValues = containers.Map({1}, {enemyXStart});
% Keeps track of the number of rows
totalRows = 1;
% TODO: Keeps track of friendly bullet positions
bulletsX = [];
bulletsY = [];
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


% LAST UPDATE
% Converted x and y enemy values to maps.
% Added bullets
% Added bullet impact (broken)
% NEXT UPDATE
% Error check.
% Dial in player speed, bullet speed, enemy speed.
% Fix the impact function

while xPos(1) > -mapSize/2 & ... 
        xPos(end) < mapSize/2
    
    dir = get(gcf,'CurrentKey');

    bulletsY = bulletsY + 1;
    exitBullets = bulletsY > mapSize / 2;
    bulletsY(exitBullets) = [];
    bulletsX(exitBullets) = [];
    
    switch dir
        case 'rightarrow'
            xMove = .1;
            yMove = 0;
        case 'leftarrow'
            xMove = -.1;
            yMove = 0;
        case 'space'
            if isempty(bulletsY)
                bulletsX(end + 1) = xPos(2);
                bulletsY(end + 1) = yPos(2) + 1;
            else
                if bulletsY(end) > 2
                    bulletsX(end + 1) = xPos(2);
                    bulletsY(end + 1) = yPos(2) + 1;
                end
            end   
    end

    xPos = xPos + xMove;
    
    rows = rowValues.keys;
    for i = 1:length(rows)
        row = rowValues(rows{i});
        erasedEnemies = [];
        erasedBullets = [];
        for j = 1:length(row(:, 1))
            for k = 1:length(bulletsY)
                yValues = enemyYValues(rows{i});
                if yValues(1) > bulletsY(k) & yValues(2) < bulletsY(k)
                    if enemyDestroyed(yValues(1), row(j,1), row(j,3), yValues(2), bulletsX(k), bulletsY(k))
                        erasedBullets(end + 1) = k;
                        erasedEnemies(end + 1) = j;
                    end
                end
            end
        end
        bulletsX(erasedBullets) = [];
        bulletsY(erasedBullets) = [];
        row(erasedEnemies, :) = [];
        if isempty(row)
            remove(enemyYValues,i);
            remove(rowValues, i);
        else
            rowValues(i) = row;
            leftValue = row(1:1, 1);
            rightValue = row(end:end, end);
            if rightValue + enemyRowMove(i) > mapSize / 2 |...
                    leftValue + enemyRowMove(i) < - mapSize / 2
                enemyRowMove(i) = -(enemyRowMove(i) * 1.1);
                innerRows = rowValues.keys;
                for l = 1:length(innerRows)
                    enemyYValues(innerRows{i}) = enemyYValues(innerRows{i}) - .2;
                end
            end
            rowValues(i) = rowValues(i) + enemyRowMove(i);
        end
    end
    
    rows = rowValues.keys;
    if ~isempty(enemyYValues)
        if enemyYValues(rows{length(rows)}) < mapSize / 2 - 3
            totalRows = rows{length(rows)} + 1;
            enemyYValues(totalRows) = enemyYStart;
            rowValues(totalRows) = enemyXStart;
            enemyRowMove = [enemyRowMove rand];
        end
    else
        totalRows = 1;
        enemyYValues(totalRows) = enemyYStart;
        rowValues(totalRows) = enemyXStart;
        enemyRowMove = [rand];
    end
    
    clf
    innerRows = rowValues.keys;
    if ~isempty(rowValues.keys)
        for i = 1:length(innerRows)
            row = rowValues(innerRows{i});
            for j = 1:size(row, 1)
                scatter(row(j:j,:), enemyYValues(innerRows{i}), 'filled', colors(mod(i, length(colors)) + 1))
                hold on
            end
        end
    end
    
    scatter(bulletsX, bulletsY)
    hold on
    
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