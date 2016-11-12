within Buildings.ThermalZones.Detailed;
package Types "Package with type definitions"

  type CFDBoundaryConditions = enumeration(
      Temperature "Temperature specified",
      HeatFlowRate "Heat flow rate specified")
    "Enumeration to define boundary conditions for the CFD simulation";

annotation (preferredView="info", Documentation(info="<html>
This package contains type definitions.
</html>"));
end Types;
