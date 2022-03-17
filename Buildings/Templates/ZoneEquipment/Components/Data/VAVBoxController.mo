within Buildings.Templates.ZoneEquipment.Components.Data;
record VAVBoxController "Record for VAV terminal unit controller"
  extends Buildings.Templates.ZoneEquipment.Components.Data.PartialController;

  parameter Boolean have_CO2Sen
    "Set to true if the zone has CO2 sensor"
    annotation (Dialog(group="Configuration", enable=false));

  parameter Modelica.Units.SI.Temperature TZonHeaOccSet(
    final min=273.15,
    displayUnit="degC")=21+273.15
    "Zone occupied heating temperature set point"
    annotation(Dialog(group="Temperature",
    enable=typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat));

  parameter Modelica.Units.SI.Temperature TZonHeaUnoSet(
    final min=273.15,
    displayUnit="degC")=16+273.15
    "Zone unoccupied heating temperature set point"
    annotation(Dialog(group="Temperature",
    enable=typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat));

  parameter Modelica.Units.SI.Temperature TZonCooOccSet(
    final min=273.15,
    displayUnit="degC")=24+273.15
    "Zone occupied cooling temperature set point"
    annotation(Dialog(group="Temperature",
    enable=typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat));

  parameter Modelica.Units.SI.Temperature TZonCooUnoSet(
    final min=273.15,
    displayUnit="degC")=32+273.15
    "Zone unoccupied cooling temperature set point"
    annotation(Dialog(group="Temperature",
    enable=typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat));

  parameter Modelica.Units.SI.TemperatureDifference dTAirDisHea_max(
    final min=0,
    displayUnit="K")=11
    "Zone maximum discharge air temperature above heating set point"
    annotation (Dialog(group="Temperature",
    enable=typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat));

  // FIXME #1913: not in §3.1.2.2 VAV Reheat Terminal Unit
  parameter Modelica.Units.SI.Temperature TAirDis_min(
    final min=273.15,
    displayUnit="degC")=12 + 273.15
    "Zone minimum discharge air temperature"
    annotation (Dialog(group="Temperature",
    enable=typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat));

  parameter Modelica.Units.SI.VolumeFlowRate VAirCooSet_flow_max(
    final min=0,
    start=1)
    "Zone maximum cooling airflow set point"
    annotation (Dialog(group="Airflow"));

  parameter Modelica.Units.SI.VolumeFlowRate VAirSet_flow_min(
    final min=0,
    start=0.1 * VAirCooSet_flow_max)
    "Zone minimum airflow set point"
    annotation (Dialog(group="Airflow"));

  parameter Modelica.Units.SI.VolumeFlowRate VAirHeaSet_flow_max(
    final min=0,
    start=0.3 * VAirCooSet_flow_max)
    "Zone maximum heating airflow set point"
    annotation (Dialog(group="Airflow",
    enable=typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat));

  parameter Modelica.Units.SI.VolumeFlowRate VAirHeaSet_flow_min(
    final min=0)=0
    "Zone minimum heating airflow set point"
    annotation (Dialog(group="Airflow",
    enable=typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat));

  final parameter Modelica.Units.SI.VolumeFlowRate VAir_flow_nominal=
    max(VAirCooSet_flow_max, VAirHeaSet_flow_max)
    "Zone design volume flow rate"
    annotation (Dialog(group="Airflow"));

  parameter Real VOutPerAre_flow(
    final unit = "m3/(s.m2)",
    final min=0)=3e-4
    "Zone outdoor air flow rate per unit area"
    annotation(Dialog(group="Ventilation",
    enable=typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat));

  parameter Real VOutPerPer_flow(
    final unit = "m3/s",
    final min=0)=2.5e-3
    "Zone outdoor air flow rate per person"
    annotation(Dialog(group="Ventilation",
    enable=typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat));

  parameter Modelica.Units.SI.Area AFlo(
    final min=0,
    start=10)
    "Zone floor area"
    annotation(Dialog(group="Ventilation",
    enable=typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat));

  parameter Real nPeo_nominal(
    final unit="1",
    final min=0,
    start=0.05 * AFlo)
    "Zone design population (without diversity)"
    annotation(Dialog(group="Ventilation",
    enable=typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat));

  parameter Real effAirDisHea(
    final unit = "1",
    final min=0,
    final max=1)=0.8
    "Zone air distribution effectiveness during heating"
    annotation(Dialog(group="Ventilation",
    enable=typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat));

  parameter Real effAirDisCoo(
    final unit = "1",
    final min=0,
    final max=1)=1.0
    "Zone air distribution effectiveness during cooling"
    annotation(Dialog(group="Ventilation",
    enable=typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat));

  parameter Real CO2Set(
    final min=0)=894
    "CO2 set point"
    annotation (Dialog(group="Ventilation",
    enable=typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat and
    have_CO2Sen));

end VAVBoxController;
