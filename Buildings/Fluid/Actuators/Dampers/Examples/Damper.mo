within Buildings.Fluid.Actuators.Dampers.Examples;
model Damper
  "Dampers with constant pressure difference and varying control signal."
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air "Medium model for air";

  Modelica.Blocks.Sources.Ramp yRam(
  duration=0.3,
  offset=0,
  startTime=0.2,
  height=1) annotation (Placement(transformation(extent={{-10,90},{10,110}})));

  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    p(displayUnit="Pa") = 101335,
    T=293.15,
    nPorts=4) "Pressure boundary condition"
     annotation (Placement(
        transformation(extent={{-62,-10},{-42,10}})));

  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=7) "Pressure boundary condition"
      annotation (Placement(
        transformation(extent={{102,-10},{82,10}})));

  PressureIndependent preInd(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=5,
    use_inputFilter=false,
    v_nominal=3) "A damper with a mass flow proportional to the input signal"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Exponential res(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    use_inputFilter=false,
    dp_nominal=0,
    dp_nominalIncludesDamper=false)
    "A damper with quadratic relationship between m_flow and dp"
    annotation (Placement(transformation(extent={{30,70},{50,90}})));
  PressureIndependent preIndDpFixed_nominal(
    m_flow_nominal=1,
    dp_nominal=5,
    use_inputFilter=false,
    v_nominal=3,
    dpFixed_nominal=20,
    redeclare package Medium = Medium)
    "A damper with a mass flow proportional to the input signal and using dpFixed_nominal"
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));
    Modelica.Blocks.Sources.Ramp pSouVar(
    duration=0.3,
    startTime=0.2,
    height=20,
    offset=Medium.p_default - 10)
    annotation (Placement(transformation(extent={{-100,-94},{-80,-74}})));
  Sources.Boundary_pT souVar(
    redeclare package Medium = Medium,
    nPorts=2,
    use_p_in=true,
    p(displayUnit="Pa"),
    T=293.15) "Pressure boundary condition variable"
    annotation (Placement(transformation(extent={{-60,-102},{-40,-82}})));
  PressureIndependent preInd0(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=5,
    use_inputFilter=false,
    v_nominal=3) "A damper with a mass flow proportional to the input signal"
    annotation (Placement(transformation(extent={{30,-90},{50,-70}})));
  Modelica.Blocks.Sources.Constant yCst0(k=0)
    annotation (Placement(transformation(extent={{-12,-70},{8,-50}})));
  PressureIndependent preInd1(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=5,
    use_inputFilter=false,
    v_nominal=3) "A damper with a mass flow proportional to the input signal"
    annotation (Placement(transformation(extent={{30,-130},{50,-110}})));
  Modelica.Blocks.Sources.Constant yCst1(k=1)
    annotation (Placement(transformation(extent={{-12,-110},{8,-90}})));
  Exponential resChaLin(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    use_inputFilter=false,
    linearized=false,
    char_linear=true,
    dp_nominal=0,
    dp_nominalIncludesDamper=false)
    "A damper with quadratic relationship between m_flow and dp and linearized characteristic"
    annotation (Placement(transformation(extent={{30,30},{50,50}})));
  PressureIndependent preIndChar(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    use_inputFilter=false,
    v_nominal=3,
    dp_nominal=5,
    l=0.02,
    dpFixed_nominal=100)
            "A damper with a mass flow proportional to the input signal"
    annotation (Placement(transformation(extent={{30,-170},{50,-150}})));
  Sources.Boundary_pT                 sou1(
    redeclare package Medium = Medium,
    p(displayUnit="Pa") = 101335,
    nPorts=1,
    use_p_in=true,
    T=293.15) "Pressure boundary condition"
     annotation (Placement(
        transformation(extent={{-60,-170},{-40,-150}})));
    Modelica.Blocks.Sources.Ramp pSouVar1(
    duration=0.3,
    startTime=0.2,
    offset=Medium.p_default,
    height=400)
    annotation (Placement(transformation(extent={{-100,-162},{-80,-142}})));
  Modelica.Blocks.Sources.Constant yCst01(k=0.1) annotation (Placement(transformation(extent={{-10,-150},{10,-130}})));
