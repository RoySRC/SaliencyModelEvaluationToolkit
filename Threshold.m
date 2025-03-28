%% Q1

% This function is used to adaptively threshold a given input image, img.
% The thresholding is achieved through an iterative process.

function binarized_image = Threshold(img)

    % define delta T
    delta_T = eps;
    
    % create a variable to store the running delta
    running_delta = realmax; % longest positive floating point number
    
    % define intial value of T
    T = 0.5;
    
    % read the image
    img = im2gray(img);
    img = im2double(img); % scale intensities between [0,1]
    
    while running_delta > delta_T
    
        G = img;
        G(img > T) = 1;
        G(img <= T) = 0;
        
        % Compute m1
        m1 = sum(sum(img(G == 1)));
        m1 = m1 / sum(sum(G == 1));
        
        % Compute m2
        m2 = sum(sum(img(G == 0)));
        m2 = m2 / sum(sum(G == 0));
        
        new_T = 0.5 * (m1 + m2);
        running_delta = abs(new_T - T);
        T = new_T;
    
    end
    
    % At this point, I have the threshold value
    % Time to apply the thresholding to binarize the input image
    binarized_image = img;
    binarized_image(binarized_image >= T) = 1;
    binarized_image(binarized_image < T) = 0;
    
    
