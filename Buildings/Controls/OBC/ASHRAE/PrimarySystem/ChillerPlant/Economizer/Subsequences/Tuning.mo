within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizer.Subsequences;
block Tuning
  "Defines a tuning parameter for the temperature prediction downstream of WSE"

  parameter Real step=0.02
  "Tuning step";

  parameter Modelica.SIunits.Time wseOnTimDec = 3600
  "Economizer enable time needed to allow decrease of the tuning parameter";

  parameter Modelica.SIunits.Time wseOnTimInc = 1800
  "Economizer enable time needed to allow increase of the tuning parameter";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWseSta
    "WSE enable disable status"
    annotation (Placement(transformation(extent={{-240,100},{-200,140}}),
        iconTransformation(extent={{-140,30},{-100,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTowFanSpeMax(
    final unit="1")
    "Maximum cooling tower fan speed signal"
    annotation (Placement(transformation(
    extent={{-240,-100},{-200,-60}}), iconTransformation(extent={{-140,-70},
      {-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    final max=0.5,
    final min=-0.2,
    final start=initTunPar)
    "Tuning parameter for the waterside economizer outlet temperature prediction"
    annotation (Placement(transformation(extent={{200,-10},{220,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));

protected
  final parameter Real initTunPar = 0
  "Initial value of the tuning parameter";

  Buildings.Controls.OBC.CDL.Logical.Timer tim "Timer"
    annotation (Placement(transformation(extent={{-160,140},{-140,160}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg "Falling edge"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));

  Buildings.Controls.OBC.CDL.Logical.And and2 "And"
    annotation (Placement(transformation(extent={{-20,140},{0,160}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant tunStep(
    final k=step) "Tuning step"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add2(
    final k1=-1,
    final k2=1) "Add"
    annotation (Placement(transformation(extent={{160,50},{180,70}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim1 "Timer"
    annotation (Placement(transformation(extent={{-160,40},{-140,60}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg1 "Falling edge"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));

  Buildings.Controls.OBC.CDL.Logical.And3 and1 "And"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));

  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr(
    final threshold=wseOnTimInc) "Less than"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truHol1(
    final trueHoldDuration=1,
    final falseHoldDuration=0)
    "Logical pre to capture true signal just before the WSE gets disabled"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uHigh=0.99,
    final uLow=0.98) "Checks if the signal is at its maximum"
    annotation (Placement(transformation(extent={{-180,-90},{-160,-70}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam2(
    final y_start=0) "Sampler"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final threshold=0.5) "Greater or equal than"
    annotation (Placement(transformation(extent={{42,-90},{62,-70}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea "Conversion"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1 "Not"
    annotation (Placement(transformation(extent={{-160,-30},{-140,-10}})));

  Buildings.Controls.OBC.CDL.Logical.Not not2 "Not"
    annotation (Placement(transformation(extent={{-140,-150},{-120,-130}})));

  Buildings.Controls.OBC.CDL.Logical.And and5 "And"
    annotation (Placement(transformation(extent={{-100,-160},{-80,-140}})));

  Buildings.Controls.OBC.CDL.Logical.And and6 "And"
    annotation (Placement(transformation(extent={{-100,-120},{-80,-100}})));

  Buildings.Controls.OBC.CDL.Logical.Or and4 "And"
    annotation (Placement(transformation(extent={{-20,-120},{0,-100}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat "Latch"
    annotation (Placement(transformation(extent={{-60,-140},{-40,-120}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=false)
    "False input to make sure that value does not reset during plant operation"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));

  Buildings.Controls.OBC.CDL.Integers.OnCounter disCou
    "Counts the number of times the WSE got disabled"
    annotation (Placement(transformation(extent={{20,140},{40,160}})));

  Buildings.Controls.OBC.CDL.Integers.OnCounter disCou1
    "Counts the number of times the WSE got disabled"
    annotation (Placement(transformation(extent={{30,0},{50,20}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    "Type converter"
    annotation (Placement(transformation(extent={{60,140},{80,160}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1
    "Type converter"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Product pro "Product"
    annotation (Placement(transformation(extent={{120,100},{140,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Product pro1 "Product"
    annotation (Placement(transformation(extent={{120,20},{140,40}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr1(
    final threshold=wseOnTimDec) "Greater than"
    annotation (Placement(transformation(extent={{-120,140},{-100,160}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truHol(
    final trueHoldDuration=1,
    final falseHoldDuration=0)
    "Holds true signal for a shor period of time to catch the falling edge"
    annotation (Placement(transformation(extent={{-80,140},{-60,160}})));

  Buildings.Controls.OBC.CDL.Continuous.Limiter lim(
    final uMax=0.5,
    final uMin=-0.2) "Limiter"
    annotation (Placement(transformation(extent={{160,-10},{180,10}})));

equation
  connect(uWseSta, tim.u)
    annotation (Line(points={{-220,120},{-180,120},{-180,150},{-162,150}},
          color={255,0,255}));
  connect(uWseSta, tim1.u) annotation (Line(points={{-220,120},{-180,120},{-180,
          50},{-162,50}},color={255,0,255}));
  connect(lesThr.y, truHol1.u)
    annotation (Line(points={{-98,50},{-82,50}}, color={255,0,255}));
  connect(and1.u1, truHol1.y) annotation (Line(points={{-22,18},{-50,18},{-50,50},
          {-58,50}}, color={255,0,255}));
  connect(uTowFanSpeMax, hys.u)
    annotation (Line(points={{-220,-80},{-182,-80}}, color={0,0,127}));
  connect(triSam2.y, greThr.u)
    annotation (Line(points={{22,-80},{40,-80}}, color={0,0,127}));
  connect(booToRea.y, triSam2.u) annotation (Line(points={{-18,-80},{-2,-80}},
          color={0,0,127}));
  connect(uWseSta, falEdg.u) annotation (Line(points={{-220,120},{-180,120},{-180,
          100},{-122,100}}, color={255,0,255}));
  connect(falEdg.y, and2.u2) annotation (Line(points={{-98,100},{-40,100},{-40,142},
          {-22,142}}, color={255,0,255}));
  connect(uWseSta, falEdg1.u) annotation (Line(points={{-220,120},{-180,120},{-180,
          0},{-122,0}}, color={255,0,255}));
  connect(and1.u2, falEdg1.y) annotation (Line(points={{-22,10},{-60,10},{-60,0},
          {-98,0}}, color={255,0,255}));
  connect(hys.y, booToRea.u)
    annotation (Line(points={{-158,-80},{-42,-80}}, color={255,0,255}));
  connect(and4.y, triSam2.trigger) annotation (Line(points={{2,-110},{10,-110},{
          10,-91.8}}, color={255,0,255}));
  connect(uWseSta, not1.u) annotation (Line(points={{-220,120},{-180,120},{-180,
          -20},{-162,-20}},color={255,0,255}));
  connect(hys.y, and6.u1) annotation (Line(points={{-158,-80},{-144,-80},{-144,-110},
          {-102,-110}}, color={255,0,255}));
  connect(not1.y, and6.u2) annotation (Line(points={{-138,-20},{-110,-20},{-110,
          -118},{-102,-118}},color={255,0,255}));
  connect(and4.u1, and6.y) annotation (Line(points={{-22,-110},{-78,-110}},
           color={255,0,255}));
  connect(uWseSta, and5.u2) annotation (Line(points={{-220,120},{-190,120},{-190,
          -158},{-102,-158}},color={255,0,255}));
  connect(hys.y, not2.u) annotation (Line(points={{-158,-80},{-152,-80},{-152,-140},
          {-142,-140}}, color={255,0,255}));
  connect(and5.u1, not2.y)
    annotation (Line(points={{-102,-150},{-110,-150},{-110,-140},{-118,-140}},
          color={255,0,255}));
  connect(and5.y, lat.u) annotation (Line(points={{-78,-150},{-72,-150},{-72,-130},
          {-62,-130}}, color={255,0,255}));
  connect(lat.y, and4.u2) annotation (Line(points={{-38,-130},{-30,-130},{-30,-118},
          {-22,-118}}, color={255,0,255}));
  connect(greThr.y, and1.u3) annotation (Line(points={{64,-80},{70,-80},{70,-50},
          {-48,-50},{-48,2},{-22,2}}, color={255,0,255}));
  connect(not1.y, lat.clr) annotation (Line(points={{-138,-20},{-68,-20},{-68,-136},
          {-62,-136}}, color={255,0,255}));
  connect(tim1.y, lesThr.u)
    annotation (Line(points={{-138,50},{-122,50}}, color={0,0,127}));
  connect(pro1.y, add2.u2) annotation (Line(points={{142,30},{150,30},{150,54},{
          158,54}},  color={0,0,127}));
  connect(and1.y, disCou1.trigger)
    annotation (Line(points={{2,10},{28,10}}, color={255,0,255}));
  connect(intToRea1.y, pro1.u2) annotation (Line(points={{82,10},{90,10},{90,24},
          {118,24}},  color={0,0,127}));
  connect(tunStep.y, pro1.u1) annotation (Line(points={{82,80},{100,80},{100,36},
          {118,36}}, color={0,0,127}));
  connect(intToRea.u, disCou.y)
    annotation (Line(points={{58,150},{42,150}}, color={255,127,0}));
  connect(and2.y, disCou.trigger)
    annotation (Line(points={{2,150},{18,150}}, color={255,0,255}));
  connect(con.y, disCou.reset) annotation (Line(points={{2,80},{20,80},{20,120},
          {30,120},{30,138}}, color={255,0,255}));
  connect(con.y, disCou1.reset) annotation (Line(points={{2,80},{20,80},{20,-10},
          {40,-10},{40,-2}}, color={255,0,255}));
  connect(y, y) annotation (Line(points={{210,0},{210,0}},   color={0,0,127}));
  connect(pro.y, add2.u1) annotation (Line(points={{142,110},{150,110},{150,66},
          {158,66}}, color={0,0,127}));
  connect(disCou1.y, intToRea1.u)
    annotation (Line(points={{52,10},{58,10}}, color={255,127,0}));
  connect(tunStep.y, pro.u2) annotation (Line(points={{82,80},{100,80},{100,104},
          {118,104}},color={0,0,127}));
  connect(intToRea.y, pro.u1) annotation (Line(points={{82,150},{110,150},{110,116},
          {118,116}},color={0,0,127}));
  connect(truHol.y, and2.u1)
    annotation (Line(points={{-58,150},{-22,150}}, color={255,0,255}));
  connect(greThr1.y, truHol.u)
    annotation (Line(points={{-98,150},{-82,150}}, color={255,0,255}));
  connect(tim.y, greThr1.u)
    annotation (Line(points={{-138,150},{-122,150}}, color={0,0,127}));
  connect(lim.y, y)
    annotation (Line(points={{182,0},{210,0}}, color={0,0,127}));
  connect(add2.y, lim.u) annotation (Line(points={{182,60},{190,60},{190,20},{150,
          20},{150,0},{158,0}}, color={0,0,127}));
  annotation (defaultComponentName = "wseTun",
        Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name")}),
        Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-200,-180},{200,180}})),
Documentation(info="<html>
<p>
Waterside economizer outlet temperature prediction tuning parameter subsequence 
per ASHRAE RP-1711, July Draft, section 5.2.3.3. 
</p>
<p>
The subsequence calculates the tuning parameter <code>y</code> as follows:
</p>
<ul>
<li>
Decrease  <code>y</code> in <code>step</code> when the WSE is disabled if the WSE remained enabled for greater than <code>wseOnTimDec</code> time period.
</li>
<li>
Increase <code>y</code> in <code>step</code> when the WSE is disabled if the WSE 
remained enabled for less than <code>wseOnTimInc</code> time period and 
the cooling tower fan speed signal <code>uTowFanSpeMax</code> did not decrease 
below 100% speed while the WSE was enabled.
</li>
</ul>
<p>
<code>y</code> initializes at 0 upon first plant start up,
it does not get reinitialized at plant enable/disable and it is limited between -0.2 and 0.5.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 12, 2019, by Milica Grahovac:<br/>
Revised for performance.
</li>
<li>
October 13, 2018, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Tuning;
