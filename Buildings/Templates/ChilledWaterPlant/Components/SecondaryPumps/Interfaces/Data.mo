within Buildings.Templates.ChilledWaterPlant.Components.SecondaryPumps.Interfaces;
record Data "Data for secondary pumps"
  extends Modelica.Icons.Record;

  // Structure parameters

  parameter
    Buildings.Templates.ChilledWaterPlant.Components.Types.SecondaryPump typ
    "Type of secondary pumping"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nPum(final min=0) "Number of pumps"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  final parameter Boolean is_none=
    typ == Buildings.Templates.ChilledWaterPlant.Components.Types.SecondaryPump.None
    "= true if there is no secondary pumping";

  // Equipment parameters

  parameter Buildings.Templates.Components.Pumps.Interfaces.Data pum[nPum](
    each m_flow_nominal = if is_none then 0 else m_flow_nominal / nPum)
    "Pump data"
    annotation(Dialog(group = "Pumps", enable=not is_none));
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=0
    "Pump group nominal flow rate"
    annotation(Dialog(group = "Nominal condition", enable=not is_none));

end Data;
