clear;
close all;

img=imread('images\building.png');
%% corner points of the outer rectangle
[outerheight,outerlength,~]=size(img);
o1=[1,1]; o2=[outerlength,1];
o3=[1,outerheight ];o4=[outerlength,outerheight];
%% corner points of the inner rectangle

%imshow(img); [x,y] = ginput(2); p7 = floor([x(1),y(1)]);p8 = floor([x(2), y(1)]);p1 = floor([x(1),y(2)]);p2 = floor([x(2),y(2)]);
p7=[339,184]; p8=[957,184];
p1=[339,668]; p2=[957,668];
%% Vanishing point
vp=[500,400]; %vp=[779,515];
%[a,b] = ginput(1); vp = floor([a,b]);

%% function of the first spider mesh line l1; coordinates of p9 and p11
k1=(p7(2)-vp(2))/(p7(1)-vp(1));
b1=p7(2)-k1*p7(1);
l1= @(x) k1*x+b1;
p11=[o1(1),l1(o1(1))];

l1_inv=@(x) (1/k1)*x-b1/k1;
p9=[l1_inv(o1(2)),o1(2)];

%% function of the second spider mesh line l2; coordinates of p10 and p12
k2=(p8(2)-vp(2))/(p8(1)-vp(1));
b2=p8(2)-k2*p8(1);
l2= @(x) k2*x+b2;
p12=[o2(1),l2(o2(1))];

l2_inv=@(x) (1/k2)*x-b2/k2;
p10=[l2_inv(o2(2)),o2(2)]; 
%% function of the first spider mesh line l3; coordinates of p3 and p5
k3=(p1(2)-vp(2))/(p1(1)-vp(1));
b3=p1(2)-k3*p1(1);
l3= @(x) k3*x+b3;
p5=[o3(1),l3(o3(1))];

l3_inv=@(x) (1/k3)*x-b3/k3;
p3=[l3_inv(o3(2)),o3(2)];    
%% function of the second spider mesh line l4; coordinates of p4 and p6
k4=(p2(2)-vp(2))/(p2(1)-vp(1));
b4=p2(2)-k4*p2(1);
l4= @(x) k4*x+b4;
p6=[o4(1),l4(o4(1))];

l4_inv=@(x) (1/k4)*x-b4/k4;
p4=[l4_inv(o4(2)),o4(2)];   
%% Coordinates of all points in the image
pixel_num=outerheight*outerlength;
pixel_index=linspace(1,pixel_num,pixel_num);
[pixel_y, pixel_x]=ind2sub([outerheight,outerlength],pixel_index);

%% CROPPING IS NOT NECESSARY
%% Left wall cropping: img_lw
inleftwall=inpolygon(pixel_x, pixel_y, [p11(1),p7(1),p1(1),p5(1)], [p11(2),p7(2),p1(2),p5(2)]);
inleftwall=reshape(inleftwall,[outerheight,outerlength]);
img_r=img(:,:,1);img_r(~inleftwall)=nan;
img_g=img(:,:,2);img_g(~inleftwall)=nan;
img_b=img(:,:,3);img_b(~inleftwall)=nan;
img_lw(:,:,1)=img_r;
img_lw(:,:,2)=img_g;
img_lw(:,:,3)=img_b;
%% Ceiling cropping: img_c
inceiling=inpolygon(pixel_x,pixel_y,[p7(1),p9(1),p10(1),p8(1)],[p7(2),p9(2),p10(2),p8(2)]);
inceiling=reshape(inceiling,[outerheight,outerlength]);
img_r=img(:,:,1);img_r(~inceiling)=nan;
img_g=img(:,:,2);img_g(~inceiling)=nan;
img_b=img(:,:,3);img_b(~inceiling)=nan;
img_c(:,:,1)=img_r;
img_c(:,:,2)=img_g;
img_c(:,:,3)=img_b;
%% Right wall cropping 
inrightwall=inpolygon(pixel_x,pixel_y,[p8(1),p12(1),p6(1),p2(1)],[p8(2),p12(2),p6(2),p2(2)]);
inrightwall=reshape(inrightwall,[outerheight,outerlength]);
img_r=img(:,:,1);img_r(~inrightwall)=nan;
img_g=img(:,:,2);img_g(~inrightwall)=nan;
img_b=img(:,:,3);img_b(~inrightwall)=nan;
img_rw(:,:,1)=img_r;
img_rw(:,:,2)=img_g;
img_rw(:,:,3)=img_b;
imshow(img_rw)
%% Floor cropping
infloor=inpolygon(pixel_x,pixel_y,[p1(1),p2(1),p4(1),p3(1)],[p1(2),p2(2),p4(2),p3(2)]);
infloor=reshape(infloor,[outerheight,outerlength]);
img_r=img(:,:,1);img_r(~infloor)=nan;
img_g=img(:,:,2);img_g(~infloor)=nan;
img_b=img(:,:,3);img_b(~infloor)=nan;
img_f(:,:,1)=img_r;
img_f(:,:,2)=img_g;
img_f(:,:,3)=img_b;
size(img_f)
size(img)

