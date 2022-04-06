within Buildings.Templates.ChilledWaterPlant.Components.PrimaryPumpGroup.Interfaces;
record Data "Data for primary pump groups"
  extends Modelica.Icons.Record;

  // Structure parameters

  parameter Buildings.Templates.ChilledWaterPlant.Components.Types.PrimaryPumpGroup typ "Type of pump"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_byp "= true if primary pump group has a return bypass"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_chiByp "= true if chilled water loop has a chiller bypass"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nPum(final min=1) "Number of pumps"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  final parameter Boolean is_dedicated=
    typ == Buildings.Templates.ChilledWaterPlant.Components.Types.PrimaryPumpGroup.Dedicated;

  // Equipment characteristics

  parameter Buildings.Templates.Components.Pumps.Interfaces.Data pum[nPum](
    each m_flow_nominal = m_flow_nominal / nPum)
    "Pump data"
    annotation(Dialog(group = "Pumps"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Pump group nominal flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpChiWatChiValve_nominal=0
    "Nominal pressure drop of chiller valves on chilled water side"
    annotation(Dialog(group = "Valves", enable=not is_dedicated));
  parameter Modelica.Units.SI.PressureDifference dpByp_nominal=0
    "Bypass valve pressure drop"
    annotation(Dialog(group = "Valves", enable=have_byp));
  parameter Modelica.Units.SI.PressureDifference dpChiByp_nominal=0
    "Chiller bypass valve pressure drop"
    annotation(Dialog(group = "Valves", enable=have_chiByp));

end Data;
