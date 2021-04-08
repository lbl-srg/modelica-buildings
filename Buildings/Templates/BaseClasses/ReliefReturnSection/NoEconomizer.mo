within Buildings.Templates.BaseClasses.ReliefReturnSection;
model NoEconomizer "No economizer"
  extends Buildings.Templates.Interfaces.ReliefReturnSection(
    final typ=Templates.Types.ReliefReturn.NoEconomizer,
    final have_ret=false,
    redeclare Dampers.TwoPosition damOutIso);

  inner replaceable Fans.None fanRet
    constrainedby Fans.None(
      redeclare final package Medium = MediumAir)
    "Return fan"
    annotation (
      choicesAllMatching=true,
      Dialog(
        group="Exhaust/relief/return section",
        enable=typRel==Buildings.Templates.Types.ReliefReturn.ReturnFanPressure or
          typRel==Buildings.Templates.Types.ReliefReturn.ReturnFanAirflow),
      Placement(transformation(extent={{110,-10},{90,10}})));
  Sensors.Wrapper pRet_rel(
    redeclare final package Medium = MediumAir,
    typ=if typCtrFan==Templates.Types.ReturnFanControl.Pressure
      then Templates.Types.Sensor.DifferentialPressure else
      Templates.Types.Sensor.None)
    "Return static pressure sensor"
    annotation (
      Placement(transformation(extent={{30,-10},{10,10}})));

  Sensors.Wrapper VRet_flow(
    redeclare final package Medium = MediumAir,
    typ=if typCtrFan==Templates.Types.ReturnFanControl.AirFlow
      then Templates.Types.Sensor.VolumeFlowRate else
      Templates.Types.Sensor.None)
    "Return air volume flow rate sensor"
    annotation (
      Placement(transformation(extent={{70,-10},{50,10}})));
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
end NoEconomizer;
