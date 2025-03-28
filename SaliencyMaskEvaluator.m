%% Code for evaluating saliency models
% Author: Sajeeb Roy Chowdhury
% Date: Mar 28, 2025

%% Description

% This file contains the necessary code for evaluating the output of the
% saliency models using several evaluation metrics.

% This file only evaluates the following evaluation metrics:
% AUC_Borji
% AUC_Judd
% AUC_shuffled
% CC
% EMD
% Info Gain
% KLdiv
% NSS

%% Generate the segmentation masks for the ground truth ASD Fixation Maps

clc;

% Define the path to the Ground Truth directory
imageDir = fullfile('Saliency4asd', 'TrainingData', 'ASD_FixMaps');
imageFiles = dir(fullfile(imageDir, '*.png'));
num_images = length(imageFiles);

% Loop through each image
for k = 1:num_images
    imagePath = fullfile(imageDir, imageFiles(k).name);
    out = Threshold(imread(imagePath));
    [~, imageName, ~] = fileparts(imagePath);  % Extract base image name
    outputFilename = fullfile('scratch/GT/ASD', sprintf('%s.png', imageName));
    imwrite(mat2gray(out), outputFilename);
end

%% Generate the segmentation masks for the ground truth TD Fixation Maps

% Define the path to the Ground Truth directory
imageDir = fullfile('Saliency4asd', 'TrainingData', 'TD_FixMaps');
imageFiles = dir(fullfile(imageDir, '*.png'));
num_images = length(imageFiles);

% Loop through each image
for k = 1:num_images
    imagePath = fullfile(imageDir, imageFiles(k).name);
    out = Threshold(imread(imagePath));
    [~, imageName, ~] = fileparts(imagePath);  % Extract base image name
    outputFilename = fullfile('scratch/GT/TD', sprintf('%s.png', imageName));
    imwrite(mat2gray(out), outputFilename);
end

%% 
clc;
% Add the saliency performance metric toolbox path
addpath(fullfile(pwd, 'saliency', 'code_forMetrics'));
addpath(fullfile(pwd, 'saliency', 'code_forMetrics', 'FastEMD'));

%% Compute Performance table for TD Fixation maps

clc;


function performance_metric = computePerformaneMetric(modelName)
    performance = struct( ...
        'AUC_Borji', [0.0 0.0 0.0], ...
        'AUC_Judd', [0.0 0.0 0.0 0.0], ...
        'AUC_shuffled', [0.0 0.0 0.0], ...
        'CC', 0.0, ...
        'EMD', [0.0 0.0 0.0], ...
        'InfoGain', 0.0, ...
        'KLdiv', 0.0, ...
        'NSS', 0.0 ...
    );
    
    saliencyDir = fullfile('scratch', 'raw', modelName);
    saliencyFiles = dir(fullfile(saliencyDir, '*.png'));
    num_images = length(saliencyFiles);
    
    for k = 1:num_images
        disp([modelName ':' num2str(k)]);
        saliencyPath = fullfile(saliencyDir, saliencyFiles(k).name);
        [~, saliencyFileName, ~] = fileparts(saliencyPath);  % Extract base image name
        fixationFilename = fullfile('scratch/GT/TD', sprintf('%s.png', saliencyFileName));
        fixationSaliencyMapFilename = fullfile('Saliency4asd/TrainingData/TD_FixMaps', sprintf('%s.png', saliencyFileName));
    
        saliencyImg = imresize(im2double(imread(saliencyPath)), [256 256]);
        fixationMap = imresize(im2double(imread(fixationFilename)), [256 256]);
        fixationSaliencyMap = imresize(im2double(imread(fixationSaliencyMapFilename)), [256 256]);
    
        performance.AUC_Borji = performance.AUC_Borji + AUC_Borji(saliencyImg, fixationMap);
        performance.AUC_Judd = performance.AUC_Judd + AUC_Judd(saliencyImg, fixationMap);
        % performance.AUC_shuffled = AUC_shuffled();
        performance.CC = performance.CC + CC(saliencyImg, fixationSaliencyMap);
        % performance.EMD = EMD(saliencyImg, fixationSaliencyMap);
        % performance.InfoGain = InfoGain(saliencyImg, fixationMap);
        performance.KLdiv = performance.KLdiv + KLdiv(saliencyImg, fixationSaliencyMap);
        performance.NSS = performance.NSS + NSS(saliencyImg, fixationMap);
    end

        performance.AUC_Borji = performance.AUC_Borji ./ num_images;
        performance.AUC_Judd = performance.AUC_Judd ./ num_images;
        % performance.AUC_shuffled = AUC_shuffled();
        performance.CC = performance.CC / num_images;
        % performance.EMD = EMD(saliencyImg, fixationSaliencyMap);
        % performance.InfoGain = InfoGain(saliencyImg, fixationMap);
        performance.KLdiv = performance.KLdiv / num_images;
        performance.NSS = performance.NSS / num_images;

        performance_metric = performance;
