within Buildings.Fluid.Sensors.Examples;
model TemperatureWetBulb "Test model for the wet bulb temperature sensor"
  extends Modelica.Icons.Example;
 package Medium = Buildings.Media.Air "Medium model"
           annotation (choicesAllMatching = true);
    Modelica.Blocks.Sources.Ramp p(
    duration=1,
    offset=101325,
    height=250) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium=Medium,
    use_p_in=true,
    nPorts=1,
    T=293.15) "Flow boundary condition"
      annotation (Placement(
        transformation(extent={{74,10},{54,30}})));
  Buildings.Fluid.Sensors.TemperatureWetBulbTwoPort senWetBul(
    redeclare package Medium=Medium,
    m_flow_nominal=1,
    tau=0) "Wet bulb temperature sensor"
    annotation (Placement(transformation(extent={{10,10},{30,30}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    m_flow=1,
    use_T_in=true,
    nPorts=1,
    use_Xi_in=true)
              "Flow boundary condition"  annotation (Placement(transformation(
          extent={{-30,10},{-10,30}})));
  Modelica.Blocks.Sources.Ramp TDryBul(
    height=10,
    offset=273.15 + 30,
    duration=50) "Dry bulb temperature"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Modelica.Blocks.Sources.Ramp XHum(
    height=(0.0133 - 0.0175),
    offset=0.0175,
    duration=50) "Humidity concentration"
                 annotation (Placement(transformation(extent={{-100,0},{-80,20}})));

equation
  connect(TDryBul.y, sou.T_in)          annotation (Line(points={{-79,50},{-60,50},
          {-60,24},{-32,24}}, color={0,0,127}));
  connect(p.y, sin.p_in) annotation (Line(points={{81,70},{92,70},{92,28},{76,
          28}}, color={0,0,127}));
  connect(sou.ports[1], senWetBul.port_a)          annotation (Line(
      points={{-10,20},{10,20}},
      color={0,127,255}));
  connect(senWetBul.port_b, sin.ports[1]) annotation (Line(
      points={{30,20},{54,20}},
      color={0,127,255}));
  connect(XHum.y, sou.Xi_in[1]) annotation (Line(points={{-79,10},{-56,10},{-56,
          16},{-32,16}}, color={0,0,127}));
    annotation (experiment(Tolerance=1e-6, StopTime=120),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Sensors/Examples/TemperatureWetBulb.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example tests the wet bulb temperature sensor.
The problem setup is such that the moisture concentration and
the dry bulb temperature are varied simultaneously in such a way
that the wet bulb temperature remains close to a constant value.
</p>
</html>", revisions="<html>
<ul>
<li>
June 4, 2011 by Michael Wetter:<br/>
Adjusted parameters and simulation stop time since the sensor was changed to a dynamic sensor.
</li>
<li>
May 6, 2008 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end TemperatureWetBulb;
