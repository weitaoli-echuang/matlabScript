clc;
clear all;

!echo 'setting the images files'name;
template_image_path='D:\lwtworker\ct_data\DICOM\template_image';
file_path='D:\lwtworker\ct_data\DICOM\1-147';
result_path='D:\lwtworker\ct_data\DICOM\ps_result1';

!echo 'reading template image';



!echo 'finding the file list';
old_file_list = ls(file_path);
new_file_list=old_file_list;
file_count=0;
file_size=size(old_file_list);
s=file_size(1,1);
for i =1:s
    if(~isdir(old_file_list(i,:)))
        file_count=file_count+1;
        new_file_list(file_count,:)=old_file_list(i,:);
    end        
end

!echo 'processing images';
for i=1:file_count
    image_name=[file_path,'\\',new_file_list(i,:)];
    image_template_name=[template_image_path,'\\',strtrim(new_file_list(i,:)),'.bmp'];
    image_name_processed=[result_path,'\\',new_file_list(i,:)];
    
    message = sprintf('processing image %d', i);
    disp(message);

    dicomImage_i = dicomread(image_name);
    dicomInfo_i = dicominfo(image_name);
    template_image=imread(image_template_name);
    
    size_dicom=size(dicomImage_i);  
    for l=1:size_dicom(1,1)
        for m=1:size_dicom(1,2)
            if template_image(l,m)
                dicomImage_i(l,m)=-2048;
            end
        end
    end
    
    dicomwrite(dicomImage_i,image_name_processed,dicomInfo_i);

    
end




