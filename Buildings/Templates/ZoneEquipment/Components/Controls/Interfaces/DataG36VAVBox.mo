within Buildings.Templates.ZoneEquipment.Components.Controls.Interfaces;
record DataG36VAVBox
  extends Buildings.Templates.ZoneEquipment.Components.Controls.Interfaces.Data;

  parameter Boolean have_CO2Sen
    "Set to true if the zone has CO2 sensor"
    annotation (Dialog(group="Configuration", enable=false));

  parameter Modelica.Units.SI.Temperature TAirZonHeaOccSet(
    displayUnit="degC",
    final min=273.15,
    start=20+273.15)=21+273.15
    "Zone occupied heating temperature set point"
    annotation(Dialog(group="Temperature",
    enable=typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat));

  parameter Modelica.Units.SI.Temperature TAirZonHeaUnoSet(
    displayUnit="degC",
    final min=273.15,
    start=12+273.15)=16+273.15
    "Zone unoccupied heating temperature set point"
    annotation(Dialog(group="Temperature",
    enable=typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat));

  parameter Modelica.Units.SI.Temperature TAirZonCooOccSet(
    displayUnit="degC",
    final min=273.15,
    start=24+273.15)=24+273.15
    "Zone occupied cooling temperature set point"
    annotation(Dialog(group="Temperature",
    enable=typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat));

  parameter Modelica.Units.SI.Temperature TAirZonCooUnoSet(
    displayUnit="degC",
    final min=273.15,
    start=30+273.15)=32+273.15
    "Zone unoccupied cooling temperature set point"
    annotation(Dialog(group="Temperature",
    enable=typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat));

  parameter Modelica.Units.SI.TemperatureDifference dTAirDisHea_max(
    displayUnit="K",
    final min=0,
    final max=50,
    start=11) = 11
    "Zone maximum discharge air temperature above heating set point"
    annotation (Dialog(group="Temperature",
    enable=typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat));

  // FIXME: not in §3.1.2.2 VAV Reheat Terminal Unit
  parameter Modelica.Units.SI.Temperature TAirDis_min(
    displayUnit = "degC",
    final min=273.15,
    final max=50+273.15,
    start=12+273.15)=12 + 273.15
    "Zone minimum discharge air temperature"
    annotation (Dialog(group="Temperature",
    enable=typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat));

  parameter Modelica.Units.SI.VolumeFlowRate VAirCooSet_flow_max(final min=0)=
    1
    "Zone maximum cooling airflow set point"
    annotation (Dialog(group="Airflow",
    enable=typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat));

  parameter Modelica.Units.SI.VolumeFlowRate VAirSet_flow_min(final min=0)=
    0.1 * VAirCooSet_flow_max
    "Zone minimum airflow set point"
    annotation (Dialog(group="Airflow"));

  parameter Modelica.Units.SI.VolumeFlowRate VAirHeaSet_flow_max(final min=0)=
    0.3 * VAirCooSet_flow_max
    "Zone maximum heating airflow set point"
    annotation (Dialog(group="Airflow",
    enable=typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat));

  parameter Modelica.Units.SI.VolumeFlowRate VAirHeaSet_flow_min(final min=0, start=0)=
    0
    "Zone minimum heating airflow set point"
    annotation (Dialog(group="Airflow",
    enable=typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat));

  final parameter Modelica.Units.SI.VolumeFlowRate VAir_flow_nominal=
    max(VAirCooSet_flow_max, VAirHeaSet_flow_max)
    "Zone design volume flow rate"
    annotation (Dialog(group="Airflow",
    enable=typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat));

  parameter Real VAirOutPerAre_flow(
    final unit = "m3/(s.m2)", final min=0, start=3e-4)=3e-4
    "Zone outdoor air flow rate per unit area"
    annotation(Dialog(group="Ventilation",
    enable=typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat));

  parameter Real VAirOutPerPer_flow(
    final unit = "m3/s", final min=0, start=2.5e-3)=2.5e-3
    "Zone outdoor air flow rate per person"
    annotation(Dialog(group="Ventilation",
    enable=typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat));

  parameter Modelica.Units.SI.Area AFlo(final min=0)=10
    "Zone floor area"
    annotation(Dialog(group="Ventilation",
    enable=typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat));

  parameter Real nPeo_nominal(final unit="1", final min=0, start=0.05 * AFlo)=
    0.05 * AFlo
    "Zone design population (without diversity)"
    annotation(Dialog(group="Ventilation",
    enable=typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat));

  parameter Real effAirDisHea(final unit = "1", final min=0, final max=1, start=0.8)=
    0.8
    "Zone air distribution effectiveness during heating"
    annotation(Dialog(group="Ventilation",
    enable=typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat));

  parameter Real effAirDisCoo(final unit = "1", final min=0, final max=1, start=1.0)=
    1.0
    "Zone air distribution effectiveness during cooling"
    annotation(Dialog(group="Ventilation",
    enable=typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat));

  parameter Real CO2Set(final min=0, start=894)=894
    "CO2 set point"
    annotation (Dialog(group="Ventilation",
    enable=typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat and
    have_CO2Sen));

end DataG36VAVBox;
