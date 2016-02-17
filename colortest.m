x=[230, 230, 250];
z=[80, 200, 120];
s=[0, 255, 128];
X = zeros(100,3);
for i =1:49
    alpha=(i-1)/49;
    for j=1:3
        X(i,j)=(1-alpha)*x(1,j)+alpha*z(1,j);
    end
end

for i =50:99
    alpha=(i-50)/49;
    for j=1:3
        X(i,j)=(1-alpha)*z(1,j)+alpha*s(1,j);
    end
end

X=X/255.;