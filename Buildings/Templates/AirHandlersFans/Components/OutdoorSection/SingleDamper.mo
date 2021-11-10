within Buildings.Templates.AirHandlersFans.Components.OutdoorSection;
model SingleDamper "Single common OA damper (modulated) with AFMS"
  extends Buildings.Templates.AirHandlersFans.Components.OutdoorSection.Interfaces.PartialOutdoorSection(
    final typ=Types.OutdoorSection.SingleCommon,
    final typDamOut=damOut.typ,
    final typDamOutMin=Buildings.Templates.Components.Types.Damper.None);

  Buildings.Templates.Components.Sensors.VolumeFlowRate VOut_flow(redeclare
      final package Medium = MediumAir, final loc=Buildings.Templates.Components.Types.Location.OutdoorAir)
    "Outdoor air volume flow rate sensor"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Buildings.Templates.Components.Sensors.Temperature TOut(redeclare final
      package Medium = MediumAir, final loc=Buildings.Templates.Components.Types.Location.OutdoorAir)
    "Outdoor air temperature sensor"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Buildings.Templates.Components.Dampers.Modulated damOut(redeclare final
      package Medium = MediumAir, final loc=Buildings.Templates.Components.Types.Location.OutdoorAir)
    "Outdoor air damper" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,0})));

equation
  /* Hardware point connection - start */
  connect(damOut.bus, bus.damOut);
  connect(TOut.y, bus.TOut);
  connect(VOut_flow.y, bus.VOut_flow);
  /* Hardware point connection - end */
  connect(port_aIns, damOut.port_a)
    annotation (Line(points={{-80,0},{-10,0}}, color={0,127,255}));
  connect(damOut.port_b, TOut.port_a)
    annotation (Line(points={{10,0},{30,0}}, color={0,127,255}));
  connect(TOut.port_b, VOut_flow.port_a)
    annotation (Line(points={{50,0},{70,0}}, color={0,127,255}));
  connect(VOut_flow.port_b, port_b)
    annotation (Line(points={{90,0},{180,0}}, color={0,127,255}));
  connect(port_a, pas.port_a)
    annotation (Line(points={{-180,0},{-110,0}}, color={0,127,255}));

end SingleDamper;
