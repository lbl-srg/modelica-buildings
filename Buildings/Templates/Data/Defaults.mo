within Buildings.Templates.Data;
package Defaults "Package with default sizing parameters"
  extends Modelica.Icons.MaterialPropertiesPackage;

  constant Modelica.Units.SI.PressureDifference dpValIso=1E3
    "Isolation or bypass valve pressure drop";
  constant Modelica.Units.SI.PressureDifference dpValChe=1E4
    "Check valve pressure drop";
  constant Modelica.Units.SI.PressureDifference dpChiWatChi=5E4
    "Chiller CHW pressure drop";
  constant Modelica.Units.SI.PressureDifference dpConWatChi=5E4
    "Chiller CW pressure drop";
  constant Modelica.Units.SI.PressureDifference dpChiWatEco=3E4
    "WSE CHW pressure drop";
  constant Modelica.Units.SI.PressureDifference dpConWatEco=3E4
    "WSE CW pressure drop";

end Defaults;
