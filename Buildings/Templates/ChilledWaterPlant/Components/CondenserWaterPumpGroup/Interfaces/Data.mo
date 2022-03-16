within Buildings.Templates.ChilledWaterPlant.Components.CondenserWaterPumpGroup.Interfaces;
record Data "Data for condenser water pump groups"

  // Structure parameters

  parameter Buildings.Templates.ChilledWaterPlant.Components.Types.CondenserWaterPumpGroup typ
    "Type of pump group"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nPum(final min=1)
    "Number of pumps"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  final parameter Boolean is_dedicated=
    typ == Buildings.Templates.ChilledWaterPlant.Components.Types.CondenserWaterPumpGroup.Dedicated
    "Pump group is dedicated";

  // Equipment characteristics

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Pump group nominal flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Buildings.Templates.Components.Pumps.Interfaces.Data pum[nPum](
    each m_flow_nominal = m_flow_nominal / nPum)
    "Pump data"
    annotation(Dialog(group = "Pumps"));
  parameter Modelica.Units.SI.PressureDifference dpCWValve_nominal=0
    "Nominal pressure drop of chiller valves on condenser water side"
    annotation(Dialog(group = "Valves", enable=not is_dedicated));

end Data;
