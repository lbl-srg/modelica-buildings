within Buildings.Templates.AHUs.BaseClasses.Coils.Valves;
model None "No actuator"
  extends Buildings.Templates.Interfaces.Valve(
    final typ=Types.Actuator.None);

equation
  connect(port_bSup, port_aSup)
    annotation (Line(points={{-40,100},{-40,-100}}, color={0,127,255}));
  connect(port_bRet, port_aRet)
    annotation (Line(points={{40,-100},{40,100}}, color={0,127,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                                              Line(
          points={{-40,100},{-40,-100}},
          color={28,108,200},
          thickness=1),                                       Line(
          points={{40,100},{40,-100}},
          color={28,108,200},
          thickness=1)}),                              Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end None;
