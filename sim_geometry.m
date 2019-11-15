function [torque, mass, j_rotor, r_phase] = sim_geometry(g, theta, id, iq, jd, jq)
    init_geometry_2(g, theta, id, iq, jd, jq);
    torque = calc_torque(g);
    [mass, m_stator, m_rotor, j_rotor, r_phase] = calc_phys_props(g);
end