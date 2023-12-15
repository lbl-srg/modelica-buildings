within Buildings.Templates.Plants.HeatPumps.Components.Interfaces;
block PartialController
  parameter Buildings.Templates.Plants.HeatPumps.Types.Controller typ
    "Type of controller"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Integer nHeaPum(start=0, final min=0)
    "Number of heat pumps"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary typPumHeaWatPri(
    start=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable)
    "Type of primary HW pumps"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  final parameter Boolean have_varPumHeaWatPri=
    typPumHeaWatPri==Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.FactoryVariable or
    typPumHeaWatPri==Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable
    "Set to true for variable speed primary HW pumps"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary typPumHeaWatSec
    "Type of secondary HW pumps"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Integer nPumHeaWatPri=nHeaPum
    "Number of primary HW pumps"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.PumpArrangement typArrPumHeaWatPri(
    start=Buildings.Templates.Components.Types.PumpArrangement.Headered)
    "Type of primary HW pump arrangement"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Integer nPumHeaWatSec(start=0)
    "Number of secondary HW pumps"
    annotation (Evaluate=true, Dialog(group="Configuration",
    enable=typPumHeaWatSec<>Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None));
  parameter Boolean have_valHeaWatMinByp
    "Set to true if the plant has a HW minimum flow bypass valve"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Integer nAirHan(
    final min=if typ==Buildings.Templates.Plants.HeatPumps.Types.Controller.Guideline36
    and nEquZon==0 then 1 else 0,
    start=0)
    "Number of air handling units served by the plant"
    annotation(Evaluate=true, Dialog(group="Configuration", enable=
    typ==Buildings.Templates.Plants.HeatPumps.Types.Controller.Guideline36));
  parameter Integer nEquZon(
    final min=if typ==Buildings.Templates.Plants.HeatPumps.Types.Controller.Guideline36 and
    nAirHan==0 then 1 else 0,
    start=0)
    "Number of terminal units (zone equipment) served by the plant"
    annotation(Evaluate=true, Dialog(group="Configuration", enable=
    typ==Buildings.Templates.Plants.HeatPumps.Types.Controller.Guideline36));

  parameter Buildings.Templates.Plants.HeatPumps.Types.PrimaryOverflowMeasurement typMeaCtlHeaWatPri(
    start=Buildings.Templates.Plants.HeatPumps.Types.PrimaryOverflowMeasurement.TemperatureSupplySensor)
    "Type of sensors for variable speed primary pumps control in primary-secondary plants"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=
    typ==Buildings.Templates.Plants.HeatPumps.Types.Controller.Guideline36 and
    typPumHeaWatSec<>Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None and
    (have_varPumHeaWatPriCon or have_varPumHeaWatPriNon)));

  final parameter Boolean have_senVHeaWatPri=
    if have_varPumHeaWatPri and
    typPumHeaWatSec<>Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None then
    typMeaCtlHeaWatPri==Buildings.Templates.Plants.HeatPumps.Types.PrimaryOverflowMeasurement.FlowDifference
    else typPumHeaWatSec==Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None
    "Set to true for primary HW flow sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Plants.HeatPumps.Types.SensorLocation locSenVHeaWatPri=
    Buildings.Templates.Plants.HeatPumps.Types.SensorLocation.Return
    "Location of primary HW flow sensor"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=
    typ==Buildings.Templates.Plants.HeatPumps.Types.Controller.Guideline36 and
    have_senVHeaWatPriCon or have_senVHeaWatPriNon));
  final parameter Boolean have_senVHeaWatSec=
    typPumHeaWatSec<>Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None and
    typMeaCtlHeaWatPri==Buildings.Templates.Plants.HeatPumps.Types.PrimaryOverflowMeasurement.FlowDifference
    "Set to true for secondary HW flow sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Plants.HeatPumps.Types.SensorLocation locSenVHeaWatSec=
    Buildings.Templates.Plants.HeatPumps.Types.SensorLocation.Return
    "Location of secondary HW flow sensor"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=
    typ==Buildings.Templates.Plants.HeatPumps.Types.Controller.Guideline36 and
    have_senVHeaWatSec));

  final parameter Boolean have_senTHeaWatPriSup=
    if typPumHeaWatSec<>Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None then
    typMeaCtlHeaWatPri==Buildings.Templates.Plants.HeatPumps.Types.PrimaryOverflowMeasurement.TemperatureSupplySensor
    else have_varPumHeaWatPri
    "Set to true for primary HW supply temperature sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  final parameter Boolean have_senTHeaWatPlaRet=
    typPumHeaWatSec==Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None
    "Set to true for plant HW return temperature sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  final parameter Boolean have_senTHeaWatSecSup=
    typPumHeaWatSec<>Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None
    "Set to true for secondary HW supply temperature sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  final parameter Boolean have_senTHeaWatSecRet=
    typPumHeaWatSec<>Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None
    "Set to true for secondary HW return temperature sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Boolean have_senDpHeaWatLoc=false
    "Set to true for local HW differential pressure sensor hardwired to plant or pump controller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=
    typ==Buildings.Templates.Plants.HeatPumps.Types.Controller.Guideline36));
  parameter Integer nSenDpHeaWatRem(
    final min=if typ==Buildings.Templates.Plants.HeatPumps.Types.Controller.Guideline36
    then 1 else 0)=1
    "Number of remote HW differential pressure sensors used for HW pump speed control"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=
    typ==Buildings.Templates.Plants.HeatPumps.Types.Controller.Guideline36));

  parameter Buildings.Templates.Plants.HeatPumps.Components.Data.Controller dat(
    final typ=typ,
    final nHeaPump=nHeaPump,
    final have_varPumHeaWatPri=have_varPumHeaWatPri,
    final typArrPumHeaWatPri=typArrPumHeaWatPri,
    final typPumHeaWatSec=typPumHeaWatSec,
    final nPumHeaWatPri=nPumHeaWatPri,
    final nPumHeaWatSec=nPumHeaWatSec,
    final have_valHeaWatMinByp=have_valHeaWatMinByp,
    final have_senDpHeaWatLoc=have_senDpHeaWatLoc,
    final nSenDpHeaWatRem=nSenDpHeaWatRem,
    final have_senVHeaWatSec=have_senVHeaWatSec)
    "Parameter record for controller";

  Buildings.Templates.Plants.HeatPumps.Interfaces.Bus bus
    "Plant control bus"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-260,0}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-100,0})));
  Buildings.Templates.AirHandlersFans.Interfaces.Bus busAirHan[nAirHan]
    if nAirHan>0
    "Air handling unit control bus"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={260,140}), iconTransformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={100,60})));
  Buildings.Templates.ZoneEquipment.Interfaces.Bus busEquZon[nEquZon]
    if nEquZon>0
    "Terminal unit control bus"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={260,-140}),
        iconTransformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={100,-60})));

protected
  Buildings.Templates.Plants.HeatPumps.Components.Interfaces.Bus busHeaPump[nHeaPum]
    "Heat pump control bus"
    annotation (Placement(transformation(extent={{-260,140},{-220,180}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busPumHeaWatPriCon
    "Primary HW pump control bus"
    annotation (Placement(transformation(extent={{-260,60},{-220,100}}),
        iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busPumHeaWatSec
    if typPumHeaWatSec==Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized
    "Secondary HW pump control bus"
    annotation (Placement(transformation(extent={{-220,-60},{-180,-20}}),
    iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValHeaWatMinByp
    if have_valHeaWatMinByp
    "HW minimum flow bypass valve control bus"
    annotation (Placement(transformation(extent={{-220,20},{-180,60}}),
        iconTransformation(extent={{-466,50},{-426,90}})));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-260,-380},{260,380}})),
    Documentation(info="<html>
<p>
This partial class provides a standard interface for heat pump plant controllers.
</p>
</html>", revisions="<html>
<ul>
<li>
FIXME, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialController;
