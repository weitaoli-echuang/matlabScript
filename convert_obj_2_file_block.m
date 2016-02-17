function convert_obj_2_file_block()
    clc;
    clear;
    
    file_path =  'D:\\lwtworker\\DHII1\\TestCaseData\\Data\\left_leg\\';
    %     model_name = 'left_leg';
%     model_name ='left_leg_original';
    model_name = 'left_leg_original_sim_version7';
    file_name = [file_path, model_name, '.obj'];
    block_file =  [file_path, model_name, '_block'];
    off_file = [file_path, model_name, '_block.off'];
    
    width = 800;
    height =1000;
    depth = 500;
    
    disp('read obj files')
    [vertices, vertices_normals, faces] = load_mesh(file_name,'obj');
    faces = faces - 1;
    vertices = vertices / double(height);
    
    disp('write block files')
    fid = fopen(block_file, 'w');
    write_block_file(fid, vertices, 'float');
    write_block_file(fid, vertices_normals, 'float');
    write_block_file(fid, faces, 'uint32');
    fclose(fid);
    
    disp('write off files')
    fid = fopen(off_file,'w');
    write_off(fid,vertices,faces);
    fclose(fid);
    
    disp('finished')
end

function write_block_file(fid, block_data, data_format)
    block_size = size(block_data);
    fwrite(fid,block_size(1,1),'uint32');
    fwrite(fid,block_size(1,2),'uint32');
    fwrite(fid, block_data',data_format);
end

function write_off(fid,vertex_block,face_block)
    fprintf(fid,'%s\n','OFF');
    vertex_size = size(vertex_block);
    face_size = size(face_block);
    fprintf(fid, '%d %d %d\n',vertex_size(1,1),face_size(1,1),0);
    
    for row = 1:vertex_size(1,1)
        fprintf(fid,'%f %f %f\n',vertex_block(row,1),vertex_block(row,2),vertex_block(row,3));
    end
    
    for row = 1:face_size(1,1)
        fprintf(fid,'%d %d %d %d\n',3,face_block(row,1),face_block(row,2),face_block(row,3));
    end
    
end

