function plotLines(points ,img)
    %% Plot Image, Lines & Polygons
    imshow(img);
    hold on;
    
    rectangle('Position',[points(7,1),points(7,2), points(2,1)-points(1,1), points(1,2)-points(7,2)], 'EdgeColor', [1,0,0], 'LineWidth', 2);
    plot(points(13,1), points(13,2), 'Color', [1,0,0], 'LineWidth', 2, 'Marker', 'X', 'MarkerSize', 20);
    
    drawline(points(13,:), points(1,:));
    drawline(points(13,:), points(2,:));
    drawline(points(13,:), points(7,:));
    drawline(points(13,:), points(8,:));
    
    scatter(points(1:end-1,1),points(1:end-1,2), 20, [1,0,1]);
    
    for i = 1:12
        text(points(i,1)+ 30 , points(i,2), sprintf('P%i',i), 'Color', [1,1,1]);
    end
    
    if (size(points,1)>2)
        points_plot = points(:,1:2);
        scatter(points(1:end-1,3),points(1:end-1,4), 20, [1,1,1]);
    else
        points_plot = points;
    end
    plot( polyshape( [points_plot(1,:); points_plot(2,:); points_plot(8,:); points_plot(7,:)] ) );
    plot( polyshape( [points_plot(1,:); points_plot(2,:); points_plot(4,:); points_plot(3,:)] ) );
    plot( polyshape( [points_plot(7,:); points_plot(1,:); points_plot(5,:); points_plot(11,:)] ) );
    plot( polyshape( [points_plot(7,:); points_plot(9,:); points_plot(10,:); points_plot(8,:)] ) );
    plot( polyshape( [points_plot(8,:); points_plot(12,:); points_plot(6,:); points_plot(2,:)] ) );
    
end

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