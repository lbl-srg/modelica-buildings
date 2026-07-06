within Buildings.Templates.Plants.HeatPumps.Components.Interfaces;
block PartialController
  "Interface for heat pump plant controller"
  /*
   * The following bindings are for parameters that are propagated *up*
   * from the controller to the plant configuration record.
   * All other configuration parameters (e.g. nHp) are propagated *down*
   * from the plant configuration record to the controller.
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
    annotation(Evaluate=true,
      Dialog(group="Configuration",
        enable=false));
  parameter Buildings.Templates.Plants.HeatPumps.Components.Data.Controller dat(
    cfg=cfg)
    "Parameter record for controller";
  final parameter Integer nHp = cfg.nHp
    "Number of heat pumps (excluding polyvalent HPs)"
    annotation(Evaluate=true);
  final parameter Integer nPhp = cfg.nPhp
    "Number of polyvalent heat pumps"
    annotation(Evaluate=true);
  parameter Buildings.Templates.Plants.HeatPumps.Types.Controller typ
    "Type of controller"
    annotation(Evaluate=true,
      Dialog(group="Configuration"));
  parameter Integer nAirHan(
    final min=if typ <>
      Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop
      and nEquZon == 0 then 1 else 0,
    start=0)
    "Number of air handling units served by the plant"
    annotation(Evaluate=true,
      Dialog(group="Configuration",
        enable=typ <>
          Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop));
  parameter Integer nEquZon(
    final min=if typ <>
      Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop
      and nAirHan == 0 then 1 else 0,
    start=0)
    "Number of terminal units (zone equipment) served by the plant"
    annotation(Evaluate=true,
      Dialog(group="Configuration",
        enable=typ <>
          Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop));
  // Sensor configuration: see the code comments in
  // Buildings.Templates.Plants.Controls.HeatPumps.AirToWater
  // for the rationale to enable the parameters *_select below.
  parameter Boolean have_senTPriRet_select(start=false) = false
    "Set to true for plants with primary CHW/HW return temperature sensor"
    annotation(Evaluate=true,
      Dialog(group="Sensors",
        enable=typ <>
          Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop
          and cfg.typDis <>
            Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only));
  parameter Boolean have_senTLooRet_select(start=false) = false
    "Set to true for plants with CHW/HW loop return temperature sensor (load side of minimum flow bypass)"
    annotation(Evaluate=true,
      Dialog(group="Sensors",
        enable=typ <>
          Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop
          and cfg.typDis ==
            Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only
          and not cfg.have_hrc));
  parameter Boolean have_senDpHeaWatRemWir = false
    "Set to true for remote HW differential pressure sensor(s) hardwired to plant or pump controller"
    annotation(Evaluate=true,
      Dialog(group="Sensors",
        enable=typ <>
          Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop));
  parameter Integer nSenDpHeaWatRem(
    final min=if typ <>
      Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop then 1
      else 0) = 1
    "Number of remote HW differential pressure sensors used for HW pump speed control"
    annotation(Evaluate=true,
      Dialog(group="Sensors",
        enable=typ <>
          Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop));
  parameter Boolean have_senDpChiWatRemWir = have_senDpHeaWatRemWir
    "Set to true for remote CHW differential pressure sensor(s) hardwired to plant or pump controller"
    annotation(Evaluate=true,
      Dialog(group="Sensors",
        enable=cfg.have_chiWat
          and typ <>
            Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop));
  parameter Integer nSenDpChiWatRem(
    final min=if typ <>
      Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop then 1
      else 0) = 1
    "Number of remote CHW differential pressure sensors used for CHW pump speed control"
    annotation(Evaluate=true,
      Dialog(group="Sensors",
        enable=cfg.have_chiWat
          and typ <>
            Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop));
  parameter Boolean have_inpSch(start=false) = false
    "Set to true to provide schedule via software input point"
    annotation(Dialog(group="Plant enable",
      enable=typ ==
        Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater),
      Evaluate=true);
  final parameter Real schHea[:, 2] = dat.schHea
    "Heating mode enable schedule"
    annotation(Dialog(
      enable=not have_inpSch
        and typ ==
          Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater,
      group="Plant enable"));
  final parameter Real schCoo[:, 2] = dat.schCoo
    "Cooling mode enable schedule"
    annotation(Dialog(
      enable=not have_inpSch
        and typ ==
          Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater,
      group="Plant enable"));
  // Bind the following disabled parameters to the corresponding controller
  // parameters in derived class to avoid duplicating final assignment equations.
  parameter Boolean have_senVHeaWatPri
    "Set to true for plants with primary HW flow sensor"
    annotation(Evaluate=true,
      Dialog(enable=false));
  parameter Boolean have_senVHeaWatLoo
    "Set to true for plants with HW loop flow sensor"
    annotation(Evaluate=true,
      Dialog(enable=false));
  parameter Boolean have_senVHeaWatSec
    "Set to true for plants with secondary HW flow sensor"
    annotation(Evaluate=true,
      Dialog(enable=false));
  parameter Boolean have_senVChiWatPri
    "Set to true for plants with primary CHW flow sensor"
    annotation(Evaluate=true,
      Dialog(enable=false));
  parameter Boolean have_senVChiWatLoo
    "Set to true for plants with CHW loop flow sensor"
    annotation(Evaluate=true,
      Dialog(enable=false));
  parameter Boolean have_senVChiWatSec
    "Set to true for plants with secondary CHW flow sensor"
    annotation(Evaluate=true,
      Dialog(enable=false));
  parameter Boolean have_senTHeaWatPriRet
    "Set to true for plants with primary HW return temperature sensor"
    annotation(Evaluate=true,
      Dialog(enable=false));
  parameter Boolean have_senTHeaWatLooRet
    "Set to true for plants with HW loop return temperature sensor"
    annotation(Evaluate=true,
      Dialog(enable=false));
  parameter Boolean have_senTChiWatPriRet
    "Set to true for plants with primary CHW return temperature sensor"
    annotation(Evaluate=true,
      Dialog(enable=false));
  parameter Boolean have_senTChiWatLooRet
    "Set to true for plants with CHW loop return temperature sensor"
    annotation(Evaluate=true,
      Dialog(enable=false));
  parameter Boolean have_senTHeaWatSecSup
    "Set to true for plants with secondary HW supply temperature sensor"
    annotation(Evaluate=true,
      Dialog(enable=false));
  parameter Boolean have_senTChiWatSecSup
    "Set to true for plants with secondary CHW supply temperature sensor"
    annotation(Evaluate=true,
      Dialog(enable=false));
  parameter Boolean have_senTHeaWatSecRet
    "Set to true for plants with secondary HW return temperature sensor"
    annotation(Evaluate=true,
      Dialog(enable=false));
  parameter Boolean have_senTChiWatSecRet
    "Set to true for plants with secondary CHW return temperature sensor"
    annotation(Evaluate=true,
      Dialog(enable=false));
  Buildings.Templates.Plants.HeatPumps.Interfaces.Bus bus
    "Plant control bus"
    annotation(Placement(transformation(extent={{-20,-20},{20,20}},
      rotation=90,
      origin={-260,0}),
      iconTransformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-100,0})));
  Buildings.Templates.AirHandlersFans.Interfaces.Bus busAirHan[nAirHan]
    if nAirHan > 0
    "Air handling unit control bus"
    annotation(Placement(transformation(extent={{-20,-20},{20,20}},
      rotation=-90,
      origin={260,140}),
      iconTransformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={100,60})));
  Buildings.Templates.ZoneEquipment.Interfaces.Bus busEquZon[nEquZon]
    if nEquZon > 0
    "Terminal unit control bus"
    annotation(Placement(transformation(extent={{-20,-20},{20,20}},
      rotation=-90,
      origin={260,-140}),
      iconTransformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={100,-60})));
  Controls.PrimaryPumpSignalRouting rouPumChiWatPri(
    final typ=cfg.typPumChiWatPri,
    final typArr=cfg.typArrPumPri,
    final nPum=cfg.nPumChiWatPri,
    nHp=if cfg.have_pumChiWatPriDedHp then cfg.nHp else 0,
    final nPhp=cfg.nPhp)
    if cfg.typPumChiWatPri <>
      Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None
    "Primary CHW pump signal routing"
    annotation(Placement(transformation(extent={{-210,-180},{-190,-160}})));
  Controls.PrimaryPumpSignalRouting rouPumHeaWatPri(
    final typ=cfg.typPumHeaWatPri,
    final typArr=cfg.typArrPumPri,
    final nPum=cfg.nPumHeaWatPri,
    nHp=cfg.nHp,
    final nPhp=cfg.nPhp)
    if cfg.typPumHeaWatPri <>
      Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None
    "Primary HW pump signal routing"
    annotation(Placement(transformation(extent={{-210,60},{-190,80}})));
  protected
  Buildings.Templates.Components.Interfaces.Bus busHp[nHp]
    if cfg.have_hp
    "Heat pump control bus"
    annotation(Placement(transformation(extent={{-260,320},{-220,360}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busPumHeaWatPri
    if cfg.typPumHeaWatPri <>
      Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None
    "Primary HW pump control bus"
    annotation(Placement(transformation(extent={{-260,60},{-220,100}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busPumHeaWatSec
    if cfg.typPumHeaWatSec ==
      Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized
    "Secondary HW pump control bus"
    annotation(Placement(transformation(extent={{-260,20},{-220,60}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatPri
    if cfg.typPumChiWatPri <>
      Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None
    "Primary CHW pump control bus"
    annotation(Placement(transformation(extent={{-260,-180},{-220,-140}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatSec
    if cfg.typPumHeaWatSec ==
      Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized
    "Secondary CHW pump control bus"
    annotation(Placement(transformation(extent={{-260,-220},{-220,-180}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValHeaWatHpInlIso[nHp]
    if cfg.have_hp and cfg.have_heaWat and cfg.have_valHpInlIso
    "Heat pump inlet HW isolation valve control bus"
    annotation(Placement(transformation(extent={{-260,180},{-220,220}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValHeaWatHpOutIso[nHp]
    if cfg.have_hp and cfg.have_heaWat and cfg.have_valHpOutIso
    "Heat pump outlet HW isolation valve control bus"
    annotation(Placement(transformation(extent={{-260,140},{-220,180}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatHpInlIso[nHp]
    if cfg.have_hp and cfg.have_chiWat and cfg.have_valHpInlIso
    "Heat pump inlet CHW isolation valve control bus"
    annotation(Placement(transformation(extent={{-260,-60},{-220,-20}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatHpOutIso[nHp]
    if cfg.have_hp and cfg.have_chiWat and cfg.have_valHpOutIso
    "Heat pump outlet CHW isolation valve control bus"
    annotation(Placement(transformation(extent={{-260,-100},{-220,-60}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatHrc
    if cfg.have_hrc
    "Sidestream HRC CHW pump control bus"
    annotation(Placement(transformation(extent={{-260,-340},{-220,-300}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busPumHeaWatHrc
    if cfg.have_hrc
    "Sidestream HRC HW pump control bus"
    annotation(Placement(transformation(extent={{-260,-380},{-220,-340}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busHrc
    if cfg.have_hrc
    "Sidestream HRC control bus"
    annotation(Placement(transformation(extent={{-260,-300},{-220,-260}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValHeaWatMinByp
    if cfg.have_valHeaWatMinByp
    "HW minimum flow bypass valve control bus"
    annotation(Placement(transformation(extent={{-260,100},{-220,140}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatMinByp
    if cfg.have_valChiWatMinByp
    "CHW minimum flow bypass valve control bus"
    annotation(Placement(transformation(extent={{-260,-140},{-220,-100}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValHeaWatPhpInlIso[nPhp]
    if cfg.have_php and cfg.have_heaWat and cfg.have_valPhpInlIso
    "Polyvalent HP inlet HW isolation valve control bus"
    annotation(Placement(transformation(extent={{-180,180},{-140,220}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValHeaWatPhpOutIso[nPhp]
    if cfg.have_php and cfg.have_heaWat and cfg.have_valPhpOutIso
    "Polyvalent HP outlet HW isolation valve control bus"
    annotation(Placement(transformation(extent={{-180,140},{-140,180}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatPhpInlIso[nPhp]
    if cfg.have_php and cfg.have_chiWat and cfg.have_valPhpInlIso
    "Polyvalent HP inlet CHW isolation valve control bus"
    annotation(Placement(transformation(extent={{-180,-60},{-140,-20}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatPhpOutIso[nPhp]
    if cfg.have_php and cfg.have_chiWat and cfg.have_valPhpOutIso
    "Polyvalent HP outlet CHW isolation valve control bus"
    annotation(Placement(transformation(extent={{-180,-100},{-140,-60}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busPhp[nPhp]
    if cfg.have_php
    "Polyvalent HP control bus"
    annotation(Placement(transformation(extent={{-180,320},{-140,360}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
equation
  /* Control point connection - start */
  connect(busHp, bus.hp);
  connect(busHrc, bus.hrc);
  connect(busPumChiWatHrc, bus.pumChiWatHrc);
  connect(busPumChiWatPri, bus.pumChiWatPri);
  connect(busPumChiWatSec, bus.pumChiWatSec);
  connect(busPumHeaWatHrc, bus.pumHeaWatHrc);
  connect(busPumHeaWatPri, bus.pumHeaWatPri);
  connect(busPumHeaWatSec, bus.pumHeaWatSec);
  connect(busPhp, bus.php);
  connect(busValChiWatHpInlIso, bus.valChiWatHpInlIso);
  connect(busValChiWatHpOutIso, bus.valChiWatHpOutIso);
  connect(busValChiWatPhpInlIso, bus.valChiWatPhpInlIso);
  connect(busValChiWatPhpOutIso, bus.valChiWatPhpOutIso);
  connect(busValChiWatMinByp, bus.valChiWatMinByp);
  connect(busValHeaWatHpInlIso, bus.valHeaWatHpInlIso);
  connect(busValHeaWatHpOutIso, bus.valHeaWatHpOutIso);
  connect(busValHeaWatPhpInlIso, bus.valHeaWatPhpInlIso);
  connect(busValHeaWatPhpOutIso, bus.valHeaWatPhpOutIso);
  connect(busValHeaWatMinByp, bus.valHeaWatMinByp);
  /* Control point connection - stop */
  connect(rouPumChiWatPri.bus, busPumChiWatPri)
    annotation(Line(points={{-200,-160},{-240,-160}},
      color={255,204,51},
      thickness=0.5));
  connect(rouPumHeaWatPri.bus, busPumHeaWatPri)
    annotation(Line(points={{-200,80},{-240,80}},
      color={255,204,51},
      thickness=0.5));
annotation(Icon(coordinateSystem(preserveAspectRatio=false),
  graphics={Rectangle(extent={{-100,100},{100,-100}},
    lineColor={0,0,255},
    fillColor={255,255,255},
    fillPattern=FillPattern.Solid),
  Text(extent={{-150,150},{150,110}},
    textString="%name",
    textColor={0,0,255})}),
  Diagram(coordinateSystem(preserveAspectRatio=false,
    extent={{-260,-380},{260,380}})),
  Documentation(
    info="<html>
<p>
  This partial class provides a standard interface for heat pump plant
  controllers.
</p>
</html>",
    revisions="<html>
<ul>
  <li>
    March 29, 2024, by Antoine Gautier:<br />
    First implementation.
  </li>
</ul>
</html>"));
end PartialController;
