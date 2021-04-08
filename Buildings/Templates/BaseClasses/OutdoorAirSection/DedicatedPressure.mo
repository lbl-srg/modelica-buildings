within Buildings.Templates.BaseClasses.OutdoorAirSection;
model DedicatedPressure
  "Dedicated minimum OA damper (two-position) with differential pressure sensor"
  extends Buildings.Templates.Interfaces.OutdoorAirSection(
    final typ=Types.OutdoorAir.DedicatedPressure,
    final typDamOut=damOut.typ,
    final typDamOutMin=damOutMin.typ);

   BaseClasses.Dampers.Modulated damOut(
     redeclare final package Medium = MediumAir)
    "Outdoor air damper"
    annotation (
      Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={0,0})));

  Dampers.TwoPosition damOutMin(
    redeclare final package Medium = MediumAir)
    "Minimum outdoor air damper"
    annotation (
    Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,60})));

  Sensors.Temperature TOutMin(
    redeclare final package Medium = MediumAir)
    "Minimum outdoor air temperature sensor"
    annotation (
      Placement(transformation(extent={{70,50},{90,70}})));

  Sensors.DifferentialPressure dpOutMin(
    redeclare final package Medium = MediumAir)
    "Minimum outdoor air damper differential pressure sensor"
    annotation (
      Placement(transformation(extent={{10,50},{30,70}})));
equation
  connect(port_aIns, damOut.port_a)
    annotation (Line(points={{-80,0},{-10,0}}, color={0,127,255}));
  connect(damOut.busCon, busCon) annotation (Line(
      points={{0,10},{0,76},{0,140},{0,140}},
      color={255,204,51},
      thickness=0.5));
  connect(damOutMin.port_b,TOutMin. port_a)
    annotation (Line(points={{60,60},{70,60}},         color={0,127,255}));
  connect(dpOutMin.port_b,damOutMin. port_a)
    annotation (Line(points={{30,60},{40,60}},         color={0,127,255}));
  connect(TOutMin.port_b, port_b) annotation (Line(points={{90,60},{120,60},{120,
          0},{180,0}}, color={0,127,255}));
  connect(port_aIns, port_aIns)
    annotation (Line(points={{-80,0},{-80,0}}, color={0,127,255}));
  connect(port_aIns, dpOutMin.port_a) annotation (Line(points={{-80,0},{-20,0},{
          -20,60},{10,60}}, color={0,127,255}));
  connect(dpOutMin.port_bRef, port_b) annotation (Line(points={{20,50},{20,40},{
          120,40},{120,0},{180,0}}, color={0,127,255}));
  connect(dpOutMin.busCon, busCon) annotation (Line(
      points={{20,70},{20,80},{0,80},{0,140}},
      color={255,204,51},
      thickness=0.5));
  connect(damOutMin.busCon, busCon) annotation (Line(
      points={{50,70},{50,80},{0,80},{0,140}},
      color={255,204,51},
      thickness=0.5));
  connect(TOutMin.busCon, busCon) annotation (Line(
      points={{80,70},{80,80},{0,80},{0,140}},
      color={255,204,51},
      thickness=0.5));
  connect(damOut.port_b, port_b)
    annotation (Line(points={{10,0},{180,0}}, color={0,127,255}));
  connect(port_a, pas.port_a)
    annotation (Line(points={{-180,0},{-110,0}}, color={0,127,255}));
end DedicatedPressure;
