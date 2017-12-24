clc;
clearvars;
fprintf('Press "Enter" to begin\n\n');
pause;

controlModel= readfis('truck_fuzzyParameter_model.fis');
mfParaNum = 2;
population = 50;
numOfGeneration = 100;
mutativeOscillation = 0.4;
errorRecord = NaN(numOfGeneration, 2);
trainingTimeRecord = zeros(numOfGeneration, 1);
X = (20 : 30 : 80);
Y = 5;
Phi = (-80 : 85 : 260);
MSGID = 'Fuzzy:evalfis:InputOutOfRange';
warning('off', MSGID);

%%
%===Part1 : What is your fuzzy controller? 
fprintf('What is your algorithm for design of fuzzy controller?\n\n');
fprintf('Press "Enter" to begin\n\n');
pause;
fprintf('Ans : \n');
fprintf('      1. It is a mamdani type fuzzy control model\n');
fprintf('      2. 5 Gaussion functions for input X and 7 ones for input Phi\n');
fprintf('      3. 7 Gaussion functions for output Theta\n');
fprintf('      4. 35 rules and the "And" method in rules is "Min"\n');
fprintf('      5. Use 50 populations and 100 generations for GA\n\n');
fprintf('Press "Enter" to begin\n\n');
pause;

%%
%===Part2 : What is the learning curve?
fprintf('What is the learning curve?\n\n');
fprintf('Press "Enter" to begin\n\n');
pause;
fprintf('Model evolving... (It will take about 1 hour to evolve)\n\n');
tic;
[para_cell, docking_error_array, mean_docking_error, outstandingGene, outstandingGene_error] = initialGene(controlModel, population, mfParaNum, X, Y, Phi);
errorRecord(1, 1) = mean_docking_error;
errorRecord(1, 2) = outstandingGene_error;
trainingTimeRecord(1, 1) = toc;

for i = 2 : numOfGeneration; 
    tic;
    mO = mutativeOscillation*exp(-i/100) + 0.01;
    para_cell = geneEvolve(population, mfParaNum, para_cell, docking_error_array, mO, outstandingGene);
    [docking_error_array, mean_docking_error, outstandingGene, outstandingGene_error, trajectory_error_array] = evalError(controlModel, population, para_cell, outstandingGene, outstandingGene_error, X, Y, Phi, 0);
    errorRecord(i, 1) = mean_docking_error;
    errorRecord(i, 2) = outstandingGene_error;
    fprintf('Generation : %d | mean_docking_error : %.4f | outstanding_docking_error : %.4f\n', i, mean_docking_error, outstandingGene_error);
    trainingTimeRecord(i, 1) = toc;
end

fprintf('\nTotal training time : %.2f minutes\n\n', (sum(trainingTimeRecord)/60));

[controlModel.input(1).mf.params] = outstandingGene{1, 1}{:};
[controlModel.input(2).mf.params] = outstandingGene{1, 2}{:};
[controlModel.output.mf.params] = outstandingGene{1, 3}{:};
writefis(controlModel, 'controlModel_trained');
fprintf('Trained model has been saved as "controlModel_trained"\n\n');

plot(errorRecord(:, 1), '-', 'MarkerSize', 2);
hold on;
plot(errorRecord(:, 2), '-', 'MarkerSize', 2);
title('Learning Curve');
xlabel('Iteration');
ylabel('Error');
legend('mean docking error', 'outstanding docking error');
axis([1 100 0 max(errorRecord(:, 1))]);
text(size(errorRecord, 1), errorRecord(end, 2), num2str(errorRecord(end, 2))); 
hold off;

fprintf('Press "Enter" to begin\n\n');
pause;

%%
%===Part3 : What is the average Docking error (over all test trials)?
fprintf('What is the average Docking error (over all test trials)?\n\n');
fprintf('Press "Enter" to begin\n\n');
pause;
fprintf('The answer is computing, please wait\n\n');

X = (20 : 10 : 80);
Y = (20 : 10 : 50);
Phi = (-80 : 5 : 260);

%gensurf(controlModel);
[docking_error, trajectory_error] = singleEvalError(controlModel, X, Y, Phi, 1);
disp('All done!');
fprintf('Ans : Average docking_error is %.4f\n\n', docking_error);
fprintf('Press "Enter" to begin\n\n');
pause;

%%
%===Part4 : What is the average trajectory error over test trials in the previous part?
fprintf('What is the average trajectory error over test trials in the previous part?\n\n');
fprintf('Press "Enter" to begin\n\n');
pause;
fprintf('Ans : Average trajectory error is %.4f\n\n', trajectory_error);
fprintf('Press "Enter" to begin\n\n');
pause;

%%
%===Part5 : Manual typing
fprintf('Finally, we come to manual typing part!\n\n');
fprintf('Press "Enter" to begin\n\n');
pause;

again = 'y';
while(again == 'y')
    x = input('Please enter initial coordinate X (range from 0 to 100)\n');
    y = input('Please enter initial coordinate Y (range from 0 to 100)\n');
    phi = input('Please enter initial angle "phi" (range from -90 to 270 in degrees)\n');
    alpha = input('Please enter step size "alpha" (alpha will be 1 in default if you just type in "Enter")\n');

    [status, x_p, y_p, phi_p, steps] = truck_reversing_fuzzy_controller(controlModel, x, y, phi, alpha, 1);
    fprintf(['x = %.2f\n', 'y = %.2f\n', 'phi = %.2f in degrees\n', 'steps = %d\n'], x_p, y_p, phi_p*180 / pi, steps);
    again = input('Try it again? [y/n]\n', 's');
end

%%












