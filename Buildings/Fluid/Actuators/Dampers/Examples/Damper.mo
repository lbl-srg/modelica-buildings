within Buildings.Fluid.Actuators.Dampers.Examples;
model Damper
  "Dampers with constant pressure difference and varying control signal."
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air "Medium model for air";

  Buildings.Fluid.Actuators.Dampers.Exponential res(
    redeclare package Medium = Medium,
    use_strokeTime=false,
    dpDamper_nominal=10,
    m_flow_nominal=1,
    k1=0.45) "A damper with quadratic relationship between m_flow and dp"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));

    Modelica.Blocks.Sources.Ramp yRam(
    duration=0.3,
    offset=0,
    startTime=0.2,
    height=1) annotation (Placement(transformation(extent={{-20,60},{0,80}})));

  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    p(displayUnit="Pa") = 101335,
    T=293.15,
    nPorts=4) "Pressure boundary condition"
     annotation (Placement(
        transformation(extent={{-60,-10},{-40,10}})));

  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=4) "Pressure boundary condition"
      annotation (Placement(
        transformation(extent={{94,-10},{74,10}})));

  Buildings.Fluid.Actuators.Dampers.PressureIndependent preIndDpFixed_nominal(
    use_strokeTime=false,
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dpFixed_nominal=5,
    dpDamper_nominal=10)
    "A damper with a mass flow proportional to the input signal and using dpFixed_nominal"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));

  Buildings.Fluid.Actuators.Dampers.PressureIndependent preIndFrom_dp(
    use_strokeTime=false,
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dpFixed_nominal=0,
    dpDamper_nominal=10,
    from_dp=false)
    "A damper with a mass flow proportional to the input signal and using from_dp = false"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));

  Buildings.Fluid.Actuators.Dampers.PressureIndependent preInd(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dpDamper_nominal=10,
    use_strokeTime=false)
    "A damper with a mass flow proportional to the input signal"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

equation
  connect(yRam.y, res.y) annotation (Line(
      points={{1,70},{10,70},{10,52}},
      color={0,0,127}));
  connect(yRam.y, preInd.y) annotation (Line(points={{1,70},{30,70},{30,20},{10,
          20},{10,12}}, color={0,0,127}));
  connect(res.port_a, sou.ports[1]) annotation (Line(points={{0,40},{-20,40},{
          -20,4},{-20,3},{-40,3}},
                               color={0,127,255}));
  connect(preInd.port_a, sou.ports[2])
    annotation (Line(points={{0,0},{-40,0},{-40,1}}, color={0,127,255}));
  connect(preIndFrom_dp.port_a, sou.ports[3]) annotation (Line(points={{0,-40},
          {-20,-40},{-20,-1},{-40,-1}}, color={0,127,255}));
  connect(res.port_b, sin.ports[1]) annotation (Line(points={{20,40},{60,40},{
          60,3},{74,3}},
                      color={0,127,255}));
  connect(preInd.port_b, sin.ports[2])
    annotation (Line(points={{20,0},{74,0},{74,1}}, color={0,127,255}));
  connect(sou.ports[4], preIndDpFixed_nominal.port_a) annotation (Line(points={
          {-40,-3},{-24,-3},{-24,-4},{-24,-4},{-24,-80},{0,-80}}, color={0,127,
          255}));
  connect(preIndFrom_dp.port_b, sin.ports[3]) annotation (Line(points={{20,-40},
          {60,-40},{60,-1},{74,-1}}, color={0,127,255}));
  connect(preIndDpFixed_nominal.port_b, sin.ports[4]) annotation (Line(points={
          {20,-80},{44,-80},{64,-80},{64,-3},{74,-3}}, color={0,127,255}));
  connect(preIndFrom_dp.y, yRam.y) annotation (Line(points={{10,-28},{10,-20},{
          30,-20},{30,70},{1,70}}, color={0,0,127}));
  connect(preIndDpFixed_nominal.y, yRam.y) annotation (Line(points={{10,-68},{
          10,-60},{30,-60},{30,70},{1,70}}, color={0,0,127}));
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
</html>"));
end Damper;
