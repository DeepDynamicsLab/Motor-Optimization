%%% Random sampling based optimization %%%
clear all


% p(1) = axial length
% p(2) = stator slots
% p(3) = stator tooth surface radius
% p(4) = stator tooth length
% p(5) = stator backiron thickness
% p(6) = tooth fill percent
% p(7) = tooth tip fill percent

% p(9) = tooth tip flare angle
% p(10) = winding fill factor
% p(11) = pole-pairs
% p(12) = airgap thickness
% p(13) = magnet thickness
% p(14) = rotor backiron thickness
% p(15) = magnet pole fill percent
% p(16) = rotor type, N/S vs Hallbach
% p(17) = -1 for outrunner, 1 for inrunner
%  Initialize all parameters
x0 =    [8;          % 1: axial length
            36;         % 2: stator slots
            40.5;       % 3: tooth surface radius
            31.5;       % 4: radius at tooth root
            29.3;       % 5: backiron radius
            .28;        % 6: tooth fill percent
            .707;       % 7: tooth tip fill percent
            .5;         % 8: Tooth tip length
            pi/24;      % 9: Tooth tip flare angle
            .2;      % 10: Slot fill-factor
            21;         % 11: pole-pairs
            40.7;       % 12: rotor surface radius
            42.02;      % 13: back-iron radius, magnet side
            43.42;      % 14: backiron radius
            .70;        % 15: magnet fill percent         
            2;          % 16: 1 = North-south poles, 2 = hallbach
            -1;         % 17: 1 for inrunner, -1 for outrunner
            50;         % 18: Current density
            ];

%steel = 'Hiperco-50';
mag = 'N42';

sv = {'M-19 Steel', 'Hiperco-50', 'Hiperco-50'};
mv = [1, 1, 2];
% Optimization variables and ranges
% [lower bound, upper bound]


%f1 = figure(); hold all;
f2 = figure(); hold all;
f3 = figure(); hold all;
%x = x0; 

for j = 1:3
steel = char(sv(j)); % Set steel type
x0(16) = mv(j);         % Set magnet array type

n = 100;         % Try to simulate n motors
n_theta = 8;
thetas = linspace(.01, pi, n_theta);
theta = pi/4;
results = [];
p_des = 315;


