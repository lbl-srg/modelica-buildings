within Buildings.Fluid.Storage.PCM.Examples;
model test_medium2
  replaceable package Medium =
        Buildings.Media.Water;
  test_medium0 test_medium0_1(redeclare package Medium1 = Medium)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end test_medium2;
