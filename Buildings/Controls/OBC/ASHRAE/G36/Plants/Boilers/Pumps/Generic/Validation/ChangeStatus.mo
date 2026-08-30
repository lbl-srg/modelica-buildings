within Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Pumps.Generic.Validation;
model ChangeStatus
  "Validate sequence for changing pump status"

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Pumps.Generic.ChangeStatus
    chaPumSta(
    final nPum=3)
    "Scenario testing pump status changer"
    annotation (Placement(transformation(extent={{28,-10},{50,10}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol2(
    final trueHoldDuration=1,
    final falseHoldDuration=0)
    "Detect pump status change completion"
    annotation (Placement(transformation(extent={{70,-40},{90,-20}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Pre pre[3](
    final pre_u_start=fill(false, 3))
    "Logical pre block"
    annotation (Placement(transformation(extent={{120,0},{140,20}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.SampleTrigger samTri(
    final period=5,
    final shift=1)
    "Sample trigger"
    annotation (Placement(transformation(extent={{-162,-10},{-142,10}})));

  Buildings.Controls.OBC.CDL.Integers.OnCounter onCouInt
    "Boolean True pulse counter"
    annotation (Placement(transformation(extent={{-132,-6},{-120,6}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr(
    final t=3)
    "Switch pump staging to staging-down after 3 pump stage-ups"
    annotation (Placement(transformation(extent={{-112,-10},{-92,10}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi
    "Logical switch"
    annotation (Placement(transformation(extent={{-72,40},{-52,60}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi1
    "Logical switch"
    annotation (Placement(transformation(extent={{-72,10},{-52,30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=false)
    "Constant Boolean false"
    annotation (Placement(transformation(extent={{-162,70},{-142,90}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical Not"
    annotation (Placement(transformation(extent={{-42,10},{-22,30}})));

  Buildings.Controls.OBC.CDL.Integers.Subtract subInt
    "Generate stage setpoints for staging down processes"
    annotation (Placement(transformation(extent={{-72,-50},{-52,-30}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=7)
    "Constant Integer source"
    annotation (Placement(transformation(extent={{-132,-60},{-112,-40}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel[3](
    final delayTime=2)
    "Time delay for mimicking time delay for pump proven on process"
    annotation (Placement(transformation(extent={{70,0},{90,20}})));

equation
  connect(pre.y, chaPumSta.uHotWatPum) annotation (Line(points={{142,10},{152,10},
          {152,40},{16,40},{16,0},{25.8,0}},
                                           color={255,0,255}));

  connect(samTri.y, onCouInt.trigger)
    annotation (Line(points={{-140,0},{-133.2,0}}, color={255,0,255}));

  connect(onCouInt.y, intGreThr.u)
    annotation (Line(points={{-118.8,0},{-114,0}},
                                                 color={255,127,0}));

  connect(onCouInt.y, chaPumSta.uNexLagPum) annotation (Line(points={{-118.8,0},
          {-116,0},{-116,-20},{-12,-20},{-12,-4},{25.8,-4}},
                                                       color={255,127,0}));

  connect(samTri.y, logSwi1.u1) annotation (Line(points={{-140,0},{-138,0},{-138,
          28},{-74,28}}, color={255,0,255}));

  connect(samTri.y, logSwi.u3) annotation (Line(points={{-140,0},{-138,0},{-138,
          42},{-74,42}}, color={255,0,255}));

  connect(intGreThr.y, logSwi1.u2) annotation (Line(points={{-90,0},{-86,0},{-86,
          20},{-74,20}}, color={255,0,255}));

  connect(con.y, logSwi.u1) annotation (Line(points={{-140,80},{-82,80},{-82,58},
          {-74,58}}, color={255,0,255}));

  connect(con.y, logSwi1.u3) annotation (Line(points={{-140,80},{-82,80},{-82,12},
          {-74,12}}, color={255,0,255}));

  connect(intGreThr.y, logSwi.u2) annotation (Line(points={{-90,0},{-86,0},{-86,
          50},{-74,50}}, color={255,0,255}));

  connect(logSwi1.y, not1.u)
    annotation (Line(points={{-50,20},{-44,20}}, color={255,0,255}));

  connect(not1.y, chaPumSta.uLasLagPumSta) annotation (Line(points={{-20,20},{-2,
          20},{-2,3.8},{25.8,3.8}},
                              color={255,0,255}));

  connect(logSwi.y, chaPumSta.uNexLagPumSta) annotation (Line(points={{-50,50},{
          20,50},{20,7.8},{25.8,7.8}},
                                  color={255,0,255}));

  connect(subInt.y, chaPumSta.uLasLagPum) annotation (Line(points={{-50,-40},{20,
          -40},{20,-8},{25.8,-8}},  color={255,127,0}));

  connect(con.y, onCouInt.reset) annotation (Line(points={{-140,80},{-136,80},{-136,
          -14},{-126,-14},{-126,-7.2}},
                                      color={255,0,255}));

  connect(conInt.y,subInt. u1) annotation (Line(points={{-110,-50},{-92,-50},{-92,
          -34},{-74,-34}}, color={255,127,0}));
  connect(onCouInt.y,subInt. u2) annotation (Line(points={{-118.8,0},{-116,0},{-116,
          -20},{-82,-20},{-82,-46},{-74,-46}}, color={255,127,0}));
  connect(chaPumSta.yPumStaCom, truFalHol2.u) annotation (Line(points={{52.2,-4},
          {60,-4},{60,-30},{68,-30}},
                                color={255,0,255}));
  connect(chaPumSta.yHotWatPum, truDel.u) annotation (Line(points={{52.2,4},{60,
          4},{60,10},{68,10}},         color={255,0,255}));
  connect(truDel.y, pre.u) annotation (Line(points={{92,10},{118,10}},
                                      color={255,0,255}));
annotation (
  experiment(StopTime=35.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/Plants/Boilers/Pumps/Generic/Validation/ChangeStatus.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Pumps.Generic.ChangeStatus\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Pumps.Generic.ChangeStatus</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 19, 2020, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                         graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-100},{180,100}})));
end ChangeStatus;
