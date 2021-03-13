within Buildings.Templates.BaseClasses.Coils;
model None
  extends Buildings.Templates.Interfaces.Coil(
    final typ=Types.Coil.None,
    final have_weaBus=false,
    final have_sou=false,
    final typAct=Types.Valve.None,
    final typHex=Types.HeatExchanger.None);

equation
  connect(port_a, port_b)
    annotation (Line(points={{-100,0},{100,0}}, color={0,127,255}));
  annotation (
    defaultComponentName="coi",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                                              Line(
          points={{-100,0},{100,0}},
          color={28,108,200},
          thickness=1)}),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end None;