%% Left wall homographie matrix estimation and warping
f=1600; %focal length of the camera
d_lw=abs(vp(1)-p11(1))*f/abs(vp(1)-p7(1))-f;%depth of left wall
d_c=d_lw*(norm(p7-p9))/norm(p7-p11);%depth of Ceiling
d_rw=d_c*(norm(p8-p12))/norm(p8-p10);%depth of Right wall
d_f=d_rw*(norm(p2-p4)/norm(p2-p6));%depth of floor
lw_rect=zeros(p1(2)-p7(2),round(d_lw));
img_lw=img_lw(:,1:p7(1),:);
[lw_height,lw_length]=size(lw_rect);
% projective transformation
tform_lw = fitgeotrans([p11;p7;p1;p5],[1 1;lw_length 1;lw_length lw_height;1 lw_height],'projective');
lw_rect = imwarp(img_lw,tform_lw,'OutputView', imref2d(size(lw_rect)));
lw_rect2 = imwarp(img,tform_lw,'OutputView', imref2d(size(lw_rect)));
figure;imshow(lw_rect./2 + lw_rect2./2);figure;imshow(lw_rect - lw_rect2);
p9_trans=[p9(1) p9(2) 1]*tform_lw.T;
p9_trans=p9_trans/p9_trans(3);
p9_trans=[p9_trans(1) p9_trans(2)];
p3_trans=[p3(1) p3(2) 1]*tform_lw.T;
p3_trans=p3_trans/p3_trans(3);
p3_trans=[p3_trans(1) p3_trans(2)];

% additional pwl transformation

if (p3_trans(1)>1&&p3_trans(1)<lw_length)&&(p9_trans(1)>1&&p9_trans(1)<lw_length)
    if p3_trans(1)>p9_trans(1)
        tform_lw_pwl=fitgeotrans([1 1;p9_trans;p3_trans(1) 1;lw_length 1;lw_length lw_height;p3_trans;p9_trans(1) lw_height;1 lw_height], [1 1;norm(p11-p9)/norm(p11-p7)*d_lw 1;norm(p5-p3)/norm(p5-p1)*d_lw 1;lw_length 1;lw_length lw_height;norm(p5-p3)/norm(p5-p1)*d_lw lw_height;norm(p11-p9)/norm(p11-p7)*d_lw lw_height;1 lw_height],'pwl');
        lw_rect = imwarp(lw_rect,tform_lw_pwl,'OutputView', imref2d(size(lw_rect)));
    end
    if p3_trans(1)<p9_trans(1)
    tform_lw_pwl=fitgeotrans([1 1;p3_trans(1) 1;p9_trans;lw_length 1;lw_length lw_height;p9_trans(1) lw_height;p3_trans;1 lw_height],[1 1;norm(p5-p3)/norm(p5-p1)*d_lw 1;norm(p11-p9)/norm(p11-p7)*d_lw 1;lw_length 1;lw_length lw_height;norm(p11-p9)/norm(p11-p7)*d_lw lw_height;norm(p5-p3)/norm(p5-p1)*d_lw lw_height;1 lw_height],'pwl');
    lw_rect = imwarp(lw_rect,tform_lw_pwl,'OutputView', imref2d(size(lw_rect)));
    end
