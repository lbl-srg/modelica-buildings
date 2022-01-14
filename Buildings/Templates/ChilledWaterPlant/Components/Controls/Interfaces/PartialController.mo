within Buildings.Templates.ChilledWaterPlant.Components.Controls.Interfaces;
block PartialController "Partial controller for CHW plant"

  parameter Buildings.Templates.ChilledWaterPlant.Components.Types.Controller typ
    "Type of controller"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  outer parameter String id
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file";
  outer replaceable Buildings.Templates.ChilledWaterPlant.Components.CoolingTowerGroup.Interfaces.PartialCoolingTowerGroup
    cooTow "Cooling towers";
  outer replaceable Buildings.Templates.ChilledWaterPlant.Components.ReturnSection.Interfaces.PartialReturnSection
    retSec "CHW return section";

  parameter Integer nChi
    "Number of chillers";
  parameter Integer nPumPri
    "Number of primary pumps";
  parameter Integer nPumSec
    "Number of secondary pumps";
  parameter Integer nPumCon = 0
    "Number of condenser pumps"
    annotation(Dialog(enable=not isAirCoo));
  parameter Integer nCooTow = 0
    "Number of cooling towers"
    annotation(Dialog(enable=not isAirCoo));
  parameter Boolean isAirCoo
    "Set to true if chillers are air cooled, false if chillers are water cooled";
  parameter Boolean have_WSE
    "Set to true if the plant has a WSE";
  parameter Boolean have_parChi
    "Set to true if the plant has parallel chillers";
  final parameter Modelica.Units.SI.HeatFlowRate cap_nominal(final min=0)=
    sum(capChi_nominal)
    "Plant design capacity (>0 by convention)"
    annotation (Dialog(tab="General", group="Chillers configuration"));
  parameter Modelica.Units.SI.HeatFlowRate capChi_nominal[nChi](each final min=0)
    "Design chiller capacities vector"
    annotation (Dialog(tab="General", group="Chillers configuration"));
  parameter Modelica.Units.SI.Temperature TCHWSupSet_min(displayUnit="degC")
    "Design (minimum) CHW supply temperature setpoint"
    annotation (Dialog(tab="General", group="Chillers configuration"));
  parameter Boolean have_dedPum
    "Set to true if parallel chillers are connected to dedicated pumps"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_fixSpeConWatPum = false
    "Set to true if the plant has fixed speed CW pumps. (Must be false if the plant has WSE.)"
    annotation(Dialog(tab="General", group="Condenser water pump",
      enable=not have_WSE and not isAirCoo));
  parameter Boolean have_senDpCHWLoc = false
    "Set to true if there is a local DP sensor hardwired to the plant controller"
    annotation (Dialog(tab="General", group="Configuration"));
  parameter Integer nSenDpCHWRem = 1
    "Number of remote CHW differential pressure sensors"
    annotation (Dialog(tab="General", group="Chilled water pump"));
  parameter Modelica.Units.SI.Temperature TAirOutLoc(displayUnit="degC")=
    dat.getReal(varName=id + ".control.TAirOutLoc.value")
    "Outdoor air lockout temperature below which the chiller plant should be disabled"
    annotation(Dialog(tab="Plant enable"));

  parameter Modelica.Units.SI.PressureDifference dpCHWLoc_max(displayUnit="Pa")=
    dat.getReal(varName=id + ".control.TAirOutLoc.value")
    "Maximum CHW differential pressure setpoint - Local sensors"
    annotation (Dialog(tab="Chilled water pumps", enable=have_senDpCHWLoc));
  parameter Modelica.Units.SI.PressureDifference dpCHWRem_max[nSenDpCHWRem](each displayUnit="Pa")=
    dat.getRealArray1D(varName=id + ".control.dpCHWRem_max.value", n=nSenDpCHWRem)
    "Maximum CHW differential pressure setpoint - Remote sensors"
    annotation (Dialog(tab="Plant Reset", group="Chilled water supply"));

  parameter Modelica.Units.SI.MassFlowRate mCHWPri_flow_nominal
    "Design (maximum) primary CHW mass flow rate (for the plant)";
  parameter Modelica.Units.SI.MassFlowRate mCHWChi_flow_min[nChi]=
    dat.getRealArray1D(varName=id + ".control.mCHWChi_flow_min.value", n=nChi)
    "Minimum chiller CHW mass flow rate (for each chiller)"
    annotation(Dialog(tab="Minimum flow bypass", group="Flow limits"));

  Buildings.Templates.ChilledWaterPlant.BaseClasses.BusChilledWater busCHW(
    final nChi=nChi,
    final nPumPri=nPumPri,
    final nPumSec=nPumSec)
    "Control bus"
    annotation (Placement(transformation(extent={{200,-20},{240,20}}),
        iconTransformation(extent={{80,-20},{120,20}})));
  Buildings.Templates.ChilledWaterPlant.BaseClasses.BusCondenserWater busCW(
    final nChi=nChi,
    final nPum=nPumCon,
    final nCooTow=nCooTow) if not isAirCoo
    "Control bus"
    annotation (
      Placement(transformation(extent={{-218,-20},{-178,20}}),
        iconTransformation(extent={{-120,-20},{-80,20}})));

  annotation (
    __Dymola_translate=true,
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-151,-114},{149,-154}},
          lineColor={0,0,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-200},{220,
            200}})));
end PartialController;
