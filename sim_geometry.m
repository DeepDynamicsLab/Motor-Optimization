function [torque, mass, j_rotor, r_phase, p_ir] = sim_geometry(g, theta, id, iq, jd, jq)
    if(nargin < 5)
        jd = 0;
        jq = 0;
    end
    init_geometry_2(g, theta, id, iq, jd, jq);
    torque = calc_torque(g);
    i_norm = norm([id, iq]);
    j_norm = norm([jd, jq]);
    [mass, m_stator, m_rotor, j_rotor, r_phase, p_ir] = calc_phys_props(g, i_norm, j_norm);
end