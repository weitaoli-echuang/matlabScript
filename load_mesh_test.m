clc;
clear;

obj_file_1 = 'D:\\Users\\Desktop\\lwtRelative\\PoissonRecon.x64\\PoissonRecon.x64\\Possion_leftleg\\outlgdr.obj';
[vertices_1,vertices_normal_1,faces_1]=load_mesh(obj_file_1, 'obj');

obj_file_2 = 'D:\\Users\\Desktop\\lwtRelative\\PoissonRecon.x64\\PoissonRecon.x64\\Possion_leftleg\\outlgdr1.obj';
[vertices_2,vertices_normal_2,faces_2]=load_mesh(obj_file_2, 'obj');

x_range = max(vertices(:,1)) - min(vertices(:,1));
y_range = max(vertices(:,2)) - min(vertices(:,2));
z_range = max(vertices(:,3)) - min(vertices(:,3));

center_x = x_range / 2.;
center_y = y_range / 2.;
center_z = z_range / 2.;

center = vertices_2 - vertices_1;
