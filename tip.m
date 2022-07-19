function fig = tip(img, vp, p7, p2, varargin)

    parser = inputParser;
    parser.FunctionName = 'tip';

    parser.addRequired('img');
    parser.addRequired('vp', @isnumeric);
    parser.addRequired('p7', @isnumeric);
    parser.addRequired('p2', @isnumeric);
    parser.addParameter('useAlpha', false);
    parser.addParameter('fgMask', false);
    parser.addParameter('f', 400);

    parser.parse(img, vp, p7, p2, varargin{:});
    
    img = parser.Results.img;
    vp = parser.Results.vp;
    p7 = parser.Results.p7;
    p2 = parser.Results.p2;
    use_alpha = parser.Results.useAlpha;
    mask = parser.Results.fgMask;
    f = parser.Results.f;
    addpath('Helper_Functions')
    
    
    %% Add foreground elements
    if size(mask,1) > 1
        % Calculate bounding box around mask
        mask_col_means = mean(mask,1);
        mask_row_means = mean(mask,2);
        % find min and max
        m_left = find(mask_col_means, 1);
        m_right = find(mask_col_means, 1, 'last');
        m_up = find(mask_row_means,1);
        m_down = find(mask_row_means,1, 'last');

        rectangle('Position', [m_left,m_up,m_right-m_left,m_down-m_up], 'EdgeColor', [1,0,0], 'LineWidth', 2);

        mask_img = img(m_up:m_down, m_left:m_right, :);
        mask_crop = mask(m_up:m_down, m_left:m_right);
        %figure, imshow(mask_img), figure, imshow(mask_crop)
        point_mask = [m_left, m_down];

        if m_down < p2(2)
            error('Object to be removed has to be connected to ground plane');
            mask = false
        else
            %% Inpaint image
            img = inpaintExemplar(img,mask);
        end
    end
    
    
    

    %% Calculate Intercept Points
    dim = size(img);
    points = zeros(13,2);
    
    points(1,:) = [p7(1), p2(2)];
    points(2,:) = p2;%[x(2), y(2)];
    points(7,:) = p7;%[x(1), y(1)];
    points(8,:) = [p2(1), p7(2)];
    points(13,:) = [vp(1), vp(2)];
    [points(3,:), points(5,:)] = interceptPoint(points(13,:), points(1,:), dim);
    [points(9,:), points(11,:)] = interceptPoint(points(13,:), points(7,:), dim);
    [points(4,:), points(6,:)] = interceptPoint(points(13,:), points(2,:), dim);
    [points(10,:), points(12,:)] = interceptPoint(points(13,:), points(8,:), dim);
    
    %% Find longest plane (relative to 1:1 img dimensions)
    len_ceil = (points(10,1) - points(9,1))/dim(2);
    len_floor = (points(4,1) - points(3,1))/dim(2);
    len_left = (points(5,2) - points(11,2))/dim(1);
    len_right = (points(6,2) - points(12,2))/dim(1);
    
    [a, i] = max([len_left, len_ceil, len_right, len_floor]);
    
    
     %% Extend points to all be on maximum depth rectangle parallel to BG
     points_long = points;
    
    switch i
        case 1 % left_len is longest
            %p11, p5
            points_long(9,:) = points(11,:);
            points_long(3,:) = points(5,:);
            
            % Calculate all other points
            %x_left = 1;
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
            %y_up = 1;
            
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
            %x_right = dim(2);
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
            %y_low = dim(1);
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
    %points = points_comb;
    points = points_long;
    
    %% Pad
    [points_pad, img_pad, paddings, alpha] = padPoints(points, img);
    
    hold off;
    close;
    %plotLines(points_pad, img_pad);
    
    points = points_pad(:,1:2);
    %% Calculate Depth of shortened walls
    focal_length = f;
    depth = calcDepth(points(13,:), points(1,:), points(3,:),focal_length);
   
    
    %% Get textures
    % Background Texture
    tex_bg = img_pad(points(7,2):points(1,2), points(7,1):points(2,1),:);
    bg_dim = size(tex_bg); % Y Dim, X dim
    %figure; imshow(tex_bg);
    
    % Left Texture
    % Create points of new image to map to (ie height and width of the
    % image block)
    mat_l = floor([1,bg_dim(1); 1, 1; depth, 1; depth, bg_dim(1);]);
    % Choose polygon from which the block is going to be taken
    points_l = [points(5,1:2); points(11,1:2); points(7,1:2); points(1,1:2)];
    % Generate Homographie Transform between the new image map and the polygon
    tf_l = fitgeotrans(floor(points_l), mat_l, 'projective'); % generate Transform for left texture
    % Transform and create texture
    tex_l = imwarp(img_pad, tf_l, 'OutputView', imref2d([bg_dim(1), floor(depth)])); % Dimensions are defined in imref2d
    tex_l_alpha = imwarp(alpha, tf_l, 'OutputView', imref2d([bg_dim(1), floor(depth)]));
    
    % Crop textures and alpha mats for less memory intensive drawing
    % collapse columns by taking mean and then finding first zero element
    %(all rows are 0 in the alpha mat after the index, so this part can be discarded)
    tex_l = flip(tex_l,2);
    tex_l_alpha = flip(tex_l_alpha,2);
    l_index = find(mean(tex_l_alpha, 1) == 0,1) - 1;
    if isempty(l_index) 
        l_index = size(tex_l_alpha,2);
    end
    tex_l = tex_l(:, 1:l_index,:);
    tex_l_alpha = tex_l_alpha(:, 1:l_index);
    
    
    % Ceil Texture
    mat_c = floor([1,depth; 1, 1; bg_dim(2), 1; bg_dim(2), depth;]);
    points_c = [points(7,1:2); points(9,1:2); points(10,1:2); points(8,1:2)];
    tf_c = fitgeotrans(floor(points_c), mat_c, 'projective'); % generate Transform for left texture
    tex_c = imwarp(img_pad, tf_c, 'OutputView', imref2d([floor(depth), bg_dim(2)])); % Dimensions are defined in imref2d
    tex_c_alpha = imwarp(alpha, tf_c, 'OutputView', imref2d([floor(depth), bg_dim(2)])); 
    tex_c = flip(tex_c, 1);
    tex_c_alpha = flip(tex_c_alpha,1);
    
    c_index = find(mean(tex_c_alpha, 2) == 0,1) - 1;
    if isempty(c_index) 
        c_index = size(tex_c_alpha,1);
    end
    tex_c = tex_c(1:c_index,:, :);
    tex_c_alpha = tex_c_alpha(1:c_index,:);
    
    % Right Texture
    mat_r = floor([1,bg_dim(1); 1, 1; depth, 1; depth, bg_dim(1);]);
    points_r = [points(2,1:2); points(8,1:2); points(12,1:2); points(6,1:2)];
    tf_r = fitgeotrans(floor(points_r), mat_r, 'projective'); % generate Transform for left texture
    tex_r = imwarp(img_pad, tf_r, 'OutputView', imref2d([bg_dim(1), floor(depth)])); % Dimensions are defined in imref2d
    tex_r_alpha = imwarp(alpha, tf_r, 'OutputView', imref2d([bg_dim(1), floor(depth)])); % Dimensions are defined in imref2d
    
    r_index = find(mean(tex_r_alpha, 1) == 0,1) - 1;
    if isempty(r_index) 
        r_index = size(tex_r,2);
    end
    tex_r = tex_r(:, 1:r_index,:);
    tex_r_alpha = tex_r_alpha(:, 1:r_index);
    
    
    % Floor Texture
    mat_f = floor([1,depth; 1, 1; bg_dim(2), 1; bg_dim(2), depth;]);
    points_f = [points(3,1:2); points(1,1:2); points(2,1:2); points(4,1:2)];
    tf_f = fitgeotrans(floor(points_f), mat_f, 'projective'); % generate Transform for left texture
    tex_f = imwarp(img_pad, tf_f, 'OutputView', imref2d([floor(depth), bg_dim(2)])); % Dimensions are defined in imref2d
    tex_f_alpha = imwarp(alpha, tf_f, 'OutputView', imref2d([floor(depth), bg_dim(2)])); % Dimensions are defined in imref2d
    
    % Crop Floor textures
    f_index = find(mean(tex_f_alpha, 2) == 0,1) - 1;  
    if isempty(f_index) 
        f_index = size(tex_f,1);
    end
    tex_f = tex_f(1:f_index,:,:);
    tex_f_alpha = tex_f_alpha(1:f_index,:);
    
    
    %% Mask
    if size(mask,1) > 1
        % Pad Mask
        point_mask(1) = point_mask(1) + paddings(1);
        point_mask(2) = point_mask(2) + paddings(2);

        % Calculate Depth Value % Y value is 0
        depth_mask = depth * (point_mask(2)- points(13,2))/(points(3,2)-points(13,2));

        % Calculate interpolatedd x Value of mask
        % get left x lim and right x lim (x values of left and right walls on the same line as the point)
        mask_m_left = (points(1,2) - points(13,2))/(points(1,1) - points(13,1));
        b_left = points(1,2) - mask_m_left*points(1,1);
        mask_x_left = (point_mask(2) - b_left)/mask_m_left;

        mask_m_right = (points(2,2) - points(13,2))/(points(2,1) - points(13,1));
        b_right = points(2,2) - mask_m_right*points(2,1);
        mask_x_right = (point_mask(2) - b_right)/mask_m_right;
        
        B_mask = (point_mask(1) - mask_x_left) / (mask_x_right - mask_x_left) * bg_dim(2);
    end
    
    %% Draw in 3D
    fig = figure;
    xlabel('x'); ylabel('y'); zlabel('z');
    axis on; hold on;
    
    B = bg_dim(2);
    H = bg_dim(1);
    
    %BG
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    m_bg = hgtransform('Matrix', makehgtform('translate', [0,0,H-1], 'xrotate', -pi/2));
    image(m_bg, tex_bg);
    %Left
    m_left = hgtransform('Matrix', makehgtform('translate', [1, 1, H-1], 'xrotate', pi/2, 'yrotate', pi/2, 'zrotate',pi));
    im_l = image(m_left, tex_l);
     
    %Right
    m_right = hgtransform('Matrix', makehgtform('translate', [B,1,H], 'xrotate', -pi/2, 'yrotate', pi/2));
    im_r = image(m_right, tex_r);
     
    %Floor
    m_floor = hgtransform('Matrix', makehgtform('translate', [1,1,1], 'xrotate', pi, 'yrotate', 0));
    im_f = image(m_floor, tex_f);
    
    %Ceiling
    m_ceil = hgtransform('Matrix', makehgtform('translate', [0,1,H-2], 'xrotate', pi, 'yrotate', 0, 'zrotate', 0));
    im_c = image(m_ceil, tex_c);
    
    % Masked
    if size(mask,1) > 1
        % Calculate
        %ratio = sqrt((bg_dim(1)*bg_dim(2)) / (dim(1)*dim(2)));
        ratio = bg_dim(1)/dim(1);
        mask_img = imresize(mask_img, ratio);
        mask_crop = imresize(mask_crop, ratio);
        m_mask = hgtransform('Matrix', makehgtform('translate', [B_mask,-depth_mask,1+size(mask_img,1)], 'xrotate', -pi/2));
        im_m = image(m_mask, mask_img);
        im_m.AlphaData = mask_crop;
    end
    
    % Set Alpha Data
    if use_alpha
        im_l.AlphaData = tex_l_alpha;
        im_r.AlphaData = tex_r_alpha;
        im_f.AlphaData = tex_f_alpha;
        im_c.AlphaData = tex_c_alpha;
    end   
    
    %% Camera Setup
    view(3);
     tf = cameratoolbar(fig);
     %cameratoolbar('SetMode', 'dollyfb');
     camproj('perspective');
     
     vp = [points(13,1) - points(1,1), points(2,2)-points(13,2)];
     cam_pos = [vp(1), -depth-focal_length, vp(2)];
     campos(cam_pos);
     camtarget([vp(1),vp(2),0]);
     camzoom(0.15);
     axis off;
     
