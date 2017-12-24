function [docking_error_array, mean_docking_error, outstandingGene, outstandingGene_error, trajectory_error_array] = evalError(controlModel, population, para_cell, outstandingGene, outstandingGene_error, X, Y, Phi, traErrSwitch)
    
    X_exp = repmat(X, length(Y), 1);
    X_exp = X_exp(:);
    Y_exp = repmat(Y', 1, length(X));
    Y_exp = Y_exp(:);
    
    docking_error_array = NaN(population, 1);
    trajectory_error_array = NaN(population, 1);
    
    for i = 1 : population;
        docking_error = 0;
        trajectory_error = 0;
        
        [controlModel.input(1).mf.params] = para_cell{i, 1}{:};
        [controlModel.input(2).mf.params] = para_cell{i, 2}{:};
        [controlModel.output.mf.params] = para_cell{i, 3}{:};
        
        for j = 1 : length(Phi);
            phi = Phi(1, j);
            for k = 1 : length(X)*length(Y);
                x = X_exp(k, 1);
                y = Y_exp(k, 1);
                [~, x_p, y_p, phi_p, steps] = truck_reversing_fuzzy_controller(controlModel, x, y, phi, 1, 0);
                docking_error = docking_error + sqrt(((0.5*pi - phi_p) / pi)^2 + ((50 - x_p) / 50)^2 + ((100 - y_p) / 100)^2);
                if traErrSwitch == 1
                    trajectory_error = trajectory_error + (steps / sqrt((50 - x)^2 + (100 - y)^2));
                    %fprintf('(%d/%d)\n', (j + length(X)*length(Y)*(k - 1)), length(X)*length(Y)*length(Phi));
                end
            end
        end
        docking_error = docking_error / (length(X)*length(Y)*length(Phi));
        docking_error_array(i, 1) = docking_error;
        if traErrSwitch == 1
            trajectory_error = trajectory_error / (length(X)*length(Y)*length(Phi));
            trajectory_error_array(i, 1) = trajectory_error;
        end
    end
    
    mean_docking_error = mean(docking_error_array);
    [min_docking_error, index] = min(docking_error_array);
    if min_docking_error < outstandingGene_error
        outstandingGene = para_cell(index, :);
        outstandingGene_error = min_docking_error;
    end
    
end