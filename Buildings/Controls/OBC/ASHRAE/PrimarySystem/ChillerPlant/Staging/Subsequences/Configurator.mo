within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block Configurator "Configures chiller staging"

  parameter Integer nSta = 3
    "Number of chiller stages";

  parameter Integer nChi = 2
    "Number of chillers";

  parameter Modelica.SIunits.Power chiNomCap[nChi]
    "Nominal chiller capacities";

  parameter Modelica.SIunits.Power chiMinCap[nChi]
    "Chiller unload capacities";

  parameter Integer chiTyp[nChi] = {
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.StageTypes.posDis,
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.StageTypes.vsdCen}
    "Chiller type";

  parameter Integer staMat[nSta, nChi] = {{1,0},{0,1},{1,1}}
    "Staging matrix with stages in rows and chillers in columns";

  final parameter Integer chiTypMat[nSta, nChi] = {chiTyp[i] for i in 1:nChi, j in 1:nSta}
    "Chiller type array expanded to allow for element-wise multiplication with the staging matrix";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiAva[nChi]
    "Chiller availability status"
    annotation (Placement(transformation(extent={{-260,-20},{-220,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yAva[nSta]
    "Stage availability status array"
    annotation (Placement(transformation(extent={{220,-50},{240,-30}}),
      iconTransformation(extent={{100,-80},{120,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yTyp[nSta](
    final max=nSta) "Chiller stage types"
    annotation (Placement(transformation(extent={{220,-90},{240,-70}}),
      iconTransformation(extent={{100,-40},{120,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yNomCap[nSta](
    final unit="W",
    final quantity="Power") "Stage nominal capacities"
    annotation (Placement(transformation(extent={{220,50},{240,70}}),
      iconTransformation(extent={{100,60},{120,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMinCap[nSta](
    final unit="W",
    final quantity="Power") "Unload stage capacities"
    annotation (Placement(transformation(extent={{220,10},{240,30}}),
      iconTransformation(extent={{100,20},{120,40}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiNomCaps[nChi](
    final k=chiNomCap) "Array of nominal chiller capacities"
    annotation (Placement(transformation(extent={{-200,140},{-180,160}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiMinCaps[nChi](
    final k=chiMinCap) "Array of chiller unload capacities"
    annotation (Placement(transformation(extent={{-200,100},{-180,120}})));

  Buildings.Controls.OBC.CDL.Continuous.MatrixGain staNomCaps(
    final K=staMat) ""
    annotation (Placement(transformation(extent={{-140,140},{-120,160}})));

  Buildings.Controls.OBC.CDL.Continuous.MatrixGain staMinCaps(
    final K=staMat) ""
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));

  Buildings.Controls.OBC.CDL.Continuous.MatrixGain staMinCaps1(
    final K=staMat) ""
    annotation (Placement(transformation(extent={{-140,50},{-120,70}})));

  Buildings.Controls.OBC.CDL.Continuous.MatrixGain staMinCaps2(
    final K=staMat) ""
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oneVec[nChi](
    final k=fill(1, nSta))
    "All chillers available"
    annotation (Placement(transformation(extent={{-200,50},{-180,70}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nChi]
    "Type converter"
    annotation (Placement(transformation(extent={{-200,-10},{-180,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add2[nSta](
    final k2=fill(-1, nSta)) "Sum"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr[nSta](
    final threshold=fill(0.5, nSta))
    "Checks if the number of chillers available in each stage equals the design number of chillers"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiStaMat[nSta,nChi](
    final k=staMat) "Staging matrix"
    annotation (Placement(transformation(extent={{-200,-140},{-180,-120}})));

  CDL.Continuous.Sources.Constant staType[nSta,nChi](
    final k=chiTypMat) "Chiller stage type in a matrix form"
    annotation (Placement(transformation(extent={{-200,-80},{-180,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Product pro[nSta,nChi]
    "Product"
    annotation (Placement(transformation(extent={{-140,-100},{-120,-80}})));

  Buildings.Controls.OBC.CDL.Continuous.MatrixMax matMax(
    final nRow=nSta,
    final nCol=nChi)
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt[nSta]
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sort sort(
    final nin=nSta)
    annotation (Placement(transformation(extent={{20,-140},{40,-120}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1[nSta]
    annotation (Placement(transformation(extent={{-20,-140},{0,-120}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1[nSta]
    annotation (Placement(transformation(extent={{60,-140},{80,-120}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[nSta]
    annotation (Placement(transformation(extent={{100,-120},{120,-100}})));

  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(
    final message="Chillers are not staged according to G36 recommendation. If possible, please stage any positive displacement machines first, any variable speed centrifugal next and any constant speed centrifugal last.")
    annotation (Placement(transformation(extent={{180,-120},{200,-100}})));

  CDL.Logical.MultiAnd mulAnd(
    final nu=nSta)
    annotation (Placement(transformation(extent={{140,-120},{160,-100}})));

equation
  connect(chiNomCaps.y, staNomCaps.u) annotation (Line(points={{-179,150},{-142,
          150}},                color={0,0,127}));
  connect(oneVec.y, staMinCaps1.u)
    annotation (Line(points={{-179,60},{-142,60}}, color={0,0,127}));
  connect(chiMinCaps.y, staMinCaps.u) annotation (Line(points={{-179,110},{-142,
          110}},                         color={0,0,127}));
  connect(uChiAva, booToRea.u)
    annotation (Line(points={{-240,0},{-202,0}}, color={255,0,255}));
  connect(booToRea.y, staMinCaps2.u) annotation (Line(points={{-179,0},{-142,0}},
                                    color={0,0,127}));
  connect(staMinCaps1.y, add2.u1) annotation (Line(points={{-119,60},{-100,60},{
          -100,36},{-82,36}}, color={0,0,127}));
  connect(staMinCaps2.y, add2.u2) annotation (Line(points={{-119,0},{-100.5,0},{
          -100.5,24},{-82,24}},  color={0,0,127}));
  connect(add2.y,lesThr. u)
    annotation (Line(points={{-59,30},{-42,30}}, color={0,0,127}));
  connect(lesThr.y, yAva) annotation (Line(points={{-19,30},{60,30},{60,-40},{230,
          -40}},color={255,0,255}));
  connect(chiStaMat.y,pro. u2) annotation (Line(points={{-179,-130},{-160,-130},
          {-160,-96},{-142,-96}},   color={0,0,127}));
  connect(pro.y,matMax. u)
    annotation (Line(points={{-119,-90},{-102,-90}},
                                               color={0,0,127}));
  connect(matMax.y,reaToInt. u)
    annotation (Line(points={{-79,-90},{-62,-90}},
                                               color={0,0,127}));
  connect(reaToInt.y, yTyp) annotation (Line(points={{-39,-90},{90,-90},{90,-80},
          {230,-80}}, color={255,127,0}));
  connect(reaToInt.y, intToRea1.u) annotation (Line(points={{-39,-90},{-28,-90},
          {-28,-130},{-22,-130}},
                                color={255,127,0}));
  connect(intToRea1.y, sort.u)
    annotation (Line(points={{1,-130},{18,-130}},  color={0,0,127}));
  connect(sort.y, reaToInt1.u)
    annotation (Line(points={{41,-130},{58,-130}},   color={0,0,127}));
  connect(reaToInt.y,intEqu. u1) annotation (Line(points={{-39,-90},{90,-90},{90,
          -110},{98,-110}},      color={255,127,0}));
  connect(reaToInt1.y,intEqu. u2) annotation (Line(points={{81,-130},{90,-130},{
          90,-118},{98,-118}},    color={255,127,0}));
  connect(mulAnd.y, assMes.u)
    annotation (Line(points={{161.7,-110},{178,-110}},color={255,0,255}));
  connect(intEqu.y, mulAnd.u) annotation (Line(points={{121,-110},{138,-110}},
    color={255,0,255}));
  connect(staType.y, pro.u1) annotation (Line(points={{-179,-70},{-160,-70},{-160,
          -84},{-142,-84}},color={0,0,127}));
  connect(staNomCaps.y, yNomCap) annotation (Line(points={{-119,150},{100,150},{
          100,60},{230,60}}, color={0,0,127}));
  connect(staMinCaps.y, yMinCap) annotation (Line(points={{-119,110},{80,110},{80,
          20},{230,20}}, color={0,0,127}));
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
The staging configurator calculates:
<ul>
<li>
Stage availability vector <code>yAva</code>, based on the chiller availability <code>uChiAva</code> input and the staging matrix input parameter <code>staMat</code> 
</li>
<li>
Nominal stage capacity vector <code>yNomCap</code>, based on the chiller capacity input parameter <code>chiNomCap</code>
</li>
<li>
Minimum stage capacity vector <code>yMinCap</code>, based on the chiller capacity input parameter <code>chiMinCap</code>
</li>
<li>
Stage type vector <code>yMinCap</code>, based on the chiller type input parameter <code>uChiTyp</code> and the staging matrix input parameter <code>staMat</code>
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
