within Buildings.Fluid.Air.Data.Generic;
record AirHandingUnit "Performance data for air handling unit"
  extends Modelica.Icons.Record;

  parameter Buildings.Fluid.Air.Data.Generic.BaseClasses.NominalValue nomVal
  "Data record for AHU nominal values";
  parameter Buildings.Fluid.Air.Data.Generic.BaseClasses.PerformanceCurve perCur
  "Data record for fan performance data";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end AirHandingUnit;
