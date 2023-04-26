within Buildings.Templates.HeatingPlants.HotWater.Components.Interfaces;
block PartialController
  parameter Buildings.Templates.HeatingPlants.HotWater.Types.Controller typ
    "Type of controller"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_boiCon
    "Set to true if the plant includes condensing boilers"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_boiNon
    "Set to true if the plant includes non-condensing boilers"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Integer nBoiCon(start=0, final min=0)
    "Number of condensing boilers"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=have_boiCon));
  parameter Integer nBoiNon(start=0, final min=0)
    "Number of non-condensing boilers"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=have_boiNon));
  parameter Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary typPumHeaWatPriCon(
    start=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.Variable)
    "Type of primary HW pumps - Condensing boilers"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=have_boiCon));
  parameter Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary typPumHeaWatPriNon(
    start=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.Variable)
    "Type of primary HW pumps - Non-condensing boilers"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=have_boiNon));
  final parameter Boolean have_varPumHeaWatPriCon=
    typPumHeaWatPriCon==Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.FactoryVariable or
    typPumHeaWatPriCon==Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.Variable
    "Set to true for variable speed primary HW pumps - Condensing boilers"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  final parameter Boolean have_varPumHeaWatPriNon=
    typPumHeaWatPriNon==Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.FactoryVariable or
    typPumHeaWatPriNon==Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.Variable
    "Set to true for variable speed primary HW pumps - Non-condensing boilers"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary typPumHeaWatSec
    "Type of secondary HW pumps"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Integer nPumHeaWatPriCon=nBoiCon
    "Number of primary HW pumps - Condensing boilers"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=have_boiCon));
  parameter Integer nPumHeaWatPriNon=nBoiNon
    "Number of primary HW pumps - Non-condensing boilers"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=have_boiNon));
  parameter Buildings.Templates.Components.Types.PumpArrangement typArrPumHeaWatPriCon(
    start=Buildings.Templates.Components.Types.PumpArrangement.Headered)
    "Type of primary HW pump arrangement - Condensing boilers"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=have_boiCon));
  parameter Buildings.Templates.Components.Types.PumpArrangement typArrPumHeaWatPriNon(
    start=Buildings.Templates.Components.Types.PumpArrangement.Headered)
    "Type of primary HW pump arrangement - Non-condensing boilers"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=have_boiNon));
  parameter Integer nPumHeaWatSec(start=0)
    "Number of secondary HW pumps"
    annotation (Evaluate=true, Dialog(group="Configuration",
    enable=typPumHeaWatSec<>Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None));
  parameter Boolean have_valHeaWatMinBypCon
    "Set to true if the plant has a HW minimum flow bypass valve - Condensing boilers"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_valHeaWatMinBypNon
    "Set to true if the plant has a HW minimum flow bypass valve - Non-condensing boilers"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Integer nAirHan(
    final min=if typ==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36
    and nEquZon==0 then 1 else 0,
    start=0)
    "Number of air handling units served by the plant"
    annotation(Evaluate=true, Dialog(group="Configuration", enable=
    typ==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36));
  parameter Integer nEquZon(
    final min=if typ==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36 and
    nAirHan==0 then 1 else 0,
    start=0)
    "Number of terminal units (zone equipment) served by the plant"
    annotation(Evaluate=true, Dialog(group="Configuration", enable=
    typ==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36));

  parameter Buildings.Templates.HeatingPlants.HotWater.Types.PrimaryOverflowMeasurement typMeaCtlHeaWatPri(
    start=Buildings.Templates.HeatingPlants.HotWater.Types.PrimaryOverflowMeasurement.TemperatureSupplySensor)
    "Type of sensors for variable speed primary pumps control in primary-secondary plants"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=
    typ==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36 and
    typPumHeaWatSec<>Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None and
    (have_varPumHeaWatPriCon or have_varPumHeaWatPriNon)));

  final parameter Boolean have_senVHeaWatPriCon=
    have_boiCon and (
    if have_varPumHeaWatPriCon and
    typPumHeaWatSec<>Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None then
    typMeaCtlHeaWatPri==Buildings.Templates.HeatingPlants.HotWater.Types.PrimaryOverflowMeasurement.FlowDifference
    else typPumHeaWatSec==Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None)
    "Set to true for primary HW flow sensor - Condensing boilers"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  final parameter Boolean have_senVHeaWatPriNon=
    have_boiNon and (
    if have_varPumHeaWatPriNon and
    typPumHeaWatSec<>Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None then
    typMeaCtlHeaWatPri==Buildings.Templates.HeatingPlants.HotWater.Types.PrimaryOverflowMeasurement.FlowDifference
    else typPumHeaWatSec==Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None)
    "Set to true for primary HW flow sensor - Non-condensing boilers"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.HeatingPlants.HotWater.Types.SensorLocation locSenVHeaWatPri=
    Buildings.Templates.HeatingPlants.HotWater.Types.SensorLocation.Return
    "Location of primary HW flow sensor"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=
    typ==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36 and
    have_senVHeaWatPriCon or have_senVHeaWatPriNon));
  final parameter Boolean have_senVHeaWatSec=
    typPumHeaWatSec<>Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None and
    typMeaCtlHeaWatPri==Buildings.Templates.HeatingPlants.HotWater.Types.PrimaryOverflowMeasurement.FlowDifference
    "Set to true for secondary HW flow sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.HeatingPlants.HotWater.Types.SensorLocation locSenVHeaWatSec=
    Buildings.Templates.HeatingPlants.HotWater.Types.SensorLocation.Return
    "Location of secondary HW flow sensor"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=
    typ==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36 and
    have_senVHeaWatSec));

  final parameter Boolean have_senTHeaWatPriSupCon=
    have_boiCon and (
    if typPumHeaWatSec<>Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None then
    typMeaCtlHeaWatPri==Buildings.Templates.HeatingPlants.HotWater.Types.PrimaryOverflowMeasurement.TemperatureSupplySensor
    else have_varPumHeaWatPriCon)
    "Set to true for primary HW supply temperature sensor - Condensing boilers"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  final parameter Boolean have_senTHeaWatPriSupNon=
    have_boiNon and (
    if typPumHeaWatSec<>Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None then
    typMeaCtlHeaWatPri==Buildings.Templates.HeatingPlants.HotWater.Types.PrimaryOverflowMeasurement.TemperatureSupplySensor
    else have_varPumHeaWatPriNon)
    "Set to true for primary HW supply temperature sensor - Non-condensing boilers"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  final parameter Boolean have_senTHeaWatPlaRetCon=
    have_boiCon and typPumHeaWatSec==Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None
    "Set to true for plant HW return temperature sensor - Condensing boilers"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  final parameter Boolean have_senTHeaWatPlaRetNon=have_boiNon
    "Set to true for plant HW return temperature sensor - Non-condensing boilers"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  final parameter Boolean have_senTHeaWatSecSup=
    typPumHeaWatSec<>Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None
    "Set to true for secondary HW supply temperature sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  final parameter Boolean have_senTHeaWatSecRet=
    typPumHeaWatSec<>Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None
    "Set to true for secondary HW return temperature sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Boolean have_senDpHeaWatLoc=false
    "Set to true for local HW differential pressure sensor hardwired to plant or pump controller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=
    typ==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36));
  parameter Integer nSenDpHeaWatRem(
    final min=if typ==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36
    then 1 else 0)=1
    "Number of remote HW differential pressure sensors used for HW pump speed control"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=
    typ==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36));

  parameter Buildings.Templates.HeatingPlants.HotWater.Components.Data.Controller dat(
    final typ=typ,
    final have_boiCon=have_boiCon,
    final have_boiNon=have_boiNon,
    final nBoiCon=nBoiCon,
    final nBoiNon=nBoiNon,
    final have_varPumHeaWatPriCon=have_varPumHeaWatPriCon,
    final have_varPumHeaWatPriNon=have_varPumHeaWatPriNon,
    final typArrPumHeaWatPriCon=typArrPumHeaWatPriCon,
    final typArrPumHeaWatPriNon=typArrPumHeaWatPriNon,
    final typPumHeaWatSec=typPumHeaWatSec,
    final nPumHeaWatPriCon=nPumHeaWatPriCon,
    final nPumHeaWatPriNon=nPumHeaWatPriNon,
    final nPumHeaWatSec=nPumHeaWatSec,
    final have_valHeaWatMinBypCon=have_valHeaWatMinBypCon,
    final have_valHeaWatMinBypNon=have_valHeaWatMinBypNon,
    final have_senDpHeaWatLoc=have_senDpHeaWatLoc,
    final nSenDpHeaWatRem=nSenDpHeaWatRem,
    final have_senVHeaWatSec=have_senVHeaWatSec)
    "Parameter record for controller";

  Buildings.Templates.HeatingPlants.HotWater.Interfaces.Bus bus
    "Plant control bus" annotation (Placement(transformation(
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
  Buildings.Templates.Components.Interfaces.Bus busBoiCon[nBoiCon]
    if have_boiCon "Boiler control bus - Condensing boilers" annotation (
      Placement(transformation(extent={{-260,140},{-220,180}}),
        iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busBoiNon[nBoiNon] if have_boiNon
    "Boiler control bus - Non-condensing boilers"
    annotation (Placement(transformation(extent={{-180,140},{-140,180}}),
                    iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValBoiConIso[nBoiCon]
    if have_boiCon "Boiler isolation valve control bus - Condensing boilers"
    annotation (Placement(transformation(extent={{-260,100},{-220,140}}),
        iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValBoiNonIso[nBoiNon] if have_boiNon
    "Boiler isolation valve control bus - Non-condensing boilers"
    annotation (Placement(transformation(extent={{-180,100},{-140,140}}),
    iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busPumHeaWatPriCon
    if have_boiCon "Primary HW pump control bus - Condensing boilers"
    annotation (Placement(transformation(extent={{-260,60},{-220,100}}),
        iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busPumHeaWatPriNon if have_boiNon
    "Primary HW pump control bus - Condensing boilers"
    annotation (Placement(transformation(extent={{-180,60},{-140,100}}),
    iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busPumHeaWatSec
    if typPumHeaWatSec==Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.Centralized
    "Secondary HW pump control bus"
    annotation (Placement(transformation(extent={{-220,-60},{-180,-20}}),
    iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValHeaWatMinByp
    if have_valHeaWatMinBypCon or have_valHeaWatMinBypNon
    "HW minimum flow bypass valve control bus"
    annotation (Placement(transformation(extent={{-220,20},{-180,60}}),
        iconTransformation(extent={{-466,50},{-426,90}})));
equation
  connect(busBoiCon, bus.boiCon) annotation (Line(
      points={{-240,160},{-220,160},{-220,0},{-260,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busValBoiConIso, bus.valBoiConIso) annotation (Line(
      points={{-240,120},{-220,120},{-220,0},{-260,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busPumHeaWatPriCon, bus.pumHeaWatPriCon) annotation (Line(
      points={{-240,80},{-220,80},{-220,0},{-260,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busPumHeaWatSec, bus.pumHeaWatSec) annotation (Line(
      points={{-200,-40},{-200,0},{-260,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busPumHeaWatPriNon, bus.pumHeaWatPriNon) annotation (Line(
      points={{-160,80},{-180,80},{-180,0},{-260,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busValBoiNonIso, bus.valBoiNonIso) annotation (Line(
      points={{-160,120},{-180,120},{-180,0},{-260,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busBoiNon, bus.boiNon) annotation (Line(
      points={{-160,160},{-180,160},{-180,0},{-260,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busValHeaWatMinByp, bus.valHeaWatMinByp) annotation (Line(
      points={{-200,40},{-200,0},{-260,0}},
      color={255,204,51},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-260,-380},{260,380}})),
    Documentation(info="<html>
<p>
This partial class provides a standard interface for boiler plant controllers.
</p>
</html>", revisions="<html>
<ul>
<li>
April 28, 2023, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialController;
