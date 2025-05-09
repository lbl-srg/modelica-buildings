within Buildings.Templates.Plants.Boilers.HotWater.Components.Interfaces;
block PartialController
  parameter Buildings.Templates.Plants.Boilers.HotWater.Configuration.BoilerPlant cfg
    "Plant configuration parameters"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Plants.Boilers.HotWater.Components.Data.Controller dat(
    final cfg=cfg)
    "Parameter record for controller";
  parameter Buildings.Templates.Plants.Boilers.HotWater.Types.Controller typ
    "Type of controller"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Integer nAirHan(
    final min=if typ==Buildings.Templates.Plants.Boilers.HotWater.Types.Controller.Guideline36
    and nEquZon==0 then 1 else 0,
    start=0)
    "Number of air handling units served by the plant"
    annotation(Evaluate=true, Dialog(group="Configuration", enable=
    typ==Buildings.Templates.Plants.Boilers.HotWater.Types.Controller.Guideline36));
  parameter Integer nEquZon(
    final min=if typ==Buildings.Templates.Plants.Boilers.HotWater.Types.Controller.Guideline36 and
    nAirHan==0 then 1 else 0,
    start=0)
    "Number of terminal units (zone equipment) served by the plant"
    annotation(Evaluate=true, Dialog(group="Configuration", enable=
    typ==Buildings.Templates.Plants.Boilers.HotWater.Types.Controller.Guideline36));

  parameter Buildings.Templates.Plants.Boilers.HotWater.Types.PrimaryOverflowMeasurement typMeaCtlHeaWatPri(
    start=Buildings.Templates.Plants.Boilers.HotWater.Types.PrimaryOverflowMeasurement.TemperatureSupplySensor)
    "Type of sensors for variable speed primary pumps control in primary-secondary plants"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=
    typ==Buildings.Templates.Plants.Boilers.HotWater.Types.Controller.Guideline36 and
    cfg.typPumHeaWatSec<>Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsSecondary.None and
    (cfg.have_boiCon and cfg.have_pumHeaWatPriVarCon or cfg.have_boiNon and cfg.have_pumHeaWatPriVarNon)));
  final parameter Boolean have_senVHeaWatPriCon=
    cfg.have_boiCon and (
    if cfg.have_pumHeaWatPriVarCon and
    cfg.typPumHeaWatSec<>Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsSecondary.None then
    typMeaCtlHeaWatPri==Buildings.Templates.Plants.Boilers.HotWater.Types.PrimaryOverflowMeasurement.FlowDifference
    else cfg.typPumHeaWatSec==Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsSecondary.None)
    "Set to true for primary HW flow sensor - Condensing boilers"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  final parameter Boolean have_senVHeaWatPriNon=
    cfg.have_boiNon and (
    if cfg.have_pumHeaWatPriVarNon and
    cfg.typPumHeaWatSec<>Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsSecondary.None then
    typMeaCtlHeaWatPri==Buildings.Templates.Plants.Boilers.HotWater.Types.PrimaryOverflowMeasurement.FlowDifference
    else cfg.typPumHeaWatSec==Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsSecondary.None)
    "Set to true for primary HW flow sensor - Non-condensing boilers"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Plants.Boilers.HotWater.Types.SensorLocation locSenVHeaWatPri=
    Buildings.Templates.Plants.Boilers.HotWater.Types.SensorLocation.Return
    "Location of primary HW flow sensor"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=
    typ==Buildings.Templates.Plants.Boilers.HotWater.Types.Controller.Guideline36 and
    have_senVHeaWatPriCon or have_senVHeaWatPriNon));
  final parameter Boolean have_senVHeaWatSec=
    cfg.typPumHeaWatSec<>Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsSecondary.None and
    (if cfg.have_boiCon and cfg.have_pumHeaWatPriVarCon or
    cfg.have_boiNon and cfg.have_pumHeaWatPriVarNon then
    typMeaCtlHeaWatPri==Buildings.Templates.Plants.Boilers.HotWater.Types.PrimaryOverflowMeasurement.FlowDifference
    else true)
    "Set to true for secondary HW flow sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Plants.Boilers.HotWater.Types.SensorLocation locSenVHeaWatSec=
    Buildings.Templates.Plants.Boilers.HotWater.Types.SensorLocation.Return
    "Location of secondary HW flow sensor"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=
    typ==Buildings.Templates.Plants.Boilers.HotWater.Types.Controller.Guideline36 and
    have_senVHeaWatSec));

  final parameter Boolean have_senTHeaWatPriSupCon=
    cfg.have_boiCon and (
    if cfg.typPumHeaWatSec<>Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsSecondary.None then
    typMeaCtlHeaWatPri==Buildings.Templates.Plants.Boilers.HotWater.Types.PrimaryOverflowMeasurement.TemperatureSupplySensor
    else cfg.have_pumHeaWatPriVarCon)
    "Set to true for primary HW supply temperature sensor - Condensing boilers"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  final parameter Boolean have_senTHeaWatPriSupNon=
    cfg.have_boiNon and (
    if cfg.typPumHeaWatSec<>Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsSecondary.None then
    typMeaCtlHeaWatPri==Buildings.Templates.Plants.Boilers.HotWater.Types.PrimaryOverflowMeasurement.TemperatureSupplySensor
    else cfg.have_pumHeaWatPriVarNon)
    "Set to true for primary HW supply temperature sensor - Non-condensing boilers"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  final parameter Boolean have_senTHeaWatPlaRetCon=
    cfg.have_boiCon and cfg.typPumHeaWatSec==Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsSecondary.None
    "Set to true for plant HW return temperature sensor - Condensing boilers"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  final parameter Boolean have_senTHeaWatPlaRetNon=cfg.have_boiNon
    "Set to true for plant HW return temperature sensor - Non-condensing boilers"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  final parameter Boolean have_senTHeaWatSecSup=
    cfg.typPumHeaWatSec<>Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsSecondary.None
    "Set to true for secondary HW supply temperature sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  final parameter Boolean have_senTHeaWatSecRet=
    cfg.typPumHeaWatSec<>Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsSecondary.None
    "Set to true for secondary HW return temperature sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Boolean have_senDpHeaWatRemWir(start=false)=false
    "Set to true for remote HW differential pressure sensor(s) hardwired to plant or pump controller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=
    typ==Buildings.Templates.Plants.Boilers.HotWater.Types.Controller.Guideline36));
  parameter Integer nSenDpHeaWatRem(
    final min=if typ==Buildings.Templates.Plants.Boilers.HotWater.Types.Controller.Guideline36
    then 1 else 0)=1
    "Number of remote HW differential pressure sensors used for HW pump speed control"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=
    typ==Buildings.Templates.Plants.Boilers.HotWater.Types.Controller.Guideline36));
  Buildings.Templates.Plants.Boilers.HotWater.Interfaces.Bus bus
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
  Buildings.Templates.Components.Interfaces.Bus busBoiCon[cfg.nBoiCon]
    if cfg.have_boiCon "Boiler control bus - Condensing boilers" annotation (
      Placement(transformation(extent={{-260,140},{-220,180}}),
        iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busBoiNon[cfg.nBoiNon] if cfg.have_boiNon
    "Boiler control bus - Non-condensing boilers"
    annotation (Placement(transformation(extent={{-180,140},{-140,180}}),
                    iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValBoiConIso[cfg.nBoiCon]
    if cfg.have_boiCon "Boiler isolation valve control bus - Condensing boilers"
    annotation (Placement(transformation(extent={{-260,100},{-220,140}}),
        iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValBoiNonIso[cfg.nBoiNon] if cfg.have_boiNon
    "Boiler isolation valve control bus - Non-condensing boilers"
    annotation (Placement(transformation(extent={{-180,100},{-140,140}}),
    iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busPumHeaWatPriCon
    if cfg.have_boiCon "Primary HW pump control bus - Condensing boilers"
    annotation (Placement(transformation(extent={{-260,60},{-220,100}}),
        iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busPumHeaWatPriNon if cfg.have_boiNon
    "Primary HW pump control bus - Condensing boilers"
    annotation (Placement(transformation(extent={{-180,60},{-140,100}}),
    iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busPumHeaWatSec
    if cfg.typPumHeaWatSec==Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsSecondary.Centralized
    "Secondary HW pump control bus"
    annotation (Placement(transformation(extent={{-220,-60},{-180,-20}}),
    iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValHeaWatMinByp
    if cfg.have_valHeaWatMinBypCon or cfg.have_valHeaWatMinBypNon
    "HW minimum flow bypass valve control bus"
    annotation (Placement(transformation(extent={{-220,20},{-180,60}}),
        iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busLooCon if cfg.have_boiCon
    "Condensing boiler loop control bus" annotation (Placement(transformation(
          extent={{-260,180},{-220,220}}), iconTransformation(extent={{-466,50},
            {-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busLooNon if cfg.have_boiNon
    "Non-condensing boiler loop control bus" annotation (Placement(
        transformation(extent={{-180,180},{-140,220}}), iconTransformation(
          extent={{-466,50},{-426,90}})));
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
  connect(busLooCon, bus.looCon) annotation (Line(
      points={{-240,200},{-220,200},{-220,0},{-260,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busLooNon, bus.looNon) annotation (Line(
      points={{-160,200},{-180,200},{-180,0},{-260,0}},
      color={255,204,51},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-260,-280},{260,280}},
        grid={2,2})),
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
