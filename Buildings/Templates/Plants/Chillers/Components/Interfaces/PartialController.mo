within Buildings.Templates.Plants.Chillers.Components.Interfaces;
partial block PartialController
  "Interface class for plant controller"
  parameter Buildings.Templates.Plants.Chillers.Types.Controller typ
    "Type of controller"
    annotation(Evaluate=true);
  parameter Buildings.Templates.Plants.Chillers.Configuration.ChillerPlant cfg
    "Plant configuration parameters";
  parameter Integer nAirHan(
    final min=if typ == Buildings.Templates.Plants.Chillers.Types.Controller.G36
      and nEquZon == 0
      then 1 else 0,
    start=0)
    "Number of air handling units served by the plant"
    annotation(Dialog(group="Plant configuration",
      enable=typ == Buildings.Templates.Plants.Chillers.Types.Controller.G36),
      Evaluate=true);
  parameter Integer nEquZon(
    final min=if typ == Buildings.Templates.Plants.Chillers.Types.Controller.G36
      and nAirHan == 0
      then 1 else 0,
    start=0)
    "Number of terminal units (zone equipment) served by the plant"
    annotation(Dialog(group="Plant configuration",
      enable=typ == Buildings.Templates.Plants.Chillers.Types.Controller.G36),
      Evaluate=true);
  parameter Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Types.HeadPressureControl typCtlHea(
    start=Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Types.HeadPressureControl.NotRequired)
    "Type of head pressure control"
    annotation(Evaluate=true,
      Dialog(group="Chiller configuration",
        enable=typ == Buildings.Templates.Plants.Chillers.Types.Controller.G36
          and cfg.typChi ==
            Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Boolean is_clsCpl = true
    "Set to true if the plant is close coupled (pipe length from chillers to coolers under 30 m)"
    annotation(Evaluate=true,
      Dialog(group="Cooling tower configuration",
        enable=typ ==
          Buildings.Templates.Plants.Chillers.Types.Controller.G36));
  parameter Buildings.Templates.Plants.Chillers.Types.CoolerFanSpeedControl typCtlFanCoo =
    Buildings.Templates.Plants.Chillers.Types.CoolerFanSpeedControl.SupplyTemperature
    "Cooler fan speed control"
    annotation(Evaluate=true,
      Dialog(group="Cooling tower configuration",
        enable=typ == Buildings.Templates.Plants.Chillers.Types.Controller.G36
          and cfg.typChi ==
            Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Boolean have_senLevCoo = false
    "Set to true if cooling towers have level sensor for makeup water control"
    annotation(Evaluate=true,
      Dialog(group="Sensors",
        enable=typ == Buildings.Templates.Plants.Chillers.Types.Controller.G36
          and cfg.typChi ==
            Buildings.Templates.Components.Types.Chiller.WaterCooled
          and (cfg.typCoo ==
            Buildings.Templates.Components.Types.Cooler.CoolingTowerOpen
            or cfg.typCoo ==
              Buildings.Templates.Components.Types.Cooler.CoolingTowerClosed)));
  parameter Boolean have_senDpChiWatRemWir = false
    "Set to true for remote CHW differential pressure sensor(s) hardwired to plant or pump controller"
    annotation(Evaluate=true,
      Dialog(group="Sensors",
        enable=typ == Buildings.Templates.Plants.Chillers.Types.Controller.G36
          and (cfg.typDisChiWat ==
            Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1Only
            or cfg.typDisChiWat ==
              Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Variable2
            or cfg.typDisChiWat ==
              Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2)));
  parameter Integer nSenDpChiWatRem(
    final min=if typ == Buildings.Templates.Plants.Chillers.Types.Controller.G36
      then 1 else 0) = 1
    "Number of remote CHW differential pressure sensors used for CHW pump speed control"
    annotation(Evaluate=true,
      Dialog(group="Sensors",
        enable=typ == Buildings.Templates.Plants.Chillers.Types.Controller.G36
          and (cfg.typDisChiWat ==
            Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1Only
            or cfg.typDisChiWat ==
              Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Variable2
            or cfg.typDisChiWat ==
              Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2)));
  parameter Buildings.Templates.Plants.Chillers.Types.PrimaryOverflowMeasurement typMeaCtlChiWatPri(
    start=Buildings.Templates.Plants.Chillers.Types.PrimaryOverflowMeasurement.FlowDecoupler)
    "Type of sensors for primary CHW pump control in variable primary-variable secondary plants"
    annotation(Evaluate=true,
      Dialog(group="Sensors",
        enable=typ == Buildings.Templates.Plants.Chillers.Types.Controller.G36
          and (cfg.typDisChiWat ==
            Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2
            or cfg.typDisChiWat ==
              Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2Distributed)));
  final parameter Boolean have_senVChiWatPri =
    if cfg.typDisChiWat ==
      Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1Only
    then true
    elseif cfg.typDisChiWat ==
      Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2
      or cfg.typDisChiWat ==
        Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2Distributed
    then typMeaCtlChiWatPri ==
      Buildings.Templates.Plants.Chillers.Types.PrimaryOverflowMeasurement.FlowDifference
    else false
    "Set to true for plants with primary CHW flow sensor"
    annotation(Evaluate=true,
      Dialog(group="Sensors"));
  parameter Buildings.Templates.Plants.Chillers.Types.SensorLocation locSenFloChiWatPri =
    Buildings.Templates.Plants.Chillers.Types.SensorLocation.Return
    "Location of primary CHW flow sensor"
    annotation(Evaluate=true,
      Dialog(group="Sensors",
        enable=typ == Buildings.Templates.Plants.Chillers.Types.Controller.G36
          and have_senVChiWatPri));
  final parameter Boolean have_senVChiWatSec =
    cfg.typDisChiWat ==
      Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Variable2
      or cfg.typDisChiWat ==
        Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2
      or cfg.typDisChiWat ==
        Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2Distributed
    "Set to true for plants with secondary CHW flow sensor"
    annotation(Evaluate=true,
      Dialog(group="Sensors"));
  parameter Buildings.Templates.Plants.Chillers.Types.SensorLocation locSenFloChiWatSec =
    Buildings.Templates.Plants.Chillers.Types.SensorLocation.Return
    "Location of secondary CHW flow sensor"
    annotation(Evaluate=true,
      Dialog(group="Sensors",
        enable=typ == Buildings.Templates.Plants.Chillers.Types.Controller.G36
          and have_senVChiWatSec));
  parameter Boolean have_senTChiWatPriSup_select = false
    "Set to true for plants with primary CHW supply temperature sensor"
    annotation(Evaluate=true,
      Dialog(group="Sensors",
        enable=typ == Buildings.Templates.Plants.Chillers.Types.Controller.G36
          and cfg.typDisChiWat <>
            Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Only
          and cfg.typDisChiWat <>
            Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1Only));
  final parameter Boolean have_senTChiWatPriSup =
    cfg.typDisChiWat ==
      Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Only
      or cfg.typDisChiWat ==
        Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1Only
      or have_senTChiWatPriSup_select
    "Set to true for plants with CHW supply temperature sensor"
    annotation(Evaluate=true,
      Dialog(group="Sensors"));
  parameter Boolean have_senTChiWatPlaRet_select = false
    "Set to true for plants with CHW return temperature sensor"
    annotation(Evaluate=true,
      Dialog(group="Sensors",
        enable=typ == Buildings.Templates.Plants.Chillers.Types.Controller.G36
          and cfg.typDisChiWat <>
            Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Only
          and cfg.typDisChiWat <>
            Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1Only));
  final parameter Boolean have_senTChiWatPlaRet =
    if cfg.typDisChiWat ==
      Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Only
    then false
    elseif cfg.typDisChiWat ==
      Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1Only
    then true
    else have_senTChiWatPlaRet_select
    "Set to true for plants with CHW return temperature sensor"
    annotation(Evaluate=true,
      Dialog(group="Sensors"));
  // For plants with WSE, TChiWatEcoBef is used in place of TChiWatSecRet.
  final parameter Boolean have_senTChiWatSecRet =
    if cfg.typEco <> Buildings.Templates.Plants.Chillers.Types.Economizer.None
    then false
    else cfg.typDisChiWat ==
      Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Variable2 or
      cfg.typDisChiWat ==
      Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2 or
      cfg.typDisChiWat ==
      Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2Distributed
    "Set to true for plants with secondary CHW return temperature sensor"
    annotation(Evaluate=true,
      Dialog(group="Sensors"));
  parameter Buildings.Templates.Plants.Chillers.Components.Data.Controller dat(
    cfg=cfg)
    "Parameter record for controller";
  Buildings.Templates.Plants.Chillers.Interfaces.Bus bus
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
  protected
  Buildings.Templates.Components.Interfaces.Bus busChi[cfg.nChi]
    "Chiller control bus"
    annotation(Placement(transformation(extent={{-260,260},{-220,300}}),
      iconTransformation(extent={{-756,150},{-716,190}})));
  Buildings.Templates.Components.Interfaces.Bus busCoo
    if cfg.typCoo <> Buildings.Templates.Components.Types.Cooler.None
    "Cooler group control bus"
    annotation(Placement(transformation(extent={{-260,-100},{-220,-60}}),
      iconTransformation(extent={{-756,150},{-716,190}})));
  Buildings.Templates.Components.Interfaces.Bus busValCooInlIso[cfg.nCoo]
    if cfg.typValCooInlIso <> Buildings.Templates.Components.Types.Valve.None
    "Cooler inlet isolation valve control bus"
    annotation(Placement(transformation(extent={{-260,-140},{-220,-100}}),
      iconTransformation(extent={{-756,150},{-716,190}})));
  Buildings.Templates.Components.Interfaces.Bus busValCooOutIso[cfg.nCoo]
    if cfg.typValCooOutIso <> Buildings.Templates.Components.Types.Valve.None
    "Cooler outlet isolation valve control bus"
    annotation(Placement(transformation(extent={{-260,-180},{-220,-140}}),
      iconTransformation(extent={{-756,150},{-716,190}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatChiIso[cfg.nChi]
    if cfg.typValChiWatChiIso <> Buildings.Templates.Components.Types.Valve.None
    "Chiller CHW isolation valve control bus"
    annotation(Placement(transformation(extent={{-260,220},{-220,260}}),
      iconTransformation(extent={{-756,150},{-716,190}})));
  Buildings.Templates.Components.Interfaces.Bus busValConWatChiIso[cfg.nChi]
    if cfg.typValConWatChiIso <> Buildings.Templates.Components.Types.Valve.None
    "Chiller CW isolation valve control bus"
    annotation(Placement(transformation(extent={{-260,60},{-220,100}}),
      iconTransformation(extent={{-756,150},{-716,190}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatChiBypSer[cfg.nChi]
    if cfg.typArrChi ==
      Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series
    "Chiller CHW bypass valve control bus - Series chillers"
    annotation(Placement(transformation(extent={{-260,180},{-220,220}}),
      iconTransformation(extent={{-422,198},{-382,238}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatPri
    "Primary CHW pump control bus"
    annotation(Placement(transformation(extent={{-260,20},{-220,60}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busPumConWat
    if cfg.nPumConWat > 0
    "CW pump control bus"
    annotation(Placement(transformation(extent={{-260,-60},{-220,-20}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatSec
    if cfg.have_pumChiWatSec
    "Secondary CHW pump control bus"
    annotation(Placement(transformation(extent={{-260,-20},{-220,20}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatEco
    if cfg.typEco ==
      Buildings.Templates.Plants.Chillers.Types.Economizer.HeatExchangerWithPump
    "WSE CHW HX pump control bus"
    annotation(Placement(transformation(extent={{-260,-300},{-220,-260}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatEcoByp
    if cfg.typEco ==
      Buildings.Templates.Plants.Chillers.Types.Economizer.HeatExchangerWithValve
    "WSE CHW bypass valve control bus"
    annotation(Placement(transformation(extent={{-260,-260},{-220,-220}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatChiBypPar
    if cfg.have_valChiWatChiBypPar
    "Chiller CHW bypass valve control bus – Parallel chillers with WSE in primary-only plants"
    annotation(Placement(transformation(extent={{-260,140},{-220,180}}),
      iconTransformation(extent={{-422,198},{-382,238}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatMinByp
    if cfg.typDisChiWat ==
      Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1Only
    "CHW minimum flow bypass valve control bus"
    annotation(Placement(transformation(extent={{-260,100},{-220,140}}),
      iconTransformation(extent={{-422,198},{-382,238}})));
  Buildings.Templates.Components.Interfaces.Bus busValConWatEcoIso
    if cfg.typEco ==
      Buildings.Templates.Plants.Chillers.Types.Economizer.HeatExchangerWithValve
    "WSE HX CW isolation valve control bus"
    annotation(Placement(transformation(extent={{-260,-220},{-220,-180}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
equation
  /* Control point connection - start */
  connect(busValChiWatChiIso, bus.valChiWatChiIso);
  connect(busChi, bus.chi);
  connect(busCoo, bus.coo);
  connect(busValCooInlIso, bus.valCooInlIso);
  connect(busValCooOutIso, bus.valCooOutIso);
  connect(busValChiWatChiBypSer, bus.valChiWatChiByp);
  connect(busValConWatChiIso, bus.valConWatChiIso);
  connect(busPumConWat, bus.pumConWat);
  connect(busPumChiWatSec, bus.pumChiWatSec);
  connect(busPumChiWatPri, bus.pumChiWatPri);
  connect(busValChiWatEcoByp, bus.valChiWatEcoByp);
  connect(busPumChiWatEco, bus.pumChiWatEco);
  connect(busValChiWatChiBypPar, bus.valChiWatChiBypPar);
  connect(busValChiWatMinByp, bus.valChiWatMinByp);
  connect(busValConWatEcoIso, bus.valConWatEcoIso);
  /* Control point connection - stop */
annotation(Icon(coordinateSystem(preserveAspectRatio=false,
  extent={{-100,-100},{100,100}}),
  graphics={Rectangle(extent={{-100,-100},{100,100}},
    lineColor={0,0,127},
    fillColor={255,255,255},
    fillPattern=FillPattern.Solid),
  Text(extent={{-149,-114},{151,-154}},
    textString="%name")}),
  Diagram(coordinateSystem(preserveAspectRatio=false,
    extent={{-260,-300},{260,300}})),
  Documentation(
    info="<html>
<p>This partial class provides a standard interface for plant controllers.</p>
<h4>Details</h4>
<p>
  Array instances of nested expandable connectors are systematically declared
  here to enhance support across various Modelica tools. A typical connect
  clause such as <code>connect(bus.nestedBus[:].y, sensor[:].y)</code> raises
  issues when <code>nestedBus</code> is not explicitly declared because Modelica
  compilers cannot decide to which variable the dimensionality should be
  assigned between <code>nestedBus</code> and <code>y</code> inside
  <code>nestedBus</code>.
</p>
</html>",
    revisions="<html>
<ul>
  <li>
    November 18, 2022, by Antoine Gautier:<br />
    First implementation.
  </li>
</ul>
</html>"));
end PartialController;
