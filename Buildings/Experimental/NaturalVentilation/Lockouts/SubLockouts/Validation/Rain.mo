within Buildings.Experimental.NaturalVentilation.Lockouts.SubLockouts.Validation;
model Rain "Validation model for rain natural ventilation lockout"

  RainLockout raiLoc
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Controls.OBC.CDL.Logical.Sources.Pulse booPul(period=14400)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
equation
  connect(booPul.y, raiLoc.uRai)
    annotation (Line(points={{-38,30},{-2,30}}, color={255,0,255}));
  annotation (Documentation(info="<html>
<p>
This model validates the rain lockout. If natural ventilation is allowed, output should show true. 
If natural ventilation is locked out because it is raining or it was raining within a specified amount of time (in this case, 30 minutes), output should show false. 
</p>  
</p>
</html>"),experiment(Tolerance=1e-6, StartTime=0, StopTime=86400),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/NaturalVentilation/Lockouts/SubLockouts/Validation/Rain.mos"
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
end Rain;
