function d = calcDepth(vp, p_b, p_i, f)
    % vp: vanishing point
    % p_b: point in the box in screen coordinates
    % p_i: point of intersection of frame border with vp line
    
    % No check necessary on which side, as minus would cancel out
    d = floor(((p_i(1) - vp(1))/(p_b(1) - vp(1)) - 1)*f);
    %d2 = ((p_i(2) - vp(2))/(p_b(2)-vp(2))-1)*f;
    
end

