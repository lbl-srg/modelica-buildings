within Buildings.Templates.AirHandlersFans.Components.OutdoorSection;
model NoEconomizer "No air economizer"
  extends Buildings.Templates.AirHandlersFans.Components.OutdoorSection.Interfaces.PartialOutdoorSection(
    final typ=Types.OutdoorSection.NoEconomizer,
    final typDamOut=damOut.typ,
    final typDamOutMin=Buildings.Templates.Components.Types.Damper.None);

  Buildings.Templates.Components.Dampers.TwoPosition damOut(redeclare final
      package Medium = MediumAir, final loc=Buildings.Templates.Components.Types.Location.OutdoorAir)
    "Outdoor air damper" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-150,0})));
equation
  /* Hardware point connection - start */
  connect(damOut.bus, bus.damOut);
  /* Hardware point connection - end */
  connect(port_aIns, port_b)
    annotation (Line(points={{-80,0},{180,0}}, color={0,127,255}));
  connect(port_a, damOut.port_a)
    annotation (Line(points={{-180,0},{-160,0}}, color={0,127,255}));
  connect(damOut.port_b, pas.port_a)
    annotation (Line(points={{-140,0},{-110,0}}, color={0,127,255}));
end NoEconomizer;
