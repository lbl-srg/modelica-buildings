within Buildings.Fluid.Air.Data.Generic;
record AirHandingUnit "Performance data for air handling unit"
  extends Modelica.Icons.Record;

  parameter Buildings.Fluid.Air.Data.Generic.BaseClasses.NominalValue nomVal
  "Data record for AHU nominal values";
  parameter Buildings.Fluid.Air.Data.Generic.BaseClasses.PerformanceCurve perCur
  "Data record for fan performance data";


  parameter Modelica.SIunits.MassFlowRate m1_flow_small = 0.0001*nomVal.m1_flow_nominal
    "Small mass flow rate for regularization near zero flow"
    annotation (Dialog(group="Minimum conditions"));
  parameter Modelica.SIunits.MassFlowRate m2_flow_small = 0.0001*nomVal.m2_flow_nominal
    "Small mass flow rate for regularization near zero flow"
    annotation (Dialog(group="Minimum conditions"));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end AirHandingUnit;
