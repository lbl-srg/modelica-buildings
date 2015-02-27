within Buildings.Fluid.Delays.Examples;
model Delay
  extends Modelica.Icons.Example;
// We set X_default to a small enough value to avoid saturation at the medium temperature
// that is used in this model.
 package Medium = Buildings.Media.Air(X_default={0.001, 0.999});

    Modelica.Blocks.Sources.Constant PAtm(k=101325)
      annotation (Placement(transformation(extent={{62,36},{82,56}})));
    Modelica.Blocks.Sources.Ramp P(
      duration=1,
    height=20,
    offset=101315)
                 annotation (Placement(transformation(extent={{-94,30},{-74,50}})));
    Buildings.Fluid.FixedResistances.FixedResistanceDpM res1(
    from_dp=true,
    m_flow_nominal=5,
    dp_nominal=5,
    redeclare package Medium = Medium)
             annotation (Placement(transformation(extent={{-30,-4},{-10,16}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
                T=293.15, redeclare package Medium = Medium,
    use_p_in=true,
    nPorts=1)             annotation (Placement(transformation(extent={{-58,-4},
            {-38,16}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
                T=283.15, redeclare package Medium = Medium,
    use_p_in=true,
    nPorts=1)             annotation (Placement(transformation(extent={{78,-4},
            {58,16}})));
    Buildings.Fluid.FixedResistances.FixedResistanceDpM res2(
    from_dp=true,
    m_flow_nominal=5,
    dp_nominal=5,
    redeclare package Medium = Medium)
             annotation (Placement(transformation(extent={{26,-4},{46,16}})));
  Buildings.Fluid.Delays.DelayFirstOrder del(         m_flow_nominal=5, redeclare
      package Medium = Medium,
    nPorts=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=283.15)
    "Fluid volume that is a first order approximation of the transport delay"
    annotation (Placement(transformation(extent={{-2,6},{18,26}})));

equation
  connect(P.y, sou.p_in) annotation (Line(points={{-73,40},{-66,40},{-66,14},{
          -60,14}}, color={0,0,127}));
  connect(PAtm.y, sin.p_in) annotation (Line(points={{83,46},{90,46},{90,14},{
          80,14}}, color={0,0,127}));
  connect(sou.ports[1], res1.port_a) annotation (Line(
      points={{-38,6},{-36,6},{-36,6},{-34,6},{-34,6},{-30,6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin.ports[1], res2.port_b) annotation (Line(
      points={{58,6},{55,6},{55,6},{52,6},{52,6},{46,6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res1.port_b, del.ports[1]) annotation (Line(
      points={{-10,6},{6,6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res2.port_a, del.ports[2]) annotation (Line(
      points={{26,6},{10,6}},
      color={0,127,255},
      smooth=Smooth.None));
    annotation (experiment(StopTime=300),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Delays/Examples/Delay.mos"
        "Simulate and plot"));
end Delay;
