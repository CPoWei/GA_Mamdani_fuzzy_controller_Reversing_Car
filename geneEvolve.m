function para_cell = geneEvolve(population, mfParaNum, para_cell, docking_error_array, mO, outstandingGene)
   
    selectThreshold = 0.2*population;
    [~, index0] = max(docking_error_array);
    para_cell(index0, :) = outstandingGene;    
    returned_para_cell = cell(population, 3);
    
    for i = 1 : (population / 2);     

        %Part 1 : Select    
        boolSelect = (randperm(population) <= selectThreshold)';
        selectedError = docking_error_array(boolSelect, 1);
        [index1, ~] = find(docking_error_array == min(selectedError));
        index1 = index1(1, 1);
        boolSelect = (randperm(population) <= selectThreshold)';
        selectedError = docking_error_array(boolSelect, 1);
        [index2, ~] = find(docking_error_array == min(selectedError));
        index2 = index2(1, 1);

        locOutstandingGene = cell2mat(cat(1, para_cell{index1, 1}, para_cell{index1, 2}, para_cell{index1, 3}));
        locSecondPalceGene = cell2mat(cat(1, para_cell{index2, 1}, para_cell{index2, 2}, para_cell{index2, 3}));
        
        %Part 2 : Mate 
        if (rand(1) <= 0.9) == 1    % '90%' mate
            
            maskThreshold = randi(19);
            mateMask = double(rand(19, mfParaNum) >= 0.5);
            invMateMask = abs(mateMask - 1);
            onesMask = ones((19 - maskThreshold), mfParaNum);
            zerosMask = zeros((19 - maskThreshold), mfParaNum);
            
            newGene1 = locOutstandingGene.*cat(1, mateMask(1 : maskThreshold, :), onesMask) ...
                     + locSecondPalceGene.*cat(1, invMateMask(1 : maskThreshold, :), zerosMask);
            newGene2 = locOutstandingGene.*cat(1, mateMask(1 : maskThreshold, :), zerosMask) ...
                     + locSecondPalceGene.*cat(1, invMateMask(1 : maskThreshold, :), onesMask);
            %{
            maskThreshold = randi(19);
            mateMask = cat(1, ones(maskThreshold, 2), zeros((19 - maskThreshold), 2));
            invMateMask = abs(mateMask - 1);
            newGene1 = locOutstandingGene.*mateMask + locSecondPalceGene.*invMateMask;
            newGene2 = locOutstandingGene.*invMateMask + locSecondPalceGene.*mateMask;
            %}
        else
            newGene1 = locOutstandingGene;
            newGene2 = locSecondPalceGene;
        end

        %Part 3 : Mutation 
        if (rand(1) <= 0.8) == 1    % '80%' mutate
            mutateMask = double(rand(19, mfParaNum) >= 0.5);
            invMutateMask = abs(mutateMask - 1);
            mutateMask(mutateMask == 0) = -1;
            invMutateMask(invMutateMask == 0) = -1;
            newGene1 = newGene1 + mO.*mutateMask.*newGene1;
            newGene2 = newGene2 + mO.*invMutateMask.*newGene2; 

            for select = 1 : 2;    %fit to the boundary
                if select == 1
                    newGene = newGene1;
                else
                    newGene = newGene2;
                end

                newGene_x = newGene(1 : 5, :);
                newGene_x(newGene_x > 100) = 100;
                newGene_x(newGene_x <= 0) = 0.001;

                newGene_phi = newGene(6 : 12, :);
                newGene_phi(newGene_phi > 270) = 270;
                newGene_phi(newGene_phi < -90) = -90;
                newGene_phi(newGene_phi == 0) = 0.001;
                
                newGene_theta = newGene(13 : 19, :);
                newGene_theta(newGene_theta > 30) = 30;
                newGene_theta(newGene_theta < -30) = -30;
                newGene_theta(newGene_theta == 0) = 0.001;
                
                if select == 1
                    newGene1_x = newGene_x;
                    newGene1_phi = newGene_phi;
                    newGene1_theta = newGene_theta;
                else
                    newGene2_x = newGene_x;
                    newGene2_phi = newGene_phi;
                    newGene2_theta = newGene_theta;
                end
            end
        else
            newGene1_x = newGene1(1 : 5, :);
            newGene1_phi = newGene1(6 : 12, :);
            newGene1_theta = newGene1(13 : 19, :);
            
            newGene2_x = newGene2(1 : 5, :);
            newGene2_phi = newGene2(6 : 12, :);
            newGene2_theta = newGene2(13 : 19, :);
        end
        newGene1_x = mat2cell(newGene1_x, ones(1, 5));
        newGene1_phi = mat2cell(newGene1_phi, ones(1, 7));
        newGene1_theta = mat2cell(newGene1_theta, ones(1, 7));
        
        newGene2_x = mat2cell(newGene2_x, ones(1, 5));
        newGene2_phi = mat2cell(newGene2_phi, ones(1, 7));
        newGene2_theta = mat2cell(newGene2_theta, ones(1, 7));
        
        k = (2*i) - 1;
        returned_para_cell(k, :) = {newGene1_x, newGene1_phi, newGene1_theta};
        returned_para_cell((k + 1), :) = {newGene2_x, newGene2_phi, newGene2_theta};
    end
    
    para_cell = returned_para_cell;
    
end







