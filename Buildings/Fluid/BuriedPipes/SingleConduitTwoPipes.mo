within Buildings.Fluid.BuriedPipes;
model SingleConduitTwoPipes
  FixedResistances.PlugFlowPipe plugFlowPipe
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  FixedResistances.PlugFlowPipe plugFlowPipe1
    annotation (Placement(transformation(extent={{-10,-52},{10,-32}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SingleConduitTwoPipes;
