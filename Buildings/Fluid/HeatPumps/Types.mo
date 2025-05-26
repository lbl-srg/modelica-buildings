within Buildings.Fluid.HeatPumps;
package Types "Package with type definitions"
  extends Modelica.Icons.TypesPackage;

  type OperatingMode = enumeration(
    Heating "Heating only",
    Cooling "Cooling only",
    SHC "Simultaneous heating and cooling")
    "Operating mode";

end Types;
