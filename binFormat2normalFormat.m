function binFormat2normalFormat()
    clc;
    clear;
    channel = 3;
    width = 800;
    height = 1000;
    depth=500;
    count = 2662365;

    disp('Starting read files')
    %data_in_memory = readBinFile('D:\\lwtworker\\DHII1\\TestCaseData\\Data\\left_leg\\image.egdes','int',count);

    count = 1468326;
    data_in_memory = readBinFile('D:\\lwtworker\\DHII1\\TestCaseData\\Data\\left_leg\\mask_31382.egdes','int',count);
    
%     count = 527136;
%     data_in_memory = readBinFile('D:\\lwtworker\\DHII1\\TestCaseData\\Data\\left_leg\\mask_52482.egdes','int',count);

    disp('Reshape data')
    data_size = size(data_in_memory);
    nonzeros_size = data_size(1,1)/channel;
    tuple_array = reshape(data_in_memory,channel,nonzeros_size);

    %copy the memory to 3D space
    mem3D = zeros(depth,height,width,'uint8');
    index=1;
    for pixel_coord = 1:nonzeros_size
        col = tuple_array(1,pixel_coord)+1;
        row = tuple_array(2,pixel_coord)+1;
        level = tuple_array(3,pixel_coord)+1;
        if row > height || col > width || row < 1 || col < 1
            disp(['original data wrong index' num2str(level)])
            return;
        end
        mem3D(level,row,col) = 255;
        index=index+1;
    end


    %copy the coord into an image
    disp('find the BoundaryLine and write it to a image');
    threshold = zeros(1,500);
    threshold(1,:)=0.99;
    threshold(1,246)=0.98;
    
% the result matrix, tooltips: matrix is saved in matrix in colume domain
    v_p_set = zeros(nonzeros_size,3)';
    v_n_set = zeros(nonzeros_size,3)';
    nonzeros_row_index = 1;    
 

    %the first level   
    level=1;
    level_one = mem3D(level,:,:);
    level_one = reshape(level_one,height,width);
    [nonzeros_row_level_one, nonzeros_col_level_one]=find(level_one);
    non_zeros_one_size = size(nonzeros_row_level_one,1);

    p_set = zeros(non_zeros_one_size,3);
    n_set = zeros(non_zeros_one_size,3);
    for i = 1:non_zeros_one_size
        row = nonzeros_row_level_one(i);
        col = nonzeros_col_level_one(i);
        p_set(i,1)=col;
        p_set(i,2)=row;
        p_set(i,3)=level;
        n_set(i,1)=0;
        n_set(i,2)=0;
        n_set(i,3)=-1;
    end
    row_index_end = nonzeros_row_index + numel(p_set) - 1;
    v_p_set(nonzeros_row_index:row_index_end) = p_set';
    v_n_set(nonzeros_row_index:row_index_end) = n_set';
    nonzeros_row_index = row_index_end + 1;
    

%     middle level
    for level =2:499
        [vertex_position, vertex_normal] = findBoundaryLine(mem3D,level,width,height,threshold);
        row_index_end = nonzeros_row_index + numel(vertex_position) - 1;
        v_p_set(nonzeros_row_index:row_index_end) = vertex_position';
        v_n_set(nonzeros_row_index:row_index_end) = vertex_normal';
        nonzeros_row_index = row_index_end + 1;
    end

%     the last level
    level=500;
    level_last = mem3D(level,:,:);
    level_last = reshape(level_last,height,width);
    [nonzeros_row_level_last, nonzeros_col_level_last]=find(level_last);
    non_zeros_last_size = size(nonzeros_row_level_last,1);
    if non_zeros_last_size ~=0
        p_set = zeros(non_zeros_last_size,3);
        n_set = zeros(non_zeros_last_size,3);
        for i = 1:non_zeros_last_size
            row = nonzeros_row_level_last(i);
            col = nonzeros_col_level_last(i);
            p_set(i,1)=col;
            p_set(i,2)=row;
            p_set(i,3)=level;
            n_set(i,1)=0;
            n_set(i,2)=0;
            n_set(i,3)=1;
        end
        row_index_end = nonzeros_row_index + numel(p_set) - 1;
        v_p_set(nonzeros_row_index:row_index_end) = p_set';
        v_n_set(nonzeros_row_index:row_index_end) = n_set';
    end

    v_p_set=v_p_set';
    v_n_set=v_n_set';
    write_ply_only_vertices('D:\\Users\\documents\\MATLAB\\ScritpResult\\left_leg.ply',v_p_set,v_n_set);


    % disp('show the image')
    % imshow(image)
    %     disp('Output off file')
    %     write_off_file('1.off',tuple_array);
    %     disp('finished')
end

