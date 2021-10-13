within Buildings.Templates.BaseClasses.Valve;
model None
  extends Interfaces.Valve(
    final typ=Buildings.Templates.Types.Valve.None);
  PassThroughFluid pas
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(port_a, pas.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(pas.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={Line(
          points={{-100,0},{100,0}},
          color={28,108,200},
          thickness=1)}),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end None;
