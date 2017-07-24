within Buildings.ChillerWSE.Examples;
model IntegratedPrimaryLoadSide
  "Example that show how to use Buildings.ChillerWSE.IntegratedPrimaryLoadSide"
  import Buildings;
  Buildings.ChillerWSE.IntegratedPrimaryLoadSide intWSEPri
    "Integrated waterside economizer on the load side of a primary-only chilled water system"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end IntegratedPrimaryLoadSide;
