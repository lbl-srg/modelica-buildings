within Buildings.Applications.DHC.Loads.Validation.BaseClasses;
model Distribution2Pipes
  extends DHC.Examples.FifthGeneration.Unidirectional.Networks.BaseClasses.PartialUnidirectionalParallel(
    redeclare BaseClasses.ConnectionParallel con[nCon](
      dpDis_nominal=dpDis_nominal, dpCon_nominal=dpCon_nominal),
    redeclare model PipeDisModel = Fluid.FixedResistances.PressureDrop,
    pipEnd(dp_nominal=dpEnd_nominal));
  parameter Modelica.SIunits.PressureDifference dpDis_nominal[nCon];
  parameter Modelica.SIunits.PressureDifference dpCon_nominal[nCon];
  parameter Modelica.SIunits.PressureDifference dpEnd_nominal;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Distribution2Pipes;
