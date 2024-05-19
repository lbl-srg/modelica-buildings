within Buildings.Templates.Components.Interfaces;
partial model PartialSensor "Interface class for sensor"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface
    annotation(__Linkage(enable=false));

  parameter Boolean have_sen=true
    "Set to true for sensor, false for direct pass through"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean isDifPreSen=false
    "Set to true for differential pressure sensor, false for any other sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Integer text_rotation = 0
    "Text rotation angle in icon layer"
    annotation(Dialog(tab="Graphics", enable=false));
  parameter Boolean text_flip = false
    "True to flip text horizontally in icon layer"
    annotation(Dialog(tab="Graphics", enable=false));
  parameter Buildings.Templates.Components.Types.IconPipe icon_pipe =
    Buildings.Templates.Components.Types.IconPipe.None
    "Pipe symbol"
    annotation(Dialog(tab="Graphics", enable=false));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y if have_sen
    "Connector for measured value"
    annotation (Placement(iconVisible=false,
      transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,120})));

equation
  if isDifPreSen and (not have_sen) then
    // Zero flow equations for connectors
    port_a.m_flow = 0;
    port_b.m_flow = 0;

    // No contribution of specific quantities
    port_a.h_outflow = 0;
    port_b.h_outflow = 0;
    port_a.Xi_outflow = zeros(Medium.nXi);
    port_b.Xi_outflow = zeros(Medium.nXi);
    port_a.C_outflow  = zeros(Medium.nC);
    port_b.C_outflow  = zeros(Medium.nC);
  end if;

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={Line(
        visible=icon_pipe<>Buildings.Templates.Components.Types.IconPipe.None
        or (not have_sen) and (not isDifPreSen),
        points={{-100,0},{100,0}},
        color=if icon_pipe==Buildings.Templates.Components.Types.IconPipe.None
        then {28,108,200} else {0,0,0},
        thickness=if icon_pipe==Buildings.Templates.Components.Types.IconPipe.None
        then 1 else 5,
        pattern=if icon_pipe==Buildings.Templates.Components.Types.IconPipe.Return
        then LinePattern.Dash else LinePattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This partial class provides a standard interface for sensor models.
</p>
</html>"));
end PartialSensor;
