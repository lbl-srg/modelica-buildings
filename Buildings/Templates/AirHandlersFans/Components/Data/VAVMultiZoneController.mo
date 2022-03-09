within Buildings.Templates.AirHandlersFans.Components.Data;
record VAVMultiZoneController "Record for Multiple-zone VAV controller"
  extends Buildings.Templates.AirHandlersFans.Components.Data.PartialController;

  parameter Buildings.Templates.AirHandlersFans.Types.ReliefReturnSection typSecRel
    "Relief/return air section type"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns minOADes
    "Design of minimum outdoor air and economizer function"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes buiPreCon
    "Type of building pressure control system"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Modelica.Units.SI.PressureDifference pAirSupSet_rel_max(
    final min=0,
    displayUnit="Pa",
    start=500)
    "Duct design maximum static pressure"
    annotation (Dialog(group="Airflow and pressure",
    enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone));

  parameter Modelica.Units.SI.PressureDifference pAirRetSet_rel_min(
    final min=2.4,
    displayUnit="Pa") = 10
    "Return fan minimum discharge static pressure set point"
    annotation (Dialog(group="Airflow and pressure",
      enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
      buiPreCon==Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp));

  parameter Modelica.Units.SI.PressureDifference pAirRetSet_rel_max(
    final min=10,
    displayUnit="Pa") = 100
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

  parameter Modelica.Units.SI.PressureDifference dpDamOutMin_nominal(
    final min=0,
    displayUnit="Pa",
    start=15)
    "Design minimum outdoor air damper differential pressure"
    annotation (Dialog(group="Airflow and pressure",
      enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
      minOADes==Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.SeparateDamper_DP));

  parameter Modelica.Units.SI.PressureDifference pAirBuiSet_rel(
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
      buiPreCon==Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanAir));

  parameter Real nPeaSys_nominal(
    final unit="1",
    final min=0,
    start=100)
    "Design system population (including diversity)"
    annotation (Dialog(group="Ventilation",
    enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone));

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

  parameter Modelica.Units.SI.Temperature TAirOutRes_min(
    final min=273.15,
    displayUnit="degC")=16+273.15
    "Lowest value of the outdoor air temperature reset range"
    annotation (Dialog(group="Supply air temperature",
    enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone));

  parameter Modelica.Units.SI.Temperature TAirOutRes_max(
    final min=273.15,
    displayUnit="degC")=21+273.15
    "Highest value of the outdoor air temperature reset range"
    annotation (Dialog(group="Supply air temperature",
    enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone));

end VAVMultiZoneController;
