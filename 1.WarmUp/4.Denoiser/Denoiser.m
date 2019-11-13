close all
clearvars

I = imread('LenaNoise.png');
figure, imshow(I); title('Original');

I_Filtered_Mean = I;
I_Filtered_Gaussian = I;
I_Filtered_Median = I;
Filtersize = 3;
[rows,cols] = size(I);
ctr = (Filtersize+1)/2;

% Mean Filter.
Mean_Filter = ones(Filtersize,Filtersize)/(Filtersize^2);
% End of Mean Filter.

% Gaussian Filter.
Sigma = Filtersize/3;
Gaussian_Filter = ones(Filtersize);
for i = 1:ctr
   Gaussian_Filter(i) = exp(-((ctr-i)*(ctr-i))/(2*Sigma*Sigma))/(sqrt(2*pi*Sigma));
   Gaussian_Filter(Filtersize+1-i) = Gaussian_Filter(i);
end
Gaussian_Filter_Rows = Gaussian_Filter(:,1);
Gaussian_Filter_Cols = Gaussian_Filter_Rows';
Gaussian_Filter = (Gaussian_Filter_Rows * Gaussian_Filter_Cols);
for i = 1:Filtersize
    Dev = sum(sum(Gaussian_Filter));
end
Gaussian_Filter = Gaussian_Filter/Dev;
% End of Gaussian Filter.

% To have the best chance of detecting outliers (salt and peper noises), I
% chose to aplly the Median Filter on the Original LenaNoise as my first
% step.
for i = ctr:rows-ctr+1
    for j = ctr:cols-ctr+1
        ImgWindow = double(I(i-(ctr-1):i+(ctr-1),j-(ctr-1):j+(ctr-1)));
        % Median Filter
        I_Filtered_Median(i,j) = sum(sum(median(ImgWindow,'all') .* Mean_Filter));
        % End of Median Filter
    end
end

% Then to smooth the image I chose to use the Gaussian Filter (Through
% trial of both Mean and Gaussian filters, I saw better resualts with The
% Gaussian Filter).
for i = ctr:rows-ctr+1
    for j = ctr:cols-ctr+1
        ImgWindow = double(I_Filtered_Median(i-(ctr-1):i+(ctr-1),j-(ctr-1):j+(ctr-1)));
        % Median Filter
        I_Filtered_Gaussian(i,j) = sum(sum(ImgWindow .* Gaussian_Filter));
    end
end

% The predefined imsharpen MATLAB function can be used to sharpen the image.
%Sharpend = imsharpen(I_Filtered_Median);
figure, imshow(I_Filtered_Gaussian); title('Filtered Median Gaussian');
%imwrite(I_Filtered_Gaussian,'Filtered_Median_Gaussian.png');
