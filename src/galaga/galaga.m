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

enemyXStart = ...
    gpuArray([-5 -4 -3;
    -1 0 1;
    3 4 5]);

enemyYStart = ...
    gpuArray([mapSize/2 - 1, mapSize/2 - 2, mapSize/2 - 1]);

enemyYValues = enemyYStart;

enemyRowMove = gpuArray([rand]);

rowValues = containers.Map({1}, {enemyXStart});

totalRows = 1;

bulletsX = gpuArray([]);
bulletsY = gpuArray([]);

xMove = .1;
yMove = 0;

turn = 1;

scatter(xPos,yPos,'filled','b')
hold on
xlim([-mapSize/2 mapSize/2])
ylim([-1 mapSize/2])
hold on
set(gcf,'position',dim);
colors = ['r' 'y' 'k' 'o'];

set(gcf,'KeyPressFcn',@stroke)
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
            if i == 1
                enemyYValues = enemyYValues - 1;
                if enemyYValues(end) - 1 < mapSize - 6
                    totalRows = totalRows + 1;
                    enemyYValues = gpuArray([enemyYValues; enemyYStart]);
                    rowValues(totalRows) = enemyXStart;
                    enemyRowMove = gpuArray([enemyRowMove rand]);
                end
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