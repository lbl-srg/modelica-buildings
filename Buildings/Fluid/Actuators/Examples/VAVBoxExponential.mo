within Buildings.Fluid.Actuators.Examples;
model VAVBoxExponential
  extends Modelica.Icons.Example;

 package Medium = Buildings.Media.IdealGases.SimpleAir;

  Buildings.Fluid.Actuators.Dampers.Exponential dam(
         redeclare package Medium = Medium, A=1.8,
    m_flow_nominal=2)
         annotation (Placement(transformation(extent={{20,10},{40,30}},
          rotation=0)));
    Modelica.Blocks.Sources.Step yDam(
    height=-1,
    offset=1,
    startTime=60)
                 annotation (Placement(transformation(extent={{-60,60},{-40,80}},
          rotation=0)));
    Modelica.Blocks.Sources.Ramp P(
    height=-10,
    offset=101330,
    startTime=0,
    duration=60) annotation (Placement(transformation(extent={{-100,40},{-80,60}},
          rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sou(             redeclare package Medium
      =        Medium, T=273.15 + 20,
    nPorts=2,
    use_p_in=true)                      annotation (Placement(transformation(
          extent={{-70,-20},{-50,0}}, rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sin(             redeclare package Medium
      =        Medium, T=273.15 + 20,
    nPorts=2,
    use_p_in=true)                      annotation (Placement(transformation(
          extent={{72,-20},{52,0}}, rotation=0)));
    Modelica.Blocks.Sources.Constant PAtm(k=101325)
      annotation (Placement(transformation(extent={{60,60},{80,80}}, rotation=0)));
  Buildings.Fluid.Actuators.Dampers.VAVBoxExponential vav(
    redeclare package Medium = Medium,
    dp_nominal=5,
    A=1.8,
    m_flow_nominal=2)
         annotation (Placement(transformation(extent={{-2,-50},{18,-30}},
          rotation=0)));
    Buildings.Fluid.FixedResistances.FixedResistanceDpM res(
    from_dp=true,
    m_flow_nominal=2,
    redeclare package Medium = Medium,
    dp_nominal=5 - 0.45*2^2/1.2/1.8^2/2)
             annotation (Placement(transformation(extent={{-36,10},{-16,30}},
          rotation=0)));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
equation
  connect(yDam.y,dam. y) annotation (Line(
      points={{-39,70},{-12,70},{-12,40},{30,40},{30,32}},
      color={0,0,127},
      pattern=LinePattern.None));
  connect(P.y, sou.p_in) annotation (Line(points={{-79,50},{-78,50},{-78,-2},{
          -72,-2}}, color={0,0,127}));
  connect(PAtm.y, sin.p_in) annotation (Line(points={{81,70},{92,70},{92,-2},{
          74,-2}}, color={0,0,127}));
  connect(yDam.y, vav.y) annotation (Line(
      points={{-39,70},{-12,70},{-12,-20},{8,-20},{8,-28}},
      color={0,0,127},
      pattern=LinePattern.None));
  connect(res.port_b, dam.port_a)
    annotation (Line(points={{-16,20},{20,20}}, color={0,127,255}));
  connect(sou.ports[1], res.port_a) annotation (Line(
      points={{-50,-8},{-42,-8},{-42,20},{-36,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[2], vav.port_a) annotation (Line(
      points={{-50,-12},{-42,-12},{-42,-40},{-2,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dam.port_b, sin.ports[1]) annotation (Line(
      points={{40,20},{46,20},{46,-8},{52,-8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin.ports[2], vav.port_b) annotation (Line(
      points={{52,-12},{46,-12},{46,-40},{18,-40}},
      color={0,127,255},
      smooth=Smooth.None));
 annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                     graphics),
             __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Actuators/Examples/VAVBoxExponential.mos"
        "Simulate and plot"),
    experiment(StopTime=240));
end VAVBoxExponential;
