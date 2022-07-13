function fig = tip_input(img)
% This function just serves as a simple cli interface. For TIP use the TIP
% function
    close all;
    n_px = size(img,1) * size(img,2);
    n_px_fhd = 1920*1080;
    if n_px > n_px_fhd
        ratio = sqrt(n_px_fhd / n_px)
        img = imresize(img, ratio);
        size(img), size(img,1)*size(img,2)
    end
    
    dim = size(img);
    imshow(img);
    
    hold on;
    % Get Upper Left corner and lower right corners
    [x,y] = ginput(2);
    w = x(2)-x(1);
    h = y(2)-y(1);
    rectangle('Position', [x(1),y(1),w,h], 'EdgeColor', [1,0,0], 'LineWidth', 2);
    % Get Vanishing Point
    [vp1, vp2] = ginput(1);
    plot(vp1, vp2, 'Marker', 'X', 'MarkerSize', 20, 'LineWidth', 4, 'Color', [1,0,0]);
    
    p7 = floor([x(1), y(1)]);
    p2 = floor([x(2), y(2)]);
    vp = floor([vp1, vp2]);
    
    
    outline = drawassisted();   
    
    mask = createMask(outline);
    
    %img_inpaint = inpaintExemplar(img,mask);
    
    %fullDestinationFileName = fullfile(pathname, "temp.png")
    %imwrite(j, fullDestinationFileName)
    
    
    % TIP FUNCTIONS
    fig = tip(img, vp, p7, p2, mask, 'useAlpha', false); % David
    set(gcf, 'Name', 'TIP');
    
    
    %fig2 = box3d(img, vp, p7, p2); % Yan, Shi
    %set(gcf, 'Name', 'Box3D');
    
end

