within Buildings.Airflow.Multizone.Examples;
model CO2TransportStep "Model that transport CO2 through buoyancy driven flow"
  extends Buildings.Airflow.Multizone.Examples.Validation3Rooms(
    Medium(extraPropertiesNames={"CO2"}),
    volWes(nPorts=5),
    volTop(nPorts=3),
    volEas(nPorts=6));

  Fluid.Sensors.TraceSubstances CO2SenTop(redeclare package Medium = Medium)
    "CO2 sensor"
    annotation (Placement(transformation(extent={{20,120},{40,140}})));
  Fluid.Sensors.TraceSubstances CO2SenWes(redeclare package Medium = Medium)
    "CO2 sensor"
    annotation (Placement(transformation(extent={{-102,10},{-82,30}})));
  Fluid.Sensors.TraceSubstances CO2SenEas(redeclare package Medium = Medium)
    "CO2 sensor"
    annotation (Placement(transformation(extent={{58,10},{78,30}})));
  Modelica.Blocks.Sources.Pulse pulse(
    amplitude=8.18E-6,
    width=1/24/10,
    period=86400,
    startTime=3600)
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));
  Fluid.Sources.TraceSubstancesFlowSource sou(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1) "CO2 source"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
equation

  connect(sou.m_flow_in, pulse.y)                             annotation (Line(
      points={{-102.1,-70},{-119,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou.ports[1], volWes.ports[4])
    annotation (Line(
      points={{-80,-70},{-74,-70},{-74,-38},{-90,-38},{-90,-30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(CO2SenWes.port, volWes.ports[5]) annotation (Line(
      points={{-92,10},{-92,0},{-72,0},{-72,-34},{-90,-34},{-90,-30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(CO2SenTop.port, volTop.ports[3]) annotation (Line(
      points={{30,120},{30,108},{-10,108},{-10,120}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(CO2SenEas.port, volEas.ports[6]) annotation (Line(
      points={{68,10},{68,-30},{90,-30},{90,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-200,-150},{300,
            250}})),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Airflow/Multizone/Examples/CO2TransportStep.mos"
        "Simulate and plot"),
    experiment(
      StopTime=86400,
      Tolerance=1e-05),
    Documentation(info="<html>
<p>
This model is based on
<a href=\"modelica://Buildings.Airflow.Multizone.Examples.Validation3Rooms\">
Buildings.Airflow.Multizone.Examples.Validation3Rooms</a>.
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
November 10, 2011, by Michael Wetter:<br/>
Extended model from 
<a href=\"modelica://Buildings.Airflow.Multizone.Examples.Validation3Rooms\">
Buildings.Airflow.Multizone.Examples.Validation3Rooms</a>
and added documentation.
</li>
</ul>
</html>"));
end CO2TransportStep;
