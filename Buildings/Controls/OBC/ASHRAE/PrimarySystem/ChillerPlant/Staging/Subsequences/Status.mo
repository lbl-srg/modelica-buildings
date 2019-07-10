within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block Status
  "Outputs current stage chiller index vector, next available lower and higher stage index and whether curent stage is the lowest and/or the highest available stage"

  parameter Integer nSta = 3
    "Number of stages";

  parameter Integer nChi = 2
    "Number of chillers";

  final parameter Integer staInd[nSta] = {i for i in 1:nSta}
    "Stage index vector";

  parameter Integer staMat[nSta, nChi] = {{1,0},{0,1},{1,1}}
    "Staging matrix with stages in rows and chillers in columns";

  final parameter Integer chiExtMat[nSta, nChi] = {j for i in 1:nChi, j in 1:nSta}
    "Matrix with stage index in each column";

  final parameter Integer lowDia[nSta, nSta] = {if i<=j then 1 else 0 for i in 1:nSta, j in 1:nSta}
    "Lower diagonal unit matrix";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uAva[nSta](
    final start = fill(true, nSta)) "Stage availability status"
    annotation (Placement(transformation(extent={{-460,-100},{-420,-60}}),
        iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput u(
    final min=0,
    final max=nSta) "Current chiller stage index"
    annotation (Placement(transformation(extent={{-460,60},{-420,100}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHig
    "Operating in the highest available stage"
    annotation (Placement(transformation(extent={{440,30},{460,50}}),
        iconTransformation(extent={{100,-40},{120,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLow
    "Operating in the lowest available stage"
    annotation (Placement(transformation(extent={{440,-90},{460,-70}}),
        iconTransformation(extent={{100,-60},{120,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChi[nChi]
    "Chillers index for the current stage"
    annotation (Placement(transformation(extent={{440,150},{460,170}}),
        iconTransformation(extent={{100,-90},{120,-70}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput y(
    final min=0,
    final max=nSta) "Current stage"
    annotation (Placement(transformation(extent={{440,-170},{460,-150}}),
        iconTransformation(extent={{100,80},{120,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yUp(
    final min=0,
    final max=nSta) "Next available stage up index"
    annotation (Placement(transformation(extent={{440,70},{460,90}}),
      iconTransformation(extent={{100,40},{120,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yDown(
    final min=0,
    final max=nSta) "Next available stage down index"
    annotation (Placement(transformation(extent={{440,-50},{460,-30}}),
      iconTransformation(extent={{100,0},{120,20}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Switch swi2
    annotation (Placement(transformation(extent={{100,-220},{120,-200}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi3
    annotation (Placement(transformation(extent={{360,70},{380,90}})));

  Buildings.Controls.OBC.CDL.Routing.IntegerReplicator intRep(
    final nout=nSta) "Signal replicator"
    annotation (Placement(transformation(extent={{-300,230},{-280,250}})));

  Buildings.Controls.OBC.CDL.Routing.IntegerReplicator intRep1[nSta](
    final nout=fill(nChi, nSta)) "Signal replicator"
    annotation (Placement(transformation(extent={{-180,230},{-160,250}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant chiExtMatr[nSta,nChi](
    final k=chiExtMat) "Matrix with stage index in each column"
    annotation (Placement(transformation(extent={{-180,180},{-160,200}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1[nSta,nChi]
    "Returns a matrix with all zeroes apart from ones in the row with the current stage index"
    annotation (Placement(transformation(extent={{-120,230},{-100,250}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant chiStaMatr[nSta,nChi](
    final k=staMat) "Staging matrix"
    annotation (Placement(transformation(extent={{-100,180},{-80,200}})));

  Buildings.Controls.OBC.CDL.Continuous.MatrixMax matMax(
    final nRow=nSta,
    final nCol=nChi,
    final rowMax=false) "Column-wise matrix maximum"
    annotation (Placement(transformation(extent={{60,210},{80,230}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold chiInSta[nChi](threshold=fill(0.5, nChi))
    "Identifies chillers designated to operate in a given stage"
    annotation (Placement(transformation(extent={{100,210},{120,230}})));

  Buildings.Controls.OBC.CDL.Integers.Product proInt[nSta,nChi]
    "Returns a matrix with all zeros apart from ones for any chiller staged in the current stage"
    annotation (Placement(transformation(extent={{-20,210},{0,230}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nSta,nChi]
    "Type converter"
    annotation (Placement(transformation(extent={{-80,230},{-60,250}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea[nSta,nChi]
    "Type converter"
    annotation (Placement(transformation(extent={{20,210},{40,230}})));

  Buildings.Controls.OBC.CDL.Integers.Product proInt1[nSta]
    "Outputs index for any available stage that is above the current stage"
    annotation (Placement(transformation(extent={{-60,100},{-40,120}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant staIndx[nSta](
    final k=staInd) "Stage index vector"
    annotation (Placement(transformation(extent={{-240,120},{-220,140}})));

  Buildings.Controls.OBC.CDL.Integers.Greater intGre[nSta]
    "Identifies stages that are above the current stage"
    annotation (Placement(transformation(extent={{-180,80},{-160,100}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1[nSta](
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

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt2[nSta]
    "Type converter that outputs zero for any false input"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  Buildings.Controls.OBC.CDL.Integers.Product proInt2[nSta]
    "Outputs index for any available stage below the current stage"
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
    final threshold=nSta)
    "If the current stage is the highest available the input value equals the number of stages + 1"
    annotation (Placement(transformation(extent={{100,100},{120,120}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea5
    "Type converter"
    annotation (Placement(transformation(extent={{100,140},{120,160}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea4
    "Type converter"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi "Logical switch"
    annotation (Placement(transformation(extent={{180,100},{200,120}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Type converter"
    annotation (Placement(transformation(extent={{220,100},{240,120}})));

  Buildings.Controls.OBC.CDL.Integers.LessEqualThreshold intLesEquThr(
    final threshold=0)
    "If the current stage is the lowest available the input value equals 0"
    annotation (Placement(transformation(extent={{100,-80},{120,-60}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea2
    "Type converter"
    annotation (Placement(transformation(extent={{100,-120},{120,-100}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi1 "Logical switch"
    annotation (Placement(transformation(extent={{180,-80},{200,-60}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt3
    "Type converter"
    annotation (Placement(transformation(extent={{220,-80},{240,-60}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaAva(
    final allowOutOfRange=false,
    final outOfRangeValue=nSta + 1,
    final nin=nSta) "Extracts stage availability for the current stage"
    annotation (Placement(transformation(extent={{-200,-160},{-180,-140}})));

  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr(
    final threshold=0.5)
    "Detects if the current stage becomes unavailable"
    annotation (Placement(transformation(extent={{-160,-160},{-140,-140}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nSta]
    "Type converter"
    annotation (Placement(transformation(extent={{-240,-160},{-220,-140}})));

  Buildings.Controls.OBC.CDL.Utilities.Assert cheStaAva1(
    final message="There are no available chiller stages. The staging cannot be performed.")
    "Checks if any stage is available"
    annotation (Placement(transformation(extent={{-340,-140},{-320,-120}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nu=nSta)    "Logical or"
    annotation (Placement(transformation(extent={{-380,-140},{-360,-120}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=0)
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea6 "Type converter"
    annotation (Placement(transformation(extent={{40,-240},{60,-220}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea7 "Type converter"
    annotation (Placement(transformation(extent={{40,-202},{60,-182}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt4
    "Type converter"
    annotation (Placement(transformation(extent={{220,-220},{240,-200}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea8 "Type converter"
    annotation (Placement(transformation(extent={{300,90},{320,110}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt5
    "Type converter"
    annotation (Placement(transformation(extent={{400,70},{420,90}})));

  Buildings.Controls.OBC.CDL.Logical.And and4
    "Identifies any available stages above the current stage"
    annotation (Placement(transformation(extent={{220,70},{240,90}})));

equation
  connect(intRep.y, intRep1.u)
    annotation (Line(points={{-279,240},{-182,240}}, color={255,127,0}));
  connect(intRep1.y, intEqu1.u1)
    annotation (Line(points={{-159,240},{-122,240}},   color={255,127,0}));
  connect(matMax.y, chiInSta.u)
    annotation (Line(points={{81,220},{98,220}},  color={0,0,127}));
  connect(chiExtMatr.y, intEqu1.u2) annotation (Line(points={{-159,190},{-140,
          190},{-140,232},{-122,232}},
                                    color={255,127,0}));
  connect(chiInSta.y, yChi)
    annotation (Line(points={{121,220},{200,220},{200,160},{450,160}},
                                                   color={255,0,255}));
  connect(proInt.y, intToRea.u)
    annotation (Line(points={{1,220},{18,220}}, color={255,127,0}));
  connect(intToRea.y, matMax.u)
    annotation (Line(points={{41,220},{58,220}}, color={0,0,127}));
  connect(booToInt.y, proInt.u1) annotation (Line(points={{-59,240},{-40,240},{
          -40,226},{-22,226}},
                           color={255,127,0}));
  connect(intEqu1.y, booToInt.u)
    annotation (Line(points={{-99,240},{-82,240}}, color={255,0,255}));
  connect(chiStaMatr.y, proInt.u2) annotation (Line(points={{-79,190},{-40,190},
          {-40,214},{-22,214}}, color={255,127,0}));
  connect(staIndx.y, intGre.u1) annotation (Line(points={{-219,130},{-200,130},
          {-200,90},{-182,90}},
                          color={255,127,0}));
  connect(intRep.y, intGre.u2) annotation (Line(points={{-279,240},{-260,240},{
          -260,82},{-182,82}},
                 color={255,127,0}));
  connect(intGre.y, and2.u1) annotation (Line(points={{-159,90},{-150,90},{-150,
          80},{-142,80}},color={255,0,255}));
  connect(uAva, and2.u2) annotation (Line(points={{-440,-80},{-280,-80},{-280,
          72},{-142,72}},
                     color={255,0,255}));
  connect(staIndx.y, proInt1.u1) annotation (Line(points={{-219,130},{-70,130},
          {-70,116},{-62,116}},
                         color={255,127,0}));
  connect(booToInt1.y, proInt1.u2) annotation (Line(points={{-79,80},{-70,80},{
          -70,104},{-62,104}},
                          color={255,127,0}));
  connect(proInt1.y, intToRea1.u)
    annotation (Line(points={{-39,110},{-22,110}},
                                                 color={255,127,0}));
  connect(intToRea1.y, multiMin.u) annotation (Line(points={{1,110},{18,110}},
                                      color={0,0,127}));
  connect(intRep.y, intLes.u2) annotation (Line(points={{-279,240},{-260,240},{
          -260,-78},{-182,-78}},
               color={255,127,0}));
  connect(staIndx.y, intLes.u1) annotation (Line(points={{-219,130},{-200,130},
          {-200,-70},{-182,-70}},
                              color={255,127,0}));
  connect(uAva, and1.u2) annotation (Line(points={{-440,-80},{-280,-80},{-280,
          -98},{-142,-98}},
                      color={255,0,255}));
  connect(intLes.y, and1.u1) annotation (Line(points={{-159,-70},{-150,-70},{
          -150,-90},{-142,-90}},
                      color={255,0,255}));
  connect(proInt2.y, intToRea3.u)
    annotation (Line(points={{-39,-70},{-22,-70}}, color={255,127,0}));
  connect(intToRea3.y, multiMax.u) annotation (Line(points={{1,-70},{18,-70}},
    color={0,0,127}));
  connect(staIndx.y, proInt2.u1) annotation (Line(points={{-219,130},{-200,130},
          {-200,-40},{-70,-40},{-70,-64},{-62,-64}},
                           color={255,127,0}));
  connect(booToInt2.y, proInt2.u2) annotation (Line(points={{-79,-90},{-70,-90},
          {-70,-76},{-62,-76}},
                       color={255,127,0}));
  connect(multiMax.y, reaToInt1.u)
    annotation (Line(points={{41,-70},{58,-70}}, color={0,0,127}));
  connect(multiMin.y, reaToInt.u)
    annotation (Line(points={{41,110},{58,110}},   color={0,0,127}));
  connect(reaToInt.y, intGreThr.u)
    annotation (Line(points={{81,110},{98,110}},   color={255,127,0}));
  connect(intGreThr.y, swi.u2)
    annotation (Line(points={{121,110},{178,110}}, color={255,0,255}));
  connect(intToRea5.y, swi.u1) annotation (Line(points={{121,150},{160,150},{
          160,118},{178,118}},
                           color={0,0,127}));
  connect(reaToInt.y, intToRea4.u) annotation (Line(points={{81,110},{90,110},{
          90,70},{98,70}},    color={255,127,0}));
  connect(intToRea4.y, swi.u3) annotation (Line(points={{121,70},{160,70},{160,
          102},{178,102}},
                      color={0,0,127}));
  connect(swi.y, reaToInt2.u)
    annotation (Line(points={{201,110},{218,110}}, color={0,0,127}));
  connect(intGreThr.y, yHig) annotation (Line(points={{121,110},{140,110},{140,
          40},{450,40}},                   color={255,0,255}));
  connect(reaToInt3.y,yDown)  annotation (Line(points={{241,-70},{340,-70},{340,
          -40},{450,-40}},
                     color={255,127,0}));
  connect(reaToInt1.y, intLesEquThr.u)
    annotation (Line(points={{81,-70},{98,-70}}, color={255,127,0}));
  connect(intLesEquThr.y, swi1.u2)
    annotation (Line(points={{121,-70},{178,-70}},
                                                 color={255,0,255}));
  connect(intToRea2.y, swi1.u3) annotation (Line(points={{121,-110},{168,-110},
          {168,-78},{178,-78}},
                         color={0,0,127}));
  connect(swi1.y, reaToInt3.u)
    annotation (Line(points={{201,-70},{218,-70}},
                                                 color={0,0,127}));
  connect(intLesEquThr.y, yLow) annotation (Line(points={{121,-70},{140,-70},{
          140,-90},{340,-90},{340,-80},{450,-80}},
                             color={255,0,255}));
  connect(uAva, booToRea.u) annotation (Line(points={{-440,-80},{-280,-80},{
          -280,-150},{-242,-150}},
                              color={255,0,255}));
  connect(reaToInt1.y, intToRea2.u) annotation (Line(points={{81,-70},{88,-70},
          {88,-110},{98,-110}},   color={255,127,0}));
  connect(con.y, swi1.u1) annotation (Line(points={{121,-30},{168,-30},{168,-62},
          {178,-62}},        color={0,0,127}));
  connect(and2.y, booToInt1.u)
    annotation (Line(points={{-119,80},{-102,80}},
                                                 color={255,0,255}));
  connect(lesThr.y, swi2.u2) annotation (Line(points={{-139,-150},{0,-150},{0,
          -210},{98,-210}},
                       color={255,0,255}));
  connect(reaToInt3.y, intToRea7.u) annotation (Line(points={{241,-70},{260,-70},
          {260,-140},{20,-140},{20,-192},{38,-192}},    color={255,127,0}));
  connect(swi2.y, reaToInt4.u)
    annotation (Line(points={{121,-210},{218,-210}}, color={0,0,127}));
  connect(reaToInt4.y, y)
    annotation (Line(points={{241,-210},{360,-210},{360,-160},{450,-160}},
                                                     color={255,127,0}));
  connect(reaToInt2.y, intToRea8.u) annotation (Line(points={{241,110},{260,110},
          {260,100},{298,100}}, color={255,127,0}));
  connect(intToRea8.y, swi3.u3) annotation (Line(points={{321,100},{340,100},{
          340,72},{358,72}},
                         color={0,0,127}));
  connect(swi3.y, reaToInt5.u)
    annotation (Line(points={{381,80},{398,80}}, color={0,0,127}));
  connect(reaToInt5.y, yUp)
    annotation (Line(points={{421,80},{450,80}}, color={255,127,0}));
  connect(intToRea6.y, swi2.u3) annotation (Line(points={{61,-230},{80,-230},{
          80,-218},{98,-218}},   color={0,0,127}));
  connect(intToRea7.y, swi2.u1) annotation (Line(points={{61,-192},{80,-192},{
          80,-202},{98,-202}},   color={0,0,127}));
  connect(intGreThr.y, and4.u1) annotation (Line(points={{121,110},{150,110},{
          150,80},{218,80}},      color={255,0,255}));
  connect(lesThr.y, and4.u2) annotation (Line(points={{-139,-150},{210,-150},{
          210,72},{218,72}},                                   color={255,0,255}));
  connect(and4.y, swi3.u2) annotation (Line(points={{241,80},{358,80}},
                             color={255,0,255}));
  connect(yUp, yUp)
    annotation (Line(points={{450,80},{450,80}}, color={255,127,0}));
  connect(swi2.y, swi3.u1) annotation (Line(points={{121,-210},{200,-210},{200,
          -170},{348,-170},{348,88},{358,88}}, color={0,0,127}));
  connect(uAva, mulOr.u) annotation (Line(points={{-440,-80},{-400,-80},{-400,-130},
          {-392,-130},{-392,-130},{-382,-130}},                    color={255,0,
          255}));
  connect(mulOr.y, cheStaAva1.u)
    annotation (Line(points={{-358.3,-130},{-342,-130}}, color={255,0,255}));
  connect(booToRea.y, extStaAva.u)
    annotation (Line(points={{-219,-150},{-202,-150}}, color={0,0,127}));
  connect(extStaAva.y, lesThr.u)
    annotation (Line(points={{-179,-150},{-162,-150}}, color={0,0,127}));
  connect(and1.y, booToInt2.u)
    annotation (Line(points={{-119,-90},{-102,-90}}, color={255,0,255}));
  connect(u, intRep.u) annotation (Line(points={{-440,80},{-320,80},{-320,240},
          {-302,240}}, color={255,127,0}));
  connect(u, intToRea5.u) annotation (Line(points={{-440,80},{-300,80},{-300,
          160},{80,160},{80,150},{98,150}}, color={255,127,0}));
  connect(u, intToRea6.u) annotation (Line(points={{-440,80},{-300,80},{-300,
          -230},{38,-230}}, color={255,127,0}));
  connect(u, extStaAva.index) annotation (Line(points={{-440,80},{-300,80},{
          -300,-180},{-190,-180},{-190,-162}}, color={255,127,0}));
  annotation (Icon(graphics={
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
          extent={{-420,-280},{440,280}})),
Documentation(info="<html>
<p>
Based on the current stage <code>u</code> and stage availability vector <code>uAva</code> the sequence outputs:
</p>
<ul>
<li>
Vector of chillers operating in the current stage <code>yChi</code>
</li>
<li>
Index of the first available higher stage <code>yUp</code> and the first available lower stage <code>yDown</code>
</li>
<li>
Boolean indicators whether current operating stage <code>u</code> is the highest <code>yHig</code> and/or the lowest <code>yLow</code> stage
</li>
</ul>
<p>
The sequences are implemented according to RP-1711 Draft 4 5.2.4.11. 3.
</p>
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
