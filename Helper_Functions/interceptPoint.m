function [ipx, ipy] = interceptPoint(vp, p, frame_dim)
    %%% Calculate the Point that the line through vp and a vertex
    %%% intercepts with
    %%% Assume VP is inside box and box is inside frame
    % Calculate m & b
    m = (p(2)- vp(2))/(p(1)-vp(1));
    b = p(2) - m*p(1);
    
    % Only in ideal cases, points will be directly in the corners,
    % Therefore we calculate two points x intercept point and y intersect point
    
    if (vp(1) - p(1) > 0) % check x: left point
        x = 0;
    else % point is right
        x = frame_dim(2);
    end
    
    if (vp(2) - p(2) > 0) % y: upper point
        y = 0;
    else % lower point
        y = frame_dim(1);
    end

    % find x intersect
    ipx = floor([(y-b)/m,y]);
    
    % Find y intersect
    ipy = floor([x,m*x + b]);

    
end

