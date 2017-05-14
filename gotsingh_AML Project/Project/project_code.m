%{
Objective: To extract frequent patterns in data from child and parent,
about their object of focus either in sight or in hand.

Method: Apriori algorithm is used to extract association rules from pattern
happening over a particular transaction. A transaction in our case is
defined in terms of events happening in time duration.

Assumptions: Transaction is not attached to an event as in purchase or 
change in object of attention, or to an agent such as child or parent.
A trasaction is attatched to state of affairs in a duration of time.

%}

%{
Code high level: The data is broken into second wise ditribution of states,
for child and parent, eye and in-hand fixation object.

A duration t is defined for transaction. All the information about states
in that time t is used as a transaction.

A priori algorithm is used to find frequent accouring states and
association rules are defined in the process.

states refer to the object of fixation for child & parent in terms of gaze
and hold. 

child gaze fixation is refered as 'Ax' where x is the object ID.
child held object is refered as 'Bx' where x is the object ID.
Parent gaze fixation is refered as 'Cx' where x is the object ID.
Parent held object is refered as 'Dx' where x is the object ID.

subject id is used as a variable and report is generated for each subject
available in the data.

%}

t = input('Time Duration in seconds to record one transaction (e.g. 5): ');
min_s = input('Minimum Support Threshold (e.g. 3): ');
min_c = input('Minimum Confidence Threshold (e.g. 0.5): ');

filename =  strcat('s', string(min_s),'_c', string(min_c),'_t',string(t));
fileID = fopen(strcat(filename,'_Results.txt'),'w');

fprintf(fileID,...
 '------Apriori analysis of multiple perspective gaze data------\n');

fprintf(fileID,'\n');
fprintf(fileID,...
 'Analysis Results:\n');
fprintf(fileID,'\n');

fprintf(fileID,...
 'Child eye gaze is represented with Ax, where x is the object ID.\n');
fprintf(fileID,...
 'Child inhand item is represented with Bx, where x is the object ID.\n');
fprintf(fileID,...
 'Parent eye gaze is represented with Cx, where x is the object ID.\n');
fprintf(fileID,...
 'Parent inhand item is represented with Dx, where x is the object ID.\n');
fprintf(fileID,'\n');
fprintf(fileID,'\n');

% t = 5; % trasaction period
fprintf(fileID,strcat('Transaction Period in seconds :\t',...
                        string(t),'\n'));
% min_s = 3;  % support variable
fprintf(fileID,strcat('Minimum Support Value :\t',...
                        string(min_s),'\n'));

% min_c = 0.5;  % confidence level required
fprintf(fileID,strcat('Minimum Confidence Level :\t',...
                        string(min_c),'\n'));



subjects = [string('7206') string('7207') string('7208') string('7209') ...
    string('7211') string('7212') string('7213') string('7215')];

