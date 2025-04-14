within Buildings.Templates.Plants.Chillers.Components.Data;
record Controller
  "Record for plant controller"
  extends Modelica.Icons.Record;
  parameter Buildings.Templates.Plants.Chillers.Configuration.ChillerPlant cfg
    "Plant configuration parameters";
  parameter Modelica.Units.SI.Temperature TChiWatSupChi_nominal[:](
    each displayUnit="degC",
    start=fill(Buildings.Templates.Data.Defaults.TChiWatSup, cfg.nChi),
    each final min=260)
    "Design (lowest) CHW supply temperature setpoint - Each chiller"
    annotation (Dialog(group="Temperature setpoints",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36));
  parameter Modelica.Units.SI.Temperature TChiWatSup_max(
    displayUnit="degC",
    final min=260)=Buildings.Templates.Data.Defaults.TChiWatSup_max
    "Maximum CHW supply temperature setpoint used in plant reset logic"
    annotation (Dialog(group="Temperature setpoints",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36));
  parameter Modelica.Units.SI.Temperature TConWatSupChi_nominal[:](
    each displayUnit="degC",
    start=fill(Buildings.Templates.Data.Defaults.TConWatSup, cfg.nChi),
    each final min=273.15)
    "CW supply temperature (condenser entering) at chiller selection conditions - Each chiller"
    annotation (Dialog(group="Temperature setpoints",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36 and
      cfg.typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Modelica.Units.SI.Temperature TConWatRetChi_nominal[:](
    each displayUnit="degC",
    start=fill(Buildings.Templates.Data.Defaults.TConWatRet, cfg.nChi),
    each final min=273.15)
    "CW return temperature (condenser leaving) at chiller selection conditions - Each chiller"
    annotation (Dialog(group="Temperature setpoints",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36 and
      cfg.typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Modelica.Units.SI.Temperature TOutChiWatLck(
    displayUnit="degC",
    final min=250)=Buildings.Templates.Data.Defaults.TOutChiWatLck
    "Outdoor air lockout temperature below which the plant is prevented from operating"
    annotation (Dialog(group="Temperature setpoints",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36));
  parameter Modelica.Units.SI.PressureDifference dpChiWatLocSet_min(
    start=Buildings.Templates.Data.Defaults.dpChiWatSet_min)
    "Minimum CHW differential pressure setpoint used in plant reset logic - Local sensor"
    annotation (Dialog(group="Differential pressure setpoints",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36 and
      cfg.typDisChiWat<>Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Only
        and not cfg.have_senDpChiWatRemWir));
  parameter Modelica.Units.SI.PressureDifference dpChiWatRemSet_min[:](
    start=fill(Buildings.Templates.Data.Defaults.dpChiWatSet_min, cfg.nSenDpChiWatRem))
    "Minimum CHW differential pressure setpoint used in plant reset logic - Each remote sensor"
    annotation (Dialog(group="Differential pressure setpoints",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36 and
      cfg.typDisChiWat<>Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Only
        and cfg.have_senDpChiWatRemWir));
  parameter Modelica.Units.SI.VolumeFlowRate VChiWatChi_flow_nominal[:](
    each displayUnit="L/s",
    each final min=0,
    start=fill(0, cfg.nChi))
    "Design CHW volume flow rate - Each chiller"
    annotation (Dialog(group="Chiller flow setpoints",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36));
  parameter Modelica.Units.SI.VolumeFlowRate VChiWatChi_flow_min[:](
    each displayUnit="L/s",
    each final min=0,
    start=fill(0, cfg.nChi))
    "Minimum CHW volume flow rate - Each chiller"
    annotation (Dialog(group="Chiller flow setpoints",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36));
  parameter Modelica.Units.SI.VolumeFlowRate VConWatChi_flow_nominal[:](
    each displayUnit="L/s",
    start=fill(0.01, cfg.nChi),
    each final min=0)
    "Design CW volume flow rate - Each chiller"
    annotation (Dialog(group="Chiller flow setpoints",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36
      and cfg.typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled
      and cfg.have_pumConWatVar));
  parameter Modelica.Units.SI.TemperatureDifference dTLifChi_min[:](
    start=fill(Buildings.Templates.Data.Defaults.dTLifChi_min, cfg.nChi),
    each final min=0)
    "Minimum allowable lift at minimum load - Each chiller"
    annotation (Dialog(group="Chiller lift setpoints",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36
      and cfg.typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled
      and cfg.typCtlHea<>Buildings.Templates.Plants.Chillers.Types.ChillerLiftControl.None));
  parameter Modelica.Units.SI.TemperatureDifference dTLifChi_nominal[:](
    each final min=0)=TConWatRetChi_nominal - TChiWatSupChi_nominal
    "Design lift at design load - Each chiller"
    annotation (Dialog(group="Chiller lift setpoints",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36
      and cfg.typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled
        and cfg.typCtlHea<>Buildings.Templates.Plants.Chillers.Types.ChillerLiftControl.None));
  parameter Modelica.Units.SI.HeatFlowRate capChi_nominal[:](
    start=fill(0, cfg.nChi),
    each final min=0)
    "Design capacity - Each chiller"
    annotation (Dialog(group="Capacity",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36));
  parameter Modelica.Units.SI.VolumeFlowRate VChiWatPri_flow_nominal(
    start=0.01,
    displayUnit="L/s",
    final min=0)=sum(VChiWatChi_flow_nominal)
    "Design primary CHW volume flow rate"
    annotation (Dialog(group="Capacity",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36 and
      ((cfg.typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2
        or cfg.typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2Distributed)
        and (cfg.typMeaCtlChiWatPri==Buildings.Templates.Plants.Chillers.Types.PrimaryOverflowMeasurement.FlowDecoupler
        or cfg.typMeaCtlChiWatPri==Buildings.Templates.Plants.Chillers.Types.PrimaryOverflowMeasurement.FlowDifference)
        or cfg.typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1Only
        and cfg.typArrPumChiWatPri==Buildings.Templates.Components.Types.PumpArrangement.Headered)));
  parameter Modelica.Units.SI.VolumeFlowRate VChiWatSec_flow_nominal[:](
    start=fill(0.01, cfg.nLooChiWatSec),
    each displayUnit="L/s",
    each final min=0)
    "Design secondary CHW volume flow rate - Each secondary loop"
    annotation (Dialog(group="Capacity",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36
      and ((cfg.typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Variable2
        or cfg.typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2
        or cfg.typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2Distributed)
        and cfg.have_senVChiWatSec)));
  parameter Modelica.Units.SI.HeatFlowRate capUnlChi_min[:](
    start=0.1 * abs(capChi_nominal),
    each final min=0)
    "Minimum load before engaging hot gas bypass or cycling - Each chiller"
    annotation (Dialog(group="Minimum cycling load",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36));
  parameter Modelica.Units.SI.TemperatureDifference dTAppEco_nominal(
    start=Buildings.Templates.Data.Defaults.TChiWatEcoLvg - Buildings.Templates.Data.Defaults.TConWatEcoEnt,
    final min=0)
    "Design heat exchanger approach"
    annotation (Dialog(group="Waterside economizer design information",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36
      and cfg.typEco<>Buildings.Templates.Plants.Chillers.Types.Economizer.None));
  parameter Modelica.Units.SI.TemperatureDifference TWetBulCooEnt_nominal(
    start=Buildings.Templates.Data.Defaults.TWetBulTowEnt,
    final min=273.15)
    "Design cooling tower wetbulb temperature"
    annotation (Dialog(group="Waterside economizer design information",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36
      and cfg.typEco<>Buildings.Templates.Plants.Chillers.Types.Economizer.None));
  parameter Modelica.Units.SI.TemperatureDifference dTAppCoo_nominal(
    start=Buildings.Templates.Data.Defaults.TConWatSup - Buildings.Templates.Data.Defaults.TWetBulTowEnt,
    final min=0)
    "Design cooling tower approach"
    annotation (Dialog(group="Waterside economizer design information",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36
      and cfg.typEco<>Buildings.Templates.Plants.Chillers.Types.Economizer.None));
  parameter Modelica.Units.SI.VolumeFlowRate VChiWatEco_flow_nominal(
    start=0.01,
    displayUnit="L/s",
    final min=0)
    "Design waterside economizer CHW volume flow rate"
    annotation (Dialog(group="Waterside economizer design information",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36
      and cfg.typEco<>Buildings.Templates.Plants.Chillers.Types.Economizer.None));
  parameter Modelica.Units.SI.VolumeFlowRate VConWatEco_flow_nominal(
    start=0.01,
    displayUnit="L/s",
    final min=0)
    "Design waterside economizer CW volume flow rate"
    annotation (Dialog(group="Waterside economizer design information",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36
      and cfg.typEco==Buildings.Templates.Plants.Chillers.Types.Economizer.HeatExchangerWithValve));
  parameter Modelica.Units.SI.PressureDifference dpChiWatEco_nominal(
    start=Buildings.Templates.Data.Defaults.dpChiWatEco,
    final min=0)
    "Design waterside economizer CHW pressure drop"
    annotation (Dialog(group="Waterside economizer design information",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36
      and cfg.typEco==Buildings.Templates.Plants.Chillers.Types.Economizer.HeatExchangerWithValve));
  parameter Modelica.Units.SI.Height hLevAlaCoo_max(
    start=0.3,
    final min=0)
    "Maximum level just below overflow"
    annotation (Dialog(group="Cooling tower level control",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36
      and (cfg.typCoo==Buildings.Templates.Components.Types.Cooler.CoolingTowerOpen
        or cfg.typCoo==Buildings.Templates.Components.Types.Cooler.CoolingTowerClosed)
        and cfg.have_senLevCoo));
  parameter Modelica.Units.SI.Height hLevAlaCoo_min(
    start=0.05,
    final min=0)
    "Minimum level before triggering alarm"
    annotation (Dialog(group="Cooling tower level control",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36
      and ((cfg.typCoo==Buildings.Templates.Components.Types.Cooler.CoolingTowerOpen
        or cfg.typCoo==Buildings.Templates.Components.Types.Cooler.CoolingTowerClosed)
        and cfg.have_senLevCoo)));
  parameter Modelica.Units.SI.Height hLevCoo_min(
    start=0.1,
    final min=0)
    "Lowest normal operating level"
    annotation (Dialog(group="Cooling tower level control",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36 and
      ((cfg.typCoo==Buildings.Templates.Components.Types.Cooler.CoolingTowerOpen
        or cfg.typCoo==Buildings.Templates.Components.Types.Cooler.CoolingTowerClosed)
        and cfg.have_senLevCoo)));
  parameter Modelica.Units.SI.Height hLevCoo_max(
    start=0.2,
    final min=0)
    "Highest normal operating level"
    annotation (Dialog(group="Cooling tower level control",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36 and
      ((cfg.typCoo==Buildings.Templates.Components.Types.Cooler.CoolingTowerOpen
        or cfg.typCoo==Buildings.Templates.Components.Types.Cooler.CoolingTowerClosed)
        and cfg.have_senLevCoo)));
  parameter Modelica.Units.SI.PressureDifference dpChiWatRemSet_max[:](
    start=fill(Buildings.Templates.Data.Defaults.dpChiWatRemSet_max, cfg.nSenDpChiWatRem),
    each final min=0)
    "Mmaximum CHW differential pressure setpoint - Remote sensor"
    annotation (Dialog(group="Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36
       and (cfg.typDisChiWat == Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1Only
       or cfg.typDisChiWat == Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Variable2
       or cfg.typDisChiWat == Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2)));
  parameter Modelica.Units.SI.PressureDifference dpChiWatLocSet_max(
    start=Buildings.Templates.Data.Defaults.dpChiWatLocSet_max,
    final min=0)
    "Design (maximum) CHW differential pressure setpoint - Local sensor"
    annotation (Dialog(group="Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.typCtl == Buildings.Templates.Plants.Chillers.Types.Controller.G36
       and (cfg.typDisChiWat == Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1Only
       and not cfg.have_senDpChiWatRemWir)));
  // FIXME #2299: For dedicated CW pumps this should be a 2-D array [nSta, nPumConWat] which is more aligned with §5.20.9.6.
  parameter Real yPumConWatSta_nominal[nSta](
    each final unit="1",
    each final min=0,
    each final max=1,
    each start=1)
    "CW pump speed delivering design CW flow through chillers and WSE - Each plant stage"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36 and
        (cfg.typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled
        and cfg.have_pumConWatVar)));
  parameter Real yValConWatChiIso_min(
    final unit="1",
    final min=0,
    final max=1,
    start=0)
    "Minimum head pressure control valve position"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36 and
        (cfg.typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled
        and not cfg.have_pumConWatVar)));
  parameter Real yPumConWat_min(
    final unit="1",
    final min=0,
    final max=1,
    start=0.1)
    "Minimum CW pump speed"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36 and
        (cfg.typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled
        and cfg.have_pumConWatVar)));
  parameter Real yPumChiWatEco_nominal(
    final unit="1",
    final min=0,
    final max=1,
    start=1)
    "WSE heat exchanger pump speed delivering design CHW flow through the heat exchanger "
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36 and
      cfg.typEco==Buildings.Templates.Plants.Chillers.Types.Economizer.HeatExchangerWithPump));
  parameter Real yPumChiWatPriSta_nominal[nSta](
    each final unit="1",
    each final min=0,
    each final max=1,
    each start=1)
    "Primary CHW pump speed delivering design flow through chillers - Each plant stage"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36 and
        ((cfg.typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Only
        or cfg.typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Variable2)
        and cfg.have_pumChiWatPriVar)));
  parameter Real yPumChiWatPriSta_min[nSta](
    each final unit="1",
    each final min=0,
    each final max=1,
    each start=0.3)
    "Primary CHW pump speed delivering minimum flow through chillers - Each plant stage"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36 and
        (cfg.typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2
        or cfg.typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2Distributed)));
  parameter Real yPumChiWatPri_min(
    final unit="1",
    final min=0,
    final max=1,
    start=0.1)
    "Primary CHW pump minimum speed"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36 and
      cfg.typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1Only));
  parameter Real yPumChiWatSec_min(
    final unit="1",
    final min=0,
    final max=1,
    start=0.1)
    "Secondary CHW pump minimum speed"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36
      and (cfg.typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Variable2
        or cfg.typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2)));
  parameter Real yFanCoo_min(
    final unit="1",
    final min=0,
    final max=1,
    start=0.1)
    "Cooler fan minimum speed"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36
      and cfg.typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  // RFE: The following parameter has the type Real for future capability to specify lead/lag alternated chillers with 0.5.
  parameter Real sta[:, :](
    each min=0,
    each max=1,
    each final unit="1")
    "Staging matrix with plant stage as row index and chiller as column index (highest index for optional WSE): 0 for disabled, 1 for enabled"
    annotation (Evaluate=true,
    Dialog(group="Plant staging"));
  final parameter Integer nSta=size(sta, 1)
    "Number of plant stages"
    annotation (Evaluate=true,
    Dialog(group="Plant staging"));
  final parameter Integer nUniSta=size(sta, 2)
    "Number of units to be staged, including chillers and optional WSE"
    annotation (Evaluate=true,
    Dialog(group="Plant staging"));
  parameter Real staCoo[nSta](
    each max=cfg.nCoo,
    start=fill(0, nSta))
    "Quantity of enabled cooler units (e.g. cooling tower cells) at each plant Stage"
    annotation (Evaluate=true,
    Dialog(group="Plant staging",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36
      and cfg.typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  annotation (
    defaultComponentName="datCtl",
    Documentation(
      info="<html>
<p>
This record provides the set of sizing and operating parameters for
CHW plant controllers that can be found within
<a href=\"modelica://Buildings.Templates.Plants.Chillers.Components.Controls\">
Buildings.Templates.Plants.Chillers.Components.Controls</a>.
</p>
</html>"));
end Controller;
