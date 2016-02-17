clc;
clear;
%fid = fopen('1.dat', 'rb');
% fid = fopen('sin_model.normals', 'rb');
fid = fopen('sin.curvatures', 'rb');
channel = 2;
width = 256;
height = 256;
depth = 256;
tuple_count=width*height*depth;
count = tuple_count*channel;
c = fread(fid, count,'double');
fclose(fid);

img2=zeros(width,height,channel);
level_size = width*height*channel;
level_start = 1*level_size;
row_size = width*channel;
for row=0:height-1
    for col=0:width-1
        index = level_start + row_size*row + channel*col + 1;
        for ch=1:channel
            img2(row+1,col+1,ch)=c(index+ch,1);
        end
    end
end


non_zeros = zeros(height,width);
img=zeros(height,width,'uint8');
for i=1:height
    for j=1:width
        show = false;
        for ch =1:channel
            if img2(i,j,ch)~=0
                show=true;
            end
        end
        tuple_ele = img2(i,j,:);
        tuple_ele = reshape(tuple_ele,1,channel);
        pixelscale = norm(tuple_ele);
        if show
            img(i,j)=255* pixelscale^0.2;
            non_zeros(i,j) = pixelscale;
        end
    end
end
nzs = nonzeros(non_zeros);
imshow(img)