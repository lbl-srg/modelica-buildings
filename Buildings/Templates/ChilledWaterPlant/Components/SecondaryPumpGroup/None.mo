within Buildings.Templates.ChilledWaterPlant.Components.SecondaryPumpGroup;
model None "No secondary pumping"
  extends
    Buildings.Templates.ChilledWaterPlant.Components.SecondaryPumpGroup.Interfaces.PartialSecondaryPumpGroup(
      dat(
        final typ=Buildings.Templates.ChilledWaterPlant.Components.Types.SecondaryPumpGroup.None,
        final typPum=Buildings.Templates.Components.Types.Pump.None));

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
