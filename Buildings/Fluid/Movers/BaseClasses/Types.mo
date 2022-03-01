within Buildings.Fluid.Movers.BaseClasses;
package Types "Package with type definitions"
  extends Modelica.Icons.TypesPackage;

  type PrescribedVariable = enumeration(
      Speed "Speed is prescribed",
      FlowRate "Flow rate is prescribed",
      PressureDifference "Pressure difference is prescribed")
    "Enumeration to choose what variable is prescribed";
  type PowerMethod = enumeration(
      PowerCharacteristic "User provides a dataset for power",
      EulerNumber "User provides peak operation point",
      MotorEfficiency "User provides motor efficiency")
    "Enumeration to choose the method for power computation";
  type EfficiencyMethod = enumeration(
      NotProvided
        "1. Not provided, will be computed from other efficiencies",
      Values
        "2. An array of values or one constant is provided",
      PowerCurve
        "3. A power curve is provided",
      EulerNumber
        "4. The peak point is provided");
 annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains type definitions for movers.
</p>
</html>"));
end Types;
