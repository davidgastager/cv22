function H = getH(P1, P2)
x = P1(:, 1);
y = P1(:, 2);
X = P2(:, 1);
Y = P2(:, 2);
A = zeros(length(x(:))*2,9);
for i = 1:length(x(:))
    a = [x(i),y(i),1];
    b = [0 0 0];
    c = [X(i);Y(i)];
    d = -c*a;
    A((i-1)*2+1:(i-1)*2+2,1:9) = [[a b;b a] d];
end
[U,S,V] = svd(A);
h = V(:,9);
H = reshape(h,[3,3])';
end