end

performance_metric_fes = computePerformaneMetric('FES');
performance_metric_dvs = computePerformaneMetric('Dynamic_Visual_Attention');
performance_metric_covsal = computePerformaneMetric('CovSal');


%% Compute Performance table for ASD Fixation maps

clc;


function performance_metric = computePerformaneMetricASD(modelName)
    performance = struct( ...
        'AUC_Borji', [0.0 0.0 0.0], ...
        'AUC_Judd', [0.0 0.0 0.0 0.0], ...
        'AUC_shuffled', [0.0 0.0 0.0], ...
        'CC', 0.0, ...
        'EMD', [0.0 0.0 0.0], ...
        'InfoGain', 0.0, ...
        'KLdiv', 0.0, ...
        'NSS', 0.0 ...
    );
    
    saliencyDir = fullfile('scratch', 'raw', modelName);
    saliencyFiles = dir(fullfile(saliencyDir, '*.png'));
    num_images = length(saliencyFiles);
    
    for k = 1:num_images
        disp([modelName ':' num2str(k)]);
        saliencyPath = fullfile(saliencyDir, saliencyFiles(k).name);
        [~, saliencyFileName, ~] = fileparts(saliencyPath);  % Extract base image name
        fixationFilename = fullfile('scratch/GT/ASD', sprintf('%s.png', saliencyFileName));
        fixationSaliencyMapFilename = fullfile('Saliency4asd/TrainingData/ASD_FixMaps', sprintf('%s.png', saliencyFileName));
    
        saliencyImg = imresize(im2double(imread(saliencyPath)), [256 256]);
        fixationMap = imresize(im2double(imread(fixationFilename)), [256 256]);
        fixationSaliencyMap = imresize(im2double(imread(fixationSaliencyMapFilename)), [256 256]);
    
        performance.AUC_Borji = performance.AUC_Borji + AUC_Borji(saliencyImg, fixationMap);
        performance.AUC_Judd = performance.AUC_Judd + AUC_Judd(saliencyImg, fixationMap);
        % performance.AUC_shuffled = AUC_shuffled();
        performance.CC = performance.CC + CC(saliencyImg, fixationSaliencyMap);
        % performance.EMD = EMD(saliencyImg, fixationSaliencyMap);
        % performance.InfoGain = InfoGain(saliencyImg, fixationMap);
        performance.KLdiv = performance.KLdiv + KLdiv(saliencyImg, fixationSaliencyMap);
        performance.NSS = performance.NSS + NSS(saliencyImg, fixationMap);
    end

        performance.AUC_Borji = performance.AUC_Borji ./ num_images;
        performance.AUC_Judd = performance.AUC_Judd ./ num_images;
        % performance.AUC_shuffled = AUC_shuffled();
        performance.CC = performance.CC / num_images;
        % performance.EMD = EMD(saliencyImg, fixationSaliencyMap);
        % performance.InfoGain = InfoGain(saliencyImg, fixationMap);
        performance.KLdiv = performance.KLdiv / num_images;
        performance.NSS = performance.NSS / num_images;

        performance_metric = performance;
end

performance_metric_fes_asd = computePerformaneMetricASD('FES');
performance_metric_dvs_asd = computePerformaneMetricASD('Dynamic_Visual_Attention');
performance_metric_covsal_asd = computePerformaneMetricASD('CovSal');