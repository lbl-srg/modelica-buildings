within Buildings.Experimental.NaturalVentilation.Window.Validation;
model Window "Window validation model"
  Modelica.Blocks.Sources.Ramp ramp1(
    height=10,
    duration=86400,
    offset=291.15)
    annotation (Placement(transformation(extent={{-60,58},{-40,78}})));
  Modelica.Blocks.Sources.Constant const1(k=293.15)
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  WindowControl winCon
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
equation
  connect(const1.y, winCon.TRooSet) annotation (Line(points={{-39,10},{-20,10},{
          -20,27.2},{-2,27.2}}, color={0,0,127}));
  connect(ramp1.y, winCon.TRooMea) annotation (Line(points={{-39,68},{-22,68},{-22,
          35},{-2,35}}, color={0,0,127}));
  annotation (experiment(Tolerance=1e-6, StartTime=0, StopTime=86400),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/NatVentControl/Window/Validation/Window.mos"
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
end Window;
