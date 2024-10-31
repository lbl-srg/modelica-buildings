within Buildings.Airflow.Multizone.Examples;
model CO2TransportStep "Model with transport of CO2 through buoyancy driven flow"
  extends Buildings.Airflow.Multizone.Validation.ThreeRoomsContam(
    volWes(nPorts=5),
    volTop(nPorts=3),
    volEas(nPorts=6));

  Buildings.Fluid.Sensors.TraceSubstances CO2SenTop(
    redeclare package Medium = Medium,
    warnAboutOnePortConnection = false)
    "CO2 sensor"
    annotation (Placement(transformation(extent={{20,120},{40,140}})));
  Buildings.Fluid.Sensors.TraceSubstances CO2SenWes(
    redeclare package Medium = Medium,
    warnAboutOnePortConnection = false)
    "CO2 sensor"
    annotation (Placement(transformation(extent={{-102,10},{-82,30}})));
  Buildings.Fluid.Sensors.TraceSubstances CO2SenEas(
    redeclare package Medium = Medium,
    warnAboutOnePortConnection = false)
    "CO2 sensor"
    annotation (Placement(transformation(extent={{58,10},{78,30}})));
  Modelica.Blocks.Sources.Pulse pulse(
    amplitude=8.18E-6,
    width=1/24/10,
    period=86400,
    startTime=3600) "Pulse signal for CO2 flow source"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));
  Buildings.Fluid.Sources.TraceSubstancesFlowSource sou(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1) "CO2 source"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
equation
  connect(sou.m_flow_in, pulse.y) annotation (Line(
      points={{-102.1,-70},{-119,-70}},
      color={0,0,127}));
  connect(sou.ports[1], volWes.ports[4])
    annotation (Line(
      points={{-80,-70},{-74,-70},{-74,-38},{-80,-38},{-80,-30}},
      color={0,127,255}));
  connect(CO2SenWes.port, volWes.ports[5]) annotation (Line(
      points={{-92,10},{-92,0},{-72,0},{-72,-34},{-80,-34},{-80,-30}},
      color={0,127,255}));
  connect(CO2SenTop.port, volTop.ports[3]) annotation (Line(
      points={{30,120},{30,108},{-10,108},{-10,120}},
      color={0,127,255}));
  connect(CO2SenEas.port, volEas.ports[6]) annotation (Line(
      points={{68,10},{68,-30},{90,-30},{90,-20}},
      color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-200,-150},{300,
            250}})),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Airflow/Multizone/Examples/CO2TransportStep.mos"
        "Simulate and plot"),
    experiment(
      StopTime=86400,
      Tolerance=1e-6),
    Documentation(info="<html>
<p>
This model is based on
<a href=\"modelica://Buildings.Airflow.Multizone.Validation.ThreeRoomsContam\">
Buildings.Airflow.Multizone.Validation.ThreeRoomsContam</a>.
In addition, a CO<sub>2</sub> source has been added to the left room
in the bottom floor.
At initial time, all volumes have zero CO<sub>2</sub> concentration.
At <i>t=3600</i> seconds, CO<sub>2</sub> is added to <code>volWes</code>.
As time progresses, the CO<sub>2</sub> is transported to
the other rooms, and eventually its concentration decays.
</p>
</html>", revisions="<html>
<ul>
<li>
March 26, 2024, by Michael Wetter:<br/>
Configured the sensor parameter to suppress the warning about being a one-port connection.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1857\">IBPSA, #1857</a>.
</li>
<li>
March 26, 2021 by Michael Wetter:<br/>
Updated comments for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/515\">IBPSA, #515</a>.
</li>
<li>
November 10, 2011, by Michael Wetter:<br/>
Extended model from
<a href=\"modelica://Buildings.Airflow.Multizone.Validation.ThreeRoomsContam\">
Buildings.Airflow.Multizone.Validation.ThreeRoomsContam</a>
and added documentation.
</li>
</ul>
</html>"));
end CO2TransportStep;
