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

n = 1:1;

H = struct;


threads = 8;
poolobj = gcp;
n_theta = 8;
thetas = linspace(.01, pi, n_theta);

for i = n
    tic
    parfor j = 1:n_theta
        init_geometry_2(g, thetas(j), 0, 0, 0, J);
        temp = strcat('v', num2str(j));
        femm_name = strcat('test', num2str(j), '.fem');
        torque = calc_torque(g, femm_name);
    end
    time = toc;
    fprintf('Iteration %d took %f seconds, %f seconds per simulation\n', i, time, time/threads);

end

