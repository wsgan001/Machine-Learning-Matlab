%Image retrieval function
image_foldername='data';%'chen1000';
%Assuming for result calculations that the query image is from the folder 
queryimage_number =1;
queryimage_name =strcat('sample_',int2str(queryimage_number),'.jpg');

%extract names of image files
filenames=dir(fullfile(image_foldername,'*.jpg'));
filenames={filenames.name};

%image count in the folder
image_count=numel(filenames);

% compute 3-D image histograms (LAB color space) for query image:
fprintf('Computing 3-D (HSV) histogram for query image...\n');
[HistQ, RGBQ] = getImageHists(fullfile(image_foldername,queryimage_name));
Hist_Q = reshape(HistQ,1,[]);

% compute 3-D image histograms (LAB color space)for images from the folder
fprintf('Computing 3-D (HSV) histogram for folder images...\n');
dist_func=@histogram_intersection;

distance_matrix= zeros(image_count,2);

for i=1:image_count
  I = fullfile(image_foldername,filenames{i});
  
  [HistI, RGBI] = getImageHists(I);
  Hist_I = reshape(HistI,1,[]);
  D = pdist2(Hist_Q,Hist_I,dist_func);
  distance_matrix(i,:)=[D i];
end

% sorting the distance matrix 
result= sortrows(distance_matrix);

fig2= figure(2);
% plotting the queryimage
I= imread(fullfile(image_foldername,queryimage_name));
subplot(2,2,1); 
imshow(I); 
title(sprintf('Query Image %s', queryimage_name),'Interpreter','none');

% Assuming that the query image is from the folder only
I= imread(fullfile(image_foldername,filenames{result(2,2)}));
subplot(2,2,2);  
imshow(I); 
title(sprintf('Image- %s Dist score = %.3f',filenames{result(2,2)},result(2,1)),'Interpreter','none'); 

I= imread(fullfile(image_foldername,filenames{result(3,2)}));
subplot(2,2,3);  
imshow(I);  
title(sprintf('Image- %s Dist score = %.3f',filenames{result(3,2)},result(3,1)),'Interpreter','none'); 

I= imread(fullfile(image_foldername,filenames{result(4,2)}));
subplot(2,2,4);  
imshow(I); 
title(sprintf('Image- %s Dist score = %.3f',filenames{result(4,2)},result(4,1)),'Interpreter','none'); 

saveas(fig2,'histogram_interspection.jpg')