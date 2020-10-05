within Buildings.Experimental.NaturalVentilation.Lockouts.SubLockouts.Validation;
model Occupancy
  "Validation model for occupancy natural ventilation lockout"

  OccupancyLockout occLoc
    annotation (Placement(transformation(extent={{0,38},{20,58}})));
  Controls.OBC.CDL.Logical.Sources.Pulse booPul(period=86400)
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Controls.OBC.CDL.Logical.Sources.Pulse booPul1(period=43200)
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
equation
  connect(booPul.y, occLoc.uOcc) annotation (Line(points={{-38,10},{-20,10},
          {-20,45},{-2,45}}, color={255,0,255}));
  connect(booPul1.y, occLoc.uNitFlu) annotation (Line(points={{-38,50},{-20,
          50},{-20,50.8},{-2,50.8}}, color={255,0,255}));
  annotation (Documentation(info="<html>
<p>
This model validates the occupancy lockout. If natural ventilation is allowed, output should show true. 
If natural ventilation is locked out because the building is unoccupied and is also not in night flush mode, output should show false. 
</p>  
</p>
</html>"),experiment(Tolerance=1e-6, StartTime=0, StopTime=86400),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/NatVentControl/Lockouts/SubLockouts/Validation/Occupancy.mos"
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
end Occupancy;
