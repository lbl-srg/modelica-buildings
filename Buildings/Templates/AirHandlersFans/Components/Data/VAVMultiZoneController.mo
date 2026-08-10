within Buildings.Templates.AirHandlersFans.Components.Data;
record VAVMultiZoneController "Record for multiple-zone VAV controller"
  extends Buildings.Templates.AirHandlersFans.Components.Data.PartialController;

  /* HACK(AntoineGautier):
   * Default bindings are required for the array parameters below for the case 
   * where typ<>G36VAVMultiZone and these parameters are left unassigned in 
   * the instantiated record.
   * When using instead 'each start = ""':
   * - Dymola -> "Failed to expand the variable"
   * - OCT    -> "Can not determine array size of variable"
   * When using instead 'start = {""}' or 'start = fill("", n)' where n is
   * itself declared with enable and start attribute:
   * - Dymola -> "Incompatible sizes for variable and its start value" if
   *             size of assignment differs in instance.
   * - OCT    -> "Can not determine array size of variable"
   */
  parameter String idZon[:](each start="") = {""}
    "Zone (or terminal unit) names"
    annotation(
      Dialog(group="Zoning",
        enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone));

  parameter String namGro[:](each start="") = {""}
    "Name of zone groups"
    annotation (
      Dialog(group="Zoning",
        enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone));

  parameter String namGroZon[:](each start="") = {""}
    "Name of group which each zone belongs to"
    annotation(
      Dialog(group="Zoning",
        enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone));

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection typSecOut
    "Type of outdoor air section"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.PressureControl buiPreCon
    "Type of building pressure control system"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard stdVen
    "Ventilation standard"
    annotation(Evaluate=true, Dialog(group="Energy and ventilation standards", enable=false));

  parameter Modelica.Units.SI.Temperature TAirSupSet_min(
    min=273.15,
    displayUnit="degC")=285.15
    "Lowest supply air temperature setpoint"
    annotation (Dialog(group="Temperature setpoints",
    enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone));

  parameter Modelica.Units.SI.Temperature TAirSupSet_max(
    min=273.15,
    displayUnit="degC")=291.15
    "Highest supply air temperature setpoint"
    annotation (Dialog(group="Temperature setpoints",
    enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone));

  parameter Modelica.Units.SI.Temperature TOutRes_min(
    min=273.15,
    displayUnit="degC")=289.15
    "Lowest value of the outdoor air temperature reset range"
    annotation (Dialog(group="Temperature setpoints",
    enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone));

  parameter Modelica.Units.SI.Temperature TOutRes_max(
    min=273.15,
    displayUnit="degC")=294.15
    "Highest value of the outdoor air temperature reset range"
    annotation (Dialog(group="Temperature setpoints",
    enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone));

  parameter Modelica.Units.SI.VolumeFlowRate VOutUnc_flow_nominal(start=0)
    "Uncorrected design outdoor air flow rate, including diversity where applicable"
    annotation (Dialog(group="Ventilation setpoints",
      enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
      stdVen==Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1));
  parameter Modelica.Units.SI.VolumeFlowRate VOutTot_flow_nominal(start=0)
    "Design total outdoor air flow rate"
    annotation (Dialog(group="Ventilation setpoints",
      enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
      stdVen==Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1));
  parameter Modelica.Units.SI.VolumeFlowRate VOutAbsMin_flow_nominal(start=0)
    "Design outdoor air flow rate when all zones with CO2 sensors or occupancy sensors are unpopulated"
    annotation (Dialog(group="Ventilation setpoints",
      enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
      stdVen==Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24));
  parameter Modelica.Units.SI.VolumeFlowRate VOutMin_flow_nominal(start=0)
    "Design minimum outdoor air flow rate when all zones are occupied at their design population, including diversity"
    annotation (Dialog(group="Ventilation setpoints",
      enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
      stdVen==Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24));

  parameter Modelica.Units.SI.PressureDifference pAirSupSet_rel_max(
    min=0,
    start=500,
    displayUnit="Pa")
    "Duct design maximum static pressure"
    annotation (Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone));
  parameter Modelica.Units.SI.PressureDifference dpDamOutMinAbs(
    min=2.4,
    start=5,
    displayUnit="Pa")
    "Differential pressure across the minimum outdoor air damper that provides the absolute minimum outdoor airflow"
    annotation (Dialog(group="Information provided by testing, adjusting, and balancing contractor",
      enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
        stdVen==Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24
        and typSecOut == Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure));
  parameter Modelica.Units.SI.PressureDifference dpDamOutMin_nominal(
    min=5,
    start=15,
    displayUnit="Pa")
    "Differential pressure across the minimum outdoor air damper that provides the design minimum outdoor airflow"
    annotation (Dialog(group="Information provided by testing, adjusting, and balancing contractor",
      enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
        typSecOut==Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersPressure));

  parameter Modelica.Units.SI.PressureDifference pAirRetSet_rel_min(
    min=2.4,
    displayUnit="Pa")=10
    "Return fan minimum discharge static pressure setpoint"
    annotation (Dialog(group="Information provided by testing, adjusting, and balancing contractor",
      enable=typ == Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone
           and buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.PressureControl.ReturnFanDp));

  parameter Modelica.Units.SI.PressureDifference pAirRetSet_rel_max(
    min=10,
    displayUnit="Pa")=40
    "Return fan maximum discharge static pressure setpoint"
    annotation (Dialog(group="Information provided by testing, adjusting, and balancing contractor",
      enable=typ == Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone
           and buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.PressureControl.ReturnFanDp));

  parameter Modelica.Units.SI.VolumeFlowRate dVFanRet_flow(min=0, start=0.1)
    "Airflow differential between supply and return fans to maintain building pressure at setpoint"
    annotation (Dialog(group="Information provided by testing, adjusting, and balancing contractor",
      enable=typ == Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone
           and buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.PressureControl.ReturnFanMeasuredAir));

  parameter Real yFanSup_min(
    max=1,
    min=0,
    unit="1")=0.1
    "Lowest allowed fan speed if fan is on"
    annotation (Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
    typFanSup<>Buildings.Templates.Components.Types.Fan.None));

  parameter Real yFanRel_min(
    max=1,
    min=0,
    unit="1")=0.1
    "Minimum relief fan speed"
    annotation (Dialog(group="Information provided by testing, adjusting, and balancing contractor",
      enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
      typFanRel<>Buildings.Templates.Components.Types.Fan.None));

  parameter Real yFanRet_min(
    max=1,
    min=0,
    unit="1")=0.1
    "Minimum return fan speed"
    annotation (Dialog(group="Information provided by testing, adjusting, and balancing contractor",
      enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
      typFanRet<>Buildings.Templates.Components.Types.Fan.None));

  annotation (Documentation(info="<html>
<p>
This record provides the set of sizing and operating parameters for
multiple-zone VAV controllers within
<a href=\"modelica://Buildings.Templates.AirHandlersFans.Components.Controls\">
Buildings.Templates.AirHandlersFans.Components.Controls</a>.
</p>
</html>"));
end VAVMultiZoneController;
