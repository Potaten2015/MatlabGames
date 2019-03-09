%% Video 2
%% Matlab Gaming: Snake

clear all
close all
clc

screensize = get(groot,'Screensize');
dim = [(screensize(3)-screensize(4))/2 0 screensize(4) screensize(4)];

size = 40;

a = arduino;

xPos = [0 1 2];
yPos = [0 0 0];
xMove = 1;
yMove = 0;

L = 'You played yourself bud';
turn = 1;

foodX = round((rand(1)*(size/2-1)+(rand(1)*-(size/2-1))),0);
foodY = round((rand(1)*(size/2-1)+(rand(1)*-(size/2-1))),0);

scatter(xPos,yPos,'filled','b')
hold on
scatter(foodX,foodY,'filled','r')
xlim([-size/2 size/2])
ylim([-size/2 size/2])
hold on
set(gcf,'position',dim);

while xPos(end) > -size/2 & ... 
        xPos(end) < size/2 & ...
        yPos(end) > -size/2 &...
        yPos(end) < size/2
    
    y1 = readVoltage(a,'A1');
    x1 = readVoltage(a,'A2');
    
    if (y1 > 3) & ((y1 > 5 - x1)|(y1 > x1)) & yMove ~= 1
        xMove = 0;
        yMove = -1;
    elseif (y1 < 2) & ((5 - y1 > x1)|(y1 < x1)) & yMove ~= -1
        xMove = 0;
        yMove = 1;
    elseif (x1 > 3) & ((x1 > y1)|(x1 > 5-y1)) & xMove ~= -1
        xMove = 1;
        yMove = 0;
    elseif (x1 < 2) & ((5 - x1 > y1)|(x1 < y1)) & xMove ~= 1
        xMove = -1;
        yMove = 0;
    end
    
    xPrev = xPos;
    yPrev = yPos;
    
    if [xPos(end) yPos(end)] == [foodX foodY]
        foodX = round((rand(1)*(size/2-1)+(rand(1)*-(size/2-1))),0);
        foodY = round((rand(1)*(size/2-1)+(rand(1)*-(size/2-1))),0);
        xPos(end+1) = xPos(end) + xMove;
        yPos(end+1) = yPos(end) + yMove;
        xPos(1:end-2) = xPrev(2:end);
        yPos(1:end-2) = yPrev(2:end);
    else
        xPos(end) = xPos(end) + xMove;
        yPos(end) = yPos(end) + yMove;
        xPos(1:end-1) = xPrev(2:end);
        yPos(1:end-1) = yPrev(2:end);
    end
    
    if sum((xPos(end) == xPos(1:end-1)).*(yPos(end) == yPos(1:end-1))) > 0
        xPos(end) = size;
    end
    
    clf   
    scatter(foodX,foodY,'filled','r')
    xlim([-size/2 size/2])
    ylim([-size/2 size/2])
    hold on
    
    scatter(xPos,yPos,'filled','b')
    xlim([-size/2 size/2])
    ylim([-size/2 size/2])
    hold on    
    
    pause(.01)
       
end

clf   
scatter(foodX,foodY,'filled','r')
xlim([-size/2 size/2])
ylim([-size/2 size/2])
hold on

scatter(xPos,yPos,'filled','b')
annotation('textbox',[.5 .5 .3 .3],'String',L,'FitBoxToText','on')
xlim([-size/2 size/2])
ylim([-size/2 size/2])
hold on
