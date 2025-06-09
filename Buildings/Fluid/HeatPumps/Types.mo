within Buildings.Fluid.HeatPumps;
package Types "Package with type definitions"
  extends Modelica.Icons.TypesPackage;

  type HeatPump = enumeration(
    AirToWater
    "Air-to-water heat pump",
    WaterToWater
    "Water(or brine)-to-water heat pump")
  "Enumeration to specify the type of heat pump";
  package OperatingModes
    constant Integer heating = 1 "Heating only";
    constant Integer cooling = 2 "Cooling only";
    constant Integer shc = 3 "Simultaneous heating and cooling";
  end OperatingModes;
end Types;
