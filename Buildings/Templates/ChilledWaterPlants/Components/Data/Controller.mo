within Buildings.Templates.ChilledWaterPlants.Components.Data;
record Controller "Record for plant controller"
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.ChilledWaterPlants.Types.Controller typ
    "Type of controller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.Chiller typChi
    "Type of chiller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.PumpArrangement typArrPumChiWatPri
    "Type of primary CHW pump arrangement"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nChi
    "Number of chillers"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nPumChiWatPri=nChi
    "Number of primary CHW pumps"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nPumConWat=nChi
    "Number of CW pumps"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.ChilledWaterPlants.Types.Distribution typDisChiWat
    "Type of CHW distribution system"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nPumChiWatSec=nChi
    "Number of secondary CHW pumps"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.Cooler typCoo
    "Condenser water cooling equipment"
    annotation(Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nCoo
    "Number of cooler units"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_varPumChiWatPri
    "Set to true for variable speed primary CHW pumps, false for constant speed pumps"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_varPumConWat
    "Set to true for variable speed CW pumps, false for constant speed pumps"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.ChilledWaterPlants.Types.ChillerLiftControl typCtlHea
    "Type of head pressure control"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.ChilledWaterPlants.Types.Economizer typEco
    "Type of WSE"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.ChilledWaterPlants.Types.PrimaryOverflowMeasurement typMeaCtlChiWatPri
    "Type of sensors for primary CHW pump control in variable primary-variable secondary plants"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_senDpChiWatLoc = false
    "Set to true for local CHW differential pressure sensor hardwired to plant controller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nSenDpChiWatRem
    "Number of remote CHW differential pressure sensors used for CHW pump speed control"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nLooChiWatSec=1
    "Number of secondary CHW loops"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_senVChiWatSec
    "Set to true if secondary loop is equipped with a flow meter"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_senLevCoo
    "Set to true if cooling towers have level sensor for makeup water control"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Modelica.Units.SI.Temperature TChiWatChiSup_nominal[nChi](
    each displayUnit="degC",
    each start=Buildings.Templates.Data.Defaults.TChiWatSup,
    each final min=260)
    "Design (lowest) CHW supply temperature setpoint - Each chiller"
    annotation(Dialog(group="Temperature setpoints", enable=
    typ==Buildings.Templates.ChilledWaterPlants.Types.Controller.Guideline36));
  parameter Modelica.Units.SI.Temperature TChiWatSup_max(
    displayUnit="degC",
    final min=260)=Buildings.Templates.Data.Defaults.TChiWatSup_max
    "Maximum CHW supply temperature setpoint used in plant reset logic"
    annotation(Dialog(group="Temperature setpoints", enable=
    typ==Buildings.Templates.ChilledWaterPlants.Types.Controller.Guideline36));
  parameter Modelica.Units.SI.Temperature TConWatChiRet_nominal[nChi](
    each displayUnit="degC",
    each start=Buildings.Templates.Data.Defaults.TConWatRet,
    each final min=273.15)
    "CW return temperature at chiller selection conditions - Each chiller"
    annotation(Dialog(group="Temperature setpoints", enable=
    typ==Buildings.Templates.ChilledWaterPlants.Types.Controller.Guideline36 and
    typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Modelica.Units.SI.Temperature TConWatChiSup_nominal[nChi](
    each displayUnit="degC",
    each start=Buildings.Templates.Data.Defaults.TConWatSup,
    each final min=273.15)
    "CW supply temperature at chiller selection conditions - Each chiller"
    annotation(Dialog(group="Temperature setpoints", enable=
    typ==Buildings.Templates.ChilledWaterPlants.Types.Controller.Guideline36 and
    typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Modelica.Units.SI.Temperature TOutLoc(
    displayUnit="degC",
    final min=250)=Buildings.Templates.Data.Defaults.TOutChiLoc
    "Outdoor air lockout temperature below which the plant is prevented from operating"
    annotation(Dialog(group="Temperature setpoints", enable=
    typ==Buildings.Templates.ChilledWaterPlants.Types.Controller.Guideline36));

  parameter Modelica.Units.SI.PressureDifference dpChiWatLocSet_min(
    start=Buildings.Templates.Data.Defaults.dpChiWatSet_min)
    "Minimum CHW differential pressure setpoint used in plant reset logic - Local sensor"
    annotation(Dialog(group="Differential pressure setpoints", enable=
    typ==Buildings.Templates.ChilledWaterPlants.Types.Controller.Guideline36 and
    typDisChiWat<>Buildings.Templates.ChilledWaterPlants.Types.Distribution.Constant1Only and
    have_senDpChiWatLoc));
  parameter Modelica.Units.SI.PressureDifference dpChiWatRemSet_min[nSenDpChiWatRem](
    each start=Buildings.Templates.Data.Defaults.dpChiWatSet_min)
    "Minimum CHW differential pressure setpoint used in plant reset logic - Each remote sensor"
    annotation(Dialog(group="Differential pressure setpoints", enable=
    typ==Buildings.Templates.ChilledWaterPlants.Types.Controller.Guideline36 and
    typDisChiWat<>Buildings.Templates.ChilledWaterPlants.Types.Distribution.Constant1Only and
    not have_senDpChiWatLoc));

  parameter Modelica.Units.SI.VolumeFlowRate VChiWatChi_flow_nominal[nChi](
    each displayUnit="L/s",
    each final min=0)
    "Design CHW volume flow rate - Each chiller"
    annotation(Dialog(group="Chiller flow setpoints", enable=
    typ==Buildings.Templates.ChilledWaterPlants.Types.Controller.Guideline36));
  parameter Modelica.Units.SI.VolumeFlowRate VChiWatChi_flow_min[nChi](
    each displayUnit="L/s",
    each final min=0)
    "Minimum CHW volume flow rate - Each chiller"
    annotation(Dialog(group="Chiller flow setpoints", enable=
    typ==Buildings.Templates.ChilledWaterPlants.Types.Controller.Guideline36));
  parameter Modelica.Units.SI.VolumeFlowRate VConWatChi_flow_nominal[nChi](
    each displayUnit="L/s",
    each start=0.01,
    each final min=0)
    "Design CW volume flow rate - Each chiller"
    annotation(Dialog(group="Chiller flow setpoints", enable=
    typ==Buildings.Templates.ChilledWaterPlants.Types.Controller.Guideline36 and
    typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled and
    have_varPumConWat));

  parameter Modelica.Units.SI.TemperatureDifference dTLifChi_min[nChi](
    each start=Buildings.Templates.Data.Defaults.dTLifChi_min,
    each final min=0)
    "Minimum allowable lift at minimum load - Each chiller"
    annotation(Dialog(group="Chiller lift setpoints", enable=
    typ==Buildings.Templates.ChilledWaterPlants.Types.Controller.Guideline36 and
    typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled and
    typCtlHea<>Buildings.Templates.ChilledWaterPlants.Types.ChillerLiftControl.None));
  parameter Modelica.Units.SI.TemperatureDifference dTLifChi_nominal[nChi](
    each final min=0)=TConWatChiRet_nominal-TChiWatChiSup_nominal
    "Design lift at design load - Each chiller"
    annotation(Dialog(group="Chiller lift setpoints", enable=
    typ==Buildings.Templates.ChilledWaterPlants.Types.Controller.Guideline36 and
    typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled and
    typCtlHea<>Buildings.Templates.ChilledWaterPlants.Types.ChillerLiftControl.None));

  parameter Modelica.Units.SI.HeatFlowRate capChi_nominal[nChi](
    each final min=0)
    "Design capacity - Each chiller"
    annotation(Dialog(group="Capacity", enable=
    typ==Buildings.Templates.ChilledWaterPlants.Types.Controller.Guideline36));
  parameter Modelica.Units.SI.VolumeFlowRate VChiWatPri_flow_nominal(
    start=0.01,
    displayUnit="L/s",
    final min=0)=sum(VChiWatChi_flow_nominal)
    "Design primary CHW volume flow rate"
    annotation(Dialog(group="Capacity", enable=
    typ==Buildings.Templates.ChilledWaterPlants.Types.Controller.Guideline36 and (
    (typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1And2 or
    typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1And2Distributed) and
    (typMeaCtlChiWatPri==Buildings.Templates.ChilledWaterPlants.Types.PrimaryOverflowMeasurement.FlowDecoupler or
    typMeaCtlChiWatPri==Buildings.Templates.ChilledWaterPlants.Types.PrimaryOverflowMeasurement.FlowDifference) or
    typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1Only and
    typArrPumChiWatPri==Buildings.Templates.Components.Types.PumpArrangement.Headered)));
  parameter Modelica.Units.SI.VolumeFlowRate VChiWatSec_flow_nominal[nLooChiWatSec](
    each start=0.01,
    each displayUnit="L/s",
    each final min=0)
    "Design secondary CHW volume flow rate - Each secondary loop"
    annotation(Dialog(group="Capacity", enable=
    typ==Buildings.Templates.ChilledWaterPlants.Types.Controller.Guideline36 and (
    (typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Constant1Variable2 or
    typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1And2 or
    typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1And2Distributed) and
    have_senVChiWatSec)));

  parameter Modelica.Units.SI.HeatFlowRate capUnlChi_min[nChi](
    each final min=0)
    "Minimum load before engaging hot gas bypass or cycling - Each chiller"
    annotation(Dialog(group="Minimum cycling load", enable=
    typ==Buildings.Templates.ChilledWaterPlants.Types.Controller.Guideline36));

  parameter Modelica.Units.SI.TemperatureDifference dTAppEco_nominal(
    start=Buildings.Templates.Data.Defaults.TChiWatEcoLvg-
    Buildings.Templates.Data.Defaults.TConWatEcoEnt,
    final min=0)
    "Design heat exchanger approach"
    annotation(Dialog(group="Waterside economizer design information", enable=
    typ==Buildings.Templates.ChilledWaterPlants.Types.Controller.Guideline36 and
    typEco<>Buildings.Templates.ChilledWaterPlants.Types.Economizer.None));
  parameter Modelica.Units.SI.TemperatureDifference TWetBulCooEnt_nominal(
    start=Buildings.Templates.Data.Defaults.TWetBulTowEnt,
    final min=273.15)
    "Design cooling tower wetbulb temperature"
    annotation(Dialog(group="Waterside economizer design information", enable=
    typ==Buildings.Templates.ChilledWaterPlants.Types.Controller.Guideline36 and
    typEco<>Buildings.Templates.ChilledWaterPlants.Types.Economizer.None));
  parameter Modelica.Units.SI.TemperatureDifference dTAppCoo_nominal(
    start=Buildings.Templates.Data.Defaults.TConWatSup-
    Buildings.Templates.Data.Defaults.TWetBulTowEnt,
    final min=0)
    "Design cooling tower approach"
    annotation(Dialog(group="Waterside economizer design information", enable=
    typ==Buildings.Templates.ChilledWaterPlants.Types.Controller.Guideline36 and
    typEco<>Buildings.Templates.ChilledWaterPlants.Types.Economizer.None));
  parameter Modelica.Units.SI.VolumeFlowRate VChiWatEco_flow_nominal(
    start=0.01,
    displayUnit="L/s",
    final min=0)
    "Design waterside economizer CHW volume flow rate"
    annotation(Dialog(group="Waterside economizer design information", enable=
    typ==Buildings.Templates.ChilledWaterPlants.Types.Controller.Guideline36 and
    typEco<>Buildings.Templates.ChilledWaterPlants.Types.Economizer.None));
  parameter Modelica.Units.SI.VolumeFlowRate VConWatEco_flow_nominal(
    start=0.01,
    displayUnit="L/s",
    final min=0)
    "Design waterside economizer CW volume flow rate"
    annotation(Dialog(group="Waterside economizer design information", enable=
    typ==Buildings.Templates.ChilledWaterPlants.Types.Controller.Guideline36 and
    typEco==Buildings.Templates.ChilledWaterPlants.Types.Economizer.HeatExchangerWithValve));
  parameter Modelica.Units.SI.PressureDifference dpChiWatEco_nominal(
    start=Buildings.Templates.Data.Defaults.dpChiWatEco,
    final min=0)
    "Design waterside economizer CHW pressure drop"
    annotation(Dialog(group="Waterside economizer design information", enable=
    typ==Buildings.Templates.ChilledWaterPlants.Types.Controller.Guideline36 and
    typEco==Buildings.Templates.ChilledWaterPlants.Types.Economizer.HeatExchangerWithValve));

  parameter Modelica.Units.SI.Height hLevAlaCoo_max(
    start=0.3,
    final min=0)
    "Maximum level just below overflow"
    annotation(Dialog(group="Cooling tower level control", enable=
    typ==Buildings.Templates.ChilledWaterPlants.Types.Controller.Guideline36 and (
    (typCoo==Buildings.Templates.Components.Types.Cooler.CoolingTowerOpen or
    typCoo==Buildings.Templates.Components.Types.Cooler.CoolingTowerClosed) and
    have_senLevCoo)));
  parameter Modelica.Units.SI.Height hLevAlaCoo_min(
    start=0.05,
    final min=0)
    "Minimum level before triggering alarm"
    annotation(Dialog(group="Cooling tower level control", enable=
    typ==Buildings.Templates.ChilledWaterPlants.Types.Controller.Guideline36 and
    ((typCoo==Buildings.Templates.Components.Types.Cooler.CoolingTowerOpen or
    typCoo==Buildings.Templates.Components.Types.Cooler.CoolingTowerClosed) and
    have_senLevCoo)));
  parameter Modelica.Units.SI.Height hLevCoo_min(
    start=0.1,
    final min=0)
    "Lowest normal operating level"
    annotation(Dialog(group="Cooling tower level control", enable=
    typ==Buildings.Templates.ChilledWaterPlants.Types.Controller.Guideline36 and (
    (typCoo==Buildings.Templates.Components.Types.Cooler.CoolingTowerOpen or
    typCoo==Buildings.Templates.Components.Types.Cooler.CoolingTowerClosed) and
    have_senLevCoo)));
  parameter Modelica.Units.SI.Height hLevCoo_max(
    start=0.2,
    final min=0)
    "Highest normal operating level"
    annotation(Dialog(group="Cooling tower level control", enable=
    typ==Buildings.Templates.ChilledWaterPlants.Types.Controller.Guideline36 and (
    (typCoo==Buildings.Templates.Components.Types.Cooler.CoolingTowerOpen or
    typCoo==Buildings.Templates.Components.Types.Cooler.CoolingTowerClosed) and
    have_senLevCoo)));

  parameter Modelica.Units.SI.PressureDifference dpChiWatRemSet_nominal[nSenDpChiWatRem](
    each start=Buildings.Templates.Data.Defaults.dpChiWatSet_max,
    each final min=0)
    "Design (maximum) CHW differential pressure setpoint - Remote sensor"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=
    typ==Buildings.Templates.ChilledWaterPlants.Types.Controller.Guideline36 and (
    typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1Only or
    typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Constant1Variable2  or
    typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1And2)));
  parameter Modelica.Units.SI.PressureDifference dpChiWatLocSet_nominal(
    start=Buildings.Templates.Data.Defaults.dpChiWatLocSet_max,
    final min=0)
    "Design (maximum) CHW differential pressure setpoint - Local sensor"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=typ==Buildings.Templates.ChilledWaterPlants.Types.Controller.Guideline36 and (
    typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1Only and
    have_senDpChiWatLoc)));
  // FIXME #2299: For dedicated CW pumps this should be a 2-D array [nSta, nPumConWat] which is more aligned with §5.20.9.6.
  parameter Real yPumConWatSta_nominal[nSta](
    each final unit="1",
    each final min=0,
    each final max=1,
    each start=1)
    "CW pump speed delivering design CW flow through chillers and WSE - Each plant stage"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=typ==Buildings.Templates.ChilledWaterPlants.Types.Controller.Guideline36 and (
    typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled
    and have_varPumConWat)));
  parameter Real yValConWatChiIso_min(
    final unit="1",
    final min=0,
    final max=1,
    start=0)
    "Minimum head pressure control valve position"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=typ==Buildings.Templates.ChilledWaterPlants.Types.Controller.Guideline36 and (
    typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled
    and not have_varPumConWat)));
  parameter Real yPumConWat_min(
    final unit="1",
    final min=0,
    final max=1,
    start=0.1)
    "Minimum CW pump speed"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=typ==Buildings.Templates.ChilledWaterPlants.Types.Controller.Guideline36 and (
    typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled and
    have_varPumConWat)));
  parameter Real yPumChiWatEco_nominal(
    final unit="1",
    final min=0,
    final max=1,
    start=1)
    "WSE heat exchanger pump speed delivering design CHW flow through the heat exchanger "
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=typ==Buildings.Templates.ChilledWaterPlants.Types.Controller.Guideline36 and
    typEco==Buildings.Templates.ChilledWaterPlants.Types.Economizer.HeatExchangerWithPump));
  parameter Real yPumChiWatPriSta_nominal[nSta](
    each final unit="1",
    each final min=0,
    each final max=1,
    each start=1)
    "Primary CHW pump speed delivering design flow through chillers - Each plant stage"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=typ==Buildings.Templates.ChilledWaterPlants.Types.Controller.Guideline36 and (
      (typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Constant1Only or
      typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Constant1Variable2)
      and have_varPumChiWatPri)));
  parameter Real yPumChiWatPriSta_min[nSta](
    each final unit="1",
    each final min=0,
    each final max=1,
    each start=0.3)
    "Primary CHW pump speed delivering minimum flow through chillers - Each plant stage"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=typ==Buildings.Templates.ChilledWaterPlants.Types.Controller.Guideline36 and (
    typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1And2 or
    typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1And2Distributed)));
  parameter Real yPumChiWatPri_min(
    final unit="1",
    final min=0,
    final max=1,
    start=0.1)
    "Primary CHW pump minimum speed"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=typ==Buildings.Templates.ChilledWaterPlants.Types.Controller.Guideline36 and
    typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1Only));
  parameter Real yPumChiWatSec_min(
    final unit="1",
    final min=0,
    final max=1,
    start=0.1)
    "Secondary CHW pump minimum speed"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=typ==Buildings.Templates.ChilledWaterPlants.Types.Controller.Guideline36 and (
    typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Constant1Variable2 or
    typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1And2)));
  parameter Real yFanCoo_min(
    final unit="1",
    final min=0,
    final max=1,
    start=0.1)
    "Cooler fan minimum speed"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=typ==Buildings.Templates.ChilledWaterPlants.Types.Controller.Guideline36 and
    typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));

  // RFE: The following parameter has the type Real for future capability to specify interchangeable chillers with 0.5.
  parameter Real sta[:, nUniSta](
    each min=0,
    each max=1,
    each final unit="1")
    "Staging matrix with plant stage as row index and chiller as column index (highest index for optional WSE): 0 for disabled, 1 for enabled"
    annotation (Evaluate=true, Dialog(group="Plant staging"));
  final parameter Integer nUniSta=
    if typEco<>Buildings.Templates.ChilledWaterPlants.Types.Economizer.None then nChi+1
    else nChi
    "Number of units to be staged, including chillers and optional WSE"
    annotation (Evaluate=true, Dialog(group="Plant staging"));
  final parameter Integer nSta=size(sta, 1)
    "Number of plant stages"
    annotation (Evaluate=true, Dialog(group="Plant staging"));
  parameter Real staCoo[nSta](
    each max=nCoo,
    start=fill(0, nSta))
    "Quantity of enabled cooler units (e.g. cooling tower cells) at each plant Stage"
    annotation (Evaluate=true, Dialog(group="Plant staging", enable=
    typ==Buildings.Templates.ChilledWaterPlants.Types.Controller.Guideline36 and
    typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  annotation (
  defaultComponentName="datCtl",
  Documentation(info="<html>
<p>
This record provides the set of sizing and operating parameters for
CHW plant controllers that can be found within
<a href=\"modelica://Buildings.Templates.ChilledWaterPlants.Components.Controls\">
Buildings.Templates.ChilledWaterPlants.Components.Controls</a>.
</p>
</html>"));
end Controller;
