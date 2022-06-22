function  [img_left,img_right,img_ceil,img_floor,img_rect]= box(vp,p7,p2,focalLength,img )
img=im2double(img);
img_rect=img(p7(2):p2(2)-1,p7(1):p2(1)-1,:);


p1=[p7(1),p2(2)];
p8=[p2(1),p7(2)];
p11=getpointx(vp,p7,1);
p9=getpointy(vp,p7,1);
p3=getpointy(vp,p1,length(img(:,1,1)));
p5=getpointx(vp,p1,1);
p10=getpointy(vp,p8,1);
p12=getpointx(vp,p8,length(img(1,:,1)));
p6=getpointx(vp,p2,length(img(1,:,1)));
p4=getpointy(vp,p2,length(img(:,1,1)));
% 
% [k1,b1]=getline(vp,p1);
% [k2,b2]=getline(vp,p2);
% [k7,b7]=getline(vp,p7);
% [k8,b8]=getline(vp,p1);
% P=[p1;p2;p3;p4;p5;p6;p7;p8;p9;p10;p11;p12]
padding_left=0;
padding_right=0;
padding_ceil=0;
padding_floor=0;

if min(p11(2),p12(2))<0
    padding_ceil=abs(min(p11(2),p12(2)));
end
if min(p3(1),p9(1))<0
    padding_left=abs(min(p3(1),p9(1)));
end
if max(p5(2),p6(2))>length(img(:,1,1))
    padding_floor=abs(min(p5(2),p6(2))-length(img(:,1,1)));
end    
if max(p10(1),p4(1))>length(img(1,:,1))
    padding_right=abs( max(p10(1),p4(1))-length(img(1,:,1)));
end


img_new=zeros( padding_floor+length(img(:,1,1))+ padding_ceil,padding_left+length(img(1,:,1))+padding_right,3);

img_new( padding_ceil+1:padding_ceil+length(img(:,1,1)),padding_left+1:padding_left+length(img(1,:,1)),:)=img;

% imshow(img_new)
p1_new=[p1(1)+padding_left,p1(2)+padding_ceil];
p2_new=[p2(1)+padding_left,p2(2)+padding_ceil];
p3_new=[p3(1)+padding_left,p3(2)+padding_ceil];
p4_new=[p4(1)+padding_left,p4(2)+padding_ceil];
p5_new=[p5(1)+padding_left,p5(2)+padding_ceil];
p6_new=[p6(1)+padding_left,p6(2)+padding_ceil];
p7_new=[p7(1)+padding_left,p7(2)+padding_ceil];
p8_new=[p8(1)+padding_left,p8(2)+padding_ceil];
p9_new=[p9(1)+padding_left,p9(2)+padding_ceil];
p10_new=[p10(1)+padding_left,p10(2)+padding_ceil];
p11_new=[p11(1)+padding_left,p11(2)+padding_ceil];
p12_new=[p12(1)+padding_left,p12(2)+padding_ceil];
vp_new=[vp(1)+padding_left,vp(2)+padding_ceil];



% [k1,b1]=getline(vp_new,p1_new);
% [k2,b2]=getline(vp_new,p2_new);
% [k7,b7]=getline(vp_new,p7_new);
% [k8,b8]=getline(vp_new,p1_new);
% P_left=[];
% P_right=[];
% P_ceil=[];
% P_floor=[];
% 
% 
% for x= 1:length(img_new(1,:,1))
%     for y=1:length(img_new(:,1,1))
%         if y>k7*x+b7 && y<k1*x+b1 && x>p5_new(1) && x<p1_new(1)
%             P_left=[P_left;[x,y]];
%         else if y>k8*x+b8 && y<k2*x+b2 && x>p2_new(1) && x<p6_new(1)
%             P_right=[P_right;[x,y]];
%              else if y<k7*x+b7 && y<k8*x+b8 && y>p7_new(2) && y<p9_new(2)
%             P_ceil=[P_ceil;[x,y]];
%                    else if y>k1*x+b1 && y>k2*x+b2 && y>p1_new(2) && y<p3_new(2)
%             P_floor=[P_floor;[x,y]];
%                         end
%                  end
%             end
%         end
%     end
%         
P_left=[p1_new;p5_new;p7_new;p11_new];
P_right=[p2_new;p6_new;p8_new;p12_new];
P_ceil=[p7_new;p8_new;p9_new;p10_new];
P_floor=[p1_new;p2_new;p3_new;p4_new];
depth_left=depth(abs(vp(1)-p1(1)),vp(1),focalLength);
depth_right=depth(abs(vp(1)-p2(1)),length(img(1,:,1))-vp(1),focalLength);
depth_ceil=depth(abs(vp(2)-p7(2)),vp(2),focalLength);
depth_floor=depth(abs(vp(2)-p1(2)),length(img(:,1,1))-vp(2),focalLength);
% 
%  Hleft=getH(P_left,[depth_left,0;0,0;0,p7(2)-p1(2);depth_left,p7(2)-p1(2)])
% [depth_left,p1(2)-p7(2);1,p1(2)-p7(2);depth_left,1;1,1;]
% P_left
%  tform_left=fitgeotrans([depth_left,p1(2)-p7(2);1,p1(2)-p7(2);depth_left,1;1,1;],P_left,'projective');
 
% invtform = invert(tform_left);
tform_left=fitgeotrans(P_left,[depth_left,p1(2)-p7(2);1,p1(2)-p7(2);depth_left,1;1,1;],'projective');
tform_right=fitgeotrans(P_right,[1,p1(2)-p7(2);depth_right,p1(2)-p7(2);1,1;depth_right,1],'projective');
tform_ceil=fitgeotrans(P_ceil,[1,depth_ceil;p8(1)-p7(1),depth_ceil;1,1;p8(1)-p7(1),1],'projective');
tform_floor=fitgeotrans(P_floor,[1,1;p8(1)-p7(1),1;1,depth_floor;p8(1)-p7(1),depth_floor],'projective');
% P_left(:,1)=P_left(:,1)+p11(1)-1;

% im_left=img_new(p11_new(2):p5_new(2),1:p1_new(1),:);
% invtform = invert(tform_left);
 img_left=imwarp(img_new,tform_left,'OutputView', imref2d([p1(2)-p7(2),depth_left]));
 img_right=imwarp(img_new,tform_right,'OutputView', imref2d([p1(2)-p7(2),depth_right]));
 img_ceil=imwarp(img_new,tform_ceil,'OutputView', imref2d([depth_ceil,p8(1)-p7(1)]));
 img_floor=imwarp(img_new,tform_floor,'OutputView', imref2d([depth_floor,p8(1)-p7(1)]));

% img_right=imwarp(img_new,tform_right);
% 
% img_ceil=imwarp(img_new,tform_ceil);
% 
% img_floor=imwarp(img_new,tform_floor);






end

