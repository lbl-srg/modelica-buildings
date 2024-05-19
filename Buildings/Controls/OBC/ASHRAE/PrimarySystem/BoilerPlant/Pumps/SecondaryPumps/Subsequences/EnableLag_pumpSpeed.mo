within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.SecondaryPumps.Subsequences;
block EnableLag_pumpSpeed
  "Sequence for enabling and disabling lag pumps for variable-speed secondary pumps with no secondary loop flowrate sensor"

  parameter Real speLim(
    final unit="1",
    displayUnit="1") = 0.9
    "Speed limit with longer enable delay for enabling next lag pump";

  parameter Real speLim1(
    final unit="1",
    displayUnit="1") = 0.99
    "Speed limit with shorter enable delay for enabling next lag pump";

  parameter Real speLim2(
    final unit="1",
    displayUnit="1") = 0.4
    "Speed limit for disabling last lag pump";

  parameter Real timPer(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 300
    "Delay time period for enabling next lag pump at speed limit speLim";

  parameter Real timPer1(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 60
    "Delay time period for enabling next lag pump at speed limit speLim1";

  parameter Real timPer2(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 600
    "Delay time period for disabling last lag pump";

  parameter Real sigDif(
    final unit="1",
    displayUnit="1") = 0.01
    "Constant value used in hysteresis for checking pump speed"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uPumSpe(
    final unit="1",
    displayUnit="1")
    "Calculated pump speed"
    annotation (Placement(transformation(extent={{-180,-20},{-140,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yUp
    "Next lag pump status"
    annotation (Placement(transformation(extent={{140,10},{180,50}}),
      iconTransformation(extent={{100,20},{140,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDown
    "Last lag pump status"
    annotation (Placement(transformation(extent={{140,-110},{180,-70}}),
      iconTransformation(extent={{100,-60},{140,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=timPer)
    "Hysteresis loop enable timer"
    annotation (Placement(transformation(extent={{-70,50},{-50,70}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim1(
    final t=timPer1)
    "Hysteresis loop enable timer"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim2(
    final t=timPer2)
    "Hysteresis loop enable timer"
    annotation (Placement(transformation(extent={{-50,-100},{-30,-80}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys(
    final uLow=speLim - sigDif,
    final uHigh=speLim)
    "Hysteresis for enabling next lag pump at speed limit speLim"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys1(
    final uLow=speLim1 - sigDif,
    final uHigh=speLim1)
    "Hysteresis for enabling next lag pump at speed limit speLim1"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys2(
    final uLow=speLim2,
    final uHigh=speLim2 + sigDif)
    "Hysteresis for disabling last lag pump"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1
    "Logical pre block"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Edge detector"
    annotation (Placement(transformation(extent={{40,90},{60,110}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical Not"
    annotation (Placement(transformation(extent={{70,90},{90,110}})));

  Buildings.Controls.OBC.CDL.Logical.And and2
    "Logical And"
    annotation (Placement(transformation(extent={{100,90},{120,110}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Logical Or"
    annotation (Placement(transformation(extent={{100,20},{120,40}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg1
    "Edge detector"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Logical Not"
    annotation (Placement(transformation(extent={{70,-50},{90,-30}})));

  Buildings.Controls.OBC.CDL.Logical.And and1
    "Logical And"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Not not3
    "Logical Not"
    annotation (Placement(transformation(extent={{-90,-100},{-70,-80}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre2
    "Logical pre block"
    annotation (Placement(transformation(extent={{10,-140},{30,-120}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg2
    "Edge detector"
    annotation (Placement(transformation(extent={{40,-140},{60,-120}})));

  Buildings.Controls.OBC.CDL.Logical.Not not4
    "Logical Not"
    annotation (Placement(transformation(extent={{70,-140},{90,-120}})));

  Buildings.Controls.OBC.CDL.Logical.And and3
    "Logical And"
    annotation (Placement(transformation(extent={{100,-140},{120,-120}})));

  Buildings.Controls.OBC.CDL.Logical.Not not5
    "Logical Not"
    annotation (Placement(transformation(extent={{70,-100},{90,-80}})));

equation
  connect(uPumSpe, hys.u) annotation (Line(points={{-160,0},{-130,0},{-130,60},{
          -122,60}},color={0,0,127}));

  connect(uPumSpe, hys1.u)
    annotation (Line(points={{-160,0},{-122,0}},color={0,0,127}));

  connect(uPumSpe, hys2.u) annotation (Line(points={{-160,0},{-130,0},{-130,-90},
          {-122,-90}},color={0,0,127}));

  connect(edg.y, not1.u)
    annotation (Line(points={{62,100},{68,100}}, color={255,0,255}));

  connect(not1.y, and2.u1)
    annotation (Line(points={{92,100},{98,100}}, color={255,0,255}));

  connect(hys.y, and2.u2) annotation (Line(points={{-98,60},{-90,60},{-90,80},{94,
          80},{94,92},{98,92}},        color={255,0,255}));

  connect(and2.y, tim.u) annotation (Line(points={{122,100},{132,100},{132,86},{
          -80,86},{-80,60},{-72,60}},     color={255,0,255}));

  connect(or2.y, yUp)
    annotation (Line(points={{122,30},{160,30}}, color={255,0,255}));

  connect(edg1.y, not2.u)
    annotation (Line(points={{62,-40},{68,-40}},
                                               color={255,0,255}));

  connect(not2.y, and1.u1)
    annotation (Line(points={{92,-40},{98,-40}},
                                               color={255,0,255}));

  connect(and1.y, tim1.u) annotation (Line(points={{122,-40},{130,-40},{130,-16},
          {-80,-16},{-80,0},{-72,0}},
                                color={255,0,255}));

  connect(hys1.y, and1.u2) annotation (Line(points={{-98,0},{-90,0},{-90,-20},{96,
          -20},{96,-48},{98,-48}}, color={255,0,255}));

  connect(hys2.y, not3.u)
    annotation (Line(points={{-98,-90},{-92,-90}}, color={255,0,255}));

  connect(not3.y, and3.u2) annotation (Line(points={{-68,-90},{-60,-90},{-60,-150},
          {94,-150},{94,-138},{98,-138}}, color={255,0,255}));

  connect(not4.y, and3.u1)
    annotation (Line(points={{92,-130},{98,-130}}, color={255,0,255}));

  connect(and3.y, tim2.u) annotation (Line(points={{122,-130},{130,-130},{130,-110},
          {-56,-110},{-56,-90},{-52,-90}}, color={255,0,255}));

  connect(pre2.y, edg2.u)
    annotation (Line(points={{32,-130},{38,-130}}, color={255,0,255}));

  connect(edg2.y, not4.u)
    annotation (Line(points={{62,-130},{68,-130}}, color={255,0,255}));

  connect(not5.y, yDown)
    annotation (Line(points={{92,-90},{160,-90}}, color={255,0,255}));

  connect(pre1.y, edg1.u)
    annotation (Line(points={{22,-40},{38,-40}}, color={255,0,255}));

  connect(pre1.y, edg.u) annotation (Line(points={{22,-40},{30,-40},{30,100},{38,
          100}}, color={255,0,255}));

  connect(tim.passed, or2.u1) annotation (Line(points={{-48,52},{90,52},{90,30},
          {98,30}}, color={255,0,255}));
  connect(tim1.passed, or2.u2) annotation (Line(points={{-48,-8},{90,-8},{90,22},
          {98,22}}, color={255,0,255}));
  connect(tim2.passed, not5.u) annotation (Line(points={{-28,-98},{50,-98},{50,
          -90},{68,-90}}, color={255,0,255}));
  connect(or2.y, pre1.u) annotation (Line(points={{122,30},{130,30},{130,-12},{
          -20,-12},{-20,-40},{-2,-40}}, color={255,0,255}));
  connect(tim2.passed, pre2.u) annotation (Line(points={{-28,-98},{0,-98},{0,
          -130},{8,-130}}, color={255,0,255}));
annotation (
defaultComponentName="enaLagSecPum",
Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}}),
    graphics={
      Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Text(
        extent={{-100,150},{100,110}},
        textColor={0,0,255},
        textString="%name")}),
Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-160},{140,160}})),
Documentation(info="<html>
<p>
Block that enables and disables lag secondary hot water pump, for plants with 
variable-speed secondary pumps and no flowrate sensor in secondary loop, according
to ASHRAE RP-1711, March, 2020 draft, section 5.3.7.4.
</p>
<ol>
<li>
Stage up <code>yUp = true</code> when speed <code>uPumSpe</code> exceeds speed limit
<code>speLim</code> for time period <code>timPer</code> or <code>speLim1</code>
for <code>timPer1</code>.
</li>
<li>
Stage down <code>yDown = false</code> when <code>uPumSpe</code> falls below <code>speLim2</code>
for <code>timPer2</code>.
</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
August 25, 2020, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end EnableLag_pumpSpeed;
