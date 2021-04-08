within Buildings.Templates.BaseClasses.OutdoorAirSection;
model NoEconomizer "No economizer"
  extends Buildings.Templates.Interfaces.OutdoorAirSection(
    final typ=Types.OutdoorAir.NoEconomizer,
    redeclare Dampers.TwoPosition damOutIso);
equation
  connect(port_aIns, port_b)
    annotation (Line(points={{-80,0},{180,0}}, color={0,127,255}));
end NoEconomizer;
