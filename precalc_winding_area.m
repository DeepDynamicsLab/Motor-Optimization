function a = precalc_winding_area(g)
%%% Pre-calculate  winding area for resistance calculations ahead of running
%%% a simulation

%%% Polygon Area %%%
p1 = g.s.p3;
p2 = g.s.p4;
p3 = g.s.p5;
p4 = g.s.p6;
p5 = g.s.p9;

a1 = 1e-6*2*g.s.ff*abs(.5*((p1(1)*p2(2) - p1(2)*p2(1)) + (p2(1)*p3(2) - p2(2)*p3(1)) + (p3(1)*p4(2) - p3(2)*p4(1)) + (p4(1)*p5(2) - p4(2)*p5(1)) + (p5(1)*p1(2) - p5(2)*p1(1))))
%%% Arc segment area %%%
%ignoring for now, it's kind of small
%a = 


end