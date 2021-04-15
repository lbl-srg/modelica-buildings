within Buildings.Templates.BaseClasses.ReliefReturnSection;
model NoEconomizer "No economizer"
  extends Buildings.Templates.Interfaces.ReliefReturnSection(
    final typ=Templates.Types.ReliefReturnSection.NoEconomizer,
    final typDamRel=damRel.typ,
    final typFan=fanRet.typ,
    final have_porPre=fanRet.typCtr==Templates.Types.ReturnFanControlSensor.Pressure);

  replaceable Templates.BaseClasses.Fans.None fanRet
    constrainedby Templates.Interfaces.Fan(
      redeclare final package Medium = MediumAir,
      final loc=Templates.Types.Location.Return)
    "Return/relief fan"
    annotation (
      choices(
        choice(redeclare Templates.BaseClasses.Fans.None fanRet
          "No fan"),
        choice(redeclare Templates.BaseClasses.Fans.SingleVariable fanRet
          "Single fan - Variable speed"),
        choice(redeclare Templates.BaseClasses.Fans.MultipleVariable fanRet
          "Multiple fans (identical) - Variable speed")),
      Dialog(
        group="Exhaust/relief/return section"),
      Placement(transformation(extent={{110,-10},{90,10}})));
  Sensors.Wrapper pRet_rel(
    redeclare final package Medium = MediumAir,
    final typ=if fanRet.typCtr==Templates.Types.ReturnFanControlSensor.Pressure
      then Templates.Types.Sensor.DifferentialPressure else
      Templates.Types.Sensor.None,
    final loc=Templates.Types.Location.Return)
    "Return static pressure sensor"
    annotation (
      Placement(transformation(extent={{30,-10},{10,10}})));
  Sensors.Wrapper VRet_flow(
    redeclare final package Medium = MediumAir,
    final typ=if fanRet.typCtr==Templates.Types.ReturnFanControlSensor.Airflow
      then Templates.Types.Sensor.VolumeFlowRate else
      Templates.Types.Sensor.None,
    final loc=Templates.Types.Location.Return)
    "Return air volume flow rate sensor"
    annotation (
      Placement(transformation(extent={{70,-10},{50,10}})));
   Dampers.TwoPosition damRel(
    redeclare final package Medium = MediumAir,
    final loc=Buildings.Templates.Types.Location.Relief)
    "Relief damper"
    annotation (
      Placement(transformation(
          extent={{10,-10},{-10,10}},
          rotation=0,
          origin={-150,0})));
equation
  connect(port_a, fanRet.port_a)
    annotation (Line(points={{180,0},{110,0}}, color={0,127,255}));
  connect(fanRet.port_b, VRet_flow.port_a)
    annotation (Line(points={{90,0},{70,0}}, color={0,127,255}));
  connect(VRet_flow.port_b, pRet_rel.port_a)
    annotation (Line(points={{50,0},{30,0}}, color={0,127,255}));
  connect(pRet_rel.port_b, port_aIns)
    annotation (Line(points={{10,0},{-80,0}}, color={0,127,255}));
  connect(pRet_rel.busCon, busCon) annotation (Line(
      points={{20,10},{20,20},{0,20},{0,140}},
      color={255,204,51},
      thickness=0.5));
  connect(VRet_flow.busCon, busCon) annotation (Line(
      points={{60,10},{60,20},{0,20},{0,140}},
      color={255,204,51},
      thickness=0.5));
  connect(fanRet.busCon, busCon) annotation (Line(
      points={{100,10},{100,20},{0,20},{0,140}},
      color={255,204,51},
      thickness=0.5));
  connect(pRet_rel.port_bRef, port_bPre) annotation (Line(points={{20,-10},{20,
          -120},{80,-120},{80,-140}}, color={0,127,255}));
  connect(port_b, damRel.port_b)
    annotation (Line(points={{-180,0},{-160,0}}, color={0,127,255}));
  connect(damRel.port_a, pas.port_a)
    annotation (Line(points={{-140,0},{-110,0}}, color={0,127,255}));
  connect(damRel.busCon, busCon) annotation (Line(
      points={{-150,10},{-150,20},{0,20},{0,140}},
      color={255,204,51},
      thickness=0.5));
end NoEconomizer;