end
if (p3_trans(1)<1||p3_trans(1)>lw_length)&&(p9_trans(1)>1&&p9_trans(1)<lw_length)
tform_lw_pwl=fitgeotrans([1 1;p9_trans;lw_length 1;lw_length lw_height;p9_trans(1) lw_height;1 lw_height],[1 1;norm(p11-p9)/norm(p11-p7)*d_lw 1;lw_length 1;lw_length lw_height;norm(p11-p9)/norm(p11-p7)*d_lw lw_height;1 lw_height],'pwl');
lw_rect = imwarp(lw_rect,tform_lw_pwl,'OutputView', imref2d(size(lw_rect)));
end
if (p3_trans(1)>1&&p3_trans(1)<lw_length)&&(p9_trans(1)<1||p9_trans(1)>lw_length)
tform_lw_pwl=fitgeotrans([1 1;p3_trans(1) 1;lw_length 1;lw_length lw_height;p3_trans;1 lw_height],[1 1;norm(p5-p3)/norm(p5-p1)*d_lw 1;lw_length 1;lw_length lw_height;norm(p5-p3)/norm(p5-p1)*d_lw lw_height;1 lw_height],'pwl');
lw_rect = imwarp(lw_rect,tform_lw_pwl,'OutputView', imref2d(size(lw_rect)));
end
% figure;
% imshow(img_lw);
% hold on;
% scatter(p11(1),p11(2),'+');
% hold on;
% scatter(p9(1),p9(2),'+');
% hold on;
% scatter(p7(1),p7(2),'+');
% hold on;
% figure;
% imshow(lw_rect);
% hold on;
% scatter(norm(p11-p9)/norm(p11-p7)*d_lw,1,'+');

%% Ceiling homographie matrix estimation and warping

c_rect=zeros(round(d_c),p8(1)-p7(1));
img_c=img_c(1:p7(2),:,:);
[c_height,c_length]=size(c_rect);
tform_c = fitgeotrans([p9;p10;p8;p7],[1 1;c_length 1;c_length c_height ;1 c_height],'projective');
c_rect = imwarp(img_c,tform_c,'OutputView', imref2d(size(c_rect)));

p11_trans=[p11(1) p11(2) 1]*tform_c.T;
p11_trans=p11_trans/p11_trans(3);
p11_trans=[p11_trans(1) p11_trans(2)];
p12_trans=[p12(1) p12(2) 1]*tform_c.T;
p12_trans=p12_trans/p12_trans(3);
p12_trans=[p12_trans(1) p12_trans(2)];

% additional pwl transformation
if (p11_trans(2)>1&&p11_trans(2)<c_height)&&(p12_trans(2)>1&&p12_trans(2)<c_height)
    if p11_trans(2)>p12_trans(2)
    tform_c_pwl=fitgeotrans([1 1;c_length 1;p12_trans;c_length p11_trans(2);c_length c_height ;1 c_height;p11_trans;1 p12_trans(2)],[1 1;c_length 1;c_length norm(p10-p12)/norm(p10-p8)*d_c;c_length norm(p9-p11)/norm(p9-p7)*d_c;c_length c_height ;1 c_height;1 norm(p9-p11)/norm(p9-p7)*d_c;1 c_length norm(p10-p12)/norm(p10-p8)],'pwl');
    c_rect = imwarp(c_rect,tform_c_pwl,'OutputView', imref2d(size(c_rect)));
    end
    if p11_trans(2)<p12_trans(2)
    tform_c_pwl=fitgeotrans([1 1;c_length 1;c_length p11_trans(2);p12_trans;c_length c_height ;1 c_height;1 p12_trans(2);p11_trans],[1 1;c_length 1;c_length norm(p9-p11)/norm(p9-p7)*d_c;c_length norm(p10-p12)/norm(p10-p8)*d_c;c_length c_height ;1 c_height;1 c_length norm(p10-p12)/norm(p10-p8);1 norm(p9-p11)/norm(p9-p7)*d_c],'pwl');
    c_rect = imwarp(c_rect,tform_c_pwl,'OutputView', imref2d(size(c_rect)));
    end
