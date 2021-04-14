within Buildings.Templates.BaseClasses.OutdoorAirSection;
model DedicatedAirflow
  "Dedicated minimum OA damper (modulated) with AFMS"
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

  Dampers.Modulated damOutMin(
    redeclare final package Medium = MediumAir)
    "Minimum outdoor air damper"
    annotation (
    Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,60})));

  Sensors.Temperature TOutMin(
    redeclare final package Medium = MediumAir)
    "Minimum outdoor air temperature sensor"
    annotation (
      Placement(transformation(extent={{50,50},{70,70}})));

  Sensors.VolumeFlowRate VOutMin_flow(
    redeclare final package Medium = MediumAir)
    "Minimum outdoor air volume flow rate sensor"
    annotation (
      choices(
        choice(redeclare BaseClasses.Sensors.None VOutMin_flow "No sensor"),
        choice(redeclare BaseClasses.Sensors.VolumeFlowRate VOutMin_flow "Volume flow rate sensor")),
      Dialog(group="Outdoor air section", enable=damOutMin.typ <> Buildings.Templates.Types.Damper.NoPath),
      __Linkage(
        modification(
          condition=typOut <> Buildings.Templates.Types.OutdoorAir.DedicatedAirflow,
            redeclare BaseClasses.Sensors.None VOutMin_flow "No sensor"),
        condition=typOut == Buildings.Templates.Types.OutdoorAir.DedicatedAirflow,
        redeclare BaseClasses.Sensors.VolumeFlowRate VOutMin_flow "Volume flow rate sensor"),
    Placement(transformation(extent={{80,50},{100,70}})));
equation
  connect(port_aIns, damOut.port_a)
    annotation (Line(points={{-80,0},{-10,0}}, color={0,127,255}));
  connect(damOut.busCon, busCon) annotation (Line(
      points={{0,10},{0,76},{0,140},{0,140}},
      color={255,204,51},
      thickness=0.5));
  connect(port_aIns, port_aIns)
    annotation (Line(points={{-80,0},{-80,0}}, color={0,127,255}));
  connect(damOutMin.busCon, busCon) annotation (Line(
      points={{30,70},{30,80},{0,80},{0,140}},
      color={255,204,51},
      thickness=0.5));
  connect(TOutMin.busCon, busCon) annotation (Line(
      points={{60,70},{60,80},{0,80},{0,140}},
      color={255,204,51},
      thickness=0.5));
  connect(damOut.port_b, port_b)
    annotation (Line(points={{10,0},{180,0}}, color={0,127,255}));
  connect(port_a, pas.port_a)
    annotation (Line(points={{-180,0},{-110,0}}, color={0,127,255}));
  connect(TOutMin.port_b, VOutMin_flow.port_a)
    annotation (Line(points={{70,60},{80,60}}, color={0,127,255}));
  connect(VOutMin_flow.port_b, port_b) annotation (Line(points={{100,60},{120,60},
          {120,0},{180,0}}, color={0,127,255}));
  connect(VOutMin_flow.busCon, busCon) annotation (Line(
      points={{90,70},{90,80},{0,80},{0,140}},
      color={255,204,51},
      thickness=0.5));
  connect(damOutMin.port_b, TOutMin.port_a)
    annotation (Line(points={{40,60},{50,60}}, color={0,127,255}));
  connect(port_aIns, damOutMin.port_a) annotation (Line(points={{-80,0},{-20,0},
          {-20,60},{20,60}}, color={0,127,255}));
  annotation (Documentation(info="<html>
<p>
Two classes are used depending on the type of sensor used to control the
OA flow rate because the type of sensor conditions the type of 
damper: two-position in case of differential pressure, modulated in case
of AFMS. 
</p>
</html>"));
end DedicatedAirflow;
