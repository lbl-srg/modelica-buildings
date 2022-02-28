within Buildings.Templates.AirHandlersFans.Components.Controls.Interfaces;
record DataVAVMultiZone
  extends Buildings.Templates.AirHandlersFans.Components.Controls.Interfaces.Data;

  parameter Buildings.Templates.AirHandlersFans.Types.ReliefReturnSection typSecRel
    "Relief/return air section type"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns minOADes
    "Design of minimum outdoor air and economizer function"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes buiPreCon
    "Type of building pressure control system"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Modelica.Units.SI.PressureDifference pAirSupSet_rel_max = 500
    "Maximum supply duct static pressure set point"
    annotation (Dialog(tab="Fan speed",
    group="Trim and respond for reseting duct static pressure set point",
    enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone));

  parameter Modelica.Units.SI.PressureDifference pAirRetSet_rel_min(
    final min=2.4, start=10) = 10
    "Return fan minimum discharge static pressure set point"
    annotation (Dialog(tab="Pressure control", group="Return fan",
      enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
      buiPreCon==Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp));

  parameter Modelica.Units.SI.PressureDifference pAirRetSet_rel_max(
    final min=pAirRetSet_rel_min+1, start=100) = 100
    "Return fan maximum discharge static pressure set point"
    annotation (Dialog(tab="Pressure control", group="Return fan",
      enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
      buiPreCon==Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp));

  parameter Real ySpeFanSup_min(final unit="1", final min=0, final max=1, start=0.1)= 0.1
    "Lowest allowed fan speed if fan is on"
    annotation (Dialog(group="Fan speed PID controller",
    enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone));

  parameter Real nPeaSys_nominal(final unit="1", final min=0)=100
    "Peak system population"
    annotation (Dialog(tab="Minimum outdoor airflow rate", group="Nominal conditions",
    enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone));

  parameter Modelica.Units.SI.Temperature TAirSupSet_min(
    displayUnit="degC")=13+273.15
    "Lowest supply air temperature set point"
    annotation (Dialog(tab="Supply air temperature", group="Temperature limits",
    enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone));

  parameter Modelica.Units.SI.Temperature TAirSupSet_max(
    displayUnit="degC")=18+273.15
    "Highest supply air temperature set point"
    annotation (Dialog(tab="Supply air temperature", group="Temperature limits",
    enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone));

  parameter Modelica.Units.SI.Temperature TAirOutRes_min(
    displayUnit="degC")=16+273.15
    "Lowest outdoor air temperature reset range"
    annotation (Dialog(tab="Supply air temperature", group="Temperature limits",
    enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone));

  parameter Modelica.Units.SI.Temperature TAirOutRes_max(
    displayUnit="degC")=21+273.15
    "Highest outdoor air temperature reset range"
    annotation (Dialog(tab="Supply air temperature", group="Temperature limits",
    enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone));

  parameter Modelica.Units.SI.PressureDifference pAirBuiSet_rel(start=12)=12
    "Building static pressure set point"
    annotation (Dialog(tab="Pressure control",
      enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
      (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper
       or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
       or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)));

  parameter Real ySpeFanRet_min(final unit="1", final min=0, final max=1, start=0.1)=0.1
    "Minimum relief/return fan speed"
    annotation (Dialog(tab="Pressure control", group="Relief fans",
      enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
      typSecRel<>Buildings.Templates.AirHandlersFans.Types.ReliefReturnSection.NoRelief));

  parameter Modelica.Units.SI.PressureDifference dpDamOutMin_nominal=15
    "Design minimum outdoor air damper differential pressure"
    annotation (Dialog(tab="Economizer", group="Limits, separated with DP",
      enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
      minOADes==Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.SeparateDamper_DP));

  parameter Modelica.Units.SI.VolumeFlowRate dVFanRet_flow=0.1
    "Airflow differential between supply and return fans to maintain building pressure at set point"
    annotation (Dialog(tab="Pressure control", group="Return fan",
      enable=typ==Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone and
      buiPreCon==Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanAir));

end DataVAVMultiZone;