function [vertex_position, vertex_normal]=findBoundaryLine(mem3D,level,width,height,threshold)
    image = mem3D(level,:,:);
    image = reshape(image,height,width);
    conquered = reshape(image,height,width);
    [nonzeros_row,nonzeros_col]=find(image);
    non_ordered_size = size(nonzeros_row,1);
    if non_ordered_size ==0
        vertex_position = zeros(0,3);
        vertex_normal = zeros(0,3);
        return;
    end
    index = 1;
    for i = 1:non_ordered_size
        positions(index).Row = nonzeros_row(i);
        positions(index).Col = nonzeros_col(i);
        index=index+1;
    end
    %   imshow(image)
    %   order_position=image;

    order_position.Row=positions(1).Row;
    order_position.Col=positions(1).Col;
    conquered(order_position.Row,order_position.Col)=0;


    direction_order = [1,0; 0,1; -1,0; 0,-1; 1,1; -1,1; -1,-1; 1,-1];
    dealed_point_count=1;
    ordered_index = 1;
    while dealed_point_count < non_ordered_size
        current_position = order_position(ordered_index);
        old_index = ordered_index;
        for i=1:8
            row=direction_order(i,1)+ current_position.Row;
            col=direction_order(i,2)+ current_position.Col;
            if row > height || col > width || row < 1 || col < 1
                continue;
            end
            % find the neighbor
            if  conquered(row,col)==255 && image(row,col) == 255
                ordered_index=ordered_index+1;
                dealed_point_count=dealed_point_count+1;
                order_position(ordered_index).Row = row;
                order_position(ordered_index).Col = col;
                conquered(row,col)=0;
                break;
            end
        end
        % ordered_index = size(order_position,2);
        % we find a location where we can not continue, so we should find
        % another way, we choose to move backwards and try to continue
        if ordered_index == old_index
            % if the ordered points' number is more than 80% of the non_ordered_size
            % then the current line is the domain.
            if (ordered_index/non_ordered_size - threshold(1,level))>0
                break;
            end

            disp('error');
            % backwards
            ordered_index = ordered_index-1;
            % break;
            if ordered_index<=0
                if dealed_point_count < non_ordered_size
                    disp('find another startup point')
                    % find a point which has not been conquered by the BoundaryLine
                    for i = 1: non_ordered_size
                        row = positions(i).Row;
                        col = positions(i).Col;
                        if conquered(row,col)==255
                            order_position(1).Row=row;
                            order_position(1).Col=col;
                            conquered(row,col)=0;
                            ordered_index=1;
                            dealed_point_count=dealed_point_count+1;
                            break;
                        end
                    end
                else
                    disp('ioslated points');
                    break;
                end
            end
        end
    end

    disp([num2str(ordered_index) ' points in BoundaryLine']);
    vertex_position = zeros(ordered_index,3);
    for i = 1:ordered_index
        vertex_position(i,1)=order_position(i).Col;
        vertex_position(i,2)=order_position(i).Row;
        vertex_position(i,3)=level;
    end

    disp('calculate the normal');
    zAxis=[0,0,-1];
    vertex_normal=getNormal(order_position,ordered_index ,zAxis);

    disp('Show the normal');
    figure
    imshow(image);
    hold on
    plot(vertex_position(:,1),vertex_position(:,2),'Color','Red','LineWidth',2);
    hold on
    quiver(vertex_position(:,1),vertex_position(:,2),vertex_normal(:,1),vertex_normal(:,2));
    hold off

    image_path = 'D:\\Users\\documents\\MATLAB\\ScritpResult\\BoundaryLine\\';
    image_name = [image_path num2str(level) '.jpg']
    saveas(gca,image_name);
    close;
end

function normal = getNormal(ordered_position,count,zAxis)
    normal = zeros(count,3);
    edge_vector = zeros(1,3);
    for i = 1:count-1
        edge_vector(1,1) = ordered_position(i+1).Col - ordered_position(i).Col;
        edge_vector(1,2) = ordered_position(i+1).Row - ordered_position(i).Row;
        normal(i,:) = cross(edge_vector,zAxis);
    end

    edge_vector(1,1) = ordered_position(1).Col - ordered_position(count).Col;
    edge_vector(1,2) = ordered_position(1).Row - ordered_position(count).Row;
    normal(count,:) = cross(edge_vector,zAxis);
end

function cache = readBinFile(file_name, data_type, data_count)
    fid = fopen(file_name, 'rb');
    cache = fread(fid,data_count,data_type);
    fclose(fid);
end


function write_off_file(file_name, tuple_array)
    fid = fopen(file_name, 'w');
    tuple_size = size(tuple_array);
    fprintf(fid,'%s\n','OFF');
    fprintf(fid,'%d %d %d\n',tuple_size(1,2),0,0);
    for i = 1: tuple_size(1,2)
        fprintf(fid,'%d %d %d\n',tuple_array(1,i),tuple_array(2,i),tuple_array(3,i));
    end
    fclose(fid);
end

function write_ply_only_vertices(file_name, vertex_position,vertex_normal)
    fid = fopen(file_name, 'w');
    fprintf(fid,'%s\n','ply');
    fprintf(fid,'%s\n','format ascii 1.0');
    fprintf(fid,'%s\n','comment vcglib generated');
    vertex_count = size(vertex_position,1);
    fprintf(fid,'%s %d\n','element vertex',vertex_count);
    fprintf(fid,'%s\n', 'property float x');
    fprintf(fid,'%s\n', 'property float y');
    fprintf(fid,'%s\n', 'property float z');
    fprintf(fid,'%s\n', 'property float nx');
    fprintf(fid,'%s\n', 'property float ny');
    fprintf(fid,'%s\n', 'property float nz');
    fprintf(fid,'%s %d\n','element face',0);
    fprintf(fid,'%s\n', 'property list uchar int vertex_indices');
    fprintf(fid,'%s\n','end_header');

    for i = 1:vertex_count
        fprintf(fid,'%d %d %d %d %d %d\n',vertex_position(i,1),vertex_position(i,2),vertex_position(i,3),vertex_normal(i,1),vertex_normal(i,2),vertex_normal(i,3));
    end
    fclose(fid);
end
