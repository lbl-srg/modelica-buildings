within Buildings.Templates.ChilledWaterPlant.Components.CondenserPumps.Interfaces;
record Data "Data for condenser water pumps"
  extends Modelica.Icons.Record;

  // Structure parameters

  parameter
    Buildings.Templates.ChilledWaterPlant.Components.Types.CondenserPump
    typ "Type of pump arrangement"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nPum(final min=1)
    "Number of pumps"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nChi
    "Number of chillers"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  final parameter Boolean is_dedicated=
    typ == Buildings.Templates.ChilledWaterPlant.Components.Types.CondenserPump.Dedicated
    "= true if condenser pumps are dedicated";

  // Equipment characteristics

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Pump section nominal flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Buildings.Templates.Components.Pumps.Interfaces.Data pum[nPum](
    each m_flow_nominal = m_flow_nominal / nPum)
    "Pump data"
    annotation(Dialog(group = "Pumps"));
  parameter
    Buildings.Templates.Components.Data.Valve valConWatChi[nChi](
      each final m_flow_nominal = m_flow_nominal / nChi,
      each dpValve_nominal = 0)
    "Chiller chilled water side isolation valve"
    annotation(Dialog(group = "Valve", enable=not is_dedicated));

end Data;
