within Buildings.Fluid.Delays.Examples;
model Delay

    annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                        graphics),
                         Commands(file=
            "Delay.mos" "run"));
 package Medium = Buildings.Media.ConstantPropertyLiquidWater;
// package Medium = Buildings.Media.IdealGases.SimpleAir;

    Modelica.Blocks.Sources.Constant PAtm(k=101325) 
      annotation (Placement(transformation(extent={{62,36},{82,56}}, rotation=0)));
    Modelica.Blocks.Sources.Ramp P(
      duration=1,
    height=20,
    offset=101315) 
                 annotation (Placement(transformation(extent={{-94,30},{-74,50}},
          rotation=0)));
    Buildings.Fluid.FixedResistances.FixedResistanceDpM res1(
    from_dp=true,
    m_flow_nominal=5,
    dp_nominal=5,
    redeclare package Medium = Medium) 
             annotation (Placement(transformation(extent={{-30,-4},{-10,16}},
          rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sou(
                T=293.15, redeclare package Medium = Medium,
    use_p_in=true,
    nPorts=1)             annotation (Placement(transformation(extent={{-58,-4},
            {-38,16}}, rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sin(
                T=283.15, redeclare package Medium = Medium,
    use_p_in=true,
    nPorts=1)             annotation (Placement(transformation(extent={{78,-4},
            {58,16}}, rotation=0)));
    Buildings.Fluid.FixedResistances.FixedResistanceDpM res2(
    from_dp=true,
    m_flow_nominal=5,
    dp_nominal=5,
    redeclare package Medium = Medium) 
             annotation (Placement(transformation(extent={{26,-4},{46,16}},
          rotation=0)));
  Buildings.Fluid.Delays.DelayFirstOrder del(         m_flow_nominal=5, redeclare
      package Medium = Medium,
    T_start=283.15) 
    annotation (Placement(transformation(extent={{0,6},{20,26}},   rotation=0)));
  inner Modelica.Fluid.System system 
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
equation
  connect(P.y, sou.p_in) annotation (Line(points={{-73,40},{-66,40},{-66,14},{
          -60,14}}, color={0,0,127}));
  connect(PAtm.y, sin.p_in) annotation (Line(points={{83,46},{90,46},{90,14},{
          80,14}}, color={0,0,127}));
  connect(sou.ports[1], res1.port_a) annotation (Line(
      points={{-38,6},{-30,6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin.ports[1], res2.port_b) annotation (Line(
      points={{58,6},{46,6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res1.port_b, del.ports[1]) annotation (Line(
      points={{-10,6},{8,6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(del.ports[2], res2.port_a) annotation (Line(
      points={{12,6},{26,6}},
      color={0,127,255},
      smooth=Smooth.None));
end Delay;
