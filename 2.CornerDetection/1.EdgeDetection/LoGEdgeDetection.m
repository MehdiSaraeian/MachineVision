close all
clearvars


Sigma = 1.2;
% Filter Size should be an odd number so I used ceil()*2+1 to do that
Filtersize = ceil(Sigma*3)*2 + 1;
H_Threshold = 16;
L_Threshold = 10;
I = imread('twoCircles.png');
I = rgb2gray(I);
[rows,cols] = size(I);
ctr = (Filtersize+1)/2;
I_LoG = zeros(rows,cols);
I_Cross = zeros(rows,cols);


% LoG
LoG = ones(Filtersize);
for r = 1:ctr
    for c = 1:ctr
        LoG(r,c) = exp(((-(((ctr-r)^2) + ((ctr-c)^2))) / (2*(Sigma^2))))...
            * ((((ctr-r)^2 + (ctr-c)^2 - 2*(Sigma^2)) / (2*pi*(Sigma^6))));
        LoG(Filtersize+1-r , Filtersize+1-c) = LoG(r,c);
        LoG(Filtersize+1-r , c) = LoG(r,c);
        LoG(r , Filtersize+1-c) = LoG(r,c);
    end
end
% End of LoG


for r = ctr:rows-ctr+1
    for c = ctr:cols-ctr+1
        ImgWindow = double(I(r-(ctr-1):r+(ctr-1),c-(ctr-1):c+(ctr-1)));
        I_LoG(r,c) = sum(sum(ImgWindow .* LoG));
    end
end
figure(), imshow(I_LoG); title('LoG');


% Zero Crossings & Thresholding
for r = ctr:rows-ctr+1
    for c = ctr:cols-ctr+1
        if sign(I_LoG(r,c)) ~= sign(I_LoG(r+1,c)) && ...
                abs(I_LoG(r,c)-I_LoG(r+1,c)) > H_Threshold
            I_Cross(r,c) = 255;
            if abs(I_LoG(r+1,c)-I_LoG(r+2,c)) > L_Threshold
                I_LoG(r+1,c) = L_Threshold + I_LoG(r+1,c);
            elseif abs(I_LoG(r,c+1)-I_LoG(r,c+2)) > L_Threshold
                I_LoG(r,c+1) = L_Threshold + I_LoG(r,c+1);
            elseif abs(I_LoG(r-1,c)-I_LoG(r,c)) > L_Threshold
                I_LoG(r-1,c) = L_Threshold + I_LoG(r-1,c);
            elseif abs(I_LoG(r,c-1)-I_LoG(r,c)) > L_Threshold
                I_LoG(r,c-1) = L_Threshold + I_LoG(r,c-1);
            end
        elseif sign(I_LoG(r,c)) ~= sign(I_LoG(r,c+1)) && ...
                abs(I_LoG(r,c) - I_LoG(r,c+1)) > H_Threshold
            I_Cross(r,c) = 255;
            if abs(I_LoG(r+1,c)-I_LoG(r+2,c)) > L_Threshold
                I_LoG(r+1,c) = L_Threshold + I_LoG(r+1,c);
            elseif abs(I_LoG(r,c+1)-I_LoG(r,c+2)) > L_Threshold
                I_LoG(r,c+1) = L_Threshold + I_LoG(r,c+1);
            elseif abs(I_LoG(r-1,c)-I_LoG(r,c)) > L_Threshold
                I_LoG(r-1,c) = L_Threshold + I_LoG(r-1,c);
            elseif abs(I_LoG(r,c-1)-I_LoG(r,c)) > L_Threshold
                I_LoG(r,c-1) = L_Threshold + I_LoG(r,c-1);
            end
        else
            I_Cross(r,c) = 0;
        end
    end
end

figure(), imshow(I_Cross); title('LoG Edge Detection');