%%   Calculate offest angle to background plane midpoint
     %midpoint = [bg_dim(2)/2, 0, bg_dim(1)/2];
     %len_vp = depth+focal_length;
     %len_x_rot = norm([depth + focal_length, cam_pos(3) - midpoint(3)]);
     %alpha = acos(len_vp/len_x_rot)/(2*pi)*360;
     %len_y_rot = norm([depth+focal_length, cam_pos(1) - midpoint(1)]);
     %beta = acos(len_vp/len_y_rot)/(2*pi)*360;
     
    %Pan Camera to adjust vp offset to center
    %campan(-beta, alpha);
    
%% Set display ratios of axis to be equal (Non distorted view)
    pbaspect([1 1 1]);
    daspect([1 1 1]);
    cf=gcf;
    axis off;
    
%% Add Buttons for easier Control
    % Orbit button
    orbitbutton=uicontrol(cf,'style','Pushbutton','String','Orbit','Position',[10 20 70 30],'Callback',@orbit_callback)
    function orbit_callback(~,~)
        cameratoolbar('SetMode','orbit')
    end
    % Pan button
    panbutton=uicontrol(cf,'style','Pushbutton','String','Pan','Position',[85 20 70 30],'Callback',@pan_callback);
    function pan_callback(~,~)
        cameratoolbar('SetMode','pan')
    end
    % Forward/Back button
    dollyfbbutton=uicontrol(cf,'style','Pushbutton','String','Forward/Back','Position',[160 20 70 30],'Callback',@dollyfb_callback);
    function dollyfb_callback(~,~)
        cameratoolbar('SetMode','dollyfb')
    end
    % Zoom button
    zoom=uicontrol(cf,'style','Pushbutton','String','Zoom','Position',[235 20 70 30],'Callback',@zoom_callback);
    function zoom_callback(~,~)
        cameratoolbar('SetMode','zoom')
    end
    % Move button
    move=uicontrol(cf,'style','Pushbutton','String','Move','Position',[310 20 70 30],'Callback',@move_callback);
    function move_callback(~,~)
        cameratoolbar('SetMode','dollyhv')
    end
    % Perspective projection botton
    perspective=uicontrol(cf,'style','Pushbutton','String','Perspective','Position',[385 20 70 30],'Callback',@perspective_callback);
    function perspective_callback(~,~)
        camproj('perspective')
    end
    % Orthographic projection botton
    orthographic=uicontrol(cf,'style','Pushbutton','String','Orthographic','Position',[460 20 70 30],'Callback',@orthographic_callback);
    function orthographic_callback(~,~)
        camproj('orthographic')
    end



end