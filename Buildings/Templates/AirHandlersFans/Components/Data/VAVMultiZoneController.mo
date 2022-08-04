within Buildings.Templates.AirHandlersFans.Components.Data;
record VAVMultiZoneController "Record for multiple-zone VAV controller"
  extends Buildings.Templates.AirHandlersFans.Components.Data.PartialController;

  parameter Buildings.Templates.AirHandlersFans.Types.ReliefReturnSection typSecRel
    "Relief/return air section type"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorSection typSecOut
    "Type of outdoor air section"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes buiPreCon
    "Type of building pressure control system"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard stdEne
    "Energy standard, ASHRAE 90.1 or Title 24"
    annotation(Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard stdVen
    "Ventilation standard, ASHRAE 62.1 or Title 24"
    annotation(Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Boolean have_CO2Sen
    "Set to true if there are zones with CO2 sensor"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Modelica.Units.SI.VolumeFlowRate VOutUnc_flow_nominal(
    start=0)
    "Uncorrected design outdoor air flow rate, including diversity where applicable"
    annotation (Dialog(group="Airflow and pressure",
      enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
      stdVen==Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1_2016));
  parameter Modelica.Units.SI.VolumeFlowRate VOutTot_flow_nominal(
    start=0)
    "Design total outdoor air flow rate"
    annotation (Dialog(group="Airflow and pressure",
      enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
      stdVen==Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1_2016));
  parameter Modelica.Units.SI.VolumeFlowRate VOutAbsMin_flow_nominal(
    start=0)
    "Design outdoor air flow rate when all zones with CO2 sensors or occupancy sensors are unpopulated"
    annotation (Dialog(group="Airflow and pressure",
      enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
      stdVen==Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016));
  parameter Modelica.Units.SI.VolumeFlowRate VOutMin_flow_nominal(
    start=0)
    "Design minimum outdoor air flow rate when all zones are occupied at their design population, including diversity"
    annotation (Dialog(group="Airflow and pressure",
      enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
      stdVen==Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016));

  parameter Modelica.Units.SI.PressureDifference dpDamOutMinAbs(
    final min=2.4,
    displayUnit="Pa",
    start=5)
    "Differential pressure across the minimum outdoor air damper that provides the absolute minimum outdoor airflow"
    annotation (Dialog(group="Airflow and pressure",
      enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
        stdVen==Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016
        and typSecOut == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorSection.DedicatedDampersPressure));
  parameter Modelica.Units.SI.PressureDifference dpDamOutMin_nominal(
    final min=5,
    displayUnit="Pa",
    start=15)
    "Differential pressure across the minimum outdoor air damper that provides the design minimum outdoor airflow"
    annotation (Dialog(group="Airflow and pressure",
      enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
        typSecOut==Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorSection.DedicatedDampersPressure));

  parameter Modelica.Units.SI.PressureDifference pAirSupSet_rel_max(
    final min=0,
    displayUnit="Pa",
    start=500)
    "Duct design maximum static pressure"
    annotation (Dialog(group="Airflow and pressure",
    enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone));

  parameter Modelica.Units.SI.PressureDifference pAirRetSet_rel_min(
    final min=2.4,
    displayUnit="Pa")=10
    "Return fan minimum discharge static pressure set point"
    annotation (Dialog(group="Airflow and pressure",
      enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
      buiPreCon==Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp));

  parameter Modelica.Units.SI.PressureDifference pAirRetSet_rel_max(
    final min=10,
    displayUnit="Pa")=40
    "Return fan maximum discharge static pressure set point"
    annotation (Dialog(group="Airflow and pressure",
      enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
      buiPreCon==Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp));

  parameter Real yFanSup_min(
    final unit="1",
    final min=0,
    final max=1)= 0.1
    "Lowest allowed fan speed if fan is on"
    annotation (Dialog(group="Airflow and pressure",
    enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
    typFanSup<>Buildings.Templates.Components.Types.Fan.None));

  parameter Real yFanRel_min(
    final unit="1",
    final min=0,
    final max=1)=0.1
    "Minimum relief fan speed"
    annotation (Dialog(group="Airflow and pressure",
      enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
      typFanRel<>Buildings.Templates.Components.Types.Fan.None));

  parameter Real yFanRet_min(
    final unit="1",
    final min=0,
    final max=1)=0.1
    "Minimum return fan speed"
    annotation (Dialog(group="Airflow and pressure",
      enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
      typFanRet<>Buildings.Templates.Components.Types.Fan.None));

  parameter Modelica.Units.SI.PressureDifference pBuiSet_rel(
    final min=0,
    displayUnit="Pa")=12
    "Building static pressure set point"
    annotation (Dialog(group="Airflow and pressure",
      enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
      (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper
        or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
        or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)));

  parameter Modelica.Units.SI.VolumeFlowRate dVFanRet_flow(
    final min=0,
    start=0.1)
    "Airflow differential between supply and return fans to maintain building pressure at set point"
    annotation (Dialog(group="Airflow and pressure",
      enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
      (buiPreCon==Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir or
      buiPreCon==Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanCalculatedAir)));

  parameter Modelica.Units.SI.Temperature TAirSupSet_min(
    final min=273.15,
    displayUnit="degC")=12+273.15
    "Lowest supply air temperature set point"
    annotation (Dialog(group="Supply air temperature",
    enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone));

  parameter Modelica.Units.SI.Temperature TAirSupSet_max(
    final min=273.15,
    displayUnit="degC")=18+273.15
    "Highest supply air temperature set point"
    annotation (Dialog(group="Supply air temperature",
    enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone));

  parameter Modelica.Units.SI.Temperature TOutRes_min(
    final min=273.15,
    displayUnit="degC")=16+273.15
    "Lowest value of the outdoor air temperature reset range"
    annotation (Dialog(group="Supply air temperature",
    enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone));

  parameter Modelica.Units.SI.Temperature TOutRes_max(
    final min=273.15,
    displayUnit="degC")=21+273.15
    "Highest value of the outdoor air temperature reset range"
    annotation (Dialog(group="Supply air temperature",
    enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone));

  annotation (Documentation(info="<html>
<p>
This record provides the set of sizing and operating parameters for 
multiple-zone VAV controllers within
<a href=\"modelica://Buildings.Templates.AirHandlersFans.Components.Controls\">
Buildings.Templates.AirHandlersFans.Components.Controls</a>.
</p>
</html>"));
end VAVMultiZoneController;
