%Image retrieval function
image_foldername='data'; %'chen1000';
%Assuming for result calculations that the query image is from the folder 
queryimage_number =14;
queryimage_name =strcat('sample_',int2str(queryimage_number),'.jpg');

%extract names of image files
filenames=dir(fullfile(image_foldername,'*.jpg'));
filenames={filenames.name};

%image count in the folder
image_count=numel(filenames);


%color space transform
cform = makecform('srgb2lab');  

% transform query image
img=imresize(imread(fullfile(image_foldername,queryimage_name)),1/30);
img_Y= size(img,1);
img_X= size(img,2);
img_N= img_Y*img_X;

imgQ= double(img)./255;
imgQ_lab= applycform(imgQ, cform);




%empty matrix to store results
result_matrix= zeros(image_count,2);


threshold= 10;
alpha_color= 1/2;
coordinates_transformation= 2; 
extra_mass_penalty= -1;
flowType= 3;



for i=1:image_count
  imgI = imresize(imread(fullfile(image_foldername,filenames{i})),1/30);
  imgI_Y= size(imgI,1);
  imgI_X= size(imgI,2);
  imgI_N= imgI_Y*imgI_X;
  imgI= double(imgI)./255;
  imgI_lab= applycform(imgI, cform);
  
  
  P= [ ones(img_N,1)  ;  zeros(imgI_N,1) ];
  Q= [ zeros(img_N,1) ;  ones(imgI_N,1)  ];
 
  [ground_distance_matrix]= color_spatial_EMD_ground_distance(imgQ_lab,imgI_lab,...
                                                  alpha_color,threshold, ...
                                                  coordinates_transformation);
  [emd_hat_mex_val_with_flow,F]= emd_hat_mex(P,Q,ground_distance_matrix,extra_mass_penalty,flowType);
  
  fprintf('iteration number : %d\n', i)
  result_matrix(i,:)=[emd_hat_mex_val_with_flow i];
end

% sorting the distance matrix 
result= sortrows(result_matrix);

fig1 = figure(1);
% plotting the queryimage
I= imread(fullfile(image_foldername,queryimage_name));
subplot(2,2,1); 
imshow(I); 
title(sprintf('Query Image: %s',queryimage_name),'Interpreter','none');

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

saveas(fig1,'earth_movers_distance.jpg')
