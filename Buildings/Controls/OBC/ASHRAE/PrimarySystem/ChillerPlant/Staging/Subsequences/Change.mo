within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block Change "Calculates the chiller stage signal"

  parameter Modelica.SIunits.Time delayStaCha = 900
    "Hold period for each stage change";

  CDL.Interfaces.BooleanInput uUp "Stage up status" annotation (Placement(
        transformation(extent={{-340,-60},{-300,-20}}), iconTransformation(
          extent={{-140,-40},{-100,0}})));
  CDL.Interfaces.BooleanInput uDow "Stage down signal" annotation (Placement(
        transformation(extent={{-342,-160},{-302,-120}}), iconTransformation(
          extent={{-140,-80},{-100,-40}})));
  CDL.Logical.Or                        or2 "Logical or"
    annotation (Placement(transformation(extent={{-152,-100},{-132,-80}})));
  CDL.Logical.Edge                          edg1
                                                "Boolean signal change"
    annotation (Placement(transformation(extent={{-62,-100},{-42,-80}})));
  CDL.Discrete.TriggeredSampler                        triSam
    annotation (Placement(transformation(extent={{-22,50},{-2,70}})));
  CDL.Logical.Switch                        switch1
    annotation (Placement(transformation(extent={{-102,50},{-82,70}})));
  CDL.Conversions.IntegerToReal                        intToRea
    annotation (Placement(transformation(extent={{-160,10},{-140,30}})));
  CDL.Conversions.RealToInteger                        reaToInt
    annotation (Placement(transformation(extent={{160,150},{180,170}})));
  CDL.Conversions.IntegerToReal                        intToRea1
    annotation (Placement(transformation(extent={{-160,90},{-140,110}})));
  CDL.Logical.Latch                        lat(pre_y_start=true)
    annotation (Placement(transformation(extent={{-160,50},{-140,70}})));
  CDL.Conversions.IntegerToReal                        intToRea2 "Integer to real conversion"
    annotation (Placement(transformation(extent={{-42,190},{-22,210}})));
  CDL.Logical.TrueFalseHold                        holIniSta(final
      trueHoldDuration=delayStaCha, final falseHoldDuration=0)
    "Holds stage switched to initial upon plant start"
    annotation (Placement(transformation(extent={{-160,150},{-140,170}})));
  CDL.Logical.Switch                        switch2
    annotation (Placement(transformation(extent={{42,190},{62,210}})));
  CDL.Logical.TrueFalseHold                        staChaHol(final
      trueHoldDuration=0, final falseHoldDuration=delayStaCha)
    "Main stage change hold"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  CDL.Logical.Or or1
    annotation (Placement(transformation(extent={{-14,-58},{6,-38}})));
  CDL.Logical.Edge                          edg2
                                                "Boolean signal change"
    annotation (Placement(transformation(extent={{-28,-190},{-8,-170}})));
  CDL.Logical.And and2
    "Ensures the stage is changed at high load increases/decreases where a stage up or a stage down signal is uninterrupted after a single stage change as an another one is needed right away"
    annotation (Placement(transformation(extent={{10,-200},{30,-180}})));
  CDL.Logical.Timer tim(accumulate=false)
    annotation (Placement(transformation(extent={{-60,-230},{-40,-210}})));
  CDL.Logical.And and1
    "Ensures the stage is changed at high load increases/decreases where a stage up or a stage down signal is uninterrupted after a single stage change as an another one is needed right away"
    annotation (Placement(transformation(extent={{-102,-202},{-82,-182}})));
  CDL.Logical.Pre pre
    annotation (Placement(transformation(extent={{58,-242},{78,-222}})));
  CDL.Continuous.LessEqualThreshold lesEquThr(threshold=delayStaCha)
    annotation (Placement(transformation(extent={{10,-240},{30,-220}})));
  CDL.Discrete.TriggeredSampler                        triSam1
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  CDL.Logical.Sources.Constant con(k=true)
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  CDL.Conversions.BooleanToReal booToRea
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  CDL.Continuous.GreaterThreshold greThr1(threshold=0.5)
    annotation (Placement(transformation(extent={{100,0},{120,20}})));
  CDL.Logical.Latch lat1
    "Ensures initial stage is held until the first stage change signal after the initial stage phase is over"
    annotation (Placement(transformation(extent={{-28,150},{-8,170}})));
  CDL.Logical.And and3
    annotation (Placement(transformation(extent={{100,90},{120,110}})));
  CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{38,100},{58,120}})));
  CDL.Logical.And and4
    annotation (Placement(transformation(extent={{38,-62},{58,-42}})));
  CDL.Logical.Not not2
    annotation (Placement(transformation(extent={{160,10},{180,30}})));
  CDL.Logical.And and5
    annotation (Placement(transformation(extent={{218,-10},{238,10}})));
  CDL.Logical.TrueFalseHold                        staChaHol1(final
      trueHoldDuration=delayStaCha, final falseHoldDuration=0)
    "Main stage change hold"
    annotation (Placement(transformation(extent={{-60,-190},{-40,-170}})));
  CDL.Interfaces.IntegerOutput                        ySta(final max=fill(nSta,
        nSta))
    "Chiller stage integer setpoint"
    annotation (Placement(
        transformation(extent={{300,140},{340,180}}),  iconTransformation(
          extent={{100,20},{140,60}})));
  CDL.Interfaces.IntegerInput                        uIni(final min=0, final
      max=nSta) "Initial chiller stage (at plant enable)"
                                              annotation (Placement(
        transformation(extent={{-100,180},{-60,220}}),   iconTransformation(
          extent={{-140,80},{-100,120}})));
  CDL.Interfaces.BooleanOutput y "Chiller stage change edge signal" annotation (
     Placement(transformation(extent={{300,-18},{340,22}}),
        iconTransformation(extent={{100,-60},{140,-20}})));
  CDL.Interfaces.BooleanInput                        uPla "Plant enable signal"
                          annotation (Placement(
        transformation(extent={{-340,140},{-300,180}}),   iconTransformation(
          extent={{-140,-120},{-100,-80}})));
  CDL.Logical.Edge                        edg
    "Detects plant start"
    annotation (Placement(transformation(extent={{-220,150},{-200,170}})));
  CDL.Interfaces.IntegerInput uAvaUp(final min=0, final max=nSta)
    "Next available stage up" annotation (Placement(transformation(extent={{-340,
            80},{-300,120}}), iconTransformation(extent={{-140,40},{-100,80}})));
  CDL.Interfaces.IntegerInput uAvaDow(final min=0, final max=nSta)
    "Next available stage down" annotation (Placement(transformation(extent={{-340,
            0},{-300,40}}), iconTransformation(extent={{-140,0},{-100,40}})));
