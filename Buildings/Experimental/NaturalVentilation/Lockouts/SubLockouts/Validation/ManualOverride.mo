within Buildings.Experimental.NaturalVentilation.Lockouts.SubLockouts.Validation;
model ManualOverride
  "Validation model for manual override natural ventilation lockout"

  Controls.OBC.CDL.Logical.Sources.Pulse booPul(period=86400)
    "Varying manual override signal"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  ManualOverrideLockout manLoc
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
equation
  connect(booPul.y, manLoc.uManOveRid)
    annotation (Line(points={{-38,10},{-2,10}}, color={255,0,255}));
  annotation (Documentation(info="<html>
<p>
This model validates the manual override lockout. If natural ventilation is allowed, output should show true. 
If natural ventilation is locked out due to manual override, output should show false. 
</p>
</html>", revisions="<html>
<ul>
<li>
October 6, 2020, by Fiona Woods:<br/>
Updated description. 
</li>
</html>"),experiment(Tolerance=1e-6, StartTime=0, StopTime=86400),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/NaturalVentilation/Lockouts/SubLockouts/Validation/ManualOverride.mos"
        "Simulate and plot"), Icon(graphics={
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
end ManualOverride;
