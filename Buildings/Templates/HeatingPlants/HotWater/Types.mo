within Buildings.Templates.HeatingPlants.HotWater;
package Types "Package with type definitions"
  extends Modelica.Icons.TypesPackage;
type Boilers = enumeration(
    Condensing "Condensing boilers",
    Hybrid "Condensing and non-condensing boilers",
    NonCondensing "Non-condensing boilers")
    "Enumeration to specify the type of boilers";
type Controller = enumeration(
    G36VAVMultiZone
    "Guideline 36 controller for boiler plant",
    OpenLoop
    "Open loop controller")
  "Enumeration to configure the plant controller";
type Distribution = enumeration(
    Variable1Only "Variable primary-only",
    Constant1Variable2 "Constant primary - Variable secondary centralized",
    Variable1And2 "Variable primary - Variable secondary centralized",
    Variable1And2Distributed "Variable primary - Variable secondary distributed")
    "Enumeration to specify the type of HW distribution system";
type Plant = enumeration(
    Boiler "Hot water boiler plant",
    HeatPump "Heat pump plant")
    "Enumeration to specify the type of HW plant";
end Types;
