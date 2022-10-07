within Buildings.Templates.ChilledWaterPlants.Components.Interfaces;
partial block PartialController "Interface class for plant controller"
  parameter Buildings.Templates.ChilledWaterPlants.Types.Controller typ
    "Type of controller"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Chiller typChi
    "Type of chiller"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Integer nChi(start=1)
    "Number of chillers"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement typArrChi
    "Type of chiller arrangement"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.ChilledWaterPlants.Types.Distribution typDisChiWat
    "Type of CHW distribution system"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  final parameter Boolean have_pumChiWatSec=
    typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Constant1Variable2 or
    typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1And2
    "Set to true if the plant includes secondary CHW pumps"
    annotation(Evaluate=true, Dialog(group="Configuration"));
  parameter Integer nPumChiWatPri(
    start=1,
    final min=1)=nChi
    "Number of primary CHW pumps"
    annotation (Evaluate=true, Dialog(group="Configuration",
    enable=typArrPumChiWatPri == Buildings.Templates.Components.Types.PumpArrangement.Headered));
  parameter Buildings.Templates.Components.Types.PumpArrangement
    typArrPumChiWatPri "Type of primary CHW pump arrangement"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Integer nPumConWat(
    start=1,
    final min=0)=nChi
    "Number of CW pumps"
    annotation (Evaluate=true, Dialog(group="Configuration",
    enable=typChi == Buildings.Templates.Components.Types.Chiller.WaterCooled
           and typArrPumConWat == Buildings.Templates.Components.Types.PumpArrangement.Headered));
  parameter Buildings.Templates.Components.Types.PumpArrangement
    typArrPumConWat
    "Type of CW pump arrangement"
    annotation (Evaluate=true,
      Dialog(group="Configuration", enable=typChi == Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Boolean have_varPumChiWatPri
    "Set to true for variable speed primary CHW pumps, false for constant speed pumps"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_varComPumChiWatPri
    "Set to true for single common speed signal for primary CHW pumps, false for dedicated signals"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_varPumConWat(
    start=false)
    annotation (Evaluate=true, Dialog(group="Configuration",
    enable=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Boolean have_varComPumConWat(
    start=false)
    "Set to true for single common speed signal for CW pumps, false for dedicated signals"
    annotation (Evaluate=true, Dialog(group="Configuration",
    enable=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Buildings.Templates.ChilledWaterPlants.Types.ChillerLiftControl typCtrHea
    "Type of head pressure control"
    annotation (Evaluate=true, Dialog(group="Configuration",
    enable=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Buildings.Templates.ChilledWaterPlants.Types.Economizer typEco
    "Type of WSE"
    annotation (Evaluate=true, Dialog(group="Configuration",
    enable=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Buildings.Templates.Components.Types.Cooler typCoo
    "Condenser water cooling equipment"
    annotation(Evaluate=true, Dialog(group="Configuration",
    enable=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Integer nCoo(
    start=1,
    final min=0)=nChi
    "Number of cooler units"
    annotation (Evaluate=true, Dialog(group="Configuration",
    enable=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Integer nPumChiWatSec(
    start=1,
    final min=0)=nChi
    "Number of secondary CHW pumps"
    annotation (Evaluate=true, Dialog(group="Configuration",
    enable=typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Constant1Variable2
     or typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1And2));
  parameter Integer nLooChiWatSec=1
    "Number of secondary CHW loops"
    annotation (Evaluate=true, Dialog(group="Configuration",
    enable=typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1And2Distributed));
  parameter Buildings.Templates.Components.Types.Valve typValChiWatChiIso
    "Type of chiller CHW isolation valve"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Valve typValConWatChiIso
    "Type of chiller CW isolation valve"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Valve typValCooInlIso
    "Cooler inlet isolation valve"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Valve typValCooOutIso
    "Cooler outlet isolation valve"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Boolean have_senDpChiWatLoc = false
    "Set to true for local CHW differential pressure sensor hardwired to plant controller"
    annotation (Evaluate=true, Dialog(group="Configuration",
    enable=typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1Only
    or typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Constant1Variable2
    or typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1And2));
  parameter Integer nSenDpChiWatRem(
    final min=if typ==Buildings.Templates.ChilledWaterPlants.Types.Controller.Guideline36
    then 1 else 0)=1
    "Number of remote CHW differential pressure sensors used for CHW pump speed control"
    annotation (Evaluate=true, Dialog(group="Configuration",
    enable=typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1Only
    or typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Constant1Variable2
    or typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1And2));

  parameter Buildings.Templates.ChilledWaterPlants.Types.PrimaryOverflowMeasurement typMeaCtrChiWatPri(
    start=Buildings.Templates.ChilledWaterPlants.Types.PrimaryOverflowMeasurement.FlowDecoupler)
    "Type of sensors for primary CHW pump control in variable primary-variable secondary plants"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=
    typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1And2
    or typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1And2Distributed));

  final parameter Boolean have_senVChiWatPri=
    if typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1Only then
      true
    elseif typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1And2
    or typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1And2Distributed then
      typMeaCtrChiWatPri==Buildings.Templates.ChilledWaterPlants.Types.PrimaryOverflowMeasurement.FlowDifference
    else false
    "Set to true for primary CHW flow sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.ChilledWaterPlants.Types.SensorLocation locSenFloChiWatPri=
     Buildings.Templates.ChilledWaterPlants.Types.SensorLocation.Return
     "Location of primary CHW flow sensor"
     annotation (Evaluate=true, Dialog(group="Configuration", enable=have_senVChiWatPri));
  final parameter Boolean have_senVChiWatSec=
    typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Constant1Variable2 or
    typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1And2 or
    typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1And2Distributed
    "Set to true for secondary CHW flow sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.ChilledWaterPlants.Types.SensorLocation locSenFloChiWatSec=
     Buildings.Templates.ChilledWaterPlants.Types.SensorLocation.Return
     "Location of secondary CHW flow sensor"
     annotation (Evaluate=true, Dialog(group="Configuration", enable=have_senVChiWatSec));

  parameter Boolean have_senTChiWatPriSup_select=false
    "Set to true for primary CHW supply temperature sensor"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=
    typDisChiWat<>Buildings.Templates.ChilledWaterPlants.Types.Distribution.Constant1Only and
    typDisChiWat<>Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1Only));
  final parameter Boolean have_senTChiWatPriSup=
    typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Constant1Only
    or typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1Only
    or have_senTChiWatPlaRet_select
    "Set to true for plant CHW return temperature sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Boolean have_senTChiWatPlaRet_select=false
    "Set to true for plant CHW return temperature sensor"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=
    typDisChiWat<>Buildings.Templates.ChilledWaterPlants.Types.Distribution.Constant1Only and
    typDisChiWat<>Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1Only));
  final parameter Boolean have_senTChiWatPlaRet=
    if typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Constant1Only
      then false
    elseif typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1Only
      then true
    else have_senTChiWatPlaRet_select
    "Set to true for plant CHW return temperature sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  final parameter Boolean have_senTChiWatSecRet=
    if typEco<>Buildings.Templates.ChilledWaterPlants.Types.Economizer.None
      then false
    else typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Constant1Variable2
      or typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1And2
      or typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1And2Distributed
    "Set to true for secondary CHW return temperature sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Buildings.Templates.ChilledWaterPlants.Types.CoolerFanSpeedControl typCtrFanCoo
    "Cooler fan speed control"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=
    typChi == Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Boolean is_clsCpl=true
    "Set to true if the plant is close coupled, i.e. pipe length from chillers to coolers under 100 feet"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=
    typ==Buildings.Templates.ChilledWaterPlants.Types.Controller.Guideline36));
  parameter Boolean have_senLevCoo(
    start=true)
    "Set to true if cooling towers have level sensor for makeup water control"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=
    typChi == Buildings.Templates.Components.Types.Chiller.WaterCooled and
    (typCoo==Buildings.Templates.Components.Types.Cooler.CoolingTowerOpen or
    typCoo==Buildings.Templates.Components.Types.Cooler.CoolingTowerClosed)));

  parameter Buildings.Templates.ChilledWaterPlants.Components.Data.Controller dat(
    final typChi=typChi,
    final nChi=nChi,
    final nPumChiWatPri=nPumChiWatPri,
    final nPumConWat=nPumConWat,
    final typDisChiWat=typDisChiWat,
    final nPumChiWatSec=nPumChiWatSec,
    final typCoo=typCoo,
    final nCoo=nCoo,
    final have_varPumConWat=have_varPumConWat,
    final typCtrHea=typCtrHea,
    final typEco=typEco,
    final typMeaCtrChiWatPri=typMeaCtrChiWatPri,
    final have_senDpChiWatLoc=have_senDpChiWatLoc,
    final nSenDpChiWatRem=nSenDpChiWatRem,
    final nLooChiWatSec=nLooChiWatSec,
    final have_senVChiWatSec=have_senVChiWatSec,
    final have_senLevCoo=have_senLevCoo)
    "Parameter record for controller";

  final parameter Real sta[:,:]=dat.sta
    "Staging matrix with plant stage as row index and chiller as column index (highest index for optional WSE): 0 for disabled, 1 for enabled"
    annotation (Evaluate=true, Dialog(group="Plant staging"));
  final parameter Integer nUniSta=dat.nUniSta
    "Number of units to stage, including chillers and optional WSE"
    annotation (Evaluate=true, Dialog(group="Plant staging"));
  final parameter Integer nSta=dat.nSta
    "Number of plant stages"
    annotation (Evaluate=true, Dialog(group="Plant staging"));

  Buildings.Templates.ChilledWaterPlants.Interfaces.Bus bus
    "Plant control bus"
    annotation (Placement(
        transformation(
        extent={{-20,20},{20,-20}},
        rotation=90,
        origin={260,0}),  iconTransformation(
        extent={{-20,20},{20,-20}},
        rotation=90,
        origin={100,0})));

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
<code>nSenDpChiWatRem</code> may be zero if CHW pump speed
is only controlled based on a local differential pressure
sensor.
However, that option is not supported by G36.
</p>
</html>"));
end PartialController;
