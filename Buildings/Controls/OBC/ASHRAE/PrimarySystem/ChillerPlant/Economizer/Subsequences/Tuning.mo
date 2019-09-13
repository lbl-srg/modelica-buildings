within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizer.Subsequences;
block Tuning
  "Defines a tuning parameter for the temperature prediction downstream of WSE"

  parameter Real step=0.02
  "Tuning step";

  parameter Modelica.SIunits.Time wseOnTimDec = 3600
  "Economizer enable time needed to allow decrease of the tuning parameter";

  parameter Modelica.SIunits.Time wseOnTimInc = 1800
  "Economizer enable time needed to allow increase of the tuning parameter";

  parameter Real antWinGai=1 "Anti-windup gain";

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

//protected
  final parameter Real initTunPar = 0
  "Initial value of the tuning parameter";

  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(final k={-1,1,1},
    final nin=3) "Multiple input sum"
    annotation (Placement(transformation(extent={{160,60},{180,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add2(
    final k2=-1) "Anti-windup adder"
    annotation (Placement(transformation(extent={{240,-18},{260,2}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim "Timer"
    annotation (Placement(transformation(extent={{-218,140},{-198,160}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg "Falling edge"
    annotation (Placement(transformation(extent={{-178,90},{-158,110}})));

  Buildings.Controls.OBC.CDL.Logical.And and2 "And"
    annotation (Placement(transformation(extent={{-78,140},{-58,160}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant tunStep(
    final k=step) "Tuning step"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim1 "Timer"
    annotation (Placement(transformation(extent={{-218,40},{-198,60}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg1 "Falling edge"
    annotation (Placement(transformation(extent={{-178,-10},{-158,10}})));

  Buildings.Controls.OBC.CDL.Logical.And3 and1 "And"
    annotation (Placement(transformation(extent={{-78,0},{-58,20}})));

  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr(
    final threshold=wseOnTimInc) "Less than"
    annotation (Placement(transformation(extent={{-178,40},{-158,60}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truHol1(
    final trueHoldDuration=1,
    final falseHoldDuration=0)
    "Logical pre to capture true signal just before the WSE gets disabled"
    annotation (Placement(transformation(extent={{-138,40},{-118,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uHigh=0.99,
    final uLow=0.98) "Checks if the signal is at its maximum"
    annotation (Placement(transformation(extent={{-238,-90},{-218,-70}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam2(
    final y_start=0) "Sampler"
    annotation (Placement(transformation(extent={{-58,-90},{-38,-70}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final threshold=0.5) "Greater or equal than"
    annotation (Placement(transformation(extent={{-18,-90},{2,-70}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea "Conversion"
    annotation (Placement(transformation(extent={{-98,-90},{-78,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1 "Not"
    annotation (Placement(transformation(extent={{-218,-30},{-198,-10}})));

  Buildings.Controls.OBC.CDL.Logical.Not not2 "Not"
    annotation (Placement(transformation(extent={{-198,-150},{-178,-130}})));

  Buildings.Controls.OBC.CDL.Logical.And and5 "And"
    annotation (Placement(transformation(extent={{-158,-160},{-138,-140}})));

  Buildings.Controls.OBC.CDL.Logical.And and6 "And"
    annotation (Placement(transformation(extent={{-158,-120},{-138,-100}})));

  Buildings.Controls.OBC.CDL.Logical.Or and4 "And"
    annotation (Placement(transformation(extent={{-78,-120},{-58,-100}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat "Latch"
    annotation (Placement(transformation(extent={{-118,-140},{-98,-120}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=false)
    "False input to make sure that value does not reset during plant operation"
    annotation (Placement(transformation(extent={{-78,70},{-58,90}})));

  Buildings.Controls.OBC.CDL.Integers.OnCounter disCou
    "Counts the number of times the WSE got disabled"
    annotation (Placement(transformation(extent={{-38,140},{-18,160}})));

  Buildings.Controls.OBC.CDL.Integers.OnCounter disCou1
    "Counts the number of times the WSE got disabled"
    annotation (Placement(transformation(extent={{-28,0},{-8,20}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    "Type converter"
    annotation (Placement(transformation(extent={{60,140},{80,160}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1
    "Type converter"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Product pro "Product"
    annotation (Placement(transformation(extent={{100,100},{120,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Product pro1 "Product"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr1(
    final threshold=wseOnTimDec) "Greater than"
    annotation (Placement(transformation(extent={{-178,140},{-158,160}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truHol(
    final trueHoldDuration=1,
    final falseHoldDuration=0)
    "Holds true signal for a shor period of time to catch the falling edge"
    annotation (Placement(transformation(extent={{-138,140},{-118,160}})));

  Buildings.Controls.OBC.CDL.Continuous.Limiter lim(
    final uMax=0.5,
    final uMin=-0.2) "Limiter"
    annotation (Placement(transformation(extent={{240,30},{260,50}})));

  CDL.Continuous.IntegratorWithReset intWitRes(k=antWinGai, reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter)
    annotation (Placement(transformation(extent={{240,-80},{260,-60}})));
equation
  connect(uWseSta, tim.u)
    annotation (Line(points={{-342,120},{-238,120},{-238,150},{-220,150}},
          color={255,0,255}));
  connect(uWseSta, tim1.u) annotation (Line(points={{-342,120},{-238,120},{-238,
          50},{-220,50}},color={255,0,255}));
  connect(lesThr.y, truHol1.u)
    annotation (Line(points={{-156,50},{-140,50}},
                                                 color={255,0,255}));
  connect(and1.u1, truHol1.y) annotation (Line(points={{-80,18},{-108,18},{-108,
          50},{-116,50}},
                     color={255,0,255}));
  connect(uTowFanSpeMax, hys.u)
    annotation (Line(points={{-342,-80},{-240,-80}}, color={0,0,127}));
  connect(triSam2.y, greThr.u)
    annotation (Line(points={{-36,-80},{-20,-80}},
                                                 color={0,0,127}));
  connect(booToRea.y, triSam2.u) annotation (Line(points={{-76,-80},{-60,-80}},
          color={0,0,127}));
  connect(uWseSta, falEdg.u) annotation (Line(points={{-342,120},{-238,120},{
          -238,100},{-180,100}},
                            color={255,0,255}));
  connect(falEdg.y, and2.u2) annotation (Line(points={{-156,100},{-98,100},{-98,
          142},{-80,142}},
                      color={255,0,255}));
  connect(uWseSta, falEdg1.u) annotation (Line(points={{-342,120},{-238,120},{
          -238,0},{-180,0}},
                        color={255,0,255}));
  connect(and1.u2, falEdg1.y) annotation (Line(points={{-80,10},{-118,10},{-118,
          0},{-156,0}},
                    color={255,0,255}));
  connect(hys.y, booToRea.u)
    annotation (Line(points={{-216,-80},{-100,-80}},color={255,0,255}));
  connect(and4.y, triSam2.trigger) annotation (Line(points={{-56,-110},{-48,
          -110},{-48,-91.8}},
                      color={255,0,255}));
  connect(uWseSta, not1.u) annotation (Line(points={{-342,120},{-238,120},{-238,
          -20},{-220,-20}},color={255,0,255}));
  connect(hys.y, and6.u1) annotation (Line(points={{-216,-80},{-202,-80},{-202,
          -110},{-160,-110}},
                        color={255,0,255}));
  connect(not1.y, and6.u2) annotation (Line(points={{-196,-20},{-168,-20},{-168,
          -118},{-160,-118}},color={255,0,255}));
  connect(and4.u1, and6.y) annotation (Line(points={{-80,-110},{-136,-110}},
           color={255,0,255}));
  connect(uWseSta, and5.u2) annotation (Line(points={{-342,120},{-248,120},{
          -248,-158},{-160,-158}},
                             color={255,0,255}));
  connect(hys.y, not2.u) annotation (Line(points={{-216,-80},{-210,-80},{-210,
          -140},{-200,-140}},
                        color={255,0,255}));
  connect(and5.u1, not2.y)
    annotation (Line(points={{-160,-150},{-168,-150},{-168,-140},{-176,-140}},
          color={255,0,255}));
  connect(and5.y, lat.u) annotation (Line(points={{-136,-150},{-130,-150},{-130,
          -130},{-120,-130}},
                       color={255,0,255}));
  connect(lat.y, and4.u2) annotation (Line(points={{-96,-130},{-88,-130},{-88,
          -118},{-80,-118}},
                       color={255,0,255}));
  connect(greThr.y, and1.u3) annotation (Line(points={{4,-80},{12,-80},{12,-50},
          {-108,-50},{-108,2},{-80,2}},
                                      color={255,0,255}));
  connect(not1.y, lat.clr) annotation (Line(points={{-196,-20},{-126,-20},{-126,
          -136},{-120,-136}},
                       color={255,0,255}));
  connect(tim1.y, lesThr.u)
    annotation (Line(points={{-196,50},{-180,50}}, color={0,0,127}));
  connect(and1.y, disCou1.trigger)
    annotation (Line(points={{-56,10},{-30,10}},
                                              color={255,0,255}));
  connect(intToRea1.y, pro1.u2) annotation (Line(points={{82,10},{90,10},{90,54},
          {98,54}},   color={0,0,127}));
  connect(tunStep.y, pro1.u1) annotation (Line(points={{82,80},{90,80},{90,66},{
          98,66}},   color={0,0,127}));
  connect(intToRea.u, disCou.y)
    annotation (Line(points={{58,150},{-16,150}},color={255,127,0}));
  connect(and2.y, disCou.trigger)
    annotation (Line(points={{-56,150},{-40,150}},
                                                color={255,0,255}));
  connect(con.y, disCou.reset) annotation (Line(points={{-56,80},{-38,80},{-38,
          120},{-28,120},{-28,138}},
                              color={255,0,255}));
  connect(con.y, disCou1.reset) annotation (Line(points={{-56,80},{-38,80},{-38,
          -10},{-18,-10},{-18,-2}},
                             color={255,0,255}));
  connect(y, y) annotation (Line(points={{330,0},{330,0}},   color={0,0,127}));
  connect(disCou1.y, intToRea1.u)
    annotation (Line(points={{-6,10},{58,10}}, color={255,127,0}));
  connect(tunStep.y, pro.u2) annotation (Line(points={{82,80},{90,80},{90,104},{
          98,104}},  color={0,0,127}));
  connect(intToRea.y, pro.u1) annotation (Line(points={{82,150},{90,150},{90,116},
          {98,116}}, color={0,0,127}));
  connect(truHol.y, and2.u1)
    annotation (Line(points={{-116,150},{-80,150}},color={255,0,255}));
  connect(greThr1.y, truHol.u)
    annotation (Line(points={{-156,150},{-140,150}},
                                                   color={255,0,255}));
  connect(tim.y, greThr1.u)
    annotation (Line(points={{-196,150},{-180,150}}, color={0,0,127}));
  connect(lim.y, y)
    annotation (Line(points={{262,40},{262,0},{330,0}},
                                               color={0,0,127}));
  connect(pro.y, mulSum.u[1]) annotation (Line(points={{122,110},{130,110},{130,
          71.3333},{158,71.3333}}, color={0,0,127}));
  connect(pro1.y, mulSum.u[2]) annotation (Line(points={{122,60},{130,60},{130,
          70},{158,70}},
                     color={0,0,127}));
  connect(mulSum.y, lim.u) annotation (Line(points={{182,70},{190,70},{190,66},
          {208,66},{208,40},{238,40}},
                                    color={0,0,127}));
  connect(lim.y, add2.u1) annotation (Line(points={{262,40},{284,40},{284,20},{
          226,20},{226,-2},{238,-2}},color={0,0,127}));
  connect(mulSum.y, add2.u2) annotation (Line(points={{182,70},{192,70},{192,66},
          {200,66},{200,18},{194,18},{194,-14},{238,-14}},
                                         color={0,0,127}));
  connect(add2.y, intWitRes.u) annotation (Line(points={{262,-8},{280,-8},{280,
          -40},{220,-40},{220,-70},{238,-70}}, color={0,0,127}));
  connect(intWitRes.y, mulSum.u[3]) annotation (Line(points={{262,-70},{278,-70},
          {278,-112},{122,-112},{122,42},{146,42},{146,68.6667},{158,68.6667}},
        color={0,0,127}));
  connect(con.y, intWitRes.trigger) annotation (Line(points={{-56,80},{-38,80},
          {-38,-40},{42,-40},{42,-98},{250,-98},{250,-82}}, color={255,0,255}));
  annotation (defaultComponentName = "wseTun",
        Icon(coordinateSystem(extent={{-320,-240},{320,260}}),
             graphics={
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
          extent={{-320,-240},{320,260}})),
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
