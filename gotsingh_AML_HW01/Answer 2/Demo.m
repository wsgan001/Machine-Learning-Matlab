% This code implemented a comparison between “k-means” and “mean-shift”
% Teste methods are:
% Kmeans segmentation using (color) only
% Kmeans segmentation using (color + spatial)
% Mean Shift segmentation using (color) only
% Mean Shift segmentation using (color + spatial)

% an implementation by "Bryan Feldman" is used for “mean-shift clustering" 

%% clear command windows
clc;
close all;

%% input
% read the image in 3 dimensional array containing rgb value for each
% pixel

I    = imread('Female_face.jpg');


%% parameters
% kmeans parameter
K1    = 2;                  % Cluster Numbers
K2    = 4;                  % Cluster Numbers
K3    = 6;                  % Cluster Numbers
K4    = 8;                  % Cluster Numbers
% meanshift parameter
bw1  = 0.1;                % Mean Shift Bandwidth
bw2  = 0.2;                % Mean Shift Bandwidth
bw3  = 0.4;                % Mean Shift Bandwidth
bw4  = 0.8;                % Mean Shift Bandwidth

%% compare
% k means on euclidean distance
Ikm1          = Km(I,K1);                     % Kmeans (color)
Ikm2          = Km(I,K2);                     % Kmeans (color)
Ikm3          = Km(I,K3);                     % Kmeans (color)
Ikm4          = Km(I,K4);                     % Kmeans (color)

% kmeans on manhattan distance
Ikm11          = Kmm(I,K1);                     % Kmeans (color)
Ikm12          = Kmm(I,K2);                     % Kmeans (color)
Ikm13          = Kmm(I,K3);                     % Kmeans (color)
Ikm14          = Kmm(I,K4);                     % Kmeans (color)
%{
[Ims1, Nms1]   = Ms(I,bw1);                    % Mean Shift (color)
[Ims2, Nms2]   = Ms(I,bw2);                    % Mean Shift (color)
[Ims3, Nms3]   = Ms(I,bw3);                    % Mean Shift (color)
[Ims4, Nms4]   = Ms(I,bw4);                    % Mean Shift (color)
%}
%{
Ikm2         = Km2(I,K);                    % Kmeans (color + spatial)
[Ims2, Nms2] = Ms2(I,bw);                   % Mean Shift (color + spatial)
%}

%% show
fig1 = figure(1);
subplot(141); imshow(I);    title('Original'); 
%saveas(fig1,'original.jpg');

fig2 = figure(2);
subplot(241); imshow(Ikm1);   title(['Kmeans-E',' : ',num2str(K1)]);
subplot(242); imshow(Ikm2);   title(['Kmeans-E',' : ',num2str(K2)]);
subplot(243); imshow(Ikm3);   title(['Kmeans-E',' : ',num2str(K3)]);
subplot(244); imshow(Ikm4);   title(['Kmeans-E',' : ',num2str(K4)]);
subplot(245); imshow(Ikm11);  title(['Kmeans-M',' : ',num2str(K1)]);
subplot(246); imshow(Ikm12);  title(['Kmeans-M',' : ',num2str(K2)]);
subplot(247); imshow(Ikm13);  title(['Kmeans-M',' : ',num2str(K3)]);
subplot(248); imshow(Ikm14);  title(['Kmeans-M',' : ',num2str(K4)]);
imshow(fig2);
saveas(fig2,'kmeans.jpg');

%{
fig3 = figure(3);
subplot(141); imshow(Ims1);  title(['MeanShift',' : ',num2str(Nms1)]);
subplot(142); imshow(Ims2);  title(['MeanShift',' : ',num2str(Nms2)]);
subplot(143); imshow(Ims3);  title(['MeanShift',' : ',num2str(Nms3)]);
subplot(144); imshow(Ims4);  title(['MeanShift',' : ',num2str(Nms4)]);
imshow(fig3);
saveas(fig3,'meanshift.jpg')
%}
%{
subplot(233); imshow(Ikm2); title(['Kmeans+Spatial',' : ',num2str(K)]); 
subplot(235); imshow(Ims2); title(['MeanShift+Spatial',' : ',num2str(Nms2)]);
%}
