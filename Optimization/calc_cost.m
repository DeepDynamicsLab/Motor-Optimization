function cost = calc_cost(x)
% Calculates cost function from motor simulation results x)
% x(1) = torque
% x(2) = mass
% x(3) = stator mass
% x(4) = rotor mass
% x(5) = rotor inertia
% x(6) = phase resistance
% x(7) = resistive power loss

%%% Simple example maximizing torque for 330 W power dissipation %%%
cost = -(x(1)^2) + .01*(330-x(5))^2;

end