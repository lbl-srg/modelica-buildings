within Buildings.Experimental.NaturalVentilation.Lockouts.SubLockouts.Validation;
model WetBulb
  "Validation model for natural ventilation wet bulb lockout"

  Controls.OBC.CDL.Continuous.Sources.Sine sin(
    amplitude=2*4.44,
    freqHz=2/86400,
    phase(displayUnit="rad"),
    offset=293.15)
    annotation (Placement(transformation(extent={{-60,42},{-40,62}})));
  Controls.OBC.CDL.Continuous.Sources.Constant con(k=293.15)
    annotation (Placement(transformation(extent={{-60,2},{-40,22}})));
  WetBulbLockout wetBulLoc
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
equation
  connect(con.y, wetBulLoc.TRooSet) annotation (Line(points={{-38,12},{-20,
          12},{-20,27},{-2,27}}, color={0,0,127}));
  connect(sin.y, wetBulLoc.TWetBul) annotation (Line(points={{-38,52},{-20,
          52},{-20,33},{-2,33}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This model validates the wet bulb lockout. If natural ventilation is allowed, output should show true. 
If natural ventilation is locked out because the wet bulb temperature is above the room setpoint minus the temperature difference , output should show false. 
</p> 
</p>
</html>"),experiment(Tolerance=1e-6, StartTime=0, StopTime=86400),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/NaturalVentilation/Lockouts/SubLockouts/Validation/WetBulb.mos"
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
end WetBulb;
