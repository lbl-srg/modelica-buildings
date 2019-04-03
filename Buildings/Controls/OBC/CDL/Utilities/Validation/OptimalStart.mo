within Buildings.Controls.OBC.CDL.Utilities.Validation;
model OptimalStart
  extends Modelica.Icons.Example;
  Buildings.Controls.OBC.CDL.Utilities.OptimalStart optimalStart
    annotation (Placement(transformation(extent={{0,-18},{20,2}})));
  Buildings.Controls.SetPoints.OccupancySchedule occSch
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Continuous.Sources.Sine TZon(
    amplitude=8,
    freqHz=1/86400,
    offset=18)
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Continuous.Sources.Constant TSetHea(k=21)
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Continuous.Sources.Constant TSetCoo(k=24)
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
equation
  connect(occSch.tNexOcc, optimalStart.tNexOcc) annotation (Line(points={{-39,66},
          {-20,66},{-20,-0.2},{-2,-0.2}}, color={0,0,127}));
  connect(occSch.tNexNonOcc, optimalStart.tNexNonOcc) annotation (Line(points={{
          -39,60},{-22,60},{-22,-4},{-2,-4}}, color={0,0,127}));
  connect(TZon.y, optimalStart.TZon) annotation (Line(points={{-39,20},{-24,20},
          {-24,-8},{-2,-8}}, color={0,0,127}));
  connect(TSetHea.y, optimalStart.TSetZonHea) annotation (Line(points={{-39,-20},
          {-22,-20},{-22,-12},{-2,-12}}, color={0,0,127}));
  connect(TSetCoo.y, optimalStart.TSetZonCoo) annotation (Line(points={{-39,-60},
          {-20,-60},{-20,-16},{-2,-16}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OptimalStart;
