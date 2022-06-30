function [points_pad, img_pad, dim_pad, paddings] = padPoints(points, img)
    % Function to add Padding to the image and the points
    dim = size(img);
    
    % Calculate necessary Paddings for each side
    ceil_pad= floor(abs(min([points(11,2), points(12,2),0])));
    left_pad = floor(abs(min([points(9,1), points(3,1),0])));
    right_pad = floor(max([points(10,1)-dim(2), points(4, 1)-dim(2), 0]));
    floor_pad = floor(max([points(6, 2)-dim(1),points(5, 2)-dim(1),0]));
    paddings = [left_pad, ceil_pad, right_pad, floor_pad];
    
    % Pad the image
    img_pad = zeros([dim(1)+ceil_pad+floor_pad, dim(2)+left_pad + right_pad,3]);
    img_pad(1+ceil_pad:end-floor_pad,1+left_pad:end-right_pad,:) = img;
    img_pad = img_pad/255.0;
    
    % Pad all points
    points_pad = zeros(size(points));
    points_pad(:,1) = points(:,1) + left_pad;
    points_pad(:,2) = points(:,2) + ceil_pad;
    
    if (size(points,1)>2)
        points_pad(:,3) = points(:,3) + left_pad;
        points_pad(:,4) = points(:,4) + ceil_pad;
    end
    
    points_pad = floor(points_pad);
    % Get new image dimensions
    dim_pad = size(img_pad)
end

