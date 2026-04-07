within Buildings.Controls.OBC.DemandFlexibility.Generic.Subsequences.Validation;
model SingleTemperatureSetpointBAS "Single temperature setpoint in a BAS"
  extends Modelica.Icons.Example;
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin                                               sin(
    final freqHz=1/43200,
    final amplitude=6,
    phase=3.1415926535898,
    final offset=273.15 + 20) "Sine wave"
    annotation (Placement(transformation(extent={{-64,-20},{-44,0}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.Subsequences.SingleTemperatureSetpointBAS
    singleTemperatureSetpointBAS(setChaDel=3600)
    "Represents a single temperature setpoint within a Building Automation System"
    annotation (Placement(transformation(extent={{-6,-20},{14,0}})));
equation
  connect(sin.y, singleTemperatureSetpointBAS.uTSet)
  annotation (Line(points={{-42,-10},{-8,-10}}, color={0,0,127}));
   annotation (experiment(
      StopTime=172800,
      Interval=60,
      __Dymola_Algorithm="Dassl"), Documentation(info="<html>
<p>This example validates <a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.Generic.Subsequences.SingleTemperatureSetpointBAS\">
Buildings.Controls.OBC.DemandFlexibility.Generic.Subsequences.SingleTemperatureSetpointBAS</a> by
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
end SingleTemperatureSetpointBAS;
