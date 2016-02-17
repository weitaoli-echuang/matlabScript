function [vertices,vertices_normals,faces] = load_mesh(file_name, mesh_type)
    if strcmp(mesh_type,'obj')
        vertices = [];
        vertices_normals = [];
        faces = [];
    end
    
    disp('Begin reading');
    
    fid = fopen(file_name, 'r');
    vertex_index =1;
    normal_index =1;
    face_index =1;
    
    count_pat = '(\d+)';
    float_pat = '(-*\d*\.*\d+){1,3}';
    int_pat = '(\d+)';
    
    while ~feof(fid)
        tline=fgetl(fid);
        if ~isempty(tline) && length(tline) > 1
            
            if tline(1)=='#'
                if strfind(tline, 'Vertices:')
                    tmp_count = regexp(tline, count_pat, 'match');
                    vertex_count = str2num(tmp_count{1});
                elseif strfind(tline,'Faces')
                    tmp_count = regexp(tline, count_pat, 'match');
                    face_count = str2num(tmp_count{1});
                    
                    vertices = zeros(vertex_count,3);
                    vertices_normals = zeros(vertex_count,3);
                    faces = zeros(face_count,3);
                end
            end
            
            if strcmp(tline(1:2),'v ')
                tmp_count = regexp(tline, float_pat, 'match');
                vertices(vertex_index,:)=cellfun(@str2double,tmp_count);
                vertex_index=vertex_index+1;
            end
            
            if strcmp(tline(1:2),'vn')
                tmp_count = regexp(tline, float_pat, 'match');
                vertices_normals(normal_index,:)=cellfun(@str2double,tmp_count);
                normal_index=normal_index+1;
            end
            
            if strcmp(tline(1),'f')
                tmp_count = regexp(tline, int_pat, 'match');
                tmp_face = cellfun(@str2double,tmp_count);
                face_index_len = length(tmp_face);
                if face_index_len==3
                    faces(face_index,:)=tmp_face;
                elseif face_index_len ==6
                    faces(face_index,:) = [tmp_face(1) tmp_face(3) tmp_face(5)];
                elseif face_index_len==9
                    faces(face_index,:) = [tmp_face(1) tmp_face(4) tmp_face(7)];
                end
                face_index=face_index+1;
            end
        end
    end
    
    fclose(fid);
    
    disp('Finish reading');
end
