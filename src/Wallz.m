clear all
close all
clc

screensize = get(groot,'Screensize');
dim = [(screensize(3)-screensize(4))/2 0 screensize(4) screensize(4)];
speed = 0;
refresh = 30;

xPos = 0;
yPos = 0;
xMove = 1;
yMove = rand(1)*-4+2;
wallHit = 0;

color = 'k';
colorKey = 0;
colorKey2 = 'k';
scatter(xPos,yPos,'filled',color)
hold on
xlim([-100 100])
ylim([-100 100])
set(gcf,'position',dim);
hold on 

set(gcf,'KeyPressFcn',@stroke)
while xPos > -100 & ... 
        xPos < 100 & ...
        yPos > -100 &...
        yPos < 100  
        
    clf
    hold on
    scatter(xPos,yPos,100,'filled',color)
    xlim([-100 100])
    ylim([-100 100])
    hold on
    plot([-100 -100 100 100 -100],[100 -100 -100 100 100],colorKey2,...
        'LineWidth',4)
    hold on
    pause(1/refresh)
    
    colorKey = get(gcf,'CurrentKey');
    
    switch colorKey
        case 'downarrow'
            colorKey2 = 'k';
            
        case 'uparrow'
            colorKey2 = 'g';
            
        case 'rightarrow'
            colorKey2 = 'b';
            
        case 'leftarrow'
            colorKey2 = 'r';
            
        otherwise
            colorKey2 = 'k';
    end
    
    if colorKey2 == color
        impact = 1;
    else
        impact = 0;
    end
    
    if xPos + xMove + (speed*(abs(xMove)/xMove)) >= 100 & (impact == 1) 
        xMove = -xMove;
        color = floor(rand(1)*3.99);
        wallHit = 1;
    end
    if xPos + xMove + (speed*(abs(xMove)/xMove)) <= -100 & (impact == 1) 
        xMove = -xMove;
        color = floor(rand(1)*3.99);
        wallHit = 1;
    end
    if yPos  + yMove + (speed*(abs(yMove)/yMove)) >= 100 & (impact == 1) 
        yMove = -yMove;
        color = floor(rand(1)*3.99);
        wallHit = 1;
    end
    if yPos + yMove + (speed*(abs(yMove)/yMove)) <= -100 & (impact == 1) 
        yMove = -yMove;
        color = floor(rand(1)*3.99);
        wallHit = 1;
    end
    
    if wallHit == 1
        switch color
            case 0
                color = 'r';
                wallHit = 0;
                speed = speed+.5;
            case 1
                color = 'g';
                wallHit = 0;
                speed = speed+.5;
            case 2
                color = 'b';
                wallHit = 0;
                speed = speed+.5;
            case 3 
                color = 'k';
                wallHit = 0;
                speed = speed+.5;
        end
    end
    
    xPos = xPos + xMove + (speed*(abs(xMove)/xMove));
    yPos = yPos + yMove + (speed*(abs(yMove)/yMove));

    drawnow
end



close all

function dir = stroke(src,event)
end