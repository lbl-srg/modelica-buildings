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
    annotation (Placement(transformation(extent={{-362,100},{-322,140}}),
        iconTransformation(extent={{-140,30},{-100,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTowFanSpeMax(
    final unit="1")
    "Maximum cooling tower fan speed signal"
    annotation (Placement(transformation(
    extent={{-362,-100},{-322,-60}}), iconTransformation(extent={{-140,-70},
      {-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    final max=0.5,
    final min=-0.2,
    final start=initTunPar)
    "Tuning parameter for the waterside economizer outlet temperature prediction"
    annotation (Placement(transformation(extent={{320,-10},{340,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));

protected
  final parameter Real antWinGai=1 "Anti-windup gain";

  final parameter Real initTunPar = 0
  "Initial value of the tuning parameter";

  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(
    final k={-1,1,1},
    final nin=3) "Multiple input sum"
    annotation (Placement(transformation(extent={{120,60},{140,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add2(
    final k2=-1) "Anti-windup adder"
    annotation (Placement(transformation(extent={{200,20},{220,40}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim "Timer"
    annotation (Placement(transformation(extent={{-220,140},{-200,160}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg "Falling edge"
    annotation (Placement(transformation(extent={{-180,90},{-160,110}})));

  Buildings.Controls.OBC.CDL.Logical.And and2 "And"
    annotation (Placement(transformation(extent={{-80,140},{-60,160}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant tunStep(
    final k=step) "Tuning step"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim1 "Timer"
    annotation (Placement(transformation(extent={{-220,40},{-200,60}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg1 "Falling edge"
    annotation (Placement(transformation(extent={{-180,-10},{-160,10}})));

  Buildings.Controls.OBC.CDL.Logical.And3 and1 "And"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));

  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr(
    final threshold=wseOnTimInc) "Less than"
    annotation (Placement(transformation(extent={{-180,40},{-160,60}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truHol1(
    final trueHoldDuration=1,
    final falseHoldDuration=0)
    "Logical pre to capture true signal just before the WSE gets disabled"
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uHigh=0.99,
    final uLow=0.98) "Checks if the signal is at its maximum"
    annotation (Placement(transformation(extent={{-240,-90},{-220,-70}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam2(
    final y_start=0) "Sampler"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final threshold=0.5) "Greater or equal than"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea "Conversion"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1 "Not"
    annotation (Placement(transformation(extent={{-220,-30},{-200,-10}})));

  Buildings.Controls.OBC.CDL.Logical.Not not2 "Not"
    annotation (Placement(transformation(extent={{-200,-150},{-180,-130}})));

  Buildings.Controls.OBC.CDL.Logical.And and5 "And"
    annotation (Placement(transformation(extent={{-160,-160},{-140,-140}})));

  Buildings.Controls.OBC.CDL.Logical.And and6 "And"
    annotation (Placement(transformation(extent={{-160,-120},{-140,-100}})));

  Buildings.Controls.OBC.CDL.Logical.Or and4 "And"
    annotation (Placement(transformation(extent={{-80,-120},{-60,-100}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat "Latch"
    annotation (Placement(transformation(extent={{-120,-140},{-100,-120}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=false)
    "False input to make sure that value does not reset during plant operation"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

  Buildings.Controls.OBC.CDL.Integers.OnCounter disCou
    "Counts the number of times the WSE got disabled"
    annotation (Placement(transformation(extent={{-40,140},{-20,160}})));

  Buildings.Controls.OBC.CDL.Integers.OnCounter disCou1
    "Counts the number of times the WSE got disabled"
    annotation (Placement(transformation(extent={{-30,0},{-10,20}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    "Type converter"
    annotation (Placement(transformation(extent={{20,140},{40,160}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1
    "Type converter"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Product pro "Product"
    annotation (Placement(transformation(extent={{60,100},{80,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Product pro1 "Product"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr1(
    final threshold=wseOnTimDec) "Greater than"
    annotation (Placement(transformation(extent={{-180,140},{-160,160}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truHol(
    final trueHoldDuration=1,
    final falseHoldDuration=0)
    "Holds true signal for a shor period of time to catch the falling edge"
    annotation (Placement(transformation(extent={{-140,140},{-120,160}})));

  Buildings.Controls.OBC.CDL.Continuous.Limiter lim(
    final uMax=0.5,
    final uMin=-0.2) "Limiter"
    annotation (Placement(transformation(extent={{160,60},{180,80}})));

  Buildings.Controls.OBC.CDL.Continuous.IntegratorWithReset intWitRes(
    final k=antWinGai,
    final reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter)
    annotation (Placement(transformation(extent={{240,-20},{260,0}})));

equation
  connect(uWseSta, tim.u)
    annotation (Line(points={{-342,120},{-240,120},{-240,150},{-222,150}},
          color={255,0,255}));
  connect(uWseSta, tim1.u) annotation (Line(points={{-342,120},{-240,120},{-240,
          50},{-222,50}},color={255,0,255}));
  connect(lesThr.y, truHol1.u)
    annotation (Line(points={{-158,50},{-142,50}}, color={255,0,255}));
  connect(and1.u1, truHol1.y) annotation (Line(points={{-82,18},{-100,18},{-100,
          50},{-118,50}}, color={255,0,255}));
  connect(uTowFanSpeMax, hys.u)
    annotation (Line(points={{-342,-80},{-242,-80}}, color={0,0,127}));
  connect(triSam2.y, greThr.u)
    annotation (Line(points={{-38,-80},{-22,-80}}, color={0,0,127}));
  connect(booToRea.y, triSam2.u) annotation (Line(points={{-78,-80},{-62,-80}},
          color={0,0,127}));
  connect(uWseSta, falEdg.u) annotation (Line(points={{-342,120},{-240,120},{-240,
          100},{-182,100}}, color={255,0,255}));
  connect(falEdg.y, and2.u2) annotation (Line(points={{-158,100},{-100,100},{-100,
          142},{-82,142}}, color={255,0,255}));
  connect(uWseSta, falEdg1.u) annotation (Line(points={{-342,120},{-240,120},{-240,
          0},{-182,0}}, color={255,0,255}));
  connect(and1.u2, falEdg1.y) annotation (Line(points={{-82,10},{-120,10},{-120,
          0},{-158,0}}, color={255,0,255}));
  connect(hys.y, booToRea.u)
    annotation (Line(points={{-218,-80},{-102,-80}},color={255,0,255}));
  connect(and4.y, triSam2.trigger) annotation (Line(points={{-58,-110},{-50,-110},
          {-50,-91.8}}, color={255,0,255}));
  connect(uWseSta, not1.u) annotation (Line(points={{-342,120},{-240,120},{-240,
          -20},{-222,-20}},color={255,0,255}));
  connect(hys.y, and6.u1) annotation (Line(points={{-218,-80},{-204,-80},{-204,-110},
          {-162,-110}}, color={255,0,255}));
  connect(not1.y, and6.u2) annotation (Line(points={{-198,-20},{-170,-20},{-170,
          -118},{-162,-118}},color={255,0,255}));
  connect(and4.u1, and6.y) annotation (Line(points={{-82,-110},{-138,-110}},
           color={255,0,255}));
  connect(uWseSta, and5.u2) annotation (Line(points={{-342,120},{-260,120},{-260,
          -158},{-162,-158}}, color={255,0,255}));
  connect(hys.y, not2.u) annotation (Line(points={{-218,-80},{-212,-80},{-212,-140},
          {-202,-140}}, color={255,0,255}));
  connect(and5.u1, not2.y)
    annotation (Line(points={{-162,-150},{-170,-150},{-170,-140},{-178,-140}},
          color={255,0,255}));
  connect(and5.y, lat.u) annotation (Line(points={{-138,-150},{-132,-150},{-132,
          -130},{-122,-130}}, color={255,0,255}));
  connect(lat.y, and4.u2) annotation (Line(points={{-98,-130},{-90,-130},{-90,-118},
          {-82,-118}}, color={255,0,255}));
  connect(greThr.y, and1.u3) annotation (Line(points={{2,-80},{10,-80},{10,-50},
          {-100,-50},{-100,2},{-82,2}}, color={255,0,255}));
  connect(not1.y, lat.clr) annotation (Line(points={{-198,-20},{-128,-20},{-128,
          -136},{-122,-136}}, color={255,0,255}));
  connect(tim1.y, lesThr.u)
    annotation (Line(points={{-198,50},{-182,50}}, color={0,0,127}));
  connect(and1.y, disCou1.trigger)
    annotation (Line(points={{-58,10},{-32,10}}, color={255,0,255}));
  connect(intToRea1.y, pro1.u2) annotation (Line(points={{42,10},{50,10},{50,54},
          {58,54}}, color={0,0,127}));
  connect(tunStep.y, pro1.u1) annotation (Line(points={{42,80},{50,80},{50,66},{
          58,66}}, color={0,0,127}));
  connect(intToRea.u, disCou.y)
    annotation (Line(points={{18,150},{-18,150}},color={255,127,0}));
  connect(and2.y, disCou.trigger)
    annotation (Line(points={{-58,150},{-42,150}}, color={255,0,255}));
  connect(con.y, disCou.reset) annotation (Line(points={{-58,80},{-40,80},{-40,120},
          {-30,120},{-30,138}}, color={255,0,255}));
  connect(con.y, disCou1.reset) annotation (Line(points={{-58,80},{-40,80},{-40,
          -10},{-20,-10},{-20,-2}}, color={255,0,255}));
  connect(y, y) annotation (Line(points={{330,0},{330,0}},  color={0,0,127}));
  connect(disCou1.y, intToRea1.u)
    annotation (Line(points={{-8,10},{18,10}}, color={255,127,0}));
  connect(tunStep.y, pro.u2) annotation (Line(points={{42,80},{50,80},{50,104},{
          58,104}},  color={0,0,127}));
  connect(intToRea.y, pro.u1) annotation (Line(points={{42,150},{50,150},{50,116},
          {58,116}}, color={0,0,127}));
  connect(truHol.y, and2.u1)
    annotation (Line(points={{-118,150},{-82,150}},color={255,0,255}));
  connect(greThr1.y, truHol.u)
    annotation (Line(points={{-158,150},{-142,150}}, color={255,0,255}));
  connect(tim.y, greThr1.u)
    annotation (Line(points={{-198,150},{-182,150}}, color={0,0,127}));
  connect(lim.y, y)
    annotation (Line(points={{182,70},{300,70},{300,0},{330,0}}, color={0,0,127}));
  connect(pro.y, mulSum.u[1]) annotation (Line(points={{82,110},{90,110},{90,
          71.3333},{118,71.3333}},
                          color={0,0,127}));
  connect(pro1.y, mulSum.u[2]) annotation (Line(points={{82,60},{90,60},{90,70},
          {118,70}},     color={0,0,127}));
  connect(mulSum.y, lim.u)
    annotation (Line(points={{142,70},{158,70}}, color={0,0,127}));
  connect(lim.y, add2.u1) annotation (Line(points={{182,70},{190,70},{190,36},{198,
          36}},  color={0,0,127}));
  connect(mulSum.y, add2.u2) annotation (Line(points={{142,70},{152,70},{152,24},
          {198,24}}, color={0,0,127}));
  connect(add2.y, intWitRes.u) annotation (Line(points={{222,30},{230,30},{230,-10},
          {238,-10}}, color={0,0,127}));
  connect(intWitRes.y, mulSum.u[3]) annotation (Line(points={{262,-10},{280,-10},
          {280,-50},{100,-50},{100,68.6667},{118,68.6667}},
        color={0,0,127}));
  connect(con.y, intWitRes.trigger) annotation (Line(points={{-58,80},{-40,80},{
          -40,-40},{250,-40},{250,-22}}, color={255,0,255}));
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
          extent={{-320,-200},{320,200}})),
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
