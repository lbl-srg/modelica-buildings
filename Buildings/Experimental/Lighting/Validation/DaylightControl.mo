within Buildings.Experimental.Lighting.Validation;
model DaylightControl "Validation model for daylighting control"
  DaylightControlContinuous dayConCon(maxFC=100)
    annotation (Placement(transformation(extent={{-18,0},{40,62}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Constant const(k=100)
    annotation (Placement(transformation(extent={{-82,22},{-62,42}})));
  Modelica.Blocks.Sources.Ramp ramp(height=50, duration=7200)
    annotation (Placement(transformation(extent={{-80,-22},{-60,-2}})));
equation
  connect(booleanConstant.y, dayConCon.uFixAva) annotation (
      Line(points={{-59,70},{-32,70},{-32,52.7},{-23.8,52.7}}, color={255,0,255}));
  connect(ramp.y, dayConCon.uDayLev) annotation (Line(points={{-59,-12},
          {-48,-12},{-48,40.3},{-24.38,40.3}},      color={0,0,127}));
  connect(const.y,dayConCon.uLigSet)  annotation (Line(points={{-61,32},
          {-42,32},{-42,27.9},{-24.38,27.9}},         color={0,0,127}));
  annotation (experiment(Tolerance=1e-6, StopTime=14400), __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/Lighting/Validation/DaylightControl.mos"
        "Simulate and plot"),Documentation(info="<html>
  <p>
  This model validates the daylighting control block by demonstrating fixture output in response to varying daylight levels.
  <p>
 
</p>
</html>"),
    Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-100,-102},{100,98}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,58},{64,-2},{-36,-62},{-36,58}})}));
end DaylightControl;
