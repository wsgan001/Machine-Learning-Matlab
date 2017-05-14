function [itemset,combination] = prune(matrix)
% input is len size itemset which meets support.
% output is len+1 size itemset in accordance with apriori principle.
     len = size(matrix,2);
%----------------------------------------------------------------
% form high-frequency combination list for len
               temp = num2cell(matrix,1);
     low_combo_name = strcat(temp{:}); % len size itemset combo names
%-----------------------------------------------------------------
% forming possible greater size combinations
  sequence = transpose(unique(matrix(:),'sorted'));

   combination = nchoosek(sequence, len+1); % possiblilities
          temp = num2cell(combination,1); 
   combo_names = strcat(temp{:});  % merge row wise and form itemset
 %--------------------------------------------------------------
 % Now we check if the forming components, are part of previous 
 % high-frequency group.
 % --------------------------------------------------------------
 itemset = struct('item_name',num2cell(combo_names),'count',{1});
 
 for i = 1: length(combo_names) % check all combinations
     % check item frequency for individual items in each itemset
     % form all possible short combo from each itemset
     s_combination = nchoosek(combination(i,:),len); % shorter combos
     s_temp= num2cell(s_combination,1);
     s_combo_names = strcat(s_temp{:}); % shorter combo names
     flag = 0; % indicates presence of short combo in high frequency set
     for j = 1:length(s_combo_names)
         if ~any(ismember(s_combo_names(j),low_combo_name))
             flag = 1; % short combo is not in high frequency set
             break;
         end
     end
     if flag ==0
         itemset(i).count = 0; % to indicate not pruned
     end
 end
 
 [row, col] = find([itemset.count] == 1); % detect to be pruned items 
 itemset(col)= []; % prune items
 combination(col,:) =[];
 
 return
