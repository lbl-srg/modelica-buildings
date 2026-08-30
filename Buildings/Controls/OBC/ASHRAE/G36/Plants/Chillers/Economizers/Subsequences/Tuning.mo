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
    extent={{-360,-170},{-320,-130}}),iconTransformation(extent={{-140,-70},
      {-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    final max=maxTunPar,
    final min=minTunPar,
    final start=initTunPar)
    "Tuning parameter for the waterside economizer outlet temperature prediction"
    annotation (Placement(transformation(extent={{320,70},{360,110}}),
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
    annotation (Placement(transformation(extent={{200,-10},{220,10}})));

  Buildings.Controls.OBC.CDL.Reals.MultiSum mulSum(
    final k={-1*step,step,1}, nin=3) "Multiple input sum"
    annotation (Placement(transformation(extent={{200,80},{220,100}})));

  Buildings.Controls.OBC.CDL.Reals.Subtract sub1 "Anti-windup adder"
    annotation (Placement(transformation(extent={{280,40},{300,60}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=wseOnTimDec) "Timer"
    annotation (Placement(transformation(extent={{-280,168},{-260,188}})));

  Buildings.Controls.OBC.CDL.Logical.Not disWse "Disabled economizer"
    annotation (Placement(transformation(extent={{-280,60},{-260,80}})));

  Buildings.Controls.OBC.CDL.Logical.And and2
    "Economizer disabled after being enabled by more than threshold time"
    annotation (Placement(transformation(extent={{-140,150},{-120,170}})));

  Buildings.Controls.OBC.CDL.Logical.TimerAccumulating wseEnaTim
    "Economizer enabling time"
    annotation (Placement(transformation(extent={{-280,0},{-260,20}})));

  Buildings.Controls.OBC.CDL.Logical.And and1
    "Economizer disabled after being enabled by less than threshold time"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

  Buildings.Controls.OBC.CDL.Reals.LessThreshold lesThr(
    final t=wseOnTimInc) "Less than threshold time"
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys(
    final uHigh=0.99,
    final uLow=0.98) "Checks if the signal is at its maximum"
    annotation (Placement(transformation(extent={{-280,-160},{-260,-140}})));

  Buildings.Controls.OBC.CDL.Integers.OnCounter disCou
    "Counts the number of times the WSE got disabled"
    annotation (Placement(transformation(extent={{20,150},{40,170}})));

  Buildings.Controls.OBC.CDL.Integers.OnCounter disCou1
    "Counts the number of times the WSE got disabled"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    "Type converter"
    annotation (Placement(transformation(extent={{120,150},{140,170}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1
    "Type converter"
    annotation (Placement(transformation(extent={{120,-30},{140,-10}})));

  Buildings.Controls.OBC.CDL.Integers.Max maxInt
    "Greater or equal a threshold"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold intGreEquThr1(
    final t=larInt) "Greater or equal a threshold"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));

  Buildings.Controls.OBC.CDL.Reals.Limiter lim(
    final uMax=maxTunPar,
    final uMin=minTunPar) "Limiter"
    annotation (Placement(transformation(extent={{240,80},{260,100}})));

  Buildings.Controls.OBC.CDL.Reals.IntegratorWithReset intWitRes(
    final k=antWinGai)
    "Integrator with reset"
    annotation (Placement(transformation(extent={{280,-20},{300,0}})));

  Buildings.Controls.OBC.CDL.Logical.Pre preRes
    "Breaks algebraic loop for the counter and integrator reset"
    annotation (Placement(transformation(extent={{140,50},{160,70}})));

  Buildings.Controls.OBC.CDL.Logical.And and3
    "Logical and"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lonEnaTim
    "Enabled time is greater than threshold"
    annotation (Placement(transformation(extent={{-220,160},{-200,180}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam1(
    final y_start=0)
    "Total enabled time at the moment when the economizer is disabled"
    annotation (Placement(transformation(extent={{-200,0},{-180,20}})));

  Buildings.Controls.OBC.CDL.Logical.Latch shoEnaTim
    "Enabled time is less than threshold"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg "Enabled economizer"
    annotation (Placement(transformation(extent={{-280,110},{-260,130}})));

  Buildings.Controls.OBC.CDL.Logical.TimerAccumulating accTim1
    "Total time that the speed is not less than the threshold"
    annotation (Placement(transformation(extent={{-200,-160},{-180,-140}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam2(
    final y_start=0)
    "Total time that the speed is not less than the threshold"
    annotation (Placement(transformation(extent={{-160,-160},{-140,-140}})));

  Buildings.Controls.OBC.CDL.Reals.LessThreshold lesThr1(
    final t=5)
    "Check if it is equal time"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay delWseDis(
    final delayTime=5)
    "Delay the economizer disable signal"
    annotation (Placement(transformation(extent={{-200,-70},{-180,-50}})));

  Buildings.Controls.OBC.CDL.Reals.Subtract timDif
    "Difference of the economizer enabling time and the high tower speed time"
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));

equation
  connect(uWseSta, tim.u)
    annotation (Line(points={{-340,120},{-300,120},{-300,178},{-282,178}},
          color={255,0,255}));
  connect(uWseSta, wseEnaTim.u) annotation (Line(points={{-340,120},{-300,120},{
          -300,10},{-282,10}}, color={255,0,255}));
  connect(uTowFanSpeMax, hys.u)
    annotation (Line(points={{-340,-150},{-282,-150}}, color={0,0,127}));
  connect(uWseSta, disWse.u) annotation (Line(points={{-340,120},{-300,120},{-300,
          70},{-282,70}}, color={255,0,255}));
  connect(disWse.y, and2.u2) annotation (Line(points={{-258,70},{-220,70},{-220,
          152},{-142,152}}, color={255,0,255}));
  connect(intToRea.u, disCou.y)
    annotation (Line(points={{118,160},{42,160}},color={255,127,0}));
  connect(and2.y, disCou.trigger)
    annotation (Line(points={{-118,160},{18,160}},   color={255,0,255}));
  connect(disCou1.y, intToRea1.u)
    annotation (Line(points={{42,-20},{118,-20}}, color={255,127,0}));
  connect(lim.y, y)
    annotation (Line(points={{262,90},{340,90}}, color={0,0,127}));
  connect(mulSum.y, lim.u)
    annotation (Line(points={{222,90},{238,90}}, color={0,0,127}));
  connect(lim.y, sub1.u1) annotation (Line(points={{262,90},{270,90},{270,56},{278,
          56}}, color={0,0,127}));
  connect(mulSum.y, sub1.u2) annotation (Line(points={{222,90},{230,90},{230,44},
          {278,44}}, color={0,0,127}));
  connect(maxInt.y, intGreEquThr1.u)
    annotation (Line(points={{82,60},{98,60}},  color={255,127,0}));
  connect(disCou.y, maxInt.u1) annotation (Line(points={{42,160},{50,160},{50,66},
          {58,66}}, color={255,127,0}));
  connect(disCou1.y, maxInt.u2) annotation (Line(points={{42,-20},{50,-20},{50,54},
          {58,54}}, color={255,127,0}));
  connect(intToRea.y, mulSum.u[1]) annotation (Line(points={{142,160},{180,160},
          {180,89.3333},{198,89.3333}},color={0,0,127}));
  connect(intToRea1.y, mulSum.u[2]) annotation (Line(points={{142,-20},{180,-20},
          {180,90},{198,90}}, color={0,0,127}));
  connect(intWitRes.y, mulSum.u[3]) annotation (Line(points={{302,-10},{310,-10},
          {310,-60},{180,-60},{180,90.6667},{198,90.6667}},color={0,0,127}));
  connect(intGreEquThr1.y, preRes.u)
    annotation (Line(points={{122,60},{138,60}}, color={255,0,255}));
  connect(preRes.y, disCou.reset) annotation (Line(points={{162,60},{170,60},{170,
          120},{30,120},{30,148}}, color={255,0,255}));
  connect(preRes.y, disCou1.reset) annotation (Line(points={{162,60},{170,60},{170,
          -60},{30,-60},{30,-32}},     color={255,0,255}));
  connect(preRes.y, intWitRes.trigger) annotation (Line(points={{162,60},{170,60},
          {170,-40},{290,-40},{290,-22}},    color={255,0,255}));
  connect(resVal.y, intWitRes.y_reset_in) annotation (Line(points={{222,0},{252,
          0},{252,-18},{278,-18}},  color={0,0,127}));
  connect(disCou1.trigger, and3.y)
    annotation (Line(points={{18,-20},{2,-20}},  color={255,0,255}));
  connect(and1.y, and3.u1)
    annotation (Line(points={{-38,-20},{-22,-20}}, color={255,0,255}));
  connect(tim.passed, lonEnaTim.u)
    annotation (Line(points={{-258,170},{-222,170}}, color={255,0,255}));
  connect(lonEnaTim.y, and2.u1) annotation (Line(points={{-198,170},{-180,170},
          {-180,160},{-142,160}}, color={255,0,255}));
  connect(uWseSta, edg.u)
    annotation (Line(points={{-340,120},{-282,120}}, color={255,0,255}));
  connect(edg.y, lonEnaTim.clr) annotation (Line(points={{-258,120},{-240,120},{
          -240,164},{-222,164}},  color={255,0,255}));
  connect(wseEnaTim.y, triSam1.u)
    annotation (Line(points={{-258,10},{-202,10}}, color={0,0,127}));
  connect(triSam1.y, lesThr.u)
    annotation (Line(points={{-178,10},{-142,10}}, color={0,0,127}));
  connect(lesThr.y, shoEnaTim.u)
    annotation (Line(points={{-118,10},{-102,10}}, color={255,0,255}));
  connect(edg.y, shoEnaTim.clr) annotation (Line(points={{-258,120},{-110,120},{
          -110,4},{-102,4}},    color={255,0,255}));
  connect(disWse.y, triSam1.trigger) annotation (Line(points={{-258,70},{-220,70},
          {-220,-28},{-190,-28},{-190,-2}}, color={255,0,255}));
  connect(shoEnaTim.y, and1.u1) annotation (Line(points={{-78,10},{-70,10},{-70,
          -20},{-62,-20}},     color={255,0,255}));
  connect(disWse.y, and1.u2) annotation (Line(points={{-258,70},{-220,70},{-220,
          -28},{-62,-28}}, color={255,0,255}));
  connect(delWseDis.y, wseEnaTim.reset) annotation (Line(points={{-178,-60},{-170,
          -60},{-170,-80},{-300,-80},{-300,2},{-282,2}}, color={255,0,255}));
  connect(disWse.y, delWseDis.u) annotation (Line(points={{-258,70},{-220,70},{-220,
          -60},{-202,-60}}, color={255,0,255}));
  connect(hys.y, accTim1.u)
    annotation (Line(points={{-258,-150},{-202,-150}}, color={255,0,255}));
  connect(edg.y, accTim1.reset) annotation (Line(points={{-258,120},{-240,120},{
          -240,-158},{-202,-158}},color={255,0,255}));
  connect(accTim1.y, triSam2.u)
    annotation (Line(points={{-178,-150},{-162,-150}}, color={0,0,127}));
  connect(disWse.y, triSam2.trigger) annotation (Line(points={{-258,70},{-220,70},
          {-220,-180},{-150,-180},{-150,-162}}, color={255,0,255}));
  connect(triSam2.y, timDif.u2) annotation (Line(points={{-138,-150},{-120,-150},
          {-120,-106},{-102,-106}}, color={0,0,127}));
  connect(triSam1.y, timDif.u1) annotation (Line(points={{-178,10},{-160,10},{-160,
          -94},{-102,-94}}, color={0,0,127}));
  connect(timDif.y, lesThr1.u)
    annotation (Line(points={{-78,-100},{-62,-100}}, color={0,0,127}));
  connect(lesThr1.y, and3.u2) annotation (Line(points={{-38,-100},{-30,-100},{-30,
          -28},{-22,-28}}, color={255,0,255}));
  connect(sub1.y, intWitRes.u) annotation (Line(points={{302,50},{310,50},{310,20},
          {262,20},{262,-10},{278,-10}}, color={0,0,127}));
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
