Walco;

theta = linspace(.1, .9*pi/2, 10);
j = 77;

torque = [];
for i = 1:length(theta)
    torque = [torque; sim_geometry(g, theta(i), 0, 0, 0, j)];
end

figure;plot(theta, torque);
xlabel('Electrical Angle');
ylabel('Torque');
NicePlot
