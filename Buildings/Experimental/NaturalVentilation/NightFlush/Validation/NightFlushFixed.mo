within Buildings.Experimental.NaturalVentilation.NightFlush.Validation;
model NightFlushFixed "Night flush validation model"
  NightFlushFixedDuration nitFluFix
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp ram(
    height=30,
    duration=864000,
    offset=290)
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Controls.OBC.CDL.Continuous.Sources.Constant con(k=280)
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
equation
  connect(con.y, nitFluFix.uRooSet) annotation (Line(points={{-38,70},{-20,70},
          {-20,12.2},{-2,12.2}}, color={0,0,127}));
  connect(ram.y, nitFluFix.uForHi) annotation (Line(points={{-38,-10},{-20,-10},
          {-20,7.2},{-2.2,7.2}}, color={0,0,127}));
  annotation (experiment(Tolerance=1e-6, StartTime=0, StopTime=864000),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/NaturalVentilation/NightFlush/Validation/NightFlushFixed.mos"
        "Simulate and plot"),Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-34,64},{66,4},{-34,-56},{-34,64}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end NightFlushFixed;
