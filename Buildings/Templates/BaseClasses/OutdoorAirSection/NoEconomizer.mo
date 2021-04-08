within Buildings.Templates.BaseClasses.OutdoorAirSection;
model NoEconomizer "No economizer"
  extends Buildings.Templates.Interfaces.OutdoorAirSection(
    final typ=Types.OutdoorAir.NoEconomizer,
    final typDamOut=damOut.typ,
    final typDamOutMin=Templates.Types.Damper.None);

  Dampers.TwoPosition damOut(
   redeclare final package Medium = MediumAir)
   "Outdoor air damper"
   annotation (
     Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-150,0})));
equation
  connect(port_aIns, port_b)
    annotation (Line(points={{-80,0},{180,0}}, color={0,127,255}));
  connect(port_a, damOut.port_a)
    annotation (Line(points={{-180,0},{-160,0}}, color={0,127,255}));
  connect(damOut.port_b, pas.port_a)
    annotation (Line(points={{-140,0},{-110,0}}, color={0,127,255}));
  connect(damOut.busCon, busCon) annotation (Line(
      points={{-150,10},{-150,20},{0,20},{0,140}},
      color={255,204,51},
      thickness=0.5));
end NoEconomizer;
