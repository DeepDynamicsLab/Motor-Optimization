% fixed parameters (not included in optimization)
const =    [8;          % 1: axial length
            36;         % 2: stator slots
            40.5;       % 3: tooth surface radius
            31.5;       % 4: radius at tooth root
            29.3;       % 5: backiron radius
            .28;        % 6: tooth fill percent
            .707;       % 7: tooth tip fill percent
            .5;         % 8: Tooth tip length
            pi/24;      % 9: Tooth tip flare angle
            .2;      % 10: Slot fill-factor
            21;         % 11: pole-pairs
            40.7;       % 12: rotor surface radius
            42.02;      % 13: back-iron radius, magnet side
            43.42;      % 14: backiron radius
            .62;        % 15: magnet fill percent         
            1;          % 16: 1 = North-south poles, 2 = hallbach
            pi/4;       % 17: rotor angle
            100;        % 18: Q-axis current density
            ];

% first attempt at optimizing parameters with fmincon

% initial guess for decision variables
x0 = [.62;           % magnet fill percent
        42.02;      % rotor backiron radius, magnet side
        .38;        % tooth  fill percent
        40.5;       % stator surface radius
        40.7;       % rotor surface radius
        31.0;       % tooth root radius
        100;        % Q-axis current density
      ]; 
  
% linear inequality constraints, Ax <= b;
A = [   0, 0, 0, 1, -1, 0, 0;    % maintain airgap > .4mm
        0, 0, 0, -1, 0, 1, 0;     % tooth length > 1 mm
        0, -1, 0, 0, 1, 0, 0];   % magnet thicknes > .4mm
b = [   -.4;
        -1;     
        -.4;];

% linear equality constraints, Ax = b;
Aeq = [];%[0, 0, 0, 0, -1, 1];      %  - stator I.D + rotor O.D = t_airgap
beq = [];%[.2];
 
% bounds
ub = [.85;
        const(14)-.1;
        .6;
        const(14) - 1;
        const(14) - .8;
        const(14) - 1.2;
        150;
      ];
lb = [.1;
        const(12)+.1;
        .2;
        const(5) + .8;
        const(5) + 1;
        const(5) + .6;
        1;
        ];


% need to find a less janky way to do this
objfn = @(x) objective_fn([const(1); 
                            const(2); 
                            x(4);
                            x(6);
                            const(5);
                            x(3);
                            const(7);
                            const(8);
                            const(9);
                            const(10);
                            const(11);
                            x(5);
                            x(2);
                            const(14);
                            x(1);           
                            const(16);
                            const(17);
                            x(7);]);
                        
% Optimize for x                
options = optimoptions('fmincon', 'Display', 'iter', 'FiniteDifferenceStepSize',1e-2, 'OptimalityTolerance', 1e-3, 'DiffMaxChange', .05);
tic
[x, fval] = fmincon(objfn, x0, A, b, Aeq, beq, lb, ub, [], options)
toc

