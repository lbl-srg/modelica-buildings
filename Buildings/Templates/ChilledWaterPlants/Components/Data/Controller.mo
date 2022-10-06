within Buildings.Templates.ChilledWaterPlants.Components.Data;
record Controller "Record for plant controller"
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.Components.Types.Chiller typChi
    "Type of chiller"
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
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Integer nPumChiWatSec=nChi
    "Number of secondary CHW pumps"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.Cooler typCoo
    "Condenser water cooling equipment"
    annotation(Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nCoo
    "Number of cooler units"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.PumpMultipleSpeedControl typCtrSpePumConWat
    "Type of CW pump speed control"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.ChilledWaterPlants.Types.Economizer typEco
    "Type of WSE"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Modelica.Units.SI.Temperature TChiWatChiSup_nominal[nChi](
    each displayUnit="degC",
    each start=Buildings.Templates.Data.Defaults.TChiWatSup,
    each final min=260)
    "Design (lowest) CHW supply temperature setpoint - Each chiller"
    annotation(Dialog(group="Temperature setpoints"));
  parameter Modelica.Units.SI.Temperature TChiWatSup_max(
    displayUnit="degC",
    final min=260)=Buildings.Templates.Data.Defaults.TChiWatSup_max
    "Maximum CHW supply temperature setpoint used in plant reset logic"
    annotation(Dialog(group="Temperature setpoints"));
  parameter Modelica.Units.SI.Temperature TConWatChiRet_nominal[nChi](
    each displayUnit="degC",
    each start=Buildings.Templates.Data.Defaults.TConWatRet,
    each final min=273.15)
    "CW return temperature at chiller selection conditions - Each chiller"
    annotation(Dialog(group="Temperature setpoints",
    enable=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Modelica.Units.SI.Temperature TConWatChiSup_nominal[nChi](
    each displayUnit="degC",
    each start=Buildings.Templates.Data.Defaults.TConWatSup,
    each final min=273.15)
    "CW supply temperature at chiller selection conditions - Each chiller"
    annotation(Dialog(group="Temperature setpoints",
    enable=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Modelica.Units.SI.Temperature TAirOutLoc(
    displayUnit="degC",
    final min=273.15)
    "Outdoor air lockout temperature below which the plant is prevented from operating"
    annotation(Dialog(group="Temperature setpoints"));

  parameter Modelica.Units.SI.PressureDifference dpChiWatSet_min(
    start=Buildings.Templates.Data.Defaults.dpChiWatSet_min)
    "Minimum CHW differential pressure setpoint used in plant reset logic"
    annotation(Dialog(group="Differential pressure setpoints"));

  parameter Modelica.Units.SI.MassFlowRate mChiWatChi_flow_nominal[nChi](
    each final min=0)
    "Design CHW mass flow rate - Each chiller"
    annotation(Dialog(group="Chiller flow setpoints"));
  parameter Modelica.Units.SI.MassFlowRate mChiWatChi_flow_min[nChi](
    each final min=0)
    "Minimum CHW mass flow rate - Each chiller"
    annotation(Dialog(group="Chiller flow setpoints"));
  parameter Modelica.Units.SI.MassFlowRate mConWatChi_flow_nominal[nChi](
    each start=1,
    each final min=0)
    "Design CW mass flow rate - Each chiller"
    annotation(Dialog(group="Chiller flow setpoints", enable=
    typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled and
    (typCtrSpePumConWat==Buildings.Templates.Components.Types.PumpMultipleSpeedControl.VariableCommon or
    typCtrSpePumConWat==Buildings.Templates.Components.Types.PumpMultipleSpeedControl.VariableDedicated)));

  parameter Modelica.Units.SI.TemperatureDifference dTLifChi_min[nChi](
    each start=Buildings.Templates.Data.Defaults.dTLifChi_min,
    each final min=0)
    "Minimum allowable lift at minimum load - Each chiller"
    annotation(Dialog(group="Chiller lift setpoints", enable=
    typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Modelica.Units.SI.TemperatureDifference dTLifChi_nominal[nChi](
    each final min=0)=TConWatChiRet_nominal-TChiWatChiSup_nominal
    "Design lift at design load - Each chiller"
    annotation(Dialog(group="Chiller lift setpoints", enable=
    typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));

  parameter Modelica.Units.SI.HeatFlowRate capChi_nomina[nChi](
    each final min=0)
    "Design capacity - Each chiller"
    annotation(Dialog(group="Capacity"));
  parameter Modelica.Units.SI.MassFlowRate mChiWatPri_nominal(
    start=1,
    final min=0)
    "Design primary CHW mass flow rate"
    annotation(Dialog(group="Capacity"));
  parameter Modelica.Units.SI.MassFlowRate mChiWatSec_nominal(
    start=1,
    final min=0)
    "Design secondary CHW mass flow rate"
    annotation(Dialog(group="Capacity"));

  parameter Real PLRUnlChi_min[nChi](
    each final min=0,
    each final max=1)
    "Minimum load before engaging hot gas bypass or cycling - Each chiller"
    annotation(Dialog(group="Minimum cycling load"));

  parameter Modelica.Units.SI.TemperatureDifference dTAppEco_nominal(
    start=Buildings.Templates.Data.Defaults.TChiWatEcoLvg-
    Buildings.Templates.Data.Defaults.TConWatEcoEnt,
    final min=0)
    "Design heat exchanger approach"
    annotation(Dialog(group="Waterside economizer design information",
    enable=typEco<>Buildings.Templates.ChilledWaterPlants.Types.Economizer.None));
  parameter Modelica.Units.SI.TemperatureDifference TWetBulCooEnt_nominal(
    start=Buildings.Templates.Data.Defaults.TWetBulTowEnt,
    final min=273.15)
    "Design cooling tower wetbulb temperature"
    annotation(Dialog(group="Waterside economizer design information",
    enable=typEco<>Buildings.Templates.ChilledWaterPlants.Types.Economizer.None));
  parameter Modelica.Units.SI.TemperatureDifference dTAppCoo_nominal(
    start=Buildings.Templates.Data.Defaults.TConWatSup-
    Buildings.Templates.Data.Defaults.TWetBulTowEnt,
    final min=0)
    "Design cooling tower approach"
    annotation(Dialog(group="Waterside economizer design information",
    enable=typEco<>Buildings.Templates.ChilledWaterPlants.Types.Economizer.None));
  parameter Modelica.Units.SI.MassFlowRate mChiWatEco_flow_nominal(
    start=1,
    final min=0)
    "Design waterside economizer CHW mass flow rate"
    annotation(Dialog(group="Waterside economizer design information",
    enable=typEco<>Buildings.Templates.ChilledWaterPlants.Types.Economizer.None));
  parameter Modelica.Units.SI.MassFlowRate mConWatEco_flow_nominal(
    start=1,
    final min=0)
    "Design waterside economizer CW mass flow rate"
    annotation(Dialog(group="Waterside economizer design information",
    enable=typEco==Buildings.Templates.ChilledWaterPlants.Types.Economizer.HeatExchangerWithValve));
  parameter Modelica.Units.SI.PressureDifference dpChiWatEco_nominal(
    start=Buildings.Templates.Data.Defaults.dpChiWatEco,
    final min=0)
    "Design waterside economizer CHW pressure drop"
    annotation(Dialog(group="Waterside economizer design information",
    enable=typEco==Buildings.Templates.ChilledWaterPlants.Types.Economizer.HeatExchangerWithValve));

  parameter Modelica.Units.SI.PressureDifference dpChiWatSet_nominal(
    start=Buildings.Templates.Data.Defaults.dpChiWatSet_max,
    final min=0)
    "Design (maximum) CHW differential pressure setpoint - Remote sensor"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=toadd));
  parameter Modelica.Units.SI.PressureDifference dpChiWatLocSet_nominal(
    start=Buildings.Templates.Data.Defaults.dpChiWatLocSet_max,
    final min=0)
    "Design (maximum) CHW differential pressure setpoint - Local sensor"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=toadd));
  parameter Real yValConWatChiIso_min(
    final unit="1",
    final min=0,
    final max=1,
    start=toadd)
    "Minimum head pressure control valve position"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=toadd));
  parameter Real yPumConWat_min(
    final unit="1",
    final min=0,
    final max=1,
    start=toadd)
    "Minimum CW pump speed"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=toadd));
  parameter Real yPumChiWatEco_nominal(
    final unit="1",
    final min=0,
    final max=1,
    start=toadd)
    "WSE heat exchanger pump speed delivering design CHW flow through the heat exchanger "
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=toadd));
  parameter Real yPumChiWatPriSta_nominal(
    final unit="1",
    final min=0,
    final max=1,
    start=toadd)
    "Primary CHW pump speed delivering design flow through operating chiller(s) in the stage"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=toadd));
  parameter Real yPumChiWatPriSta_min(
    final unit="1",
    final min=0,
    final max=1,
    start=toadd)
    "Primary CHW pump speed delivering minimum flow through operating chiller(s) in the stage"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=toadd));
  parameter Real yPumChiWatPri_min(
    final unit="1",
    final min=0,
    final max=1,
    start=0.1)
    "Primary CHW pump minimum speed"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=toadd));
  parameter Real yPumChiWatSec_min(
    final unit="1",
    final min=0,
    final max=1,
    start=0.1)
    "Secondary CHW pump minimum speed"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=toadd));
  /* FIXME: See how to handle duplicate information / line 180.
  parameter Real yPumConWat_min(
    final unit="1",
    final min=0,
    final max=1,
    start=0.1)
    "CW pump minimum speed"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=toadd));
  */
  parameter Real yFanCoo_min(
    final unit="1",
    final min=0,
    final max=1,
    start=0.1)
    "Cooler fan minimum speed"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=toadd));
end Controller;
