within Buildings.DHC.ETS.Combined.Data;
record BuildingSetPoints "Set points for the buildings"
  extends Modelica.Icons.Record;

  parameter Modelica.Units.SI.ThermodynamicTemperature TChiWatSup_nominal = 7+273.15
    "Nominal chilled water supply temperature"
    annotation (Dialog(group="Chilled water"));
  parameter Modelica.Units.SI.TemperatureDifference dTChiWat_nominal = 5
    "Nominal chilled water temperature difference"
    annotation (Dialog(group="Chilled water"));
  final parameter Modelica.Units.SI.ThermodynamicTemperature TChiWatRet_nominal = TChiWatSup_nominal + dTChiWat_nominal
    "Nominal chilled water return temperature";
  parameter Modelica.Units.SI.ThermodynamicTemperature tabChiWatRes[2,2](each displayUnit="degC")=
    [16+273.15, 12+273.15;
     27+273.15, TChiWatSup_nominal]
    "Chilled water supply temperature reset schedule"
    annotation (Dialog(group="Chilled water"));

  parameter Modelica.Units.SI.ThermodynamicTemperature THeaWatSup_nominal(displayUnit="degC") = 60+273.15
    "Nominal heating hot water supply temperature"
    annotation (Dialog(group="Heating hot water"));
  parameter Modelica.Units.SI.TemperatureDifference dTHeaWat_nominal = 10
    "Nominal heating hot water temperature difference"
    annotation (Dialog(group="Heating hot water"));
  final parameter Modelica.Units.SI.ThermodynamicTemperature THeaWatRet_nominal = THeaWatSup_nominal - dTHeaWat_nominal
    "Nominal heating hot water supply temperature";
  parameter Modelica.Units.SI.ThermodynamicTemperature tabHeaWatRes[2,2](
    each displayUnit="degC")=
    [-6.7+273.15, THeaWatSup_nominal;
       16+273.15, 30+273.15]
    "Heating hot water supply temperature reset schedule. Don't set below 30 as the isolation valve is open only at 30 degC"
    annotation (Dialog(group="Heating hot water"));
  parameter Modelica.Units.SI.ThermodynamicTemperature THotWatSupTan_nominal(displayUnit="degC") =
    50 + 273.15 "Nominal domestic hot water supply temperature to the tank"
    annotation (Dialog(group="Domestic hot water"));
  parameter Modelica.Units.SI.ThermodynamicTemperature THotWatSupFix_nominal(displayUnit="degC") =
    45 + 273.15 "Nominal domestic hot water supply temperature to the fixture"
    annotation (Dialog(group="Domestic hot water"));
  parameter Modelica.Units.SI.ThermodynamicTemperature TColWat_nominal(displayUnit="degC") =
    15 + 273.15 "Nominal domestic cold water temperature"
    annotation (Dialog(group="Domestic hot water"));
    annotation(defaultComponentName="datBuiSet",
    Documentation(info="<html>
<p>
Unified set point declarations. All buildings use the same set points.
</p>    
</html>"));
end BuildingSetPoints;
