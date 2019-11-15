function [mass, m_stator, m_rotor, j_rotor, r_phase] = calc_phys_props(g)
%%% Calculate masses, inertias, resistance, eventually inductances %%%

material_densities;

%%% stator laminations %%%
mo_clearblock;
mo_groupselectblock(1);     
v_s_steel  = mo_blockintegral(10)*g.s.slots/g.n_s;
m_s_steel = v_s_steel*densities(g.s.material);

%%% windings %%%
p = 1.68e-8;  % Copper resistivity in Ohm-meters
mo_clearblock;
mo_groupselectblock(11);     
a_s_windings = g.s.ff*mo_blockintegral(5)/g.n_s;     % Slot area * fill factor
l_s_windings = 1e-3*(g.depth + g.s.span*g.s.theta*norm(mean(g.s.p6' + g.s.p9'))); % single slot plus single end-turn length
v_s_windings  = l_s_windings*a_s_windings*g.s.slots;
m_s_windings = v_s_windings*densities('Copper');
r_phase = p*l_s_windings*g.s.slots/(a_s_windings*3);                         % divide by 3 for single phase length
% Still need to add in end-turn resistance

%%% rotor steel %%%
mo_clearblock;
mo_groupselectblock(2); 
v_r_steel = mo_blockintegral(10)*2*g.r.ppairs/g.n_p;
m_r_steel = v_r_steel*densities(g.r.backiron_material);
j_r_steel = mo_blockintegral(24)*densities(g.r.backiron_material)*2*g.r.ppairs/g.n_p;

%%% rotor magnets %%%
mo_clearblock;
mo_groupselectblock(12); 
v_r_magnet = mo_blockintegral(10)*2*g.r.ppairs/g.n_p;
m_r_magnet = v_r_magnet*densities(g.r.magnet_type);
j_r_magnet = mo_blockintegral(24)*densities(g.r.magnet_type)*2*g.r.ppairs/g.n_p;




mo_clearblock;

m_stator = m_s_steel + m_s_windings;
m_rotor = m_r_steel + m_r_magnet;
mass = m_stator + m_rotor;
j_rotor = j_r_steel + j_r_magnet;

end
