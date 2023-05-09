within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences;
block Status
  "Outputs current stage chiller index vector, current, next available lower and higher stage index and whether curent stage is the lowest and/or the highest available stage"

  parameter Integer nSta = 3
    "Number of chiller stages, does not include zero stage";

  parameter Integer nChi = 2
    "Number of chillers";

  parameter Integer staMat[nSta, nChi] = {{1,0},{0,1},{1,1}}
    "Staging matrix with stages in rows and chillers in columns";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uAva[nSta](
    final start = fill(true, nSta)) "Stage availability status"
    annotation (Placement(transformation(extent={{-460,-100},{-420,-60}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput u(
    final min=0,
    final max=nSta,
    final start = 0) "Current chiller stage"
    annotation (Placement(transformation(extent={{-460,60},{-420,100}}),
        iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHig
    "If true current stage is the highest available stage"
    annotation (Placement(transformation(extent={{440,20},{480,60}}),
        iconTransformation(extent={{100,-30},{140,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLow
    "If true current stage is the lowest available stage"
    annotation (Placement(transformation(extent={{440,-110},{480,-70}}),
        iconTransformation(extent={{100,-60},{140,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yAvaCur
    "Current stage availability status"
    annotation (Placement(transformation(extent={{440,-260},{480,-220}}),
        iconTransformation(extent={{100,-90},{140,-50}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yAvaUp(
    final min=0,
    final max=nSta)
    "Next available higher stage"
    annotation (Placement(transformation(extent={{440,60},{480,100}}),
      iconTransformation(extent={{100,50},{140,90}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yAvaDow(
    final min=0,
    final max=nSta)
    "Next available lower stage"
    annotation (Placement(transformation(extent={{440,-60},{480,-20}}),
        iconTransformation(extent={{100,20},{140,60}})));

protected
  final parameter Integer staInd[nSta] = {i for i in 1:nSta}
    "Stage index vector";

  final parameter Integer staIndMat[nSta, nChi] = {j for i in 1:nChi, j in 1:nSta}
    "Matrix of staging matrix dimensions with stage indices in each column";

  final parameter Integer lowDia[nSta, nSta] = {if i<=j then 1 else 0 for i in 1:nSta, j in 1:nSta}
    "Lower diagonal unit matrix";

  Buildings.Controls.OBC.CDL.Logical.Not not1 "Not unavailable"
    annotation (Placement(transformation(extent={{-60,-180},{-40,-160}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi2 "Switch"
    annotation (Placement(transformation(extent={{260,-220},{280,-200}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi3 "Switch"
    annotation (Placement(transformation(extent={{360,70},{380,90}})));

  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intRep(
    final nout=nSta) "Replicates signal to a length equal the stage count"
    annotation (Placement(transformation(extent={{-300,190},{-280,210}})));

  Buildings.Controls.OBC.CDL.Integers.Multiply proInt1[nSta]
    "Outputs a vector of stage indices for any available stage above the current stage"
    annotation (Placement(transformation(extent={{-60,100},{-40,120}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant staIndx[nSta](
    final k=staInd) "Stage index vector"
    annotation (Placement(transformation(extent={{-240,120},{-220,140}})));

  Buildings.Controls.OBC.CDL.Integers.Greater intGre[nSta]
    "Identifies stages that are above the current stage"
    annotation (Placement(transformation(extent={{-180,80},{-160,100}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1[nSta](
    final integerTrue=fill(1, nSta),
    final integerFalse=fill(nSta + 1, nSta))
    "Type converter that outputs a value larger than the stage count for any false input"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));

  Buildings.Controls.OBC.CDL.Logical.And and2[nSta]
    "Identifies any available stages above the current stage"
    annotation (Placement(transformation(extent={{-140,70},{-120,90}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiMin multiMin(
    final nin=nSta)
    "Minimum of a vector input"
    annotation (Placement(transformation(extent={{20,100},{40,120}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1[nSta]
    "Type converter"
    annotation (Placement(transformation(extent={{-20,100},{0,120}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Type converter"
    annotation (Placement(transformation(extent={{60,100},{80,120}})));

  Buildings.Controls.OBC.CDL.Integers.Less intLes[nSta]
    "Identifies stages that are below the current stage"
    annotation (Placement(transformation(extent={{-180,-80},{-160,-60}})));

  Buildings.Controls.OBC.CDL.Logical.And and1[nSta]
    "Identifies any available stage below the current stage"
    annotation (Placement(transformation(extent={{-140,-100},{-120,-80}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt2[nSta](
      integerTrue=fill(1, nSta), integerFalse=fill(0, nSta))
    "Type converter that outputs zero for any false input"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  Buildings.Controls.OBC.CDL.Integers.Multiply proInt2[nSta]
    "Outputs vector of stage indices for any available stage below the current stage"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea3[nSta]
    "Type converter"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiMax multiMax(
    final nin=nSta)
    "Maximum of a vector input"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Type converter"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr(
    final t=nSta) "True if there are no higher available stages"
    annotation (Placement(transformation(extent={{100,100},{120,120}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi
    "If no higher stage is available, output current stage"
    annotation (Placement(transformation(extent={{180,100},{200,120}})));

  Buildings.Controls.OBC.CDL.Integers.LessEqualThreshold intLesEquThr(
    final t=0)
    "If the current stage is the lowest available the input value equals 0"
    annotation (Placement(transformation(extent={{100,-80},{120,-60}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi1 "Logical switch"
    annotation (Placement(transformation(extent={{180,-80},{200,-60}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanExtractor extStaAva(
    final nin=nSta) "Extracts stage availability for the current stage"
    annotation (Placement(transformation(extent={{-200,-140},{-180,-120}})));

  Buildings.Controls.OBC.CDL.Utilities.Assert cheStaAva1(
    final message="There are no available chiller stages. The staging cannot be performed.")
    "Checks if any stage is available"
    annotation (Placement(transformation(extent={{-320,-50},{-300,-30}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=nSta) "Logical or"
    annotation (Placement(transformation(extent={{-360,-50},{-340,-30}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=0) "Zero"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));

  Buildings.Controls.OBC.CDL.Logical.And and4 "Logical and"
    annotation (Placement(transformation(extent={{220,70},{240,90}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold intGreEquThr(
    final t=1)
    "Check if index is in the range"
    annotation (Placement(transformation(extent={{-380,-120},{-360,-100}})));
  Buildings.Controls.OBC.CDL.Integers.LessEqualThreshold intLesEquThr1(
    final t=nSta)
    "Check if index is in the range"
    annotation (Placement(transformation(extent={{-380,-200},{-360,-180}})));
  Buildings.Controls.OBC.CDL.Logical.And and3 "Check if index is in the range"
    annotation (Placement(transformation(extent={{-320,-120},{-300,-100}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=1)
    "Dummy index so the extractor will not have out of range index"
    annotation (Placement(transformation(extent={{-320,-200},{-300,-180}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi4 "Valid index"
    annotation (Placement(transformation(extent={{-260,-160},{-240,-140}})));
  Buildings.Controls.OBC.CDL.Logical.And and5 "Chiller availability"
    annotation (Placement(transformation(extent={{-140,-180},{-120,-160}})));

equation
  connect(staIndx.y, intGre.u1) annotation (Line(points={{-218,130},{-200,130},{
          -200,90},{-182,90}},  color={255,127,0}));
  connect(intRep.y, intGre.u2) annotation (Line(points={{-278,200},{-260,200},{
          -260,82},{-182,82}}, color={255,127,0}));
  connect(intGre.y, and2.u1) annotation (Line(points={{-158,90},{-150,90},{-150,
          80},{-142,80}},color={255,0,255}));
  connect(uAva, and2.u2) annotation (Line(points={{-440,-80},{-220,-80},{-220,72},
          {-142,72}},     color={255,0,255}));
  connect(staIndx.y, proInt1.u1) annotation (Line(points={{-218,130},{-70,130},{
          -70,116},{-62,116}},  color={255,127,0}));
  connect(booToInt1.y, proInt1.u2) annotation (Line(points={{-78,80},{-70,80},{-70,
          104},{-62,104}},     color={255,127,0}));
  connect(proInt1.y, intToRea1.u)
    annotation (Line(points={{-38,110},{-22,110}}, color={255,127,0}));
  connect(intToRea1.y, multiMin.u) annotation (Line(points={{2,110},{18,110}},
          color={0,0,127}));
  connect(intRep.y, intLes.u2) annotation (Line(points={{-278,200},{-260,200},{
          -260,-78},{-182,-78}}, color={255,127,0}));
  connect(staIndx.y, intLes.u1) annotation (Line(points={{-218,130},{-200,130},{
          -200,-70},{-182,-70}},  color={255,127,0}));
  connect(uAva, and1.u2) annotation (Line(points={{-440,-80},{-220,-80},{-220,-98},
          {-142,-98}},      color={255,0,255}));
  connect(intLes.y, and1.u1) annotation (Line(points={{-158,-70},{-150,-70},{-150,
          -90},{-142,-90}},      color={255,0,255}));
  connect(proInt2.y, intToRea3.u)
    annotation (Line(points={{-38,-70},{-22,-70}}, color={255,127,0}));
  connect(intToRea3.y, multiMax.u) annotation (Line(points={{2,-70},{18,-70}},
    color={0,0,127}));
  connect(staIndx.y, proInt2.u1) annotation (Line(points={{-218,130},{-200,130},
          {-200,-40},{-70,-40},{-70,-64},{-62,-64}}, color={255,127,0}));
  connect(booToInt2.y, proInt2.u2) annotation (Line(points={{-78,-90},{-70,-90},
          {-70,-76},{-62,-76}}, color={255,127,0}));
  connect(multiMax.y, reaToInt1.u)
    annotation (Line(points={{42,-70},{58,-70}}, color={0,0,127}));
  connect(multiMin.y, reaToInt.u)
    annotation (Line(points={{42,110},{58,110}}, color={0,0,127}));
  connect(reaToInt.y, intGreThr.u)
    annotation (Line(points={{82,110},{98,110}}, color={255,127,0}));
  connect(intGreThr.y, intSwi.u2)
    annotation (Line(points={{122,110},{178,110}}, color={255,0,255}));
  connect(intGreThr.y, yHig) annotation (Line(points={{122,110},{140,110},{140,40},
          {460,40}},     color={255,0,255}));
  connect(reaToInt1.y, intLesEquThr.u)
    annotation (Line(points={{82,-70},{98,-70}}, color={255,127,0}));
  connect(intLesEquThr.y, intSwi1.u2)
    annotation (Line(points={{122,-70},{178,-70}}, color={255,0,255}));
  connect(intLesEquThr.y, yLow) annotation (Line(points={{122,-70},{140,-70},{140,
          -90},{460,-90}},  color={255,0,255}));
  connect(and2.y, booToInt1.u)
    annotation (Line(points={{-118,80},{-102,80}}, color={255,0,255}));
  connect(intGreThr.y, and4.u1)
    annotation (Line(points={{122,110},{140,110},{140,80},{218,80}},
         color={255,0,255}));
  connect(and4.y, intSwi3.u2)
    annotation (Line(points={{242,80},{358,80}}, color={255,0,255}));
  connect(uAva, mulOr.u) annotation (Line(points={{-440,-80},{-380,-80},{-380,-40},
          {-362,-40}},  color={255,0,255}));
  connect(mulOr.y, cheStaAva1.u)
    annotation (Line(points={{-338,-40},{-322,-40}},     color={255,0,255}));
  connect(and1.y, booToInt2.u)
    annotation (Line(points={{-118,-90},{-102,-90}}, color={255,0,255}));
  connect(u, intRep.u) annotation (Line(points={{-440,80},{-400,80},{-400,200},{
          -302,200}},  color={255,127,0}));
  connect(conInt.y, intSwi1.u1) annotation (Line(points={{122,-30},{160,-30},{160,
          -62},{178,-62}},     color={255,127,0}));
  connect(intSwi1.y, yAvaDow) annotation (Line(points={{202,-70},{320,-70},{320,
          -40},{460,-40}}, color={255,127,0}));
  connect(intSwi1.y, intSwi2.u1) annotation (Line(points={{202,-70},{220,-70},{220,
          -202},{258,-202}},                        color={255,127,0}));
  connect(intSwi2.y, intSwi3.u1) annotation (Line(points={{282,-210},{350,-210},
          {350,88},{358,88}}, color={255,127,0}));
  connect(u, intSwi2.u3) annotation (Line(points={{-440,80},{-400,80},{-400,-218},
          {258,-218}},      color={255,127,0}));
  connect(intSwi.y, intSwi3.u3) annotation (Line(points={{202,110},{340,110},{340,
          72},{358,72}},     color={255,127,0}));
  connect(u, intSwi.u1) annotation (Line(points={{-440,80},{-400,80},{-400,160},
          {160,160},{160,118},{178,118}}, color={255,127,0}));
  connect(reaToInt.y, intSwi.u3) annotation (Line(points={{82,110},{90,110},{90,
          90},{160,90},{160,102},{178,102}}, color={255,127,0}));
  connect(reaToInt1.y, intSwi1.u3) annotation (Line(points={{82,-70},{90,-70},{90,
          -100},{170,-100},{170,-78},{178,-78}},    color={255,127,0}));
  connect(intSwi3.y, yAvaUp)
    annotation (Line(points={{382,80},{460,80}}, color={255,127,0}));
  connect(uAva, extStaAva.u) annotation (Line(points={{-440,-80},{-220,-80},{-220,
          -130},{-202,-130}},      color={255,0,255}));
  connect(not1.y, intSwi2.u2) annotation (Line(points={{-38,-170},{210,-170},{210,
          -210},{258,-210}},color={255,0,255}));
  connect(not1.y, and4.u2) annotation (Line(points={{-38,-170},{210,-170},{210,72},
          {218,72}},     color={255,0,255}));
  connect(u, intGreEquThr.u) annotation (Line(points={{-440,80},{-400,80},{-400,
          -110},{-382,-110}}, color={255,127,0}));
  connect(u, intLesEquThr1.u) annotation (Line(points={{-440,80},{-400,80},{-400,
          -190},{-382,-190}}, color={255,127,0}));
  connect(intGreEquThr.y, and3.u1)
    annotation (Line(points={{-358,-110},{-322,-110}}, color={255,0,255}));
  connect(intLesEquThr1.y, and3.u2) annotation (Line(points={{-358,-190},{-340,-190},
          {-340,-118},{-322,-118}}, color={255,0,255}));
  connect(intSwi4.y, extStaAva.index) annotation (Line(points={{-238,-150},{-190,
          -150},{-190,-142}}, color={255,127,0}));
  connect(and3.y, intSwi4.u2) annotation (Line(points={{-298,-110},{-280,-110},{
          -280,-150},{-262,-150}}, color={255,0,255}));
  connect(u, intSwi4.u1) annotation (Line(points={{-440,80},{-400,80},{-400,-142},
          {-262,-142}}, color={255,127,0}));
  connect(conInt1.y, intSwi4.u3) annotation (Line(points={{-298,-190},{-290,-190},
          {-290,-158},{-262,-158}}, color={255,127,0}));
  connect(extStaAva.y, and5.u1) annotation (Line(points={{-178,-130},{-160,-130},
          {-160,-170},{-142,-170}}, color={255,0,255}));
  connect(and5.y, not1.u)
    annotation (Line(points={{-118,-170},{-62,-170}}, color={255,0,255}));
  connect(and5.y, yAvaCur) annotation (Line(points={{-118,-170},{-100,-170},{-100,
          -240},{460,-240}}, color={255,0,255}));
  connect(and3.y, and5.u2) annotation (Line(points={{-298,-110},{-280,-110},{-280,
          -178},{-142,-178}}, color={255,0,255}));
  annotation (defaultComponentName = "sta",
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
          extent={{-420,-280},{440,280}})),
Documentation(info="<html>
<p>This subsequence is not directly specified in 1711 as it provides a side calculation pertaining to generalization of the staging sequences for any number of chillers and stages provided by the user. </p>
<p>Based on the current stage <span style=\"font-family: monospace;\">u</span> and stage availability vector <span style=\"font-family: monospace;\">uAva</span> the sequence outputs: </p>
<ul>
<li>Integer indices of: the current stage <span style=\"font-family: monospace;\">y</span>, first available higher stage <span style=\"font-family: monospace;\">yUp</span> and the first available lower stage <span style=\"font-family: monospace;\">yDown</span>. </li>
<li>Boolean status outputs to show if the current operating stage <span style=\"font-family: monospace;\">u</span> is: </li>
<li><ul>
<li>Available, <span style=\"font-family: monospace;\">u</span> </li>
<li>The highest available stage, <span style=\"font-family: monospace;\">yHig</span> </li>
<li>The lowest available stage, <span style=\"font-family: monospace;\">yLow</span> </li>
</ul></li>
</ul>
<p>The purpose of this sequence is to: </p>
<ul>
<li>Provide inputs for the stage up and down conditionals such that staging into unavailable stages is avoided. </li>
<li>Change the stage to the first available higher stage in an event that the current stage becomes unavailable. </li>
</ul>
<p>The sequences are implemented according to 1711 March 2020 Draft, section 5.2.4.15.</p>
</html>",
revisions="<html>
<ul>
<li>
June 10, 2019, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Status;
