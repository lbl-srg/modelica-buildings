within Buildings.Fluid.Actuators.Examples;
model Damper
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.IdealGases.SimpleAir;

  Buildings.Fluid.Actuators.Dampers.Exponential res(
    A=1,
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    filteredOpening=false)
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
    nPorts=1,
    p(displayUnit="Pa") = 101335,
    T=293.15)                                       annotation (Placement(
        transformation(extent={{-68,10},{-48,30}}, rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sin(             redeclare package Medium
      = Medium,
    nPorts=1,
    p(displayUnit="Pa") = 101325,
    T=293.15)                                       annotation (Placement(
        transformation(extent={{74,10},{54,30}}, rotation=0)));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
equation
  connect(yRam.y, res.y) annotation (Line(
      points={{1,50},{10,50},{10,32}},
      color={0,0,127},
      pattern=LinePattern.None));
  connect(sou.ports[1], res.port_a) annotation (Line(
      points={{-48,20},{-5.55112e-16,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin.ports[1], res.port_b) annotation (Line(
      points={{54,20},{20,20}},
      color={0,127,255},
      smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                        graphics),
experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Actuators/Examples/Damper.mos"
        "Simulate and plot"));
end Damper;
