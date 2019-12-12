function cost = objective_fn(x)
    g = init_motor_params(x);
    [torque, mass, j_rotor, r_phase, p_ir] = sim_geometry(g, x(17), 0, 0, 0, x(18));
    cost = calc_cost([torque, mass, j_rotor, r_phase, p_ir]);

end