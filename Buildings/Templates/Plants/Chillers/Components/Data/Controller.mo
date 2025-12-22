within Buildings.Templates.Plants.Chillers.Components.Data;
record Controller
  "Record for plant controller"
  extends Modelica.Icons.Record;
  parameter Buildings.Templates.Plants.Chillers.Configuration.ChillerPlant cfg
    "Plant configuration parameters";
  parameter Modelica.Units.SI.Temperature TChiWatSupChi_nominal[:](
    min=fill(260, cfg.nChi),
    start=fill(Buildings.Templates.Data.Defaults.TChiWatSup, cfg.nChi),
    each displayUnit="degC")
    "Design (lowest) CHW supply temperature setpoint - Each chiller"
    annotation (Dialog(group="Temperature setpoints",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36));
  parameter Modelica.Units.SI.Temperature TChiWatSup_max(min=260)=Buildings.Templates.Data.Defaults.TChiWatSup_max
    "Maximum CHW supply temperature setpoint used in plant reset logic"
    annotation (Dialog(group="Temperature setpoints",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36));
  parameter Modelica.Units.SI.Temperature TConWatSupChi_nominal[:](
    min=fill(273.15, cfg.nChi),
    start=fill(Buildings.Templates.Data.Defaults.TConWatSup, cfg.nChi),
    each displayUnit="degC")
    "CW supply temperature (condenser entering) at chiller selection conditions - Each chiller"
    annotation (Dialog(group="Temperature setpoints",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36 and
      cfg.typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Modelica.Units.SI.Temperature TConWatRetChi_nominal[:](
    min=fill(273.15, cfg.nChi),
    start=fill(Buildings.Templates.Data.Defaults.TConWatRet, cfg.nChi),
    each displayUnit="degC")
    "CW return temperature (condenser leaving) at chiller selection conditions - Each chiller"
    annotation (Dialog(group="Temperature setpoints",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36 and
      cfg.typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Modelica.Units.SI.Temperature TOutChiWatLck(min=250)=Buildings.Templates.Data.Defaults.TOutChiWatLck
    "Outdoor air lockout temperature below which the plant is prevented from operating"
    annotation (Dialog(group="Temperature setpoints",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36));
  parameter Modelica.Units.SI.PressureDifference dpChiWatLocSet_min(start=
        Buildings.Templates.Data.Defaults.dpChiWatSet_min)
    "Minimum CHW differential pressure setpoint used in plant reset logic - Local sensor"
    annotation (Dialog(group="Differential pressure setpoints",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36 and
      cfg.typDisChiWat<>Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Only
        and not cfg.have_senDpChiWatRemWir));
  parameter Modelica.Units.SI.PressureDifference dpChiWatRemSet_min[:](start=
        fill(Buildings.Templates.Data.Defaults.dpChiWatSet_min, cfg.nSenDpChiWatRem))
    "Minimum CHW differential pressure setpoint used in plant reset logic - Each remote sensor"
    annotation (Dialog(group="Differential pressure setpoints",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36 and
      cfg.typDisChiWat<>Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Only
        and cfg.have_senDpChiWatRemWir));
  parameter Modelica.Units.SI.VolumeFlowRate VChiWatChi_flow_nominal[:](
    min=fill(0, cfg.nChi),
    start=fill(0, cfg.nChi),
    each displayUnit="L/s")
    "Design CHW volume flow rate - Each chiller"
    annotation (Dialog(group="Chiller flow setpoints",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36));
  parameter Modelica.Units.SI.VolumeFlowRate VChiWatChi_flow_min[:](
    min=fill(0, cfg.nChi),
    start=fill(0, cfg.nChi),
    each displayUnit="L/s")
    "Minimum CHW volume flow rate - Each chiller"
    annotation (Dialog(group="Chiller flow setpoints",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36));
  parameter Modelica.Units.SI.VolumeFlowRate VConWatChi_flow_nominal[:](
    min=fill(0, cfg.nChi),
    start=fill(0.01, cfg.nChi),
    each displayUnit="L/s")
    "Design CW volume flow rate - Each chiller"
    annotation (Dialog(group="Chiller flow setpoints",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36
      and cfg.typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled
      and cfg.have_pumConWatVar));
  parameter Modelica.Units.SI.TemperatureDifference dTLifChi_min[:](min=fill(0,
        cfg.nChi), start=fill(Buildings.Templates.Data.Defaults.dTLifChi_min,
        cfg.nChi))
    "Minimum allowable lift at minimum load - Each chiller"
    annotation (Dialog(group="Chiller lift setpoints",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36
      and cfg.typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled
      and cfg.typCtlHea<>Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Types.HeadPressureControl.NotRequired));
  parameter Modelica.Units.SI.TemperatureDifference dTLifChi_nominal[:](min=fill(
        0, cfg.nChi))=TConWatRetChi_nominal - TChiWatSupChi_nominal
    "Design lift at design load - Each chiller"
    annotation (Dialog(group="Chiller lift setpoints",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36
      and cfg.typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled
        and cfg.typCtlHea<>Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Types.HeadPressureControl.NotRequired));
  parameter Modelica.Units.SI.HeatFlowRate capChi_nominal[:](min=fill(0, cfg.nChi),
      start=fill(0, cfg.nChi))
    "Design capacity - Each chiller"
    annotation (Dialog(group="Capacity",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36));
  parameter Modelica.Units.SI.VolumeFlowRate VChiWatPri_flow_nominal(
    min=0,
    start=0.01)=sum(VChiWatChi_flow_nominal)
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
    min=fill(0, cfg.nLooChiWatSec),
    start=fill(0.01, cfg.nLooChiWatSec),
    each displayUnit="L/s")
    "Design secondary CHW volume flow rate - Each secondary loop"
    annotation (Dialog(group="Capacity",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36
      and ((cfg.typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Variable2
        or cfg.typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2
        or cfg.typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2Distributed)
        and cfg.have_senVChiWatSec)));
  parameter Modelica.Units.SI.HeatFlowRate capUnlChi_min[:](
    min=fill(0, cfg.nChi),
    start=0.1 * abs(capChi_nominal))
    "Minimum load before engaging hot gas bypass or cycling - Each chiller"
    annotation (Dialog(group="Minimum cycling load",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36));
  parameter Modelica.Units.SI.TemperatureDifference dTAppEco_nominal(
    min=0,
    start=Buildings.Templates.Data.Defaults.TChiWatEcoLvg -
      Buildings.Templates.Data.Defaults.TConWatEcoEnt)
    "Design heat exchanger approach"
    annotation (Dialog(group="Waterside economizer design information",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36
      and cfg.typEco<>Buildings.Templates.Plants.Chillers.Types.Economizer.None));
  parameter Modelica.Units.SI.TemperatureDifference TWetBulCooEnt_nominal(min=
        273.15, start=Buildings.Templates.Data.Defaults.TWetBulTowEnt)
    "Design cooling tower wetbulb temperature"
    annotation (Dialog(group="Waterside economizer design information",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36
      and cfg.typEco<>Buildings.Templates.Plants.Chillers.Types.Economizer.None));
  parameter Modelica.Units.SI.TemperatureDifference dTAppCoo_nominal(
    min=0,
    start=Buildings.Templates.Data.Defaults.TConWatSup -
      Buildings.Templates.Data.Defaults.TWetBulTowEnt)
    "Design cooling tower approach"
    annotation (Dialog(group="Waterside economizer design information",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36
      and cfg.typEco<>Buildings.Templates.Plants.Chillers.Types.Economizer.None));
  parameter Modelica.Units.SI.VolumeFlowRate VChiWatEco_flow_nominal(
    min=0,
    start=0.01,
    displayUnit="L/s")
    "Design waterside economizer CHW volume flow rate"
    annotation (Dialog(group="Waterside economizer design information",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36
      and cfg.typEco<>Buildings.Templates.Plants.Chillers.Types.Economizer.None));
  parameter Modelica.Units.SI.VolumeFlowRate VConWatEco_flow_nominal(
    min=0,
    start=0.01,
    displayUnit="L/s")
    "Design waterside economizer CW volume flow rate"
    annotation (Dialog(group="Waterside economizer design information",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36
      and cfg.typEco==Buildings.Templates.Plants.Chillers.Types.Economizer.HeatExchangerWithValve));
  parameter Modelica.Units.SI.PressureDifference dpChiWatEco_nominal(
    min=0,
    start=Buildings.Templates.Data.Defaults.dpChiWatEco)
    "Design waterside economizer CHW pressure drop"
    annotation (Dialog(group="Waterside economizer design information",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36
      and cfg.typEco==Buildings.Templates.Plants.Chillers.Types.Economizer.HeatExchangerWithValve));
  parameter Modelica.Units.SI.Height hLevAlaCoo_max(min=0, start=0.3)
    "Maximum level just below overflow"
    annotation (Dialog(group="Cooling tower level control",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36
      and (cfg.typCoo==Buildings.Templates.Components.Types.Cooler.CoolingTowerOpen
        or cfg.typCoo==Buildings.Templates.Components.Types.Cooler.CoolingTowerClosed)
        and cfg.have_senLevCoo));
  parameter Modelica.Units.SI.Height hLevAlaCoo_min(min=0, start=0.05)
    "Minimum level before triggering alarm"
    annotation (Dialog(group="Cooling tower level control",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36
      and ((cfg.typCoo==Buildings.Templates.Components.Types.Cooler.CoolingTowerOpen
        or cfg.typCoo==Buildings.Templates.Components.Types.Cooler.CoolingTowerClosed)
        and cfg.have_senLevCoo)));
  parameter Modelica.Units.SI.Height hLevCoo_min(min=0, start=0.1)
    "Lowest normal operating level"
    annotation (Dialog(group="Cooling tower level control",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36 and
      ((cfg.typCoo==Buildings.Templates.Components.Types.Cooler.CoolingTowerOpen
        or cfg.typCoo==Buildings.Templates.Components.Types.Cooler.CoolingTowerClosed)
        and cfg.have_senLevCoo)));
  parameter Modelica.Units.SI.Height hLevCoo_max(min=0, start=0.2)
    "Highest normal operating level"
    annotation (Dialog(group="Cooling tower level control",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36 and
      ((cfg.typCoo==Buildings.Templates.Components.Types.Cooler.CoolingTowerOpen
        or cfg.typCoo==Buildings.Templates.Components.Types.Cooler.CoolingTowerClosed)
        and cfg.have_senLevCoo)));
  parameter Modelica.Units.SI.PressureDifference dpChiWatRemSet_max[:](
    min=fill(0, cfg.nSenDpChiWatRem),
    start=fill(Buildings.Templates.Data.Defaults.dpChiWatRemSet_max, cfg.nSenDpChiWatRem))
    "Maximum CHW differential pressure setpoint - Remote sensor"
    annotation (Dialog(group="Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36
       and (cfg.typDisChiWat == Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1Only
       or cfg.typDisChiWat == Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Variable2
       or cfg.typDisChiWat == Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2)));
  parameter Modelica.Units.SI.PressureDifference dpChiWatLocSet_max(
    min=0,
    start=Buildings.Templates.Data.Defaults.dpChiWatLocSet_max)
    "Design (maximum) CHW differential pressure setpoint - Local sensor"
    annotation (Dialog(group="Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.typCtl == Buildings.Templates.Plants.Chillers.Types.Controller.G36
       and (cfg.typDisChiWat == Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1Only
       and not cfg.have_senDpChiWatRemWir)));
  parameter Real yPumConWatSta_nominal[:](
    max=fill(1, nSta),
    min=fill(0, nSta),
    start=fill(1, nSta),
    unit=fill("1", nSta))
    "CW pump speed delivering design CW flow through chillers and WSE - Each plant stage"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36 and
        (cfg.typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled
        and cfg.have_pumConWatVar)));
  parameter Real yValConWatChiIso_min(
    max=1,
    min=0,
    start=0,
    unit="1")
    "Minimum head pressure control valve position"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36 and
        (cfg.typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled
        and not cfg.have_pumConWatVar)));
  parameter Real yPumConWat_min(
    max=1,
    min=0,
    start=0.1,
    unit="1")
    "Minimum CW pump speed"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36 and
        (cfg.typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled
        and cfg.have_pumConWatVar)));
  parameter Real yPumChiWatEco_nominal(
    max=1,
    min=0,
    start=1,
    unit="1")
    "WSE heat exchanger pump speed delivering design CHW flow through the heat exchanger "
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36 and
      cfg.typEco==Buildings.Templates.Plants.Chillers.Types.Economizer.HeatExchangerWithPump));
  parameter Real yPumChiWatPriSta_nominal[:](
    max=fill(1, nSta),
    min=fill(0, nSta),
    start=fill(1, nSta),
    unit=fill("1", nSta))
    "Primary CHW pump speed delivering design flow through chillers - Each plant stage"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36 and
        ((cfg.typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Only
        or cfg.typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Variable2)
        and cfg.have_pumChiWatPriVar)));
  parameter Real yPumChiWatPriSta_min[:](
    max=fill(1, nSta),
    min=fill(0, nSta),
    start=fill(0.3, nSta),
    unit=fill("1", nSta))
    "Primary CHW pump speed delivering minimum flow through chillers - Each plant stage"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36 and
        (cfg.typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2
        or cfg.typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2Distributed)));
  parameter Real yPumChiWatPri_min(
    max=1,
    min=0,
    start=0.1,
    unit="1")
    "Primary CHW pump minimum speed"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36 and
      cfg.typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1Only));
  parameter Real yPumChiWatSec_min(
    max=1,
    min=0,
    start=0.1,
    unit="1")
    "Secondary CHW pump minimum speed"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36
      and (cfg.typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Variable2
        or cfg.typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2)));
  parameter Real yFanCoo_min(
    max=1,
    min=0,
    start=0.1,
    unit="1")
    "Cooler fan minimum speed"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36
      and cfg.typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Integer staChi[:, :](
    each max=1,
    each min=0)
    "Chiller staging matrix with chiller stage as row index and chiller as column index, excluding stage zero: 0 for disabled, 1 for enabled"
    annotation (Evaluate=true, Dialog(group="Plant staging"));
  final parameter Integer nStaChi = size(staChi,1)
    "Number of chiller stages, excluding stage zero"
    annotation (Evaluate=true, Dialog(group="Plant staging"));
  final parameter Integer nSta =
    if cfg.typEco<>Buildings.Templates.Plants.Chillers.Types.Economizer.None
    then 2*(nStaChi + 1) else nStaChi + 1
    "Number of plant stages, including stage zero and distinguishing stages with and without WSE, if applicable"
    annotation (Evaluate=true, Dialog(group="Plant staging"));
  parameter Integer staPumConWat[:, :](
    start=fill(0, nSta, cfg.nPumConWat))
    "Condenser water pump staging matrix, with plant stage as row index and condenser water pump as column index: 0 for disabled, 1 for enabled"
    annotation (Evaluate=true, Dialog(group="Plant staging",
      enable=cfg.typCtl==Buildings.Templates.Plants.Chillers.Types.Controller.G36 and
      cfg.typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Integer staCoo[:](
    max=fill(cfg.nCoo, nSta),
    start=fill(cfg.nCoo, nSta))
    "Number of enabled tower cells for each plant stage"
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
