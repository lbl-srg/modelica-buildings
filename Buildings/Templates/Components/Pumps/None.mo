within Buildings.Templates.Components.Pumps;
model None "No pump"
  extends Buildings.Templates.Components.Interfaces.PartialPump(
    final typ=Buildings.Templates.Types.Pump.None,
    final nPum=1,
    dp_nominal=0);
equation
  connect(port_a, port_b)
    annotation (Line(points={{-100,0},{100,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={Line(
          points={{-100,0},{100,0}},
          color={28,108,200},
          thickness=1)}),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This is a direct fluid pass-through model to represent
a configuration with no pump.
</p>
</html>"));
end None;