parfor i = 1:n
    %%% Randomly generate some motor dimensions between the bounds %%%
    x_opt = [38.5, 42.5;        % 1:  Airgap radius
        .2, .2;             % 2:  Airgap thickness
        .5, 3;          % 3:  Stator backiron thickness
        29.3, 29.3;           % 4: Stator backiron radius
        0.5, 5.0;          % 5: Magnet thickness
        43.42, 43.42;           % 6: Rotor backiron radius
        0.15, .7;          % 7: Tooth fill percent
        .3, .95;            % 8: Magnet fill percent
        ];
    x_rand = [];
    for j = 1:length(x_opt(:,1))
        x_rand(j) = x_opt(j, 1) + rand(1)*(x_opt(j, 2) - x_opt(j, 1));
    end
    
    %%% Update motor dimensions from optimization variables %%%
    x = x0;
    s = x0(17);
    x(3) = x_rand(1);
    x(5) = x_rand(4);
    %x(4) + s*x_rand(4);
    %x(4) = max(x(5)-s*.25, min(x_rand(1) + s*x_rand(3), x(3)-x(8)));
    x(4) = min(x_rand(4) - s*x_rand(3), x(3)-2);
    x(12) = x(3) - s*x_rand(2);
    x(14) = x_rand(6);%x(13) - s*x_rand(6);
    x(6) = x_rand(7);
    x(13) = min((x(12) - s*x_rand(5)), x(14)-.25);
    %x(13) = min(x(14)+s*.25, (x(12) - s*x_rand(5)));
    x(15) = x_rand(8);
    
    g = init_motor_params(x, steel, mag);
    r = precalc_winding_resistance(g);
    q_current = .5*sqrt(p_des/(1.5*r));
    %%% Run simulation %%%
    %for j = 1:n_theta
    femm_name = strcat('FEMM Temp\test', num2str(i), '.fem');
    try
        [torque, mass, j_rotor, r_phase, p_ir] = sim_geometry(g, theta, 0, q_current, 0, 0, femm_name);
        results = [results; [i, torque, mass, j_rotor, r_phase, p_ir, x']];
        delete(strcat('FEMM Temp\test', num2str(i), '*'));
        %delete(strcat('FEMM Temp\test', num2str(i), '.ans'));
    end
    
    %figure(fig1);
end


%[s_results, si] = sort(results(:,2), 'descend');


% figure;
% hold all;
% figure(f1);
% [xp, yp] = extract_pareto(results(:,6).^.5, results(:,2), 50);
% scatter(xp, yp, 'filled');
% %scatter(results(:,6).^.5, results(:,2), 'filled');
% % scatter(results(si(1),6).^.5, results(si(1), 2), 'filled');
% % scatter(results(si(2),6).^.5, results(si(2), 2), 'filled');
% % scatter(results(si(3),6).^.5, results(si(3), 2), 'filled');
% % scatter(results(si(4),6).^.5, results(si(4), 2), 'filled');
% xlabel('Root Power Loss');
% ylabel('Torque (N-m)');
% NicePlot

% figure;
% hold all;
figure(f2);
[xp, yp] = extract_pareto(results(:,4), results(:,2), 50);
scatter(xp, yp, 'filled');
%scatter(results(:,4), results(:,2), 'filled');
% scatter(results(si(1),4), results(si(1), 2), 'filled');
% scatter(results(si(2),4), results(si(2), 2), 'filled');
% scatter(results(si(3),4), results(si(3), 2), 'filled');
% scatter(results(si(4),4), results(si(4), 2), 'filled');
xlabel('Rotor Inertia (Kg*m^2)');
ylabel('Torque (N-m)');
NicePlot

% figure;
% hold all;
figure(f3);
[xp, yp] = extract_pareto(results(:,3), results(:,2), 50);
scatter(xp, yp, 'filled');
%scatter(results(:,3), results(:,2), 'filled');
% scatter(results(si(1),3), results(si(1), 2), 'filled');
% scatter(results(si(2),3), results(si(2), 2), 'filled');
% scatter(results(si(3),3), results(si(3), 2), 'filled');
% scatter(results(si(4),3), results(si(4), 2), 'filled');
xlabel('Mass (kg)');
ylabel('Torque (N-m)');
NicePlot


% 
% U8;
% [torque, mass, j_rotor, r_phase, p_ir] = sim_geometry(g, theta, 0, 0, 0, 100);
% scatter(f1, sqrt(p_ir), torque, 'filled', 'red');
% scatter(f2, j_rotor, torque, 'filled', 'red');
% scatter(f3, mass, torque, 'filled', 'red');


mc_output = struct();
mc_output.output = results;
mc_output.steel = steel;
mc_output.mag = mag;

%%% Save everything %%%
filename = strcat('Results\t_vs_rtpwr_11', num2str(j));
savefig(strcat(filename, '.fig'));
save(strcat(filename, '.mat'), 'mc_output');
csvwrite(strcat(filename, '.csv'), results);
end

%figure(f1); legend('M-19 N/S Magnets', 'Hiperco-50 N/S Magnets', 'Hiperco-50 Hallbach');
figure(f2); legend('M-19 N/S Magnets', 'Hiperco-50 N/S Magnets', 'Hiperco-50 Hallbach');
figure(f3); legend('M-19 N/S Magnets', 'Hiperco-50 N/S Magnets', 'Hiperco-50 Hallbach');
% 
U8;
r = precalc_winding_resistance(g);
q_current = .5*sqrt(p_des/(1.5*r));
[torque, mass, j_rotor, r_phase, p_ir] = sim_geometry(g, theta, 0, q_current, 0, 0);
%figure(f1); scatter(sqrt(p_ir), torque, 'filled', 'green');
figure(f2); scatter(j_rotor, torque, 'filled', 'green');
figure(f3); scatter(mass, torque, 'filled', 'green');

delete('FEMM Temp\*');
