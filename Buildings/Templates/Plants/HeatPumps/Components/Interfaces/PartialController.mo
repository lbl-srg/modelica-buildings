within Buildings.Templates.Plants.HeatPumps.Components.Interfaces;
block PartialController
  /*
  The following bindings are for parameters that are propagated *up*
  from the controller to the plant configuration record.
  All other configuration parameters (e.g. nHp) are propagated *down*
  from the plant configuration record to the controller.
  */
  parameter Buildings.Templates.Plants.HeatPumps.Configuration.HeatPumpPlant cfg(
    typCtl=typ,
    nAirHan=nAirHan,
    nEquZon=nEquZon,
    have_senDpHeaWatLoc=have_senDpHeaWatLoc,
    nSenDpHeaWatRem=nSenDpHeaWatRem,
    have_senVHeaWatSec=have_senVHeaWatSec,
    have_senDpChiWatLoc=have_senDpChiWatLoc,
    nSenDpChiWatRem=nSenDpChiWatRem,
    have_senVChiWatSec=have_senVChiWatSec)
    "Plant configuration parameters"
    annotation (Evaluate=true,
    Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Plants.HeatPumps.Components.Data.Controller dat(
    cfg=cfg)
    "Parameter record for controller";
  final parameter Integer nHp=cfg.nHp
    "Number of heat pumps"
    annotation (Evaluate=true,
    Dialog(group="Configuration"));
  parameter Buildings.Templates.Plants.HeatPumps.Types.Controller typ
    "Type of controller"
    annotation (Evaluate=true,
    Dialog(group="Configuration"));
  parameter Integer nAirHan(
    final min=if typ == Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop
      and nEquZon == 0 then 1 else 0,
    start=0)
    "Number of air handling units served by the plant"
    annotation (Evaluate=true,
    Dialog(group="Configuration",
      enable=typ==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop));
  parameter Integer nEquZon(
    final min=if typ == Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop
      and nAirHan == 0 then 1 else 0,
    start=0)
    "Number of terminal units (zone equipment) served by the plant"
    annotation (Evaluate=true,
    Dialog(group="Configuration",
      enable=typ==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop));
  parameter Buildings.Templates.Plants.Components.Controls.Types.PrimaryOverflowMeasurement typMeaCtlHeaWatPri(
    start=Buildings.Templates.Plants.Components.Controls.Types.PrimaryOverflowMeasurement.FlowDecoupler)
    "Type of sensors for primary HW pump control in variable primary-variable secondary plants"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=
    typ==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop and
    (cfg.typDis==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1And2)));
  final parameter Boolean have_senVHeaWatPri=if cfg.have_varPumHeaWatPri and cfg.typPumHeaWatSec <>
    Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None then typMeaCtlHeaWatPri ==
    Buildings.Templates.Plants.Components.Controls.Types.PrimaryOverflowMeasurement.FlowDifference
    else cfg.typPumHeaWatSec == Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None
    "Set to true for primary HW flow sensor"
    annotation (Evaluate=true,
    Dialog(group="Configuration"));
  parameter Buildings.Templates.Plants.HeatPumps.Types.SensorLocation locSenVHeaWatPri=
    Buildings.Templates.Plants.HeatPumps.Types.SensorLocation.Return
    "Location of primary HW flow sensor"
    annotation (Evaluate=true,
    Dialog(group="Configuration",
      enable=typ==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop
        and have_senVHeaWatPri));
  final parameter Boolean have_senVHeaWatSec=
    cfg.typPumHeaWatSec <> Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None
    and typMeaCtlHeaWatPri == Buildings.Templates.Plants.Components.Controls.Types.PrimaryOverflowMeasurement.FlowDifference
    "Set to true for secondary HW flow sensor"
    annotation (Evaluate=true,
    Dialog(group="Configuration"));
  parameter Buildings.Templates.Plants.HeatPumps.Types.SensorLocation locSenVHeaWatSec=
    Buildings.Templates.Plants.HeatPumps.Types.SensorLocation.Return
    "Location of secondary HW flow sensor"
    annotation (Evaluate=true,
    Dialog(group="Configuration",
      enable=typ==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop
        and have_senVHeaWatSec));
  final parameter Boolean have_senTHeaWatPriSup=
    if cfg.typPumHeaWatSec <> Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None
    then typMeaCtlHeaWatPri == Buildings.Templates.Plants.Components.Controls.Types.PrimaryOverflowMeasurement.TemperatureSupplySensor
    else cfg.have_varPumHeaWatPri
    "Set to true for primary HW supply temperature sensor"
    annotation (Evaluate=true,
    Dialog(group="Configuration"));
  final parameter Boolean have_senTHeaWatPlaRet=
    cfg.typPumHeaWatSec == Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None
    "Set to true for plant HW return temperature sensor"
    annotation (Evaluate=true,
    Dialog(group="Configuration"));
  final parameter Boolean have_senTHeaWatSecSup=
    cfg.typPumHeaWatSec <> Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None
    "Set to true for secondary HW supply temperature sensor"
    annotation (Evaluate=true,
    Dialog(group="Configuration"));
  final parameter Boolean have_senTHeaWatSecRet=
    cfg.typPumHeaWatSec <> Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None
    "Set to true for secondary HW return temperature sensor"
    annotation (Evaluate=true,
    Dialog(group="Configuration"));
  parameter Boolean have_senDpHeaWatLoc=false
    "Set to true for local HW differential pressure sensor hardwired to plant or pump controller"
    annotation (Evaluate=true,
    Dialog(group="Configuration",
      enable=typ==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop));
  parameter Integer nSenDpHeaWatRem(
    final min=if typ == Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop
      then 1 else 0)=1
    "Number of remote HW differential pressure sensors used for HW pump speed control"
    annotation (Evaluate=true,
    Dialog(group="Configuration",
      enable=typ==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop));
  parameter Buildings.Templates.Plants.Components.Controls.Types.PrimaryOverflowMeasurement typMeaCtlChiWatPri=
    typMeaCtlHeaWatPri
    "Type of sensors for primary CHW pump control in variable primary-variable secondary plants"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=cfg.have_chiWat and
    typ==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop and
    (cfg.typDis==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1And2)));
  final parameter Boolean have_senVChiWatPri=if cfg.have_varPumChiWatPri and cfg.typPumChiWatSec <>
    Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None then typMeaCtlChiWatPri ==
    Buildings.Templates.Plants.Components.Controls.Types.PrimaryOverflowMeasurement.FlowDifference
    else cfg.typPumChiWatSec == Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None
    "Set to true for primary CHW flow sensor"
    annotation (Evaluate=true,
    Dialog(group="Configuration", enable=cfg.have_chiWat));
  parameter Buildings.Templates.Plants.HeatPumps.Types.SensorLocation locSenVChiWatPri=
    locSenVHeaWatPri
    "Location of primary CHW flow sensor"
    annotation (Evaluate=true,
    Dialog(group="Configuration",
      enable=cfg.have_chiWat and
      typ==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop
      and have_senVChiWatPri));
  final parameter Boolean have_senVChiWatSec=
    cfg.typPumChiWatSec <> Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None
    and typMeaCtlChiWatPri == Buildings.Templates.Plants.Components.Controls.Types.PrimaryOverflowMeasurement.FlowDifference
    "Set to true for secondary CHW flow sensor"
    annotation (Evaluate=true,
    Dialog(group="Configuration", enable=cfg.have_chiWat));
  parameter Buildings.Templates.Plants.HeatPumps.Types.SensorLocation locSenVChiWatSec=
    locSenVHeaWatSec
    "Location of secondary CHW flow sensor"
    annotation (Evaluate=true,
    Dialog(group="Configuration", enable=cfg.have_chiWat and
    typ==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop
    and have_senVChiWatSec));
  final parameter Boolean have_senTChiWatPriSup=
    if cfg.typPumChiWatSec <> Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None
    then typMeaCtlChiWatPri == Buildings.Templates.Plants.Components.Controls.Types.PrimaryOverflowMeasurement.TemperatureSupplySensor
    else cfg.have_varPumChiWatPri
    "Set to true for primary CHW supply temperature sensor"
    annotation (Evaluate=true,
    Dialog(group="Configuration", enable=cfg.have_chiWat));
  final parameter Boolean have_senTChiWatPlaRet=
    cfg.typPumChiWatSec == Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None
    "Set to true for plant CHW return temperature sensor"
    annotation (Evaluate=true,
    Dialog(group="Configuration", enable=cfg.have_chiWat));
  final parameter Boolean have_senTChiWatSecSup=
    cfg.typPumChiWatSec <> Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None
    "Set to true for secondary CHW supply temperature sensor"
    annotation (Evaluate=true,
    Dialog(group="Configuration", enable=cfg.have_chiWat));
  final parameter Boolean have_senTChiWatSecRet=
    cfg.typPumChiWatSec <> Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None
    "Set to true for secondary CHW return temperature sensor"
    annotation (Evaluate=true,
    Dialog(group="Configuration", enable=cfg.have_chiWat));
  parameter Boolean have_senDpChiWatLoc=have_senDpHeaWatLoc
    "Set to true for local CHW differential pressure sensor hardwired to plant or pump controller"
    annotation (Evaluate=true,
    Dialog(group="Configuration", enable=cfg.have_chiWat and
    typ==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop));
  parameter Integer nSenDpChiWatRem(
    final min=if typ == Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop
      then 1 else 0)=1
    "Number of remote CHW differential pressure sensors used for CHW pump speed control"
    annotation (Evaluate=true,
    Dialog(group="Configuration", enable=cfg.have_chiWat and
    typ==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop));
  Buildings.Templates.Plants.HeatPumps.Interfaces.Bus bus
    "Plant control bus"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},rotation=90,
      origin={-260,0}),
      iconTransformation(extent={{-20,-20},{20,20}},rotation=90,origin={-100,0})));
  Buildings.Templates.AirHandlersFans.Interfaces.Bus busAirHan[nAirHan]
    if nAirHan > 0
    "Air handling unit control bus"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},rotation=-90,
      origin={260,140}),
      iconTransformation(extent={{-20,-20},{20,20}},rotation=-90,origin={100,60})));
  Buildings.Templates.ZoneEquipment.Interfaces.Bus busEquZon[nEquZon]
    if nEquZon > 0
    "Terminal unit control bus"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},rotation=-90,
      origin={260,-140}),
      iconTransformation(extent={{-20,-20},{20,20}},rotation=-90,origin={100,-60})));
