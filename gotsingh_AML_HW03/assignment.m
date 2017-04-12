
disp('Dataset consists of gaze streams with multiple categorical values')
disp('Different categories indicate different region?of?interest');
disp('Categories 1-25 are indicated by A -Y');
% We have a categorical data, with continuous record of observation
% There are no transactions or baskets.





%--------------reading data from file--------------------------------------
% list of files in the directory
d=dir('*.mat');  % get the list of files
s = input('Please provide support threshold value eg. 2 : ');
c = input('Please provide confidence threshold value eg. 0.5 : ');

disp(['The support threshold is: ', num2str(s)]);
disp(['The confidence threshold is: ',num2str(c)]);
disp('');

for file = 1:length(d)
    raw_data =load(d(file).name);
    disp('----------------------');
    disp('-------New File-------');
    disp('');
    disp([d(file).name]);
    disp('');
    data =[raw_data.sdata.data]; % matrix data
    try
        apriori(data, s, c);
    catch
        disp('parameter issue');
    end
end
