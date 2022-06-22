function drawline(FDB)

s=size(FDB);

n=1:1:s(2);

for i=n

line([FDB{1,i} FDB{1,i}+FDB{3,i}],[FDB{2,i} FDB{2,i}],'Color','r');

%%%%need use {} 横线

line([FDB{1,i}+FDB{3,i} FDB{1,i}+FDB{3,i}],[FDB{2,i} FDB{2,i}+FDB{4,i}],'Color','r');

line([FDB{1,i}+FDB{3,i} FDB{1,i}],[FDB{2,i}+FDB{4,i} FDB{2,i}+FDB{4,i}],'Color','r');%竖线

line([FDB{1,i} FDB{1,i}],[FDB{2,i}+FDB{4,i} FDB{2,i}],'Color','r');

end