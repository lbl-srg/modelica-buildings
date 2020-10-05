within Buildings.Experimental.NaturalVentilation.Lockouts.SubLockouts.Validation;
model Wind "Validation model for wind natural ventilation lockout"

  Controls.OBC.CDL.Continuous.Sources.Sine sin2(
    amplitude=2,
    freqHz=4/86400,
    phase(displayUnit="rad"),
    offset=8.94)
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  WindLockout winLoc
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
equation
  connect(sin2.y, winLoc.winSpe)
    annotation (Line(points={{-38,10},{-2,10}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This model validates the wind speed lockout. If natural ventilation is allowed, output should show true. 
If natural ventilation is locked out due to wind speeds exceeding the specified threshhold, output should show false. 
</p>  
</p>
</html>"),experiment(Tolerance=1e-6, StartTime=0, StopTime=86400),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/NatVentControl/Lockouts/SubLockouts/Validation/Wind.mos"
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
end Wind;
