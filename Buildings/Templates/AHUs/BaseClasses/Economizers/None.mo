within Buildings.Templates.AHUs.BaseClasses.Economizers;
model None
  extends Interfaces.Economizer(
    final typ=Types.Economizer.None);

equation
  connect(port_Out, port_Sup)
    annotation (Line(points={{-100,-60},{100,-60}}, color={0,127,255}));
  connect(port_Exh, port_Ret)
    annotation (Line(points={{-100,60},{100,60}}, color={0,127,255}));
  annotation (
  defaultComponentName="eco",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={Line(
          points={{-100,70},{100,70}},
          color={28,108,200},
          thickness=1),                                       Line(
          points={{-100,-70},{100,-70}},
          color={28,108,200},
          thickness=1)}),                            Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end None;
