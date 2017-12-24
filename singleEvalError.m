function [docking_error, trajectory_error] = singleEvalError(controlModel, X, Y, Phi, traErrSwitch)

    docking_error = 0;
    trajectory_error = 0;
    X_exp = repmat(X, length(Y), 1);
    X_exp = X_exp(:);
    Y_exp = repmat(Y', 1, length(X));
    Y_exp = Y_exp(:);
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
    if traErrSwitch == 1
        trajectory_error = trajectory_error / (length(X)*length(Y)*length(Phi));
    end
end