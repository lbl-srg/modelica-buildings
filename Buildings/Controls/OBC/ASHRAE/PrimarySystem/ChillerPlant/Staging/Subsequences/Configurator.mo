within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block Configurator "Configures chiller staging"

  parameter Integer nSta = 3
    "Number of chiller stages";

  parameter Integer nChi = 2
    "Number of chillers";

  parameter Modelica.SIunits.Power chiDesCap[nChi]
    "Design chiller capacities";

  parameter Modelica.SIunits.Power chiMinCap[nChi]
    "Chiller unload capacities";

  parameter Integer chiTyp[nChi]={
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerTypes.positiveDisplacement,
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerTypes.variableSpeedCentrifugal}
    "Chiller type";

  parameter Integer staMat[nSta, nChi] = {{1,0},{0,1},{1,1}}
    "Staging matrix with stage as row index and chiller as column index";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiAva[nChi]
    "Chiller availability status vector"
    annotation (Placement(transformation(extent={{-260,-20},{-220,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yAva[nSta]
    "Stage availability status vector"
    annotation (Placement(transformation(extent={{220,-60},{260,-20}}),
        iconTransformation(extent={{100,-60},{140,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yTyp[nSta](
    final max=fill(nSta, nSta)) "Chiller stage types vector"
    annotation (Placement(transformation(extent={{220,-100},{260,-60}}),
        iconTransformation(extent={{100,-100},{140,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDesCap[nSta](
    final unit=fill("W", nSta),
    final quantity=fill("Power", nSta)) "Stage design capacities vector"
    annotation (Placement(transformation(extent={{220,40},{260,80}}),
        iconTransformation(extent={{100,60},{140,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMinCap[nSta](
    final unit=fill("W", nSta),
    final quantity=fill("Power", nSta)) "Unload stage capacities vector"
    annotation (Placement(transformation(extent={{220,0},{260,40}}),
        iconTransformation(extent={{100,20},{140,60}})));

protected
  final parameter Integer chiTypMat[nSta, nChi] = {chiTyp[i] for i in 1:nChi, j in 1:nSta}
    "Chiller type array expanded to allow for element-wise multiplication with the staging matrix";

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiDesCaps[nChi](
    final k=chiDesCap) "Design chiller capacities vector"
    annotation (Placement(transformation(extent={{-200,140},{-180,160}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiMinCaps[nChi](
    final k=chiMinCap) "Chiller unload capacities vector"
    annotation (Placement(transformation(extent={{-200,100},{-180,120}})));

  Buildings.Controls.OBC.CDL.Continuous.MatrixGain staDesCaps(
    final K=staMat) "Matrix gain for design capacities"
    annotation (Placement(transformation(extent={{-140,140},{-120,160}})));

  Buildings.Controls.OBC.CDL.Continuous.MatrixGain staMinCaps(
    final K=staMat) "Matrix gain from minimal capacities"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));

  Buildings.Controls.OBC.CDL.Continuous.MatrixGain sumNumChi(
    final K=staMat)
    "Outputs the total chiller count per stage vector"
    annotation (Placement(transformation(extent={{-140,50},{-120,70}})));

  Buildings.Controls.OBC.CDL.Continuous.MatrixGain sumNumAvaChi(
    final K=staMat)
    "Outputs the available chiller count per stage vector"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oneVec[nChi](
    final k=fill(1, nChi)) "Mocks a case with all chillers available"
    annotation (Placement(transformation(extent={{-200,50},{-180,70}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nChi]
    "Type converter"
    annotation (Placement(transformation(extent={{-200,-10},{-180,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add2[nSta](
    final k2=fill(-1, nSta))
    "Subtracts count of available chillers from the design count, at each stage"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr[nSta](
    final threshold=fill(0.5, nSta))
    "Checks if the count of available chillers in each stage equals the design count"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiStaMat[nSta,nChi](
    final k=staMat) "Staging matrix"
    annotation (Placement(transformation(extent={{-200,-130},{-180,-110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staType[nSta,nChi](
    final k=chiTypMat) "Chiller stage type matrix"
    annotation (Placement(transformation(extent={{-200,-70},{-180,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Product pro[nSta,nChi]
    "Element-wise product"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));

  Buildings.Controls.OBC.CDL.Continuous.MatrixMax matMax(
    final nRow=nSta,
    final nCol=nChi) "Row-wise matrix maximum"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt[nSta]
    "Type converter"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sort sort(
    final nin=nSta) "Vector sort"
    annotation (Placement(transformation(extent={{20,-140},{40,-120}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1[nSta]
    "Type converter"
    annotation (Placement(transformation(extent={{-20,-140},{0,-120}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1[nSta]
    "Type converter"
    annotation (Placement(transformation(extent={{60,-140},{80,-120}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[nSta] "Integer equality"
    annotation (Placement(transformation(extent={{100,-120},{120,-100}})));

  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(
    final message="Chillers are not staged in a recommended order. 
    If possible, please stage any positive displacement machines first, 
    any variable speed centrifugal next and any constant speed centrifugal last.")
    "Staging type order assertion"
    annotation (Placement(transformation(extent={{180,-120},{200,-100}})));

  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(
    final nu=nSta) "Logical and with a vector input"
    annotation (Placement(transformation(extent={{140,-120},{160,-100}})));

equation
  connect(chiDesCaps.y, staDesCaps.u) annotation (Line(points={{-178,150},{-142,
          150}}, color={0,0,127}));
  connect(chiMinCaps.y, staMinCaps.u) annotation (Line(points={{-178,110},{-142,
          110}}, color={0,0,127}));
  connect(uChiAva, booToRea.u)
    annotation (Line(points={{-240,0},{-202,0}}, color={255,0,255}));
  connect(booToRea.y, sumNumAvaChi.u)
    annotation (Line(points={{-178,0},{-142,0}}, color={0,0,127}));
  connect(sumNumChi.y, add2.u1) annotation (Line(points={{-118,60},{-100,60},{-100,
          36},{-82,36}}, color={0,0,127}));
  connect(sumNumAvaChi.y, add2.u2) annotation (Line(points={{-118,0},{-100.5,0},
          {-100.5,24},{-82,24}}, color={0,0,127}));
  connect(add2.y,lesThr. u)
    annotation (Line(points={{-58,30},{-42,30}}, color={0,0,127}));
  connect(lesThr.y, yAva) annotation (Line(points={{-18,30},{60,30},{60,-40},{240,
          -40}},color={255,0,255}));
  connect(chiStaMat.y,pro. u2) annotation (Line(points={{-178,-120},{-160,-120},
          {-160,-86},{-142,-86}},   color={0,0,127}));
  connect(pro.y,matMax. u)
    annotation (Line(points={{-118,-80},{-102,-80}}, color={0,0,127}));
  connect(matMax.y,reaToInt. u)
    annotation (Line(points={{-78,-80},{-62,-80}}, color={0,0,127}));
  connect(reaToInt.y, yTyp) annotation (Line(points={{-38,-80},{240,-80}},
                      color={255,127,0}));
  connect(reaToInt.y, intToRea1.u) annotation (Line(points={{-38,-80},{-28,-80},
          {-28,-130},{-22,-130}},color={255,127,0}));
  connect(intToRea1.y, sort.u)
    annotation (Line(points={{2,-130},{18,-130}},  color={0,0,127}));
  connect(sort.y, reaToInt1.u)
    annotation (Line(points={{42,-130},{58,-130}},   color={0,0,127}));
  connect(reaToInt.y,intEqu. u1) annotation (Line(points={{-38,-80},{90,-80},{90,
          -110},{98,-110}},      color={255,127,0}));
  connect(reaToInt1.y,intEqu. u2) annotation (Line(points={{82,-130},{90,-130},{
          90,-118},{98,-118}},    color={255,127,0}));
  connect(mulAnd.y, assMes.u)
    annotation (Line(points={{162,-110},{178,-110}},  color={255,0,255}));
  connect(intEqu.y, mulAnd.u) annotation (Line(points={{122,-110},{138,-110}},
    color={255,0,255}));
  connect(staType.y, pro.u1) annotation (Line(points={{-178,-60},{-160,-60},{-160,
          -74},{-142,-74}},color={0,0,127}));
  connect(staDesCaps.y, yDesCap) annotation (Line(points={{-118,150},{100,150},{
          100,60},{240,60}}, color={0,0,127}));
  connect(staMinCaps.y, yMinCap) annotation (Line(points={{-118,110},{80,110},{80,
          20},{240,20}}, color={0,0,127}));
  connect(oneVec.y, sumNumChi.u)
    annotation (Line(points={{-178,60},{-142,60}}, color={0,0,127}));
  annotation (defaultComponentName = "conf",
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
          extent={{-220,-180},{220,180}})),
Documentation(info="<html>
<p>
Given the staging matrix input parameter <code>staMat</code> the staging configurator calculates:
</p>
<ul>
<li>
Stage availability vector <code>yAva</code> from the chiller availability <code>uChiAva</code> 
input vector according to RP-1711 Draft 4 section 5.2.4.9.
</li>
<li>
Design stage capacity vector <code>yDesCap</code> from the design chiller capacity vector 
input parameter <code>chiDesCap</code> according to RP-1711 Draft 4 section 3.1.1.4., 2.
</li>
<li>
Minimum stage capacity vector <code>yMinCap</code> from the chiller capacity vector input 
parameter <code>chiMinCap</code> according to RP-1711 Draft 4 section 3.1.1.5.
</li>
<li>
Stage type vector <code>yTyp</code> from the chiller type vector input parameter 
<code>uChiTyp</code> according to RP-1711 Draft 4 section 5.2.4.10.
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
