clear all
clc

imageDir = './Saliency4asd/TrainingData/Images/'; % replace with you image directory
resultFolder = './result/'; % where to store images

imgList = dir([imageDir '*.png']);

for i = 1:1
    %% load a RGB image
    img = imread('../Saliency4asd/TrainingData/Images/(2).png');
    [x, y, ~] = size(img);
    
    %% transform it to LAB
    img = RGB2Lab(img);
    
    %% laod a prior or perform uniform initialization
    
    % if you have prior
    load('prior');
    % otherwise
    p1 = 0.5*ones(128, 171); % uncomment for uniform initialization
    
    %% compute the saliency
    % function saliency = computeFinalSaliency(image, pScale, sScale, alpha, sigma0, sigma1, p1)
    saliency = computeFinalSaliency(img, [8 8 8], [13 25 38], 30, 10, 1, p1);
    saliency = imresize(saliency, [x,y]);
    % imwrite(saliency, [resultFolder, imgList(i).name]);
    imshow(saliency);
end