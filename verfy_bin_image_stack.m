function verfy_bin_image_stack()
    width = 800;
    height = 1000;
    %     depth=500;
    depth=1;
    start_depth = 446;
    channel = 3;
    start_pos = width*height*channel*start_depth*4;
    data_count = width*height*channel;
    
    disp('Start read bin file')
    file_name =	'D:/lwtworker/DHII1/TestCaseData/Data/left_leg/image.pixels';
    im_stack = readBinFile(file_name, start_pos, 'int', data_count);
    
    im_stack = reshape(im_stack,channel,width,height,depth);
    
    disp('Read finshed')
    level_index=1;
    ima = im_stack(:,:,:,level_index);
    ima = uint8(ima);
    ima = permute(ima,[3,2,1]);
    %     ima=extract_image_from_stack(im_stack,width,height,depth,channel,level_index);
    figure
    imshow(ima)
    
end


function cache = readBinFile(file_name, start_pos, data_type, data_count)
    fid = fopen(file_name, 'rb');
%     超过4G的文件，通过多次移动指针，可以获取都相关的内容
    fseek(fid, start_pos, 0);
%     fseek(fid, start_pos, 'cof');
    cache = fread(fid,data_count,data_type);
    fclose(fid);
end

function ima = extract_image_from_stack(data_block,width,height,depth,channel,level)
    if level<=0 || level>=depth
        ima=uint8([]);
        return;
    end
    
    ima = zeros(width,height,channel,'uint8');
    
    for row =1:height
        for col =1:width
            for ch =1:channel
                ima(row,col,ch) = uint8(data_block(row,col,ch));
            end
        end
    end
    
end
