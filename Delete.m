clc;
clear all;

ima=imread('E:/Fig13n.jpg');
size_i=size(ima);
%r=zeros(size_i);
r=double(ima);

%��Ҫ�������
d_r=1380;
r(d_r,:)=(r(d_r-1,:)+r(d_r+1,:))/2;

%д�ļ�
imwrite(uint8(r),'E:\1.tiff', 'Resolution',600)
