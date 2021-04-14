within Buildings.Templates.BaseClasses.OutdoorAirSection;
model SingleCommon "Single common OA damper (modulated) with AFMS"
  extends Buildings.Templates.Interfaces.OutdoorAirSection(
    final typ=Types.OutdoorAir.SingleCommon,
    final typDamOut=damOut.typ,
    final typDamOutMin=Templates.Types.Damper.None);

  Sensors.VolumeFlowRate VOut_flow(
    redeclare final package Medium = MediumAir,
    final loc=Buildings.Templates.Types.Location.OutdoorAir)
    "Outdoor air volume flow rate sensor"
    annotation (
      Placement(transformation(extent={{70,-10},{90,10}})));
  BaseClasses.Sensors.Temperature TOut(
      redeclare final package Medium =MediumAir,
      final loc=Buildings.Templates.Types.Location.OutdoorAir)
    "Outdoor air temperature sensor"
    annotation (
      Placement(transformation(extent={{30,-10},{50,10}})));
   BaseClasses.Dampers.Modulated damOut(
     redeclare final package Medium = MediumAir,
     final loc=Buildings.Templates.Types.Location.OutdoorAir)
    "Outdoor air damper"
    annotation (
      Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={0,0})));

equation
  connect(port_aIns, damOut.port_a)
    annotation (Line(points={{-80,0},{-10,0}}, color={0,127,255}));
  connect(damOut.port_b, TOut.port_a)
    annotation (Line(points={{10,0},{30,0}}, color={0,127,255}));
  connect(TOut.port_b, VOut_flow.port_a)
    annotation (Line(points={{50,0},{70,0}}, color={0,127,255}));
  connect(VOut_flow.port_b, port_b)
    annotation (Line(points={{90,0},{180,0}}, color={0,127,255}));
  connect(damOut.busCon, busCon) annotation (Line(
      points={{0,10},{0,76},{0,140},{0,140}},
      color={255,204,51},
      thickness=0.5));
  connect(TOut.busCon, busCon) annotation (Line(
      points={{40,10},{40,20},{0,20},{0,140}},
      color={255,204,51},
      thickness=0.5));
  connect(VOut_flow.busCon, busCon) annotation (Line(
      points={{80,10},{80,20},{0,20},{0,140}},
      color={255,204,51},
      thickness=0.5));
  connect(port_a, pas.port_a)
    annotation (Line(points={{-180,0},{-110,0}}, color={0,127,255}));
end SingleCommon;
