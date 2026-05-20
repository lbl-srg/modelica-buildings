within Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Economizers.Subsequences;
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

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWseSta
    "WSE enable disable status"
    annotation (Placement(transformation(extent={{-360,100},{-320,140}}),
        iconTransformation(extent={{-140,30},{-100,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTowFanSpeMax(
    final unit="1")
    "Maximum cooling tower fan speed signal"
    annotation (Placement(transformation(
    extent={{-360,-90},{-320,-50}}),  iconTransformation(extent={{-140,-70},
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
    annotation (Placement(transformation(extent={{160,0},{180,20}})));

  Buildings.Controls.OBC.CDL.Reals.MultiSum mulSum(
    final k={-1*step,step,1}, nin=3) "Multiple input sum"
    annotation (Placement(transformation(extent={{160,60},{180,80}})));

  Buildings.Controls.OBC.CDL.Reals.Subtract sub1 "Anti-windup adder"
    annotation (Placement(transformation(extent={{240,20},{260,40}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim(final t=wseOnTimDec) "Timer"
    annotation (Placement(transformation(extent={{-280,168},{-260,188}})));

  Buildings.Controls.OBC.CDL.Logical.Not not3   "Falling edge"
    annotation (Placement(transformation(extent={{-280,70},{-260,90}})));

  Buildings.Controls.OBC.CDL.Logical.And and2
    "Economizer disabled after being enabled by more than threshold time"
    annotation (Placement(transformation(extent={{-140,140},{-120,160}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim1 "Timer"
    annotation (Placement(transformation(extent={{-280,30},{-260,50}})));

  Buildings.Controls.OBC.CDL.Logical.And and1
    "Economizer disabled after being enabled by less than threshold time"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));

  Buildings.Controls.OBC.CDL.Reals.LessThreshold lesThr(
    final t=wseOnTimInc) "Less than threshold time"
    annotation (Placement(transformation(extent={{-180,30},{-160,50}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys(
    final uHigh=0.99,
    final uLow=0.98) "Checks if the signal is at its maximum"
    annotation (Placement(transformation(extent={{-280,-80},{-260,-60}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam2(
    final y_start=0) "Sampler"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr(
    final t=0.5) "Greater or equal than"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea "Conversion"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));

  Buildings.Controls.OBC.CDL.Logical.Not not2 "Not"
    annotation (Placement(transformation(extent={{-180,-180},{-160,-160}})));

  Buildings.Controls.OBC.CDL.Logical.And and5 "And"
    annotation (Placement(transformation(extent={{-120,-190},{-100,-170}})));

  Buildings.Controls.OBC.CDL.Logical.And and6 "And"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));

  Buildings.Controls.OBC.CDL.Logical.Or and4 "And"
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat "Latch"
    annotation (Placement(transformation(extent={{-60,-150},{-40,-130}})));

  Buildings.Controls.OBC.CDL.Integers.OnCounter disCou
    "Counts the number of times the WSE got disabled"
    annotation (Placement(transformation(extent={{-20,140},{0,160}})));

  Buildings.Controls.OBC.CDL.Integers.OnCounter disCou1
    "Counts the number of times the WSE got disabled"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    "Type converter"
    annotation (Placement(transformation(extent={{100,140},{120,160}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1
    "Type converter"
    annotation (Placement(transformation(extent={{100,10},{120,30}})));

  Buildings.Controls.OBC.CDL.Integers.Max maxInt
    "Greater or equal a threshold"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold intGreEquThr1(
    final t=larInt) "Greater or equal a threshold"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));

  Buildings.Controls.OBC.CDL.Reals.Limiter lim(
    final uMax=maxTunPar,
    final uMin=minTunPar) "Limiter"
    annotation (Placement(transformation(extent={{200,60},{220,80}})));

  Buildings.Controls.OBC.CDL.Reals.IntegratorWithReset intWitRes(
    final k=antWinGai)
    "Integrator with reset"
    annotation (Placement(transformation(extent={{280,0},{300,20}})));

  Buildings.Controls.OBC.CDL.Logical.Pre preRes
    "Breaks algebraic loop for the counter and integrator reset"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));

  Buildings.Controls.OBC.CDL.Logical.And and3
    "Logical and"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lonEnaTim
    "Enabled time is greater than threshold"
    annotation (Placement(transformation(extent={{-220,160},{-200,180}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam1(
    final y_start=0)
    "Total enabled time at the moment when the economizer is disabled"
    annotation (Placement(transformation(extent={{-220,30},{-200,50}})));

  Buildings.Controls.OBC.CDL.Logical.Latch shoEnaTim
    "Enabled time is less than threshold"
    annotation (Placement(transformation(extent={{-140,30},{-120,50}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg "Enabled economizer"
    annotation (Placement(transformation(extent={{-280,110},{-260,130}})));

equation
  connect(uWseSta, tim.u)
    annotation (Line(points={{-340,120},{-300,120},{-300,178},{-282,178}},
          color={255,0,255}));
  connect(uWseSta, tim1.u) annotation (Line(points={{-340,120},{-300,120},{-300,
          40},{-282,40}},color={255,0,255}));
  connect(uTowFanSpeMax, hys.u)
    annotation (Line(points={{-340,-70},{-282,-70}}, color={0,0,127}));
  connect(triSam2.y, greThr.u)
    annotation (Line(points={{42,-70},{58,-70}},   color={0,0,127}));
  connect(booToRea.y, triSam2.u) annotation (Line(points={{2,-70},{18,-70}},
          color={0,0,127}));
  connect(uWseSta, not3.u) annotation (Line(points={{-340,120},{-300,120},{-300,
          80},{-282,80}}, color={255,0,255}));
  connect(not3.y, and2.u2) annotation (Line(points={{-258,80},{-190,80},{-190,
          142},{-142,142}}, color={255,0,255}));
  connect(hys.y, booToRea.u)
    annotation (Line(points={{-258,-70},{-22,-70}}, color={255,0,255}));
  connect(and4.y, triSam2.trigger) annotation (Line(points={{22,-100},{30,-100},
          {30,-82}},    color={255,0,255}));
  connect(hys.y, and6.u1) annotation (Line(points={{-258,-70},{-220,-70},{-220,
          -100},{-62,-100}}, color={255,0,255}));
  connect(and4.u1, and6.y) annotation (Line(points={{-2,-100},{-38,-100}},
           color={255,0,255}));
  connect(uWseSta, and5.u2) annotation (Line(points={{-340,120},{-300,120},{
          -300,-188},{-122,-188}}, color={255,0,255}));
  connect(hys.y, not2.u) annotation (Line(points={{-258,-70},{-220,-70},{-220,
          -170},{-182,-170}}, color={255,0,255}));
  connect(and5.u1, not2.y)
    annotation (Line(points={{-122,-180},{-140,-180},{-140,-170},{-158,-170}},
          color={255,0,255}));
  connect(and5.y, lat.u) annotation (Line(points={{-98,-180},{-80,-180},{-80,
          -140},{-62,-140}},  color={255,0,255}));
  connect(lat.y, and4.u2) annotation (Line(points={{-38,-140},{-20,-140},{-20,
          -108},{-2,-108}},  color={255,0,255}));
  connect(intToRea.u, disCou.y)
    annotation (Line(points={{98,150},{2,150}},  color={255,127,0}));
  connect(and2.y, disCou.trigger)
    annotation (Line(points={{-118,150},{-22,150}},  color={255,0,255}));
  connect(disCou1.y, intToRea1.u)
    annotation (Line(points={{2,20},{98,20}},   color={255,127,0}));
  connect(lim.y, y)
    annotation (Line(points={{222,70},{340,70}}, color={0,0,127}));
  connect(mulSum.y, lim.u)
    annotation (Line(points={{182,70},{198,70}}, color={0,0,127}));
  connect(lim.y, sub1.u1) annotation (Line(points={{222,70},{230,70},{230,36},{
          238,36}}, color={0,0,127}));
  connect(mulSum.y, sub1.u2) annotation (Line(points={{182,70},{190,70},{190,24},
          {238,24}}, color={0,0,127}));
  connect(sub1.y, intWitRes.u) annotation (Line(points={{262,30},{270,30},{270,
          10},{278,10}}, color={0,0,127}));
  connect(maxInt.y, intGreEquThr1.u)
    annotation (Line(points={{42,80},{58,80}},  color={255,127,0}));
  connect(disCou.y, maxInt.u1) annotation (Line(points={{2,150},{10,150},{10,86},
          {18,86}},      color={255,127,0}));
  connect(disCou1.y, maxInt.u2) annotation (Line(points={{2,20},{10,20},{10,74},
          {18,74}},      color={255,127,0}));
  connect(intToRea.y, mulSum.u[1]) annotation (Line(points={{122,150},{140,150},
          {140,69.3333},{158,69.3333}},color={0,0,127}));
  connect(intToRea1.y, mulSum.u[2]) annotation (Line(points={{122,20},{140,20},
          {140,70},{158,70}}, color={0,0,127}));
  connect(intWitRes.y, mulSum.u[3]) annotation (Line(points={{302,10},{310,10},
          {310,-42},{140,-42},{140,70.6667},{158,70.6667}},color={0,0,127}));
  connect(intGreEquThr1.y, preRes.u)
    annotation (Line(points={{82,80},{98,80}}, color={255,0,255}));
  connect(preRes.y, disCou.reset) annotation (Line(points={{122,80},{130,80},{
          130,120},{-10,120},{-10,138}}, color={255,0,255}));
  connect(preRes.y, disCou1.reset) annotation (Line(points={{122,80},{130,80},{
          130,-10},{-10,-10},{-10,8}}, color={255,0,255}));
  connect(preRes.y, intWitRes.trigger) annotation (Line(points={{122,80},{130,
          80},{130,-10},{290,-10},{290,-2}}, color={255,0,255}));
  connect(resVal.y, intWitRes.y_reset_in) annotation (Line(points={{182,10},{
          220,10},{220,2},{278,2}}, color={0,0,127}));
  connect(disCou1.trigger, and3.y)
    annotation (Line(points={{-22,20},{-38,20}}, color={255,0,255}));
  connect(and1.y, and3.u1)
    annotation (Line(points={{-78,20},{-62,20}},   color={255,0,255}));
  connect(greThr.y, and3.u2) annotation (Line(points={{82,-70},{120,-70},{120,
          -40},{-70,-40},{-70,12},{-62,12}}, color={255,0,255}));
  connect(tim.passed, lonEnaTim.u)
    annotation (Line(points={{-258,170},{-222,170}}, color={255,0,255}));
  connect(lonEnaTim.y, and2.u1) annotation (Line(points={{-198,170},{-180,170},
          {-180,150},{-142,150}}, color={255,0,255}));
  connect(uWseSta, edg.u)
    annotation (Line(points={{-340,120},{-282,120}}, color={255,0,255}));
  connect(edg.y, lonEnaTim.clr) annotation (Line(points={{-258,120},{-240,120},
          {-240,164},{-222,164}}, color={255,0,255}));
  connect(tim1.y, triSam1.u)
    annotation (Line(points={{-258,40},{-222,40}}, color={0,0,127}));
  connect(triSam1.y, lesThr.u)
    annotation (Line(points={{-198,40},{-182,40}}, color={0,0,127}));
  connect(lesThr.y, shoEnaTim.u)
    annotation (Line(points={{-158,40},{-142,40}}, color={255,0,255}));
  connect(edg.y, shoEnaTim.clr) annotation (Line(points={{-258,120},{-150,120},
          {-150,34},{-142,34}}, color={255,0,255}));
  connect(not3.y, triSam1.trigger) annotation (Line(points={{-258,80},{-240,80},
          {-240,12},{-210,12},{-210,28}}, color={255,0,255}));
  connect(shoEnaTim.y, and1.u1) annotation (Line(points={{-118,40},{-110,40},{
          -110,20},{-102,20}}, color={255,0,255}));
  connect(not3.y, and1.u2) annotation (Line(points={{-258,80},{-240,80},{-240,
          12},{-102,12}}, color={255,0,255}));
  connect(not3.y, and6.u2) annotation (Line(points={{-258,80},{-240,80},{-240,
          -108},{-62,-108}}, color={255,0,255}));
  connect(not3.y, lat.clr) annotation (Line(points={{-258,80},{-240,80},{-240,
          -146},{-62,-146}}, color={255,0,255}));
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
per ASHRAE Guideline 36-2021, section 5.20.3.3. 
</p>
<p>
The subsequence calculates the tuning parameter <code>y</code> as follows:
</p>
<ul>
<li>
Decrease <code>y</code> in <code>step</code> when the WSE is disabled if the WSE remained
enabled for more than <code>wseOnTimDec</code> period.
</li>
<li>
Increase <code>y</code> in <code>step</code> when the WSE is disabled if the WSE 
remained enabled for less than <code>wseOnTimInc</code> period and 
the cooling tower fan speed signal <code>uTowFanSpeMax</code> did not decrease 
below 100% speed while the WSE was enabled.
</li>
</ul>
<p>
<code>y</code> initializes at 0 upon first plant start up,
it holds its value when the plant is disabled, and tuning resumes from that value when the
plant is re-enabled. It is limited between -0.2 and 0.5.
</p>
<p>
To avoid large integer values above <code>larInt</code>, the counters 
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
