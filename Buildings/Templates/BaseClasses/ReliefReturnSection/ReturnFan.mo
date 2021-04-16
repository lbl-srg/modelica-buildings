within Buildings.Templates.BaseClasses.ReliefReturnSection;
model ReturnFan "Return fan - Modulated relief damper"
  extends Buildings.Templates.Interfaces.ReliefReturnSection(
    final typ=Templates.Types.ReliefReturnSection.ReturnFan,
    final typDam=damRel.typ,
    final typFan=fanRet.typ,
    final have_porPre=fanRet.typCtr==Templates.Types.ReturnFanControlSensor.Pressure);

   Dampers.TwoPosition damRel(
    redeclare final package Medium = MediumAir,
    final loc=Buildings.Templates.Types.Location.Relief)
    "Relief damper"
    annotation (
      Placement(transformation(
          extent={{10,-10},{-10,10}},
          rotation=0,
          origin={-60,0})));
   replaceable Templates.BaseClasses.Fans.SingleVariable fanRet
     constrainedby Templates.Interfaces.Fan(
       redeclare final package Medium = MediumAir,
       final loc=Templates.Types.Location.Return)
     "Return/relief fan"
    annotation (
      choices(
        choice(redeclare Templates.BaseClasses.Fans.SingleVariable fanRet
          "Single fan - Variable speed"),
        choice(redeclare Templates.BaseClasses.Fans.MultipleVariable fanRet
          "Multiple fans (identical) - Variable speed")),
      Placement(transformation(extent={{130,-10},{110,10}})));
  Templates.BaseClasses.Sensors.Wrapper pRet_rel(
    redeclare final package Medium = MediumAir,
    final typ=if fanRet.typCtr==Templates.Types.ReturnFanControlSensor.Pressure then
      Templates.Types.Sensor.DifferentialPressure else
      Templates.Types.Sensor.None,
    final loc=Templates.Types.Location.Return)
    "Return static pressure sensor"
    annotation (
      Placement(transformation(extent={{50,-10},{30,10}})));
  Templates.BaseClasses.Sensors.Wrapper VRet_flow(
    redeclare final package Medium = MediumAir,
    final typ=if fanRet.typCtr==Templates.Types.ReturnFanControlSensor.Airflow then
      Templates.Types.Sensor.VolumeFlowRate else
      Templates.Types.Sensor.None,
    final loc=Templates.Types.Location.Return)
    "Return air volume flow rate sensor"
    annotation (
      Placement(transformation(extent={{90,-10},{70,10}})));
equation
  connect(damRel.busCon, busCon) annotation (Line(
      points={{-60,10},{-60,20},{0,20},{0,140}},
      color={255,204,51},
      thickness=0.5));
  connect(damRel.port_b, port_aIns)
    annotation (Line(points={{-70,0},{-80,0}}, color={0,127,255}));
  connect(pas.port_a, port_b)
    annotation (Line(points={{-110,0},{-180,0}}, color={0,127,255}));
  connect(fanRet.busCon, busCon) annotation (Line(
      points={{120,10},{120,20},{0,20},{0,140}},
      color={255,204,51},
      thickness=0.5));
  connect(fanRet.port_a, port_a)
    annotation (Line(points={{130,0},{180,0}},color={0,127,255}));
  connect(port_bRet, damRel.port_a)
    annotation (Line(points={{0,-140},{0,0},{-50,0}}, color={0,127,255}));
  connect(damRel.port_a, pRet_rel.port_b)
    annotation (Line(points={{-50,0},{30,0}}, color={0,127,255}));
  connect(pRet_rel.port_a, VRet_flow.port_b)
    annotation (Line(points={{50,0},{70,0}}, color={0,127,255}));
  connect(VRet_flow.port_a, fanRet.port_b)
    annotation (Line(points={{90,0},{110,0}}, color={0,127,255}));
  connect(pRet_rel.port_bRef, port_bPre) annotation (Line(points={{40,-10},{40,-120},
          {80,-120},{80,-140}}, color={0,127,255}));
  connect(pRet_rel.busCon, busCon) annotation (Line(
      points={{40,10},{40,20},{0,20},{0,140}},
      color={255,204,51},
      thickness=0.5));
  connect(VRet_flow.busCon, busCon) annotation (Line(
      points={{80,10},{80,20},{0,20},{0,140}},
      color={255,204,51},
      thickness=0.5));
  annotation (Documentation(info="<html>
<p>
5.16.10 Return-Fan Control—Direct Building Pressure
5.16.10.1 Return fan operates whenever the associated
supply fan is proven ON and shall be off otherwise.
5.16.10.2 Return fans shall be controlled to maintain returnfan
discharge static pressure at set point (Section 5.16.10.5).
5.16.10.3 Exhaust dampers shall only be enabled when
the associated supply and return fans are proven ON and the
minimum outdoor air damper is open. The exhaust dampers
shall be closed when disabled.
5.16.10.5 When exhaust dampers are enabled, a control
loop shall modulate exhaust dampers in sequence with the
return-fan static pressure set point, as shown in Figure
5.16.10.5, to maintain the building pressure at a set point of
12 Pa (0.05 in. of water).
a. From 0% to 50%, the building pressure control loop shall
modulate the exhaust dampers from 0% to 100% open.
b. From 51% to 100%, the building pressure control loop
shall reset the return-fan discharge static pressure set point
from RFDSPmin at 50% loop output to RFDSPmax at
100% of loop output. See Section 3.2.1.4 for RFDSPmin
and RFDSPmax.
</p>
<p>
5.16.11 Return-Fan Control— Airflow Tracking
5.16.11.1 Return fan operates whenever associated supply
fan is proven ON.
5.16.11.2 Return-fan speed shall be controlled to maintain
return airflow equal to supply airflow less differential SR-
DIFF, as determined per Section 3.2.1.5.
5.16.11.3 Relief/exhaust dampers shall be enabled when
the associated supply and return fans are proven ON and
closed otherwise. Exhaust dampers shall modulate as the
inverse of the return air damper per Section 5.16.2.3.4.
</p>
</html>"));
end ReturnFan;
