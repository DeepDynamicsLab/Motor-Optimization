function g = init_motor_params_simple(p)
% Initialize motor geometry struct with parameter list p
% Relative distances rather than absolute for easier optimization setup
% p(1) = axial length
% p(2) = stator slots
% p(3) = stator tooth surface radius
% p(4) = stator tooth length
% p(5) = stator backiron thickness
% p(6) = tooth fill percent
% p(7) = tooth tip fill percent
% p(8) = tooth tip length
% p(9) = tooth tip flare angle
% p(10) = winding fill factor
% p(11) = pole-pairs
% p(12) = airgap thickness
% p(13) = magnet thickness
% p(14) = rotor backiron thickness
% p(15) = magnet pole fill percent
% p(16) = rotor type, N/S vs Hallbach
% p(17) = -1 for outrunner, 1 for inrunner

s = p(17);

p_new = p;
p_new(4) = p(3) + s*p(4);
p_new(5) = p_new(4) + s*p(5);
p_new(12) = p(3) - s*p(12);
p_new(13) = p_new(12) - s*p(13);
p_new(14) = p_new(13) - s*p(14);
g = init_motor_params(p_new);

end