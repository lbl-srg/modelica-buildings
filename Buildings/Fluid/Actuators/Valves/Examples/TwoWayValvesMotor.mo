within Buildings.Fluid.Actuators.Valves.Examples;
model TwoWayValvesMotor
  "Two way valves with different opening characteristics and motor"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water;

  Buildings.Fluid.Actuators.Valves.TwoWayLinear valLin(
    redeclare package Medium = Medium,
    l=0.05,
    m_flow_nominal=2,
    use_inputFilter=false,
    dpValve_nominal=6000) "Valve model, linear opening characteristics"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Buildings.Fluid.Sources.Boundary_pT sou(             redeclare package Medium =
        Medium,
    nPorts=4,
    use_p_in=true,
    T=293.15) "Boundary condition for flow source"  annotation (Placement(
        transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin(             redeclare package Medium =
        Medium,
    nPorts=4,
    use_p_in=true,
    T=293.15) "Boundary condition for flow sink"    annotation (Placement(
        transformation(extent={{70,-10},{50,10}})));
    Modelica.Blocks.Sources.Constant PSin(k=3E5)
      annotation (Placement(transformation(extent={{60,60},{80,80}})));
    Modelica.Blocks.Sources.Constant PSou(k=306000)
      annotation (Placement(transformation(extent={{-100,-2},{-80,18}})));
  Buildings.Fluid.Actuators.Valves.TwoWayQuickOpening valQui(
    redeclare package Medium = Medium,
    l=0.05,
    m_flow_nominal=2,
    use_inputFilter=false,
    dpValve_nominal=6000) "Valve model, quick opening characteristics"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valEqu(
    redeclare package Medium = Medium,
    l=0.05,
    R=10,
    delta0=0.1,
    m_flow_nominal=2,
    use_inputFilter=false,
    dpValve_nominal=6000)
    "Valve model, equal percentage opening characteristics"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Modelica.Blocks.Sources.TimeTable ySet(table=[0,0; 60,0; 60,1; 120,1; 180,0.5;
        240,0.5; 300,0; 360,0; 360,0.25; 420,0.25; 480,1; 540,1.5; 600,-0.25])
    "Set point for actuator" annotation (Placement(transformation(extent={{-100,
            60},{-80,80}})));
  Actuators.Motors.IdealMotor mot(                 tOpe=60) "Motor model"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));

  TwoWayPressureIndependent valInd(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    dpValve_nominal=10000,
    use_strokeTime=false,
    l=0.05,
    l2=0.01) annotation (Placement(transformation(extent={{0,-64},{20,-44}})));
equation
  connect(PSin.y, sin.p_in) annotation (Line(points={{81,70},{86,70},{86,8},{72,
          8}},     color={0,0,127}));
  connect(PSou.y, sou.p_in)
    annotation (Line(points={{-79,8},{-79,8},{-62,8}},
                                                 color={0,0,127}));
  connect(ySet.y, mot.u)
    annotation (Line(points={{-79,70},{-62,70}}, color={0,0,127}));
  connect(mot.y, valEqu.y) annotation (Line(points={{-39,70},{-12,70},{-12,0},{
          10,0},{10,-8}},
                     color={0,0,127}));
  connect(mot.y, valQui.y) annotation (Line(points={{-39,70},{-12,70},{-12,40},
          {10,40},{10,32}},
                    color={0,0,127}));
  connect(mot.y, valLin.y) annotation (Line(points={{-39,70},{10,70},{10,74},{
          10,72}},  color={0,0,127}));
  connect(sou.ports[1], valLin.port_a) annotation (Line(
      points={{-40,3},{-22,3},{-22,60},{0,60}},
      color={0,127,255}));
  connect(sou.ports[2], valQui.port_a) annotation (Line(
      points={{-40,1},{-20,1},{-20,20},{0,20}},
      color={0,127,255}));
  connect(sou.ports[3], valEqu.port_a) annotation (Line(
      points={{-40,-1},{-20,-1},{-20,-20},{0,-20}},
      color={0,127,255}));
  connect(valLin.port_b, sin.ports[1]) annotation (Line(
      points={{20,60},{40,60},{40,3},{50,3}},
      color={0,127,255}));
  connect(valQui.port_b, sin.ports[2]) annotation (Line(
      points={{20,20},{38,20},{38,1},{50,1}},
      color={0,127,255}));
  connect(valEqu.port_b, sin.ports[3]) annotation (Line(
      points={{20,-20},{38,-20},{38,-1},{50,-1}},
      color={0,127,255}));
  connect(valInd.port_a, sou.ports[4]) annotation (Line(
      points={{0,-54},{-22,-54},{-22,-3},{-40,-3}},
      color={0,127,255}));
  connect(valInd.port_b, sin.ports[4]) annotation (Line(
      points={{20,-54},{40,-54},{40,-2.6667},{50,-2.6667},{50,-3}},
      color={0,127,255}));
  connect(valInd.y, valEqu.y) annotation (Line(
      points={{10,-42},{10,-36},{-12,-36},{-12,0},{10,0},{10,-8}},
      color={0,0,127}));
    annotation (experiment(Tolerance=1e-6, StartTime=0, StopTime=600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Actuators/Valves/Examples/TwoWayValvesMotor.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Test model for two way valves. Note that the
leakage flow rate has been set to a large value
and the rangeability to a small value
for better visualization of the valve characteristics.
To use common values, use the default values.
</p>
<p>
All valves are connected to a model of a motor with
hysteresis. A more efficient implementation that approximates
a motor but lacks hysteresis would be to
set the valve parameter <code>use_inputFilter=true</code> instead
of using the motor model.
</p>
</html>", revisions="<html>
<ul>
<li>
January 29, 2015, by Filip Jorissen:<br/>
Added pressure-independent valve.
</li>
<li>
February 28, 2013, by Michael Wetter:<br/>
Added default value for <code>dpValve_nominal</code>.
</li>
<li>
June 16, 2008 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end TwoWayValvesMotor;
