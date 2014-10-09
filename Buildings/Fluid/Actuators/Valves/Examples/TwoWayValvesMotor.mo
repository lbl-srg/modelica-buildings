within Buildings.Fluid.Actuators.Valves.Examples;
model TwoWayValvesMotor
    "Two way valves with different opening characteristics and motor"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.ConstantPropertyLiquidWater;

  Buildings.Fluid.Actuators.Valves.TwoWayLinear valLin(
    redeclare package Medium = Medium,
    l=0.05,
    m_flow_nominal=2,
    filteredOpening=false,
    dpValve_nominal=6000) "Valve model, linear opening characteristics"
         annotation (Placement(transformation(extent={{0,20},{20,40}}, rotation=
           0)));
  Buildings.Fluid.Sources.Boundary_pT sou(             redeclare package Medium
      = Medium,
    nPorts=3,
    use_p_in=true,
    T=293.15)                                       annotation (Placement(
        transformation(extent={{-60,-20},{-40,0}}, rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sin(             redeclare package Medium
      = Medium,
    nPorts=3,
    use_p_in=true,
    T=293.15)                                       annotation (Placement(
        transformation(extent={{70,-20},{50,0}}, rotation=0)));
    Modelica.Blocks.Sources.Constant PSin(k=3E5)
      annotation (Placement(transformation(extent={{60,60},{80,80}}, rotation=0)));
    Modelica.Blocks.Sources.Constant PSou(k=306000)
      annotation (Placement(transformation(extent={{-100,-12},{-80,8}},
          rotation=0)));
  Buildings.Fluid.Actuators.Valves.TwoWayQuickOpening valQui(
    redeclare package Medium = Medium,
    l=0.05,
    m_flow_nominal=2,
    filteredOpening=false,
    dpValve_nominal=6000) "Valve model, quick opening characteristics"
         annotation (Placement(transformation(extent={{0,-20},{20,0}}, rotation=
           0)));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valEqu(
    redeclare package Medium = Medium,
    l=0.05,
    R=10,
    delta0=0.1,
    m_flow_nominal=2,
    filteredOpening=false,
    dpValve_nominal=6000)
    "Valve model, equal percentage opening characteristics"
         annotation (Placement(transformation(extent={{0,-60},{20,-40}},
          rotation=0)));
  Modelica.Blocks.Sources.TimeTable ySet(table=[0,0; 60,0; 60,1; 120,1; 180,0.5;
        240,0.5; 300,0; 360,0; 360,0.25; 420,0.25; 480,1; 540,1.5; 600,-0.25])
    "Set point for actuator" annotation (Placement(transformation(extent={{-100,
            60},{-80,80}}, rotation=0)));
  Actuators.Motors.IdealMotor mot(                 tOpe=60) "Motor model"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}}, rotation=0)));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
equation
  connect(PSin.y, sin.p_in) annotation (Line(points={{81,70},{86,70},{86,-2},{
          72,-2}}, color={0,0,127}));
  connect(PSou.y, sou.p_in)
    annotation (Line(points={{-79,-2},{-62,-2},{-62,-2}},
                                                 color={0,0,127}));
  connect(ySet.y, mot.u)
    annotation (Line(points={{-79,70},{-62,70}}, color={0,0,127}));
  connect(mot.y, valEqu.y) annotation (Line(points={{-39,70},{-12,70},{-12,-30},
          {10,-30},{10,-38}},
                     color={0,0,127}));
  connect(mot.y, valQui.y) annotation (Line(points={{-39,70},{-12,70},{-12,10},
          {10,10},{10,2}},
                    color={0,0,127}));
  connect(mot.y, valLin.y) annotation (Line(points={{-39,70},{10,70},{10,44},{
          10,42}},  color={0,0,127}));
  connect(sou.ports[1], valLin.port_a) annotation (Line(
      points={{-40,-7.33333},{-20,-7.33333},{-20,30},{-5.55112e-16,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[2], valQui.port_a) annotation (Line(
      points={{-40,-10},{-5.55112e-16,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[3], valEqu.port_a) annotation (Line(
      points={{-40,-12.6667},{-20,-12.6667},{-20,-50},{-5.55112e-16,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valLin.port_b, sin.ports[1]) annotation (Line(
      points={{20,30},{36,30},{36,-7.33333},{50,-7.33333}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valQui.port_b, sin.ports[2]) annotation (Line(
      points={{20,-10},{50,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valEqu.port_b, sin.ports[3]) annotation (Line(
      points={{20,-50},{36,-50},{36,-12.6667},{50,-12.6667}},
      color={0,127,255},
      smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                        graphics),
experiment(StopTime=600),
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
set the valve parameter <code>filteredOpening=true</code> instead
of using the motor model.
</p>
</html>", revisions="<html>
<ul>
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
