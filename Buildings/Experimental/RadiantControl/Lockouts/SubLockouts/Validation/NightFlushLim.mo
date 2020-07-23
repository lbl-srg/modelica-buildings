within Buildings.Experimental.RadiantControl.Lockouts.SubLockouts.Validation;
model NightFlushLim "Validation model for night flush"
  Modelica.Blocks.Sources.BooleanPulse booleanPulse3(period=43000)
    annotation (Placement(transformation(extent={{-60,-2},{-40,18}})));
  NightFlush nightFlush
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
equation
  connect(booleanPulse3.y, nightFlush.nightFlushSignal) annotation (
      Line(points={{-39,8},{-20,8},{-20,10},{-2.2,10}}, color={255,0,
          255}));
  annotation (Documentation(info="<html>
<p>
Validates the night flush lockout. Validates that heating is locked out if night flush mode is on. 
</p>
</html>"),experiment(StopTime=172800.0, Tolerance=1e-06),Icon(graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,58},{64,-2},{-36,-62},{-36,58}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end NightFlushLim;
