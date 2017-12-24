function [status, x, y, phi_radius, steps] = truck_reversing_fuzzy_controller(controlModel, x, y, phi, alpha, image)    
    
    iteration = 150;
    error = 0.05;
    if isempty(alpha) == 1
        alpha = 1; 
    end    
    if image == 1
        patch([0; 0; 100; 100], [0; 100; 100; 0], 'w', 'linewidth', 2);
        axis([0 100 0 100]);
        figure(1);
        hold on;   
        midLength = 1.6;
        buttonLength = 0.1;
    end
    
    for steps = 0 : iteration;

        if steps ~= 0
            theta = evalfis([x, phi], controlModel);

            phi = phi + theta;
            phi_radius = (phi*pi) / 180;
            x_former = x;
            y_former = y;
            x = x + alpha*cos(phi_radius);
            y = y + alpha*sin(phi_radius);
            if x < 0 || x > 100
                x = x_former;
                break;  
            end
            if y < 0 || y > 100
                y = y_former;
                break;
            end
            if image == 1
                peak_coor = [x - midLength*cos(phi_radius), y - midLength*sin(phi_radius)];
                side_angle = (pi / 2) - phi_radius;
                side_coor_1 = [x + buttonLength*cos(side_angle), y - buttonLength*sin(side_angle)];
                side_coor_2 = [x - buttonLength*cos(side_angle), y + buttonLength*sin(side_angle)];
                x_tri = [peak_coor(1, 1); side_coor_1(1, 1); side_coor_2(1, 1)];
                y_tri = [peak_coor(1, 2); side_coor_1(1, 2); side_coor_2(1, 2)];    
                
                %plot(x, y, '--rs', 'LineWidth', 1, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 5);
                gplot(rand(3), [x_tri, y_tri], 'r');
                %patch(x_tri, y_tri, 'r');
            end
        end
    end
    
    if image == 1
        hold off;
    end
    if phi <= pi*(1 + error) / 2 && phi >= pi*(1 - error) / 2 
        status = 1; 
    else
        status = 0;
    end
    
end
