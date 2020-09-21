within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences;
block Change "Calculates the chiller stage signal"

  parameter Integer nSta = 3
    "Number of chiller stages";

  parameter Real delayStaCha(
    final unit="s",
    final quantity="Time",
    displayUnit="h")=900
      "Hold period for each stage change";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPla
    "Plant enable signal"
    annotation (Placement(transformation(extent={{-478,140},{-438,180}}),
    iconTransformation(extent={{-140,-120},{-100,-80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uUp
    "Stage up status"
    annotation (Placement(transformation(extent={{-478,-60},{-438,-20}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDow
    "Stage down signal"
    annotation (Placement(transformation(extent={{-480,-160},{-440,-120}}),
    iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uIni(
    final min=0,
    final max=nSta)
    "Initial chiller stage (at plant enable)"
     annotation (Placement(transformation(extent={{-478,200},{-438,240}}),
     iconTransformation(extent={{-140,80},{-100,120}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uAvaUp(
    final min=0,
    final max=nSta)
    "Next available stage up"
    annotation (Placement(transformation(extent={{-478,80},{-438,120}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uAvaDow(
    final min=0,
    final max=nSta)
    "Next available stage down"
    annotation (Placement(transformation(extent={{-478,0}, {-438,40}}),
    iconTransformation(extent={{-140,0},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChaEdg
    "Chiller stage change edge signal"
    annotation (Placement(transformation(
          extent={{440,-20},{480,20}}), iconTransformation(extent={{100,-60},{
            140,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChaUpEdg
    "Chiller stage up change edge signal"
    annotation (Placement(transformation(extent={{440,40},{480,80}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChaDowEdg
    "Chiller stage down change edge signal"
    annotation (Placement(transformation(extent={{440,-80},{480,-40}}),
        iconTransformation(extent={{100,-100},{140,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput ySta(
    final min=0,
    final max = nSta)
    "Chiller stage integer setpoint"
    annotation (Placement(
        transformation(extent={{440,140},{480,180}}),  iconTransformation(
          extent={{100,20},{140,60}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Or or2 "Logical or"
    annotation (Placement(transformation(extent={{-380,-100},{-360,-80}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg1
     "Boolean signal change"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam "Triggered sampler"
    annotation (Placement(transformation(extent={{140,50},{160,70}})));

  Buildings.Controls.OBC.CDL.Logical.Switch switch1 "Switch"
    annotation (Placement(transformation(extent={{-200,50},{-180,70}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea "Type converter"
    annotation (Placement(transformation(extent={{-320,10},{-300,30}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt "Type converter"
    annotation (Placement(transformation(extent={{400,150},{420,170}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1 "Type converter"
    annotation (Placement(transformation(extent={{-320,90},{-300,110}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat(
    final pre_y_start=true) "Latch"
    annotation (Placement(transformation(extent={{-320,50},{-300,70}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea2
    "Integer to real conversion"
    annotation (Placement(transformation(extent={{-40,210},{-20,230}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold holIniSta(
    final trueHoldDuration=delayStaCha,
    final falseHoldDuration=0)
    "Holds stage switched to initial upon plant start"
    annotation (Placement(transformation(extent={{-320,150},{-300,170}})));

  Buildings.Controls.OBC.CDL.Logical.Switch switch2 "Switch"
    annotation (Placement(transformation(extent={{340,190},{360,210}})));

  Buildings.Controls.OBC.CDL.Logical.Or or1 "Logical or"
    annotation (Placement(transformation(extent={{120,-60},{140,-40}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg2
    "Boolean signal change"
    annotation (Placement(transformation(extent={{20,-180},{40,-160}})));

  Buildings.Controls.OBC.CDL.Logical.And and2
    "Ensures the stage is changed at high load increases/decreases where a stage up or a stage down signal is uninterrupted after a single stage change as an another one is needed right away"
    annotation (Placement(transformation(extent={{80,-180},{100,-160}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim "Timer"
    annotation (Placement(transformation(extent={{-20,-240},{0,-220}})));

  Buildings.Controls.OBC.CDL.Logical.And and1 "Logical andEnsures the stage is changed at high load increases/decreases where a stage up or a stage down signal is uninterrupted after a single stage change as an another one is needed right away"
    annotation (Placement(transformation(extent={{-80,-200},{-60,-180}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre "Previous value"
    annotation (Placement(transformation(extent={{60,-240},{80,-220}})));

  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesEquThr(
    final t=delayStaCha) "Less equal threshold"
    annotation (Placement(transformation(extent={{20,-240},{40,-220}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam1
    "Triggered sampler"
    annotation (Placement(transformation(extent={{240,0},{260,20}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea "Type conveter"
    annotation (Placement(transformation(extent={{200,0},{220,20}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr1(
    final t=0.5) "Greater than a threshold"
    annotation (Placement(transformation(extent={{280,0},{300,20}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat1
    "Ensures initial stage is held until the first stage change signal after the initial stage phase is over"
    annotation (Placement(transformation(extent={{102,150},{122,170}})));

  Buildings.Controls.OBC.CDL.Logical.And and3 "And"
    annotation (Placement(transformation(extent={{280,90},{300,110}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold staChaHol1(
    final trueHoldDuration=delayStaCha,
    final falseHoldDuration=0)
    "Ensures stage change delay is kept at long stage up or down signals that cause multiple consecutive stage changes "
    annotation (Placement(transformation(extent={{-20,-180},{0,-160}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Detects plant start"
    annotation (Placement(transformation(extent={{-380,150},{-360,170}})));

  Buildings.Controls.OBC.CDL.Logical.Not not3 "Logical not"
    annotation (Placement(transformation(extent={{-220,-70},{-200,-50}})));

  Buildings.Controls.OBC.CDL.Logical.And3 and6 "Logical not"
    annotation (Placement(transformation(extent={{-160,-90},{-140,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Or or3 "Logical or"
    annotation (Placement(transformation(extent={{220,-60},{240,-40}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    "Detects plant start"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold staChaHol2(
    final trueHoldDuration=0,
    final falseHoldDuration=delayStaCha)
    "Stage change hold"
    annotation (Placement(transformation(extent={{120,-20},{140,0}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold staChaHol3(
    final trueHoldDuration=delayStaCha,
    final falseHoldDuration=0)
    "Stage change hold"
    annotation (Placement(transformation(extent={{340,-118},{360,-98}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{378,-118},{398,-98}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1 "Previous value"
    annotation (Placement(transformation(extent={{406,-118},{426,-98}})));

  Buildings.Controls.OBC.CDL.Integers.Change cha "Integer change"
    annotation (Placement(transformation(extent={{380,0},{400,20}})));

equation
  connect(reaToInt.y,ySta)
    annotation (Line(points={{422,160},{460,160}}, color={255,127,0}));
  connect(switch1.y,triSam. u)
    annotation (Line(points={{-178,60},{138,60}},  color={0,0,127}));
  connect(intToRea1.y,switch1. u1) annotation (Line(points={{-298,100},{-220,100},
          {-220,68},{-202,68}}, color={0,0,127}));
  connect(intToRea.y,switch1. u3) annotation (Line(points={{-298,20},{-220,20},{
          -220,52},{-202,52}},  color={0,0,127}));
  connect(edg.y,holIniSta. u)
    annotation (Line(points={{-358,160},{-322,160}},
                                                  color={255,0,255}));
  connect(triSam.y,switch2. u3) annotation (Line(points={{162,60},{170,60},{170,
          192},{338,192}},     color={0,0,127}));
  connect(uIni,intToRea2. u) annotation (Line(points={{-458,220},{-42,220}},
                         color={255,127,0}));
  connect(intToRea2.y,switch2. u1) annotation (Line(points={{-18,220},{140,220},
          {140,208},{338,208}},
                           color={0,0,127}));
  connect(edg2.y,and2. u1) annotation (Line(points={{42,-170},{78,-170}},
                             color={255,0,255}));
  connect(and2.y,or1. u2) annotation (Line(points={{102,-170},{110,-170},{110,-58},
          {118,-58}},                   color={255,0,255}));
  connect(tim.y,lesEquThr. u) annotation (Line(points={{2,-230},{18,-230}},
                                 color={0,0,127}));
  connect(lesEquThr.y,pre. u) annotation (Line(points={{42,-230},{58,-230}},
                      color={255,0,255}));
  connect(pre.y,and1. u2) annotation (Line(points={{82,-230},{100,-230},{100,-260},
          {-100,-260},{-100,-198},{-82,-198}},
                                        color={255,0,255}));
  connect(and1.y,tim. u) annotation (Line(points={{-58,-190},{-40,-190},{-40,-230},
          {-22,-230}},       color={255,0,255}));
  connect(triSam1.u,booToRea. y)
    annotation (Line(points={{238,10},{222,10}},   color={0,0,127}));
  connect(triSam1.y,greThr1. u)
    annotation (Line(points={{262,10},{278,10}},   color={0,0,127}));
  connect(edg.y,lat1. u) annotation (Line(points={{-358,160},{-340,160},{-340,180},
          {80,180},{80,160},{100,160}},
                                 color={255,0,255}));
  connect(switch2.y,reaToInt. u)
    annotation (Line(points={{362,200},{380,200},{380,160},{398,160}},
                                                 color={0,0,127}));
  connect(greThr1.y,and3. u2) annotation (Line(points={{302,10},{320,10},{320,60},
          {260,60},{260,92},{278,92}},       color={255,0,255}));
  connect(and3.y,lat1. clr) annotation (Line(points={{302,100},{320,100},{320,140},
          {80,140},{80,154},{100,154}},
                                      color={255,0,255}));
  connect(and1.y,staChaHol1. u) annotation (Line(points={{-58,-190},{-40,-190},{
          -40,-170},{-22,-170}},
                               color={255,0,255}));
  connect(staChaHol1.y,edg2. u)
    annotation (Line(points={{2,-170},{18,-170}},    color={255,0,255}));
  connect(uUp, lat.u) annotation (Line(points={{-458,-40},{-380,-40},{-380,60},{
          -322,60}}, color={255,0,255}));
  connect(uDow, lat.clr) annotation (Line(points={{-460,-140},{-340,-140},{-340,
          54},{-322,54}}, color={255,0,255}));
  connect(uUp, or2.u1) annotation (Line(points={{-458,-40},{-400,-40},{-400,-90},
          {-382,-90}}, color={255,0,255}));
  connect(uDow, or2.u2) annotation (Line(points={{-460,-140},{-400,-140},{-400,-98},
          {-382,-98}}, color={255,0,255}));
  connect(uAvaUp, intToRea1.u)
    annotation (Line(points={{-458,100},{-322,100}}, color={255,127,0}));
  connect(uAvaDow, intToRea.u)
    annotation (Line(points={{-458,20},{-322,20}}, color={255,127,0}));
  connect(holIniSta.y, not3.u) annotation (Line(points={{-298,160},{-230,160},{-230,
          -60},{-222,-60}},      color={255,0,255}));
  connect(not3.y, and6.u1) annotation (Line(points={{-198,-60},{-180,-60},{-180,
          -72},{-162,-72}},                       color={255,0,255}));
  connect(or2.y, and6.u2) annotation (Line(points={{-358,-90},{-180,-90},{-180,
          -80},{-162,-80}}, color={255,0,255}));
  connect(and6.y, and1.u1) annotation (Line(points={{-138,-80},{-100,-80},{-100,
          -190},{-82,-190}},  color={255,0,255}));
  connect(and6.y, and2.u2) annotation (Line(points={{-138,-80},{-80,-80},{-80,-140},
          {60,-140},{60,-178},{78,-178}},    color={255,0,255}));
  connect(and6.y, edg1.u)
    annotation (Line(points={{-138,-80},{-2,-80}}, color={255,0,255}));
  connect(uPla, booToRea.u) annotation (Line(points={{-458,160},{-400,160},{
          -400,120},{40,120},{40,10},{198,10}}, color={255,0,255}));
  connect(or3.y, triSam1.trigger) annotation (Line(points={{242,-50},{250,-50},
          {250,-1.8}}, color={255,0,255}));
  connect(uPla, falEdg.u) annotation (Line(points={{-458,160},{-420,160},{-420,
          -20},{0,-20},{0,-30},{38,-30}}, color={255,0,255}));
  connect(falEdg.y, or3.u1) annotation (Line(points={{62,-30},{210,-30},{210,
          -50},{218,-50}}, color={255,0,255}));
  connect(uPla, edg.u)
    annotation (Line(points={{-458,160},{-382,160}}, color={255,0,255}));
  connect(lat.y, switch1.u2)
    annotation (Line(points={{-298,60},{-202,60}}, color={255,0,255}));
  connect(and3.u1, and6.y) annotation (Line(points={{278,100},{-100,100},{-100,-80},
          {-138,-80}}, color={255,0,255}));
  connect(lat1.y, switch2.u2) annotation (Line(points={{124,160},{160,160},{160,
          200},{338,200}}, color={255,0,255}));
  connect(or1.y, staChaHol2.u) annotation (Line(points={{142,-50},{152,-50},{152,
          -24},{100,-24},{100,-10},{118,-10}}, color={255,0,255}));
  connect(staChaHol2.y, triSam.trigger) annotation (Line(points={{142,-10},{150,
          -10},{150,48.2}}, color={255,0,255}));
  connect(edg1.y, or1.u1) annotation (Line(points={{22,-80},{40,-80},{40,-50},{118,
          -50}}, color={255,0,255}));
  connect(edg1.y, or3.u2) annotation (Line(points={{22,-80},{210,-80},{210,-58},
          {218,-58}}, color={255,0,255}));
  connect(staChaHol3.y, not1.u)
    annotation (Line(points={{362,-108},{376,-108}}, color={255,0,255}));
  connect(not1.y, pre1.u)
    annotation (Line(points={{400,-108},{404,-108}}, color={255,0,255}));
  connect(pre1.y, and6.u3) annotation (Line(points={{428,-108},{428,-286},{-170,
          -286},{-170,-88},{-162,-88}}, color={255,0,255}));
  connect(reaToInt.y, cha.u) annotation (Line(points={{422,160},{430,160},{430,126},
          {360,126},{360,10},{378,10}}, color={255,127,0}));
  connect(cha.y, yChaEdg) annotation (Line(points={{402,10},{432,10},{432,0},{460,
          0}}, color={255,0,255}));
  connect(cha.y, staChaHol3.u) annotation (Line(points={{402,10},{410,10},{410,-60},
          {320,-60},{320,-108},{338,-108}}, color={255,0,255}));
  connect(cha.up, yChaUpEdg) annotation (Line(points={{402,16},{420,16},{420,60},
          {460,60}}, color={255,0,255}));
  connect(cha.down, yChaDowEdg) annotation (Line(points={{402,4},{420,4},{420,-60},
          {460,-60}}, color={255,0,255}));
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
        extent={{-440,-300},{440,300}})),
Documentation(info="<html>
<p>This subsequence is not directly specified in 1711 as it provides a side calculation pertaining to generalization of the staging sequences for any number of chillers and stages provided by the user. </p>
<p>This subsequence is used to generate the chiller stage setpoint <span style=\"font-family: monospace;\">ySta</span> and a boolean vector of chiller status setpoint indices <span style=\"font-family: monospace;\">y</span> for the <span style=\"font-family: monospace;\">ySta</span> stage. </p>
<p>The inputs to the subsequece are: </p>
<ul>
<li>Plant enable status <span style=\"font-family: monospace;\">uPla</span> that is generated by <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable\">Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable</a> subsequence </li>
<li>Integer index of initial chiller stage <span style=\"font-family: monospace;\">uIni</span> that is generated by <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Initial\">Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Initial</a> subsequence </li>
<li>Stage up <span style=\"font-family: monospace;\">uUp</span> and down <span style=\"font-family: monospace;\">uDow</span> boolean signals that are generated by <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Up\">Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Up</a> and <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Down\">Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Down</a> subsequences, respectively </li>
<li>Integer index of next available higher <span style=\"font-family: monospace;\">uAvaUp</span> and lower <span style=\"font-family: monospace;\">uAvaDow</span> chiller stage, as calculated by <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Status\">Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Status</a> subsequence </li>
</ul>
<p>If stage down and stage up happen at the same time for any faulty reason the staging down is performed.</p>
<p>If stage down or stage up signal is held for a time longer than <code>delayStaCha</code> multiple consecutive stage change signals are issued.</p>
<p>At plant enable the intial stage <code>uIni</code> is held for at least <code>delayStaCha</code> and until any stage up or down signal is generated.</p>
<p>Per 1711 March 2020 Draft 5.2.4.15.1. Each stage shall have a minimum runtime of <span style=\"font-family: monospace;\">delayStaCha</span>. </p>
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
