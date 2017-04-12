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

% setting the parameter. Considering the 2 nearest neighbours for labeling
% new data point
k =2;


% Output category label
[neighbors, distances] = kNearestNeighbors(training_data,sample_data,k);
voteMatrix=zeros(1,3);
for i=1:k
    if training_label(neighbors(i),1) == 'a'
        voteMatrix(1,1)=plus(voteMatrix(1,1),(1/distances(i)));
    end
    if training_label(neighbors(i),1) == 'b'
        voteMatrix(1,2)=plus(voteMatrix(1,3),(1/distances(i)));
    end
    if training_label(neighbors(i),1) == 'c'
        voteMatrix(1,3)=plus(voteMatrix(1,3),(1/distances(i)));
    end
end


[M,I] = max(voteMatrix);
if I ==1
    display('a','The label of [x y]');
end
if I ==2
    display('b','The label of [x y]');
end
if I ==3
    display('c','The label of [x y]');
end


%Visualize both the input and training data in a plot (with category colors).
newx =[training_data(:,1);sample_data(:,1)];
newy =[training_data(:,2);sample_data(:,2)];
newz =[training_label; 'x'];
labels={'a','b','c'};
fig2 = figure(2);
gplotmatrix(newx,newy,newz,['r','b','g','k'],('...x'));
saveas(fig2,'KNN-Weighted.jpg')
