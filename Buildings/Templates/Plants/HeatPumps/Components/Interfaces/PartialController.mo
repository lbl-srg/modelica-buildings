within Buildings.Templates.Plants.HeatPumps.Components.Interfaces;
block PartialController "Interface for heat pump plant controller"
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
    have_senDpHeaWatRemWir=have_senDpHeaWatRemWir,
    nSenDpHeaWatRem=nSenDpHeaWatRem,
    have_senDpChiWatRemWir=have_senDpChiWatRemWir,
    nSenDpChiWatRem=nSenDpChiWatRem)
    "Plant configuration parameters"
    annotation (Evaluate=true,
    Dialog(group="Configuration",
      enable=false));
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
    final min=if typ <> Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop
      and nEquZon == 0 then 1 else 0,
    start=0)
    "Number of air handling units served by the plant"
    annotation (Evaluate=true,
    Dialog(group="Configuration",
      enable=typ<>Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop));
  parameter Integer nEquZon(
    final min=if typ <> Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop
      and nAirHan == 0 then 1 else 0,
    start=0)
    "Number of terminal units (zone equipment) served by the plant"
    annotation (Evaluate=true,
    Dialog(group="Configuration",
      enable=typ<>Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop));
  parameter Boolean have_senVHeaWatPri_select(start=false)=false
    "Set to true for plants with primary HW flow sensor"
    annotation (Evaluate=true,
    Dialog(group="Configuration",
      enable=typ<>Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop and
      cfg.have_heaWat and not cfg.have_hrc and have_senVHeaWatSec
      and cfg.typDis<>Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only));
  final parameter Boolean have_senVHeaWatPri=cfg.have_heaWat and
    (if cfg.have_hrc or not have_senVHeaWatSec
    or cfg.typDis==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only
    then true else have_senVHeaWatPri_select)
    "Set to true for plants with primary HW flow sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  // Secondary flow sensor required for secondary HW pump staging.
  final parameter Boolean have_senVHeaWatSec=
    cfg.typPumHeaWatSec<>Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None
    "Set to true for plants with secondary HW flow sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_senVChiWatPri_select(start=false)=have_senVHeaWatPri_select
    "Set to true for plants with primary CHW flow sensor"
    annotation (Evaluate=true,
    Dialog(group="Configuration",
      enable=typ<>Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop and
      cfg.have_chiWat and not cfg.have_hrc and have_senVChiWatSec
      and cfg.typDis<>Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only));
  final parameter Boolean have_senVChiWatPri=cfg.have_chiWat and
    (if cfg.have_hrc or not have_senVChiWatSec
     or cfg.typDis<>Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only
     then true else have_senVChiWatPri_select)
    "Set to true for plants with primary CHW flow sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  // Secondary flow sensor required for secondary CHW pump staging.
  final parameter Boolean have_senVChiWatSec=
    cfg.typPumChiWatSec<>Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None
    "Set to true for plants with secondary CHW flow sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_senTHeaWatPriRet_select(start=false)=false
    "Set to true for plants with primary HW return temperature sensor"
    annotation (Evaluate=true,
    Dialog(group="Configuration",
      enable=typ<>Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop and
      cfg.have_heaWat and not cfg.have_hrc and have_senTHeaWatSecRet));
  final parameter Boolean have_senTHeaWatPriRet=cfg.have_heaWat and
    (if cfg.have_hrc or not have_senTHeaWatSecRet then true else have_senTHeaWatPriRet_select)
    "Set to true for plants with primary HW return temperature sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_senTChiWatPriRet_select(start=false)=have_senTHeaWatPriRet_select
    "Set to true for plants with primary CHW return temperature sensor"
    annotation (Evaluate=true,
    Dialog(group="Configuration",
      enable=typ<>Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop and
      cfg.have_chiWat and not cfg.have_hrc and have_senTChiWatSecRet));
  final parameter Boolean have_senTChiWatPriRet=cfg.have_chiWat and
    (if cfg.have_hrc or not have_senTChiWatSecRet then true else have_senTChiWatPriRet_select)
    "Set to true for plants with primary CHW return temperature sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  // For primary-secondary plants, SHWST sensor is required for plant staging.
  final parameter Boolean have_senTHeaWatSecSup=
    cfg.typPumHeaWatSec<>Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None
    "Set to true for plants with secondary HW supply temperature sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  // For primary-secondary plants, SCHWST sensor is required for plant staging.
  final parameter Boolean have_senTChiWatSecSup=
    cfg.typPumChiWatSec<>Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None
    "Set to true for plants with secondary CHW supply temperature sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  // Following return temperature sensors are:
  // - optional for primary-secondary plants without HRC,
  // - required for plants with HRC: downstream of HRC.
  parameter Boolean have_senTHeaWatSecRet_select(start=false)=false
    "Set to true for plants with secondary HW return temperature sensor"
    annotation (Evaluate=true, Dialog(group="Sensors",
      enable=typ<>Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop and
    cfg.typPumHeaWatSec<>Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None
    and not cfg.have_hrc));
  parameter Boolean have_senTChiWatSecRet_select(start=false)=have_senTHeaWatSecRet_select
    "Set to true for plants with secondary CHW return temperature sensor"
    annotation (Evaluate=true, Dialog(group="Sensors",
    enable=typ<>Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop and
    cfg.typPumChiWatSec<>Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None
    and not cfg.have_hrc));
  final parameter Boolean have_senTHeaWatSecRet=
    if cfg.have_hrc then true
    elseif cfg.typPumHeaWatSec==Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None then false
    else have_senTHeaWatSecRet_select
    "Set to true for plants with secondary HW return temperature sensor"
    annotation (Evaluate=true);
  final parameter Boolean have_senTChiWatSecRet(start=false)=
    if cfg.have_hrc then true
    elseif cfg.typPumChiWatSec==Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None then false
    else have_senTChiWatSecRet_select
    "Set to true for plants with secondary CHW return temperature sensor"
    annotation (Evaluate=true);
  parameter Boolean have_senDpHeaWatRemWir=false
    "Set to true for remote HW differential pressure sensor(s) hardwired to plant or pump controller"
    annotation (Evaluate=true,
    Dialog(group="Configuration",
      enable=typ<>Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop));
  parameter Integer nSenDpHeaWatRem(
    final min=if typ <> Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop
      then 1 else 0)=1
    "Number of remote HW differential pressure sensors used for HW pump speed control"
    annotation (Evaluate=true,
    Dialog(group="Configuration",
      enable=typ<>Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop));
  parameter Boolean have_senDpChiWatRemWir=have_senDpHeaWatRemWir
    "Set to true for remote CHW differential pressure sensor(s) hardwired to plant or pump controller"
    annotation (Evaluate=true,
    Dialog(group="Configuration",
      enable=cfg.have_chiWat and typ<>Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop));
  parameter Integer nSenDpChiWatRem(
    final min=if typ <> Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop
      then 1 else 0)=1
    "Number of remote CHW differential pressure sensors used for CHW pump speed control"
    annotation (Evaluate=true,
    Dialog(group="Configuration",
      enable=cfg.have_chiWat and typ<>Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop));
  parameter Boolean have_inpSch(start=false)=false
    "Set to true to provide schedule via software input point"
    annotation (Dialog(group="Plant enable",
    enable=typ==Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater),
    Evaluate=true);
  final parameter Real schHea[:, 2]=dat.schHea
    "Heating mode enable schedule"
    annotation (Dialog(enable=not have_inpSch and
    typ==Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater,
    group="Plant enable"));
  final parameter Real schCoo[:, 2]=dat.schCoo
    "Cooling mode enable schedule"
    annotation (Dialog(enable=not have_inpSch and
    typ==Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater,
    group="Plant enable"));
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
    "Heat pump control bus"
    annotation (Placement(transformation(extent={{-260,320},{-220,360}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busPumHeaWatPri
    if cfg.typPumHeaWatPri<>Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None
    "Primary HW pump control bus"
    annotation (Placement(transformation(extent={{-260,60},{-220,100}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busPumHeaWatSec if cfg.typPumHeaWatSec
     == Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized
    "Secondary HW pump control bus"
    annotation (Placement(transformation(extent={{-260,20},{-220,60}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatPri if cfg.typPumChiWatPri
     <> Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None
    "Primary CHW pump control bus"
    annotation (Placement(transformation(extent={{-260,-180},{-220,-140}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatSec if cfg.typPumHeaWatSec
     == Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized
    "Secondary CHW pump control bus"
    annotation (Placement(transformation(extent={{-260,-220},{-220,-180}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValHeaWatHpInlIso[nHp]
    if cfg.have_heaWat and cfg.have_valHpInlIso
    "Heat pump inlet HW isolation valve control bus"
    annotation (Placement(transformation(extent={{-260,180},{-220,220}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValHeaWatHpOutIso[nHp]
    if cfg.have_heaWat and cfg.have_valHpOutIso
    "Heat pump outlet HW isolation valve control bus"
    annotation (Placement(transformation(extent={{-260,140},{-220,180}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatHpInlIso[nHp]
    if cfg.have_chiWat and cfg.have_valHpInlIso
    "Heat pump inlet CHW isolation valve control bus"
    annotation (Placement(transformation(extent={{-260,-60},{-220,-20}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatHpOutIso[nHp]
    if cfg.have_chiWat and cfg.have_valHpOutIso
    "Heat pump outlet CHW isolation valve control bus"
    annotation (Placement(transformation(extent={{-260,-100},{-220,-60}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatHrc if cfg.have_hrc
    "Sidestream HRC CHW pump control bus" annotation (Placement(transformation(
          extent={{-260,-340},{-220,-300}}), iconTransformation(extent={{-466,50},
            {-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busPumHeaWatHrc if cfg.have_hrc
    "Sidestream HRC HW pump control bus" annotation (Placement(transformation(
          extent={{-260,-380},{-220,-340}}), iconTransformation(extent={{-466,50},
            {-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busHrc if cfg.have_hrc
    "Sidestream HRC control bus" annotation (Placement(transformation(extent={{-260,
            -300},{-220,-260}}), iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValHeaWatMinByp
    if cfg.have_valHeaWatMinByp "HW minimum flow bypass valve control bus"
    annotation (Placement(transformation(extent={{-260,100},{-220,140}}),
        iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatMinByp
    if cfg.have_valChiWatMinByp "CHW minimum flow bypass valve control bus"
    annotation (Placement(transformation(extent={{-260,-140},{-220,-100}}),
        iconTransformation(extent={{-466,50},{-426,90}})));
equation
  /* Control point connection - start */
  connect(busPumHeaWatPri, bus.pumHeaWatPri);
  connect(busPumChiWatPri, bus.pumChiWatPri);
  connect(busPumChiWatSec, bus.pumChiWatSec);
  connect(busPumHeaWatSec, bus.pumHeaWatSec);
  connect(busHp, bus.hp);
  connect(busValHeaWatHpInlIso, bus.valHeaWatHpInlIso);
  connect(busValHeaWatHpOutIso, bus.valHeaWatHpOutIso);
  connect(busValChiWatHpInlIso, bus.valChiWatHpInlIso);
  connect(busValChiWatHpOutIso, bus.valChiWatHpOutIso);
  connect(busValHeaWatMinByp, bus.valHeaWatMinByp);
  connect(busValChiWatMinByp, bus.valChiWatMinByp);
  connect(busHrc, bus.hrc);
  connect(busPumChiWatHrc, bus.pumChiWatHrc);
  connect(busPumHeaWatHrc, bus.pumHeaWatHrc);
  /* Control point connection - stop */
annotation (
    Icon(
      coordinateSystem(
        preserveAspectRatio=false),
      graphics={
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
</html>",
      revisions="<html>
<ul>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialController;
