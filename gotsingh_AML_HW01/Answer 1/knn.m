% Create a larger dataset which is composed of three Gaussians 
%(e.g., 1000 data points for each category).

N =1000;
training_data=[normrnd(0,1,[N,2]);normrnd(0.5,2,[N,2]);normrnd(0.1,1,[N,2])];
training_label=[repmat('a',N,1);repmat('b',N,1);repmat('c',N,1)];
gplotmatrix(training_data(:,1),training_data(:,2),training_label,['r','b','g','k'],('...X'));

%Allow users to enter an input: [x y], and output the category label.
x_input = input(' x of [x y] = ');
y_input = input(' y of [x y] = ');
sample_data = [x_input y_input];

% setting parameter value. Number of nearest neighbours to consider for 
% finding label of the new data point.
k =2;


% Output category label
[neighbors, distances] = kNearestNeighbors(training_data,sample_data,k);
labelMatrix = zeros(1,k);
for i=1:k
    labelMatrix(1,i)=training_label(neighbors(i),:);
end
display(char(mode(labelMatrix,2)),'The label of [x y]');



%Visualize both the input and training data in a plot (with category colors).
newx =[training_data(:,1);sample_data(:,1)];
newy =[training_data(:,2);sample_data(:,2)];
newz =[training_label; 'x'];
fig1 = figure(1);
gplotmatrix(newx,newy,newz,['r','b','g','k'],('...x'));
saveas(fig1,'KNN-MajVote.jpg')