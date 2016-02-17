clc;
clear all;
clear;

model_view =[
    0.976807833	,
    -0.214117721	,
    0.000184795528	,
    0.000000000	,
    -0.213962018	,
    -0.976063848	,
    0.0389815941	,
    0.000000000	,
    -0.00816627778	,
    -0.0381170660	,
    -0.999239922	,
    0.000000000	,
    0.000000000	,
    0.000000000	,
    -2.00000000	,
    1.00000000 ];

position = [0;0;-0.5;1];
normal = [0;0;-1;0];
model_view = reshape(model_view,4,4);
normal_matrix = inv(model_view)';

position_view = model_view*position;
normal_view = normal_matrix*normal;
normal_view =normal_view(1:3,:);

n = normal_view/norm(normal_view);
diffuse = zeros(3,1);
specular = zeros(3,1);

vLightAmbient = [0.125;0.125;0.125];
vLightDiffuse = [0.79;0.79;0.79];
vLightSpecular = ones(3,1);
mat_ambient = ones(3,1);
mat_diffuse = ones(3,1);
mat_specular = ones(3,1);

ambient = mat_ambient * vLightAmbient;
% 
% // diffuse color
% vec3 kd = mat_diffuse * vLightDiffuse;
% 
% // specular color
% vec3 ks = mat_specular * vLightSpecular;
% 
% // diffuse term
% vec3 lightDir = normalize(vLightPosition - vPosition);
% //vec3 lightDir = normalize(vPosition - vLightPosition);
% //vec3 lightDir = vec3(0,0,-1);
% float NdotL = clamp(dot(n, lightDir),0.0,1.0);
% diffuse = kd * NdotL;
% //    return vec3(NdotL);
% //return n;
% 
% // specular term
% vec3 rVector = normalize(2.0 * n * dot(n, lightDir) - lightDir);
% vec3 viewVector = normalize(-vPosition);
% float RdotV = clamp(dot(rVector, viewVector),0.0,1.0);
% specular = ks * pow(RdotV, shininess);
% 
% vec3 color = ambient + diffuse + specular;