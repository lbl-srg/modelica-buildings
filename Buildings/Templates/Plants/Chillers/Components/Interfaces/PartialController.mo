within Buildings.Templates.Plants.Chillers.Components.Interfaces;
partial block PartialController "Interface class for plant controller"
  parameter Buildings.Templates.Plants.Chillers.Types.Controller typ
    "Type of controller"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Plants.Chillers.Configuration.ChillerPlant cfg
    "Plant configuration parameters"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Plants.Chillers.Types.ChillerLiftControl typCtlHea(
    start=Buildings.Templates.Plants.Chillers.Types.ChillerLiftControl.None)
    "Type of head pressure control"
    annotation (Evaluate=true, Dialog(group="Configuration",
       enable=typ == Buildings.Templates.Plants.Chillers.Types.Controller.G36
       and cfg.typChi == Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Boolean have_senDpChiWatRemWir=false
    "Set to true for remote CHW differential pressure sensor(s) hardwired to plant or pump controller"
    annotation (Evaluate=true,
      Dialog(group="Configuration",
      enable=typ==Buildings.Templates.Plants.Chillers.Types.Controller.G36 and (
        cfg.typDisChiWat == Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1Only
        or cfg.typDisChiWat == Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Variable2
        or cfg.typDisChiWat == Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2)));
  parameter Integer nSenDpChiWatRem(final min=if typ == Buildings.Templates.Plants.Chillers.Types.Controller.G36
         then 1 else 0) = 1
    "Number of remote CHW differential pressure sensors used for CHW pump speed control"
    annotation (Evaluate=true, Dialog(group="Configuration",
      enable=typ==Buildings.Templates.Plants.Chillers.Types.Controller.G36 and (
       cfg.typDisChiWat == Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1Only
       or cfg.typDisChiWat == Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Variable2
       or cfg.typDisChiWat == Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2)));
  parameter Integer nAirHan(
    final min=0)=0
    "Number of air handling units served by the plant"
    annotation(Dialog(group="Configuration",
    enable=typ == Buildings.Templates.Plants.Chillers.Types.Controller.G36),
    Evaluate=true);
  parameter Integer nEquZon(
    final min=0)=0
    "Number of terminal units (zone equipment) served by the plant"
    annotation(Dialog(group="Configuration",
    enable=typ == Buildings.Templates.Plants.Chillers.Types.Controller.G36),
    Evaluate=true);
  parameter Buildings.Templates.Plants.Chillers.Types.PrimaryOverflowMeasurement typMeaCtlChiWatPri(
    start=Buildings.Templates.Plants.Chillers.Types.PrimaryOverflowMeasurement.FlowDecoupler)
    "Type of sensors for primary CHW pump control in variable primary-variable secondary plants"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=typ ==
      Buildings.Templates.Plants.Chillers.Types.Controller.G36 and (
      cfg.typDisChiWat == Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2
      or cfg.typDisChiWat == Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2Distributed)));
  final parameter Boolean have_senVChiWatPri=
    if cfg.typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1Only then
      true
    elseif cfg.typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2
    or cfg.typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2Distributed then
      typMeaCtlChiWatPri==Buildings.Templates.Plants.Chillers.Types.PrimaryOverflowMeasurement.FlowDifference
    else false
    "Set to true for primary CHW flow sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Plants.Chillers.Types.SensorLocation locSenFloChiWatPri=
    Buildings.Templates.Plants.Chillers.Types.SensorLocation.Return
    "Location of primary CHW flow sensor"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=typ ==
          Buildings.Templates.Plants.Chillers.Types.Controller.G36 and
          have_senVChiWatPri));
  final parameter Boolean have_senVChiWatSec=
    cfg.typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Variable2 or
    cfg.typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2 or
    cfg.typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2Distributed
    "Set to true for secondary CHW flow sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Plants.Chillers.Types.SensorLocation locSenFloChiWatSec=
    Buildings.Templates.Plants.Chillers.Types.SensorLocation.Return
    "Location of secondary CHW flow sensor"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=typ ==
          Buildings.Templates.Plants.Chillers.Types.Controller.G36 and
          have_senVChiWatSec));

  parameter Boolean have_senTChiWatPriSup_select=false
    "Set to true for primary CHW supply temperature sensor"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=typ ==
          Buildings.Templates.Plants.Chillers.Types.Controller.G36 and
          cfg.typDisChiWat <> Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Only
           and cfg.typDisChiWat <> Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1Only));
  final parameter Boolean have_senTChiWatPriSup=
    cfg.typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Only
    or cfg.typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1Only
    or have_senTChiWatPlaRet_select
    "Set to true for plant CHW return temperature sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Boolean have_senTChiWatPlaRet_select=false
    "Set to true for plant CHW return temperature sensor"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=typ ==
          Buildings.Templates.Plants.Chillers.Types.Controller.G36 and
          cfg.typDisChiWat <> Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Only
           and cfg.typDisChiWat <> Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1Only));
  final parameter Boolean have_senTChiWatPlaRet=
    if cfg.typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Only
      then false
    elseif cfg.typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1Only
      then true
    else have_senTChiWatPlaRet_select
    "Set to true for plant CHW return temperature sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  // For plants with WSE, TChiWatEcoBef is used in place of TChiWatSecRet.
  final parameter Boolean have_senTChiWatSecRet=
    if cfg.typEco<>Buildings.Templates.Plants.Chillers.Types.Economizer.None
      then false
    else cfg.typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Variable2
      or cfg.typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2
      or cfg.typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2Distributed
    "Set to true for secondary CHW return temperature sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Buildings.Templates.Plants.Chillers.Types.CoolerFanSpeedControl typCtlFanCoo=
    Buildings.Templates.Plants.Chillers.Types.CoolerFanSpeedControl.SupplyTemperature
    "Cooler fan speed control"
    annotation (Evaluate=true, Dialog(group="Configuration",
    enable=typ ==Buildings.Templates.Plants.Chillers.Types.Controller.G36
    and cfg.typChi == Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Boolean is_clsCpl=true
    "Set to true if the plant is close coupled (pipe length from chillers to coolers under 30 m)"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=typ ==
          Buildings.Templates.Plants.Chillers.Types.Controller.G36));
  parameter Boolean have_senLevCoo=false
    "Set to true if cooling towers have level sensor for makeup water control"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=typ ==
          Buildings.Templates.Plants.Chillers.Types.Controller.G36 and cfg.typChi
           == Buildings.Templates.Components.Types.Chiller.WaterCooled and (
          cfg.typCoo == Buildings.Templates.Components.Types.Cooler.CoolingTowerOpen
           or cfg.typCoo == Buildings.Templates.Components.Types.Cooler.CoolingTowerClosed)));

  parameter Buildings.Templates.Plants.Chillers.Components.Data.Controller dat(
    cfg=cfg)
    "Parameter record for controller";

  final parameter Real sta[:,:]=dat.sta
    "Staging matrix with plant stage as row index and chiller as column index (highest index for optional WSE): 0 for disabled, 1 for enabled"
    annotation (Evaluate=true, Dialog(group="Plant staging",
    enable=typ == Buildings.Templates.Plants.Chillers.Types.Controller.G36));
  final parameter Integer nUniSta=dat.nUniSta
    "Number of units to stage, including chillers and optional WSE"
    annotation (Evaluate=true, Dialog(group="Plant staging"));
  final parameter Integer nSta=dat.nSta
    "Number of plant stages"
    annotation (Evaluate=true, Dialog(group="Plant staging"));

  Buildings.Templates.Plants.Chillers.Interfaces.Bus bus
    "Plant control bus"
    annotation (Placement(
        transformation(
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
  Buildings.Templates.Components.Interfaces.Bus busChi[cfg.nChi]
    "Chiller control bus"
    annotation (Placement(transformation(extent={{-260,180},{-220,220}}),
                        iconTransformation(extent={{-756,150},{-716,190}})));
  Buildings.Templates.Components.Interfaces.Bus busCoo[cfg.nCoo]
    if cfg.typCoo<>Buildings.Templates.Components.Types.Cooler.None
    "Cooler control bus"
    annotation (Placement(transformation(extent={{-260,-120},{-220,-80}}),
                         iconTransformation(extent={{-756,150},{-716,190}})));
  Buildings.Templates.Components.Interfaces.Bus busValCooInlIso[cfg.nCoo]
    if cfg.typValCooInlIso<>Buildings.Templates.Components.Types.Valve.None
    "Cooler inlet isolation valve control bus"
    annotation (Placement(
        transformation(extent={{-260,-160},{-220,-120}}), iconTransformation(
          extent={{-756,150},{-716,190}})));
  Buildings.Templates.Components.Interfaces.Bus busValCooOutIso[cfg.nCoo]
    if cfg.typValCooOutIso<>Buildings.Templates.Components.Types.Valve.None
    "Cooler outlet isolation valve control bus"
    annotation (Placement(
        transformation(extent={{-260,-200},{-220,-160}}), iconTransformation(
          extent={{-756,150},{-716,190}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatChiIso[cfg.nChi]
    if cfg.typValChiWatChiIso<>Buildings.Templates.Components.Types.Valve.None
    "Chiller CHW isolation valve control bus"
    annotation (Placement(
        transformation(extent={{-260,140},{-220,180}}), iconTransformation(extent=
           {{-756,150},{-716,190}})));
  Buildings.Templates.Components.Interfaces.Bus busValConWatChiIso[cfg.nChi]
    if cfg.typValConWatChiIso<>Buildings.Templates.Components.Types.Valve.None
    "Chiller CW isolation valve control bus"
    annotation (Placement(
        transformation(extent={{-260,100},{-220,140}}), iconTransformation(extent={{
            -756,150},{-716,190}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatChiBypSer[cfg.nChi] if
    cfg.typArrChi == Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series
    "Chiller CHW bypass valve control bus - Series chillers" annotation (
      Placement(transformation(extent={{-260,60},{-220,100}}),
        iconTransformation(extent={{-422,198},{-382,238}})));
equation
  connect(busValChiWatChiIso, bus.valChiWatChiIso) annotation (Line(
      points={{-240,160},{-220,160},{-220,0},{-260,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busChi, bus.chi) annotation (Line(
      points={{-240,200},{-210,200},{-210,0},{-260,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busCoo, bus.coo) annotation (Line(
      points={{-240,-100},{-240,0},{-260,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busValCooInlIso, bus.valCooInlIso) annotation (Line(
      points={{-240,-140},{-220,-140},{-220,0},{-260,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busValCooOutIso, bus.valCooOutIso) annotation (Line(
      points={{-240,-180},{-210,-180},{-210,0},{-260,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busValChiWatChiBypSer, bus.valChiWatChiByp) annotation (Line(
      points={{-240,80},{-240,0},{-260,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busValConWatChiIso, bus.valConWatChiIso) annotation (Line(
      points={{-240,120},{-228,120},{-228,0},{-260,0}},
      color={255,204,51},
      thickness=0.5));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                      graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-149,-114},{151,-154}},
          lineColor={0,0,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-260,-300},{260,300}})),
    Documentation(info="<html>
<p>
This partial class provides a standard interface for plant controllers.
</p>
<h4>Details</h4>
<p>
Array instances of nested expandable connectors are systematically
declared here to enhance support across various Modelica tools.
A typical connect clause such as
<code>connect(bus.nestedBus[:].y, sensor[:].y)</code>
raises issues when <code>nestedBus</code> is not explicitly declared
as Modelica compilers cannot decide to which variable the dimensionality
should be assigned between <code>nestedBus</code> and <code>y</code>
inside <code>nestedBus</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
November 18, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialController;
