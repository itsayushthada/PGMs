function Joint_Dist = PrintFactor(phi, print=0)
% Following function prints the Factor Table along with the Probabilities. 

    Joint_Dist = []
    
    % Temporary Variable Initialization.
    count = ones(1, length(phi.var));
    update = zeros(1, length(phi.var));
    
    idx_1 = first_Multivariate_RV(phi.card, 1);
    idx_2 = first_Multivariate_RV(phi.card, idx_1 + 1);
    
    count(idx_1) = 0;
    update(idx_1) = 1;
    
    % Dynamic String Head and Body Generator
    str_head = '';
    str_body = '';
    line = '';
    for i=1:length(phi.var)
        line = strcat(line,         '|-----|');
        str_head = strcat(str_head, '| X_%d |');
        str_body = strcat(str_body, '|  %d  |');
    end
    line = strcat(line,         '|-------------|');
    str_head = strcat(str_head, '| Probability |');
    str_body = strcat(str_body, '|  %.7f  |');
     
    line = strrep(line, '||', '|');
    str_head = strrep(str_head, '||', '|');
    str_body = strrep(str_body, '||', '|');
    
    % Display Header of the Factor table
    if print == 1
      disp(sprintf(line));
      disp(sprintf(str_head, phi.var));
      disp(sprintf(line));
    end
    
    % Table Generator
    for i = 1:prod(phi.card)
        % To Update the First Multivariate RV which has to updated every single iteration.
        count(idx_1) = mod(count(idx_1), phi.card(idx_1)) + 1;
        
        if  length(phi.card) > 1
            % Updates for next Variables when the preceeding variable's Cycle is completed.
            for j = idx_2:length(phi.var)
                if length(phi.card)-idx_1 +1 > 1
                    idx = last_Multivariate_RV(phi.card, j-1);
                    if count(idx) == phi.card(idx)
                        update(j) = 1;
                    end
                    
                    if update(j) == 1 && count(idx) == 1
                        count(j) = mod(count(j), phi.card(j)) + 1;
                        update(j) = 0;
                    end
                end
            end
        end
        Joint_Dist = [Joint_Dist; [count phi.val(i)]];
        if print == 1
            disp(sprintf(str_body, count, phi.val(i)));
        end
    end
    if print == 1
        disp(sprintf(line));
    end
end

function N = last_Multivariate_RV(card, idx)
% Returns the the index of last greater than one value from given index including that index.
    if card(idx) > 1 || idx == 1
        N = idx;
    else
        N = last_Multivariate_RV(card, idx-1);
    end
end

function N = first_Multivariate_RV(card, idx)
% Returns the the index of first greater than one value from given index including that index.
    if card(idx) > 1 || idx == length(card)
        N = idx;
    else
        N = first_Multivariate_RV(card, idx+1);
    end
end