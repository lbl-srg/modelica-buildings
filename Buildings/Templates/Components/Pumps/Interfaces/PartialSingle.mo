within Buildings.Templates.Components.Pumps.Interfaces;
partial model PartialSingle "Interface class for single pump"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    redeclare replaceable package Medium=Buildings.Media.Water,
    final m_flow_nominal=m_flow_nominal)
    annotation(__Linkage(enable=false));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Design mass flow rate"
    annotation (Dialog(group="Nominal condition"));

  parameter Buildings.Templates.Components.Types.Pump typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.PumpMotor typMot
    "Motor type"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Buildings.Templates.Components.Data.Pump dat(
    final typ=typ)
    "Pump data";

  parameter Integer text_rotation = 0
    "Text rotation angle in icon layer"
    annotation(Dialog(tab="Graphics", enable=false));
  parameter Boolean text_flip = false
    "True to flip text horizontally in icon layer"
    annotation(Dialog(tab="Graphics", enable=false));

  Buildings.Templates.Components.Interfaces.Bus bus
    "Control bus"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));

  annotation (Icon(coordinateSystem(preserveAspectRatio=true), graphics={
    Line( visible=typ==Buildings.Templates.Components.Types.Pump.None,
          points={{100,0},{-100,0}},
          color={0,0,0},
          thickness=1)}),
   Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This partial class provides a standard interface for pump models.
</p>
</html>"));

end PartialSingle;
