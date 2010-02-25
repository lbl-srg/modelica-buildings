within Buildings.Fluid.Actuators.Examples;
model Damper

    annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                        graphics),
                         Commands(file=
            "Damper.mos" "run"));

 package Medium = Buildings.Media.IdealGases.SimpleAir;

  Buildings.Fluid.Actuators.Dampers.Exponential res(
    A=1,
    redeclare package Medium = Medium,
    m_flow_nominal=1) 
         annotation (Placement(transformation(extent={{0,10},{20,30}}, rotation=
           0)));
    Modelica.Blocks.Sources.Ramp yRam(
    duration=0.3,
    offset=0,
    startTime=0.2,
    height=1)    annotation (Placement(transformation(extent={{-20,40},{0,60}},
          rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sou(             redeclare package Medium
      = Medium,
    use_p_in=true,
    nPorts=1,
    T=293.15)                                       annotation (Placement(
        transformation(extent={{-68,10},{-48,30}}, rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sin(             redeclare package Medium
      = Medium,
    use_p_in=true,
    nPorts=1,
    T=293.15)                                       annotation (Placement(
        transformation(extent={{74,10},{54,30}}, rotation=0)));
    Modelica.Blocks.Sources.Constant PAtm(k=101325) 
      annotation (Placement(transformation(extent={{60,60},{80,80}}, rotation=0)));
  Buildings.Fluid.Actuators.Dampers.Exponential res1(
    A=1,
    redeclare package Medium = Medium,
    m_flow_nominal=1) 
         annotation (Placement(transformation(extent={{0,-90},{20,-70}},
          rotation=0)));
    Modelica.Blocks.Sources.Ramp yRam1(
    duration=0.3,
    height=1,
    offset=0)    annotation (Placement(transformation(extent={{-20,-60},{0,-40}},
                   rotation=0)));
    Modelica.Blocks.Sources.Ramp P1(
    duration=0.5,
    startTime=0.5,
    height=-10,
    offset=101330) 
                 annotation (Placement(transformation(extent={{-100,-82},{-80,
            -62}}, rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sou1(          redeclare package Medium
      = Medium,
    use_p_in=true,
    nPorts=1,
    T=293.15)                                       annotation (Placement(
        transformation(extent={{-68,-90},{-48,-70}}, rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sin1(          redeclare package Medium
      = Medium,
    use_p_in=true,
    nPorts=1,
    T=293.15)                                       annotation (Placement(
        transformation(extent={{74,-90},{54,-70}}, rotation=0)));
    Modelica.Blocks.Sources.Constant PAtm1(
                                          k=101325) 
      annotation (Placement(transformation(extent={{60,-40},{80,-20}}, rotation=
           0)));
    Modelica.Blocks.Sources.Constant PAtm0(k=101335) 
      annotation (Placement(transformation(extent={{-100,18},{-80,38}},
          rotation=0)));
  inner Modelica.Fluid.System system 
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
equation
  connect(yRam.y, res.y) annotation (Line(
      points={{1,50},{10,50},{10,28}},
      color={0,0,127},
      pattern=LinePattern.None));
  connect(PAtm.y, sin.p_in) annotation (Line(points={{81,70},{86,70},{86,28},{
          76,28}}, color={0,0,127}));
  connect(yRam1.y, res1.y) 
                         annotation (Line(
      points={{1,-50},{10,-50},{10,-72}},
      color={0,0,127},
      pattern=LinePattern.None));
  connect(P1.y, sou1.p_in) 
                         annotation (Line(points={{-79,-72},{-74,-72},{-70,-72}},
                      color={0,0,127}));
  connect(PAtm1.y, sin1.p_in) 
                            annotation (Line(points={{81,-30},{86,-30},{86,-72},
          {76,-72}}, color={0,0,127}));
  connect(PAtm0.y, sou.p_in) 
    annotation (Line(points={{-79,28},{-74.5,28},{-70,28}},
                                                 color={0,0,127}));
  connect(sou.ports[1], res.port_a) annotation (Line(
      points={{-48,20},{-5.55112e-16,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin.ports[1], res.port_b) annotation (Line(
      points={{54,20},{20,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou1.ports[1], res1.port_a) annotation (Line(
      points={{-48,-80},{-5.55112e-16,-80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res1.port_b, sin1.ports[1]) annotation (Line(
      points={{20,-80},{54,-80}},
      color={0,127,255},
      smooth=Smooth.None));
end Damper;
