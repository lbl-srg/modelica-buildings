within Buildings.Examples.Tutorial.SimpleHouse;
model SimpleHouse5 "Heating controller model"
  extends SimpleHouse4(final use_constantHeater=false);

  Modelica.Blocks.Math.BooleanToReal booRea1(realTrue=mWat_flow_nominal)
    "Boolean to integer"
    annotation (Placement(transformation(extent={{0,-160},{20,-140}})));
  Modelica.Blocks.Math.BooleanToReal booRea "Boolean to real"
    annotation (Placement(transformation(extent={{0,-120},{20,-100}})));
  Modelica.Blocks.Logical.Hysteresis hysRad(uLow=273.15 + 21, uHigh=273.15 + 23)
    "Hysteresis controller for radiator"
    annotation (Placement(transformation(extent={{-80,-120},{-60,-100}})));
  Modelica.Blocks.Logical.Not not1
    "Negation for enabling heating when temperature is low"
    annotation (Placement(transformation(extent={{-40,-120},{-20,-100}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTemZonAir
    "Zone air temperature sensor"
    annotation (Placement(transformation(extent={{90,160},{70,180}})));
equation
  connect(booRea1.u, not1.y) annotation (Line(points={{-2,-150},{-11.5,-150},{-11.5,
          -110},{-19,-110}}, color={255,0,255}));
  connect(not1.u,hysRad. y) annotation (Line(points={{-42,-110},{-59,-110}},
                  color={255,0,255}));
  connect(senTemZonAir.T,hysRad. u) annotation (Line(points={{69,170},{-210,170},
          {-210,-110},{-82,-110}},            color={0,0,127}));
  connect(senTemZonAir.port, zon.heatPort)
    annotation (Line(points={{90,170},{160,170},{160,40}},  color={191,0,0}));
  connect(not1.y, booRea.u)
    annotation (Line(points={{-19,-110},{-2,-110}}, color={255,0,255}));
  connect(booRea.y, heaWat.u) annotation (Line(points={{21,-110},{40,-110},{40,-124},
          {58,-124}}, color={0,0,127}));
  connect(booRea1.y, pum.m_flow_in) annotation (Line(points={{21,-150},{100,-150},
          {100,-168}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,
            -220},{220,220}})),
    experiment(Tolerance=1e-6, StopTime=1e+06),
    Documentation(revisions="<html>
<ul>
<li>
September 4, 2023, by Jelger Jansen:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Since the zone becomes too warm, a controller is required that disables the heater when a setpoint is reached.
We will implement a hysteresis controller with a setpoint of <i>295.15 +/- 1K</i> (<i>21-23°C</i>).
A temperature sensor will measure the zone air temperature.
</p>
<h4>Required models</h4>
<ul>
<li>
<a href=\"modelica://Modelica.Blocks.Logical.Hysteresis\">
Modelica.Blocks.Logical.Hysteresis</a>
</li>
<li>
<a href=\"modelica://Modelica.Blocks.Logical.Not\">
Modelica.Blocks.Logical.Not</a>
</li>
<li>
<a href=\"modelica://Modelica.Blocks.Math.BooleanToReal\">
Modelica.Blocks.Math.BooleanToReal</a>
</li>
<li>
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor\">
Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor</a>
</li>
</ul>
<h4>Connection instructions</h4>
<p>
The heater modulation level should be set to <i>1</i> when the heater is on and to <i>0</i> otherwise.
Furthermore, the pump should only circulate water when the heater is on.
</p>
<h4>Reference result</h4>
<p>
The figure below shows the air temperature after the controller is added.
</p>
<p align=\"center\">
<img alt=\"Air temperature as function of time.\"
src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/SimpleHouse/result5.png\" width=\"1000\"/>
</p>
</html>"),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Examples/Tutorial/SimpleHouse/SimpleHouse5.mos"
        "Simulate and plot"));
end SimpleHouse5;
