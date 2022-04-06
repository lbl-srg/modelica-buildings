within Buildings.Templates.ChilledWaterPlant.Components.SecondaryPumps;
model None "No secondary pumping"
  extends
    Buildings.Templates.ChilledWaterPlant.Components.SecondaryPumps.Interfaces.PartialSecondaryPump(
    final nPum=0,
    final typ=Buildings.Templates.ChilledWaterPlant.Components.Types.SecondaryPump.None,
    dat(pum(typ=Buildings.Templates.Components.Types.Pump.None)));

equation
  connect(port_a, port_b)
    annotation (Line(points={{-100,0},{100,0}}, color={0,127,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                                              Line(
          points={{-100,0},{100,0}},
          color={28,108,200},
          thickness=1)}),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end None;
