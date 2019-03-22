within Buildings.Fluid.Actuators.Dampers.Examples;
model Damper
  "Dampers with constant pressure difference and varying control signal."
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air "Medium model for air";

  Buildings.Fluid.Actuators.Dampers.Exponential res(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    use_inputFilter=false)
    "A damper with quadratic relationship between m_flow and dp"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));

    Modelica.Blocks.Sources.Ramp yRam(
    duration=0.3,
    offset=0,
    startTime=0.2,
    height=1) annotation (Placement(transformation(extent={{-20,60},{0,80}})));

  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    nPorts=3,
    p(displayUnit="Pa") = Medium.p_default + preInd.dp_nominal + preInd.dpFixed_nominal,
    T=293.15) "Pressure boundary condition"
     annotation (Placement(
        transformation(extent={{-60,-10},{-40,10}})));

  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=4) "Pressure boundary condition"
      annotation (Placement(
        transformation(extent={{94,-10},{74,10}})));

  Buildings.Fluid.Actuators.Dampers.PressureIndependent preInd(
    use_inputFilter=false,
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=10,
    use_deltaM=false,
    roundDuct=true,
    dpFixed_nominal=20)
    "A damper with a mass flow proportional to the input signal and using dpFixed_nominal"
    annotation (Placement(transformation(extent={{-4,-40},{16,-20}})));

  Exponential dam(
    use_inputFilter=false,
    redeclare package Medium = Medium,
    v_nominal=preInd.v_nominal,
    a=preInd.a,
    b=preInd.b,
    yL=preInd.yL,
    yU=preInd.yU,
    k0=preInd.k0,
    k1=preInd.k1,
    m_flow_nominal=preInd.m_flow_nominal,
    from_dp=false,
    use_deltaM=false,
    roundDuct=true)
    annotation (Placement(transformation(extent={{28,-84},{48,-64}})));
  FixedResistances.PressureDrop res1(
    redeclare package Medium = Medium,
    dp_nominal=preInd.dpFixed_nominal,
    m_flow_nominal=preInd.m_flow_nominal)
    annotation (Placement(transformation(extent={{-12,-84},{8,-64}})));
  Sources.Boundary_pT                 sou1(
    redeclare package Medium = Medium,
    nPorts=1,
    use_p_in=true,
    p(displayUnit="Pa"),
    T=293.15) "Pressure boundary condition"
     annotation (Placement(
        transformation(extent={{-60,-140},{-40,-120}})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=0.3,
    startTime=0.2,
    height=preInd.dp_nominal + 3*preInd.dpFixed_nominal,
    offset=Medium.p_default - preInd.dpFixed_nominal)
    annotation (Placement(transformation(extent={{-152,-132},{-132,-112}})));
  PressureIndependent                                   preInd1(
    use_inputFilter=false,
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=10,
    use_deltaM=false,
    roundDuct=true,
    dpFixed_nominal=20)
    "A damper with a mass flow proportional to the input signal and using dpFixed_nominal"
    annotation (Placement(transformation(extent={{-2,-140},{18,-120}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=1 - min(time*2, 1))
    annotation (Placement(transformation(extent={{-152,-98},{-132,-78}})));
equation
  connect(yRam.y, res.y) annotation (Line(
      points={{1,70},{10,70},{10,52}},
      color={0,0,127}));
  connect(res.port_a, sou.ports[1]) annotation (Line(points={{0,40},{-28,40},{
          -28,2.66667},{-40,2.66667}},
                               color={0,127,255}));
  connect(res.port_b, sin.ports[1]) annotation (Line(points={{20,40},{60,40},{
          60,3},{74,3}},
                      color={0,127,255}));
  connect(sou.ports[2], preInd.port_a) annotation (Line(points={{-40,0},{-28,0},
          {-28,-30},{-4,-30}},                                     color={0,127,
          255}));
  connect(preInd.port_b, sin.ports[2]) annotation (Line(points={{16,-30},{60,
          -30},{60,1},{74,1}},                           color={0,127,255}));
  connect(preInd.y, yRam.y) annotation (Line(points={{6,-18},{6,-10},{26,-10},{
          26,70},{1,70}},  color={0,0,127}));
  connect(preInd.y_open, dam.y)
    annotation (Line(points={{11,-20},{38,-20},{38,-62}},  color={0,0,127}));
  connect(dam.port_b, sin.ports[3]) annotation (Line(points={{48,-74},{60,-74},
          {60,-1},{74,-1}},             color={0,127,255}));
  connect(dam.port_a, res1.port_b)
    annotation (Line(points={{28,-74},{8,-74}},    color={0,127,255}));
  connect(sou.ports[3], res1.port_a) annotation (Line(points={{-40,-2.66667},{
          -28,-2.66667},{-28,-74},{-12,-74}},  color={0,127,255}));
  connect(sou1.p_in, ramp.y)
    annotation (Line(points={{-62,-122},{-131,-122}}, color={0,0,127}));
  connect(sou1.ports[1], preInd1.port_a)
    annotation (Line(points={{-40,-130},{-2,-130}}, color={0,127,255}));
  connect(preInd1.port_b, sin.ports[4]) annotation (Line(points={{18,-130},{64,
          -130},{64,-3},{74,-3}}, color={0,127,255}));
  connect(preInd1.y, realExpression.y) annotation (Line(points={{8,-118},{-32,
          -118},{-32,-88},{-131,-88}}, color={0,0,127}));
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
    Diagram(coordinateSystem(extent={{-160,-160},{100,100}})));
end Damper;