end
if (p11_trans(2)>1&&p11_trans(2)<c_height)&&(p12_trans(2)<1||p12_trans(2)>c_height)
tform_c_pwl=fitgeotrans([1 1;c_length 1;c_length p11_trans(2);c_length c_height ;1 c_height;p11_trans],[1 1;c_length 1;c_length norm(p9-p11)/norm(p9-p7)*d_c;c_length c_height ;1 c_height;1 norm(p9-p11)/norm(p9-p7)*d_c],'pwl');
c_rect = imwarp(c_rect,tform_c_pwl,'OutputView', imref2d(size(c_rect)));
end
if (p11_trans(2)<1||p11_trans(2)>c_height)&&(p12_trans(2)>1&&p12_trans(2)<c_height)
tform_c_pwl=fitgeotrans([1 1;c_length 1;p12_trans;c_length c_height ;1 c_height;1 p12_trans(2)],[1 1;c_length 1;c_length norm(p10-p12)/norm(p10-p8)*d_c;c_length c_height ;1 c_height;1 norm(p10-p12)/norm(p10-p8)*d_c],'pwl');
c_rect = imwarp(c_rect,tform_c_pwl,'OutputView', imref2d(size(c_rect)));
end


%% Right wall homographie matrix estimation and warping

rw_rect=zeros(p2(2)-p8(2),round(d_rw));
img_rw=img_rw(:,p8(1):end,:);
[rw_height,rw_length]=size(rw_rect);

% Points coordinates recalculation due to the translation caused by the image cropping
p8_new=[1,p8(2)];p2_new=[1,p2(2)];p12_new=[p12(1)-p8(1),p12(2)];p6_new=[p6(1)-p8(1),p6(2)];
p10_new=[p10(1)-p8(1),p10(2)];
p4_new=[p4(1)-p8(1),p4(2)];


tform_rw = fitgeotrans([p8_new;p12_new;p6_new;p2_new],[1 1;rw_length 1;rw_length rw_height ;1 rw_height],'projective');
rw_rect = imwarp(img_rw,tform_rw,'OutputView', imref2d(size(rw_rect)));

p10_new_trans=[p10_new(1) p10_new(2) 1]*tform_rw.T;
p10_new_trans=p10_new_trans/p10_new_trans(3);
p10_new_trans=[p10_new_trans(1) p10_new_trans(2)];
p4_new_trans=[p4_new(1) p4_new(2) 1]*tform_rw.T;
p4_new_trans=p4_new_trans/p4_new_trans(3);
p4_new_trans=[p4_new_trans(1) p4_new_trans(2)];

