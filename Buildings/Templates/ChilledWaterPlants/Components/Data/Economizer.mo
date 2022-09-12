within Buildings.Templates.ChilledWaterPlants.Components.Data;
record Economizer "Data for waterside economizer"
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.ChilledWaterPlants.Types.Economizer typ
    "Type of CHW flow control"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_valChiWatEcoByp
    "Set to true if CHW flowrate is controlled by a modulating bypass valve"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=have_eco));

  // Equipment characteristics
  parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_nominal(
    final min=0)
    "CHW mass flow rate"
    annotation(Dialog(group="Nominal condition",
    enable=typ<>Buildings.Templates.ChilledWaterPlants.Types.Economizer.None));
  parameter Modelica.Units.SI.MassFlowRate mConWat_flow_nominal(
    final min=0)
    "CW mass flow rate"
    annotation(Dialog(group="Nominal condition",
    enable=typ<>Buildings.Templates.ChilledWaterPlants.Types.Economizer.None));

  parameter Modelica.Units.SI.PressureDifference dpChiWat_nominal
    "Heat exchanger CHW pressure drop"
    annotation(Dialog(group="Nominal condition",
    enable=typ<>Buildings.Templates.ChilledWaterPlants.Types.Economizer.None));
  parameter Modelica.Units.SI.PressureDifference dpConWat_nominal
    "Heat exchanger CW design pressure drop"
    annotation(Dialog(group="Nominal condition",
    enable=typ<>Buildings.Templates.ChilledWaterPlants.Types.Economizer.None));

  parameter Modelica.Units.SI.Temperature TChiWatEnt_nominal
    "Heat exchanger entering CHW temperature"
    annotation(Dialog(group="Nominal condition",
    enable=typ<>Buildings.Templates.ChilledWaterPlants.Types.Economizer.None));
  parameter Modelica.Units.SI.Temperature TConWatEnt_nominal
    "Heat exchanger entering CW temperature"
    annotation(Dialog(group="Nominal condition",
    enable=typ<>Buildings.Templates.ChilledWaterPlants.Types.Economizer.None));

  parameter Modelica.Units.SI.HeatFlowRate cap_nominal(
    final min=0)
    "Cooling capacity"
    annotation(Dialog(group="Nominal condition",
      enable=typ<>Buildings.Templates.ChilledWaterPlants.Types.Economizer.None));

  final parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal(
    final max=0)=-1 * cap_nominal
    "Heat flow rate"
    annotation(Dialog(group="Nominal condition",
    enable=typ<>Buildings.Templates.ChilledWaterPlants.Types.Economizer.None));

  parameter Buildings.Templates.Components.Data.Valve valConWatIso(
    final typ = Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition,
    final m_flow_nominal = m1_flow_nominal,
    dpValve_nominal=0)
    "WSE CW isolation valve"
    annotation(Dialog(group="Valves",
    enable=typ<>Buildings.Templates.ChilledWaterPlants.Types.Economizer.None));

  parameter Buildings.Templates.Components.Data.Valve valChiWatByp(
    final typ = Buildings.Templates.Components.Types.Valve.TwoWayModulating,
    final m_flow_nominal = m2_flow_nominal,
    dpValve_nominal=0)
    "WSE CHW bypass valve"
    annotation(Dialog(group="Valves",
    enable=typ==Buildings.Templates.ChilledWaterPlants.Types.Economizer.HeatExchangerWithValve));

  parameter Buildings.Templates.Components.Data.PumpMultiple pumEco(
    final typ=Buildings.Templates.Components.Types.Pump.Variable,
    final m_flow_nominal=m2_flow_nominal)
    "Heat exchanger pump"
     annotation (Dialog(group="Pumps",
     enable=typ==Buildings.Templates.ChilledWaterPlants.Types.Economizer.HeatExchangerWithPump));

end Economizer;
