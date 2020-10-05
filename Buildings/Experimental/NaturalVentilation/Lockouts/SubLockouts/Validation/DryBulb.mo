within Buildings.Experimental.NaturalVentilation.Lockouts.SubLockouts.Validation;
model DryBulb
  "Validation model for outdoor air dry bulb natural ventilation lockout"

  Controls.OBC.CDL.Continuous.Sources.Constant con(k=293.15)
    annotation (Placement(transformation(extent={{-60,2},{-40,22}})));
  DryBulbLockout dryBulLoc
    annotation (Placement(transformation(extent={{-2,16},{18,36}})));
  Controls.OBC.CDL.Logical.Sources.Pulse booPul(width=0.25, period=86400)
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp ram(
    height=20,
    duration=86400,
    offset=278)
    annotation (Placement(transformation(extent={{-60,78},{-40,98}})));
  Controls.OBC.CDL.Continuous.Sources.Constant con1(k=295)
    annotation (Placement(transformation(extent={{-60,-38},{-40,-18}})));
equation
  connect(con.y, dryBulLoc.TRooSet) annotation (Line(points={{-38,12},{-30,12},{
          -30,22},{-4,22}}, color={0,0,127}));
  connect(booPul.y, dryBulLoc.uNitFlu) annotation (Line(points={{-38,50},{
          -28,50},{-28,26},{-4,26}}, color={255,0,255}));
  connect(ram.y, dryBulLoc.TDryBul) annotation (Line(points={{-38,88},{-22,
          88},{-22,30},{-4,30}}, color={0,0,127}));
  connect(con1.y, dryBulLoc.TRooMea) annotation (Line(points={{-38,-28},{
          -22,-28},{-22,18.4},{-4,18.4}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This model validates the dry bulb lockout. If natural ventilation is allowed, output should show true. 
If natural ventilation is locked out due to dry bulb temperature being out of range, output should show false.   
</p>
</html>"),experiment(Tolerance=1e-6, StartTime=0, StopTime=86400),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/NatVentControl/Lockouts/SubLockouts/Validation/DryBulb.mos"
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
end DryBulb;
