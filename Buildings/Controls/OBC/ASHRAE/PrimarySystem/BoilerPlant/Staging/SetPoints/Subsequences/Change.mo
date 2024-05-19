within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences;
block Change
  "Calculates the boiler stage signal"

  parameter Integer nSta = 5
    "Number of boiler stages";

  parameter Real delStaCha(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 600
    "Hold period for each stage change";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaAva[nSta]
    "Stage availability vector"
    annotation (Placement(transformation(extent={{-480,250},{-440,290}}),
        iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaChaProEnd
    "Signal indicating end of stage change process"
    annotation (Placement(transformation(extent={{-480,-260},{-440,-220}}),
      iconTransformation(extent={{-140,70},{-100,110}},
        rotation=90)));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPla
    "Plant enable signal"
    annotation (Placement(transformation(extent={{-480,140},{-440,180}}),
      iconTransformation(extent={{-140,30},{-100,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uUp
    "Stage up signal"
    annotation (Placement(transformation(extent={{-480,-60},{-440,-20}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDow
    "Stage down signal"
    annotation (Placement(transformation(extent={{-480,-160},{-440,-120}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uAvaUp(
    final min=0,
    final max=nSta)
    "Next available stage up"
    annotation (Placement(transformation(extent={{-480,80},{-440,120}}),
      iconTransformation(extent={{-140,0},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uAvaDow(
    final min=0,
    final max=nSta)
    "Next available stage down"
    annotation (Placement(transformation(extent={{-480,0},{-440,40}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChaEdg
    "Boiler stage change edge signal"
    annotation (Placement(transformation(extent={{440,-20},{480,20}}),
      iconTransformation(extent={{100,-40},{140,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChaDowEdg
    "Boiler stage change lower edge signal"
    annotation (Placement(transformation(extent={{440,-90},{480,-50}}),
      iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChaUpEdg
    "Boiler stage change higher edge signal"
    annotation (Placement(transformation(extent={{440,70},{480,110}}),
      iconTransformation(extent={{100,0},{140,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput ySta(
    final min=0,
    final max=nSta)
    "Boiler stage integer setpoint"
    annotation (Placement(transformation(extent={{440,130},{480,170}}),
      iconTransformation(extent={{100,40},{140,80}})));

protected
  parameter Integer staInd[nSta]={i for i in 1:nSta}
    "Stage index vector";

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(final k=0)
    "Zero boiler stage"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Logical or"
    annotation (Placement(transformation(extent={{-380,-90},{-360,-70}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam(
    final y_start=0)
    "Triggered sampler"
    annotation (Placement(transformation(extent={{130,140},{150,160}})));

  Buildings.Controls.OBC.CDL.Reals.Switch switch1
    "Switch"
    annotation (Placement(transformation(extent={{-200,50},{-180,70}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    "Type converter"
    annotation (Placement(transformation(extent={{-320,10},{-300,30}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Type converter"
    annotation (Placement(transformation(extent={{360,140},{380,160}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1
    "Type converter"
    annotation (Placement(transformation(extent={{-320,90},{-300,110}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Latch"
    annotation (Placement(transformation(extent={{-320,50},{-300,70}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold holIniSta(
    final trueHoldDuration=delStaCha,
    final falseHoldDuration=0)
    "Holds stage switched to initially upon plant start"
    annotation (Placement(transformation(extent={{-320,150},{-300,170}})));

  Buildings.Controls.OBC.CDL.Reals.Switch switch2
    "Switch"
    annotation (Placement(transformation(extent={{40,140},{60,160}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam1
    "Triggered sampler"
    annotation (Placement(transformation(extent={{240,0},{260,20}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Boolean to Real conversion"
    annotation (Placement(transformation(extent={{200,0},{220,20}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr1(
    final t=0.5)
    "Check if plant is still enabled"
    annotation (Placement(transformation(extent={{280,0},{300,20}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat1
    "Ensures initial stage is held until the first stage change signal after the
    initial stage phase is over"
    annotation (Placement(transformation(extent={{-80,140},{-60,160}})));

  Buildings.Controls.OBC.CDL.Logical.And and3
    "Logical And"
    annotation (Placement(transformation(extent={{280,60},{300,80}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Detects plant start"
    annotation (Placement(transformation(extent={{-380,150},{-360,170}})));

  Buildings.Controls.OBC.CDL.Logical.Not not3
    "Logical not"
    annotation (Placement(transformation(extent={{-280,150},{-260,170}})));

  Buildings.Controls.OBC.CDL.Logical.Or or3
    "Logical or"
    annotation (Placement(transformation(extent={{220,-60},{240,-40}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    "Detects plant disable"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold staChaHol3(
    final trueHoldDuration=delStaCha,
    final falseHoldDuration=0)
    "Stage change hold"
    annotation (Placement(transformation(extent={{360,-120},{380,-100}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{400,-120},{420,-100}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1
    "Previous value"
    annotation (Placement(transformation(extent={{320,-120},{340,-100}})));

  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(
    final nin=4)
    "Ensure all conditions for stage change are satisfied"
    annotation (Placement(transformation(extent={{-160,-90},{-140,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat2
    "Latch"
    annotation (Placement(transformation(extent={{-280,-190},{-260,-170}})));

  Buildings.Controls.OBC.CDL.Integers.Change cha
    "Integer change"
    annotation (Placement(transformation(extent={{340,-10},{360,10}})));

  Buildings.Controls.OBC.CDL.Logical.Or or1
    "Trigger stage number sampler when plant is turned on or when staging conditions are met"
    annotation (Placement(transformation(extent={{100,100},{120,120}})));

  Buildings.Controls.OBC.CDL.Logical.And and5
    "Ensure stage change signal is passed through only when the plant is enabled"
    annotation (Placement(transformation(extent={{-320,-90},{-300,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Change cha1
    "Detect change in boiler plant enable status"
    annotation (Placement(transformation(extent={{-120,120},{-100,140}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre2
    "Logical pre block"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg1
    "Edge detector"
    annotation (Placement(transformation(extent={{60,-90},{80,-70}})));

  Buildings.Controls.OBC.CDL.Reals.Switch switch3
    "Switch"
    annotation (Placement(transformation(extent={{-40,100},{-20,120}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nSta]
    "Boolean to Integer conversion"
    annotation (Placement(transformation(extent={{-420,260},{-400,280}})));

  Buildings.Controls.OBC.CDL.Integers.Multiply proInt[nSta]
    "Element-wise products"
    annotation (Placement(transformation(extent={{-360,240},{-340,260}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[nSta](
    final k=staInd)
    "Vector of stage indices"
    annotation (Placement(transformation(extent={{-420,220},{-400,240}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea2[nSta]
    "Integer to Real conversion"
    annotation (Placement(transformation(extent={{-320,240},{-300,260}})));

  Buildings.Controls.OBC.CDL.Reals.MultiMin mulMin(
    final nin=nSta)
    "Find lowest available stage"
    annotation (Placement(transformation(extent={{-280,240},{-260,260}})));

  Buildings.Controls.OBC.CDL.Logical.Or or4
    "Logical Or"
    annotation (Placement(transformation(extent={{-340,-190},{-320,-170}})));

  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Logical Not"
    annotation (Placement(transformation(extent={{-380,-190},{-360,-170}})));

equation
  connect(reaToInt.y,ySta)
    annotation (Line(points={{382,150},{460,150}}, color={255,127,0}));
  connect(intToRea1.y,switch1. u1) annotation (Line(points={{-298,100},{-220,100},
          {-220,68},{-202,68}}, color={0,0,127}));
  connect(intToRea.y,switch1. u3) annotation (Line(points={{-298,20},{-220,20},{
          -220,52},{-202,52}},  color={0,0,127}));
  connect(edg.y,holIniSta. u)
    annotation (Line(points={{-358,160},{-322,160}},
                                                  color={255,0,255}));
  connect(triSam1.u,booToRea. y)
    annotation (Line(points={{238,10},{222,10}},   color={0,0,127}));
  connect(triSam1.y,greThr1. u)
    annotation (Line(points={{262,10},{278,10}},   color={0,0,127}));
  connect(greThr1.y,and3. u2) annotation (Line(points={{302,10},{320,10},{320,40},
          {260,40},{260,62},{278,62}},       color={255,0,255}));
  connect(uUp, lat.u) annotation (Line(points={{-460,-40},{-380,-40},{-380,60},{
          -322,60}}, color={255,0,255}));
  connect(uDow, lat.clr) annotation (Line(points={{-460,-140},{-340,-140},{-340,
          54},{-322,54}}, color={255,0,255}));
  connect(uUp, or2.u1) annotation (Line(points={{-460,-40},{-400,-40},{-400,-80},
          {-382,-80}}, color={255,0,255}));
  connect(uDow, or2.u2) annotation (Line(points={{-460,-140},{-400,-140},{-400,-88},
          {-382,-88}}, color={255,0,255}));
  connect(uAvaUp, intToRea1.u)
    annotation (Line(points={{-460,100},{-322,100}}, color={255,127,0}));
  connect(uAvaDow, intToRea.u)
    annotation (Line(points={{-460,20},{-322,20}}, color={255,127,0}));
  connect(holIniSta.y, not3.u) annotation (Line(points={{-298,160},{-282,160}},
                                 color={255,0,255}));
  connect(uPla, booToRea.u) annotation (Line(points={{-460,160},{-388,160},{-388,
          130},{-160,130},{-160,10},{198,10}},  color={255,0,255}));
  connect(or3.y, triSam1.trigger) annotation (Line(points={{242,-50},{250,-50},{
          250,-2}},    color={255,0,255}));
  connect(uPla, falEdg.u) annotation (Line(points={{-460,160},{-388,160},{-388,130},
          {-160,130},{-160,-30},{-62,-30}},
                                          color={255,0,255}));
  connect(falEdg.y, or3.u1) annotation (Line(points={{-38,-30},{210,-30},{210,-50},
          {218,-50}},      color={255,0,255}));
  connect(uPla, edg.u)
    annotation (Line(points={{-460,160},{-382,160}}, color={255,0,255}));
  connect(lat.y, switch1.u2)
    annotation (Line(points={{-298,60},{-202,60}}, color={255,0,255}));
  connect(staChaHol3.y, not1.u)
    annotation (Line(points={{382,-110},{398,-110}}, color={255,0,255}));
  connect(lat1.y, switch2.u2)
    annotation (Line(points={{-58,150},{38,150}}, color={255,0,255}));
  connect(switch2.y, triSam.u)
    annotation (Line(points={{62,150},{128,150}}, color={0,0,127}));
  connect(triSam.y, reaToInt.u)
    annotation (Line(points={{152,150},{358,150}}, color={0,0,127}));
  connect(switch1.y, switch2.u1) annotation (Line(points={{-178,60},{-140,60},{-140,
          180},{0,180},{0,158},{38,158}}, color={0,0,127}));
  connect(and3.y, lat1.u) annotation (Line(points={{302,70},{320,70},{320,220},{
          -120,220},{-120,150},{-82,150}}, color={255,0,255}));
  connect(not3.y, mulAnd.u[1]) annotation (Line(points={{-258,160},{-240,160},{
          -240,-74.75},{-162,-74.75}},
                                  color={255,0,255}));
  connect(mulAnd.y, and3.u1) annotation (Line(points={{-138,-80},{40,-80},{40,
          70},{278,70}}, color={255,0,255}));
  connect(pre1.y, staChaHol3.u)
    annotation (Line(points={{342,-110},{358,-110}}, color={255,0,255}));
  connect(not1.y, mulAnd.u[2]) annotation (Line(points={{422,-110},{430,-110},{
          430,-140},{-200,-140},{-200,-78.25},{-162,-78.25}},
                                                          color={255,0,255}));
  connect(lat2.y, mulAnd.u[3]) annotation (Line(points={{-258,-180},{-166,-180},
          {-166,-81.75},{-162,-81.75}}, color={255,0,255}));
  connect(pre1.y, lat2.clr) annotation (Line(points={{342,-110},{350,-110},{350,
          -200},{-290,-200},{-290,-186},{-282,-186}}, color={255,0,255}));
  connect(reaToInt.y, cha.u) annotation (Line(points={{382,150},{400,150},{400,130},
          {330,130},{330,0},{338,0}}, color={255,127,0}));
  connect(or1.y, triSam.trigger) annotation (Line(points={{122,110},{140,110},{140,
          138}},   color={255,0,255}));
  connect(or2.y, and5.u1)
    annotation (Line(points={{-358,-80},{-322,-80}}, color={255,0,255}));
  connect(and5.y, mulAnd.u[4]) annotation (Line(points={{-298,-80},{-230,-80},{
          -230,-85.25},{-162,-85.25}}, color={255,0,255}));
  connect(uPla, and5.u2) annotation (Line(points={{-460,160},{-388,160},{-388,
          -20},{-328,-20},{-328,-88},{-322,-88}}, color={255,0,255}));
  connect(uPla, cha1.u) annotation (Line(points={{-460,160},{-388,160},{-388,130},
          {-122,130}},      color={255,0,255}));
  connect(cha1.y, lat1.clr) annotation (Line(points={{-98,130},{-90,130},{-90,144},
          {-82,144}},      color={255,0,255}));
  connect(cha1.y, pre2.u) annotation (Line(points={{-98,130},{-90,130},{-90,30},
          {-82,30}}, color={255,0,255}));
  connect(pre2.y, or1.u1) annotation (Line(points={{-58,30},{20,30},{20,110},{
          98,110}}, color={255,0,255}));
  connect(mulAnd.y, edg1.u)
    annotation (Line(points={{-138,-80},{58,-80}}, color={255,0,255}));
  connect(edg1.y, or1.u2) annotation (Line(points={{82,-80},{92,-80},{92,102},{
          98,102}}, color={255,0,255}));
  connect(edg1.y, or3.u2) annotation (Line(points={{82,-80},{120,-80},{120,-58},
          {218,-58}}, color={255,0,255}));
  connect(con.y, switch3.u3) annotation (Line(points={{-58,70},{-50,70},{-50,
          102},{-42,102}}, color={0,0,127}));
  connect(switch3.y, switch2.u3) annotation (Line(points={{-18,110},{0,110},{0,
          142},{38,142}}, color={0,0,127}));
  connect(uStaAva, booToInt.u)
    annotation (Line(points={{-460,270},{-422,270}}, color={255,0,255}));
  connect(booToInt.y, proInt.u1) annotation (Line(points={{-398,270},{-380,270},
          {-380,256},{-362,256}}, color={255,127,0}));
  connect(conInt.y, proInt.u2) annotation (Line(points={{-398,230},{-380,230},{-380,
          244},{-362,244}}, color={255,127,0}));
  connect(proInt.y, intToRea2.u)
    annotation (Line(points={{-338,250},{-322,250}}, color={255,127,0}));
  connect(mulMin.u[1:nSta], intToRea2.y) annotation (Line(points={{-282,250},{-290,
          250},{-290,250},{-298,250}},   color={0,0,127}));
  connect(mulMin.y, switch3.u1) annotation (Line(points={{-258,250},{-150,250},{
          -150,100},{-68,100},{-68,118},{-42,118}}, color={0,0,127}));
  connect(uPla, switch3.u2) annotation (Line(points={{-460,160},{-388,160},{-388,
          130},{-160,130},{-160,110},{-42,110}}, color={255,0,255}));
  connect(cha.up, yChaUpEdg) annotation (Line(points={{362,6},{380,6},{380,92},
          {460,92},{460,90}}, color={255,0,255}));
  connect(cha.y, yChaEdg) annotation (Line(points={{362,0},{404,0},{404,0},{460,
          0}}, color={255,0,255}));
  connect(cha.down, yChaDowEdg) annotation (Line(points={{362,-6},{380,-6},{380,
          -70},{460,-70}}, color={255,0,255}));
  connect(cha.y, pre1.u) annotation (Line(points={{362,0},{370,0},{370,-80},{
          310,-80},{310,-110},{318,-110}}, color={255,0,255}));
  connect(or4.y, lat2.u)
    annotation (Line(points={{-318,-180},{-282,-180}}, color={255,0,255}));
  connect(not2.y, or4.u1)
    annotation (Line(points={{-358,-180},{-342,-180}}, color={255,0,255}));
  connect(uPla, not2.u) annotation (Line(points={{-460,160},{-388,160},{-388,-180},
          {-382,-180}}, color={255,0,255}));
  connect(uStaChaProEnd, or4.u2) annotation (Line(points={{-460,-240},{-350,-240},
          {-350,-188},{-342,-188}}, color={255,0,255}));
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
        textString="%name")}),
    Diagram(
      coordinateSystem(preserveAspectRatio=false,
      extent={{-440,-300},{440,300}})),
    Documentation(info="<html>
    <p>
    This subsequence is not directly specified in 1711 as it provides a side
    calculation pertaining to generalization of the staging sequences for any
    number of boilers and stages provided by the user.
    </p>
    <p>This subsequence is used to generate the boiler stage setpoint 
    <span style=\"font-family: monospace;\">ySta</span> and a boolean vector of
    boiler status setpoint indices <span style=\"font-family: monospace;\">y</span>
    for the <span style=\"font-family: monospace;\">ySta</span> stage. </p>
    <p>The inputs to the subsequece are: </p>
    <ul>
    <li>
    Plant enable status <span style=\"font-family: monospace;\">uPla</span> that
    is generated by <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.PlantEnable\">Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.PlantEnable</a> subsequence. 
    </li>
    <li>
    Stage up <span style=\"font-family: monospace;\">uUp</span> and down 
    <span style=\"font-family: monospace;\">uDow</span> boolean signals that are
    generated by <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Up\">Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Up</a>
    and <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Down\">Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Down</a> subsequences, respectively.
    </li>
    <li>
    Integer index of next available higher <span style=\"font-family: monospace;\">uAvaUp</span>
    and lower <span style=\"font-family: monospace;\">uAvaDow</span> boiler stage,
    as calculated by
    <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Status\">Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Status</a>
    subsequence.
    </li>
    <li>
    Signal indicating end of stage change process <span style=\"font-family: monospace;\">uStaChaProEnd</span>
    from <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes\">Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes</a>
    subsequences.
    </li>
    </ul>
    <p>
    If stage down and stage up happen at the same time for any faulty reason the
    staging down is performed.
    </p>
    <p>
    If stage down or stage up signal is held for a time longer than <code>delStaCha</code>
    multiple consecutive stage change signals are issued.
    </p>
    <p>
    At plant enable the intial stage is held for at least <code>delStaCha</code>
    and until any stage up or down signal is generated.
    </p>
    <p>
    Per 1711 March 2020 Draft 5.3.3.10.1, each stage shall have a minimum
    runtime of <span style=\"font-family: monospace;\">delStaCha</span>. 
    </p>
    </html>",
    revisions="<html>
    <ul>
    <li>
    May 29, 2020, by Karthik Devaprasad:<br/>
    First implementation.
    </li>
    </ul>
    </html>"));
end Change;
