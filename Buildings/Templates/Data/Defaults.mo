within Buildings.Templates.Data;
package Defaults
  "Package with default sizing parameters"
  extends Modelica.Icons.MaterialPropertiesPackage;
  constant Modelica.Units.SI.Temperature TChiWatSup=7 + 273.15
    "CHW supply temperature (AHRI 551/591)";
  constant Modelica.Units.SI.Temperature TChiWatSup_max=16 + 273.15
    "Maximum CHW supply temperature (typical)";
  constant Modelica.Units.SI.Temperature TChiWatRet=12 + 273.15
    "CHW return temperature (AHRI 551/591)";
  constant Modelica.Units.SI.Temperature TConWatSup=30 + 273.15
    "CW supply temperature (AHRI 551/591)";
  constant Modelica.Units.SI.Temperature TConWatRet=35 + 273.15
    "CW return temperature (AHRI 551/591)";
  constant Modelica.Units.SI.Temperature TOutChi=35 + 273.15
    "Outdoor air temperature for air-cooled chiller (AHRI 551/591)";
  constant Modelica.Units.SI.Temperature TConEnt_min=13 + 273.15
    "Minimum condenser entering fluid temperature (air or water)";
  constant Modelica.Units.SI.Temperature TConEnt_max=45 + 273.15
    "Maximum condenser entering fluid temperature (air or water)";
  constant Modelica.Units.SI.Temperature TChiWatEcoEnt=18 + 273.15
    "WSE entering CHW temperature";
  constant Modelica.Units.SI.Temperature TChiWatEcoLvg=11 + 273.15
    "WSE leaving CHW temperature";
  constant Modelica.Units.SI.Temperature TConWatEcoEnt=9 + 273.15
    "WSE entering CW temperature";
  constant Modelica.Units.SI.Temperature TConWatEcoLvg=16 + 273.15
    "WSE leaving CW temperature";
  constant Modelica.Units.SI.Temperature TOutChiWatLck=16 + 273.15
    "Outdoor air lockout temperature below which the CHW system is prevented from operating";
  constant Modelica.Units.SI.TemperatureDifference dTLifChi_min=5
    "Minimum chiller lift at minimum load";
  constant Modelica.Units.SI.Temperature TOutDryCoo=TOutChi
    "Dry cooler entering air drybulb temperature";
  constant Modelica.Units.SI.Temperature TWetBulTowEnt=24 + 273.15
    "CT entering air wetbulb temperature";
  constant Real PFanByFloConWatTow(
    unit="W/(kg/s)")=340
    "CT fan power divided by CW mass flow rate";
  constant Real mConWatFloByAirTow(
    unit="1")=1.45
    "CT CW mass flow rate divided by air mass flow rate";
  constant Modelica.Units.SI.PressureDifference dpConWatFriTow=1E4
    "CW flow-friction losses through open-circuit tower and piping only (without elevation head or valve)";
  constant Modelica.Units.SI.PressureDifference dpConWatStaTow=3E4
    "CW elevation head (for open cooling towers only)";
  constant Modelica.Units.SI.PressureDifference dpConWatTowClo=5E4
    "CW flow-friction losses through closed-circuit tower and piping only (without valve)";
  constant Real mAirFloByCapChi(
    unit="(kg/s)/W")=1E-4
    "Air mass flow rate divided by capacity for air-cooled chiller";
  constant Real COPChiAirCoo(
    unit="1")=2.99
    "Air-cooled chiller COP (ASHRAE 90.1 2022 at 7 °C CHWST, 35 °C OAT)";
  constant Real COPChiWatCoo(
    unit="1")=5.33
    "Water-cooled chiller COP (ASHRAE 90.1 2022 at 7 °C CHWST, 35 °C source LWT)";
  constant Modelica.Units.SI.PressureDifference dpValIso=1E3
    "Isolation or bypass valve pressure drop";
  constant Modelica.Units.SI.PressureDifference dpValBypMin=3E4
    "Minimum flow bypass valve pressure drop at design minimum flow for the largest chiller";
  constant Modelica.Units.SI.PressureDifference dpValChe=1E4
    "Check valve pressure drop";
  constant Modelica.Units.SI.PressureDifference dpChiWatChi=4E4
    "Chiller CHW pressure drop";
  constant Modelica.Units.SI.PressureDifference dpChiWatSet_min=2.5E4
    "Minimum CHW differential pressure setpoint used in CHW plant reset logic";
  constant Modelica.Units.SI.PressureDifference dpChiWatSet_max=5E4
    "Maximum CHW differential pressure setpoint remote from the CHW plant";
  constant Modelica.Units.SI.PressureDifference dpChiWatLocSet_max=15E4
    "Maximum CHW differential pressure setpoint local to the CHW plant";
  constant Modelica.Units.SI.PressureDifference dpConWatChi=4E4
    "Chiller CW pressure drop (water-cooled)";
  constant Modelica.Units.SI.PressureDifference dpAirChi=500
    "Chiller air pressure drop across condenser (air-cooled)";
  constant Modelica.Units.SI.PressureDifference dpChiWatEco=3E4
    "WSE CHW pressure drop";
  constant Modelica.Units.SI.PressureDifference dpConWatEco=3E4
    "WSE CW pressure drop";
  constant Modelica.Units.SI.PressureDifference pChiWat_rel_nominal=1.0E5
    "CHW system gauge pressure at design conditions";
  constant Modelica.Units.SI.PressureDifference pHeaWat_rel_nominal=2.5E5
    "HHW system gauge pressure at design conditions";
  constant Modelica.Units.SI.PressureDifference dpHeaWatBoi=5E3
    "Boiler HW pressure drop";
  constant Modelica.Units.SI.Temperature THeaWatSup=80 + 273.15
    "HW supply temperature";
  constant Modelica.Units.SI.Temperature THeaWatConSup=65 + 273.15
    "HW supply temperature for condensing boilers";
  constant Modelica.Units.SI.Temperature THeaWatRet=55 + 273.15
    "HW return temperature";
  constant Modelica.Units.SI.Temperature TOutHeaWatLck=21 + 273.15
    "Outdoor air lockout temperature above which the HW system is prevented from operating";
  constant Modelica.Units.SI.PressureDifference dpHeaWatSet_min=2E4
    "Minimum HW differential pressure setpoint used in HW plant reset logic";
  constant Modelica.Units.SI.PressureDifference dpHeaWatSet_max=5E4
    "Maximum HW differential pressure setpoint remote from the HW plant";
  constant Modelica.Units.SI.PressureDifference dpHeaWatLocSet_max=15E4
    "Maximum HW differential pressure setpoint local to the CHW plant";
  constant Modelica.Units.SI.PressureDifference dpHeaWatHp=3E4
    "Heat pump HW pressure drop across condenser barrel";
  constant Modelica.Units.SI.Temperature THeaWatSupHig=60 + 273.15
    "HW supply temperature - High temperature level (AHRI 551/591)";
  constant Modelica.Units.SI.Temperature THeaWatRetHig=50 + 273.15
    "HW return temperature - High temperature level (AHRI 551/591)";
  constant Modelica.Units.SI.Temperature THeaWatSupMed=50 + 273.15
    "HW supply temperature - Medium temperature level (AHRI 551/591)";
  constant Modelica.Units.SI.Temperature THeaWatRetMed=42 + 273.15
    "HW return temperature - Medium temperature level (AHRI 551/591)";
  constant Modelica.Units.SI.Temperature THeaWatSupLow=40 + 273.15
    "HW supply temperature - Low temperature level (AHRI 551/591)";
  constant Modelica.Units.SI.Temperature THeaWatRetLow=35 + 273.15
    "HW return temperature - Low temperature level (AHRI 551/591)";
  constant Modelica.Units.SI.Temperature TOutHpCoo=TOutChi
    "Outdoor air temperature for air-to-water heat pump rating - Cooling (AHRI 551/591)";
  constant Modelica.Units.SI.Temperature TOutHpHeaHig=8 + 273.15
    "Outdoor air temperature for air-to-water heat pump rating - High heating (AHRI 551/591)";
  constant Modelica.Units.SI.Temperature TOutHpHeaLow=-8 + 273.15
    "Outdoor air temperature for air-to-water heat pump rating - Low heating (AHRI 551/591)";
  constant Modelica.Units.SI.Temperature TSouHpCoo=30 + 273.15
    "Source fluid entering temperature for water-to-water heat pump rating - Cooling (AHRI 551/591)";
  constant Modelica.Units.SI.Temperature TSouHpHea=12 + 273.15
    "Source fluid entering temperature for water-to-water heat pump rating - Heating (AHRI 551/591)";
  constant Real COPHpAwHea(
    unit="1")=1.75
    "Air-to-water heat pump heating COP (ASHRAE 90.1 2022 at 50 °C HWST, -8 °C OAT)";
  constant Real COPHpAwCoo(
    unit="1")=2.84
    "Air-to-water heat pump cooling COP (ASHRAE 90.1 2022 at 7 °C CHWST, 35 °C OAT)";
  constant Real COPHpWwHea(
    unit="1")=3.61
    "Water(brine)-to-water heat pump heating COP (ASHRAE 90.1 2022 at 50 °C HWST, 7 °C source LWT)";
  constant Real COPHpWwCoo(
    unit="1")=5.07
    "Water(brine)-to-water heat pump cooling COP (ASHRAE 90.1 2022 at 7 °C CHWST, 35 °C source LWT)";
  annotation (
    Documentation(
      info="<html>
<p>
This package defines some constants that are either
</p>
<ul>
<li>
typical values used as default parameter values
for models inside the package
<a href=\"modelica://Buildings.Templates\">
Buildings.Templates</a>, or
</li>
<li>
arbitrary values used for validation purposes only.
Those are typically project-specific characteristics (e.g.,
chiller COP at nominal conditions) and should not
be considered as generic default values.
</li>
</ul>
</html>",
      revisions="<html>
<ul>
<li>
November 18, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end Defaults;
