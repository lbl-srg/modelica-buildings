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
        "An array of efficiency vs. volumetric flow rate",
      PowerCurve
        "An array of power vs. volumetric flow rate",
      EulerNumber
        "One peak point to be use for the Euler number")
    "Enumeration to choose the computation method for total efficiency and hydraulic efficiency";
  type MotorEfficiencyMethod = enumeration(
      NotProvided
        "Not provided, computed from other efficiency terms",
      Values
        "An array of efficiency vs. volumetric flow rate",
      Values_yMot
        "The rated input and an array of efficiency vs. motor part load ratio",
      GenericCurves
        "The rated input and maximum efficiency to be used for generic curves")
    "Enumeration to choose the computation method for motor efficiency";
 annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains type definitions for movers.
</p>
</html>"));
end Types;
