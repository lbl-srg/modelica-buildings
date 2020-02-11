within Buildings.Applications.DHC.Loads.Validation.BaseClasses;
model Distribution2Pipe
  extends Networks.BaseClasses.PartialDistribution2Pipe(
      redeclare Connection2Pipe con[nCon](final dpDis_nominal=dpDis_nominal),
      redeclare model Model_pipDis = Fluid.FixedResistances.LosslessPipe,
      final mEnd_flow_nominal=0);
  parameter Modelica.SIunits.PressureDifference dpDis_nominal[nCon]
    "Pressure drop in distribution line (supply only, not counting return line)"
    annotation(Dialog(tab="General", group="Nominal condition"));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Distribution2Pipe;
