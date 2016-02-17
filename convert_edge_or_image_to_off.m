clc;
clear all;

!echo 'finding the images files';

file_name=mfilename('fullpath');
[path,name,ext] = fileparts(file_name);
imge_path=[path,'\\edge'];

old_file_list = ls(imge_path);
file_size=size(old_file_list)
s=file_size(1,1);
file_count=0;
new_file_list=old_file_list;
for i =1:s
    if(~isdir(old_file_list(i,:)))
        file_count=file_count+1;
        new_file_list(file_count,:)=old_file_list(i,:);
    end        
end


!echo 'processing the images files';
off_name='bone.off';
fid=fopen(off_name,'w');

for i=1:file_count
    image_name=[imge_path,'\\',new_file_list(i,:)];
    image_i=imread(image_name);
    message = sprintf('processing image %d', i);
    disp(message);
    if max(max(image_i))~=0
        [rows,cols]=find(image_i);
        s=size(rows);
        disp('processing image ');
        disp(i)
        for r=1:s
            for c=1:s
               fprintf(fid,'%f %f %f\n',rows(r,1),cols(c,1),i);  
            end
        end       
    end
end
fclose(fid);

    
