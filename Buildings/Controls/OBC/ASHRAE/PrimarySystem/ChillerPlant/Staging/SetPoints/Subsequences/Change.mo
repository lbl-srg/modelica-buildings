within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences;
block Change "Calculates the chiller stage signal"

  parameter Integer nSta = 3
    "Number of chiller stages, does not include zero stage";

  parameter Real delayStaCha(
    final unit="s",
    final quantity="Time",
    displayUnit="h")=900
      "Hold period for each stage change";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPla
    "Plant enable signal"
    annotation (Placement(transformation(extent={{-480,150},{-440,190}}),
        iconTransformation(extent={{-140,-120},{-100,-80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uUp
    "Stage up status"
    annotation (Placement(transformation(extent={{-480,-60},{-440,-20}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDow
    "Stage down signal"
    annotation (Placement(transformation(extent={{-480,-160},{-440,-120}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uIni(
    final min=0,
    final max=nSta)
    "Initial chiller stage (at plant enable)"
    annotation (Placement(transformation(extent={{-480,220},{-440,260}}),
        iconTransformation(extent={{-140,80},{-100,120}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uAvaUp(
    final min=0,
    final max=nSta)
    "Next available stage up"
    annotation (Placement(transformation(extent={{-480,90},{-440,130}}),
        iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uAvaDow(
    final min=0,
    final max=nSta)
    "Next available stage down"
    annotation (Placement(transformation(extent={{-480,10},{-440,50}}),
        iconTransformation(extent={{-140,0},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChaEdg
    "Chiller stage change edge signal"
    annotation (Placement(transformation(extent={{440,-102},{480,-62}}),
        iconTransformation(extent={{100,-60},{140,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChaUpEdg
    "Chiller stage up change edge signal"
    annotation (Placement(transformation(extent={{440,-62},{480,-22}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChaDowEdg
    "Chiller stage down change edge signal"
    annotation (Placement(transformation(extent={{440,-142},{480,-102}}),
        iconTransformation(extent={{100,-100},{140,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput ySta(
    final min=0,
    final max = nSta)
    "Chiller stage integer setpoint"
    annotation (Placement(transformation(extent={{440,150},{480,190}}),
        iconTransformation(extent={{100,20},{140,60}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Or or2 "Logical or"
    annotation (Placement(transformation(extent={{-380,-90},{-360,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg1
     "Boolean signal change"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam "Triggered sampler"
    annotation (Placement(transformation(extent={{110,60},{130,80}})));

  Buildings.Controls.OBC.CDL.Reals.Switch switch1 "Switch"
    annotation (Placement(transformation(extent={{-240,60},{-220,80}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea "Type converter"
    annotation (Placement(transformation(extent={{-320,20},{-300,40}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt "Type converter"
    annotation (Placement(transformation(extent={{200,190},{220,210}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1 "Type converter"
    annotation (Placement(transformation(extent={{-320,100},{-300,120}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea2
    "Integer to real conversion"
    annotation (Placement(transformation(extent={{-40,230},{-20,250}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold holIniSta(
    final trueHoldDuration=delayStaCha,
    final falseHoldDuration=0)
    "Holds stage switched to initial upon plant start"
    annotation (Placement(transformation(extent={{-320,160},{-300,180}})));

  Buildings.Controls.OBC.CDL.Reals.Switch switch2 "Switch"
    annotation (Placement(transformation(extent={{160,190},{180,210}})));

  Buildings.Controls.OBC.CDL.Logical.Or or1 "Logical or"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg2
    "Boolean signal change"
    annotation (Placement(transformation(extent={{-40,-180},{-20,-160}})));

  Buildings.Controls.OBC.CDL.Logical.And and2
    "Ensures the stage is changed at high load increases/decreases where a stage up or a stage down signal is uninterrupted after a single stage change as an another one is needed right away"
    annotation (Placement(transformation(extent={{0,-140},{20,-120}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim "Timer"
    annotation (Placement(transformation(extent={{-80,-240},{-60,-220}})));

  Buildings.Controls.OBC.CDL.Logical.And and1 "Logical andEnsures the stage is changed at high load increases/decreases where a stage up or a stage down signal is uninterrupted after a single stage change as an another one is needed right away"
    annotation (Placement(transformation(extent={{-140,-200},{-120,-180}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre "Previous value"
    annotation (Placement(transformation(extent={{0,-240},{20,-220}})));

  Buildings.Controls.OBC.CDL.Reals.LessThreshold lesEquThr(
    final t=delayStaCha) "Less equal threshold"
    annotation (Placement(transformation(extent={{-40,-240},{-20,-220}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam1
    "Triggered sampler"
    annotation (Placement(transformation(extent={{180,0},{200,20}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea "Type conveter"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr1(
    final t=0.5) "Greater than a threshold"
    annotation (Placement(transformation(extent={{-20,80},{0,100}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat1
    "Ensures initial stage is held until the first stage change signal after the initial stage phase is over"
    annotation (Placement(transformation(extent={{100,190},{120,210}})));

  Buildings.Controls.OBC.CDL.Logical.And and3 "And"
    annotation (Placement(transformation(extent={{40,110},{60,130}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold staChaHol1(
    final trueHoldDuration=delayStaCha,
    final falseHoldDuration=0)
    "Ensures stage change delay is kept at long stage up or down signals that cause multiple consecutive stage changes "
    annotation (Placement(transformation(extent={{-80,-180},{-60,-160}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Detects plant start"
    annotation (Placement(transformation(extent={{-380,160},{-360,180}})));

  Buildings.Controls.OBC.CDL.Logical.Not not3 "Logical not"
    annotation (Placement(transformation(extent={{-260,-70},{-240,-50}})));

  Buildings.Controls.OBC.CDL.Logical.And and6 "Logical and"
    annotation (Placement(transformation(extent={{-180,-90},{-160,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Or or3 "Logical or"
    annotation (Placement(transformation(extent={{160,-60},{180,-40}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    "Detects plant start"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold staChaHol2(
    final trueHoldDuration=0,
    final falseHoldDuration=delayStaCha)
    "Stage change hold"
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold staChaHol3(
    final trueHoldDuration=delayStaCha,
    final falseHoldDuration=0)
    "Stage change hold"
    annotation (Placement(transformation(extent={{340,-260},{360,-240}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{372,-260},{392,-240}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1 "Previous value"
    annotation (Placement(transformation(extent={{400,-260},{420,-240}})));

  Buildings.Controls.OBC.CDL.Integers.Change cha
    "Check if there is stage change"
    annotation (Placement(transformation(extent={{300,90},{320,110}})));

  Buildings.Controls.OBC.CDL.Logical.And and4
    "Consider staging up only if stage down signal is not on"
    annotation (Placement(transformation(extent={{-320,60},{-300,80}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-380,40},{-360,60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{180,-170},{200,-150}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu
    "Check if the stage setpoint is zero"
    annotation (Placement(transformation(extent={{240,-170},{260,-150}})));
  Buildings.Controls.OBC.CDL.Logical.And and5 "Logical and"
    annotation (Placement(transformation(extent={{280,-140},{300,-120}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi1 "Logical switch"
    annotation (Placement(transformation(extent={{380,-132},{400,-112}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.ModelTime modTim
    "Simulation time"
    annotation (Placement(transformation(extent={{182,-220},{202,-200}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr(final t=1)
    "Check if it has passed initial time"
    annotation (Placement(transformation(extent={{240,-220},{260,-200}})));
  Buildings.Controls.OBC.CDL.Logical.And  and7 "Logical and"
    annotation (Placement(transformation(extent={{280,-100},{300,-80}})));
  Buildings.Controls.OBC.CDL.Logical.And and8 "Logical and"
    annotation (Placement(transformation(extent={{280,-60},{300,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi2 "Logical switch"
    annotation (Placement(transformation(extent={{380,-92},{400,-72}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi3 "Logical switch"
    annotation (Placement(transformation(extent={{380,-52},{400,-32}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt
    "Convert boolean input to integer output"
    annotation (Placement(transformation(extent={{-120,140},{-100,160}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply mulInt
    "Stage zero when the plant is not enabled"
    annotation (Placement(transformation(extent={{240,160},{260,180}})));
  Buildings.Controls.OBC.CDL.Logical.And and9
    "Logical and"
    annotation (Placement(transformation(extent={{-220,-90},{-200,-70}})));

equation
  connect(switch1.y,triSam. u)
    annotation (Line(points={{-218,70},{108,70}},  color={0,0,127}));
  connect(intToRea1.y,switch1. u1) annotation (Line(points={{-298,110},{-260,110},
          {-260,78},{-242,78}}, color={0,0,127}));
  connect(intToRea.y,switch1. u3) annotation (Line(points={{-298,30},{-260,30},{
          -260,62},{-242,62}},  color={0,0,127}));
  connect(edg.y,holIniSta. u)
    annotation (Line(points={{-358,170},{-322,170}}, color={255,0,255}));
  connect(triSam.y,switch2. u3) annotation (Line(points={{132,70},{140,70},{140,
          192},{158,192}},     color={0,0,127}));
  connect(uIni,intToRea2. u) annotation (Line(points={{-460,240},{-42,240}},
                         color={255,127,0}));
  connect(intToRea2.y,switch2. u1) annotation (Line(points={{-18,240},{140,240},
          {140,208},{158,208}}, color={0,0,127}));
  connect(and2.y,or1. u2) annotation (Line(points={{22,-130},{30,-130},{30,-58},
          {38,-58}}, color={255,0,255}));
  connect(tim.y,lesEquThr. u) annotation (Line(points={{-58,-230},{-42,-230}},
          color={0,0,127}));
  connect(lesEquThr.y,pre. u) annotation (Line(points={{-18,-230},{-2,-230}},
          color={255,0,255}));
  connect(pre.y,and1. u2) annotation (Line(points={{22,-230},{40,-230},{40,-260},
          {-160,-260},{-160,-198},{-142,-198}}, color={255,0,255}));
  connect(and1.y,tim. u) annotation (Line(points={{-118,-190},{-100,-190},{-100,
          -230},{-82,-230}}, color={255,0,255}));
  connect(triSam1.u,booToRea. y)
    annotation (Line(points={{178,10},{82,10}},  color={0,0,127}));
  connect(edg.y,lat1. u) annotation (Line(points={{-358,170},{-340,170},{-340,
          200},{98,200}},
                      color={255,0,255}));
  connect(switch2.y,reaToInt. u)
    annotation (Line(points={{182,200},{198,200}}, color={0,0,127}));
  connect(and3.y,lat1. clr) annotation (Line(points={{62,120},{80,120},{80,194},
          {98,194}}, color={255,0,255}));
  connect(and1.y,staChaHol1. u) annotation (Line(points={{-118,-190},{-100,-190},
          {-100,-170},{-82,-170}}, color={255,0,255}));
  connect(staChaHol1.y,edg2. u)
    annotation (Line(points={{-58,-170},{-42,-170}}, color={255,0,255}));
  connect(uUp, or2.u1) annotation (Line(points={{-460,-40},{-410,-40},{-410,-80},
          {-382,-80}}, color={255,0,255}));
  connect(uDow, or2.u2) annotation (Line(points={{-460,-140},{-400,-140},{-400,-88},
          {-382,-88}}, color={255,0,255}));
  connect(uAvaUp, intToRea1.u)
    annotation (Line(points={{-460,110},{-322,110}}, color={255,127,0}));
  connect(uAvaDow, intToRea.u)
    annotation (Line(points={{-460,30},{-322,30}}, color={255,127,0}));
  connect(holIniSta.y, not3.u) annotation (Line(points={{-298,170},{-280,170},{
          -280,-60},{-262,-60}},
                            color={255,0,255}));
  connect(and6.y, and1.u1) annotation (Line(points={{-158,-80},{-150,-80},{-150,
          -190},{-142,-190}}, color={255,0,255}));
  connect(and6.y, edg1.u)
    annotation (Line(points={{-158,-80},{-82,-80}},color={255,0,255}));
  connect(uPla, booToRea.u) annotation (Line(points={{-460,170},{-420,170},{
          -420,10},{58,10}},                    color={255,0,255}));
  connect(uPla, falEdg.u) annotation (Line(points={{-460,170},{-420,170},{-420,
          -20},{-82,-20}},                color={255,0,255}));
  connect(falEdg.y, or3.u1) annotation (Line(points={{-58,-20},{140,-20},{140,-50},
          {158,-50}},      color={255,0,255}));
  connect(uPla, edg.u)
    annotation (Line(points={{-460,170},{-382,170}}, color={255,0,255}));
  connect(and3.u1, and6.y) annotation (Line(points={{38,120},{-150,120},{-150,
          -80},{-158,-80}},
                       color={255,0,255}));
  connect(lat1.y, switch2.u2) annotation (Line(points={{122,200},{158,200}},
                           color={255,0,255}));
  connect(or1.y, staChaHol2.u) annotation (Line(points={{62,-50},{78,-50}},
                                               color={255,0,255}));
  connect(staChaHol2.y, triSam.trigger) annotation (Line(points={{102,-50},{120,
          -50},{120,58}},   color={255,0,255}));
  connect(edg1.y, or1.u1) annotation (Line(points={{-58,-80},{0,-80},{0,-50},{38,
          -50}}, color={255,0,255}));
  connect(edg1.y, or3.u2) annotation (Line(points={{-58,-80},{140,-80},{140,-58},
          {158,-58}}, color={255,0,255}));
  connect(staChaHol3.y, not1.u)
    annotation (Line(points={{362,-250},{370,-250}}, color={255,0,255}));
  connect(not1.y, pre1.u)
    annotation (Line(points={{394,-250},{398,-250}}, color={255,0,255}));
  connect(uUp, and4.u1) annotation (Line(points={{-460,-40},{-410,-40},{-410,70},
          {-322,70}}, color={255,0,255}));
  connect(uDow, not2.u) annotation (Line(points={{-460,-140},{-400,-140},{-400,50},
          {-382,50}},   color={255,0,255}));
  connect(not2.y, and4.u2) annotation (Line(points={{-358,50},{-340,50},{-340,62},
          {-322,62}}, color={255,0,255}));
  connect(and4.y, switch1.u2) annotation (Line(points={{-298,70},{-242,70}},
                     color={255,0,255}));
  connect(conInt.y,intEqu. u1) annotation (Line(points={{202,-160},{238,-160}},
                            color={255,127,0}));
  connect(intEqu.y,and5. u2) annotation (Line(points={{262,-160},{270,-160},{
          270,-138},{278,-138}},
                            color={255,0,255}));
  connect(and5.y,logSwi1. u3) annotation (Line(points={{302,-130},{378,-130}},
                           color={255,0,255}));
  connect(modTim.y,greThr. u)
    annotation (Line(points={{204,-210},{238,-210}}, color={0,0,127}));
  connect(greThr.y,logSwi1. u2) annotation (Line(points={{262,-210},{340,-210},
          {340,-122},{378,-122}},
                           color={255,0,255}));
  connect(edg2.y, and2.u2) annotation (Line(points={{-18,-170},{-10,-170},{-10,-138},
          {-2,-138}}, color={255,0,255}));
  connect(and6.y, and2.u1) annotation (Line(points={{-158,-80},{-150,-80},{-150,
          -130},{-2,-130}}, color={255,0,255}));
  connect(and7.y, logSwi2.u3) annotation (Line(points={{302,-90},{378,-90}},
                             color={255,0,255}));
  connect(and8.y, logSwi3.u3) annotation (Line(points={{302,-50},{378,-50}},
                             color={255,0,255}));
  connect(intEqu.y, and7.u2) annotation (Line(points={{262,-160},{270,-160},{
          270,-98},{278,-98}},
                           color={255,0,255}));
  connect(intEqu.y, and8.u2) annotation (Line(points={{262,-160},{270,-160},{
          270,-58},{278,-58}},
                           color={255,0,255}));
  connect(or3.y, triSam1.trigger) annotation (Line(points={{182,-50},{190,-50},{
          190,-2}}, color={255,0,255}));
  connect(triSam1.y, greThr1.u) annotation (Line(points={{202,10},{210,10},{210,
          40},{-40,40},{-40,90},{-22,90}}, color={0,0,127}));
  connect(greThr1.y, and3.u2) annotation (Line(points={{2,90},{20,90},{20,112},{
          38,112}}, color={255,0,255}));
  connect(cha.down, and5.u1) annotation (Line(points={{322,94},{350,94},{350,20},
          {240,20},{240,-130},{278,-130}}, color={255,0,255}));
  connect(cha.y, and7.u1) annotation (Line(points={{322,100},{360,100},{360,10},
          {250,10},{250,-90},{278,-90}}, color={255,0,255}));
  connect(cha.up, and8.u1) annotation (Line(points={{322,106},{370,106},{370,0},
          {260,0},{260,-50},{278,-50}}, color={255,0,255}));
  connect(cha.up, logSwi3.u1) annotation (Line(points={{322,106},{370,106},{370,
          -34},{378,-34}}, color={255,0,255}));
  connect(cha.y, logSwi2.u1) annotation (Line(points={{322,100},{360,100},{360,
          -74},{378,-74}},
                       color={255,0,255}));
  connect(cha.down, logSwi1.u1) annotation (Line(points={{322,94},{350,94},{350,
          -114},{378,-114}}, color={255,0,255}));
  connect(greThr.y, logSwi2.u2) annotation (Line(points={{262,-210},{340,-210},
          {340,-82},{378,-82}},  color={255,0,255}));
  connect(greThr.y, logSwi3.u2) annotation (Line(points={{262,-210},{340,-210},
          {340,-42},{378,-42}},  color={255,0,255}));
  connect(logSwi1.y, yChaDowEdg)
    annotation (Line(points={{402,-122},{460,-122}}, color={255,0,255}));
  connect(logSwi2.y, yChaEdg)
    annotation (Line(points={{402,-82},{460,-82}},   color={255,0,255}));
  connect(logSwi3.y, yChaUpEdg)
    annotation (Line(points={{402,-42},{460,-42}},   color={255,0,255}));
  connect(logSwi2.y, staChaHol3.u) annotation (Line(points={{402,-82},{420,-82},
          {420,-100},{320,-100},{320,-250},{338,-250}}, color={255,0,255}));
  connect(uPla, booToInt.u) annotation (Line(points={{-460,170},{-420,170},{
          -420,150},{-122,150}}, color={255,0,255}));
  connect(booToInt.y, mulInt.u2) annotation (Line(points={{-98,150},{200,150},{
          200,164},{238,164}}, color={255,127,0}));
  connect(reaToInt.y, mulInt.u1) annotation (Line(points={{222,200},{230,200},{
          230,176},{238,176}}, color={255,127,0}));
  connect(mulInt.y, ySta)
    annotation (Line(points={{262,170},{460,170}}, color={255,127,0}));
  connect(mulInt.y, cha.u) annotation (Line(points={{262,170},{280,170},{280,
          100},{298,100}}, color={255,127,0}));
  connect(mulInt.y, intEqu.u2) annotation (Line(points={{262,170},{280,170},{
          280,100},{220,100},{220,-168},{238,-168}}, color={255,127,0}));
  connect(and9.y, and6.u1)
    annotation (Line(points={{-198,-80},{-182,-80}}, color={255,0,255}));
  connect(not3.y, and9.u2) annotation (Line(points={{-238,-60},{-232,-60},{-232,
          -88},{-222,-88}}, color={255,0,255}));
  connect(or2.y, and9.u1)
    annotation (Line(points={{-358,-80},{-222,-80}}, color={255,0,255}));
  connect(pre1.y, and6.u2) annotation (Line(points={{422,-250},{430,-250},{430,
          -280},{-190,-280},{-190,-88},{-182,-88}}, color={255,0,255}));
  annotation (defaultComponentName = "cha",
        Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-112,150},{108,112}},
          textColor={0,0,255},
          textString="%name")}), Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-440,-300},{440,300}})),
Documentation(info="<html>
<p>
This subsequence is not directly specified in 1711 as it provides a side
calculation pertaining to generalization of the staging sequences for any number
of chillers and stages provided by the user.
</p>
<p>
This subsequence is used to generate the chiller stage setpoint
<code>ySta</code> and a boolean vector of
chiller status setpoint indices <code>y</code>
for the <code>ySta</code> stage.
</p>
<p>
The inputs to the subsequece are:
</p>
<ul>
<li>
Plant enable status <code>uPla</code> that
is generated by
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable.Enable\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable.Enable</a>
subsequence
</li>
<li>
Integer index of initial chiller stage <code>uIni</code>
that is generated by
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Initial\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Initial</a>
subsequence
</li>
<li>
Stage up <code>uUp</code> and down <code>uDow</code>
boolean signals that are generated by
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Up\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Up</a>
and <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Down\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Down</a>
subsequences, respectively
</li>
<li>
Integer index of next available higher <code>uAvaUp</code>
and lower <code>uAvaDow</code> chiller stage,
as calculated by
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Status\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Status</a>
subsequence
</li>
</ul>
<p>
If stage down and stage up happen at the same time for any faulty reason the staging down is performed.
</p>
<p>
If stage down or stage up signal is held for a time longer than <code>delayStaCha</code>
multiple consecutive stage change signals are issued.
</p>
<p>
At plant enable the intial stage <code>uIni</code> is held for at least <code>delayStaCha</code>
and until any stage up or down signal is generated.
</p>
<p>
Per 1711 March 2020 Draft 5.2.4.15.1. Each stage shall have a minimum runtime
of <code>delayStaCha</code>.
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
