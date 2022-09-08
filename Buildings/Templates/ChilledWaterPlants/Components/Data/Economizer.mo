within Buildings.Templates.ChilledWaterPlants.Components.Data;
record Economizer "Data for waterside economizer"
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.ChilledWaterPlants.Types.EconomizerFlowControl typ
    "Type of CHW flow control"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_valChiWatEcoByp
    "Set to true if CHW flowrate is controlled by a modulating bypass valve"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=have_eco));

  // Equipment characteristics
  parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_nominal(
    final min=0)
    "Design CHW water mass flow rate"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mConWat_flow_nominal(
    final min=0)
    "Design CW mass flow rate"
    annotation(Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.PressureDifference dpConWatHex_nominal
    "Heat exchanger condenser water side nominal pressure difference"
    annotation(Dialog(group = "Heat Exchanger", enable=have_eco));
  parameter Modelica.Units.SI.PressureDifference dpChiWatHex_nominal
    "Heat exchanger chilled water side nominal pressure difference"
    annotation(Dialog(group = "Heat Exchanger", enable=have_eco));

  parameter Modelica.Units.SI.Temperature T_ConWatHexEnt_nominal
    "Heat exchanger condenser water side nominal entering temperature"
    annotation(Dialog(group = "Heat Exchanger", enable=have_eco));
  parameter Modelica.Units.SI.Temperature T_ChiWatHexEnt_nominal
    "Heat exchanger chilled water side nominal entering temperature"
    annotation(Dialog(group = "Heat Exchanger", enable=have_eco));

  parameter Modelica.Units.SI.HeatFlowRate QHex_flow_nominal
    "Heat exchanger nominal heat flow rate"
    annotation(Dialog(group = "Heat Exchanger", enable=have_eco));

  parameter Buildings.Templates.Components.Data.Valve valConWatEcoIso(
    final typ = Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition,
    final m_flow_nominal = m1_flow_nominal,
    dpValve_nominal = 0)
    "Waterside economizer heat exchanger condenser water isolation valve"
    annotation(Dialog(group = "Valves", enable=have_eco));
  parameter Buildings.Templates.Components.Data.Valve valChiWatEcoByp(
    final typ = Buildings.Templates.Components.Types.Valve.TwoWayModulating,
    final m_flow_nominal = m2_flow_nominal,
    dpValve_nominal = 0)
    "Waterside economizer chilled water bypass valve"
    annotation(Dialog(group = "Valves", enable=have_eco and have_valChiWatEcoByp));

  parameter Buildings.Templates.Components.Data.Pump pumEco(
    final typ=Buildings.Templates.Components.Types.Pump.Variable,
    final m_flow_nominal=m2_flow_nominal)
    "Waterside economizer heat exchanger pump"
    annotation (Dialog(group="Pumps",
      enable=have_eco and not have_valChiWatEcoByp));

end Economizer;
