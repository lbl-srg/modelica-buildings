within Buildings.Fluid.Sensors.Examples;
model RelativeHumidity "Test model for relative humidity sensor"
  import Buildings;

 package Medium = Buildings.Media.PerfectGases.MoistAir "Medium model"
           annotation (choicesAllMatching = true);

  Buildings.Fluid.Sources.Boundary_pT sin(             redeclare package Medium
      = Medium,
    use_p_in=false,
    T=293.15,
    nPorts=1)                                       annotation (Placement(
        transformation(extent={{100,10},{80,30}},rotation=0)));
  Buildings.Fluid.Sources.MassFlowSource_T massFlowRate(            redeclare
      package Medium = Medium, m_flow=1,
    use_T_in=true,
    use_X_in=true,
    nPorts=2,
    use_m_flow_in=true)                  annotation (Placement(transformation(
          extent={{-30,10},{-10,30}}, rotation=0)));
    Modelica.Blocks.Sources.Ramp TDryBul(
    height=10,
    duration=1,
    offset=273.15 + 30) "Dry bulb temperature"
                 annotation (Placement(transformation(extent={{-100,14},{-80,34}},
          rotation=0)));
    Modelica.Blocks.Sources.Ramp XHum(
    duration=1,
    height=(0.0133 - 0.0175),
    offset=0.0175) "Humidity concentration"
                 annotation (Placement(transformation(extent={{-100,-60},{-80,
            -40}}, rotation=0)));
  Modelica.Blocks.Sources.Constant const(k=1)
                                         annotation (Placement(transformation(
          extent={{-100,-20},{-80,0}}, rotation=0)));
  Modelica.Blocks.Math.Feedback feedback annotation (Placement(transformation(
          extent={{-68,-20},{-48,0}}, rotation=0)));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM dp(
    redeclare package Medium = Medium,
    m_flow_nominal=10,
    dp_nominal=200)
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Buildings.Fluid.Sensors.RelativeHumidity senRelHum(redeclare package Medium
      = Medium) annotation (Placement(transformation(extent={{-16,42},{4,62}})));
    Modelica.Blocks.Sources.Ramp m_flow(
    duration=1,
    height=-2,
    offset=1) "Mass flow rate"
                 annotation (Placement(transformation(extent={{-80,40},{-60,60}},
          rotation=0)));
  Buildings.Fluid.Sensors.RelativeHumidityTwoPort relHum(redeclare package
      Medium = Medium, m_flow_nominal=1)
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
equation
  connect(TDryBul.y, massFlowRate.T_in) annotation (Line(points={{-79,24},{-60,24},
          {-32,24}},          color={0,0,127}));
  connect(const.y, feedback.u1) annotation (Line(points={{-79,-10},{-66,-10}},
        color={0,0,127}));
  connect(XHum.y, feedback.u2) annotation (Line(points={{-79,-50},{-58,-50},{
          -58,-18}}, color={0,0,127}));
  connect(XHum.y, massFlowRate.X_in[1]) annotation (Line(points={{-79,-50},{-40,
          -50},{-40,16},{-32,16}},       color={0,0,127}));
  connect(feedback.y, massFlowRate.X_in[2]) annotation (Line(points={{-49,-10},
          {-44,-10},{-44,16},{-32,16}},       color={0,0,127}));
  connect(dp.port_a, massFlowRate.ports[1]) annotation (Line(
      points={{-5.55112e-16,20},{-5,20},{-5,22},{-10,22}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(m_flow.y, massFlowRate.m_flow_in) annotation (Line(
      points={{-59,50},{-46,50},{-46,28},{-30,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dp.port_b, relHum.port_a) annotation (Line(
      points={{20,20},{40,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(relHum.port_b, sin.ports[1]) annotation (Line(
      points={{60,20},{80,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(massFlowRate.ports[2], senRelHum.port) annotation (Line(
      points={{-10,18},{-6,18},{-6,42}},
      color={0,127,255},
      smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}}),
                        graphics),
                         Commands(file=
            "RelativeHumidity.mos" "run"),
    Documentation(info="<html>
This examples is a unit test for the relative humidity sensor.
</html>", revisions="<html>
<ul>
<li>
May 12, 2010 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end RelativeHumidity;
