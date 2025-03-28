clear all;
clc;


addpath(genpath('external/gbvs'));
run('external/vlfeat-0.9.16/toolbox/vl_setup');


load('codebook.mat');
load('corrMat.mat');

img = imread('example.jpeg');
salMap=genSalMap(img,corr,codebook);
imshow(salMap);

