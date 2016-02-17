clc;
clear all;
file='D:\lwtworker\DHII1\TestCaseData\Data\images\c60.txt';
fid=fopen(file,'r');
value_size=128^3;
A=fscanf(fid,'%d ',value_size);

% file = 'D:\lwtworker\DHII1\TestCaseData\Data\images\c60.1dt';
% fid=fopen(file,'r');
% color_size = fscanf(fid,'%d',1);
% for i =1:color_size
%     for j=1:4
%       A(i,j)=fscanf(fid,'%f',1);      
%     end
% end
% 
% B=zeros(16,16,3);
% for i =0:15
%     for j=1:16
%         for k=1:3
%             B(i+1,j,k)=A(16*i+j,k);
%         end
%    end
% end

%% 
!echo 'finished';
