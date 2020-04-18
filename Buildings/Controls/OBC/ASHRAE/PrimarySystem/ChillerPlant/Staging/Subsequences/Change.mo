within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block Change "Calculates the chiller stage signal"

  parameter Integer nSta = 3
    "Number of chiller stages";

  parameter Modelica.SIunits.Time delayStaCha = 900
    "Hold period for each stage change";

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

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput ySta(
    final max=fill(nSta, nSta))
    "Chiller stage integer setpoint"
    annotation (Placement(
        transformation(extent={{440,140},{480,180}}),  iconTransformation(
          extent={{100,20},{140,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y
    "Chiller stage change edge signal"
    annotation (Placement(transformation(extent={{440,-20},{480,20}}),
        iconTransformation(extent={{100,-60},{140,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPla
    "Plant enable signal"
    annotation (Placement(transformation(extent={{-478,140},{-438,180}}),
    iconTransformation(extent={{-140,-120},{-100,-80}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Or or2 "Logical or"
    annotation (Placement(transformation(extent={{-380,-100},{-360,-80}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg1
     "Boolean signal change"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam "Triggered sampler"
    annotation (Placement(transformation(extent={{140,50},{160,70}})));

  Buildings.Controls.OBC.CDL.Logical.Switch switch1 "Switch"
    annotation (Placement(transformation(extent={{-260,50},{-240,70}})));

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

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold staChaHol(
    final trueHoldDuration=0,
    final falseHoldDuration=delayStaCha)
    "Main stage change hold"
    annotation (Placement(transformation(extent={{160,-90},{180,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Or or1 "Logical or"
    annotation (Placement(transformation(extent={{120,-60},{140,-40}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg2
    "Boolean signal change"
    annotation (Placement(transformation(extent={{20,-180},{40,-160}})));

  Buildings.Controls.OBC.CDL.Logical.And and2
    "Ensures the stage is changed at high load increases/decreases where a stage up or a stage down signal is uninterrupted after a single stage change as an another one is needed right away"
    annotation (Placement(transformation(extent={{80,-180},{100,-160}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final accumulate=false) "Timer"
    annotation (Placement(transformation(extent={{-20,-240},{0,-220}})));

  Buildings.Controls.OBC.CDL.Logical.And and1 "Logical andEnsures the stage is changed at high load increases/decreases where a stage up or a stage down signal is uninterrupted after a single stage change as an another one is needed right away"
    annotation (Placement(transformation(extent={{-80,-202},{-60,-182}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre "Previous value"
    annotation (Placement(transformation(extent={{60,-240},{80,-220}})));

  Buildings.Controls.OBC.CDL.Continuous.LessEqualThreshold lesEquThr(
    final threshold=delayStaCha) "Less equal threshold"
    annotation (Placement(transformation(extent={{20,-240},{40,-220}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam1
    "Triggered sampler"
    annotation (Placement(transformation(extent={{242,0},{262,20}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=true) "Contant"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    annotation (Placement(transformation(extent={{80,0},{100,20}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr1(
    final threshold=0.5)
    annotation (Placement(transformation(extent={{280,0},{300,20}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat1
    "Ensures initial stage is held until the first stage change signal after the initial stage phase is over"
    annotation (Placement(transformation(extent={{102,150},{122,170}})));

  Buildings.Controls.OBC.CDL.Logical.And and3 "And"
    annotation (Placement(transformation(extent={{280,90},{300,110}})));

  Buildings.Controls.OBC.CDL.Logical.Not not2 "Not"
    annotation (Placement(transformation(extent={{342,10},{362,30}})));

  Buildings.Controls.OBC.CDL.Logical.And and5 "And"
    annotation (Placement(transformation(extent={{398,-10},{418,10}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold staChaHol1(
    final trueHoldDuration=delayStaCha,
    final falseHoldDuration=0)
    "Ensures stage change delay is kept at long stage up or down signals that cause multiple consecutive stage changes "
    annotation (Placement(transformation(extent={{-20,-180},{0,-160}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Detects plant start"
    annotation (Placement(transformation(extent={{-380,150},{-360,170}})));

  Buildings.Controls.OBC.CDL.Logical.Not not3 "Logical not"
    annotation (Placement(transformation(extent={{-220,-80},{-200,-60}})));

  Buildings.Controls.OBC.CDL.Logical.And and6 "Logical not"
    annotation (Placement(transformation(extent={{-160,-90},{-140,-70}})));

equation
  connect(reaToInt.y,ySta)
    annotation (Line(points={{422,160},{460,160}}, color={255,127,0}));
  connect(switch1.y,triSam. u)
    annotation (Line(points={{-238,60},{138,60}},  color={0,0,127}));
  connect(intToRea1.y,switch1. u1) annotation (Line(points={{-298,100},{-280,100},
          {-280,68},{-262,68}}, color={0,0,127}));
  connect(intToRea.y,switch1. u3) annotation (Line(points={{-298,20},{-280,20},{
          -280,52},{-262,52}},  color={0,0,127}));
  connect(lat.y,switch1. u2)
    annotation (Line(points={{-298,60},{-262,60}}, color={255,0,255}));
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
  connect(edg1.y,or1. u1) annotation (Line(points={{22,-80},{60,-80},{60,-50},{118,
          -50}},             color={255,0,255}));
  connect(edg2.y,and2. u1) annotation (Line(points={{42,-170},{78,-170}},
                             color={255,0,255}));
  connect(and2.y,or1. u2) annotation (Line(points={{102,-170},{110,-170},{110,-58},
          {118,-58}},                   color={255,0,255}));
  connect(or1.y,triSam. trigger) annotation (Line(points={{142,-50},{150,-50},{150,
          48.2}},                           color={255,0,255}));
  connect(tim.y,lesEquThr. u) annotation (Line(points={{2,-230},{18,-230}},
                                 color={0,0,127}));
  connect(lesEquThr.y,pre. u) annotation (Line(points={{42,-230},{58,-230}},
                      color={255,0,255}));
  connect(pre.y,and1. u2) annotation (Line(points={{82,-230},{100,-230},{100,-260},
          {-100,-260},{-100,-200},{-82,-200}},
                                        color={255,0,255}));
  connect(and1.y,tim. u) annotation (Line(points={{-58,-192},{-40,-192},{-40,-230},
          {-22,-230}},       color={255,0,255}));
  connect(triSam1.u,booToRea. y)
    annotation (Line(points={{240,10},{102,10}},   color={0,0,127}));
  connect(con.y,booToRea. u)
    annotation (Line(points={{62,10},{78,10}},    color={255,0,255}));
  connect(triSam1.y,greThr1. u)
    annotation (Line(points={{264,10},{278,10}},   color={0,0,127}));
  connect(lat1.y,switch2. u2)
    annotation (Line(points={{124,160},{140,160},{140,200},{338,200}},
                                                 color={255,0,255}));
  connect(edg.y,lat1. u) annotation (Line(points={{-358,160},{-340,160},{-340,180},
          {82,180},{82,160},{100,160}},
                                 color={255,0,255}));
  connect(switch2.y,reaToInt. u)
    annotation (Line(points={{362,200},{380,200},{380,160},{398,160}},
                                                 color={0,0,127}));
  connect(greThr1.y,and3. u2) annotation (Line(points={{302,10},{320,10},{320,60},
          {260,60},{260,92},{278,92}},       color={255,0,255}));
  connect(and3.y,lat1. clr) annotation (Line(points={{302,100},{320,100},{320,140},
          {80,140},{80,154},{100,154}},
                                      color={255,0,255}));
  connect(lat1.y,not2. u) annotation (Line(points={{124,160},{330,160},{330,20},
          {340,20}},                    color={255,0,255}));
  connect(y,and5. y) annotation (Line(points={{460,0},{420,0}},
                 color={255,0,255}));
  connect(not2.y,and5. u1) annotation (Line(points={{364,20},{380,20},{380,0},{396,
          0}},        color={255,0,255}));
  connect(or1.y,and5. u2) annotation (Line(points={{142,-50},{200,-50},{200,-70},
          {380,-70},{380,-8},{396,-8}},      color={255,0,255}));
  connect(and1.y,staChaHol1. u) annotation (Line(points={{-58,-192},{-40,-192},{
          -40,-170},{-22,-170}},
                               color={255,0,255}));
  connect(staChaHol1.y,edg2. u)
    annotation (Line(points={{2,-170},{18,-170}},    color={255,0,255}));
  connect(edg.u, uPla)
    annotation (Line(points={{-382,160},{-458,160}}, color={255,0,255}));
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
          -70},{-222,-70}},      color={255,0,255}));
  connect(not3.y, and6.u1) annotation (Line(points={{-198,-70},{-180,-70},{-180,
          -80},{-162,-80}},                       color={255,0,255}));
  connect(or2.y, and6.u2) annotation (Line(points={{-358,-90},{-180,-90},{-180,-88},
          {-162,-88}},      color={255,0,255}));
  connect(and6.y, and1.u1) annotation (Line(points={{-138,-80},{-100,-80},{-100,
          -192},{-82,-192}},  color={255,0,255}));
  connect(and6.y, and2.u2) annotation (Line(points={{-138,-80},{-80,-80},{-80,-140},
          {60,-140},{60,-178},{78,-178}},    color={255,0,255}));
  connect(and6.y, and3.u1) annotation (Line(points={{-138,-80},{-100,-80},{-100,
          100},{278,100}}, color={255,0,255}));
  connect(edg1.y, staChaHol.u)
    annotation (Line(points={{22,-80},{158,-80}}, color={255,0,255}));
  connect(staChaHol.y, triSam1.trigger) annotation (Line(points={{182,-80},{252,
          -80},{252,-1.8}}, color={255,0,255}));
  connect(and6.y, edg1.u)
    annotation (Line(points={{-138,-80},{-2,-80}}, color={255,0,255}));
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
<p>
This subsequence is not directly specified in 1711 as it provides
a side calculation pertaining to generalization of the staging 
sequences for any number of chillers and stages provided by the 
user.
</p>
<p>
This subsequence is used to generate the chiller stage setpoint <code>ySta</code>
and a boolean vector of chiller status setpoint indices <code>y</code> for the <code>ySta</code> stage. 
</p>

<p>
The inputs to the subsequece are:
</p>
<ul>
<li>
Plant enable status <code>uPla</code> that is generated by 
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable</a> subsequence
</li>
<li>
Integer index of initial chiller stage <code>uIni</code> that is generated by 
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Initial\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Initial</a> subsequence
</li>
<li>
Stage up <code>uUp</code> and down <code>uDow</code> boolean signals 
that are generated by <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Up\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Up</a> and 
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Down\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Down</a> subsequences, respectively
</li>
<li>
Integer index of next available higher <code>uAvaUp</code> and lower <code>uAvaDow</code> chiller stage, as calculated by
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Status\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Status</a> subsequence
</li>
<p>
Per 1711 March 2020 Draft 5.2.4.15.1. Each stage shall have a minimum runtime of <code>delayStaCha</code>.
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
