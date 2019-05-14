within Buildings.Controls.OBC.CDL.Utilities.Validation;
model OptimalStart
  extends Modelica.Icons.Example;
  Continuous.Sources.Sine TZon(
    amplitude=8,
    freqHz=1/172800,
    offset=20 + 273.15,
    startTime(displayUnit="h") = -3600)
    annotation (Placement(transformation(extent={{-60,8},{-40,28}})));
  Continuous.Sources.Constant TSetHea(k=22 + 273.15)
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Continuous.Sources.Constant TSetCoo(k=24 + 273.15)
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  OptimalStartConstantTemperatureGradient
    optimalStartConstantTemperatureGradient
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
equation
  connect(optimalStartConstantTemperatureGradient.TSetZonCoo, TSetCoo.y)
    annotation (Line(points={{-2,-8},{-20,-8},{-20,-60},{-39,-60}}, color={0,0,
          127}));
  connect(optimalStartConstantTemperatureGradient.TSetZonHea, TSetHea.y)
    annotation (Line(points={{-2,-4},{-22,-4},{-22,-20},{-39,-20}}, color={0,0,
          127}));
  connect(optimalStartConstantTemperatureGradient.TZon, TZon.y) annotation (
      Line(points={{-2,0},{-28,0},{-28,18},{-39,18}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OptimalStart;
