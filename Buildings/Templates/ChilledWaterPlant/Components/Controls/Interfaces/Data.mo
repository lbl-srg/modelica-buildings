within Buildings.Templates.ChilledWaterPlant.Components.Controls.Interfaces;
record Data
  extends Modelica.Icons.Record;

  // Structure parameters

  parameter Buildings.Templates.ChilledWaterPlant.Components.Types.Controller typ
    "Type of controller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nSenDpCHWRem = 1
    "Number of remote CHW differential pressure sensors"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nChi
    "Number of chillers"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_WSE=false
    "Set to true if the plant has a WSE"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_senDpCHWLoc = false
    "Set to true if there is a local DP sensor hardwired to the plant controller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_fixSpeConWatPum = false
    "Set to true if the plant has fixed speed CW pumps. (Must be false if the plant has WSE.)"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean isAirCoo=false
    "= true, chillers in group are air cooled, 
    = false, chillers in group are water cooled"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_ctrHeaPre = false
    "Set to true if head pressure control available from chiller controller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  // Equipment characteristics

  parameter Modelica.Units.SI.Temperature TAirOutLoc(displayUnit="degC")
    "Outdoor air lockout temperature below which the chiller plant should be disabled"
    annotation(Dialog(tab="Plant enable"));
  parameter Modelica.Units.SI.PressureDifference dpCHWLoc_max(displayUnit="Pa")
    "Maximum CHW differential pressure setpoint - Local sensors"
    annotation (Dialog(tab="Chilled water pumps", enable=have_senDpCHWLoc));
  parameter Modelica.Units.SI.PressureDifference dpCHWRem_max[nSenDpCHWRem](each displayUnit="Pa")
    "Maximum CHW differential pressure setpoint - Remote sensors"
    annotation (Dialog(tab="Plant Reset", group="Chilled water supply"));

  parameter Modelica.Units.SI.MassFlowRate mCHWChi_flow_min[nChi]
    "Minimum chiller CHW mass flow rate (for each chiller)"
    annotation(Dialog(tab="Minimum flow bypass", group="Flow limits"));

  // Guideline36

  // ---- General: Chiller configuration ----

  parameter Modelica.Units.SI.TemperatureDifference dTLif_min(displayUnit="K")=0
    "Minimum allowable lift at minimum load for chiller"
    annotation(Dialog(tab="General", group="Chillers configuration",
      enable=not have_ctrHeaPre and not isAirCoo));

  // ---- Head pressure ----

  parameter Real yPumCW_min(final unit="1", final min=0, final max=1)
    "Minimum CW pump speed ratio"
    annotation(Dialog(enable= not ((not have_WSE) and have_fixSpeConWatPum), tab="Head pressure", group="Limits"));

  parameter Real yValIsoCon_min(final unit="1", final min=0, final max=1)
    "Minimum head pressure control valve opening ratio"
    annotation(Dialog(enable= (not ((not have_WSE) and (not have_fixSpeConWatPum))), tab="Head pressure", group="Limits"));

  // ---- Chilled water pumps ----

  parameter Real yPumCHW_min(final unit="1", final min=0, final max=1)
    "Minimum CHW pump speed ratio"
    annotation (Dialog(tab="Chilled water pumps", group="Speed controller"));

  // ---- Cooling tower: fan speed ----

  parameter Real yFanTow_min(final unit="1", final min=0, final max=1)
    "Minimum cooling tower fan speed ratio"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed"));

  // Fan speed control: controlling condenser return water temperature when WSE is not enabled

  // FIXME: Those parameters should be computed in Buildings.Templates.ChilledWaterPlant.BaseClasses.WaterCooled
  parameter Modelica.Units.SI.Temperature  TCWSup_nominal(displayUnit="degC")=273.15
    "CW supply temperature of each chiller (identical for all chillers)"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed: Return temperature control"));

  parameter Real TCWRet_nominal(displayUnit="degC")=273.15
    "CW return temperature of each chiller (identical for all chillers)"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed: Return temperature control"));

end Data;
