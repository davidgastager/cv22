function out = tip(img)
    %% Inputs
    dim = size(img);
    imshow(img);
    hold on;
    [x,y] = ginput(2);
    w = x(2)-x(1);
    h = y(2)-y(1);
    rectangle('Position', [x(1),y(1),w,h], 'EdgeColor', [1,0,0], 'LineWidth', 2);
    [vp1, vp2] = ginput(1);
    plot(vp1, vp2, 'Marker', 'X', 'MarkerSize', 20, 'LineWidth', 4, 'Color', [1,0,0]);
    
    %% Calculate Intercept Points
    points = zeros(13,2);
    points(1,:) = [x(1), y(2)];
    points(2,:) = [x(2), y(2)];
    points(7,:) = [x(1), y(1)];
    points(8,:) = [x(2), y(1)];
    points(13,:) = [vp1, vp2];
    [points(3,:), points(5,:)] = interceptPoint(points(13,:), points(1,:), dim);
    [points(9,:), points(11,:)] = interceptPoint(points(13,:), points(7,:), dim);
    [points(4,:), points(6,:)] = interceptPoint(points(13,:), points(2,:), dim);
    [points(10,:), points(12,:)] = interceptPoint(points(13,:), points(8,:), dim);
    
    %% Find shortest plane (relative to 1:1 img dimensions)
    len_ceil = (points(10,1) - points(9,1))/dim(2);
    len_floor = (points(4,1) - points(3,1))/dim(2);
    len_left = (points(5,2) - points(11,2))/dim(1);
    len_right = (points(6,2) - points(12,2))/dim(1);
    
    [a, i] = min([len_left, len_ceil, len_right, len_floor])
    
    
    %% Shorten inner square so length of proper overlap can be calculated
    points_short = zeros([13,2]);
    points_short = points;
    switch i
        case 1 % left_len is shortest
            %p11, p5
            points_short(9,:) = points(11,:);
            points_short(3,:) = points(5,:);
            
            % Calculate x Value for short points 4,6,10,12
            points_short(10,2) = points(11,2);
            points_short(12,2) = points(11,2);
            points_short(4,2) = points(5,2);
            points_short(6,2) = points(5,2);
            
            m = (points(8,2) - points(13,2))/(points(8,1)-points(13,1));
            b = points(8,2) - m*points(8,1);
            points_short(10,1) = (points(11,2) - b)/m;
            points_short(12,1) = points_short(10,1);
            points_short(4,1) = points_short(10,1);
            points_short(6,1) = points_short(10,1);

            
        case 2 % ceil_len is shortest
            % Set points 11 and 12 to be equal to 9 and 10
            points_short(11,:) = points(9,:);
            points_short(12,:) = points(10,:);
            
            % Calculate y Value for short points 3,4,5.6
            points_short(3,1) = points(9,1);
            points_short(4,1) = points(10,1);
            points_short(5,1) = points(9,1);
            points_short(6,1) = points(10,1);
            m = (points(1,2) - points(13,2))/(points(1,1)-points(13,1));
            b = points(1,2) - m*points(1,1);
            points_short(3,2) = m*points(9,1) + b;
            points_short(4,2) = points_short(3,2);
            points_short(5,2) = points_short(3,2);
            points_short(6,2) = points_short(3,2);
        case 3 % right_len is shortest
            
            points_short(10,:) = points(12,:);
            points_short(4,:) = points(6,:);
            
            % Calculate x Value for short points 3,5,9,11
            points_short(11,2) = points(12,2);
            points_short(9,2) = points(12,2);
            points_short(3,2) = points(6,2);
            points_short(5,2) = points(6,2);
            
            m = (points(7,2) - points(13,2))/(points(7,1)-points(13,1));
            b = points(7,2) - m*points(7,1);
            points_short(11,1) = (points(12,2) - b)/m;
            points_short(9,1) = points_short(11,1);
            points_short(3,1) = points_short(11,1);
            points_short(5,1) = points_short(11,1);
            
        case 4 % floor_len is shortest
            
            points_short(5,:) = points(3,:);
            points_short(6,:) = points(4,:);
            
            % Calculate y Value for short points 9,10,11,12
            points_short(9,1) = points(3,1);
            points_short(11,1) = points(3,1);
            points_short(10,1) = points(4,1);
            points_short(12,1) = points(4,1);
            m = (points(7,2) - points(13,2))/(points(7,1)-points(13,1));
            b = points(7,2) - m*points(7,1);
            points_short(9,2) = m*points(3,1) + b;
            points_short(10,2) = points_short(9,2);
            points_short(11,2) = points_short(9,2);
            points_short(12,2) = points_short(9,2);
    end
    
    points_comb = zeros([13,4]);
    points_comb(:,1:2) = points;
    points_comb(:,3:4) = points_short;
    points = points_comb;
    
    %% Pad
    [points_pad, img_pad, dim_pad, paddings] = padPoints(points, img);
    
    hold off;
    close;
    plotLines(points_pad, img_pad);
    
    %% Calculate Depth of shortened walls
    f = 1000;
        
    depth = calcDepth(points(13,:), points(1,:), points(3,:),f)
    
    
    
    
end