protected
  Buildings.Templates.Components.Interfaces.Bus busHp[nHp]
    "Heat pump control bus" annotation (Placement(transformation(extent={{-260,
            140},{-220,180}}), iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busPumHeaWatPri
    if cfg.have_heaWat "Primary HW pump control bus" annotation (Placement(
        transformation(extent={{100,100},{140,140}}), iconTransformation(extent
          ={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busPumHeaWatSec if cfg.typPumHeaWatSec
     == Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized
    "Secondary HW pump control bus" annotation (Placement(transformation(extent
          ={{100,60},{140,100}}), iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatPri
    if cfg.have_pumChiWatSep "Primary CHW pump control bus" annotation (
      Placement(transformation(extent={{100,-100},{140,-60}}),
        iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatSec if cfg.typPumHeaWatSec
     == Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized
    "Secondary CHW pump control bus" annotation (Placement(transformation(
          extent={{100,-140},{140,-100}}), iconTransformation(extent={{-466,50},
            {-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValHeaWatHpInlIso[nHp]
    if cfg.have_heaWat and nHp > 1
    "Heat pump inlet HW isolation valve control bus" annotation (Placement(
        transformation(extent={{-260,100},{-220,140}}), iconTransformation(
          extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValHeaWatHpOutIso[nHp]
    if cfg.have_heaWat "Heat pump outlet HW isolation valve control bus"
    annotation (Placement(transformation(extent={{-260,60},{-220,100}}),
        iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatHpInlIso[nHp]
    if cfg.have_chiWat and nHp > 1
    "Heat pump inlet CHW isolation valve control bus" annotation (Placement(
        transformation(extent={{-260,-100},{-220,-60}}), iconTransformation(
          extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatHpOutIso[nHp]
    if cfg.have_chiWat "Heat pump outlet CHW isolation valve control bus"
    annotation (Placement(transformation(extent={{-260,-140},{-220,-100}}),
        iconTransformation(extent={{-466,50},{-426,90}})));
equation

  /* Control point connection - start */
  connect(busPumHeaWatPri, bus.pumHeaWatPri);
  connect(busPumChiWatSec, bus.pumChiWatSec);
  connect(busPumHeaWatSec, bus.pumHeaWatSec);
  connect(busHp, bus.hp);
  connect(busValHeaWatHpInlIso, bus.valHeaWatHpInlIso);
  connect(busValHeaWatHpOutIso, bus.valHeaWatHpOutIso);
  connect(busValChiWatHpInlIso, bus.valChiWatHpInlIso);
  connect(busValChiWatHpOutIso, bus.valChiaWatHpOutIso);
  connect(busPumChiWatPri, bus.pumChiWatPri);
  /* Control point connection - stop */

  annotation (
    Icon(
      coordinateSystem(
        preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
                                        Text(
        extent={{-150,150},{150,110}},
        textString="%name",
        textColor={0,0,255})}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-260,-380},{260,380}})),
    Documentation(
      info="<html>
<p>
This partial class provides a standard interface for heat pump plant controllers.
</p>
<p>
By default, the control options are supposed identical between the CHW and the HW loops.
</p>
</html>",
      revisions="<html>
<ul>
<li>
FIXME, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialController;
