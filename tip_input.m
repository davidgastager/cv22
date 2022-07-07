function fig = tip_input(img)
% This function just serves as a simple cli interface. For TIP use the TIP
% function
    close all;
    dim = size(img);
    imshow(img);
    
    hold on;
    % Get Upper Left corner and lower right corners
    [x,y] = ginput(2);
    w = x(2)-x(1);
    h = y(2)-y(1);
    rectangle('Position', [x(1),y(1),w,h], 'EdgeColor', [1,0,0], 'LineWidth', 2);
    % Get Vanishing Point
    [vp1, vp2] = ginput(1);
    plot(vp1, vp2, 'Marker', 'X', 'MarkerSize', 20, 'LineWidth', 4, 'Color', [1,0,0]);
    
    p7 = floor([x(1), y(1)]);
    p2 = floor([x(2), y(2)]);
    vp = floor([vp1, vp2]);
    
    fig = tip(img, vp, p7, p2); % David
    fig2 = box3d(img, vp, p7, p2); % Yan, Shi
    
end

