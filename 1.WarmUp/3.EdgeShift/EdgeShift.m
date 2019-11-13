clearvars
close all

I = imread('SquareCircle.png');
I_Filtered3x3 = imread('I_3x3MedianFiltered.png');
I_Filtered_Median = I;
Filtersize = 7;     %Change the filtersize to better see the Edge Shift effect
[rows,cols] = size(I);
ctr = (Filtersize+1)/2;
Mean_Filter = ones(Filtersize,Filtersize)/(Filtersize^2);

for i = ctr:rows-ctr+1
    for j = ctr:cols-ctr+1
        ImgWindow = double(I(i-(ctr-1):i+(ctr-1),j-(ctr-1):j+(ctr-1)));
        I_Filtered_Median(i,j) = sum(sum(median(ImgWindow,'all') .* Mean_Filter));
    end
end

% This is where I first make the I_3x3MedianFiltered.png file.
%imwrite(I_Filtered_Median,'I_3x3MedianFiltered.png');
I_Median_C = I_Filtered_Median(128, : );
I_Original = I_Filtered3x3(128, : );

figure(), imshow(I_Filtered_Median); title('Median');
figure(), plot(I_Original);
hold on;
plot(I_Median_C,'r--'); title('Circles Edge Shift'); xlabel('# of Pixel');
ylabel('Intensity'); legend('Before','After'); hold off;

I_Median_Sq = I_Filtered_Median(384, : );
I_Original = I_Filtered3x3(384, : );

figure(), plot(I_Original);
hold on;
plot(I_Median_Sq,'r--'); title('Square Edge Shift'); xlabel('# of Pixel');
ylabel('Intensity'); legend('Before','After');