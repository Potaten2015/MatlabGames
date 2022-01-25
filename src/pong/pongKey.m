clear all
close all
clc

hs = xlsread('PongHS.xlsx');
hsDisp = num2str(hs);
screensize = get(groot,'Screensize');
dim = [(screensize(3)-screensize(4))/2 0 screensize(4) screensize(4)];
speed = 0;
refresh = 1000;

xPos = 0;
yPos = 0;
xMove = 1;
yMove = rand(1)*-4+2;
barMove = 0;
barPos = 0;
barPosAll = [barPos-20;barPos+20];
barx = ones(2,1)*-100;

lvl = '1';
turn = 1;

plot(barx,barPosAll,'LineWidth',2)
hold on
scatter(xPos,yPos,'filled')
hold on
lvl = compose(['Current: ' num2str(turn) '\n' 'Previous High: ' hsDisp]);
annotation('textbox',[.5 .5 .3 .3],'String',lvl,'FitBoxToText','on')
xlim([-100 100])
ylim([-100 100])
hold on
set(gcf,'position',dim);
set(gcf,'KeyPressFcn',@stroke)
while xPos > -100  
    dir = get(gcf,'CurrentKey');
    switch dir
        case 'uparrow'
            barMove = 5;
            
        case 'downarrow'
            barMove = -5;
            
        otherwise
            barMove = 0;
    end
    
    if barPos+barMove<100 & barPos+barMove>-100
        barPos = barPos + barMove;
        barPosAll = [barPos-20;barPos+20];
    end
    
    if xPos + xMove <= -100 
        if yPos < barPosAll(end) & yPos > barPosAll(1)
            xMove = -xMove;
            turn = turn+1;
            speed = speed+1;
        end
    end
    
    lvlSave = turn;
    lvl = compose(['Current: ' num2str(turn) '\n' 'Previous High: ' hsDisp]);
    
    clf
    plot(barx,barPosAll,'LineWidth',2)
    hold on
    scatter(xPos,yPos,'filled')
    annotation('textbox',[.5 .5 .3 .3],'String',lvl,'FitBoxToText','on')
    xlim([-100 100])
    ylim([-100 100])
    hold on
    pause(1/refresh)
    
    if xPos + xMove + (speed*(abs(xMove)/xMove)) >= 100
        xMove = -xMove;
    end
    if yPos  + yMove + (speed*(abs(yMove)/yMove)) >= 100
        yMove = -yMove;
    end
    if yPos + yMove + (speed*(abs(yMove)/yMove)) <= -100
        yMove = -yMove;
    end
    
    xPos = xPos + xMove + (speed*(abs(xMove)/xMove));
    yPos = yPos + yMove + (speed*(abs(yMove)/yMove));
    
    drawnow
end

if lvlSave > hs
    xlswrite('PongHS.xlsx',lvlSave)
end

function dir = stroke(src,event)
end

function dir2 = stroke2(src,event)
clear gfc.KeyPressFcn
end