within Buildings.Templates.BaseClasses.Coils;
model None "No coil"
  extends Buildings.Templates.Interfaces.Coil(
    final typ=Types.Coil.None,
    final typHex=Types.HeatExchanger.None,
    final typAct=Types.Actuator.None,
    final have_weaBus=false,
    final have_sou=false);

equation
  connect(port_a, port_bIns)
    annotation (Line(points={{-100,0},{60,0}}, color={0,127,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                                              Line(
          points={{-100,0},{100,0}},
          color={28,108,200},
          thickness=1)}),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end None;
