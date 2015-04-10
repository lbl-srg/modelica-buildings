within Buildings.Fluid.FixedResistances.Examples;
model FixedResistance "Test model for the fixed resistance model"
  extends Modelica.Icons.Example;

 package Medium = Buildings.Media.Water;
    Modelica.Blocks.Sources.Constant PAtm(k=101325)
      annotation (Placement(transformation(extent={{66,76},{86,96}})));
    Modelica.Blocks.Sources.Ramp P(
      duration=1,
    height=20,
    offset=101315)
                 annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
    Buildings.Fluid.FixedResistances.FixedResistanceDpM res1(
    redeclare package Medium = Medium,
    from_dp=true,
    m_flow_nominal=5,
    dp_nominal=10)  annotation (Placement(transformation(extent={{-28,30},{-8,50}})));
  Buildings.Fluid.Sources.Boundary_pT sou1(          redeclare package Medium
      = Medium,
    use_p_in=true,
    T=293.15,
    nPorts=3)             annotation (Placement(transformation(extent={{-60,-10},
            {-40,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin1(          redeclare package Medium
      = Medium, T=283.15,
    use_p_in=true,
    nPorts=3)             annotation (Placement(transformation(extent={{90,-10},
            {70,10}})));
    Buildings.Fluid.FixedResistances.FixedResistanceDpM res2(
    redeclare package Medium = Medium,
    from_dp=true,
    m_flow_nominal=5,
    dp_nominal=10,
    use_dh=true)
             annotation (Placement(transformation(extent={{-28,-10},{-8,10}})));
    Buildings.Fluid.FixedResistances.FixedResistanceDpM res3(
    redeclare package Medium = Medium,
    from_dp=true,
    m_flow_nominal=5,
    dp_nominal=10,
    use_dh=true)
             annotation (Placement(transformation(extent={{-28,-50},{-8,-30}})));
  FixedResistances.LosslessPipe pipCon(redeclare package Medium = Medium,
      m_flow_nominal=5) "Lossless pipe connection"
                               annotation (Placement(transformation(extent={{34,
            -50},{54,-30}})));
  Buildings.Fluid.Sensors.MassFlowRate masFlo2(redeclare package Medium = Medium)
    "Mass flow rate sensor" annotation (Placement(transformation(extent={{20,-10},
            {40,10}})));
  Buildings.Fluid.Sensors.MassFlowRate masFlo3(redeclare package Medium = Medium)
    "Mass flow rate sensor" annotation (Placement(transformation(extent={{0,-50},
            {20,-30}})));
  Buildings.Utilities.Diagnostics.AssertEquality assEqu(threShold=1E-4, message=
        "Inputs differ, check that lossless pipe is correctly implemented.")
    "Assert equality of the two mass flow rates"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
equation
  connect(res2.port_b, masFlo2.port_a) annotation (Line(points={{-8,6.10623e-16},
          {-1,6.10623e-16},{-1,1.22125e-15},{6,1.22125e-15},{6,6.10623e-16},{20,
          6.10623e-16}},  color={0,127,255}));
  connect(res3.port_b, masFlo3.port_a) annotation (Line(points={{-8,-40},{
          -5.55112e-16,-40}},  color={0,127,255}));
  connect(masFlo3.port_b, pipCon.port_a) annotation (Line(points={{20,-40},{34,
          -40}}, color={0,127,255}));
  connect(P.y, sou1.p_in) annotation (Line(
      points={{-79,80},{-74,80},{-74,8},{-62,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou1.ports[1], res1.port_a) annotation (Line(
      points={{-40,2.66667},{-34,2.66667},{-34,40},{-28,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin1.ports[1], res1.port_b) annotation (Line(
      points={{70,2.66667},{60,2.66667},{60,40},{-8,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(masFlo3.m_flow, assEqu.u1) annotation (Line(
      points={{10,-29},{10,76},{38,76}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(masFlo2.m_flow, assEqu.u2) annotation (Line(
      points={{30,11},{30,64},{38,64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PAtm.y, sin1.p_in) annotation (Line(
      points={{87,86},{96,86},{96,8},{92,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou1.ports[2], res2.port_a) annotation (Line(
      points={{-40,5.55112e-16},{-36,5.55112e-16},{-36,6.10623e-16},{-28,
          6.10623e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou1.ports[3], res3.port_a) annotation (Line(
      points={{-40,-2.66667},{-34,-2.66667},{-34,-40},{-28,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin1.ports[2], masFlo2.port_b) annotation (Line(
      points={{70,5.55112e-16},{55,5.55112e-16},{55,6.10623e-16},{40,
          6.10623e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin1.ports[3], pipCon.port_b) annotation (Line(
      points={{70,-2.66667},{60,-2.66667},{60,-40},{54,-40}},
      color={0,127,255},
      smooth=Smooth.None));
    annotation (experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FixedResistances/Examples/FixedResistance.mos"
        "Simulate and plot"));
end FixedResistance;
