within Buildings.Fluid.Movers.BaseClasses;
package Types "Package with type definitions"
  extends Modelica.Icons.TypesPackage;

  type PrescribedVariable = enumeration(
      Speed "Speed is prescribed",
      FlowRate "Flow rate is prescribed",
      PressureDifference "Pressure difference is prescribed")
    "Enumeration to choose what variable is prescribed";

 annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains type definitions for movers.
</p>
</html>"));
end Types;
