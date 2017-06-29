within Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Validation;
model MovingMean
  import Buildings;
  Modelica.Blocks.Noise.UniformNoise uniformNoise(
    y_min=0,
    y_max=1,
    samplePeriod=2)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.MovingMean
    movingMean(Ts=1200)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
equation
  connect(uniformNoise.y, movingMean.u)
    annotation (Line(points={{-59,0},{18,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end MovingMean;
