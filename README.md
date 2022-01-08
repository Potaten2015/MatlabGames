# MatlabGames

This repo contains a group of simple games I recreated in [MATLAB](https://www.mathworks.com/products/matlab.html), just for fun.

### **Render Loop**

The render loop is a while loop that checks for game ending conditions, for example in pong, the while condition is

```
while xPos > -100
```

where xPos is the horizontal position of the ball, and -100 is the paddle position.

The rest of the render loop checks for input, various game conditions (i.e. in snake, if we have gathered any food), and plots the state of the game.

```
% Set up plot to get key input information
set(gcf,'KeyPressFcn',@stroke)
function dir = stroke(src,event)
end

while xPos > -100
    % Update values based on the key being pressed
    dir = get(gcf,'CurrentKey');
    switch dir
        % Update options
    end

    % Clear the figure in preparation of next frame
    clf

    % Use 'plot' for lines
    plot(x,y,'LineWidth',2)

    % Use hold on to keep entities that you just plotted
    hold on

    % 'scatter' for dots
    scatter(xPos,yPos,'filled')

    % Annotations can be used for things like displaying levels or prompts
    annotation('textbox',[.5 .5 .3 .3],'String',lvl,'FitBoxToText','on')
    xlim([-100 100])
    ylim([-100 100])
    hold on

    % Use drawnow to update the figure with new values
    drawnow
end
```

_Note: I just pulled the above script and trimmed it to explain the basics. It may not run as is._

### **Other Stuff**

Building out the rest of the games in MATLAB just comes down to knowing how to represent the entities in the game and how to manipulate those data structures to represent interactions between the entities, and the results of player input.

A few of the scripts also use an arduino analog joystick for player input. This would be nice for a racing game where you would like the player to be able to turn at angles that aren't multiples of 45 degrees, or in pong for slight movements.

### Message me on [LinkedIn](https://www.linkedin.com/in/taten-knight/) with any questions. I'm more likely to answer there ✌️
