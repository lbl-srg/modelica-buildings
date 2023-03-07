within Buildings.Templates.HeatingPlants.HotWater;
package Types "Package with type definitions"
  extends Modelica.Icons.TypesPackage;
type Distribution = enumeration(
    Variable1Only "Variable primary-only",
    Constant1Variable2 "Constant primary - Variable secondary centralized",
    Variable1And2 "Variable primary - Variable secondary centralized",
    Variable1And2Distributed "Variable primary - Variable secondary distributed")
    "Enumeration to specify the type of HW distribution system";
type Plant = enumeration(
    HotWaterBoiler "Hot water boiler plant",
    HotWaterHeatPump "Heat pump plant")
    "Enumeration to specify the type of HW plant";
end Types;