for idx = 1:length(subjects)
    subject_name = char(subjects(1,idx));
    
    fprintf(fileID,'\n');
    fprintf(fileID,'\n');
   
    fprintf(fileID,strcat('Subject Name :\t',string(subject_name),'\n'));


    child_eye = load(strcat('cevent_eye_roi_child/cevent_',...
                            subject_name,'.mat'));
    parent_eye = load(strcat('cevent_eye_roi_parent/cevent_',...
                             subject_name,'.mat'));
    child_inhand = load(strcat('cevent_inhand_child/cevent_',...
                             subject_name,'.mat'));
    parent_inhand = load(strcat('cevent_inhand_parent/cevent_',...
                              subject_name,'.mat'));

    data_child_eye = child_eye.sdata.data ;
    data_parent_eye = parent_eye.sdata.data;
    data_child_inhand = child_inhand.sdata.data;
    data_parent_inhand = parent_inhand.sdata.data;

    t_stamp1= data_child_eye(1:end,1);
    t_stamp2= data_parent_eye(1:end,1);
    t_stamp3= data_child_inhand(1:end,1);
    t_stamp4= data_parent_inhand(1:end,1);
    timestamp = vertcat(t_stamp1,t_stamp2, t_stamp3, t_stamp4);

    %{
                val=strcat(string(i),'<-- ',string(data_child_eye(a,1)),...
                ' -> & <- ',string(data_child_eye(a,2)));
                fprintf(val);
                fprintf('\n')
    %}

    tras_len = round((max(timestamp)-min(timestamp))/t)+1; % transaction nos.
    transactions = strings([tras_len,1]); % array for transactions
    t_counter = 1;  % transaction id/counter

    for i = min(timestamp):t:max(timestamp)
        val_A = '';
        for a = 1:size(data_child_eye,1)
            if i <= data_child_eye(a,1) && data_child_eye(a,1) <= i+t
                val_A = strcat(val_A,',A',string(data_child_eye(a,3)));
            elseif  i+t < data_child_eye(a,1)
               break;
            end
        end
        val_B = '';
        for b = 1:size(data_child_inhand,1)
            if i <= data_child_inhand(b,1) && data_child_inhand(b,1)<= i+t
                val_B = strcat(val_B,',B',string(data_child_inhand(b,3)));
            elseif  i+t < data_child_inhand(b,1)
               break;
            end
        end
        val_C = '';
        for c = 1:size(data_parent_eye,1)
            if i <= data_parent_eye(c,1) && data_parent_eye(c,1) <= i+t
                val_C = strcat(val_C,',C',string(data_parent_eye(c,3)));
            elseif  i+t < data_parent_eye(c,1)
               break;
            end
        end
        val_D = '';
        for d = 1:size(data_parent_inhand,1)
            if i <= data_parent_inhand(d,1) && data_parent_inhand(d,1)<= i+t
                val_D = strcat(val_D,',D',string(data_parent_inhand(d,3)));
            elseif  i+t < data_parent_inhand(d,1)
               break;
            end
        end
        transactions(t_counter,1) = strcat(val_A,val_B,val_C,val_D);
        t_counter = t_counter +1;
    end

    % transaction list is obtained, it contains duplicate items.

    % creating a structure to store count of each items 
    %--------------------------------------------------------------
    seq = {string('A1'),string('A2'),string('A3'),string('A4'),string('B1'),...
        string('B2'),string('B3'),string('B4'),string('C1'),string('C2'),...
        string('C3'),string('C4'),string('D1'),string('D2'),...
        string('D3'),string('D4')};
    seq_c = {0};

    itemset_one = struct('item_name',seq,'count',seq_c);
    %--------------------------------------------------------------

    % this is the section where we get started with the count 1-itemset
    for j = 1:size(transactions,1)
        % in each transaction only unique presence is counted
        %----------------------------------------------------
        unique_items = unique(strsplit(transactions(j),','));
        %----------------------------------------------------
        for k = 1:size(unique_items,2)
            % increment item count in each transaction iteration
            %----------------------------------------------------
            index = find([itemset_one.item_name] == unique_items(k));
            if index
                itemset_one(index).count = itemset_one(index).count +1;
            end
            %----------------------------------------------------
        end
    end


    % support check in itemset_one
    [col] = find([itemset_one.count] < min_s); % detect low support items 
    itemset_one(col)= []; % remove items with low support
    comb_one = transpose([itemset_one.item_name]);
    %---------------------------------------------------------------------

    [itemset_two,comb_two] = prune(comb_one);
    itemset_two = support(transactions,itemset_two,comb_two);

    % support check in itemset_two
    [col] = find([itemset_two.count] < min_s); % detect low support items 
    itemset_two(col)= []; % remove items with low support
    comb_two(col,:)=[];  % remove items with low support
    %----------------------------------------------------------------
    [itemset_three,comb_three] = prune(comb_two);
    itemset_three = support(transactions,itemset_three,comb_three);

    % support check in itemset_three
    [col] = find([itemset_three.count] < min_s); % detect low support items 
    itemset_three(col)= []; % remove items with low support
    comb_three(col,:)=[]; % remove items with low support
    %---------------------------------------------------------------------
    [itemset_four,comb_four] = prune(comb_three);
    itemset_four = support(transactions,itemset_four,comb_four);

    % support check in itemset_four
    [col] = find([itemset_four.count] < min_s); % detect low support items 
    itemset_four(col)= []; % remove items with low support
    comb_four(col,:)=[]; % remove items with low support
    %---------------------------------------------------------------------
    [itemset_five,comb_five] = prune(comb_four);
    itemset_five = support(transactions,itemset_five,comb_five);

    % support check in itemset_five
    [col] = find([itemset_five.count] < min_s); % detect low support items 
    itemset_five(col)= []; % remove items with low support
    comb_five(col,:)=[]; % remove items with low support
    %---------------------------------------------------------------------
    [itemset_six,comb_six] = prune(comb_five);
    itemset_six = support(transactions,itemset_six,comb_six);

    % support check in itemset_six
    [col] = find([itemset_six.count] < min_s); % detect low support items 
    itemset_six(col)= []; % remove items with low support
    comb_six(col,:)=[]; % remove items with low support
    %---------------------------------------------------------------------
    [itemset_seven,comb_seven] = prune(comb_six);
    itemset_seven = support(transactions,itemset_seven,comb_seven);

    % support check in itemset_seven
    [col] = find([itemset_seven.count] < min_s); % detect low support items 
    itemset_seven(col)= []; % remove items with low support
    comb_seven(col,:)=[]; % remove items with low support
    %---------------------------------------------------------------------

    % Association rule mining
    %---------------------------------------------------------------------
    %{
    Each highest frquency itemset is examined and confidence level is
    calculated for possibilities using high frequency lower itemset.
    %}

    for i = 1:size(comb_seven,1)
        s_comb_six = nchoosek(comb_seven(i,:),6); % shorter combos of six items
        s_temp= num2cell(s_comb_six,1);
        s_comb_six_names = strcat(s_temp{:}); % shorter combo names

        fprintf(fileID,'\n');
        fprintf(fileID,'\n');

        for j = 1: size(s_comb_six,1)
            temp = comb_seven(i,:);
            last = temp(~ismember(comb_seven(i,:),s_comb_six(j,:)));

            [row, col] = find([itemset_six.item_name] == s_comb_six_names(j));
            conf = itemset_seven(i).count/itemset_six(col).count;
            if conf >= min_c
                fprintf(fileID,strcat('Association Rule :\t',...
                    strjoin(s_comb_six(j,:),'\t'),'\t -> \t',string(last),...
                    '\tConfidence Level:\t',string(conf)));
                fprintf(fileID,'\n');
            end
        end
        fprintf(fileID,'\n');
        fprintf(fileID,'\n');
    end


  if isempty(comb_seven)
    for i = 1:size(comb_six,1)
        s_comb_five = nchoosek(comb_six(i,:),5); % shorter combos of six items
        s_temp= num2cell(s_comb_five,1);
        s_comb_five_names = strcat(s_temp{:}); % shorter combo names

        fprintf(fileID,'\n');
        fprintf(fileID,'\n');
        
        for j = 1: size(s_comb_five,1)
            temp = comb_six(i,:);
            last = temp(~ismember(comb_six(i,:),s_comb_five(j,:)));

            [row, col] = find([itemset_five.item_name] == s_comb_five_names(j));
            conf = itemset_six(i).count/itemset_five(col).count;
            if conf >= min_c
                fprintf(fileID,strcat('Association Rule :\t',...
                    strjoin(s_comb_five(j,:),'\t'),'\t -> \t',...
                    string(last),'\tConfidence Level:\t',string(conf)));
                    fprintf(fileID,'\n');
            end
        end
        
        fprintf(fileID,'\n');
        fprintf(fileID,'\n');
    end
  end
  
  if isempty(comb_six)
    for i = 1:size(comb_five,1)
        s_comb_four = nchoosek(comb_five(i,:),4); % shorter combos of five items
        s_temp= num2cell(s_comb_four,1);
        s_comb_four_names = strcat(s_temp{:}); % shorter combo names

        fprintf(fileID,'\n');
        fprintf(fileID,'\n');
        
        for j = 1: size(s_comb_four,1)
            temp = comb_five(i,:);
            last = temp(~ismember(comb_five(i,:),s_comb_four(j,:)));

            [row, col] = find([itemset_four.item_name] == s_comb_four_names(j));
            conf = itemset_five(i).count/itemset_four(col).count;
            if conf >= min_c
                fprintf(fileID,strcat('Association Rule :\t',...
                    strjoin(s_comb_four(j,:),'\t'),'\t -> \t',...
                    string(last),'\tConfidence Level:\t',string(conf)));
                    fprintf(fileID,'\n');
            end
        end
        
        fprintf(fileID,'\n');
        fprintf(fileID,'\n');
    end
   end
 

   if isempty(comb_five)
    for i = 1:size(comb_four,1)
        s_comb_three = nchoosek(comb_four(i,:),3); % shorter combos of four items
        s_temp= num2cell(s_comb_three,1);
        s_comb_three_names = strcat(s_temp{:}); % shorter combo names

        fprintf(fileID,'\n');
        fprintf(fileID,'\n');
        
        for j = 1: size(s_comb_three,1)
            temp = comb_four(i,:);
            last = temp(~ismember(comb_four(i,:),s_comb_three(j,:)));

            [row, col] = find([itemset_three.item_name] == s_comb_three_names(j));
            conf = itemset_four(i).count/itemset_three(col).count;
            if conf >= min_c
                fprintf(fileID,strcat('Association Rule :\t',...
                    strjoin(s_comb_three(j,:),'\t'),'\t -> \t',...
                    string(last),'\tConfidence Level:\t',string(conf)));
                    fprintf(fileID,'\n');
            end
        end
        
        fprintf(fileID,'\n');
        fprintf(fileID,'\n');
    end
   end
   if isempty(comb_four)
    for i = 1:size(comb_three,1)
        s_comb_two = nchoosek(comb_three(i,:),2); % shorter combos of three items
        s_temp= num2cell(s_comb_two,1);
        s_comb_two_names = strcat(s_temp{:}); % shorter combo names

        fprintf(fileID,'\n');
        fprintf(fileID,'\n');
        
        for j = 1: size(s_comb_two,1)
            temp = comb_three(i,:);
            last = temp(~ismember(comb_three(i,:),s_comb_two(j,:)));

            [row, col] = find([itemset_two.item_name] == s_comb_two_names(j));
            conf = itemset_three(i).count/itemset_two(col).count;
            if conf >= min_c
                fprintf(fileID,strcat('Association Rule :\t',...
                    strjoin(s_comb_two(j,:),'\t'),'\t -> \t',...
                    string(last),'\tConfidence Level:\t',string(conf)));
                    fprintf(fileID,'\n');
            end
        end
        
        fprintf(fileID,'\n');
        fprintf(fileID,'\n');
    end
   end
    
end

fclose(fileID);



