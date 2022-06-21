function output = test2(img)
    % desired im dimensions (easier to think in)
    im_v = 1000;
    im_h = 800;
    frame_dim = [im_v, im_h];
    
    si = size(img);
    bv = floor((si(1) - 800)/2);
    bh = floor((si(2) - 1000)/2);
    im = img(bv+1:end-bv-1, bh:end-bh-1, :);
    
    vp = [690, 480]; %[500,350];% Vanishing Pont X, Y
    % window plane corner points (LL, LR, UL, UR)
    ll = [260, 650]; %[220,550]; % X, Y, _s screen coordinates
    lr = [900, 650]; % [780,550];%
    ul = [260,160]; % [220,110];%
    ur = [900, 160]; % [780,110];%
    wp_corners = [ 260, 650; 900, 650; 260, 160; 900, 160];
    
    imshow(im),
    hold on;
    plot(vp(1),vp(2), 'ro', 'MarkerSize', 30, 'LineWidth', 5);
    plot(vp(1),vp(2), 'x', 'MarkerSize', 10, 'LineWidth', 5);
    text(vp(1) + 10, vp(2), 'VP', 'color', 'white');
    plot(wp_corners(:,1), wp_corners(:,2), 'o', 'MarkerSize', 10, 'Linewidth', 5);
    text(ll(1) + 10, ll(2), 'LL', 'color', 'white');
    text(lr(1) + 10, lr(2), 'LR', 'color', 'white');
    text(ul(1) + 10, ul(2), 'UL', 'color', 'white');
    text(ur(1) + 10, ur(2), 'UR', 'color', 'white');
    
    % Draw VP Lines
    drawline(vp, ll);
    drawline(vp, ul);
    drawline(vp, lr);
    drawline(vp, ur);
    
    % Set focal point f between VP and background box
    f = 1; 
    
    % Calculate corner points of wall/floor/ceiling planes
    [ll_x, ll_y] = interceptPoint2(vp, ll, frame_dim);
    [ul_x, ul_y] = interceptPoint2(vp, ul, frame_dim);
    [lr_x, lr_y] = interceptPoint2(vp, lr, frame_dim);
    [ur_x, ur_y] = interceptPoint2(vp, ur, frame_dim);
    
    
    plot(ll_x(1), ll_x(2), 'x', 'MarkerSize', 10)
    plot(ll_y(1), ll_y(2), 'x', 'MarkerSize', 10)
    
    plot(ul_x(1), ul_x(2), 'x', 'MarkerSize', 10)
    plot(ul_y(1), ul_y(2), 'x', 'MarkerSize', 10)
    
    plot(lr_x(1), lr_x(2), 'x', 'MarkerSize', 10)
    plot(lr_y(1), lr_y(2), 'x', 'MarkerSize', 10)
    
    plot(ur_x(1), ur_x(2), 'x', 'MarkerSize', 10)
    plot(ur_y(1), ur_y(2), 'x', 'MarkerSize', 10)
    
    % Screen coordinates of all planes
    % (each plane is described by: ll, ul, ur, lr points)
    % Back wall
    back_s = [ll; ul; ur; lr];
    
    % Floor
    floor_s = [ll_x; ll; lr; lr_x];
    % Left wall
    left_s = [ll_y; ul_y; ul; ll];
    % Right wall
    right_s = [lr; ur; ur_y; lr_y];
    % Ceiling
    ceil_s = [ul; ul_x; ur_x; ur];
    
    plot(polyshape(back_s));
    plot(polyshape(floor_s));
    plot(polyshape(left_s));
    plot(polyshape(right_s));
    plot(polyshape(ceil_s));
    
    % Calculate depth values for each wall
    f = 10000;
    % Depths
    floor_d = calcDepth(vp, ll, ll_x, f)
    left_d = calcDepth(vp, ul, ul_y,f)
    right_d = calcDepth(vp, ur, ur_y, f)
    ceil_d = calcDepth(vp, ul, ul_x,f)
    
    
    
    
    
    
    
    
end