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
    
    points = points_pad;
    %% Calculate Depth of shortened walls
    f = 400;
        
    depth = calcDepth(points(13,:), points(1,:), points(3,:),f)
    
    %% Interpolate max depths of walls
    d_l = depth * (points(1,1) - points(5,1))/(points(1,3) - points(5,3));
    d_r = depth * (points(6,1) - points(2,1))/(points(6,3) - points(2,3));
    d_c = depth * (points(7,2) - points(9,2))/(points(7,4) - points(9,4));
    d_f = depth * (points(3,2) - points(1,2))/(points(3,4) - points(1,4));
    
    
    %% Set world coordinates
%     points_w = zeros([13,5]);
%     points_w(:,1:4) = points;
%     points 1,2,7,8 will have 0 as z coordinate, rest is set to d vals
%     points_w(5,5) = d_l; points_w(11,5) = d_l;
%     points_w(9,5) = d_c; points_w(10,5) = d_c;
%     points_w(12,5) = d_r; points_w(6,5) = d_r;
%     points_w(3,5) = d_f; points_w(4,5) = d_f;
%     
    %% Get textures
    % Background Texture
    tex_bg = img_pad(points(7,2):points(1,2), points(7,1):points(2,1),:);
    bg_dim = size(tex_bg); % Y Dim, X dim
    %figure; imshow(tex_bg);
    
    % Left Texture
    % Create points of new image to map to (ie height and width of the
    % image block)
    mat_l = floor([0,0; 0, bg_dim(1); depth, bg_dim(1); depth, 0;]);
    % Choose polygon from which the block is going to be taken
    points_l = [points(7,3:4); points(1,3:4); points(5,3:4); points(11,3:4)];
    % Generate Homographie Transform between the new image map and the
    % polygon
    tf_l = fitgeotrans(floor(points_l), mat_l, 'projective'); % generate Transform for left texture
    % Transform and create texture
    tex_l = imwarp(img_pad, tf_l, 'OutputView', imref2d([bg_dim(1), floor(depth)])); % Dimensions are defined in imref2d
    tex_l = flip(tex_l, 2);
    
    % Do the same for the non overlapping (=black triangle) part
    tex_l_ext = 0;
    if (d_l - depth > 0)
        mat_l_ext = floor([0,0; 0, bg_dim(1); d_l - depth, bg_dim(1); d_l - depth, 0]);
        points_l_ext = [points(5,1:2); points(11,1:2); points(11,3:4); points(5,3:4)];
        tf_l_ext = fitgeotrans(floor(points_l_ext), mat_l_ext, 'projective');
        tex_l_ext = imwarp(img_pad, tf_l_ext, 'OutputView', imref2d([bg_dim(1), floor(d_l - depth)]));
        tex_l_ext = flip(tex_l_ext);
    end
    
    % Ceil Texture
    mat_c = floor([0,0; 0, depth; bg_dim(2), depth; bg_dim(2), 0;]);
    points_c = [points(7,3:4); points(9,3:4); points(10,3:4); points(8,3:4)];
    tf_c = fitgeotrans(floor(points_c), mat_c, 'projective'); % generate Transform for left texture
    tex_c = imwarp(img_pad, tf_c, 'OutputView', imref2d([floor(depth), bg_dim(2)])); % Dimensions are defined in imref2d
    tex_c = flip(tex_c, 1);
    
    tex_c_ext = 0;
    if (d_c - depth > 0)
        mat_c_ext = floor([0,0; 0, d_c - depth; bg_dim(2), d_c - depth; bg_dim(2), 0;]);
        points_c_ext = [points(9,3:4); points(9,1:2); points(10,1:2); points(10,3:4)];
        tf_c_ext = fitgeotrans(floor(points_c_ext), mat_c_ext, 'projective');
        tex_c_ext = imwarp(img_pad, tf_c_ext, 'OutputView', imref2d([floor(d_c - depth), bg_dim(2)]));
        tex_c_ext = flip(tex_c_ext);
        %figure; imshow(tex_c); figure, imshow(tex_c_ext);
    end
    
    % Right Texture
    mat_r = floor([0,0; 0, bg_dim(1); depth, bg_dim(1); depth, 0;]);
    points_r = [points(2,3:4); points(8,3:4); points(12,3:4); points(6,3:4)];
    tf_r = fitgeotrans(floor(points_r), mat_r, 'projective'); % generate Transform for left texture
    tex_r = imwarp(img_pad, tf_r, 'OutputView', imref2d([bg_dim(1), floor(depth)])); % Dimensions are defined in imref2d
    tex_r = flip(tex_r, 1);
    
    tex_r_ext = 0;
    if (d_r - depth > 0)
        mat_r_ext = floor([0,0; 0, bg_dim(1); d_r - depth, bg_dim(1); d_r - depth, 0]);
        points_r_ext = [points(6,3:4); points(12,3:4); points(12,1:2); points(6,1:2)];
        tf_r_ext = fitgeotrans(floor(points_r_ext), mat_r_ext, 'projective');
        tex_r_ext = imwarp(img_pad, tf_r_ext, 'OutputView', imref2d([bg_dim(1), floor(d_r - depth)]));
        tex_r_ext = flip(tex_r_ext);
        %figure; imshow(tex_r); figure, imshow(tex_r_ext);
    end
    
    
    % Floor Texture
    mat_f = floor([0,0; 0, depth; bg_dim(2), depth; bg_dim(2), 0;]);
    points_f = [points(3,3:4); points(1,3:4); points(2,3:4); points(4,3:4)];
    tf_f = fitgeotrans(floor(points_f), mat_f, 'projective'); % generate Transform for left texture
    tex_f = imwarp(img_pad, tf_f, 'OutputView', imref2d([floor(depth), bg_dim(2)])); % Dimensions are defined in imref2d
    tex_f = flip(tex_f, 1);
    
    tex_f_ext = 0;
    if (d_f - depth > 0)
        mat_f_ext = floor([0,0; 0, d_f - depth; bg_dim(2), d_f - depth; bg_dim(2), 0;]);
        points_f_ext = [points(3,1:2); points(3,3:4); points(4,3:4); points(4,1:2)];
        tf_f_ext = fitgeotrans(floor(points_f_ext), mat_f_ext, 'projective');
        tex_f_ext = imwarp(img_pad, tf_f_ext, 'OutputView', imref2d([floor(d_f - depth), bg_dim(2)]));
        tex_f_ext = flip(tex_f_ext);
        %figure; imshow(tex_f); figure, imshow(tex_f_ext);
    end
    
    
    %% Draw in 3D
    
    figure;
    xlabel('x'); ylabel('y'); zlabel('z');
    axis on; hold on;
    
    B = bg_dim(2);
    H = bg_dim(1);
    
    % BG
    m_bg = hgtransform('Matrix', makehgtform('translate', [0,0,H], 'xrotate', -pi/2));
    image(m_bg, tex_bg);
    % Left
    m_left = hgtransform('Matrix', makehgtform('translate', [1, -depth, H], 'xrotate', -pi/2, 'yrotate', -pi/2));
    image(m_left, tex_l);
    m_left_ext = hgtransform('Matrix', makehgtform('translate', [1, -(d_l-1), H], 'xrotate', -pi/2, 'yrotate', -pi/2));
    image(m_left_ext, tex_l_ext);
    % Right
    m_right = hgtransform('Matrix', makehgtform('translate', [B,0,H], 'xrotate', -pi/2, 'yrotate', pi/2));
    image(m_right, tex_r);
    m_right_ext = hgtransform('Matrix', makehgtform('translate', [B,-depth,H], 'xrotate', -pi/2, 'yrotate', pi/2));
    image(m_right_ext, tex_r_ext);
    % Floor
    m_floor = hgtransform('Matrix', makehgtform('translate', [0,0,0], 'xrotate', pi, 'yrotate', 0));
    image(m_floor, tex_f);
    m_floor_ext = hgtransform('Matrix', makehgtform('translate', [0,-depth,0], 'xrotate', pi, 'yrotate', 0));
    image(m_floor_ext, tex_f_ext);
    % Ceiling
    m_ceil = hgtransform('Matrix', makehgtform('translate', [0,-depth,H-1], 'xrotate', 0, 'yrotate', 0));
    image(m_ceil, tex_c);
    m_ceil_ext = hgtransform('Matrix', makehgtform('translate', [0,-d_c,H-1], 'xrotate', 0, 'yrotate', 0));
    image(m_ceil_ext, tex_c_ext);
    
    max_val = max([B,H, d_l, d_c, d_r, d_f])
    xlim([0,max_val]); ylim([-max_val, 0]); zlim([0, max_val]);
    
    view(3);
    
end