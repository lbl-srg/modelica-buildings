within Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.Lockouts.SubLockouts.Validation;
model NightFlushLockout "Validation model for night flush"
  Controls.OBC.RadiantSystems.CoolingAndHeating.Lockouts.SubLockouts.NightFlush nigFluLoc
    "Night flush"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Controls.OBC.CDL.Logical.Sources.Pulse booPul(period=43000)
    "Varying night flush signal"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
equation
  connect(booPul.y, nigFluLoc.uNigFlu)
    annotation (Line(points={{-38,10},{-2.2,10}}, color={255,0,255}));
  annotation (Documentation(info="<html>
<p>
Validates the night flush lockout. 
This model validates that heating is locked out if night flush mode is on. 
</p>
</html>", revisions="<html>
<ul>
<li>
October 6, 2020, by Fiona Woods:<br/>
First implementation. 
</li>
</ul>
</html>"),experiment(StartTime=0,StopTime=172800.0, Tolerance=1e-06),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/RadiantSystems/CoolingAndHeating/Lockouts/SubLockouts/Validation/NightFlushLockout.mos"
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
end NightFlushLockout;
