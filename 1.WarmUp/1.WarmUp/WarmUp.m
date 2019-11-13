clearvars
close all

GridSize = 500;     % Grid size of every blue and red box
rowsX2 = 5;         % Number of rows*2
clmnsX2 = 5;        % Number of columns*2

%Setting the grid colors
RedGrid = zeros(GridSize,GridSize,3);
RedGrid (1:GridSize, 1:GridSize, 1) = .8;
RedGrid (1:GridSize, 1:GridSize, 3) = .1;

BlueGrid = zeros(GridSize,GridSize,3);
BlueGrid (1:GridSize, 1:GridSize, 3) = .65;
BlueGrid (1:GridSize, 1:GridSize, 1) = .1;

I = [RedGrid, BlueGrid];
I1 = [BlueGrid, RedGrid];

I_Checker = [];
I_Checker1 = [];
I_Checker2 = [];
I_Checker3 = [];


for i = 1:clmnsX2
    I_Checker = [I_Checker, I];
    I_Checker1 = [I_Checker1, I1];
    I_Checker2 = [I_Checker; I_Checker1];
end

for j = 1:rowsX2
    I_Checker3 = [I_Checker3; I_Checker2];
end

figure(), imshow(I_Checker3); imwrite(I_Checker3,'WarmUp.png');