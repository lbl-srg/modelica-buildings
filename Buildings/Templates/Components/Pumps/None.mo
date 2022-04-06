within Buildings.Templates.Components.Pumps;
model None "No pump"
  extends Buildings.Templates.Components.Pumps.Interfaces.PartialPump(
    final nPum=0,
    final typ=Buildings.Templates.Components.Types.Pump.None,
    dat(final dp_nominal=0),
    final have_singlePort_a = true,
    final have_singlePort_b = true);
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
