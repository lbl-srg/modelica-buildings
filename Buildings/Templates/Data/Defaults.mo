within Buildings.Templates.Data;
package Defaults "Package with default sizing parameters"
  extends Modelica.Icons.MaterialPropertiesPackage;

  constant Modelica.Units.SI.Temperature TChiWatSup=7+273.15
    "CHW supply temperature";
  constant Modelica.Units.SI.Temperature TChiWatRet=12+273.15
    "CHW return temperature";
  constant Modelica.Units.SI.Temperature TConWatSup=30+273.15
    "CW supply temperature";
  constant Modelica.Units.SI.Temperature TConWatRet=35+273.15
    "CW return temperature";
  constant Modelica.Units.SI.Temperature TChiWatEcoEnt=18+273.15
    "WSE entering CHW temperature";
  constant Modelica.Units.SI.Temperature TChiWatEcoLvg=11+273.15
    "WSE leaving CHW temperature";
  constant Modelica.Units.SI.Temperature TConWatEcoEnt=9+273.15
    "WSE entering CW temperature";
  constant Modelica.Units.SI.Temperature TConWatEcoLvg=16+273.15
    "WSE leaving CW temperature";
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
  constant Modelica.Units.SI.PressureDifference pChiWat_rel_min=1.0E5
    "CHW circuit minimum pressure";
  constant Modelica.Units.SI.PressureDifference pHeaWat_rel_min=1.5E5
    "HHW circuit minimum pressure";

end Defaults;
