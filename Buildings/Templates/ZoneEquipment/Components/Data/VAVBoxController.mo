within Buildings.Templates.ZoneEquipment.Components.Data;
record VAVBoxController "Record for VAV terminal unit controller"
  extends Buildings.Templates.ZoneEquipment.Components.Data.PartialController;

  parameter Modelica.Units.SI.VolumeFlowRate VOutMinOcc_flow(
    final min=0,
    start=1)
    "Zone minimum outdoor airflow for occupants"
    annotation (Dialog(group="Ventilation", enable=
      (typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat or
      typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxCoolingOnly) and
      stdVen==Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016));
  parameter Modelica.Units.SI.VolumeFlowRate VOutMinAre_flow(
    final min=0,
    start=1)
    "Zone minimum outdoor airflow for building area"
    annotation (Dialog(group="Ventilation", enable=
      (typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat or
      typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxCoolingOnly) and
      stdVen==Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016));
  parameter Real VOutAre_flow(
    final unit = "m3/s",
    final min=0)
    "Area component of the breathing zone outdoor airflow"
    annotation(Dialog(group="Ventilation",
    enable=(typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat or
    typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxCoolingOnly) and
    stdVen==Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1_2016));
  parameter Real VOutOcc_flow(
    final unit = "m3/s",
    final min=0)
    "Population component of the breathing zone outdoor airflow"
    annotation(Dialog(group="Ventilation",
    enable=(typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat or
    typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxCoolingOnly) and
    stdVen==Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1_2016));
  parameter Real effAirDisHea(
    final unit="1",
    final min=0,
    final max=1)=0.8
    "Zone air distribution effectiveness during heating"
    annotation(Dialog(group="Ventilation",
    enable=(typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat or
    typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxCoolingOnly) and
    stdVen==Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1_2016));
  parameter Real effAirDisCoo(
    final unit="1",
    final min=0,
    final max=1)=1.0
    "Zone air distribution effectiveness during cooling"
    annotation(Dialog(group="Ventilation",
    enable=(typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat or
    typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxCoolingOnly) and
    stdVen==Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1_2016));

  parameter Modelica.Units.SI.Temperature TZonHeaOccSet(
    final min=273.15,
    displayUnit="degC")=21+273.15
    "Zone occupied heating temperature set point"
    annotation(Dialog(group="Temperature",
    enable=(typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat or
    typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxCoolingOnly)));
  parameter Modelica.Units.SI.Temperature TZonHeaUnoSet(
    final min=273.15,
    displayUnit="degC")=16+273.15
    "Zone unoccupied heating temperature set point"
    annotation(Dialog(group="Temperature",
    enable=(typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat or
    typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxCoolingOnly)));
  parameter Modelica.Units.SI.Temperature TZonCooOccSet(
    final min=273.15,
    displayUnit="degC")=24+273.15
    "Zone occupied cooling temperature set point"
    annotation(Dialog(group="Temperature",
    enable=(typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat or
    typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxCoolingOnly)));
  parameter Modelica.Units.SI.Temperature TZonCooUnoSet(
    final min=273.15,
    displayUnit="degC")=32+273.15
    "Zone unoccupied cooling temperature set point"
    annotation(Dialog(group="Temperature",
    enable=(typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat or
    typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxCoolingOnly)));
  parameter Modelica.Units.SI.TemperatureDifference dTAirDisHea_max(
    final min=0,
    displayUnit="K")=11
    "Zone maximum discharge air temperature above heating set point"
    annotation (Dialog(group="Temperature",
    enable=typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat));

  parameter Modelica.Units.SI.VolumeFlowRate VAirCooSet_flow_max(
    final min=0,
    start=1)
    "Zone maximum cooling airflow set point"
    annotation (Dialog(group="Airflow"));

  /* FIXME #1913: This should be an optional entry. If no value is scheduled,
  Vmin should be calculated automatically and dynamically to meet ventilation requirements.
  */
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
    enable=(typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxCoolingOnly or
    typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat)));

  parameter Modelica.Units.SI.VolumeFlowRate VAirHeaSet_flow_min(
    final min=0)=0
    "Zone minimum heating airflow set point"
    annotation (Dialog(group="Airflow",
    enable=typ==Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxReheat));
  annotation (Documentation(info="<html>
<p>
This record provides the set of sizing and operating parameters for 
VAV box controllers within 
<a href=\"modelica://Buildings.Templates.ZoneEquipment.Components.Controls\">
Buildings.Templates.ZoneEquipment.Components.Controls</a>.
</p>
</html>"));
end VAVBoxController;
