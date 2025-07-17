within Buildings.DHC.Plants.Combined.Subsystems.Validation;
model ValveOpeningFlowBalancing
  "Validation model for the computation of the valve opening ensuring flow balancing"
  extends Modelica.Icons.Example;
  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CHW medium";

  parameter Real m1_flow = 1
    "Valve #1 design mass flow rate";
  parameter Real m2_flow = 1.5
    "Valve #2 design mass flow rate";
  parameter Real dpv1 = 1E3
    "Valve #1 design pressure drop";
  parameter Real dpv2 = 1E3
    "Valve #2 design pressure drop";
  parameter Real dpf1 = 3E4
    "Design pressure drop of fixed flow resistance in series with valve #1";
  parameter Real dpf2 = 5E4
    "Design pressure drop of fixed flow resistance in series with valve #2";
  parameter Real dps = 20E4;

  parameter Real y1 = if dpf2 + dpv2 - dpf1 <= 0 then 1 else
    (dpv1 / (dpf2 + dpv2 - dpf1))^0.5
    "Valve #1 opening";
  parameter Real y2 = if dpf1 + dpv1 - dpf2 <= 0 then 1 else
    (dpv2 / (dpf1 + dpv1 - dpf2))^0.5
    "Valve #2 opening";

  Fluid.Actuators.Valves.TwoWayLinear val1(
    redeclare package Medium = Medium,
    m_flow_nominal=m1_flow,
    linearized=true,
    dpValve_nominal=dpv1,
    use_strokeTime=false,
    dpFixed_nominal=dpf1)
    "Valve #1"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Fluid.Actuators.Valves.TwoWayLinear val2(
    redeclare package Medium=Medium,
    m_flow_nominal=m2_flow,
    linearized=true,
    dpValve_nominal=dpv2,
    use_strokeTime=false,
    dpFixed_nominal=dpf2)
    "Valve #1"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Fluid.Sources.Boundary_pT bou(
    p=Medium.p_default + dps,  nPorts=2,
    redeclare package Medium=Medium)
    "Pressure boundary condition"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Fluid.Sources.Boundary_pT bou1(nPorts=2,
    redeclare package Medium=Medium)
    "Pressure boundary condition"
    annotation (Placement(transformation(extent={{90,-10},{70,10}})));
  Modelica.Blocks.Sources.RealExpression y[2](y={y1, y2})
    "Valve opening signal"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
equation
  connect(bou.ports[1], val1.port_a) annotation (Line(points={{-60,-1},{-40,-1},
          {-40,40},{-10,40}}, color={0,127,255}));
  connect(val1.port_b, bou1.ports[1]) annotation (Line(points={{10,40},{40,40},{
          40,-1},{70,-1}}, color={0,127,255}));
  connect(bou.ports[2],val2. port_a) annotation (Line(points={{-60,1},{-40,1},{-40,
          -40},{-10,-40}}, color={0,127,255}));
  connect(val2.port_b, bou1.ports[2]) annotation (Line(points={{10,-40},{40,-40},
          {40,1},{70,1}}, color={0,127,255}));
  connect(y[1].y, val1.y)
    annotation (Line(points={{-59,60},{0,60},{0,52}}, color={0,0,127}));
  connect(y[2].y,val2. y) annotation (Line(points={{-59,60},{-20,60},{-20,-20},{
          0,-20},{0,-28}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/DHC/Plants/Combined/Subsystems/Validation/ValveOpeningFlowBalancing.mos"
      "Simulate and plot"),
    experiment(
      StopTime=1,
      Tolerance=1e-06),
  Documentation(info="<html>
<p>
This model validates the computation of the valve opening that ensures
flow balancing proportional to design flow in the case of linear valves
configured with a pressure drop varying linearly with the flow rate.
</p>
</html>", revisions="<html>
<ul>
<li>
February 24, 2023, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end ValveOpeningFlowBalancing;
