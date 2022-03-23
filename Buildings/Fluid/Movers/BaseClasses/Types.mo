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
        "Not provided, computed from other efficiency terms",
      Values
        "An array of value(s) vs. volumetric flow rate",
      Values_y
        "An array of value(s) vs. part load ratio",
      PowerCurve
        "An array of power vs. volumetric flow rate",
      EulerNumber
        "One peak point to be use for the Euler number");
 annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains type definitions for movers.
</p>
</html>"));
end Types;
