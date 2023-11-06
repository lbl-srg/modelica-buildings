within Buildings.Templates.ZoneEquipment;
package Types "Package with type definitions"
  extends Modelica.Icons.TypesPackage;
  type Configuration = enumeration(
      DualDuct
      "Dual duct system",
      FanPowered
      "Fan-powered system",
      Induction
      "Induction system",
      VAVBoxCoolingOnly
      "VAV terminal unit cooling only",
      VAVBoxReheat
      "VAV terminal unit with reheat")
    "Enumeration to configure the terminal unit";
  type Controller = enumeration(
      G36VAVBoxCoolingOnly
      "Guideline 36 controller for VAV terminal unit cooling only",
      G36VAVBoxReheat
      "Guideline 36 controller for VAV terminal unit with reheat",
      OpenLoop
      "Open loop controller")
      "Enumeration to configure the terminal unit controller";
  annotation (Documentation(info="<html>
<p>
This package contains type definitions.
</p>
</html>"));
end Types;