% additional pwl transformation
if (p10_new_trans(1)>1&&p10_new_trans(1)<rw_length)&&(p4_new_trans(1)>1&&p4_new_trans(1)<rw_length)
    if p10_new_trans(1)>p4_new_trans(1)
    tform_rw_pwl = fitgeotrans([1 1;p4_new_trans(1) 1;p10_new_trans;rw_length 1;rw_length rw_height;p10_new_trans(1) rw_height;p4_new_trans;1 rw_height],[1 1;norm(p2-p4)/norm(p2-p6)*d_rw 1;norm(p8-p10)/norm(p8-p12)*d_rw 1;rw_length 1;rw_length rw_height;norm(p8-p10)/norm(p8-p12)*d_rw rw_height;norm(p2-p4)/norm(p2-p6)*d_rw rw_height;1 rw_height],'pwl');
    rw_rect = imwarp(rw_rect,tform_rw_pwl,'OutputView', imref2d(size(rw_rect)));
    end
    if p10_new_trans(1)<p4_new_trans(1)
    tform_rw_pwl = fitgeotrans([1 1;p10_new_trans;p4_new_trans(1) 1;rw_length 1;rw_length rw_height;p4_new_trans;p10_new_trans(1) rw_height;1 rw_height],[1 1;norm(p8-p10)/norm(p8-p12)*d_rw 1;norm(p2-p4)/norm(p2-p6)*d_rw 1;rw_length 1;rw_length rw_height;norm(p2-p4)/norm(p2-p6)*d_rw rw_height;norm(p8-p10)/norm(p8-p12)*d_rw rw_height;1 rw_height],'pwl');
    rw_rect = imwarp(rw_rect,tform_rw_pwl,'OutputView', imref2d(size(rw_rect)));
    end
end
if (p10_new_trans(1)>1&&p10_new_trans(1)<rw_length)&&(p4_new_trans(1)<1||p4_new_trans(1)>rw_length)
    
    tform_rw_pwl = fitgeotrans([1 1;p10_new_trans;rw_length 1;rw_length rw_height;p10_new_trans(1) rw_height;1 rw_height],[1 1;norm(p12-p10)/norm(p12-p8)*d_rw 1;rw_length 1;rw_length rw_height;norm(p12-p10)/norm(p12-p8)*d_rw rw_height;1 rw_height],'pwl');
    rw_rect = imwarp(rw_rect,tform_rw_pwl,'OutputView', imref2d(size(rw_rect)));
end
if (p10_new_trans(1)<1||p10_new_trans(1)>rw_length)&&(p4_new_trans(1)>1&&p4_new_trans(1)<rw_length)
   
tform_rw_pwl = fitgeotrans([1 1;p4_new_trans(1) 1;rw_length 1;rw_length rw_height;p4_new_trans;1 rw_height],[1 1;norm(p6-p4)/norm(p6-p2)*d_rw 1;rw_length 1;rw_length rw_height;norm(p6-p4)/norm(p6-p2)*d_rw rw_height;1 rw_height],'pwl');
rw_rect = imwarp(rw_rect,tform_rw_pwl,'OutputView', imref2d(size(rw_rect)));
end

%% Floor homographie matrix estimation and warping

f_rect=zeros(round(d_f),p2(1)-p1(1));
img_f=img_f(p1(2):end,:,:);
[f_height,f_length]=size(f_rect);

% Points coordinates recalculation due to the translation caused by the image cropping
p1_new=[p1(1),1];p2_new=[p2(1),1];p3_new=[p3(1),p3(2)-p1(2)];p4_new=[p4(1),p4(2)-p2(2)];
p5_new=[p5(1),p5(2)-p1(2)];
p6_new=[p6(1),p6(2)-p1(2)];

tform_f = fitgeotrans([p1_new;p2_new;p4_new;p3_new],[1 1;f_length 1;f_length f_height ;1 f_height],'projective');
f_rect = imwarp(img_f,tform_f,'OutputView', imref2d(size(f_rect)));
figure;
imshow(f_rect)
p5_new_trans=[p5_new(1) p5_new(2) 1]*tform_f.T;
p5_new_trans=p5_new_trans/p5_new_trans(3);
p5_new_trans=[p5_new_trans(1) p5_new_trans(2)];
p6_new_trans=[p6_new(1) p6_new(2) 1]*tform_f.T;
p6_new_trans=p6_new_trans/p6_new_trans(3);
p6_new_trans=[p6_new_trans(1) p6_new_trans(2)];

