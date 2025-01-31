within Buildings.Fluid.Movers.Validation.BaseClasses;
model ComparePower
  "Base class for validation models that compare power estimation methods"

  package Medium = Buildings.Media.Water "Medium model";

  replaceable parameter Buildings.Fluid.Movers.Data.Generic per
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Performance records"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal =
    per.peak.V_flow * rho_default
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dp_nominal =
    per.peak.dp
    "Nominal pressure drop";
  final parameter Modelica.Units.SI.Density rho_default=
    Medium.density_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default) "Default medium density";

  replaceable Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine mov1
    constrainedby Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine
    "Mover (fan or pump)"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  replaceable Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine mov2
    constrainedby Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine
    "Mover (fan or pump)"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  replaceable Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine mov3
    constrainedby Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine
    "Mover (fan or pump)"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));

  Buildings.Fluid.Actuators.Dampers.Exponential damExp1(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    use_strokeTime=false,
    final dpDamper_nominal=dp_nominal/2,
    y_start=1,
    final dpFixed_nominal=dp_nominal/2) "Damper"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Buildings.Fluid.Actuators.Dampers.Exponential damExp2(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    use_strokeTime=false,
    final dpDamper_nominal=dp_nominal/2,
    y_start=1,
    final dpFixed_nominal=dp_nominal/2) "Damper"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Buildings.Fluid.Actuators.Dampers.Exponential damExp3(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    use_strokeTime=false,
    final dpDamper_nominal=dp_nominal/2,
    y_start=1,
    final dpFixed_nominal=dp_nominal/2) "Damper"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));

  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare final package Medium = Medium,
    nPorts=3)
    "Source"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare final package Medium = Medium,
    nPorts=3)
    "Sink" annotation (Placement(transformation(extent={{100,-10},{80,10}})));
  Modelica.Blocks.Sources.Ramp ramSpe(
    height=1,
    duration=60,
    startTime=20) "Ramp signal for mover speed"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Modelica.Blocks.Sources.Ramp ramDam(
    height=-1,
    duration=60,
    offset=1,
    startTime=120) "Ramp signal for damper position"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));

equation
  connect(sou.ports[1], mov1.port_a)
    annotation (Line(points={{-80,-1.33333},{-80,40},{-40,40}},
                                                         color={0,127,255}));
  connect(sou.ports[2], mov2.port_a)
    annotation (Line(points={{-80,0},{-80,-20},{-40,-20}}, color={0,127,255}));
  connect(sou.ports[3], mov3.port_a) annotation (Line(points={{-80,1.33333},{-78,
          1.33333},{-78,0},{-80,0},{-80,-70},{-40,-70}}, color={0,127,255}));
  connect(damExp1.port_b, sin.ports[1]) annotation (Line(points={{60,40},{80,40},
          {80,-1.33333}},color={0,127,255}));
  connect(ramDam.y, damExp1.y)
    annotation (Line(points={{21,80},{50,80},{50,52}}, color={0,0,127}));
  connect(mov2.port_b, damExp2.port_a)
    annotation (Line(points={{-20,-20},{40,-20}}, color={0,127,255}));
  connect(damExp2.port_b, sin.ports[2])
    annotation (Line(points={{60,-20},{80,-20},{80,0}}, color={0,127,255}));
  connect(mov3.port_b, damExp3.port_a)
    annotation (Line(points={{-20,-70},{40,-70}}, color={0,127,255}));
  connect(damExp3.port_b, sin.ports[3]) annotation (Line(points={{60,-70},{80,-70},
          {80,1.33333}}, color={0,127,255}));
  connect(ramDam.y, damExp2.y) annotation (Line(points={{21,80},{30,80},{30,0},
          {50,0},{50,-8}}, color={0,0,127}));
  connect(ramDam.y, damExp3.y) annotation (Line(points={{21,80},{30,80},{30,-50},
          {50,-50},{50,-58}}, color={0,0,127}));
  connect(mov1.port_b, damExp1.port_a)
    annotation (Line(points={{-20,40},{40,40}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
        Documentation(info="<html>
<p>
This is the base class for a number of validation models that compare
power computation of different mover model configurations.
</p>
</html>", revisions="<html>
<ul>
<li>
May 15, 2024, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1880\">IBPSA, #1880</a>.
</li>
</ul>
</html>"));
end ComparePower;
