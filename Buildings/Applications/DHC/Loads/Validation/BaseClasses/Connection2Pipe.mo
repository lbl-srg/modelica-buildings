within Buildings.Applications.DHC.Loads.Validation.BaseClasses;
model Connection2Pipe
  "Model for connecting an agent to the DHC system, using fixed resistance pipe model"
  extends Networks.BaseClasses.PartialConnection2Pipe(
    redeclare model PipeDisModel =
      Fluid.FixedResistances.PressureDrop(dp_nominal=dpDis_nominal),
    redeclare model PipeConModel =
      Fluid.FixedResistances.LosslessPipe);
  parameter Modelica.SIunits.PressureDifference dpDis_nominal
    "Pressure drop in distribution line (supply only, not counting return line)";
end Connection2Pipe;
