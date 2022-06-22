function interceptPoint = interceptPoint(vp, p, frame_dim)
    %%% Calculate the Point that the line through vp and a vertex
    %%% intercepts with
    %%% Assume VP is inside box and box is inside frame
    % Calculate m & b
    m = (p(2)- vp(2))/(p(1)-vp(1));
    b = p(2) - m*p(1);
    %b = vp(2) - m*vp(1);
    
    % Check which point it is LL, LR, UL, UR
    if (vp(1) - p(1) > 0) % check x: left point
        x = 0;
        y = m*x + b;
        if (vp(2) - p(2) > 0) % y: upper point (condition just for understanding)
            % point is upper left
            if (y < 0)
                % point intersects upper frame
                'UL: point intersects upper frame';
                x = -b/m;
                y = 0;
            end
        else % lower point (condition jsut for understanding)
            % point is lower left
            if (y > frame_dim(2))
                x = -b/m;
                y = frame_dim(2);
            end
        end
        
    else % right point
        x = frame_dim(1);
        y = m*x + b;
        if (vp(2) - p(2) > 0)
            % point is upper right
            if (y < 0) %intersect with side borders?
                x = -b/m;
                y = 0;
            end
        else % point is lower right
            if (y > frame_dim(2)) % Intersect with side borders?
                x = -b/m;
                y = frame_dim(2);
            end
        end
    end

    interceptPoint = [x,y];
end

