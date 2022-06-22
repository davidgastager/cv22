function [k,b] = getline(point1,point2)
k=(point1(2)-point2(2))/(point1(1)-point2(1));
b=point1(2)-k*point1(1);
end

