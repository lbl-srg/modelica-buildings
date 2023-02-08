within Buildings.Experimental.DHC.Plants.Combined.Subsystems.Validation;
model Valve
  extends Modelica.Icons.Example;
  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CHW medium";


  parameter Real m1 = 1;
  parameter Real m2 = 1.5;
  parameter Real dpv1 = 1E3;
  parameter Real dpv2 = 1E3;
  parameter Real dpf1 = 3E4;
  parameter Real dpf2 = 5E4;
  parameter Real dps = 20E4;

  parameter Real y1 = if dpf2 + dpv2 - dpf1 <= 0 then 1 else
    (dpv1 / (dpf2 + dpv2 - dpf1))^0.5;
  parameter Real y2 = if dpf1 + dpv1 - dpf2 <= 0 then 1 else
    (dpv2 / (dpf1 + dpv1 - dpf2))^0.5;

  Fluid.Actuators.Valves.TwoWayLinear val1(
    redeclare package Medium = Medium,
    m_flow_nominal=m1,
    linearized=true,
    dpValve_nominal=dpv1,
    use_inputFilter=false,
    dpFixed_nominal=dpf1)
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Fluid.Actuators.Valves.TwoWayLinear val2(
    redeclare package Medium=Medium,
    m_flow_nominal=m2,
    linearized=true,
    dpValve_nominal=dpv2,
    use_inputFilter=false,
    dpFixed_nominal=dpf2)
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Fluid.Sources.Boundary_pT bou(
    p=Medium.p_default + dps,  nPorts=2,
    redeclare package Medium=Medium)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Fluid.Sources.Boundary_pT bou1(nPorts=2,
    redeclare package Medium=Medium)
    annotation (Placement(transformation(extent={{90,-10},{70,10}})));
  Modelica.Blocks.Sources.RealExpression y[2](y={y1, y2})
    annotation (Placement(transformation(extent={{-70,50},{-50,70}})));
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
    annotation (Line(points={{-49,60},{0,60},{0,52}}, color={0,0,127}));
  connect(y[2].y,val2. y) annotation (Line(points={{-49,60},{-20,60},{-20,-20},{
          0,-20},{0,-28}}, color={0,0,127}));
end Valve;
