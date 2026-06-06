within Buildings.Fluid.HeatPumps.ModularReversible;
package Types "Package with type definitions"
  extends Modelica.Icons.TypesPackage;

  type HeatPump = enumeration(
    AirToWater
    "Air-to-water heat pump",
    WaterToWater
    "Water(or brine)-to-water heat pump")
  "Enumeration to specify the type of heat pump";
annotation(
  Documentation(info="<html>
<p>
This package contains type definitions.
</p>
</html>"));
end Types;
