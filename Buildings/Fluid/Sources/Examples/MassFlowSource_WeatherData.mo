within Buildings.Fluid.Sources.Examples;
model MassFlowSource_WeatherData
  "Test model for source (sink) with weather bus"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air "Medium model for air";

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Fluid.Sources.MassFlowSource_WeatherData sin_with_h(
    redeclare package Medium = Medium,
    m_flow=-1,
    nPorts=1) "Mass flow source model receiving h and X from weather data through
     weather bus"
    annotation (Placement(transformation(extent={{96,-10},{76,10}})));
  Buildings.Fluid.Sources.Outside bou(redeclare package Medium = Medium, nPorts=1)
    "Model with outside conditions"
    annotation (Placement(transformation(extent={{-64,-10},{-44,10}})));
  Buildings.Fluid.Sensors.RelativeHumidityTwoPort senRelHum(redeclare package
      Medium = Medium, m_flow_nominal=1,
    tau=0)                               "Sensor for relative humidity"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Buildings.Fluid.Sensors.MassFractionTwoPort senMasFra(redeclare package Medium =
        Medium, m_flow_nominal=1,
    tau=0)                        "Sensor for mass fraction of water"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Sensors.TemperatureTwoPort senTem(redeclare package Medium = Medium,
      m_flow_nominal=1,
    tau=0)              "Temperature sensor"
    annotation (Placement(transformation(extent={{44,-10},{64,10}})));
equation
  connect(bou.ports[1], senRelHum.port_a)
    annotation (Line(points={{-44,0},{-37,0},{-30,0}}, color={0,127,255}));
  connect(senRelHum.port_b, senMasFra.port_a)
    annotation (Line(points={{-10,0},{0,0},{10,0}}, color={0,127,255}));
  connect(senMasFra.port_b, senTem.port_a)
    annotation (Line(points={{30,0},{34,0},{44,0}}, color={0,127,255}));
  connect(senTem.port_b, sin_with_h.ports[1])
    annotation (Line(points={{64,0},{70,0},{76,0}}, color={0,127,255}));
  connect(weaDat.weaBus, bou.weaBus) annotation (Line(
      points={{-80,0},{-72,0},{-72,0.2},{-64,0.2}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, sin_with_h.weaBus) annotation (Line(
      points={{-80,0},{-72,0},{-72,40},{96,40},{96,0.2}},
      color={255,204,51},
      thickness=0.5));
  annotation (
experiment(Tolerance=1e-6, StopTime=3.1536e+07),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Sources/Examples/MassFlowSource_WeatherData.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model demonstrates how to connect fluid flow components to a
boundary condition that has environmental conditions as
obtained from a weather file.
The model draws a constant mass flow rate of outside air through
its components.
</p>
</html>", revisions="<html>
<ul>
<li>
May 21, 2017 by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end MassFlowSource_WeatherData;
