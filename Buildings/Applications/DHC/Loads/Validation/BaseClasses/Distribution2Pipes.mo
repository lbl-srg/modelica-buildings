within Buildings.Applications.DHC.Loads.Validation.BaseClasses;
model Distribution2Pipes
  extends Networks.BaseClasses.PartialTwoPipeDistribution(
    redeclare BaseClasses.ConnectionParallel con[nCon](
      dpDis_nominal=dpDis_nominal),
    redeclare model PipeDisModel = Fluid.FixedResistances.LosslessPipe);
  parameter Modelica.SIunits.PressureDifference dpDis_nominal[nCon]
    "Pressure drop in distribution line (supply only, not counting return line)";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Distribution2Pipes;
