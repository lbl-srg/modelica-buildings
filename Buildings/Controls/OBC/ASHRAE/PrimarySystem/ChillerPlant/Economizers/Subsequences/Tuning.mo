within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Subsequences;
block Tuning
  "Defines a tuning parameter for the temperature prediction downstream of WSE"

  parameter Real step(
    final unit="1")=0.02
      "Incremental step used to reduce or increase the water-side economizer tuning parameter";

  parameter Real wseOnTimDec(
    final unit="s",
    final quantity="Time",
    displayUnit="h")=3600
      "Economizer enable time needed to allow decrease of the tuning parameter";

  parameter Real wseOnTimInc(
    final unit="s",
    final quantity="Time",
    displayUnit="h")=1800
      "Economizer enable time needed to allow increase of the tuning parameter";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWseSta "WSE enable disable status"
    annotation (Placement(transformation(extent={{-360,100},{-320,140}}),
        iconTransformation(extent={{-140,30},{-100,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTowFanSpeMax(
    final unit="1")
    "Maximum cooling tower fan speed signal"
    annotation (Placement(transformation(
    extent={{-360,-100},{-320,-60}}), iconTransformation(extent={{-140,-70},
      {-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    final max=maxTunPar,
    final min=minTunPar,
    final start=initTunPar)
    "Tuning parameter for the waterside economizer outlet temperature prediction"
    annotation (Placement(transformation(extent={{320,50},{360,90}}),
        iconTransformation(extent={{100,-20},{140,20}})));

protected
  final parameter Integer larInt=65535 "Large integer used to reset counters";

  final parameter Real antWinGai=1 "Anti-windup gain";

  final parameter Real initTunPar = 0
  "Initial value of the tuning parameter";

  final parameter Real minTunPar(
    final unit="1") = -0.2
    "Tuning parameter minimum limit";

  final parameter Real maxTunPar(
    final unit="1") = 0.5
    "Tuning parameter maximum limit";

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant resVal(
    final k=0) "Reset value"
    annotation (Placement(transformation(extent={{120,0},{140,20}})));

  Buildings.Controls.OBC.CDL.Reals.MultiSum mulSum(
    final k={-1*step,step,1}, nin=3) "Multiple input sum"
    annotation (Placement(transformation(extent={{120,60},{140,80}})));

  Buildings.Controls.OBC.CDL.Reals.Subtract sub1 "Anti-windup adder"
    annotation (Placement(transformation(extent={{200,20},{220,40}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim(final t=wseOnTimDec) "Timer"
    annotation (Placement(transformation(extent={{-260,140},{-240,160}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg "Falling edge"
    annotation (Placement(transformation(extent={{-220,90},{-200,110}})));

  Buildings.Controls.OBC.CDL.Logical.And and2 "And"
    annotation (Placement(transformation(extent={{-140,140},{-120,160}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim1 "Timer"
    annotation (Placement(transformation(extent={{-260,40},{-240,60}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg1 "Falling edge"
    annotation (Placement(transformation(extent={{-220,-10},{-200,10}})));

  Buildings.Controls.OBC.CDL.Logical.And and1 "And"
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));

  Buildings.Controls.OBC.CDL.Reals.LessThreshold lesThr(
    final t=wseOnTimInc) "Less than"
    annotation (Placement(transformation(extent={{-220,40},{-200,60}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys(
    final uHigh=0.99,
    final uLow=0.98) "Checks if the signal is at its maximum"
    annotation (Placement(transformation(extent={{-280,-90},{-260,-70}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam2(
    final y_start=0) "Sampler"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr(
    final t=0.5) "Greater or equal than"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea "Conversion"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1 "Not"
    annotation (Placement(transformation(extent={{-260,-30},{-240,-10}})));

  Buildings.Controls.OBC.CDL.Logical.Not not2 "Not"
    annotation (Placement(transformation(extent={{-240,-150},{-220,-130}})));

  Buildings.Controls.OBC.CDL.Logical.And and5 "And"
    annotation (Placement(transformation(extent={{-200,-160},{-180,-140}})));

  Buildings.Controls.OBC.CDL.Logical.And and6 "And"
    annotation (Placement(transformation(extent={{-200,-120},{-180,-100}})));

  Buildings.Controls.OBC.CDL.Logical.Or and4 "And"
    annotation (Placement(transformation(extent={{-80,-120},{-60,-100}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat "Latch"
    annotation (Placement(transformation(extent={{-140,-140},{-120,-120}})));

  Buildings.Controls.OBC.CDL.Integers.OnCounter disCou
    "Counts the number of times the WSE got disabled"
    annotation (Placement(transformation(extent={{-100,140},{-80,160}})));

  Buildings.Controls.OBC.CDL.Integers.OnCounter disCou1
    "Counts the number of times the WSE got disabled"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    "Type converter"
    annotation (Placement(transformation(extent={{60,140},{80,160}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1
    "Type converter"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));

  Buildings.Controls.OBC.CDL.Integers.Max maxInt
    "Greater or equal a threshold"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold intGreEquThr1(
    final t=larInt) "Greater or equal a threshold"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));

  Buildings.Controls.OBC.CDL.Reals.Limiter lim(
    final uMax=maxTunPar,
    final uMin=minTunPar) "Limiter"
    annotation (Placement(transformation(extent={{160,60},{180,80}})));

  Buildings.Controls.OBC.CDL.Reals.IntegratorWithReset intWitRes(
    final k=antWinGai)
    "Integrator with reset"
    annotation (Placement(transformation(extent={{240,0},{260,20}})));

  Buildings.Controls.OBC.CDL.Logical.Pre preRes
    "Breaks algebraic loop for the counter and integrator reset"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));

  Buildings.Controls.OBC.CDL.Logical.And and3
    "Logical and"
    annotation (Placement(transformation(extent={{-108,0},{-88,20}})));

equation
  connect(uWseSta, tim.u)
    annotation (Line(points={{-340,120},{-280,120},{-280,150},{-262,150}},
          color={255,0,255}));
  connect(uWseSta, tim1.u) annotation (Line(points={{-340,120},{-280,120},{-280,
          50},{-262,50}},color={255,0,255}));
  connect(uTowFanSpeMax, hys.u)
    annotation (Line(points={{-340,-80},{-282,-80}}, color={0,0,127}));
  connect(triSam2.y, greThr.u)
    annotation (Line(points={{-38,-80},{-22,-80}}, color={0,0,127}));
  connect(booToRea.y, triSam2.u) annotation (Line(points={{-78,-80},{-62,-80}},
          color={0,0,127}));
  connect(uWseSta, falEdg.u) annotation (Line(points={{-340,120},{-280,120},{-280,
          100},{-222,100}}, color={255,0,255}));
  connect(falEdg.y, and2.u2) annotation (Line(points={{-198,100},{-150,100},{-150,
          142},{-142,142}},color={255,0,255}));
  connect(uWseSta, falEdg1.u) annotation (Line(points={{-340,120},{-280,120},{-280,
          0},{-222,0}}, color={255,0,255}));
  connect(and1.u2, falEdg1.y) annotation (Line(points={{-142,2},{-160,2},{-160,0},
          {-198,0}},    color={255,0,255}));
  connect(hys.y, booToRea.u)
    annotation (Line(points={{-258,-80},{-102,-80}},color={255,0,255}));
  connect(and4.y, triSam2.trigger) annotation (Line(points={{-58,-110},{-50,-110},
          {-50,-92}},   color={255,0,255}));
  connect(uWseSta, not1.u) annotation (Line(points={{-340,120},{-280,120},{-280,
          -20},{-262,-20}},color={255,0,255}));
  connect(hys.y, and6.u1) annotation (Line(points={{-258,-80},{-244,-80},{-244,-110},
          {-202,-110}}, color={255,0,255}));
  connect(not1.y, and6.u2) annotation (Line(points={{-238,-20},{-210,-20},{-210,
          -118},{-202,-118}},color={255,0,255}));
  connect(and4.u1, and6.y) annotation (Line(points={{-82,-110},{-178,-110}},
           color={255,0,255}));
  connect(uWseSta, and5.u2) annotation (Line(points={{-340,120},{-300,120},{-300,
          -158},{-202,-158}}, color={255,0,255}));
  connect(hys.y, not2.u) annotation (Line(points={{-258,-80},{-252,-80},{-252,-140},
          {-242,-140}}, color={255,0,255}));
  connect(and5.u1, not2.y)
    annotation (Line(points={{-202,-150},{-210,-150},{-210,-140},{-218,-140}},
          color={255,0,255}));
  connect(and5.y, lat.u) annotation (Line(points={{-178,-150},{-172,-150},{-172,
          -130},{-142,-130}}, color={255,0,255}));
  connect(lat.y, and4.u2) annotation (Line(points={{-118,-130},{-90,-130},{-90,
          -118},{-82,-118}},
                       color={255,0,255}));
  connect(not1.y, lat.clr) annotation (Line(points={{-238,-20},{-160,-20},{-160,
          -136},{-142,-136}}, color={255,0,255}));
  connect(tim1.y, lesThr.u)
    annotation (Line(points={{-238,50},{-222,50}}, color={0,0,127}));
  connect(intToRea.u, disCou.y)
    annotation (Line(points={{58,150},{-78,150}},color={255,127,0}));
  connect(and2.y, disCou.trigger)
    annotation (Line(points={{-118,150},{-102,150}}, color={255,0,255}));
  connect(disCou1.y, intToRea1.u)
    annotation (Line(points={{-58,10},{-2,10}}, color={255,127,0}));
  connect(lim.y, y)
    annotation (Line(points={{182,70},{340,70}},                 color={0,0,127}));
  connect(mulSum.y, lim.u)
    annotation (Line(points={{142,70},{158,70}}, color={0,0,127}));
  connect(lim.y, sub1.u1) annotation (Line(points={{182,70},{190,70},{190,36},{198,
          36}},  color={0,0,127}));
  connect(mulSum.y, sub1.u2) annotation (Line(points={{142,70},{152,70},{152,24},
          {198,24}}, color={0,0,127}));
  connect(sub1.y, intWitRes.u) annotation (Line(points={{222,30},{230,30},{230,10},
          {238,10}},  color={0,0,127}));
  connect(maxInt.y, intGreEquThr1.u)
    annotation (Line(points={{-18,80},{-12,80}},color={255,127,0}));
  connect(disCou.y, maxInt.u1) annotation (Line(points={{-78,150},{-50,150},{-50,
          86},{-42,86}}, color={255,127,0}));
  connect(disCou1.y, maxInt.u2) annotation (Line(points={{-58,10},{-50,10},{-50,
          74},{-42,74}}, color={255,127,0}));
  connect(intToRea.y, mulSum.u[1]) annotation (Line(points={{82,150},{100,150},
          {100,69.3333},{118,69.3333}},color={0,0,127}));
  connect(intToRea1.y, mulSum.u[2]) annotation (Line(points={{22,10},{80,10},{
          80,70},{118,70}},
                         color={0,0,127}));
  connect(intWitRes.y, mulSum.u[3]) annotation (Line(points={{262,10},{280,10},
          {280,-40},{110,-40},{110,70.6667},{118,70.6667}},color={0,0,127}));
  connect(intGreEquThr1.y, preRes.u)
    annotation (Line(points={{12,80},{18,80}}, color={255,0,255}));
  connect(preRes.y, disCou.reset) annotation (Line(points={{42,80},{50,80},{50,
          120},{-90,120},{-90,138}}, color={255,0,255}));
  connect(preRes.y, disCou1.reset) annotation (Line(points={{42,80},{50,80},{50,
          -10},{-70,-10},{-70,-2}}, color={255,0,255}));
  connect(preRes.y, intWitRes.trigger) annotation (Line(points={{42,80},{50,80},
          {50,-10},{250,-10},{250,-2}}, color={255,0,255}));
  connect(resVal.y, intWitRes.y_reset_in) annotation (Line(points={{142,10},{182,
          10},{182,2},{238,2}}, color={0,0,127}));
  connect(disCou1.trigger, and3.y)
    annotation (Line(points={{-82,10},{-86,10}}, color={255,0,255}));
  connect(and1.y, and3.u1)
    annotation (Line(points={{-118,10},{-110,10}}, color={255,0,255}));
  connect(greThr.y, and3.u2) annotation (Line(points={{2,-80},{20,-80},{20,-20},
          {-116,-20},{-116,2},{-110,2}}, color={255,0,255}));
  connect(tim.passed, and2.u1) annotation (Line(points={{-238,142},{-220,142},{
          -220,150},{-142,150}}, color={255,0,255}));
  connect(lesThr.y, and1.u1) annotation (Line(points={{-198,50},{-180,50},{-180,
          10},{-142,10}}, color={255,0,255}));
  annotation (defaultComponentName = "wseTun",
        Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          textColor={0,0,255},
          textString="%name")}),
        Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-320,-200},{320,200}})),
Documentation(info="<html>
<p>
Waterside economizer outlet temperature prediction tuning parameter subsequence 
per ASHRAE RP-1711, March 2020, section 5.2.3.3. 
</p>
<p>
The subsequence calculates the tuning parameter <code>y</code> as follows:
</p>
<ul>
<li>
Decrease <code>y</code> in <code>step</code> when the WSE is disabled if the WSE remained enabled for greater than <code>wseOnTimDec</code> time period.
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
it holds its value when the plant is disabled and tuning resumes from that value when the plant is re-enabled. 
It is limited between -0.2 and 0.5.
</p>
<p>
In order to avoid large integer values above <code>larInt</code>, the counters 
get reset to 0 each time any of them reaches that value.
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
