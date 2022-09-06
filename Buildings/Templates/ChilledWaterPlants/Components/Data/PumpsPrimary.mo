within Buildings.Templates.ChilledWaterPlants.Components.Data;
record PumpsPrimary "Data for primary CHW pumps"
  extends Modelica.Icons.Record;

  // Structure parameters

  parameter Buildings.Templates.ChilledWaterPlants.Components.Types.PrimaryPump
    typ "Type of primary pumping"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_minFloByp "Set to true if primary pumps have a return bypass"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_chiWatChiByp "Set to true if chilled water loop has a chiller bypass"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nPum(final min=1) "Number of pumps"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nChi(final min=1) "Number of chillers"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  final parameter Boolean is_dedicated=
    typ ==Buildings.Templates.ChilledWaterPlants.Components.Types.PrimaryPump.Dedicated
    "Set to true if primary pumps are dedicated";

  // Equipment characteristics

  parameter Buildings.Templates.Components.Data.Pump pum[nPum](each
      m_flow_nominal=m_flow_nominal/nPum) "Pump data"
    annotation (Dialog(group="Pumps"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Pump group nominal flow rate"
    annotation(Dialog(group = "Nominal condition"));

  parameter Buildings.Templates.Components.Data.Valve valPriMinFloByp(
    final typ = Buildings.Templates.Components.Types.Valve.TwoWayModulating,
    final m_flow_nominal=m_flow_nominal,
    dpValve_nominal=0)
    "Chilled water minimum flow bypass valve"
    annotation(Dialog(group = "Valves", enable=have_minFloByp));
  parameter Buildings.Templates.Components.Data.Valve valChiWatChiByp(
    final typ = Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition,
    final m_flow_nominal=m_flow_nominal,
    dpValve_nominal=0)
    "Chiller chilled water bypass valve"
    annotation(Dialog(group = "Valves", enable=have_chiWatChiByp));
  parameter Buildings.Templates.Components.Data.Valve valChiWatChiIso[nChi](
      each final m_flow_nominal = m_flow_nominal/nChi,
      each dpValve_nominal = 0)
    "Chiller chilled water isolation valves"
    annotation(Dialog(group = "Valve",
      enable=typ == Buildings.Templates.ChilledWaterPlants.Components.Types.PrimaryPump.HeaderedParallel));

end PumpsPrimary;
