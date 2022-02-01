within Buildings.Templates.ZoneEquipment;
package Types "Terminal unit types"
  extends Modelica.Icons.TypesPackage;
  type Configuration = enumeration(
      SingleDuct
      "Single duct system",
      DualDuct
      "Dual duct system",
      FanPowered
      "Fan-powered system",
      Induction
      "Induction system")
    "Enumeration to configure the terminal unit";
  type Controller = enumeration(
      G36VAVBoxCoolingOnly
      "Guideline 36 controller for VAV terminal unit cooling only",
      G36VAVBoxReheat
      "Guideline 36 controller for VAV terminal unit with reheat",
      OpenLoop
      "Open loop")
      "Enumeration to configure the terminal unit controller";
end Types;
