close all
clearvars

Img = imread('Noisy_checkboard.PNG'); 
Img = rgb2gray(im2double(Img));
Filtersize = 3;
Sigma = 1;
Threshold = 0.0001;
H_Threshold = 0.1;
L_Threshold = 0.005;
[rows,cols] = size(Img);
K = 0.05;
ctr = 2;
Corner = size(Img);


% Reduce noise by Gaussian filter
Gaussian = fspecial('gaussian',Filtersize,Sigma);
Img_Gaussian = imfilter(Img,Gaussian);
% X and Y Gradients
[dx,dy] = gradient(Img_Gaussian);
% Defining Ixx, Iyy, Ixy
Ixx = dx.^2;
Iyy = dy.^2;
Ixy = dx.*dy;

% Sum of Squares + Determinant, Trace, and Corner Response + Tresholding.
for r = ctr:rows-ctr+1
    for c = ctr:cols-ctr+1
        
        ImgWindow = Ixx(r-(ctr-1):r+(ctr-1),c-(ctr-1):c+(ctr-1));
        Sxx = sum(sum(ImgWindow));
        ImgWindow = Iyy(r-(ctr-1):r+(ctr-1),c-(ctr-1):c+(ctr-1));
        Syy = sum(sum(ImgWindow));
        ImgWindow = Ixy(r-(ctr-1):r+(ctr-1),c-(ctr-1):c+(ctr-1));
        Sxy = sum(sum(ImgWindow));
        
        % Determinant and Trace to find the corner Response
        Det = (Sxx * Syy) - (Sxy^2);
        Trace = Sxx + Syy;
        R = Det - K * (Trace^2);
        
        % Thresholding
        if R > Threshold
            Corner(r,c) = Img_Gaussian(r,c);
        else
            Corner(r,c) = 0;
        end
        
    end
end


% X and Y Gradianet of Rs
[dx,dy] = gradient(Corner);
% Computing the Gradient Magnitude and Angle Images
M = abs(dx) + abs(dy);
A = round(atan2(dy, dx) * (180/pi));
for r = 1 : rows-ctr
    for c = 1 : cols-ctr
        if (A(r,c) <= 22.5 && A(r,c) > -22.5)...
                || A(r,c) > 157.5 || A(r,c) <= -157.5
            A(r,c) = 0;
        elseif (A(r,c) <= 67.5 && A(r,c) > 22.5)...
                || (A(r,c) > -157.5 && A(r,c) <= -112.5)
            A(r,c) = 45;
        elseif (A(r,c) <= 112.5 && A(r,c) > 67.5)...
                || (A(r,c) > -112.5 && A(r,c) <= -67.5)
            A(r,c) = 90;
        elseif (A(r,c) <= 157.5 && A(r,c) > 112.5)...
                || (A(r,c) > -67.5 && A(r,c) <= -22.5)
            A(r,c) = 135;
        end
    end
end
% Non-maximum suppression of Gradient Magnitude
M_1 = M;
for r = 2:rows-ctr
    for c = 2:cols-ctr
        %Suppress pixels at the image edge
        if r == 1 || r == (rows) || c == 1 || c == (cols)
            M_1(r, c) = 0;
        end
        A_1 = A(r, c) / 45;
            
            if A_1 == 0 % 0 is horizontal
                if M(r, c) <= M(r, c-1) || M(r, c) <= M(r, c+1)
                    M_1(r, c) = 0;
                end
            end
            if A_1 == 1 % 1 is 45 Degree
                if M(r, c) <= M(r-1, c+1) || M(r, c) <= M(r+1, c-1)
                    M_1(r, c) = 0;
                end
            end
            if A_1 == 2 % 2 is vertical
                if M(r, c) <= M(r-1, c) || M(r, c) <= M(r+1, c)
                    M_1(r, c) = 0;
                end
            end
            if A_1 == 3 % 3 is 135 Degree
                if M(r, c) <= M(r-1, c-1) || M(r, c) <= M(r+1, c+1)
                    M_1(r, c) = 0;
                end
            end
    end
end


% Double Thresholding and Connectivity Analysis
above_H_Threshold = M_1 > H_Threshold;
% Edge points above lower threshold. 
[above_H_Threshold_r, above_L_Threshold_c] = find(M_1 > L_Threshold);
% Row and colum coords of points above upper threshold.

% Obtain all connected regions in Above Low Threshold that include a point
% that has a value Above High Threshold. 
bw = bwselect(above_H_Threshold, above_L_Threshold_c, above_H_Threshold_r, 8);

figure(), imshow(bw); title('Harris Corner Detection Noisy');
