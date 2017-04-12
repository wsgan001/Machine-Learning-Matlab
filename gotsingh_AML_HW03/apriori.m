function NULL = apriori(data , support, confidence)
s =support; % support threshold value
c = confidence; %confidence threshold

n =length(data);
seq = []; % empty initial length array to store transformed data
serial =1; % serial count for new transformed data
tempval = data(1,3); % assigning temp value to first item in the sequence
for i =2:n % starting loop from second value in the sequence
    if data(i,3) ~= tempval % condn: if the values do not match
        seq(serial,1) = tempval+64; % value gets entered in the matrix
        tempval = data(i,3);  % reassign the temp value
        serial = serial + 1;  % move to the next row of t_data matrix
    end
end


gaze = struct('seq',char(seq)); % sequence of char instead of digits
sequence =strcat(transpose(gaze.seq)); % in string format

freq = tabulate(gaze.seq); % frequency tabulation
table=struct('item',string('ABC'),'count',2); % basic structure


% ------------------sequential pattern matching-----------------------%

% --------------------------------------------------------------------%
table1 = table; % table struct for 1 itemset frequency 
table1.item=string(cell2mat(freq(:,1)));
table1.count=cell2mat(freq(:,2));



[row, col] = find(table1.count<s); % deleting below threshold values 
table1.item(row)=[]; 
table1.count(row)=[];

% --------------------------------------------------------------------%
table2=table; % table struct for 2 itemset frequency 



counter=1;
for i =1: length(table1.item)
    for j =i+1:length(table1.item) %table1 is lexigraphically arranged
        temp = strcat(table1.item(i),table1.item(j));
        v = strfind(sequence,temp); % count =length(v)
        if ~isempty(v)
            table2.item(counter)=temp;
            table2.count(counter)=length(v);
            counter =counter + 1;
        end
    end
end
 
table2.item=transpose(table2.item);
table2.count=transpose(table2.count);

[row, col] = find(table2.count<s);
table2.item(row)=[];
table2.count(row)=[];

% --------------------------------------------------------------------%
table3=table; % table struct for 2 itemset frequency 

counter=1;
for i =1: length(table1.item)% table1 is lexigraphically arranged
    for j =i+1:length(table1.item) 
        for k =j+1:length(table1.item)
            temp = strcat(table1.item(i),table1.item(j),table1.item(k));
             v = strfind(sequence,temp); % count =length(v)
            if ~isempty(v)
                table3.item(counter)=temp;
                table3.count(counter)=length(v);
                counter =counter + 1;
            end
        end
    end
end
 
table3.item=transpose(table3.item);
table3.count=transpose(table3.count);

[row, col] = find(table3.count<s);
table3.item(row)=[];
table3.count(row)=[];

% ------------------Items in region of interest-----------------------%
roi_name=[string('helmet'),	string('house'),string('bluecar'),...
    string('rose'),	string('elephant'),string('snowman'),...
    string('rabbit'),string('spongebob'),string('turtle'),...
    string('hammer'),string('ladybug'),string('mantis'),...
    string('greencar'),string('saw'),string('doll'),string('phone'),...
    string('rubiks'),string('shovel'),string('bigwheels'),...
    string('whitecar'),string('ladybugstick'),string('purpleblock'),...
    string('bed'),string('clearblock'),string('face')];
% -----------------------association rules----------------------------%



try 
    flag =0;
    for i = 1:length(table2.item)
        c_arr = char(table2.item(i));
        p_ab = table2.count(i);
        p_a = length(strfind(sequence,c_arr(1)));
        confidence = p_ab/p_a;
        if confidence > c
            disp('');
            disp(['*** Association rule 2-itemset: ',c_arr(1),...
                '->',c_arr(2),....
                ' with confidence level: ',num2str(confidence,2)]);
            flag =1;
            disp(['Thus child goes from :', ...
                roi_name(int16(c_arr(1))-64),'->',...
                roi_name(int16(c_arr(2))-64)]);
            disp('');
        else
            disp(['Association rejected : ',c_arr(1),...
                '->',c_arr(2),....
                ' with confidence level: ',num2str(confidence,2)]);
        end  
    end 
    if flag ==0   
     disp('Association rule NOT established for 2-itemsets');
    end
catch
    fprintf('error\n');
end
try 
    flag =0;
    for i = 1:length(table3.item)
        c_arr = char(table3.item(i));
        p_abc = table3.count(i);
        p_ab = length(strfind(sequence,strcat(c_arr(1),c_arr(2))));
        confidence = p_abc/p_ab;
        if confidence > c
            disp('');
            disp(['*** Association rule 3-itemset: ',c_arr(1),c_arr(2),...
                '->',c_arr(3),....
                ' with confidence level: ',num2str(confidence,2)]);
            flag =1;
            disp(['Thus child goes from :', ...
                roi_name(int16(c_arr(1))-64),'&',...
                roi_name(int16(c_arr(2))-64),'->',...
                roi_name(int16(c_arr(3))-64)]);
            disp('');
        else
            disp('--------------------------------------');
            disp(['Association rejected : ',c_arr(1),c_arr(2),...
                '->',c_arr(3),....
                ' with confidence level: ',num2str(confidence,2)]);
        end  
    end 
    if flag ==0
     disp('Association rule not established for 3-itemsets');
    end
    
catch
    fprintf('error\n');
end



NULL=0;