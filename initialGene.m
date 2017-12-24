function [para_cell, docking_error_array, mean_docking_error, outstandingGene, outstandingGene_error] = initialGene(controlModel, population, mfParaNum, X, Y, Phi)

    para_cell = cell(population, 3);
    docking_error_array = NaN(population, 1);
    
    for i = 1 : population;
        X_rand = 100.*rand(5, mfParaNum);
        X_rand = mat2cell(X_rand, ones(1, 5));
        Phi_rand = -90 + 360.*rand(7, mfParaNum);
        Phi_rand = mat2cell(Phi_rand, ones(1, 7));
        Theta_rand = (-30) + 60.*rand(7, mfParaNum);
        Theta_rand = mat2cell(Theta_rand, ones(1, 7));
        para_cell(i, :) = {X_rand, Phi_rand, Theta_rand}; 
        
        [controlModel.input(1).mf.params] = para_cell{i, 1}{:};
        [controlModel.input(2).mf.params] = para_cell{i, 2}{:};
        [controlModel.output.mf.params] = para_cell{i, 3}{:};
 
        [docking_error, ~] = singleEvalError(controlModel, X, Y, Phi, 0);
        docking_error_array(i, 1) = docking_error;
        %fprintf('%d/%d\n', i, population);
    end
    
    mean_docking_error = mean(docking_error_array);
    [outstandingGene_error, index] = min(docking_error_array);
    outstandingGene = para_cell(index, :);
    
    fprintf('Generation : 1 | mean_docking_error : %.4f | outstanding_docking_error : %.4f\n', mean_docking_error, outstandingGene_error);
end

%[c.input(1).mf.params] = d{:}
%r = a + (b-a).*rand(N,1)
%writefis(r, '/Users/jibowei/Desktop/r.fis')


