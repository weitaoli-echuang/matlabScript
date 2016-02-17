clc;
clear;

obj_file_1 = 'D:\\Users\\Desktop\\lwtRelative\\PoissonRecon.x64\\PoissonRecon.x64\\Possion_leftleg\\outlgdr.obj';
[vertices_1,vertices_normal_1,faces_1]=load_mesh(obj_file_1, 'obj');

obj_file_2 = 'D:\\Users\\Desktop\\lwtRelative\\PoissonRecon.x64\\PoissonRecon.x64\\Possion_leftleg\\outlgdr1.obj';
[vertices_2,vertices_normal_2,faces_2]=load_mesh(obj_file_2, 'obj');

center = vertices_2 - vertices_1;
