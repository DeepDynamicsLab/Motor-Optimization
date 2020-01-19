function r = precalc_winding_resistance(g)
%%% Pre-calculate  winding area for resistance calculations ahead of running
%%% a simulation

%%% Polygon Area %%%
p1 = g.s.p3;
p2 = g.s.p4;
p3 = g.s.p5;
p4 = g.s.p6;
p5 = g.s.p9;

a_s_windings = 1e-6*2*g.s.ff*abs(.5*((p1(1)*p2(2) - p1(2)*p2(1)) + (p2(1)*p3(2) - p2(2)*p3(1)) + (p3(1)*p4(2) - p3(2)*p4(1)) + (p4(1)*p5(2) - p4(2)*p5(1)) + (p5(1)*p1(2) - p5(2)*p1(1))));
%%% Arc segment area %%%
%ignoring for now, it's kind of small
%a = 

material_densities;
p = 1.68e-8;  % Copper resistivity in Ohm-meters


l_s_windings = 1e-3*(g.depth + g.s.span*g.s.theta*norm(mean(g.s.p6' + g.s.p9'))); % single slot plus single end-turn length
v_s_windings  = l_s_windings*a_s_windings*g.s.slots;
m_s_windings = v_s_windings*densities('Copper');
r = p*l_s_windings*g.s.slots/(a_s_windings*3);  % divide by 3 for single phase length

end