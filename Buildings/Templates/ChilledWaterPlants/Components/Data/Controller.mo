within Buildings.Templates.ChilledWaterPlants.Components.Data;
record Controller "Record for plant controller"
  extends Modelica.Icons.Record;

  // Structure parameters

  parameter Buildings.Templates.ChilledWaterPlants.Types.Controller typ
    "Type of controller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nSenDpChiWatRem = 0
    "Number of remote chilled water differential pressure sensors"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nChi
    "Number of chillers"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_eco=false
    "Set to true if the plant has a Waterside Economizer"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_sendpChiWatLoc = true
    "Set to true if there is a local DP sensor hardwired to the plant controller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_fixSpeConWatPum = false
    "Set to true if the plant has fixed speed condenser water pumps. (Must be false if the plant has Waterside Economizer.)"
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
  parameter Modelica.Units.SI.PressureDifference dpChiWatLoc_max(displayUnit="Pa")
    "Maximum chilled water differential pressure setpoint - Local sensors"
    annotation (Dialog(tab="Chilled water pumps", enable=have_sendpChiWatLoc));
  // FIXME : Hardcoded dpChiWatRem_max size should be nSenDpChiWatRem
  parameter Modelica.Units.SI.PressureDifference dpChiWatRem_max[0](each displayUnit="Pa")
    "Maximum chilled water differential pressure setpoint - Remote sensors"
    annotation (Dialog(tab="Plant Reset", group="Chilled water supply"));

  // FIXME : Hardcoded mChiWatChi_flow_min size should be nChi
  parameter Modelica.Units.SI.MassFlowRate mChiWatChi_flow_min[2]
    "Minimum chiller chilled water mass flow rate (for each chiller)"
    annotation(Dialog(tab="Minimum flow bypass", group="Flow limits"));

  // Guideline36

  // ---- General: Chiller configuration ----

  parameter Modelica.Units.SI.TemperatureDifference dTLif_min(displayUnit="K")=0
    "Minimum allowable lift at minimum load for chiller"
    annotation(Dialog(tab="General", group="Chillers configuration",
      enable=not have_ctrHeaPre and not isAirCoo));
  final parameter Modelica.Units.SI.HeatFlowRate cap_nominal(final min=0)=
    sum(capChi_nominal)
    "Plant design capacity (>0 by convention)"
    annotation (Dialog(tab="General", group="Chillers configuration"));
  // FIXME : Hardcoded capChi_nominal size should be nChi
  parameter Modelica.Units.SI.HeatFlowRate capChi_nominal[2](each final min=0)
    "Design chiller capacities vector"
    annotation (Dialog(tab="General", group="Chillers configuration"));
  parameter Modelica.Units.SI.Temperature TChiWatSup_nominal(displayUnit="degC")
    "Design (minimum) chilled water supply temperature (identical for all chillers)"
    annotation (Dialog(tab="General", group="Chillers configuration"));
  // FIXME : Hardcoded mChiWatChi_flow_nominal size should be nChi
  parameter Modelica.Units.SI.MassFlowRate mChiWatChi_flow_nominal[2]=
    fill(mPri_flow_nominal/nChi,nChi)
    "Design (maximum) chiller chilled water mass flow rate (for each chiller)"
    annotation (Dialog(tab="General", group="Chillers configuration"));

  // ---- Head pressure ----

  parameter Real yPumConWat_min(final unit="1", final min=0, final max=1)
    "Minimum condenser water pump speed ratio"
    annotation(Dialog(enable= not ((not have_eco) and have_fixSpeConWatPum), tab="Head pressure", group="Limits"));

  parameter Real yValIsoCon_min(final unit="1", final min=0, final max=1)
    "Minimum head pressure control valve opening ratio"
    annotation(Dialog(enable= (not ((not have_eco) and (not have_fixSpeConWatPum))), tab="Head pressure", group="Limits"));

  // ---- Chilled water pumps ----

  parameter Real yPumChiWat_min(final unit="1", final min=0, final max=1)
    "Minimum chilled water pump speed ratio"
    annotation (Dialog(tab="Chilled water pumps", group="Speed controller"));
   parameter Modelica.Units.SI.MassFlowRate mPri_flow_nominal
    "Design (maximum) primary chilled water mass flow rate (for the plant)"
    annotation (Dialog(tab="Chilled water pumps", group="Speed controller"));

  // ---- Cooling tower: fan speed ----

  parameter Real yFanTow_min(final unit="1", final min=0, final max=1)
    "Minimum cooling tower fan speed ratio"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed"));

  // Fan speed control: controlling condenser return water temperature when Waterside Economizer is not enabled

  // FIXME: Those parameters should be computed in Buildings.Templates.ChilledWaterPlant.BaseClasses.WaterCooled
  parameter Modelica.Units.SI.Temperature  TConWatSup_nominal(displayUnit="degC")=273.15
    "Condenser Water supply temperature of each chiller (identical for all chillers)"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed: Return temperature control"));

  parameter Real TConWatRet_nominal(displayUnit="degC")=273.15
    "Condenser Water return temperature of each chiller (identical for all chillers)"
    annotation (Dialog(tab="Cooling Towers", group="Fan speed: Return temperature control"));

end Controller;
