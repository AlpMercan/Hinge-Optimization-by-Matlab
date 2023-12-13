function optimizeHingeDesign()
    figure;
    hold on;
    grid on;
    xlabel('Iteration number');
    ylabel('Torque (Nm)');
    title('Optimization Progress');
    global iter_num;
    iter_num = 25;

    objectiveFunction = @(x) calculateTorque(x);

    initial_hinge_position1 = 112.5*10^-3; % Initial hinge position 1 (m)
    initial_hinge_position2 = 337.5*10^-3; % Initial hinge position 2 (m)
    initial_dimension1 = 10*10^-3; % Initial dimension 1 (m)
    initial_dimension2 = 10*10^-3; % Initial dimension 2 (m)

    min_hinge_position1 = 10*10^-3; % Minimum hinge position 1 (m)
    min_hinge_position2 = 225*10^-3; % Minimum hinge position 2 (m)
    min_dimension1 = 10*10^-3; % Minimum dimension 1 (m)
    min_dimension2 = 10*10^-3; % Minimum dimension 2 (m)

    max_hinge_position1 = 225*10^-3; % Maximum hinge position 1 (m)
    max_hinge_position2 = 450*10^-3; % Maximum hinge position 2 (m)
    max_dimension1 = 60*10^-3; % Maximum dimension 1 (m)
    max_dimension2 = 60*10^-3; % Maximum dimension 2 (m)

    options = optimoptions('fmincon', 'Display', 'iter', 'OutputFcn', @outfun);
    [x_opt, fval] = fmincon(objectiveFunction, [initial_hinge_position1, initial_hinge_position2, initial_dimension1, initial_dimension2], [], [], [], [], [min_hinge_position1, min_hinge_position2, min_dimension1, min_dimension2], [max_hinge_position1, max_hinge_position2, max_dimension1, max_dimension2], [], options);

    
    optimal_hinge_position1 = x_opt(1);
    optimal_hinge_position2 = x_opt(2);
    optimal_dimension1 = x_opt(3);
    optimal_dimension2 = x_opt(4);

    
    figure;
    annotation('textbox', [0.1, 0.5, 0.8, 0.4], 'String', sprintf('Optimization Results:\nOptimal Hinge Position 1: %.6f m\nOptimal Hinge Position 2: %.6f m\nOptimal Dimension 1: %.6f m\nOptimal Dimension 2: %.6f m\nOptimal Torque: %.6f Nm', optimal_hinge_position1, optimal_hinge_position2, optimal_dimension1, optimal_dimension2, fval), 'FontSize', 10, 'EdgeColor', 'none');

    
    function stop = outfun(x, optimValues, state)
    persistent iter_values torque_values;
    stop = false;
    
    if isempty(iter_values)
        iter_values = [];
        torque_values = [];
    end

    switch state
        case 'iter'
            % Append the new iteration number and torque value
            iter_values = [iter_values, optimValues.iteration];
            torque_values = [torque_values, optimValues.fval];

            % Plot the updated values
            plot(iter_values, torque_values, 'b.-');
            xlabel('Iteration number');
            ylabel('Torque (Nm)');
            title('Optimization Progress');
            grid on;
            drawnow;
    end
end
end


function torque = calculateTorque(x)
   
    hinge_position1 = x(1);
    hinge_position2 = x(2);
    dimension1 = x(3);
    dimension2 = x(4);

    
    m = 2.5; % Mass of hood cover [kg]
    g = 9.81; % Gravitational acceleration [m/s^2]
    L = abs(hinge_position1 + hinge_position2); % Distance from hinge to center of hood cover, there should be a better approximation in future

    
    T = m * g * L; % Torque Equation

    G = 24 * 10^9; % Modulus of rigidity
    pi = 3.14;
    d = 40*10^-3; % Diameter of cylinder m
    J = (pi * d^4) / 32; % Polar Second Moment of Area

    Fi = (T * L) / (G * J); % Angle of twist

    torque = T; % Return the torque as the objective
end


