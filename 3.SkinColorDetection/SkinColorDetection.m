close all
clearvars


I = imread('Messi.jpg');
figure, imshow(I);

R = double(I(:,:,1)); G = double(I(:,:,2)); B = double(I(:,:,3));

% figure, imagesc(R); axis equal; title('R');
% figure, imagesc(G); axis equal; title('G');
% figure, imagesc(B); axis equal; title('B');

Y = 0.299*R + 0.287*G + 0.11*B;
Cr = R - Y;
Cb = B - Y;

% figure, imagesc(Cr); axis equal; title('Cr');
% figure, imagesc(Cb); axis equal; title('Cb');

mask = zeros (size(R));
mask(Cr<110 & Cr>10 & Cb<50 & Cb>-15 & R>45 & G>40 & B>35 & R>G & R>B ...
    & abs(R-G)>15) = 1;
% I used a combination of RGB and YCbCr(Luminance, Chrominance) Color Model
% Inspired by S. Kolkuret el, 2016
skinColorOverlay = labeloverlay(I,mask);
figure, imshow(skinColorOverlay);
imwrite(skinColorOverlay, 'Messi_Output.jpg')