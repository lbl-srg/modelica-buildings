within Buildings.Fluid.HeatExchangers.ThermalWheels.Latent.BaseClasses.Validation;
model HeatExchangerWithInputEffectiveness
  "Test model for the heat exchanger with input effectiveness"
  extends Modelica.Icons.Example;
  package Medium1 = Buildings.Media.Air
     "Supply air";
  package Medium2 = Buildings.Media.Air
     "Exhaust air";

  Buildings.Fluid.Sources.Boundary_pT sin_2(
    redeclare package Medium = Medium2,
    p(displayUnit="Pa")=101325,
    T=273.15+10,
    nPorts=1)
    "Ambient"
    annotation (Placement(transformation(extent={{-82,-90},{-62,-70}})));
  Buildings.Fluid.Sources.Boundary_pT sou_2(
    redeclare package Medium = Medium2,
    p(displayUnit="Pa")=101325+100,
    nPorts=1)
    "Exhaust air source"
    annotation (Placement(transformation(extent={{98,-50},{78,-30}})));
  Modelica.Blocks.Sources.Ramp TSup(
    height=10,
    duration=60,
    offset=273.15+30,
    startTime=120)
    "Supply air temperature"
    annotation (Placement(transformation(extent={{-80,54},{-60,74}})));
  Buildings.Fluid.Sources.Boundary_pT sin_1(
    redeclare package Medium = Medium1,
    T(displayUnit="K")=273.15+30,
    X={0.012,1 - 0.012},
    p(displayUnit="Pa")=1E5-110,
    nPorts=1)
    "Supply air sink"
    annotation (Placement(transformation(extent={{80,50},{60,70}})));
  Buildings.Fluid.Sources.Boundary_pT sou_1(
    redeclare package Medium = Medium1,
    T=273.15 + 50,
    X={0.012,1 - 0.012},
    use_T_in=true,
    p(displayUnit="Pa")=100000,
    nPorts=1)
    "Supply air source"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Fluid.HeatExchangers.ThermalWheels.Latent.BaseClasses.HeatExchangerWithInputEffectiveness hex(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    m1_flow_nominal=5,
    m2_flow_nominal=5,
    dp1_nominal=100,
    dp2_nominal=100)
    "Heat exchanger"
    annotation (Placement(transformation(extent={{6,-4},{26,16}})));
  Modelica.Blocks.Sources.Ramp epsSen(
    height=0.1,
    duration=60,
    offset=0.7,
    startTime=120)
    "Sensible heat exchanger effectiveness"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Modelica.Blocks.Sources.Ramp epsLat(
    height=0.4,
    duration=60,
    offset=0.4,
    startTime=180)
    "Latent heat exchanger effectiveness"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senExhTemOut(
    redeclare package Medium = Medium2,
    m_flow_nominal=5)
    "Temperature sensor for exhuast air outlet"
    annotation (Placement(transformation(extent={{-42,-86},{-54,-74}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senExhTemIn(
    redeclare package Medium = Medium2,
    m_flow_nominal=5)
    "Temperature sensor for exhuast air inlet"
    annotation (Placement(transformation(extent={{46,-6},{34,6}})));
  Buildings.Fluid.Sensors.RelativeHumidityTwoPort senExhRelHumIn(
     redeclare package Medium = Medium2,
     m_flow_nominal=5)
    "Humidity sensor for exhuast air inlet"
    annotation (Placement(transformation(extent={{70,-10},{50,10}})));
  Buildings.Fluid.Sensors.RelativeHumidityTwoPort senExhRelHumOut(
     redeclare package Medium = Medium2,
     m_flow_nominal=5)
    "Humidity sensor for exhuast air outlet"
    annotation (Placement(transformation(extent={{-10,-60},{-30,-40}})));
equation
  connect(TSup.y, sou_1.T_in)
    annotation (Line(points={{-59,64},{-42,64}}, color={0,0,127}));
  connect(sou_1.ports[1], hex.port_a1)
    annotation (Line(points={{-20,60},{-10,60},{-10,12},{6,12}}, color={0,127,255}));
  connect(hex.port_b1, sin_1.ports[1])
    annotation (Line(points={{26,12},{40,12},{40,60},{60,60}}, color={0,127,255}));
  connect(epsSen.y, hex.epsSen)
    annotation (Line(points={{-59,20},{-20,20},{-20,9},{4,9}},   color={0,0,127}));
  connect(hex.epsLat, epsLat.y)
    annotation (Line(points={{4,3},{-50,3},{-50,-40},{-59,-40}}, color={0,0,127}));
  connect(senExhTemOut.port_b, sin_2.ports[1])
    annotation (Line(points={{-54,-80},{-62,-80}}, color={0,127,255}));
  connect(hex.port_a2, senExhTemIn.port_b)
    annotation (Line(points={{26,0},{34,0}}, color={0,127,255}));
  connect(senExhRelHumIn.port_a, sou_2.ports[1]) annotation (Line(points={{70,0},
          {76,0},{76,-40},{78,-40}}, color={0,127,255}));
  connect(senExhRelHumIn.port_b, senExhTemIn.port_a)
    annotation (Line(points={{50,0},{46,0}}, color={0,127,255}));
  connect(hex.port_b2, senExhRelHumOut.port_a) annotation (Line(points={{6,0},{0,
          0},{0,-50},{-10,-50}}, color={0,127,255}));
  connect(senExhTemOut.port_a, senExhRelHumOut.port_b) annotation (Line(points={
          {-42,-80},{-36,-80},{-36,-50},{-30,-50}}, color={0,127,255}));
annotation(experiment(Tolerance=1e-6, StopTime=360),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/ThermalWheels/Latent/BaseClasses/Validation/HeatExchangerWithInputEffectiveness.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ThermalWheels.Latent.BaseClasses.HeatExchangerWithInputEffectiveness\">
Buildings.Fluid.HeatExchangers.ThermalWheels.Latent.BaseClasses.HeatExchangerWithInputEffectiveness</a>.
</p>
<p>
The input signals are configured as follows:
</p>
<ul>
<li>
The supply air temperature <i>TSup</i> changes from <i>273.15 + 30 K</i> to
<i>273.15 + 40 K</i> during the period from 120 seconds to 180 seconds.
</li>
<li>
The sensible heat exchanger effectiveness <i>epsSen</i> changes from <i>0.7</i>
to <i>0.8</i> during the period from 120 seconds to 180 seconds.
</li>
<li>
The latent heat exchanger effectiveness <i>epsLat</i> changes from <i>0.4</i>
to <i>0.8</i> during the period from 180 seconds to 240 seconds.
</li>
</ul>
<p>
The expected outputs are:
</p>
<ul>
<li>
During the period from 60 seconds to 120 seconds, the difference between the entering exhaust air humidity
and the leaving exhaust air humidity increases.
This difference then decreases during the period from 180 seconds to 240 seconds.
</li>
<li>
During the period from 120 seconds to 180 seconds, the difference between the entering exhaust air temperature
and the leaving exhaust air temperature increases.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
September 29, 2023, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end HeatExchangerWithInputEffectiveness;
