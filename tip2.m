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
    
    %% Find longest plane (relative to 1:1 img dimensions)
    len_ceil = (points(10,1) - points(9,1))/dim(2)
    len_floor = (points(4,1) - points(3,1))/dim(2)
    len_left = (points(5,2) - points(11,2))/dim(1)
    len_right = (points(6,2) - points(12,2))/dim(1)
    
    [a, i] = max([len_left, len_ceil, len_right, len_floor])
    
    
     %% Shorten inner square so length of proper overlap can be calculated
    points_long = zeros([13,2]);
    points_long = points;
    
    switch i
        case 1 % left_len is longest
            %p11, p5
            points_long(9,:) = points(11,:);
            points_long(3,:) = points(5,:);
            
            % Calculate all other points
            x_left = 1;
            y_up = points(11,2);
            y_low = points(5,2);
            points_long(10,2) = y_up;
            points_long(12,2) = y_up;
            points_long(4,2) = y_low;
            points_long(6,2) = y_low;
            
            % Right X Point has to be calculated
            m = (points(8,2) - points(13,2))/(points(8,1)-points(13,1));
            b = points(8,2) - m*points(8,1);
            x_right = (y_up - b)/m; % points(11,2) = y_up
            points_long(10,1) = x_right;
            points_long(12,1) = x_right;
            points_long(4,1) = x_right;
            points_long(6,1) = x_right;
            
        case 2 % ceil_len is longest
            % Set points 11 and 12 to be equal to 9 and 10
            points_long(11,:) = points(9,:);
            points_long(12,:) = points(10,:);
            
            x_left = points(9,1);
            x_right = points(10,1);
            y_up = 1;
            
            points_long(5,1) = x_left;
            points_long(3,1) = x_left;
            points_long(6,1) = x_right;
            points_long(4,1) = x_right;
            
            % Calculate y_low
            m = (points(1,2) - points(13,2))/(points(1,1)-points(13,1));
            b = points(1,2) - m*points(1,1);
            y_low = m*points(9,1) + b;
            points_long(3,2) = y_low;
            points_long(4,2) = y_low;
            points_long(5,2) = y_low;
            points_long(6,2) = y_low;
            
        case 3 % right_len is longest
            %p12, p6
            points_long(10,:) = points(12,:);
            points_long(4,:) = points(6,:);
            
            % Calculate all other points
            x_right = dim(2);
            y_up = points(12,2);
            y_low = points(6,2);
            
            m = (points(7,2) - points(13,2))/(points(7,1)-points(13,1));
            b = points(7,2) - m*points(7,1);
            x_left = (y_up - b)/m; % points(12,2) = y_up
            points_long(11,:) = [x_left, y_up];
            points_long(9,:) = [x_left, y_up];
            points_long(3,:) = [x_left, y_low];
            points_long(5,:) = [x_left, y_low];
            
        case 4 % floor_len is shortest
            % p3, p4
            points_long(5,:) = points(3,:);
            points_long(6,:) = points(4,:);
            
            % Calculate new max coordinates
            x_left = points(3,1);
            x_right = points(4,1);
            y_low = dim(1);
            % Calculate y_up
            m = (points(7,2) - points(13,2))/(points(7,1)-points(13,1));
            b = points(7,2) - m*points(7,1);
            y_up = m*points(3,1) + b;
            
            points_long(9,:) = [x_left, y_up];
            points_long(11,:) = [x_left, y_up];
            points_long(10,:) = [x_right, y_up];
            points_long(12,:) = [x_right, y_up];
            
    end
    
    points_comb = zeros([13,4]);
    points_comb(:,1:2) = points_long;
    points_comb(:,3:4) = points_long;
    points = points_comb;
    
     %% Pad
     [points_pad, img_pad, dim_pad, paddings, alpha] = padPoints(points, img);
     
     hold off;
     close;
     plotLines(points_pad, img_pad);
    
    points = points_pad(:,1:2);
    %% Calculate Depth of shortened walls
    f = 400;
    depth = calcDepth(points(13,:), points(1,:), points(3,:),f);
    d_f = depth;
    d_l = d_f * norm(points(5,1:2) - points(13,1:2))/norm(points(3,1:2)-points(13,1:2));
    d_c = d_l * norm(points(9, 1:2) - points(13,1:2))/norm(points(11,1:2)-points(13,1:2));
    d_r = d_c * norm(points(12, 1:2) - points(13,1:2))/norm(points(10,1:2)-points(13,1:2));
    
    %% Interpolate max depths of walls
    %d_l = depth * (points(1,1) - points(5,1))/(points(1,3) - points(5,3))
    %d_r = depth * (points(6,1) - points(2,1))/(points(6,3) - points(2,3))
    %d_c = depth * (points(7,2) - points(9,2))/(points(7,4) - points(9,4))
    %d_f = depth * (points(3,2) - points(1,2))/(points(3,4) - points(1,4))
   
    
    %% Get textures
    % Background Texture
    tex_bg = img_pad(points(7,2):points(1,2), points(7,1):points(2,1),:);
    bg_dim = size(tex_bg); % Y Dim, X dim
    %figure; imshow(tex_bg);
    
    % Left Texture
    % Create points of new image to map to (ie height and width of the
    % image block)
    mat_l = floor([1,1; 1, bg_dim(1); depth, bg_dim(1); depth, 1;]);
    % Choose polygon from which the block is going to be taken
    points_l = [points(5,1:2); points(11,1:2); points(7,1:2); points(1,1:2)];
    % Generate Homographie Transform between the new image map and the
    % polygon
    tf_l = fitgeotrans(floor(points_l), mat_l, 'projective'); % generate Transform for left texture
    % Transform and create texture
    tex_l = imwarp(img_pad, tf_l, 'OutputView', imref2d([bg_dim(1), floor(depth)])); % Dimensions are defined in imref2d
    tex_l = flip(tex_l, 1);
    tex_l_alpha = imwarp(alpha, tf_l, 'OutputView', imref2d([bg_dim(1), floor(depth)]));
    tex_l_alpha = flip(tex_l_alpha, 1);
    
    % Ceil Texture
    mat_c = floor([1,1; 1, depth; bg_dim(2), depth; bg_dim(2), 1;]);
    points_c = [points(7,1:2); points(9,1:2); points(10,1:2); points(8,1:2)];
    tf_c = fitgeotrans(floor(points_c), mat_c, 'projective'); % generate Transform for left texture
    tex_c = imwarp(img_pad, tf_c, 'OutputView', imref2d([floor(depth), bg_dim(2)])); % Dimensions are defined in imref2d
    tex_c = flip(tex_c, 1); 
    tex_c_alpha = imwarp(alpha, tf_c, 'OutputView', imref2d([floor(depth), bg_dim(2)])); 
    tex_c_alpha = flip(tex_c_alpha,1);
    
    % Right Texture
    mat_r = floor([1,1; 1, bg_dim(1); depth, bg_dim(1); depth, 1;]);
    points_r = [points(2,1:2); points(8,1:2); points(12,1:2); points(6,1:2)];
    tf_r = fitgeotrans(floor(points_r), mat_r, 'projective'); % generate Transform for left texture
    tex_r = imwarp(img_pad, tf_r, 'OutputView', imref2d([bg_dim(1), floor(depth)])); % Dimensions are defined in imref2d
    tex_r = flip(tex_r, 1);
    tex_r_alpha = imwarp(alpha, tf_r, 'OutputView', imref2d([bg_dim(1), floor(depth)])); % Dimensions are defined in imref2d
    tex_r_alpha = flip(tex_r_alpha, 1);

    % Floor Texture
    mat_f = floor([1,1; 1, depth; bg_dim(2), depth; bg_dim(2), 1;]);
    points_f = [points(3,1:2); points(1,1:2); points(2,1:2); points(4,1:2)];
    tf_f = fitgeotrans(floor(points_f), mat_f, 'projective'); % generate Transform for left texture
    tex_f = imwarp(img_pad, tf_f, 'OutputView', imref2d([floor(depth), bg_dim(2)])); % Dimensions are defined in imref2d
    tex_f = flip(tex_f, 1);
    tex_f_alpha = imwarp(alpha, tf_f, 'OutputView', imref2d([floor(depth), bg_dim(2)])); % Dimensions are defined in imref2d
    tex_f_alpha = flip(tex_f_alpha, 1);


    
    %% Draw in 3D
    f = figure;
    xlabel('x'); ylabel('y'); zlabel('z');
    axis on; hold on;
    
    B = bg_dim(2);
    H = bg_dim(1);
    
    %BG
    m_bg = hgtransform('Matrix', makehgtform('translate', [1,1,H], 'xrotate', -pi/2));
    image(m_bg, tex_bg);
    %Left
    m_left = hgtransform('Matrix', makehgtform('translate', [1, -depth, H], 'xrotate', -pi/2, 'yrotate', -pi/2));
    im_l = image(m_left, tex_l);
    im_l.AlphaData = tex_l_alpha;
    
    %Right
    m_right = hgtransform('Matrix', makehgtform('translate', [B,1,H], 'xrotate', -pi/2, 'yrotate', pi/2));
    im_r = image(m_right, tex_r);
    im_r.AlphaData = tex_r_alpha;
    
    %Floor
    m_floor = hgtransform('Matrix', makehgtform('translate', [1,1,1], 'xrotate', pi, 'yrotate', 0));
    im_f = image(m_floor, tex_f);
    im_f.AlphaData = tex_f_alpha;
    
    %Ceiling
    m_ceil = hgtransform('Matrix', makehgtform('translate', [1,-depth,H-1], 'xrotate', 0, 'yrotate', 0));
    im_c = image(m_ceil, tex_c);
    im_c.AlphaData = tex_c_alpha;
    
    max_val = max([B,H, d_l, d_c, d_r, d_f])
    xlim([0,max_val]); ylim([-max_val, 1]); zlim([0, max_val]);
    
    view(3);
    tf = cameratoolbar(f);
    cameratoolbar('SetMode', 'dollyfb');
    camproj('perspective');
    camzoom(0.5);
    axis off;
    
end