equation
  connect(reaToInt.y,ySta)
    annotation (Line(points={{182,160},{320,160}}, color={255,127,0}));
  connect(switch1.y,triSam. u)
    annotation (Line(points={{-80,60},{-24,60}},   color={0,0,127}));
  connect(intToRea1.y,switch1. u1) annotation (Line(points={{-138,100},{-122,100},
          {-122,68},{-104,68}}, color={0,0,127}));
  connect(intToRea.y,switch1. u3) annotation (Line(points={{-138,20},{-122,20},{
          -122,52},{-104,52}},  color={0,0,127}));
  connect(lat.y,switch1. u2)
    annotation (Line(points={{-138,60},{-104,60}}, color={255,0,255}));
  connect(edg.y,holIniSta. u)
    annotation (Line(points={{-198,160},{-162,160}},
                                                  color={255,0,255}));
  connect(triSam.y,switch2. u3) annotation (Line(points={{0,60},{8,60},{8,192},{
          40,192}},            color={0,0,127}));
  connect(uIni,intToRea2. u) annotation (Line(points={{-80,200},{-44,200}},
                         color={255,127,0}));
  connect(intToRea2.y,switch2. u1) annotation (Line(points={{-20,200},{8,200},{8,
          208},{40,208}},  color={0,0,127}));
  connect(or2.y,staChaHol. u)
    annotation (Line(points={{-130,-90},{-102,-90}}, color={255,0,255}));
  connect(staChaHol.y,edg1. u)
    annotation (Line(points={{-78,-90},{-64,-90}},   color={255,0,255}));
  connect(edg1.y,or1. u1) annotation (Line(points={{-40,-90},{-28,-90},{-28,-48},
          {-16,-48}},        color={255,0,255}));
  connect(edg2.y,and2. u1) annotation (Line(points={{-6,-180},{4,-180},{4,-190},
          {8,-190}},         color={255,0,255}));
  connect(and2.y,or1. u2) annotation (Line(points={{32,-190},{46,-190},{46,-72},
          {-24,-72},{-24,-56},{-16,-56}},
                                        color={255,0,255}));
  connect(or1.y,triSam. trigger) annotation (Line(points={{8,-48},{14,-48},{14,40},
          {-12,40},{-12,48.2}},             color={255,0,255}));
  connect(or2.y,and2. u2) annotation (Line(points={{-130,-90},{-122,-90},{-122,-238},
          {-20,-238},{-20,-208},{8,-208},{8,-198}},color={255,0,255}));
  connect(or2.y,and1. u1) annotation (Line(points={{-130,-90},{-118,-90},{-118,-192},
          {-104,-192}},      color={255,0,255}));
  connect(tim.y,lesEquThr. u) annotation (Line(points={{-38,-220},{-14,-220},{-14,
          -230},{8,-230}},       color={0,0,127}));
  connect(lesEquThr.y,pre. u) annotation (Line(points={{32,-230},{56,-230},{56,-232}},
                      color={255,0,255}));
  connect(pre.y,and1. u2) annotation (Line(points={{80,-232},{80,-258},{-114,-258},
          {-114,-200},{-104,-200}},     color={255,0,255}));
  connect(and1.y,tim. u) annotation (Line(points={{-80,-192},{-72,-192},{-72,-220},
          {-62,-220}},       color={255,0,255}));
  connect(triSam1.u,booToRea. y)
    annotation (Line(points={{58,10},{2,10}},      color={0,0,127}));
  connect(con.y,booToRea. u)
    annotation (Line(points={{-38,10},{-22,10}},  color={255,0,255}));
  connect(triSam1.y,greThr1. u)
    annotation (Line(points={{82,10},{98,10}},     color={0,0,127}));
  connect(lat1.y,switch2. u2)
    annotation (Line(points={{-6,160},{30,160},{30,200},{40,200}},
                                                 color={255,0,255}));
  connect(edg.y,lat1. u) annotation (Line(points={{-198,160},{-182,160},{-182,182},
          {-102,182},{-102,160},{-30,160}},
                                 color={255,0,255}));
  connect(switch2.y,reaToInt. u)
    annotation (Line(points={{64,200},{110,200},{110,160},{158,160}},
                                                 color={0,0,127}));
  connect(greThr1.y,and3. u2) annotation (Line(points={{122,10},{134,10},{134,74},
          {80,74},{80,92},{98,92}},          color={255,0,255}));
  connect(holIniSta.y,not1. u) annotation (Line(points={{-138,160},{-122,160},{-122,
          120},{-22,120},{-22,110},{36,110}},
                                       color={255,0,255}));
  connect(not1.y,and3. u1) annotation (Line(points={{60,110},{82,110},{82,100},{
          98,100}},
               color={255,0,255}));
  connect(and3.y,lat1. clr) annotation (Line(points={{122,100},{130,100},{130,140},
          {-40,140},{-40,154},{-30,154}},
                                      color={255,0,255}));
  connect(and4.y,triSam1. trigger) annotation (Line(points={{60,-52},{70,-52},{70,
          -1.8}},        color={255,0,255}));
  connect(edg1.y,and4. u2) annotation (Line(points={{-40,-90},{26,-90},{26,-60},
          {36,-60}},   color={255,0,255}));
  connect(not1.y,and4. u1) annotation (Line(points={{60,110},{68,110},{68,40},{20,
          40},{20,-52},{36,-52}},           color={255,0,255}));
  connect(lat1.y,not2. u) annotation (Line(points={{-6,160},{18,160},{18,150},{140,
          150},{140,20},{158,20}},      color={255,0,255}));
  connect(y,and5. y) annotation (Line(points={{320,2},{306,2},{306,0},{240,0}},
                 color={255,0,255}));
  connect(not2.y,and5. u1) annotation (Line(points={{182,20},{200,20},{200,0},{216,
          0}},        color={255,0,255}));
  connect(or1.y,and5. u2) annotation (Line(points={{8,-48},{24,-48},{24,-126},{200,
          -126},{200,-8},{216,-8}},          color={255,0,255}));
  connect(and1.y,staChaHol1. u) annotation (Line(points={{-80,-192},{-72,-192},{
          -72,-180},{-62,-180}},
                               color={255,0,255}));
  connect(staChaHol1.y,edg2. u)
    annotation (Line(points={{-38,-180},{-30,-180}}, color={255,0,255}));
  connect(edg.u, uPla)
    annotation (Line(points={{-222,160},{-320,160}}, color={255,0,255}));
  connect(uUp, lat.u) annotation (Line(points={{-320,-40},{-268,-40},{-268,60},{
          -162,60}}, color={255,0,255}));
  connect(uDow, lat.clr) annotation (Line(points={{-322,-140},{-258,-140},{-258,
          54},{-162,54}}, color={255,0,255}));
  connect(uUp, or2.u1) annotation (Line(points={{-320,-40},{-200,-40},{-200,-90},
          {-154,-90}}, color={255,0,255}));
  connect(uDow, or2.u2) annotation (Line(points={{-322,-140},{-204,-140},{-204,-98},
          {-154,-98}}, color={255,0,255}));
  connect(uAvaUp, intToRea1.u)
    annotation (Line(points={{-320,100},{-162,100}}, color={255,127,0}));
  connect(uAvaDow, intToRea.u)
    annotation (Line(points={{-320,20},{-162,20}}, color={255,127,0}));
  annotation (defaultComponentName = "cha",
        Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-112,150},{108,112}},
          lineColor={0,0,255},
          textString="%name")}), Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-300,-300},{300,300}})),
Documentation(info="<html>
<p>
Outputs the chiller stage change signal

fixme

</p>
</html>",
revisions="<html>
<ul>
<li>
April 14, 2020, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Change;
