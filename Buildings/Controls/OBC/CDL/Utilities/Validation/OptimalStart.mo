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
  Continuous.Sources.Sine TOut(
    amplitude=5,
    freqHz=1/86400,
    offset=273.15 + 10) "Outdoor temperature"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Buildings.Controls.OBC.CDL.Utilities.OptimalStart optimalStart
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
equation
  connect(optimalStartConstantTemperatureGradient.TSetZonHea, TSetHea.y)
    annotation (Line(points={{-2,-54},{-20,-54},{-20,-20},{-38,-20}}, color={0,
          0,127}));
  connect(optimalStartConstantTemperatureGradient.TSetZonCoo, TSetCoo.y)
    annotation (Line(points={{-2,-58},{-20,-58},{-20,-60},{-38,-60}}, color={0,
          0,127}));
  connect(optimalStartConstantTemperatureGradient.TZon, TZon.y) annotation (
      Line(points={{-2,-50},{-18,-50},{-18,30},{-38,30}}, color={0,0,127}));
  connect(TZon.y, optimalStart.TZon) annotation (Line(points={{-38,30},{-22,30},
          {-22,18},{-2,18}}, color={0,0,127}));
  connect(TSetHea.y, optimalStart.TSetZon) annotation (Line(points={{-38,-20},{
          -22,-20},{-22,10},{-2,10}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OptimalStart;
