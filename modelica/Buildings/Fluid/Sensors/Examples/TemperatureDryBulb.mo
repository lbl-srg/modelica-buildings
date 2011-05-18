within Buildings.Fluid.Sensors.Examples;
model TemperatureDryBulb
  extends Modelica.Icons.Example;

// package Medium =  annotation 1;
 package Medium = Buildings.Media.PerfectGases.MoistAir "Medium model";
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=1,
    T=293.15)                                       annotation (Placement(
        transformation(extent={{90,-2},{70,18}}, rotation=0)));
  Buildings.Fluid.Sources.MassFlowSource_T masFloRat(
    redeclare package Medium = Medium,
    use_T_in=true,
    use_m_flow_in=true,
    nPorts=1)                            annotation (Placement(transformation(
          extent={{-36,-2},{-16,18}}, rotation=0)));
    Modelica.Blocks.Sources.Ramp TDryBul(
    height=10,
    duration=1,
    offset=273.15 + 30) "Dry bulb temperature"
                 annotation (Placement(transformation(extent={{-100,20},{-80,40}},
          rotation=0)));
    Modelica.Blocks.Sources.Ramp XHum(
    height=(0.0133 - 0.0175),
    offset=0.0175,
    duration=60) "Humidity concentration"
                 annotation (Placement(transformation(extent={{-100,-60},{-80,
            -40}}, rotation=0)));
  Modelica.Blocks.Sources.Constant const annotation (Placement(transformation(
          extent={{-100,-20},{-80,0}}, rotation=0)));
  Modelica.Blocks.Math.Feedback feedback annotation (Placement(transformation(
          extent={{-70,-20},{-50,0}}, rotation=0)));
  Buildings.Utilities.Diagnostics.AssertEquality assertEquality(
      threShold=0.001, startTime=0)
    annotation (Placement(transformation(extent={{60,60},{80,80}},   rotation=0)));
  Modelica.Blocks.Continuous.FirstOrder firOrd(T=10,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=293.15)
    annotation (Placement(transformation(extent={{0,60},{20,80}},    rotation=0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort temSteSta(
                                               redeclare package Medium =
        Medium, m_flow_nominal=2) "Steady state temperature sensor"
    annotation (Placement(transformation(extent={{0,-2},{20,18}}, rotation=0)));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
    Modelica.Blocks.Sources.Pulse m_flow(
    offset=-1,
    amplitude=2,
    period=30) "Mass flow rate"
                 annotation (Placement(transformation(extent={{-100,60},{-80,80}},
          rotation=0)));
  Buildings.Fluid.Sensors.TemperatureDynamicTwoPort temDyn(
    redeclare package Medium = Medium,
    initType=Modelica.Blocks.Types.Init.InitialState,
    T_start=293.15,
    m_flow_nominal=2)
    annotation (Placement(transformation(extent={{30,-2},{50,18}})));
equation
  connect(TDryBul.y, masFloRat.T_in)    annotation (Line(points={{-79,30},{-60,30},
          {-60,12},{-38,12}}, color={0,0,127}));
  connect(const.y, feedback.u1) annotation (Line(points={{-79,-10},{-68,-10}},
        color={0,0,127}));
  connect(XHum.y, feedback.u2) annotation (Line(points={{-79,-50},{-60,-50},{
          -60,-18}}, color={0,0,127}));
  connect(XHum.y, masFloRat.X_in[1])    annotation (Line(points={{-79,-50},{-40,
          -50},{-40,4},{-38,4}},         color={0,0,127}));
  connect(feedback.y, masFloRat.X_in[2])    annotation (Line(points={{-51,-10},
          {-44,-10},{-44,4},{-38,4}},         color={0,0,127}));
  connect(temSteSta.T, firOrd.u) annotation (Line(points={{10,19},{10,40},{-20,
          40},{-20,70},{-2,70}},   color={0,0,127}));
  connect(masFloRat.ports[1], temSteSta.port_a) annotation (Line(
      points={{-16,8},{-5.55112e-16,8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(firOrd.y, assertEquality.u1) annotation (Line(
      points={{21,70},{44,70},{44,76},{58,76}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flow.y, masFloRat.m_flow_in) annotation (Line(
      points={{-79,70},{-58,70},{-58,16},{-36,16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSteSta.port_b, temDyn.port_a) annotation (Line(
      points={{20,8},{30,8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(temDyn.port_b, sin.ports[1]) annotation (Line(
      points={{50,8},{70,8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(temDyn.T, assertEquality.u2) annotation (Line(
      points={{40,19},{40,64},{58,64}},
      color={0,0,127},
      smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}}),
                        graphics),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Sensors/Examples/TemperatureDryBulb.mos" "Simulate and plot"),
    Documentation(info="<html>
This examples is a unit test for the dynamic dry bulb temperature sensor.
</html>", revisions="<html>
<ul>
<li>
September 10, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end TemperatureDryBulb;
