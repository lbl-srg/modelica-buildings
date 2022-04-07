within Buildings.Templates.ChilledWaterPlant.Components.PrimaryPumps.Interfaces;
record Data "Data for primary pumps"
  extends Modelica.Icons.Record;

  // Structure parameters

  parameter
    Buildings.Templates.ChilledWaterPlant.Components.Types.PrimaryPump typ
    "Type of primary pumping"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_byp "= true if primary pumps have a return bypass"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_chiByp "= true if chilled water loop has a chiller bypass"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nPum(final min=1) "Number of pumps"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nChi(final min=1) "Number of chillers"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  final parameter Boolean is_dedicated=
    typ ==Buildings.Templates.ChilledWaterPlant.Components.Types.PrimaryPump.Dedicated;

  // Equipment characteristics

  parameter Buildings.Templates.Components.Pumps.Interfaces.Data pum[nPum](
    each m_flow_nominal = m_flow_nominal / nPum)
    "Pump data"
    annotation(Dialog(group = "Pumps"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Pump group nominal flow rate"
    annotation(Dialog(group = "Nominal condition"));

  // Fixme : Move this valve to chiller section
  parameter Buildings.Templates.Components.Data.Valve valChiWatChi[nChi](
    each final m_flow_nominal=m_flow_nominal / nChi,
    each dpValve_nominal=0)
    "Chiller chilled water side valve (for headered pumps)"
    annotation(Dialog(group = "Valves", enable = not is_dedicated));
  parameter Buildings.Templates.Components.Data.Valve valByp(
    final m_flow_nominal=m_flow_nominal,
    dpValve_nominal=0)
    "Bypass valve data"
    annotation(Dialog(group = "Valves", enable=have_byp));
  parameter Buildings.Templates.Components.Data.Valve valChiByp(
    final m_flow_nominal=m_flow_nominal,
    dpValve_nominal=0)
    "Chiller bypass valve data"
    annotation(Dialog(group = "Valves", enable=have_chiByp));

end Data;
