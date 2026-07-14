within Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.Lockouts.SubLockouts.Validation;
model ChilledWaterReturnLockout
  "Chilled water return lockout validation model"
  final parameter Real TWatSetLow(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="Temperature")=285.9
    "Lower limit for chilled water return temperature, below which cooling is locked out";
   final parameter Real cooLocDurWatTem(min=0,
    final unit="s",
    final displayUnit="s",
    final quantity="Time")=3600 "Time for which cooling is locked out if CHW return is too cold";
  Controls.OBC.CDL.Continuous.Sources.Sine sin(
    amplitude=20,
    freqHz=0.0001,
    phase(displayUnit="rad"),
    offset=TWatSetLow) "Varying chilled water return temperature"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Controls.OBC.RadiantSystems.CoolingAndHeating.Lockouts.SubLockouts.ChilledWaterReturnLimit chwRetLim(
    final TWatSetLow=TWatSetLow,
    final cooLocDurWatTem=cooLocDurWatTem)
    "Chilled water return limit"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
equation
  connect(sin.y,chwRetLim. TSlaRet) annotation (Line(points={{-58,50},{-40,50},{-40,
          52},{-22,52}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
Validates the chilled water return temperature lockout. 
This model validates that cooling is locked out if CHW return temperature is below a user-specified threshold. 
</p>
</html>", revisions="<html>
<ul>
<li>
October 6, 2020, by Fiona Woods:<br/>
First implementation.
</li>
</ul>
</html>"),experiment(StopTime=172800.0, Tolerance=1e-06),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/RadiantSystems/CoolingAndHeating/Lockouts/SubLockouts/Validation/ChilledWaterReturnLockout.mos"
        "Simulate and plot"),Icon(graphics={
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
end ChilledWaterReturnLockout;
