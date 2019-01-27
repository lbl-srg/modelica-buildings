within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizer.Subsequences;
block Tuning
  "Defines a tuning parameter for the temperature prediction downstream of WSE"

  parameter Real step=0.02
  "Tuning step";

  parameter Modelica.SIunits.Time wseOnTimDec = 60*60
  "Economizer enable time needed to allow decrease of the tuning parameter";

  parameter Modelica.SIunits.Time wseOnTimInc = 30*60
  "Economizer enable time needed to allow increase of the tuning parameter";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWseSta
    "WSE enable disable status"
    annotation (Placement(transformation(extent={{-220,60},{-180,100}}),
        iconTransformation(extent={{-140,30},{-100,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTowFanSpeMax
    "Maximum cooling tower fan speed" annotation (Placement(transformation(
          extent={{-222,-120},{-182,-80}}), iconTransformation(extent={{-140,-70},
            {-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    final max=0.5,
    final min=-0.2,
    final start=initTunPar)
    "Tuning parameter for the waterside economizer outlet temperature prediction "
    annotation (Placement(transformation(extent={{180,-10},{200,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));

protected
  final parameter Real initTunPar = 0
  "Initial value of the tuning parameter";

  Buildings.Controls.OBC.CDL.Logical.Timer tim "Timer"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg "Falling edge"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));

  Buildings.Controls.OBC.CDL.Logical.And and2 "And"
    annotation (Placement(transformation(extent={{-30,100},{-10,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Greater gre "Greater than"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant wseOnTim(
    final k=wseOnTimDec)
    "Check if econ was on for the defined time period"
    annotation (Placement(transformation(extent={{-140,70},{-120,90}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant tunStep(
    final k=step) "Tuning step"
    annotation (Placement(transformation(extent={{-30,140},{-10,160}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam(y_start=0)
    annotation (Placement(transformation(extent={{60,120},{80,140}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add2(
    final k1=-1,
    final k2=1) "Add"
    annotation (Placement(transformation(extent={{140,-10},{160,10}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre "Logical pre"
    annotation (Placement(transformation(extent={{-70,100},{-50,120}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim1 "Timer"
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg1 "Falling edge"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

  Buildings.Controls.OBC.CDL.Logical.And3 and1 "And"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Less les "Less than"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant wseOnTim1(
    final k=wseOnTimInc) "Check if econ was on for the defined time period"
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam1(
    final y_start=initTunPar) "Sampler"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1 "Pre"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uHigh=0.99,
    final uLow=0.98) "Checks if the signal is at its maximum"
    annotation (Placement(transformation(extent={{-160,-110},{-140,-90}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam2(
    final y_start=0) "Sampler"
    annotation (Placement(transformation(extent={{20,-110},{40,-90}})));

  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol(
    final samplePeriod=1) "Zero order hold"
    annotation (Placement(transformation(extent={{100,120},{120,140}})));

  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol1(
    final samplePeriod=1) "Zero order hold"
    annotation (Placement(transformation(extent={{90,-30},{110,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add1 "Tuning parameter aggregator"
    annotation (Placement(transformation(extent={{20,140},{40,160}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add3 "Tuning parameter aggregator"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
     final threshold=0.5) "Greater or equal than"
    annotation (Placement(transformation(extent={{60,-110},{80,-90}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea "Conversion"
    annotation (Placement(transformation(extent={{-20,-110},{0,-90}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1 "Not"
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));

  Buildings.Controls.OBC.CDL.Logical.Not not2 "Not"
    annotation (Placement(transformation(extent={{-120,-170},{-100,-150}})));

  Buildings.Controls.OBC.CDL.Logical.And and5 "And"
    annotation (Placement(transformation(extent={{-80,-180},{-60,-160}})));

  Buildings.Controls.OBC.CDL.Logical.And and6 "And"
    annotation (Placement(transformation(extent={{-80,-140},{-60,-120}})));

  Buildings.Controls.OBC.CDL.Logical.Or and4 "And"
    annotation (Placement(transformation(extent={{0,-140},{20,-120}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat "Latch"
    annotation (Placement(transformation(extent={{-40,-160},{-20,-140}})));

equation
  connect(uWseSta, tim.u)
    annotation (Line(points={{-200,80},{-160,80},{-160,110},{-142,110}},
                                                     color={255,0,255}));
  connect(gre.u2, wseOnTim.y) annotation (Line(points={{-102,102},{-110,102},{-110,
          80},{-119,80}}, color={0,0,127}));
  connect(tim.y, gre.u1)
    annotation (Line(points={{-119,110},{-102,110}}, color={0,0,127}));
  connect(add2.y, y)
    annotation (Line(points={{161,0},{190,0}}, color={0,0,127}));
  connect(gre.y, pre.u)
    annotation (Line(points={{-79,110},{-72,110}}, color={255,0,255}));
  connect(and2.u1, pre.y)
    annotation (Line(points={{-32,110},{-49,110}},
                                                color={255,0,255}));
  connect(uWseSta, tim1.u) annotation (Line(points={{-200,80},{-160,80},{-160,
          10},{-142,10}},
                       color={255,0,255}));
  connect(les.u2, wseOnTim1.y) annotation (Line(points={{-102,2},{-110,2},{-110,
          -20},{-119,-20}}, color={0,0,127}));
  connect(tim1.y, les.u1)
    annotation (Line(points={{-119,10},{-102,10}}, color={0,0,127}));
  connect(les.y, pre1.u)
    annotation (Line(points={{-79,10},{-62,10}}, color={255,0,255}));
  connect(and1.u1, pre1.y) annotation (Line(points={{38,-42},{-30,-42},{-30,10},
          {-39,10}},  color={255,0,255}));
  connect(uTowFanSpeMax, hys.u)
    annotation (Line(points={{-202,-100},{-162,-100}}, color={0,0,127}));
  connect(triSam.y, zerOrdHol.u)
    annotation (Line(points={{81,130},{98,130}}, color={0,0,127}));
  connect(add1.y, triSam.u) annotation (Line(points={{41,150},{50,150},{50,130},
          {58,130}}, color={0,0,127}));
  connect(zerOrdHol.y, add2.u1) annotation (Line(points={{121,130},{130,130},{130,
          6},{138,6}},     color={0,0,127}));
  connect(zerOrdHol.y, add1.u1) annotation (Line(points={{121,130},{130,130},{
          130,170},{10,170},{10,156},{18,156}}, color={0,0,127}));
  connect(tunStep.y, add1.u2) annotation (Line(points={{-9,150},{10,150},{10,
          144},{18,144}}, color={0,0,127}));
  connect(add2.u2, zerOrdHol1.y) annotation (Line(points={{138,-6},{128,-6},{128,
          -20},{111,-20}},     color={0,0,127}));
  connect(triSam1.y, zerOrdHol1.u)
    annotation (Line(points={{81,-20},{88,-20}}, color={0,0,127}));
  connect(zerOrdHol1.y, add3.u1) annotation (Line(points={{111,-20},{120,-20},{120,
          30},{10,30},{10,16},{18,16}},     color={0,0,127}));
  connect(tunStep.y, add3.u2)
    annotation (Line(points={{-9,150},{0,150},{0,4},{18,4}}, color={0,0,127}));
  connect(add3.y, triSam1.u) annotation (Line(points={{41,10},{50,10},{50,-20},{
          58,-20}},  color={0,0,127}));
  connect(triSam2.y, greThr.u)
    annotation (Line(points={{41,-100},{58,-100}},   color={0,0,127}));
  connect(booToRea.y, triSam2.u) annotation (Line(points={{1,-100},{18,-100}},
                                color={0,0,127}));
  connect(uWseSta, falEdg.u) annotation (Line(points={{-200,80},{-160,80},{-160,
          60},{-102,60}}, color={255,0,255}));
  connect(falEdg.y, and2.u2) annotation (Line(points={{-79,60},{-40,60},{-40,
          102},{-32,102}},
                     color={255,0,255}));
  connect(and2.y, triSam.trigger)
    annotation (Line(points={{-9,110},{70,110},{70,118.2}},
                                                         color={255,0,255}));
  connect(uWseSta, falEdg1.u) annotation (Line(points={{-200,80},{-160,80},{
          -160,-40},{-82,-40}}, color={255,0,255}));
  connect(and1.u2, falEdg1.y) annotation (Line(points={{38,-50},{-40,-50},{-40,-40},
          {-59,-40}},      color={255,0,255}));
  connect(hys.y, booToRea.u)
    annotation (Line(points={{-139,-100},{-22,-100}},  color={255,0,255}));
  connect(and4.y, triSam2.trigger) annotation (Line(points={{21,-130},{30,-130},
          {30,-111.8}},                              color={255,0,255}));
  connect(uWseSta, not1.u) annotation (Line(points={{-200,80},{-160,80},{-160,
          -60},{-142,-60}},   color={255,0,255}));
  connect(hys.y, and6.u1) annotation (Line(points={{-139,-100},{-124,-100},{
          -124,-130},{-82,-130}},  color={255,0,255}));
  connect(not1.y, and6.u2) annotation (Line(points={{-119,-60},{-90,-60},{-90,
          -138},{-82,-138}},       color={255,0,255}));
  connect(and4.u1, and6.y) annotation (Line(points={{-2,-130},{-59,-130}},
                  color={255,0,255}));
  connect(uWseSta, and5.u2) annotation (Line(points={{-200,80},{-170,80},{-170,
          -178},{-82,-178}}, color={255,0,255}));
  connect(hys.y, not2.u) annotation (Line(points={{-139,-100},{-132,-100},{-132,
          -160},{-122,-160}}, color={255,0,255}));
  connect(and5.u1, not2.y)
    annotation (Line(points={{-82,-170},{-90,-170},{-90,-160},{-99,-160}},
                                                      color={255,0,255}));
  connect(and5.y, lat.u) annotation (Line(points={{-59,-170},{-52,-170},{-52,
          -150},{-41,-150}}, color={255,0,255}));
  connect(not1.y, lat.u0) annotation (Line(points={{-119,-60},{-50,-60},{-50,
          -156},{-41,-156}}, color={255,0,255}));
  connect(lat.y, and4.u2) annotation (Line(points={{-19,-150},{-10,-150},{-10,
          -138},{-2,-138}},                  color={255,0,255}));
  connect(and1.y, triSam1.trigger)
    annotation (Line(points={{61,-50},{70,-50},{70,-31.8}},
                                                       color={255,0,255}));
  connect(greThr.y, and1.u3) annotation (Line(points={{81,-100},{90,-100},{90,
          -80},{20,-80},{20,-58},{38,-58}},
                                          color={255,0,255}));
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
          extent={{-180,-220},{180,180}})),
Documentation(info="<html>
<p>
Waterside economizer outlet temperature prediction tuning parameter subsequence 
per OBC Chilled Water Plant Sequence of Operation, section 3.2.3.3. The parameter
is increased or decreased in a <code>step</code> depending on how long the
the economizer remained enabled and the values of the cooling tower fan speed signal 
<code>uTowFanSpe</code> during that period.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 13, 2018, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Tuning;
