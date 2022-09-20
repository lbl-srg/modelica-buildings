within Buildings.Templates.Data;
package Defaults "Package with default sizing parameters"
  extends Modelica.Icons.MaterialPropertiesPackage;

  constant Modelica.Units.SI.Temperature TChiWatSup=7+273.15
    "CHW supply temperature";
  constant Modelica.Units.SI.Temperature TChiWatSup_max=16+273.15
    "Maximum CHW supply temperature";
  constant Modelica.Units.SI.Temperature TChiWatRet=12+273.15
    "CHW return temperature";
  constant Modelica.Units.SI.Temperature TConWatSup=29.4+273.15
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

  constant Modelica.Units.SI.Temperature TAirDryCooEnt=35+273.15
    "Dry cooler entering air drybulb temperature";
  constant Modelica.Units.SI.Temperature TWetBulTowEnt=23.9+273.15
    "CT entering air wetbulb temperature";
  constant Real PFanByFloConWatTow(unit="W/(kg/s)")=340
    "CT fan power divided by CW mass flow rate";
  constant Real ratFloWatByAirTow(unit="1")=1.45
    "CT CW mass flow rate divided by air mass flow rate";
  constant Modelica.Units.SI.PressureDifference dpConWatFriTow=1E4
    "CW flow-friction losses through open-circuit tower and piping only (without static head or valve)";
  constant Modelica.Units.SI.PressureDifference dpConWatStaTow=3E4
    "CW static pressure drop (for open cooling towers only)";
  constant Modelica.Units.SI.PressureDifference dpConWatTowClo=5E4
    "CW flow-friction losses through closed-circuit tower and piping only (without valve)";

  constant Real mConAirByCapChi(unit="(kg/s)/W")=1E-4
    "Air mass flow rate at condenser divided by chiller capacity";
  constant Real COPChiAirCoo(unit="1")=3.0
    "Air-cooled chiller COP";
  constant Real COPChiWatCoo(unit="1")=5.0
    "Water-cooled chiller COP";
  constant Modelica.Units.SI.PressureDifference dpValIso=1E3
    "Isolation or bypass valve pressure drop";
  constant Modelica.Units.SI.PressureDifference dpValChe=1E4
    "Check valve pressure drop";
  constant Modelica.Units.SI.PressureDifference dpChiWatChi=5E4
    "Chiller CHW pressure drop";
  constant Modelica.Units.SI.PressureDifference dpConWatChi=5E4
    "Chiller CW pressure drop (water-cooled)";
  constant Modelica.Units.SI.PressureDifference dpConAirChi=2000
    "Chiller air pressure drop through condenser (air-cooled)";
  constant Modelica.Units.SI.PressureDifference dpChiWatEco=3E4
    "WSE CHW pressure drop";
  constant Modelica.Units.SI.PressureDifference dpConWatEco=3E4
    "WSE CW pressure drop";
  constant Modelica.Units.SI.PressureDifference pChiWat_rel_min=1.0E5
    "CHW circuit minimum pressure";
  constant Modelica.Units.SI.PressureDifference pHeaWat_rel_min=1.5E5
    "HHW circuit minimum pressure";
end Defaults;
