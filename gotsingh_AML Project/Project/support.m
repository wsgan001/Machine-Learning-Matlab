function itemset = support(transactions,itemset,combo)
    for i = 1:size(combo,1)
        for j = 1:size(transactions,1)
            % in each transaction only unique presence is counted

            unique_items = unique(strsplit(transactions(j),','));
            if all(ismember(combo(i,:),unique_items))
                itemset(i).count = itemset(i).count + 1;              
            end

        end
    end

