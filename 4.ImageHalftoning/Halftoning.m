close all
clearvars

I = imread('David.png');    % Checking with a higher resolution image
I = rgb2gray(I);
[M,N] = size(I);
bij = zeros(M,N);
eij = zeros(M,N);

for i=3 : M
    for j=3 : N-2
        errAdd = 8/42*eij(i,j-1) + 4/42*eij(i,j-2) + 2/42*eij(i-1,j+2)...
            + 4/42*eij(i-1,j+1) + 8/42*eij(i-1,j) + 4/42*eij(i-1,j-1)...
            + 2/42*eij(i-1,j-2) + 1/42*eij(i-2,j+2) + 2/42*eij(i-2,j+1)...
            + 4/42*eij(i-2,j) + 2/42*eij(i-2,j-1) + 1/42*eij(i-2,j-2);
        if (I(i,j) + errAdd) > 127.5
            bij(i,j) = 255;
            eij(i,j) = I(i,j) + errAdd - 255;
        else
            bij(i,j) = 0;
            eij(i,j) = I(i,j) + errAdd;
        end
    end
end

figure, imshow(uint8(bij));title('Pr 2');
BW = dither(I); % Comparing to the built-in function
figure, imshow(BW); title('Matlab built-in');
