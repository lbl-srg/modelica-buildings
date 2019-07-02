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
    annotation (Placement(transformation(extent={{-340,-100},{-300,-60}}),
        iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput u(
    final start=0,
    final min=0,
    final max=nSta) "Current chiller stage index"
    annotation (Placement(transformation(extent={{-340,60},{-300,100}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHig
    "Operating in the highest available stage"
    annotation (Placement(transformation(extent={{300,10},{320,30}}),
        iconTransformation(extent={{100,-40},{120,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLow
    "Operating in the lowest available stage"
    annotation (Placement(transformation(extent={{300,-110},{320,-90}}),
        iconTransformation(extent={{100,-60},{120,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChi[nChi]
    "Chillers index for a given stage"
    annotation (Placement(transformation(extent={{300,140},{320,160}}),
        iconTransformation(extent={{100,-90},{120,-70}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput uUp(
    final min=0,
    final max=nSta) "Next available stage up index"
    annotation (Placement(transformation(extent={{300,50},{320,70}}),
      iconTransformation(extent={{100,40},{120,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput uDown(
    final min=0,
    final max=nSta) "Next available stage down index"
    annotation (Placement(transformation(extent={{300,-70},{320,-50}}),
      iconTransformation(extent={{100,0},{120,20}})));

protected
  Buildings.Controls.OBC.CDL.Routing.IntegerReplicator intRep(
    final nout=nSta) "Signal replicator"
    annotation (Placement(transformation(extent={{-260,160},{-240,180}})));

  Buildings.Controls.OBC.CDL.Routing.IntegerReplicator intRep1[nSta](
    final nout=fill(nChi, nSta)) "Signal replicator"
    annotation (Placement(transformation(extent={{-200,160},{-180,180}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant chiExtMatr[nSta,nChi](
    final k=chiExtMat) "Matrix with stage index in each column"
    annotation (Placement(transformation(extent={{-200,110},{-180,130}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1[nSta,nChi]
    "Returns a matrix with all zeroes apart from ones in the row with the current stage index"
    annotation (Placement(transformation(extent={{-120,160},{-100,180}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant chiStaMatr[nSta,nChi](
    final k=staMat) "Staging matrix"
    annotation (Placement(transformation(extent={{-120,110},{-100,130}})));

  Buildings.Controls.OBC.CDL.Continuous.MatrixMax matMax(
    final nRow=nSta,
    final nCol=nChi,
    final rowMax=false) "Column-wise matrix maximum"
    annotation (Placement(transformation(extent={{80,140},{100,160}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold chiInSta[nChi](threshold=fill(0.5, nChi))
    "Identifies chillers designated to operate in a given stage"
    annotation (Placement(transformation(extent={{120,140},{140,160}})));

  Buildings.Controls.OBC.CDL.Integers.Product proInt[nSta,nChi]
    "Returns a matrix with all zeros apart from ones for any chiller staged in the current stage"
    annotation (Placement(transformation(extent={{0,140},{20,160}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nSta,nChi]
    "Type converter"
    annotation (Placement(transformation(extent={{-80,160},{-60,180}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea[nSta,nChi]
    "Type converter"
    annotation (Placement(transformation(extent={{40,140},{60,160}})));

  Buildings.Controls.OBC.CDL.Integers.Product proInt1[nSta]
    "Outputs index for any available stage that is above the current stage"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant staIndx[nSta](
    final k=staInd) "Stage index vector"
    annotation (Placement(transformation(extent={{-200,50},{-180,70}})));

  Buildings.Controls.OBC.CDL.Integers.Greater intGre[nSta]
    "Identifies stages that are above the current stage"
    annotation (Placement(transformation(extent={{-160,10},{-140,30}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1[nSta](
    final integerFalse=fill(nSta + 1, nSta))
    "Type converter that outputs a value larger than the stage count for any false input"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));

  Buildings.Controls.OBC.CDL.Logical.And and2[nSta]
    "Identifies any available stages above the current stage"
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiMin multiMin(final nin=nSta)
    "Minimum of a vector input"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1[nSta]
    "Type converter"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Type converter"
    annotation (Placement(transformation(extent={{80,30},{100,50}})));

  Buildings.Controls.OBC.CDL.Integers.Less intLes[nSta]
    "Identifies stages that are below the current stage"
    annotation (Placement(transformation(extent={{-160,-100},{-140,-80}})));

  Buildings.Controls.OBC.CDL.Logical.And and1[nSta]
    "Identifies any available stage below the current stage"
    annotation (Placement(transformation(extent={{-120,-120},{-100,-100}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt2[nSta]
    "Type converter that outputs zero for any false input"
    annotation (Placement(transformation(extent={{-80,-120},{-60,-100}})));

  Buildings.Controls.OBC.CDL.Integers.Product proInt2[nSta]
    "Outputs index for any available stage below the current stage"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea3[nSta]
    "Type converter"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiMax multiMax(final nin=nSta)
    "Maximum of a vector input"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Type converter"
    annotation (Placement(transformation(extent={{80,-90},{100,-70}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr(
    final threshold=nSta)
    "If the current stage is the highest available the input value equals the number of stages + 1"
    annotation (Placement(transformation(extent={{120,30},{140,50}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea5
    "Type converter"
    annotation (Placement(transformation(extent={{120,70},{140,90}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea4
    "Type converter"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi "Logical switch"
    annotation (Placement(transformation(extent={{200,30},{220,50}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Type converter"
    annotation (Placement(transformation(extent={{240,30},{260,50}})));

  Buildings.Controls.OBC.CDL.Integers.LessEqualThreshold intLesEquThr(final threshold=0)
    "If the current stage is the lowest available the input value equals 0"
    annotation (Placement(transformation(extent={{120,-90},{140,-70}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea2
    "Type converter"
    annotation (Placement(transformation(extent={{120,-130},{140,-110}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi1 "Logical switch"
    annotation (Placement(transformation(extent={{200,-90},{220,-70}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt3
    "Type converter"
    annotation (Placement(transformation(extent={{240,-90},{260,-70}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaAva(
    final allowOutOfRange=true,
    final outOfRangeValue=nSta + 1,
    final nin=nSta) "Extracts stage availability for the current stage"
    annotation (Placement(transformation(extent={{-180,-180},{-160,-160}})));

  Buildings.Controls.OBC.CDL.Utilities.Assert cheStaAva(
    final message="Unavailable stage passed as input.")
    "Checks if current stage is available"
    annotation (Placement(transformation(extent={{-100,-180},{-80,-160}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(final threshold=0.5)
    "Check if the current stage is available"
    annotation (Placement(transformation(extent={{-140,-180},{-120,-160}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nSta]
    "Type converter"
    annotation (Placement(transformation(extent={{-220,-180},{-200,-160}})));

  Buildings.Controls.OBC.CDL.Utilities.Assert cheStaAva1(
    final message="There are no available chiller stages. The staging cannot be performed.")
    "Checks if any stage is available"
    annotation (Placement(transformation(extent={{0,-180},{20,-160}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nu=nSta) "Logical or"
    annotation (Placement(transformation(extent={{-40,-180},{-20,-160}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=0)
    annotation (Placement(transformation(extent={{120,-50},{140,-30}})));

equation
  connect(intRep.y, intRep1.u)
    annotation (Line(points={{-239,170},{-202,170}}, color={255,127,0}));
  connect(intRep1.y, intEqu1.u1)
    annotation (Line(points={{-179,170},{-122,170}},   color={255,127,0}));
  connect(matMax.y, chiInSta.u)
    annotation (Line(points={{101,150},{118,150}},color={0,0,127}));
  connect(chiExtMatr.y, intEqu1.u2) annotation (Line(points={{-179,120},{-150,120},
          {-150,162},{-122,162}},   color={255,127,0}));
  connect(chiInSta.y, yChi)
    annotation (Line(points={{141,150},{310,150}}, color={255,0,255}));
  connect(proInt.y, intToRea.u)
    annotation (Line(points={{21,150},{38,150}},color={255,127,0}));
  connect(intToRea.y, matMax.u)
    annotation (Line(points={{61,150},{78,150}}, color={0,0,127}));
  connect(booToInt.y, proInt.u1) annotation (Line(points={{-59,170},{-20,170},{-20,
          156},{-2,156}},  color={255,127,0}));
  connect(intEqu1.y, booToInt.u)
    annotation (Line(points={{-99,170},{-82,170}}, color={255,0,255}));
  connect(chiStaMatr.y, proInt.u2) annotation (Line(points={{-99,120},{-20,120},
          {-20,144},{-2,144}},  color={255,127,0}));
  connect(staIndx.y, intGre.u1) annotation (Line(points={{-179,60},{-170,60},{-170,
          20},{-162,20}}, color={255,127,0}));
  connect(intRep.y, intGre.u2) annotation (Line(points={{-239,170},{-220,170},{-220,
          12},{-162,12}},
                 color={255,127,0}));
  connect(intGre.y, and2.u1) annotation (Line(points={{-139,20},{-130,20},{-130,
          10},{-122,10}},color={255,0,255}));
  connect(uAva, and2.u2) annotation (Line(points={{-320,-80},{-270,-80},{-270,2},
          {-122,2}}, color={255,0,255}));
  connect(staIndx.y, proInt1.u1) annotation (Line(points={{-179,60},{-50,60},{-50,
          46},{-42,46}}, color={255,127,0}));
  connect(booToInt1.y, proInt1.u2) annotation (Line(points={{-59,10},{-50,10},{-50,
          34},{-42,34}},  color={255,127,0}));
  connect(proInt1.y, intToRea1.u)
    annotation (Line(points={{-19,40},{-2,40}},  color={255,127,0}));
  connect(intToRea1.y, multiMin.u) annotation (Line(points={{21,40},{38,40}},
                                      color={0,0,127}));
  connect(intRep.y, intLes.u2) annotation (Line(points={{-239,170},{-220,170},{-220,
          -98},{-162,-98}},
               color={255,127,0}));
  connect(staIndx.y, intLes.u1) annotation (Line(points={{-179,60},{-170,60},{-170,
          -90},{-162,-90}},   color={255,127,0}));
  connect(uAva, and1.u2) annotation (Line(points={{-320,-80},{-270,-80},{-270,-118},
          {-122,-118}},
                      color={255,0,255}));
  connect(intLes.y, and1.u1) annotation (Line(points={{-139,-90},{-130,-90},{-130,
          -110},{-122,-110}},
                      color={255,0,255}));
  connect(proInt2.y, intToRea3.u)
    annotation (Line(points={{-19,-80},{-2,-80}},  color={255,127,0}));
  connect(intToRea3.y, multiMax.u) annotation (Line(points={{21,-80},{38,-80}},
    color={0,0,127}));
  connect(staIndx.y, proInt2.u1) annotation (Line(points={{-179,60},{-170,60},{-170,
          -74},{-42,-74}}, color={255,127,0}));
  connect(booToInt2.y, proInt2.u2) annotation (Line(points={{-59,-110},{-50,-110},
          {-50,-86},{-42,-86}},
                       color={255,127,0}));
  connect(multiMax.y, reaToInt1.u)
    annotation (Line(points={{61,-80},{78,-80}}, color={0,0,127}));
  connect(multiMin.y, reaToInt.u)
    annotation (Line(points={{61,40},{78,40}},     color={0,0,127}));
  connect(reaToInt.y, intGreThr.u)
    annotation (Line(points={{101,40},{118,40}},   color={255,127,0}));
  connect(intGreThr.y, swi.u2)
    annotation (Line(points={{141,40},{198,40}},   color={255,0,255}));
  connect(intToRea5.y, swi.u1) annotation (Line(points={{141,80},{180,80},{180,48},
          {198,48}},       color={0,0,127}));
  connect(reaToInt.y, intToRea4.u) annotation (Line(points={{101,40},{110,40},{110,
          0},{118,0}},        color={255,127,0}));
  connect(intToRea4.y, swi.u3) annotation (Line(points={{141,0},{180,0},{180,32},
          {198,32}},  color={0,0,127}));
  connect(uUp, reaToInt2.y) annotation (Line(points={{310,60},{280,60},{280,40},
          {261,40}},  color={255,127,0}));
  connect(swi.y, reaToInt2.u)
    annotation (Line(points={{221,40},{238,40}},   color={0,0,127}));
  connect(intGreThr.y, yHig) annotation (Line(points={{141,40},{160,40},{160,20},
          {310,20}},                       color={255,0,255}));
  connect(reaToInt3.y, uDown) annotation (Line(points={{261,-80},{280,-80},{280,
          -60},{310,-60}},
                     color={255,127,0}));
  connect(reaToInt1.y, intLesEquThr.u)
    annotation (Line(points={{101,-80},{118,-80}},
                                                 color={255,127,0}));
  connect(intLesEquThr.y, swi1.u2)
    annotation (Line(points={{141,-80},{198,-80}},
                                                 color={255,0,255}));
  connect(intToRea2.y, swi1.u3) annotation (Line(points={{141,-120},{188,-120},{
          188,-88},{198,-88}},
                         color={0,0,127}));
  connect(swi1.y, reaToInt3.u)
    annotation (Line(points={{221,-80},{238,-80}},
                                                 color={0,0,127}));
  connect(intLesEquThr.y, yLow) annotation (Line(points={{141,-80},{160,-80},{160,
          -100},{310,-100}}, color={255,0,255}));
  connect(greThr.y, cheStaAva.u)
    annotation (Line(points={{-119,-170},{-102,-170}}, color={255,0,255}));
  connect(extStaAva.y, greThr.u)
    annotation (Line(points={{-159,-170},{-142,-170}}, color={0,0,127}));
  connect(uAva, booToRea.u) annotation (Line(points={{-320,-80},{-270,-80},{-270,
          -170},{-222,-170}}, color={255,0,255}));
  connect(booToRea.y,extStaAva. u)
    annotation (Line(points={{-199,-170},{-182,-170}}, color={0,0,127}));
  connect(reaToInt1.y, intToRea2.u) annotation (Line(points={{101,-80},{108,-80},
          {108,-120},{118,-120}}, color={255,127,0}));
  connect(uAva, mulOr.u) annotation (Line(points={{-320,-80},{-270,-80},{-270,-140},
          {-50,-140},{-50,-170},{-42,-170}},                    color={255,0,255}));
  connect(mulOr.y, cheStaAva1.u)
    annotation (Line(points={{-18.3,-170},{-2,-170}},  color={255,0,255}));
  connect(con.y, swi1.u1) annotation (Line(points={{141,-40},{188,-40},{188,-72},
          {198,-72}},        color={0,0,127}));
  connect(u, intRep.u) annotation (Line(points={{-320,80},{-280,80},{-280,170},{
          -262,170}},                                                   color={255,127,0}));
  connect(u, intToRea5.u)
    annotation (Line(points={{-320,80},{118,80}},                       color={255,127,0}));
  connect(u,extStaAva. index) annotation (Line(points={{-320,80},{-280,80},{-280,
          -200},{-170,-200},{-170,-182}},
                  color={255,127,0}));
  connect(and2.y, booToInt1.u)
    annotation (Line(points={{-99,10},{-82,10}}, color={255,0,255}));
  connect(and1.y, booToInt2.u)
    annotation (Line(points={{-99,-110},{-82,-110}}, color={255,0,255}));
  annotation (defaultComponentName = "sta",
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
          extent={{-300,-220},{300,220}})),
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
