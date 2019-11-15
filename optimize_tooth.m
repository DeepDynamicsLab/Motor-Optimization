% Sweep values of stator tooth fill, find max torque design for fixed
% current density
% This probably isn't actually a good metric to optimize, but it's an easy
% place to start out

clear all;

% Load initial motor geometry %
U8;

%g.s.material = 'Hiperco-50';

% Peak current density %
J = 20;

% Range of tooth fill percent values to sweep %
t_pct = linspace(.1, .6, 10);

torque = [];

for i = 1:length(t_pct)
    tic
    
    % Set tooth percent %
    g.s.t_pct = t_pct(i);
    % Recalculate geometry %
    g = calc_geometry(g);
    % Calculate torque %
    torque = [torque;sim_geometry(g, pi/4, 0, 0, 0, J)];
    
    fprintf('Iteration %d took %f seconds\n', i, toc);
end

[max_torque, ind] = max(torque);
opt_t_pct = t_pct(ind);
figure;
hold all
plot(t_pct, torque);
scatter([opt_t_pct], [max_torque], 50, 'filled');
xlabel('Tooth Fill Fraction');
ylabel('Torque');
NicePlot;