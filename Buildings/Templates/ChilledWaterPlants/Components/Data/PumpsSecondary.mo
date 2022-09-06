within Buildings.Templates.ChilledWaterPlants.Components.Data;
record PumpsSecondary "Data for secondary CHW pumps"
  extends Modelica.Icons.Record;

  // Structure parameters

  parameter
    Buildings.Templates.ChilledWaterPlants.Components.Types.SecondaryPump typ
    "Type of secondary pumping"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nPum(final min=0) "Number of pumps"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  final parameter Boolean is_none=
    typ ==Buildings.Templates.ChilledWaterPlants.Components.Types.SecondaryPump.None
    "Set to true if there is no secondary pumping";

  // Equipment parameters

  parameter Buildings.Templates.Components.Data.Pump pum[nPum](each
      m_flow_nominal=if is_none then 0 else m_flow_nominal/nPum) "Pump data"
    annotation (Dialog(group="Pumps", enable=not is_none));
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=0
    "Pump group nominal flow rate"
    annotation(Dialog(group = "Nominal condition", enable=not is_none));

end PumpsSecondary;
