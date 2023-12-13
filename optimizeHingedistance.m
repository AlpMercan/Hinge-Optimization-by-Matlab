% Optimization script for hinge design on a range hood with two hinges
% with visualization of the torque versus L

% Given values
m = 2.5; % Mass of hood cover [kg]
g = 9.81; % Gravitational acceleration [m/s^2]
L_min = 0.3; 
L_max = 0.375; 

figure;
hold on;
grid on;
xlabel('Position L (m)');
ylabel('Torque per Hinge (Nm)');
title('Torque vs. Hinge Position L');
xlim([L_min, L_max]);

% Optimization process
options = optimset('Display', 'iter', 'TolX', 1e-6);
[L_optimal, torque_min] = fminbnd(@(L) optimizationPlot(L, m, g), L_min, L_max, options);

plot(L_optimal, torque_min, 'gp', 'MarkerSize', 10, 'MarkerFaceColor', 'g');
legend('Torque values', 'Optimal point');

fprintf('Optimal position L for the hinges is: %.4f m\n', L_optimal);
fprintf('This results in a minimum required torque per hinge of: %.4f Nm\n', torque_min);
function torque = optimizationPlot(L, m, g)
    persistent L_values torque_values 
    if isempty(L_values)
        L_values = [];
        torque_values = [];
    end
    
    torque = m * g * L / 2; 
    L_values = [L_values, L]; 
    torque_values = [torque_values, torque]; 
    
    plot(L_values, torque_values, 'b.-'); 
    drawnow;
end
