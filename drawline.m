function drawline(p1, p2);
    % Draws line from x1 through x2 to edge
    m = (p2(2)-p1(2))/(p2(1)-p1(1));
    b = p2(2) - m*p2(1);
    
    % Limits of current axis
    xlims = xlim(gca);
    
    % conditions
    if (p1(1) > p2(1))
        y1 = m*xlims(1)+b;
        y = [y1, p1(2)];
        x = [xlims(1),p1(1)];
    else
        y1 = m*xlims(2)+b;
        y = [y1, p1(2)];
        x = [xlims(2), p1(1)];
    end

    line(x, y, 'color', 'white');
end