close all
clearvars


I = imread('twoCircles.png');
I = rgb2gray(I);
Filtersize = 3;
Sigma = Filtersize/3;
H_Threshold = 200;
L_Threshold = 85;
[rows,cols] = size(I);
ctr = (Filtersize+1)/2;
I_Gaussian = zeros(size(I));
I_Gaussian_Sobel_X = zeros(size(I));
I_Gaussian_Sobel_Y = zeros(size(I));
Z = zeros(rows,cols,100);

% Reduce noise by Gaussian filter
Gaussian = fspecial('gaussian',Filtersize,Sigma);
for r = ctr:rows-ctr+1
    for c = ctr:cols-ctr+1
        ImgWindow = double(I(r-(ctr-1):r+(ctr-1),c-(ctr-1):c+(ctr-1)));
        I_Gaussian(r,c) = sum(sum(ImgWindow .* Gaussian));
    end
end


% Sobel x and y filters are used to get horizontal and vertical gradients
Sobel_Y = [1 2 1; 0 0 0; -1 -2 -1];
Sobel_X = -Sobel_Y';
for r = ctr:rows-ctr+1
    for c = ctr:cols-ctr+1
        ImgWindow = double(I_Gaussian(r-(ctr-1):r+(ctr-1)...
            ,c-(ctr-1):c+(ctr-1)));
        I_Gaussian_Sobel_X(r,c) = sum(sum(ImgWindow .* Sobel_X));
        I_Gaussian_Sobel_Y(r,c) = sum(sum(ImgWindow .* Sobel_Y));
    end
end


% Computing the Gradient Magnitude and Angle Images
M = abs(I_Gaussian_Sobel_X) + abs(I_Gaussian_Sobel_Y);
A = round(atan2(I_Gaussian_Sobel_Y, I_Gaussian_Sobel_X) * (180/pi));
for r = 1:rows
    for c = 1:cols
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
for r = 2:rows
    for c = 2:cols
        %Suppress pixels at the image edge
        if r == 0 || r == (rows-1) || c == 0 || c == (cols-1)
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
Canny = bwselect(above_H_Threshold, above_L_Threshold_c, above_H_Threshold_r, 8);

figure(), imshow(Canny); title('Canny');


for r = 3: rows
    for c = 3: cols
        if Canny(r,c) == 1
            for R = 45: 60
                for t = 0: 360
                    a = r - R * cos(t * pi / 180);
                    b = c - R * sin(t * pi / 180);
                    a = round(a);
                    b = round(b);
                    if a > 0 && b > 0 && a < 141 && b < 401
                        Z(a,b,R) = Z(a,b,R)+1;
                    end
                end
            end
        end
    end
end
center = max(Z,[],3);

figure(), imshow(uint8(center)); title('center');