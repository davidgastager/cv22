function output = test2(im)
    %% Loading & Stuff
    %im_v = size(im,1);
    %im_h = size(im,2);
    
    frame_dim = size(im);%[im_v, im_h];
    
    %si = size(img);
    %bv = floor((si(1) - 800)/2);
    %bh = floor((si(2) - 1000)/2);
    %im = img(bv+1:end-bv, bh:end-bh, :);

    %% Define VP and Coordinates
    vp = [770, 500]; %[500,350];% Vanishing Pont X, Y
    % window plane corner points (LL, LR, UL, UR)
    xl = 400; %220;
    xr = 1000; %780
    yu = 190; %110
    yl = 670; % 550
    
    p1_s = [xl, yl]; %[220,550]; % X, Y, _s screen coordinates
    p2_s = [xr, yl]; % [780,550];%
    p7_s = [xl, yu]; % [220,110];%
    p8_s = [xr, yu]; % [780,110];%
    %% Calculate Intercept Points
    % Calculate corner points of wall/floor/ceiling planes
    [p3_s, p5_s] = interceptPoint2(vp, p1_s, frame_dim);
    [p9_s, p11_s] = interceptPoint2(vp, p7_s, frame_dim);
    [p4_s, p6_s] = interceptPoint2(vp, p2_s, frame_dim);
    [p10_s, p12_s] = interceptPoint2(vp, p8_s, frame_dim);

    %% Add Padding
    ceil_pad= floor(abs(min([p11_s(2), p12_s(2),0])))
    left_pad = floor(abs(min([p9_s(1), p3_s(1),0])))
    im_dim_h = size(im,2)
    im_dim_v = size(im,1)
    right_pad = floor(max([p10_s(1)-im_dim_h, p4_s(1)-im_dim_h, 0]))
    floor_pad = floor(max([p6_s(2)-im_dim_v,p5_s(2)-im_dim_v,0]))
    
    img_pad = zeros([im_dim_v+ceil_pad+floor_pad, im_dim_h+left_pad + right_pad,3]);
    img_pad(1+ceil_pad:end-floor_pad,1+left_pad:end-right_pad,:) = im;
    im = img_pad/255.0;
    figure, imshow(img_pad);
    
    p1_s = floor([p1_s(1)+left_pad, p1_s(2)+ceil_pad]);
    p2_s = [p2_s(1)+left_pad, p2_s(2)+ceil_pad];
    p3_s = [p3_s(1)+left_pad, p3_s(2)+ceil_pad];
    p4_s = [p4_s(1)+left_pad, p4_s(2)+ceil_pad];
    p5_s = [p5_s(1)+left_pad, p5_s(2)+ceil_pad];
    p6_s = [p6_s(1)+left_pad, p6_s(2)+ceil_pad];
    p7_s = [p7_s(1)+left_pad, p7_s(2)+ceil_pad];
    p8_s = [p8_s(1)+left_pad, p8_s(2)+ceil_pad];
    p9_s = [p9_s(1)+left_pad, p9_s(2)+ceil_pad];
    p10_s = [p10_s(1)+left_pad, p10_s(2)+ceil_pad];
    p11_s = [p11_s(1)+left_pad, p11_s(2)+ceil_pad];
    p12_s = [p12_s(1)+left_pad, p12_s(2)+ceil_pad];
    
    vp = [vp(1)+left_pad, vp(2)+ceil_pad];
    
    %% Screen coordinates of all planes
    % (each plane is described by: ll, ul, ur, lr points)
    % Back wall
    back_s = [p1_s; p7_s; p8_s; p2_s];
    
    % Floor
    floor_s = [p3_s; p1_s; p2_s; p4_s];
    % Left wall
    left_s = [p5_s; p11_s; p7_s; p1_s];
    % Right wall
    right_s = [p2_s; p8_s; p12_s; p6_s];
    % Ceiling
    ceil_s = [p7_s; p9_s; p10_s; p8_s];
    
    %% Plot Image, Lines & Polygons
    
    imshow(img_pad/255.0),
    hold on;
    plot(vp(1),vp(2), 'ro', 'MarkerSize', 30, 'LineWidth', 5);
    plot(vp(1),vp(2), 'x', 'MarkerSize', 10, 'LineWidth', 5);
    text(vp(1) + 10, vp(2), 'VP', 'color', 'white');
    wp_corners = [ xl+left_pad, yl+ceil_pad; xr+left_pad, yl+ceil_pad; xl+left_pad, yu+ceil_pad; xr+left_pad, yu+ceil_pad];
    plot(wp_corners(:,1), wp_corners(:,2), 'o', 'MarkerSize', 10, 'Linewidth', 5);
    text(p1_s(1) + 10, p1_s(2), 'LL', 'color', 'white');
    text(p2_s(1) + 10, p2_s(2), 'LR', 'color', 'white');
    text(p7_s(1) + 10, p7_s(2), 'UL', 'color', 'white');
    text(p8_s(1) + 10, p8_s(2), 'UR', 'color', 'white');
    
    % Draw VP Lines
    drawline(vp, p1_s);
    drawline(vp, p7_s);
    drawline(vp, p2_s);
    drawline(vp, p8_s);
    plot(p3_s(1), p3_s(2), 'x', 'MarkerSize', 10)
    text(p3_s(1), p3_s(2), 'P3')
    plot(p5_s(1), p5_s(2), 'x', 'MarkerSize', 10)
    text(p5_s(1), p5_s(2), 'P5')
    plot(p9_s(1), p9_s(2), 'x', 'MarkerSize', 10)
    text(p9_s(1), p9_s(2), 'P9')
    plot(p11_s(1), p11_s(2), 'x', 'MarkerSize', 10)
    text(p11_s(1), p11_s(2), 'P11')
    
    plot(p4_s(1), p4_s(2), 'x', 'MarkerSize', 10)
    text(p4_s(1), p4_s(2), 'P4')
    plot(p6_s(1), p6_s(2), 'x', 'MarkerSize', 10)
    text(p6_s(1), p6_s(2), 'P6')
    
    plot(p10_s(1), p10_s(2), 'x', 'MarkerSize', 10)
    text(p10_s(1), p10_s(2), 'P10')
    plot(p12_s(1), p12_s(2), 'x', 'MarkerSize', 10)
    text(p12_s(1), p12_s(2), 'P12')
    
    plot(polyshape(back_s));
    plot(polyshape(floor_s));
    plot(polyshape(left_s));
    plot(polyshape(right_s));
    plot(polyshape(ceil_s));
    
    %% Calculate Depth Values for each Wall
    f = 1000;
    % Depths
    floor_d = calcDepth(vp, p2_s, p4_s, f)
    %floor_d = calcDepth(vp, p1_s, p3_s, f)
    left_d = calcDepth(vp, p7_s, p11_s,f)
    %left_d = calcDepth(vp, p1_s, p5_s,f)
    right_d = calcDepth(vp, p8_s, p12_s, f)
    %right_d = calcDepth(vp, p2_s, p6_s, f)
    ceil_d = calcDepth(vp, p7_s, p9_s,f)
    %ceil_d = calcDepth(vp, p8_s, p10_s,f)
    
    %% Calculate World Coordinates of points
    p1_w = [0, 0, 0];
    B = p2_s(1)-p1_s(1);
    p2_w = [B, 0, 0];
    p3_w = [0, 0, floor_d];
    p4_w = [B, 0, floor_d];
    p5_w = [0,0, left_d];
    p6_w = [B, 0, right_d];
    
    H = ((p1_s(2)-p7_s(2)) + (p2_s(2)-p8_s(2)))/2;
    
    p7_w = [0, H, 0];
    p8_w = [B,H,0];
    p9_w = [0,H, ceil_d];
    p10_w = [B,H, ceil_d];
    p11_w = [0,H, left_d];
    p12_w = [B,H, right_d];
    
    points_w = [p1_w; p2_w; p3_w; p4_w; p5_w; p6_w; p7_w; p8_w; p9_w; p10_w; p11_w; p12_w];
    left_w = [p5_w; p11_w; p7_w; p1_w; p5_w];
    ceil_w = [p7_w; p9_w; p10_w; p8_w];
    right_w = [p2_w; p8_w; p12_w; p6_w];
    floor_w = [p3_w; p1_w; p2_w; p4_w];
    back_w = [p1_w; p7_w; p8_w; p2_w];
    
    
    %% Generate Wall textures
    tex_bg = im(p7_s(2):p2_s(2), p7_s(1):p2_s(1),:);
    bg_dim = size(tex_bg); % Y Dim, X dim
    
    % Left Texture
    %l_mat = [left_d,p1_s(2)- p7_s(2);1,p1_s(2)-p7_s(2);left_d,1;1,1;];
    l_mat = floor([0, bg_dim(1);0,0; left_d,0;left_d, bg_dim(1)]); % Left image dimensions
    left_tf = fitgeotrans(floor(left_s), l_mat, 'projective'); % generate Transform for left texture
    tex_left = imwarp(im, left_tf, 'OutputView', imref2d([bg_dim(1), ceil(left_d)])); % Dimensions are defined in imref2d
    
    % Ceiling Texture
    c_mat = floor([1, ceil_d; 1,1; bg_dim(2), 1; bg_dim(2), ceil_d]);
    ceil_tf = fitgeotrans(floor(ceil_s), c_mat, 'projective');
    tex_ceil = imwarp(im, ceil_tf, 'OutputView', imref2d([ceil_d, bg_dim(2)]));
    
    % Right texture
    r_mat = floor([1, bg_dim(1); 1,1; right_d, 1; right_d, bg_dim(1)]);
    right_tf = fitgeotrans(floor(right_s), r_mat, 'projective');
    tex_right = imwarp(im, right_tf, 'OutputView', imref2d([bg_dim(1), ceil(right_d)]));
    
    % Floor Texture
    f_mat = floor([1, floor_d; 1,1; bg_dim(2), 1; bg_dim(2), floor_d]);
    floor_tf = fitgeotrans(floor(floor_s), f_mat, 'projective');
    tex_floor = imwarp(im, floor_tf, 'OutputView', imref2d([ceil(floor_d), bg_dim(2)]));

    figure;
    xlabel('x'); ylabel('y'); zlabel('z');
    axis on; hold on;

    m_bg = hgtransform('Matrix', makehgtform('translate', [0,0,H], 'xrotate', -pi/2));
    image(m_bg, tex_bg);
    
    m_left = hgtransform('Matrix', makehgtform('translate', [0, -left_d, H], 'xrotate', -pi/2, 'yrotate', -pi/2));
    image(m_left, tex_left);
    
    m_right = hgtransform('Matrix', makehgtform('translate', [B,0,H], 'xrotate', -pi/2, 'yrotate', pi/2));
    image(m_right, tex_right);
    
    m_floor = hgtransform('Matrix', makehgtform('translate', [0,0,0], 'xrotate', pi, 'yrotate', 0));
    image(m_floor, tex_floor);
    
    m_ceil = hgtransform('Matrix', makehgtform('translate', [0,-ceil_d,H], 'xrotate', 0, 'yrotate', 0));
    image(m_ceil, tex_ceil);
    
    view(3)
    
    
end




























