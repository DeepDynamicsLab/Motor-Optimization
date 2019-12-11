% Sweep values of stator tooth fill, find max torque design for fixed
% current density
% This probably isn't actually a good metric to optimize, but it's an easy
% place to start out

clear all;

% Load initial motor geometry %
U8;

%g.s.material = 'Hiperco-50';

% Peak current density %
J = 77;

% Range of tooth fill percent values to sweep %
m_pct = linspace(.5, .85, 10);
torque = [];

for i = 1:length(m_pct)
    tic
    %g.r.r3 = g.r.r2 + t_backiron(i);
    g.r.m_pct = m_pct(i);
    % Recalculate geometry %
    g = calc_geometry(g);
    % Calculate torque %
    [t, m, j] = sim_geometry(g, pi/16, 0, 9*40);
    torque = [torque; t];

    fprintf('Iteration %d took %f seconds\n', i, toc);
end

%[max_torque, ind] = max(torque);
%opt_t_pct = t_pct(ind);
figure;
hold all
plot(m_pct, torque);
ylabel('Torque (N-m)');
xlabel('Hallbach Pole Fill');

NicePlot;
