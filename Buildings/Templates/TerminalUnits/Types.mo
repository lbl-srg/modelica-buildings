within Buildings.Templates.TerminalUnits;
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
      Guideline36
      "Guideline 36 control sequence",
      OpenLoop
      "Open loop")
      "Enumeration to configure the terminal unit controller";
end Types;
