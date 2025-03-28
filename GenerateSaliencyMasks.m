%% Code for generating saliency binary masks
% Author: Sajeeb Roy Chowdhury
% Date: Mar 28, 2025

%% Description

% This file generates the saliency binary mask for three saliency models
% These are: Deep Visual Attention (DVA), covSal, and FES.
% More saliency models can be evaluated by adding them to `saliency_models`
% struct.

%%

clc;
clear all;

% Add model folders to the path
% Must be updated if adding new models for evaluation
addpath(fullfile(pwd, 'SMILER'));
addpath(fullfile(pwd, 'FES'));
addpath(fullfile(pwd, 'CovSal'));

%% For scratch storage

addpath(fullfile(pwd, 'scratch'));

%% Define the processor function.

% Function to process a given image to generate the saliency map
function out = processImage(imgPath, saliency_models)
    [~, imageName, ~] = fileparts(imgPath);  % Extract base image name

    model_names = fieldnames(saliency_models);
    for i = 1:numel(model_names)
        key = model_names{i};
        model_func = saliency_models.(key); % get the model calling function
        result = model_func(imgPath); 

        outputFilename = fullfile('scratch/raw', sprintf('/%s/%s.png', key, imageName));
        imwrite(mat2gray(result), outputFilename);

        out = Threshold(result);
        
        outputFilename = fullfile('scratch/mask', sprintf('/%s/%s.png', key, imageName));
        imwrite(mat2gray(out), outputFilename);
    end
end


%% Define the Saliency Model wrapper functions

% Define wrapper function for Dynamic Visual Attention
function output = dynamicVisualAttention(imgPath)
    % Get the path of this function file
    thisDir = fileparts(mfilename('fullpath'));
    
    % Add the folder where AW.mat is located
    addpath(fullfile(thisDir, 'SMILER', 'models', 'matlab', 'DVA'));
    load AW.mat;

    inImg = im2double(imread(imgPath));
    [imgOH, imgOW, ~] = size(inImg);
    inImg = imresize(inImg, [80,120]);
    [imgH, imgW, imgDim] = size(inImg);

    myEnergy = im2Energy(inImg, W);
    mySMap = vector2Im(myEnergy, imgH, imgW);

    mySMap = imresize(mySMap, [imgOH, imgOW]);
    mySMap = mySMap.^2;
    mySMap = imfilter(mySMap, fspecial('gaussian', [8, 8], 8));

    output = mat2gray(mySMap);
end

% Define wrapper function for FES
function output = FES(imgPath)
    p1 = 0.5*ones(128, 171);
    img = imread(imgPath);
    [x, y, ~] = size(img);
    img = RGB2Lab(img);
    saliency = computeFinalSaliency(img, [8 8 8], [13 25 38], 30, 10, 1, p1);
    saliency = imresize(saliency, [x,y]);
    output = mat2gray(saliency);
end

% Define wrapper function for CovSal
function output = CovSal(imgPath)
    % options for saliency estiomation
    options.size = 512;                     % size of rescaled image
    options.quantile = 1/10;                % parameter specifying the most similar regions in the neighborhood
    options.centerBias = 1;                 % 1 for center bias and 0 for no center bias
    options.modeltype = 'CovariancesOnly';  % 'CovariancesOnly' and 'SigmaPoints' 
                                            % to denote whether first-order statistics
                                            % will be incorporated or not
    output = saliencymap(imgPath, options);
    output = mat2gray(output);
end

%% Struct to map model names to operation functions

% Define a struct to map the model name to its wrapper function when run on
% an image in the Training Dataset
saliency_models = struct( ...
    'Dynamic_Visual_Attention', @dynamicVisualAttention, ...
    'covSal', @CovSal, ...
    'FES', @FES ...
);

%% Traverse the Input Directory and run each model on each image

% Define the path to the Images directory
imageDir = fullfile('Saliency4asd', 'TrainingData', 'Images');

% Get list of all PNG files in the directory
imageFiles = dir(fullfile(imageDir, '*.png'));

% Get the number of images in the Training Dataset
num_images = length(imageFiles);

% Loop through each image
for k = 1:num_images
    % Construct full file path
    imagePath = fullfile(imageDir, imageFiles(k).name);
    processImage(imagePath, saliency_models);
end
