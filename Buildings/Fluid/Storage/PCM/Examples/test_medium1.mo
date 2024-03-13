within Buildings.Fluid.Storage.PCM.Examples;
model test_medium1
  test_medium0 test_medium0_1(redeclare package Medium1 = Buildings.Media.Water)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end test_medium1;
