close all
clearvars

I = imread('Part.png');
figure, imshow(I); title('Original');

I_Filtered_Mean = I;
I_Filtered_Gaussian = I;
I_Filtered_Median = I;
Filtersize = 3;
[rows,cols] = size(I);
ctr = (Filtersize+1)/2;

% Mean Filter
Mean_Filter = ones(Filtersize,Filtersize)/(Filtersize^2);
% End of Mean Filter

% Gaussian Filter
Sigma = Filtersize/3;
Gaussian_Filter = zeros(Filtersize);
for i = 1:ctr
    for j = 1:ctr
        Gaussian_Filter(i,j) = exp(-(((ctr-i)*(ctr-i)) + ((ctr-j)*(ctr-j)))/(2*Sigma*Sigma))/(sqrt(2*pi*Sigma));
        Gaussian_Filter(Filtersize+1-i,Filtersize+1-j) = Gaussian_Filter(i,j);
        Gaussian_Filter(Filtersize+1-i,j) = Gaussian_Filter(i,j);
        Gaussian_Filter(i,Filtersize+1-j) = Gaussian_Filter(i,j);
    end
end
Dev = sum(sum(Gaussian_Filter));
Gaussian_Filter = Gaussian_Filter/Dev;
% End of Gaussian Filter

for i = ctr:rows-ctr+1
    for j = ctr:cols-ctr+1
        ImgWindow = double(I(i-(ctr-1):i+(ctr-1),j-(ctr-1):j+(ctr-1)));
        I_Filtered_Mean(i,j) = sum(sum(ImgWindow .* Mean_Filter));
        I_Filtered_Gaussian(i,j) = sum(sum(ImgWindow .* Gaussian_Filter));
        
        % Median Filter
        I_Filtered_Median(i,j) = median(ImgWindow(:));
        % End of Median Filter

    end
end

figure(), imshow(I_Filtered_Mean); title('Mean');
figure(), imshow(I_Filtered_Gaussian); title('Gaussian');
figure(), imshow(I_Filtered_Median); title('Median');