function g = init_motor_params(p, steel, mag);
% Initialize motor geometry struct with parameter list p
% p(1) = axial length
% p(2) = stator slots
% p(3) = stator tooth surface radius
% p(4) = stator tooth root radius
% p(5) = stator backiron radius
% p(6) = tooth fill percent
% p(7) = tooth tip fill percent
% p(8) = tooth tip length
% p(9) = tooth tip flare angle
% p(10) = winding fill factor
% p(11) = pole-pairs
% p(12) = rotor surface radius
% p(13) = rotor magnet back radius
% p(14) = rotor backiron radius
% p(15) = magnet pole fill percent
% p(16) = rotor type, N/S vs Hallbach
if(nargin<2)
    steel = 'M-19 Steel';
    mag = 'N42';
end

if(length(p)<16)
    error('params vector too short');
end
g.depth =       p(1);      % axial length
g.s.slots =     p(2);     % stator slots
g.s.r1 =        p(3);     % tooth surface radius
g.s.r2 =        p(4);     % radius at tooth root
g.s.r3 =        p(5);     % backiron radius
g.s.t_pct =     p(6);     % tooth fill percent
g.s.tip_pct =   p(7);      % tooth tip fill percent
g.s.tip_l =     p(8);      % Tooth tip length
g.s.tip_angle = p(9);   % Tooth tip flare angle
g.s.ff =        p(10);     % Slot fill-factor

g.r.ppairs =    p(11);      % pole-pairs
g.r.r1 =        p(12);     % rotor surface radius
g.r.r2 =        p(13);     % back-iron radius, magnet side
g.r.r3 =        p(14);     % backiron radius
g.r.m_pct =     p(15);     % Magnet pole fill percent
g.r.type =      p(16);        % 1 = North-south poles, 2 = hallbach

g.n_p = 7;              % number of poles to simulate
g.n_s = 6;              % number of slots to simulate

g.s.material = steel;        % Stator steel type
g.s.t_lam = .2;                     % Stator lamination thickness
g.s.stacking_factor = .928;         % lamination stacking factor
g.r.magnet_type = mag;            % Rotor Magnet Type
g.r.backiron_material = steel;   % Rotor Back Iron Material

g.s.imap = ['A','A','a','B','b','b','B','c','C','C','c','A'];
g.s.span = 1;      % number of slots spanned by each turn (typically 1 for concentrated winding, 3 for distributed

g = calc_geometry(g);

end