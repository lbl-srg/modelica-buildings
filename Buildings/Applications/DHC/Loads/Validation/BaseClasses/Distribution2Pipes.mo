within Buildings.Applications.DHC.Loads.Validation.BaseClasses;
model Distribution2Pipes
  extends DHC.Examples.FifthGeneration.Unidirectional.Networks.BaseClasses.PartialUnidirectionalParallel(
    redeclare Buildings.Applications.DHC.Loads.Validation.BaseClasses.ConnectionParallel con[nCon](
      dpDis_nominal=dpDis_nominal,
      dpCon_nominal=dpCon_nominal));
  parameter Modelica.SIunits.PressureDifference dpDis_nominal[nCon];
  parameter Modelica.SIunits.PressureDifference dpCon_nominal[nCon];
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Distribution2Pipes;
