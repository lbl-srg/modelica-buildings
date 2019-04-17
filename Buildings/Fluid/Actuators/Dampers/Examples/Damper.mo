within Buildings.Fluid.Actuators.Dampers.Examples;
model Damper
  "Dampers with constant pressure difference and varying control signal."
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air "Medium model for air";

  Modelica.Blocks.Sources.Ramp yRam(
  duration=0.3,
  offset=0,
  startTime=0.2,
  height=1) annotation (Placement(transformation(extent={{-10,70},{10,90}})));

  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    p(displayUnit="Pa") = 101335,
    T=293.15,
    nPorts=3) "Pressure boundary condition"
     annotation (Placement(
        transformation(extent={{-60,0},{-40,20}})));

  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=5) "Pressure boundary condition"
      annotation (Placement(
        transformation(extent={{100,0},{80,20}})));

  PressureIndependent preInd(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=5,
    use_inputFilter=false,
    v_nominal=3) "A damper with a mass flow proportional to the input signal"
    annotation (Placement(transformation(extent={{30,0},{50,20}})));
  Exponential res(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    use_inputFilter=false,
    dp_nominal=0,
    dp_nominalIncludesDamper=false)
    "A damper with quadratic relationship between m_flow and dp"
    annotation (Placement(transformation(extent={{30,40},{50,60}})));
  PressureIndependent preIndDpFixed_nominal(
    m_flow_nominal=1,
    dp_nominal=5,
    use_inputFilter=false,
    v_nominal=3,
    dpFixed_nominal=20,
    redeclare package Medium = Medium)
    "A damper with a mass flow proportional to the input signal and using dpFixed_nominal"
    annotation (Placement(transformation(extent={{30,-40},{50,-20}})));
    Modelica.Blocks.Sources.Ramp pSouVar(
    duration=0.3,
    startTime=0.2,
    height=20,
    offset=Medium.p_default - 10)
    annotation (Placement(transformation(extent={{-100,-96},{-80,-76}})));
  Sources.Boundary_pT souVar(
    redeclare package Medium = Medium,
    nPorts=2,
    use_p_in=true,
    p(displayUnit="Pa"),
    T=293.15) "Pressure boundary condition variable"
    annotation (Placement(transformation(extent={{-60,-104},{-40,-84}})));
  PressureIndependent preInd0(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=5,
    use_inputFilter=false,
    v_nominal=3) "A damper with a mass flow proportional to the input signal"
    annotation (Placement(transformation(extent={{30,-102},{50,-82}})));
  Modelica.Blocks.Sources.Constant yCst0(k=0)
    annotation (Placement(transformation(extent={{-10,-82},{10,-62}})));
  PressureIndependent preInd1(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=5,
    use_inputFilter=false,
    v_nominal=3) "A damper with a mass flow proportional to the input signal"
    annotation (Placement(transformation(extent={{34,-150},{54,-130}})));
  Modelica.Blocks.Sources.Constant yCst1(k=1)
    annotation (Placement(transformation(extent={{-10,-122},{10,-102}})));
equation
  connect(sou.ports[1], res.port_a) annotation (Line(points={{-40,12.6667},{-20,
          12.6667},{-20,50},{30,50}},color={0,127,255}));
  connect(res.port_b, sin.ports[1]) annotation (Line(points={{50,50},{68,50},{
          68,13.2},{80,13.2}},
                         color={0,127,255}));
  connect(preInd.port_b, sin.ports[2])
    annotation (Line(points={{50,10},{68,10},{68,11.6},{80,11.6}},
                                                           color={0,127,255}));
  connect(yRam.y, res.y)
    annotation (Line(points={{11,80},{40,80},{40,62}},  color={0,0,127}));
  connect(yRam.y, preInd.y) annotation (Line(points={{11,80},{20,80},{20,30},{
          40,30},{40,22}},  color={0,0,127}));
  connect(yRam.y, preIndDpFixed_nominal.y) annotation (Line(points={{11,80},{20,
          80},{20,-10},{40,-10},{40,-18}},      color={0,0,127}));
  connect(pSouVar.y, souVar.p_in) annotation (Line(points={{-79,-86},{-62,-86}},
                                color={0,0,127}));
  connect(souVar.ports[1], preInd0.port_a)
    annotation (Line(points={{-40,-92},{30,-92}},color={0,127,255}));
  connect(yCst0.y, preInd0.y)
    annotation (Line(points={{11,-72},{40,-72},{40,-80}}, color={0,0,127}));
  connect(sou.ports[2], preInd.port_a) annotation (Line(points={{-40,10},{30,10}},
                                                           color={0,127,255}));
  connect(sou.ports[3], preIndDpFixed_nominal.port_a) annotation (Line(points={{-40,
          7.33333},{-20,7.33333},{-20,-30},{30,-30}},       color={0,127,255}));
  connect(preIndDpFixed_nominal.port_b, sin.ports[3]) annotation (Line(points={{50,-30},
          {68,-30},{68,10},{80,10}},          color={0,127,255}));
  connect(preInd0.port_b, sin.ports[4]) annotation (Line(points={{50,-92},{70,
          -92},{70,8.4},{80,8.4}},
                                 color={0,127,255}));
  connect(yCst1.y, preInd1.y)
    annotation (Line(points={{11,-112},{44,-112},{44,-128}}, color={0,0,127}));
  connect(souVar.ports[2], preInd1.port_a) annotation (Line(points={{-40,-96},{
          -20,-96},{-20,-140},{34,-140}}, color={0,127,255}));
  connect(preInd1.port_b, sin.ports[5]) annotation (Line(points={{54,-140},{72,
          -140},{72,6.8},{80,6.8}}, color={0,127,255}));
    annotation (experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Actuators/Dampers/Examples/Damper.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
Test model for exponential and pressure independent dampers.
</p>
<p>
In the first set of tests a constant pressure drop is applied at the damper (and optional fixed resistance) boundaries.
The control signal of the dampers is a ramp from 0 (fully closed damper) to 1 (fully open damper).
</p>
<p>
In the second set of tests a variable pressure drop is applied at the damper (and optional fixed resistance) boundaries
from negative (reverse flow) to positive values.
The control signal of the dampers is constant, either equal to 0 or 1.
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
    Diagram(coordinateSystem(extent={{-120,-160},{120,100}}))
);
end Damper;
