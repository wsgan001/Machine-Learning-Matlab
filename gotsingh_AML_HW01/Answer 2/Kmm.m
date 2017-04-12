function Ikm = Kmm(I,K) 

%% K-means Segmentation (option: K (Number of Clusters))

I = im2double(I);
F = reshape(I,size(I,1)*size(I,2),3);      % Color Features

%% K-means
% ceil(X) rounds each element of X to the nearest  
% integer greater than or equal to that element.

CENTS = F( ceil(rand(K,1)*size(F,1)) ,:);             % Randomly assigning Cluster Centers

% creates a matrix to store all distances between each point and initial
% centroids
DAL   = zeros(size(F,1),K+2);                      % Distances and Labels

% Repeat clustering KMI times using new initial cluster centroid positions 
% and display the final results of each five initializations. Choosing the
% best (with most stable cluster configuration i.e. within-cluster sums of 
% point-to-centroid distances) among the three.

KMI   = 3;                                           % K-means Iteration


for n = 1:KMI
   for i = 1:size(F,1)
      for j = 1:K  
        % DAL(i,j) = norm(F(i,:) - CENTS(j,:));  % norm calculates euclidean distance of the difference
        % calculating manhattan distances
        DAL(i,j) = sum(abs(F(i,:) - CENTS(j,:)),2); 
      end                                      % stores them in columns for each centroid
      % check each point is nearest to which centroid
      [Distance, CN] = min(DAL(i,1:K));        % 1:K are Distance from Cluster Centers 1:K
      % store the information of which cluster centroid that point belongs to.
      DAL(i,K+1) = CN;                                % K+1 is Cluster Label
      % stores the minimum distance info in last column of matrix
      DAL(i,K+2) = Distance;                          % K+2 is Minimum Distance
   end
   % for the same iteration 
   for i = 1:K
      % check for the points belonging to same clusters
      A = (DAL(:,K+1) == i);                          % Cluster K Points
      % find the centroid of new clusters and re-initialize them
      % F(A,:) where A is boolean matrix hence all point of F where A is
      % true are selected.
      CENTS(i,:) = mean(F(A,:));                      % New Cluster Centers
      
      % If CENTS(i,:) Is Nan Then Replace It With Random Point (a check)
      if sum(isnan(CENTS(:))) ~= 0                    
         NC = find(isnan(CENTS(:,1)) == 1);           % Find Nan Centers
         for Ind = 1:size(NC,1)
         CENTS(NC(Ind),:) = F(randi(size(F,1)),:);
         end
      end
   end
end

% create a matrix to store rbg value of the pixel
X = zeros(size(F));

for i = 1:K
idx = find(DAL(:,K+1) == i);
X(idx,:) = repmat(CENTS(i,:),size(idx,1),1); 
end
Ikm = reshape(X,size(I,1),size(I,2),3);
end
