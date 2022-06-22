function P = getpointx(point1,point2,x)

k=(point1(2)-point2(2))/(point1(1)-point2(1));
b=point1(2)-k*point1(1);
y=floor(k*x+b);
P=[x,y];
end