equation
  connect(res.port_b, sin.ports[1]) annotation (Line(points={{50,80},{68,80},{68,3.42857},{82,3.42857}},
                         color={0,127,255}));
  connect(preInd.port_b, sin.ports[2])
    annotation (Line(points={{50,0},{68,0},{68,2.28571},{82,2.28571}},
                                                           color={0,127,255}));
  connect(yRam.y, res.y)
    annotation (Line(points={{11,100},{40,100},{40,92}},color={0,0,127}));
  connect(yRam.y, preInd.y) annotation (Line(points={{11,100},{20,100},{20,20},
          {40,20},{40,12}}, color={0,0,127}));
  connect(yRam.y, preIndDpFixed_nominal.y) annotation (Line(points={{11,100},{
          20,100},{20,-20},{40,-20},{40,-28}},  color={0,0,127}));
  connect(pSouVar.y, souVar.p_in) annotation (Line(points={{-79,-84},{-62,-84}},
                                color={0,0,127}));
  connect(souVar.ports[1], preInd0.port_a)
    annotation (Line(points={{-40,-90},{-20,-90},{-20,-80},{30,-80}},
                                                 color={0,127,255}));
  connect(yCst0.y, preInd0.y)
    annotation (Line(points={{9,-60},{40,-60},{40,-68}},  color={0,0,127}));
  connect(preIndDpFixed_nominal.port_b, sin.ports[3]) annotation (Line(points={{50,-40},{68,-40},{68,1.14286},{82,
          1.14286}},                          color={0,127,255}));
  connect(preInd0.port_b, sin.ports[4]) annotation (Line(points={{50,-80},{68,-80},{68,1.11022e-16},{82,1.11022e-16}},
                                 color={0,127,255}));
  connect(yCst1.y, preInd1.y)
    annotation (Line(points={{9,-100},{40,-100},{40,-108}},  color={0,0,127}));
  connect(souVar.ports[2], preInd1.port_a) annotation (Line(points={{-40,-94},{-20,-94},{-20,-120},{30,-120}},
                                          color={0,127,255}));
  connect(preInd1.port_b, sin.ports[5]) annotation (Line(points={{50,-120},{68,-120},{68,-1.14286},{82,-1.14286}},
                                    color={0,127,255}));
  connect(yRam.y, resChaLin.y) annotation (Line(points={{11,100},{20,100},{20,60},
          {40,60},{40,52}},     color={0,0,127}));
  connect(resChaLin.port_b, sin.ports[6]) annotation (Line(points={{50,40},{68,40},{68,-2.28571},{82,-2.28571}},
                                            color={0,127,255}));
  connect(sou.ports[1], preIndDpFixed_nominal.port_a) annotation (Line(points={{-42,3},{-20,3},{-20,-40},{30,-40}},
                                               color={0,127,255}));
  connect(sou.ports[2], preInd.port_a) annotation (Line(points={{-42,1},{-20,1},{-20,0},{30,0}},
                           color={0,127,255}));
  connect(sou.ports[3], resChaLin.port_a) annotation (Line(points={{-42,-1},{-20,-1},{-20,40},{30,40}},
                                     color={0,127,255}));
  connect(sou.ports[4], res.port_a) annotation (Line(points={{-42,-3},{-20,-3},{-20,80},{30,80}},
                             color={0,127,255}));
  connect(preIndChar.port_b, sin.ports[7])
    annotation (Line(points={{50,-160},{68,-160},{68,-3.42857},{82,-3.42857}}, color={0,127,255}));
  connect(sou1.ports[1],preIndChar. port_a) annotation (Line(points={{-40,-160},{30,-160}}, color={0,127,255}));
  connect(sou1.p_in, pSouVar1.y) annotation (Line(points={{-62,-152},{-66,-152},{-70,-152},{-79,-152}},
                                                                                  color={0,0,127}));
  connect(yCst01.y, preIndChar.y) annotation (Line(points={{11,-140},{40,-140},{40,-148}}, color={0,0,127}));
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
April 19, 2019, by Antoine Gautier:<br/>
Updated the test cases for pressure independent dampers.
</li>
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
    Diagram(coordinateSystem(extent={{-120,-200},{120,120}})),
    Icon(coordinateSystem(extent={{-120,-200},{120,120}})));
end Damper;
