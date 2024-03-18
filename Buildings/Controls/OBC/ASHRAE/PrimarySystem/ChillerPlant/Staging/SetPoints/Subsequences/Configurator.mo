within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences;
block Configurator "Configures chiller staging"

  parameter Integer nSta = 3
    "Number of chiller stages, does not include zero stage";

  parameter Integer nChi = 2
    "Number of chillers";

  parameter Real chiDesCap[nChi](
     final unit=fill("W",nChi),
     final quantity=fill("HeatFlowRate",nChi),
     displayUnit=fill("W",nChi))
    "Design chiller capacities vector"
    annotation (Evaluate=true);

  parameter Real chiMinCap[nChi](
     final unit=fill("W",nChi),
     final quantity=fill("HeatFlowRate",nChi),
     displayUnit=fill("W",nChi))
    "Chiller minimum cycling loads vector"
    annotation (Evaluate=true);

  parameter Integer chiTyp[nChi]={
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement,
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.constantSpeedCentrifugal}
    "Chiller type. Recommended staging order: positive displacement, variable speed centrifugal, constant speed centrifugal";

  parameter Integer staMat[nSta, nChi] = {{1,0},{0,1},{1,1}}
    "Staging matrix with stage as row index and chiller as column index";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiAva[nChi]
    "Chiller availability status vector. Chiller may be deemend unavailable due to unavailability of a dedicated chilled or condenser water pump"
    annotation (Placement(transformation(extent={{-260,-60},{-220,-20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yAva[nSta]
    "Stage availability status vector"
    annotation (Placement(transformation(extent={{220,-100},{260,-60}}),
        iconTransformation(extent={{100,-100},{140,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yTyp[nSta](
    final max=fill(nSta, nSta)) "Chiller stage types vector"
    annotation (Placement(transformation(extent={{220,-140},{260,-100}}),
        iconTransformation(extent={{100,-60},{140,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDesCap[nSta](
    final unit=fill("W", nSta),
    final quantity=fill("HeatFlowRate", nSta)) "Stage design capacities vector"
    annotation (Placement(transformation(extent={{220,0},{260,40}}),
        iconTransformation(extent={{100,60},{140,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMinCap[nSta](
    final unit=fill("W", nSta),
    final quantity=fill("HeatFlowRate", nSta)) "Unload stage capacities vector"
    annotation (Placement(transformation(extent={{220,-40},{260,0}}),
        iconTransformation(extent={{100,20},{140,60}})));

protected
  final parameter Integer chiTypMat[nSta, nChi] = {chiTyp[i] for i in 1:nChi, j in 1:nSta}
    "Chiller type array expanded to allow for element-wise multiplication with the staging matrix";

  Buildings.Controls.OBC.CDL.Utilities.Assert assMes1(
  final message="The chillers must be tagged in order of design capacity if unequally sized")
    "Asserts whether chillers are tagged in ascending order with regards to capacity"
    annotation (Placement(transformation(extent={{60,160},{80,180}})));

  Buildings.Controls.OBC.CDL.Reals.Sort sort1(
    final nin=nChi) "Ascending sort"
    annotation (Placement(transformation(extent={{-140,160},{-120,180}})));

  Buildings.Controls.OBC.CDL.Reals.Subtract sub1[nChi]
    "Subtracts signals"
    annotation (Placement(transformation(extent={{-100,160},{-80,180}})));

  Buildings.Controls.OBC.CDL.Reals.MultiMax multiMax(
    final nin=nChi) "Maximum value in a vector input"
    annotation (Placement(transformation(extent={{-60,160},{-40,180}})));

  Buildings.Controls.OBC.CDL.Reals.Abs abs "Absolute values"
    annotation (Placement(transformation(extent={{-20,160},{0,180}})));

  Buildings.Controls.OBC.CDL.Reals.LessThreshold lesThr1(
    final t=0.5) "Less threshold"
    annotation (Placement(transformation(extent={{20,160},{40,180}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant chiDesCaps[nChi](
    final k=chiDesCap) "Design chiller capacities vector"
    annotation (Placement(transformation(extent={{-200,100},{-180,120}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant chiMinCaps[nChi](
    final k=chiMinCap) "Chiller unload capacities vector"
    annotation (Placement(transformation(extent={{-200,60},{-180,80}})));

  Buildings.Controls.OBC.CDL.Reals.MatrixGain staDesCaps(
    final K=staMat) "Matrix gain for design capacities"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));

  Buildings.Controls.OBC.CDL.Reals.MatrixGain staMinCaps(
    final K=staMat) "Matrix gain from minimal capacities"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));

  Buildings.Controls.OBC.CDL.Reals.MatrixGain sumNumChi(
    final K=staMat)
    "Outputs the total chiller count per stage vector"
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));

  Buildings.Controls.OBC.CDL.Reals.MatrixGain sumNumAvaChi(
    final K=staMat)
    "Outputs the available chiller count per stage vector"
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant oneVec[nChi](
    final k=fill(1, nChi)) "Mocks a case with all chillers available"
    annotation (Placement(transformation(extent={{-200,10},{-180,30}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nChi]
    "Type converter"
    annotation (Placement(transformation(extent={{-200,-50},{-180,-30}})));

  Buildings.Controls.OBC.CDL.Reals.Subtract sub2[nSta]
    "Subtracts count of available chillers from the design count, at each stage"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));

  Buildings.Controls.OBC.CDL.Reals.LessThreshold lesThr[nSta](
    final t=fill(0.5, nSta))
    "Checks if the count of available chillers in each stage equals the design count"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant chiStaMat[nSta,nChi](
    final k=staMat) "Staging matrix"
    annotation (Placement(transformation(extent={{-200,-170},{-180,-150}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant staType[nSta,nChi](
    final k=chiTypMat) "Chiller stage type matrix"
    annotation (Placement(transformation(extent={{-200,-110},{-180,-90}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply pro[nSta,nChi]
    "Element-wise product"
    annotation (Placement(transformation(extent={{-140,-130},{-120,-110}})));

  Buildings.Controls.OBC.CDL.Reals.MatrixMax matMax(
    final nRow=nSta,
    final nCol=nChi) "Row-wise matrix maximum"
    annotation (Placement(transformation(extent={{-100,-130},{-80,-110}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt[nSta]
    "Type converter"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));

  Buildings.Controls.OBC.CDL.Reals.Sort sort(
    final nin=nSta) "Vector sort"
    annotation (Placement(transformation(extent={{20,-180},{40,-160}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1[nSta]
    "Type converter"
    annotation (Placement(transformation(extent={{-20,-180},{0,-160}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1[nSta]
    "Type converter"
    annotation (Placement(transformation(extent={{60,-180},{80,-160}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[nSta] "Integer equality"
    annotation (Placement(transformation(extent={{100,-160},{120,-140}})));

  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(
    final message="It could be that the chillers are not being staged in an order
    recommended by ASHRAE RP1711 or Guideline 36.
    Please make sure to follow the recommendation that is:
    any positive displacement machines first,
    any variable speed centrifugal next and any constant speed centrifugal last.")
    "Assert block"
    annotation (Placement(transformation(extent={{180,-160},{200,-140}})));

  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(
    final nin=nSta) "Logical and with a vector input"
    annotation (Placement(transformation(extent={{140,-160},{160,-140}})));

equation
  connect(chiDesCaps.y, staDesCaps.u) annotation (Line(points={{-178,110},{-142,
          110}}, color={0,0,127}));
  connect(chiMinCaps.y, staMinCaps.u) annotation (Line(points={{-178,70},{-142,70}},
                 color={0,0,127}));
  connect(uChiAva, booToRea.u)
    annotation (Line(points={{-240,-40},{-202,-40}}, color={255,0,255}));
  connect(booToRea.y, sumNumAvaChi.u)
    annotation (Line(points={{-178,-40},{-142,-40}}, color={0,0,127}));
  connect(sumNumChi.y, sub2.u1) annotation (Line(points={{-118,20},{-100,20},{-100,
          -4},{-82,-4}}, color={0,0,127}));
  connect(sumNumAvaChi.y, sub2.u2) annotation (Line(points={{-118,-40},{-100.5,-40},
          {-100.5,-16},{-82,-16}}, color={0,0,127}));
  connect(sub2.y,lesThr. u)
    annotation (Line(points={{-58,-10},{-42,-10}},  color={0,0,127}));
  connect(lesThr.y, yAva) annotation (Line(points={{-18,-10},{60,-10},{60,-80},{
          240,-80}}, color={255,0,255}));
  connect(chiStaMat.y,pro. u2) annotation (Line(points={{-178,-160},{-160,-160},
          {-160,-126},{-142,-126}}, color={0,0,127}));
  connect(pro.y,matMax. u)
    annotation (Line(points={{-118,-120},{-102,-120}}, color={0,0,127}));
  connect(matMax.y,reaToInt. u)
    annotation (Line(points={{-78,-120},{-62,-120}}, color={0,0,127}));
  connect(reaToInt.y, yTyp) annotation (Line(points={{-38,-120},{240,-120}},
                      color={255,127,0}));
  connect(reaToInt.y, intToRea1.u) annotation (Line(points={{-38,-120},{-30,
          -120},{-30,-170},{-22,-170}},
                                 color={255,127,0}));
  connect(intToRea1.y, sort.u)
    annotation (Line(points={{2,-170},{18,-170}},  color={0,0,127}));
  connect(sort.y, reaToInt1.u)
    annotation (Line(points={{42,-170},{58,-170}},   color={0,0,127}));
  connect(reaToInt.y,intEqu. u1) annotation (Line(points={{-38,-120},{90,-120},{
          90,-150},{98,-150}},   color={255,127,0}));
  connect(reaToInt1.y,intEqu. u2) annotation (Line(points={{82,-170},{90,-170},{
          90,-158},{98,-158}},    color={255,127,0}));
  connect(mulAnd.y, assMes.u)
    annotation (Line(points={{162,-150},{178,-150}},  color={255,0,255}));
  connect(intEqu.y, mulAnd.u) annotation (Line(points={{122,-150},{138,-150}},
    color={255,0,255}));
  connect(staType.y, pro.u1) annotation (Line(points={{-178,-100},{-160,-100},{-160,
          -114},{-142,-114}}, color={0,0,127}));
  connect(staDesCaps.y, yDesCap) annotation (Line(points={{-118,110},{100,110},{
          100,20},{240,20}}, color={0,0,127}));
  connect(staMinCaps.y, yMinCap) annotation (Line(points={{-118,70},{80,70},{80,
          -20},{240,-20}}, color={0,0,127}));
  connect(oneVec.y, sumNumChi.u)
    annotation (Line(points={{-178,20},{-142,20}}, color={0,0,127}));
  connect(sort1.u, chiDesCaps.y) annotation (Line(points={{-142,170},{-160,
          170},{-160,110},{-178,110}}, color={0,0,127}));
  connect(sort1.y, sub1.u1) annotation (Line(points={{-118,170},{-110,170},{-110,
          176},{-102,176}}, color={0,0,127}));
  connect(chiDesCaps.y, sub1.u2) annotation (Line(points={{-178,110},{-160,110},
          {-160,150},{-110,150},{-110,164},{-102,164}}, color={0,0,127}));
  connect(sub1.y, multiMax.u)
    annotation (Line(points={{-78,170},{-62,170}}, color={0,0,127}));
  connect(multiMax.y, abs.u)
    annotation (Line(points={{-38,170},{-22,170}}, color={0,0,127}));
  connect(abs.y, lesThr1.u)
    annotation (Line(points={{2,170},{18,170}}, color={0,0,127}));
  connect(lesThr1.y, assMes1.u)
    annotation (Line(points={{42,170},{58,170}}, color={255,0,255}));
  annotation (defaultComponentName = "conf",
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
          extent={{-220,-200},{220,200}})),
Documentation(info="<html>
<p>
This subsequence is not directly specified in 1711 as it provides
a side calculation pertaining to generalization of the staging
sequences for any number of chillers and stages provided by the
user.
</p>
<p>
Given the staging matrix input parameter <code>staMat</code> the staging configurator calculates:
</p>
<ul>
<li>
Stage availability vector <code>yAva</code> from the chiller availability <code>uChiAva</code>
input vector according to RP-1711 March 2020 Draft section 5.2.4.13<br/>
</li>
<li>
Design stage capacity vector <code>yDesCap</code> from the design chiller capacity vector
input parameter <code>chiDesCap</code>.
The chillers need to be tagged in order of ascending chiller capacity if unequally sized. This is
according to 3.1.1.4.1 1711 March 2020 Draft, otherwise a warning is thrown.<br/>
</li>
<li>
Minimum stage capacity vector <code>yMinCap</code> from the chiller minimum cycling load input
parameter <code>chiMinCap</code> according to section 3.1.1.5.1, 1711 March 2020 Draft.<br/>
</li>
<li>
Stage type vector <code>yTyp</code> from the chiller type vector input parameter
<code>uChiTyp</code>, as listed in section 5.2.4.14, 1711 March 2020 Draft. Chiller types are defined in
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes</a>.<br/>
Stage type is, based on the chiller types in that stage and in the recommended staging order:<br/>
<ul>
<li>
Positive displacement, for any stage with only positive displacement chiller(s)
</li>
<li>
Variable speed centirfugal, for any stage with any variable speed chiller(s) and no constant speed chiller(s)
</li>
<li>
Constant speed centirfugal, for any stage with any constant speed centrifugal chiller(s)<br/>
</li>
</ul>
This stage type is used in the
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.PartLoadRatios\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.PartLoadRatios</a>
subsequence to determine the stage up and down part load ratios.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
June 7, 2019, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Configurator;
