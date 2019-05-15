within Buildings.Controls.OBC.CDL.Utilities.Validation;
model OptimalStart
  extends Modelica.Icons.Example;
  Continuous.Sources.Constant TSetHea(k=22 + 273.15)
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Continuous.Sources.Constant TSetCoo(k=24 + 273.15)
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  OptimalStartConstantTemperatureGradient
    optimalStartConstantTemperatureGradient
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Continuous.Sources.Sine TZon(
    amplitude=8,
    freqHz=1/172800,
    offset=20 + 273.15,
    startTime(displayUnit="h") = -3600) "Zone temperature"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  OptimalStartAdaptiveTemperatureGradient
    optimalStartAdaptiveTemperatureGradient
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Continuous.Sources.Sine TOut(
    amplitude=5,
    freqHz=1/86400,
    offset=273.15 + 10) "Outdoor temperature"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
equation
  connect(optimalStartConstantTemperatureGradient.TSetZonHea, TSetHea.y)
    annotation (Line(points={{-2,-54},{-20,-54},{-20,-20},{-39,-20}}, color={0,
          0,127}));
  connect(optimalStartConstantTemperatureGradient.TSetZonCoo, TSetCoo.y)
    annotation (Line(points={{-2,-58},{-20,-58},{-20,-60},{-39,-60}}, color={0,
          0,127}));
  connect(optimalStartConstantTemperatureGradient.TZon, TZon.y) annotation (
      Line(points={{-2,-50},{-18,-50},{-18,30},{-39,30}}, color={0,0,127}));
  connect(TSetCoo.y, optimalStartAdaptiveTemperatureGradient.TSetZonCoo)
    annotation (Line(points={{-39,-60},{-24,-60},{-24,2},{-2,2}}, color={0,0,
          127}));
  connect(TSetHea.y, optimalStartAdaptiveTemperatureGradient.TSetZonHea)
    annotation (Line(points={{-39,-20},{-26,-20},{-26,6},{-2,6}}, color={0,0,
          127}));
  connect(optimalStartAdaptiveTemperatureGradient.TZon, TZon.y) annotation (
      Line(points={{-2,10},{-18,10},{-18,30},{-39,30}}, color={0,0,127}));
  connect(optimalStartAdaptiveTemperatureGradient.TOut, TOut.y) annotation (
      Line(points={{-2,14},{-20,14},{-20,70},{-39,70}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OptimalStart;
