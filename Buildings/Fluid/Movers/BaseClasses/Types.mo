within Buildings.Fluid.Movers.BaseClasses;
package Types "Package with type definitions"
  extends Modelica.Icons.TypesPackage;

  type PrescribedVariable = enumeration(
      Speed "Speed is prescribed",
      FlowRate "Flow rate is prescribed",
      PressureDifference "Pressure difference is prescribed")
    "Enumeration to choose what variable is prescribed";
  type EfficiencyMethod = enumeration(
      NotProvided
        "1. Not provided, will be computed from other efficiencies",
      Values
        "2. An array of values or one constant vs. volumetric flow rate",
      Values_y
        "3. An array of values vs. part load ratio",
      PowerCurve
        "4. A power curve is provided",
      EulerNumber
        "5. The peak point is provided");
 annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains type definitions for movers.
</p>
</html>"));
end Types;
