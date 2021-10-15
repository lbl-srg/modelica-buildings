within Buildings.Fluid.Movers.BaseClasses;
package Types "Package with type definitions"
  extends Modelica.Icons.TypesPackage;

  type PrescribedVariable = enumeration(
      Speed "Speed is prescribed",
      FlowRate "Flow rate is prescribed",
      PressureDifference "Pressure difference is prescribed")
    "Enumeration to choose what variable is prescribed";
  type EfficiencyMethod = enumeration(
      PowerCharacteristic "User provides a dataset for power",
      EulerCorrelation "User provides peak operation point",
      MotorEfficiency "User provides motor efficiency")
    "Enumeration to choose the method for efficiency computation";
 annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains type definitions for movers.
</p>
</html>"));
end Types;
