within Buildings.Templates.BaseClasses.ReliefReturnSection;
model ReliefFan "Relief fan - Two-position relief damper"
  extends Buildings.Templates.Interfaces.ReliefReturnSection(
    final typ=Templates.Types.ReliefReturn.ReliefFan,
    final typDamRel=damRel.typ,
    final typFan=fanRet.typ,
    final have_porPre=fanRet.typCtr==Templates.Types.ReturnFanControlSensor.Pressure);

   Dampers.TwoPosition damRel(
    redeclare final package Medium = MediumAir)
    "Relief damper"
    annotation (
      Placement(transformation(
          extent={{10,-10},{-10,10}},
          rotation=0,
          origin={-60,0})));
   replaceable Templates.BaseClasses.Fans.SingleVariable fanRet
     constrainedby Templates.Interfaces.Fan(
      redeclare final package Medium = MediumAir,
      final typCtr=Templates.Types.ReturnFanControlSensor.None)
    "Return/relief fan"
    annotation (
      choices(
        choice(redeclare Templates.BaseClasses.Fans.SingleVariable fanRet
          "Single fan - Variable speed"),
        choice(redeclare Templates.BaseClasses.Fans.MultipleVariable fanRet
          "Multiple fans (identical) - Variable speed")),
      Placement(transformation(extent={{-10,-10},{-30,10}})));
equation
  connect(damRel.busCon, busCon) annotation (Line(
      points={{-60,10},{-60,20},{0,20},{0,140}},
      color={255,204,51},
      thickness=0.5));
  connect(damRel.port_b, port_aIns)
    annotation (Line(points={{-70,0},{-80,0}}, color={0,127,255}));
  connect(pas.port_a, port_b)
    annotation (Line(points={{-110,0},{-180,0}}, color={0,127,255}));
  connect(damRel.port_a,fanRet. port_b)
    annotation (Line(points={{-50,0},{-30,0}}, color={0,127,255}));
  connect(fanRet.port_a, port_a)
    annotation (Line(points={{-10,0},{180,0}}, color={0,127,255}));
  connect(fanRet.busCon, busCon) annotation (Line(
      points={{-20,10},{-20,20},{0,20},{0,140}},
      color={255,204,51},
      thickness=0.5));
  connect(fanRet.port_a, port_bRet)
    annotation (Line(points={{-10,0},{0,0},{0,-140}}, color={0,127,255}));
  annotation (Documentation(info="<html>
<p>
5.16.8 Control of Actuated Relief Dampers without Fans
5.16.8.1 Relief dampers shall be enabled when the associated
supply fan is proven ON, and disabled otherwise.
5.16.8.2 When enabled, use a P-only control loop to
modulate relief dampers to maintain 12 Pa (0.05 in. of water)
building static pressure. Close damper when disabled.
</p>
</html>"));
end ReliefFan;
