%% Video 3
%% Matlab Gaming: dottleJump

clear all
close all
clc

screensize = get(groot,'Screensize');
dim = [(screensize(3)-screensize(4))/2 0 screensize(4) screensize(4)];

size = 40;

%% Create Jumping Pads
bottom = 0;
top = bottom+20;
v = 0;

pad1X1 = 0;
pad1X2 = 50;
pad1Y = 0;

pad2X1 = rand(1)*45;
pad2X2 = pad2X1+5;
pad2Y = (rand(1)*10.5) + bottom;

pad3X1 = rand(1)*45;
pad3X2 = pad3X1+5;
pad3Y = (rand(1)*15) + bottom;

pad4X1 = rand(1)*45;
pad4X2 = pad4X1+5;
pad4Y = (rand(1)*15) + bottom;

pad5X1 = rand(1)*45;
pad5X2 = pad5X1+5;
pad5Y = (rand(1)*15) + bottom;

padXAll = [pad1X1 pad2X1 pad3X1 pad4X1 pad5X1;...
    pad1X2 pad2X2 pad3X2 pad4X2 pad5X2];

padYAll = [pad1Y pad2Y pad3Y pad4Y pad5Y];

[padYAll ind] = sort(padYAll,2);
padXAll = padXAll(:,ind);

xPos = 25;
yPos = .1;

xMove = 0;
yMove = 1;

plot(padXAll(:,1),[pad1Y pad1Y],'LineWidth',2)
hold on

plot(padXAll(:,2),[pad2Y pad2Y],'LineWidth',2)
hold on

plot(padXAll(:,3),[pad3Y pad3Y],'LineWidth',2)
hold on

plot(padXAll(:,4),[pad4Y pad4Y],'LineWidth',2)
hold on

plot(padXAll(:,5),[pad5Y pad5Y],'LineWidth',2)
hold on

scatter(xPos,yPos,'filled')
hold on

xlim([0 50]);
ylim([bottom top]);

set(gcf,'position',dim);

u = 0;
rep = 0;

bounce = 1;
oldBottom = bottom;

jumpHeight = [];
while yPos >= bottom-1

    rep = rep+1;
    
    u = u + .1;
    
    set(gcf,'KeyPressFcn',@stroke)
    dir = get(gcf,'CurrentKey');
    
    switch dir
        case 'leftarrow'
            xMove = -1.5;
            
        case 'rightarrow'
            xMove = 1.5;
            
        otherwise
            xMove = 0;
    end
    
    for i = 5:-1:1
        if (yPos > padYAll(i)) & ((yPos+yMove) < padYAll(i)) &...
            ((xPos <= padXAll(2,i) & xPos >= padXAll(1,i))|...
                    (xPos+xMove <= padXAll(2,i) & xPos+xMove >= padXAll(1,i)))
                bounce = 1;
                oldBottom = bottom;
                bottom = padYAll(i);
                yPos = bottom;
                top = bottom+20;
                for j = 1:i-1
                    if j == 1
                        padYAll(j) = (rand(1)*10.5)+bottom;
                    else
                        padYAll(j) = (rand(1)*15)+bottom;
                    end  
                    padXAll(1,j) = rand(1)*45;
                    padXAll(2,j) = padXAll(1,j)+5;
                end
                
                [padYAll ind] = sort(padYAll,2);
                padXAll = padXAll(:,ind);
                break
        end
    end
    jumpHeight(end+1) = yPos-bottom;
    if bounce == 1
        bounceHeight = max(jumpHeight);
        jumpHeight = [];
        screenMove = 1;
        u = .1;
        v = 15;
        yMove = (.1)*v;
        bounce = 0;
    else
        v = -(2*u) + v;
        yPos = yPos + yMove;
        yMove = (.1)*v;
    end
    
    if (xPos + xMove) > 50
        xPos = xPos+xMove-50;
    elseif (xPos + xMove) < 0
        xPos = xPos+xMove+50;
    else
        xPos = xPos + xMove;
    end
    
    clf
    
    plot(padXAll(:,1),[padYAll(1) padYAll(1)],'LineWidth',2)
    hold on
    
    plot(padXAll(:,2),[padYAll(2) padYAll(2)],'LineWidth',2)
    hold on
    
    plot(padXAll(:,3),[padYAll(3) padYAll(3)],'LineWidth',2)
    hold on
    
    plot(padXAll(:,4),[padYAll(4) padYAll(4)],'LineWidth',2)
    hold on
    
    plot(padXAll(:,5),[padYAll(5) padYAll(5)],'LineWidth',2)
    hold on
    
    scatter(xPos,yPos,'filled')
    xlim([0 50]);
    title('DotJump')
    lvl = compose(['Height: ' num2str(bottom)]);
    annotation('textbox',[.5 .5 .3 .3],'String',lvl,'FitBoxToText','on')
    
    if yMove <= 0
        screenMove = 0;
    end
    
    if (screenMove == 1) && ((oldBottom + yMove) < bottom)
        ylim([oldBottom+yMove oldBottom+yMove+20])
        oldBottom = oldBottom+yMove;
    else
        ylim([bottom-.1 top-.1])
    end
    
    hold on
    
    if rep == 1
        pause(5)
    end
    
    drawnow
       
end

function dir = stroke(src,event)
end