% additional pwl transformation
if (p5_new_trans(2)>1&&p5_new_trans(2)<f_height)&&(p6_new_trans(2)>1&&p6_new_trans(2)<f_height)
    if p5_new_trans(2)>p6_new_trans(2)
    tform_f_pwl = fitgeotrans([1 1;f_length 1;p6_new_trans;f_length p5_new_trans(2);f_length f_height ;1 f_height;p5_new_trans;1 p6_new_trans(2)],[1 1;f_length 1;f_length norm(p6-p2)/norm(p4-p2)*d_f;f_length norm(p5-p1)/norm(p3-p1)*d_f;f_length f_height ;1 f_height;1 norm(p5-p1)/norm(p3-p1)*d_f;1 norm(p6-p2)/norm(p4-p2)*d_f],'pwl');
    f_rect = imwarp(f_rect,tform_f_pwl,'OutputView', imref2d(size(f_rect)));
    end
    if p5_new_trans(2)<p6_new_trans(2)
    tform_f_pwl = fitgeotrans([1 1;f_length 1;f_length p5_new_trans(2);p6_new_trans;f_length f_height ;1 f_height;1 p6_new_trans(2);p5_new_trans],[1 1;f_length 1;f_length norm(p5-p1)/norm(p3-p1)*d_f;f_length norm(p6-p2)/norm(p4-p2)*d_f;f_length f_height ;1 f_height;1 norm(p6-p2)/norm(p4-p2)*d_f;1 norm(p5-p1)/norm(p3-p1)*d_f],'pwl');
    f_rect = imwarp(f_rect,tform_f_pwl,'OutputView', imref2d(size(f_rect)));
    end
end
if (p5_new_trans(2)>1&&p5_new_trans(2)<f_height)&&(p6_new_trans(2)<1||p6_new_trans(2)>f_height)
   tform_f_pwl = fitgeotrans([1 1;f_length 1;f_length p5_new_trans(2);f_length f_height ;1 f_height;p5_new_trans],[1 1;f_length 1;f_length norm(p5-p1)/norm(p3-p1)*d_f;f_length f_height ;1 f_height;1 norm(p5-p1)/norm(p3-p1)*d_f],'pwl');
   f_rect = imwarp(f_rect,tform_f_pwl,'OutputView', imref2d(size(f_rect)));
end
if (p5_new_trans(2)<1||p5_new_trans(2)>f_height)&&(p6_new_trans(2)>1&&p6_new_trans(2)<f_height)
   tform_f_pwl = fitgeotrans([1 1;f_length 1;p6_new_trans;f_length f_height ;1 f_height;1 p6_new_trans(2)],[1 1;f_length 1;f_length norm(p6-p2)/norm(p4-p2)*d_f;f_length f_height ;1 f_height;1 norm(p6-p2)/norm(p4-p2)*d_f],'pwl');
   f_rect = imwarp(f_rect,tform_f_pwl,'OutputView', imref2d(size(f_rect)));
end
figure;
imshow(f_rect)
%% Inner rectangle image Cropping
in_rect=img(p7(2):p1(2),p7(1):p8(1),:);


%% 3D Box building

figure;
xlabel('x');
ylabel('y');
zlabel('z');
axis on;
% Inner rectangle plotting
[in_height,in_length,~]=size(in_rect);
g_in = hgtransform('Matrix',makehgtform('translate',[0 0 in_height],'xrotate',-pi/2));
image(g_in,in_rect);
hold on;
%Left wall plotting
g_lw = hgtransform('Matrix',makehgtform('translate',[0 -lw_length lw_height],'zrotate',pi/2,'xrotate',-pi/2));
image(g_lw,lw_rect);
hold on;
%Ceiling plotting
g_c = hgtransform('Matrix',makehgtform('translate',[0 -c_height in_height]));
image(g_c,c_rect);
hold on;
%right wall plotting
g_rw = hgtransform('Matrix',makehgtform('translate',[in_length 0 rw_height],'zrotate',-pi/2,'xrotate',-pi/2));
image(g_rw,rw_rect);
hold on;
%floor plotting
g_f = hgtransform('Matrix',makehgtform('xrotate',pi));
image(g_f,f_rect);
hold on;
view(3)




