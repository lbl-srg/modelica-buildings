within Buildings.Fluid.Actuators.Dampers.Examples;
model Damper
  "Dampers with constant pressure difference and varying control signal."
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air "Medium model for air";

  parameter Real yCstVal = 0 "Constant value for control input signal";

  Modelica.Blocks.Sources.Ramp yRam(
  duration=0.3,
  offset=0,
  startTime=0.2,
  height=1) annotation (Placement(transformation(extent={{-40,60},{-20,80}})));

  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    p(displayUnit="Pa") = 101335,
    T=293.15,
    nPorts=3) "Pressure boundary condition"
     annotation (Placement(
        transformation(extent={{-60,-10},{-40,10}})));

  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=4) "Pressure boundary condition"
      annotation (Placement(
        transformation(extent={{80,-10},{60,10}})));

  PressureIndependent preInd(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=5,
    use_inputFilter=false,
    v_nominal=3) "A damper with a mass flow proportional to the input signal"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Exponential res(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    use_inputFilter=false)
    "A damper with quadratic relationship between m_flow and dp"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  PressureIndependent preIndDpFixed_nominal(
    m_flow_nominal=1,
    dp_nominal=5,
    use_inputFilter=false,
    v_nominal=3,
    dpFixed_nominal=20,
    redeclare package Medium = Medium)
    "A damper with a mass flow proportional to the input signal and using dpFixed_nominal"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
    Modelica.Blocks.Sources.Ramp pSouVar(
    duration=0.3,
    startTime=0.2,
    height=20,
    offset=Medium.p_default - 10)
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Sources.Boundary_pT souVar(
    redeclare package Medium = Medium,
    nPorts=1,
    use_p_in=true,
    p(displayUnit="Pa"),
    T=293.15) "Pressure boundary condition variable"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  PressureIndependent preInd0(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=5,
    use_inputFilter=false,
    v_nominal=3) "A damper with a mass flow proportional to the input signal"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Modelica.Blocks.Sources.Constant yCst(k=yCstVal)
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
equation
  connect(sou.ports[1], res.port_a) annotation (Line(points={{-40,2.66667},{-20,
          2.66667},{-20,40},{0,40}}, color={0,127,255}));
  connect(res.port_b, sin.ports[1]) annotation (Line(points={{20,40},{48,40},{
          48,3},{60,3}}, color={0,127,255}));
  connect(preInd.port_b, sin.ports[2])
    annotation (Line(points={{20,0},{48,0},{48,1},{60,1}}, color={0,127,255}));
  connect(yRam.y, res.y)
    annotation (Line(points={{-19,70},{10,70},{10,52}}, color={0,0,127}));
  connect(yRam.y, preInd.y) annotation (Line(points={{-19,70},{-12,70},{-12,20},
          {10,20},{10,12}}, color={0,0,127}));
  connect(yRam.y, preIndDpFixed_nominal.y) annotation (Line(points={{-19,70},{
          -12,70},{-12,-20},{10,-20},{10,-28}}, color={0,0,127}));
  connect(pSouVar.y, souVar.p_in) annotation (Line(points={{-79,-60},{-70,-60},
          {-70,-72},{-62,-72}}, color={0,0,127}));
  connect(souVar.ports[1], preInd0.port_a)
    annotation (Line(points={{-40,-80},{0,-80}}, color={0,127,255}));
  connect(yCst.y, preInd0.y)
    annotation (Line(points={{-19,-60},{10,-60},{10,-68}}, color={0,0,127}));
  connect(sou.ports[2], preInd.port_a) annotation (Line(points={{-40,
          -2.22045e-16},{-20,-2.22045e-16},{-20,0},{0,0}}, color={0,127,255}));
  connect(sou.ports[3], preIndDpFixed_nominal.port_a) annotation (Line(points={
          {-40,-2.66667},{-20,-2.66667},{-20,-40},{0,-40}}, color={0,127,255}));
  connect(preIndDpFixed_nominal.port_b, sin.ports[3]) annotation (Line(points={
          {20,-40},{50,-40},{50,-1},{60,-1}}, color={0,127,255}));
  connect(preInd0.port_b, sin.ports[4]) annotation (Line(points={{20,-80},{52,
          -80},{52,-3},{60,-3}}, color={0,127,255}));
    annotation (experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Actuators/Dampers/Examples/Damper.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
Test model for exponential and linear air dampers.
The air dampers are connected to models for constant inlet and outlet
pressures. The control signal of the dampers is a ramp.
</p>
</html>", revisions="<html>
<ul>
<li>
March 21, 2017 by David Blum:<br/>
Added Linear damper models <code>lin</code>, <code>preIndFrom_dp</code>, and <code>preInd</code>.
</li>
<li>
July 20, 2007 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-120,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-120,-100},{100,100}})));
end Damper;
