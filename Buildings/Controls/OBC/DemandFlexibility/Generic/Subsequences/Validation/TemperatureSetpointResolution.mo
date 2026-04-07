within Buildings.Controls.OBC.DemandFlexibility.Generic.Subsequences.Validation;
model TemperatureSetpointResolution
  "Temperature setpoint resolution"
  extends Modelica.Icons.Example;
  Buildings.Controls.OBC.DemandFlexibility.Generic.Subsequences.TemperatureSetpointResolution
    temperatureSetpointResolution "Temperature setpoint resolution block"
    annotation (Placement(transformation(extent={{-22,-12},{2,8}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin                        sin(
    final freqHz=1/43200,
    final amplitude=6,
    phase=3.1415926535898,
    final offset=273.15 + 20) "Sine wave"
    annotation (Placement(transformation(extent={{-76,-12},{-56,8}})));
equation
  connect(sin.y, temperatureSetpointResolution.uTSet)
  annotation (Line(points={{-54,-2},{-23.92,-2}}, color={0,0,127}));
   annotation (experiment(
      StopTime=172800,
      Interval=60,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"), Documentation(info="<html>
<p>This example validates <a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.Generic.Subsequences.TemperatureSetpointResolution\">
Buildings.Controls.OBC.DemandFlexibility.Generic.Subsequences.TemperatureSetpointResolution</a> by
providing a varying real number input through a sine wave.</p>
</html>",
        revisions="<html>
<ul>
<li>
April 03, 2026, by Weiping Huang:<br/>
First implementation.
</li>

</ul>
</html>"));
end TemperatureSetpointResolution;
