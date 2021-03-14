within Buildings.Fluid.BuriedPipes;
model TwoBuriedPipes
  FixedResistances.PlugFlowPipe plugFlowPipe
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  FixedResistances.PlugFlowPipe plugFlowPipe1
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TwoBuriedPipes;
