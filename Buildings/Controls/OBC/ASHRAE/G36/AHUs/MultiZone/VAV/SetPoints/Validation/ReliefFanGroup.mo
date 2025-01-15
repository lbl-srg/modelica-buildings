within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.Validation;
model ReliefFanGroup
  "Validate model for controlling relief fans group"

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.ReliefFanGroup
    relFanCon(final k=0.5) "Relief damper control, with staging up fans"
    annotation (Placement(transformation(extent={{0,100},{20,120}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.ReliefFanGroup
    relFanCon1 "Relief damper control, with staging up fans and the fan alarm"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.ReliefFanGroup
    relFanCon2 "Relief damper control, with the staging up and down fans"
    annotation (Placement(transformation(extent={{0,-120},{20,-100}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse supFan1(
    final width=1,
    final period=4000)
    "Supply fan status"
    annotation (Placement(transformation(extent={{-120,130},{-100,150}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp dpBui(
    final height=40,
    final offset=0,
    final duration=1800) "Building static presure"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse supFan2(
    final width=1,
    final period=4000,
    shift=600) "Supply fan status"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr[4](
    final t=fill(0.01, 4))
    "Check if the relief fan is proven on"
    annotation (Placement(transformation(extent={{60,100},{80,120}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre[4] "Return relief fan status"
    annotation (Placement(transformation(extent={{100,100},{120,120}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr1[4](
    final t=fill(0.01, 4))
    "Check if the relief fan is proven on"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre1[4] "Return relief fan status"
    annotation (Placement(transformation(extent={{100,0},{120,20}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[4](
    final k=fill(0, 4)) "Constant zero"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Pulse intPul(
    final amplitude=2,
    final period=3600,
    final offset=0) "Fan 1 alarm level"
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol[4](
    final samplePeriod=fill(20, 4))
    "Zero order hold"
    annotation (Placement(transformation(extent={{30,100},{50,120}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol1[4](
    final samplePeriod=fill(20, 4))
    "Zero order hold"
    annotation (Placement(transformation(extent={{30,0},{50,20}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr2[4](
    final t=fill(0.01, 4))
    "Check if the relief fan is proven on"
    annotation (Placement(transformation(extent={{60,-120},{80,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre2[4] "Return relief fan status"
    annotation (Placement(transformation(extent={{100,-120},{120,-100}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol2[4](
    final samplePeriod=fill(20, 4))
    "Zero order hold"
    annotation (Placement(transformation(extent={{30,-120},{50,-100}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp dpBui1(
    final height=-15,
    final offset=20,
    final duration=1800,
    startTime=1800)
    "Building static presure"
    annotation (Placement(transformation(extent={{-120,-120},{-100,-100}})));

equation
  connect(dpBui.y, relFanCon.dpBui) annotation (Line(points={{-98,40},{-80,40},{
          -80,113},{-2,113}}, color={0,0,127}));
  connect(dpBui.y, relFanCon1.dpBui) annotation (Line(points={{-98,40},{-80,40},
          {-80,13},{-2,13}}, color={0,0,127}));
  connect(greThr.y, pre.u)
    annotation (Line(points={{82,110},{98,110}}, color={255,0,255}));
  connect(supFan1.y, relFanCon.u1SupFan[1]) annotation (Line(points={{-98,140},{-20,
          140},{-20,118},{-2,118}}, color={255,0,255}));
  connect(supFan2.y, relFanCon.u1SupFan[2]) annotation (Line(points={{-98,100},{-30,
          100},{-30,118},{-2,118}}, color={255,0,255}));
  connect(supFan1.y, relFanCon1.u1SupFan[1]) annotation (Line(points={{-98,140},{
          -20,140},{-20,18},{-2,18}}, color={255,0,255}));
  connect(supFan2.y, relFanCon1.u1SupFan[2]) annotation (Line(points={{-98,100},{
          -30,100},{-30,18},{-2,18}}, color={255,0,255}));
  connect(pre.y, relFanCon.u1RelFan) annotation (Line(points={{122,110},{130,110},
          {130,80},{-10,80},{-10,102},{-2,102}}, color={255,0,255}));
  connect(greThr1.y, pre1.u)
    annotation (Line(points={{82,10},{98,10}}, color={255,0,255}));
  connect(pre1.y, relFanCon1.u1RelFan) annotation (Line(points={{122,10},{130,10},
          {130,-20},{-10,-20},{-10,2},{-2,2}}, color={255,0,255}));
  connect(conInt.y, relFanCon.uRelFanAla) annotation (Line(points={{-98,-20},{-40,
          -20},{-40,107},{-2,107}}, color={255,127,0}));
  connect(conInt[1].y, relFanCon1.uRelFanAla[2]) annotation (Line(points={{-98,-20},
          {-40,-20},{-40,7},{-2,7}}, color={255,127,0}));
  connect(conInt[2].y, relFanCon1.uRelFanAla[3]) annotation (Line(points={{-98,-20},
          {-40,-20},{-40,7},{-2,7}}, color={255,127,0}));
  connect(conInt[3].y, relFanCon1.uRelFanAla[4]) annotation (Line(points={{-98,-20},
          {-40,-20},{-40,7},{-2,7}}, color={255,127,0}));
  connect(intPul.y, relFanCon1.uRelFanAla[1]) annotation (Line(points={{-98,-60},
          {-40,-60},{-40,7},{-2,7}}, color={255,127,0}));
  connect(relFanCon.yRelFan, zerOrdHol.u)
    annotation (Line(points={{22,110},{28,110}}, color={0,0,127}));
  connect(zerOrdHol.y, greThr.u)
    annotation (Line(points={{52,110},{58,110}}, color={0,0,127}));
  connect(relFanCon1.yRelFan, zerOrdHol1.u)
    annotation (Line(points={{22,10},{28,10}}, color={0,0,127}));
  connect(zerOrdHol1.y, greThr1.u)
    annotation (Line(points={{52,10},{58,10}}, color={0,0,127}));
  connect(greThr2.y,pre2. u)
    annotation (Line(points={{82,-110},{98,-110}}, color={255,0,255}));
  connect(pre2.y,relFanCon2. u1RelFan) annotation (Line(points={{122,-110},{130,-110},
          {130,-140},{-10,-140},{-10,-118},{-2,-118}}, color={255,0,255}));
  connect(relFanCon2.yRelFan, zerOrdHol2.u)
    annotation (Line(points={{22,-110},{28,-110}}, color={0,0,127}));
  connect(zerOrdHol2.y,greThr2. u)
    annotation (Line(points={{52,-110},{58,-110}}, color={0,0,127}));
  connect(dpBui1.y, relFanCon2.dpBui) annotation (Line(points={{-98,-110},{-80,-110},
          {-80,-107},{-2,-107}}, color={0,0,127}));
  connect(supFan1.y, relFanCon2.u1SupFan[1]) annotation (Line(points={{-98,140},{
          -20,140},{-20,-102},{-2,-102}}, color={255,0,255}));
  connect(supFan2.y, relFanCon2.u1SupFan[2]) annotation (Line(points={{-98,100},{
          -30,100},{-30,-102},{-2,-102}}, color={255,0,255}));
  connect(conInt.y, relFanCon2.uRelFanAla) annotation (Line(points={{-98,-20},{-40,
          -20},{-40,-113},{-2,-113}}, color={255,127,0}));

annotation (
  experiment(StopTime=3600, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/AHUs/MultiZone/VAV/SetPoints/Validation/ReliefFanGroup.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.ReliefFanGroup\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.ReliefFanGroup</a>
for relief fan group for systems with multiple zones.
</p>
</html>", revisions="<html>
<ul>
<li>
February 6, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(extent={{-140,-160},{140,160}})));
end ReliefFanGroup;
