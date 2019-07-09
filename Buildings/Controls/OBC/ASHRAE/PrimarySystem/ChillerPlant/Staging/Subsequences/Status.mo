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
    annotation (Placement(transformation(extent={{-500,-100},{-460,-60}}),
        iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput u(
    final start=0,
    final min=0,
    final max=nSta) "Current chiller stage index"
    annotation (Placement(transformation(extent={{-500,60},{-460,100}}),
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
    annotation (Placement(transformation(extent={{440,160},{460,180}}),
        iconTransformation(extent={{100,-90},{120,-70}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput y(
    final min=0,
    final max=nSta) "Current stage"
    annotation (Placement(transformation(extent={{440,-170},{460,-150}}),
        iconTransformation(extent={{100,40},{120,60}})));

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
    annotation (Placement(transformation(extent={{180,-210},{200,-190}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi3
    annotation (Placement(transformation(extent={{360,68},{380,88}})));

  Buildings.Controls.OBC.CDL.Integers.Max maxInt
    annotation (Placement(transformation(extent={{-320,30},{-300,50}})));

  Buildings.Controls.OBC.CDL.Integers.Min minInt
    annotation (Placement(transformation(extent={{-360,60},{-340,80}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant maxLim(
    final k=nSta) "Maximum stage"
    annotation (Placement(transformation(extent={{-400,40},{-380,60}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant minLim(
    final k=0) "Minimum stage"
    annotation (Placement(transformation(extent={{-360,20},{-340,40}})));

  Buildings.Controls.OBC.CDL.Routing.IntegerReplicator intRep(
    final nout=nSta) "Signal replicator"
    annotation (Placement(transformation(extent={{-260,238},{-240,258}})));

  Buildings.Controls.OBC.CDL.Routing.IntegerReplicator intRep1[nSta](
    final nout=fill(nChi, nSta)) "Signal replicator"
    annotation (Placement(transformation(extent={{-180,238},{-160,258}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant chiExtMatr[nSta,nChi](
    final k=chiExtMat) "Matrix with stage index in each column"
    annotation (Placement(transformation(extent={{-180,188},{-160,208}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1[nSta,nChi]
    "Returns a matrix with all zeroes apart from ones in the row with the current stage index"
    annotation (Placement(transformation(extent={{-120,238},{-100,258}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant chiStaMatr[nSta,nChi](
    final k=staMat) "Staging matrix"
    annotation (Placement(transformation(extent={{-120,188},{-100,208}})));

  Buildings.Controls.OBC.CDL.Continuous.MatrixMax matMax(
    final nRow=nSta,
    final nCol=nChi,
    final rowMax=false) "Column-wise matrix maximum"
    annotation (Placement(transformation(extent={{60,218},{80,238}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold chiInSta[nChi](threshold=fill(0.5, nChi))
    "Identifies chillers designated to operate in a given stage"
    annotation (Placement(transformation(extent={{100,218},{120,238}})));

  Buildings.Controls.OBC.CDL.Integers.Product proInt[nSta,nChi]
    "Returns a matrix with all zeros apart from ones for any chiller staged in the current stage"
    annotation (Placement(transformation(extent={{-20,218},{0,238}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nSta,nChi]
    "Type converter"
    annotation (Placement(transformation(extent={{-80,238},{-60,258}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea[nSta,nChi]
    "Type converter"
    annotation (Placement(transformation(extent={{20,218},{40,238}})));

  Buildings.Controls.OBC.CDL.Integers.Product proInt1[nSta]
    "Outputs index for any available stage that is above the current stage"
    annotation (Placement(transformation(extent={{-60,108},{-40,128}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant staIndx[nSta](
    final k=staInd) "Stage index vector"
    annotation (Placement(transformation(extent={{-220,128},{-200,148}})));

  Buildings.Controls.OBC.CDL.Integers.Greater intGre[nSta]
    "Identifies stages that are above the current stage"
    annotation (Placement(transformation(extent={{-180,88},{-160,108}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1[nSta](
    final integerFalse=fill(nSta + 1, nSta))
    "Type converter that outputs a value larger than the stage count for any false input"
    annotation (Placement(transformation(extent={{-100,78},{-80,98}})));

  Buildings.Controls.OBC.CDL.Logical.And and2[nSta]
    "Identifies any available stages above the current stage"
    annotation (Placement(transformation(extent={{-140,78},{-120,98}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiMin multiMin(
    final nin=nSta)
    "Minimum of a vector input"
    annotation (Placement(transformation(extent={{20,108},{40,128}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1[nSta]
    "Type converter"
    annotation (Placement(transformation(extent={{-20,108},{0,128}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Type converter"
    annotation (Placement(transformation(extent={{60,108},{80,128}})));

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
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea3[nSta]
    "Type converter"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiMax multiMax(
    final nin=nSta)
    "Maximum of a vector input"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Type converter"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr(
    final threshold=nSta)
    "If the current stage is the highest available the input value equals the number of stages + 1"
    annotation (Placement(transformation(extent={{100,108},{120,128}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea5
    "Type converter"
    annotation (Placement(transformation(extent={{100,148},{120,168}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea4
    "Type converter"
    annotation (Placement(transformation(extent={{100,68},{120,88}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi "Logical switch"
    annotation (Placement(transformation(extent={{180,108},{200,128}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Type converter"
    annotation (Placement(transformation(extent={{220,108},{240,128}})));

  Buildings.Controls.OBC.CDL.Integers.LessEqualThreshold intLesEquThr(
    final threshold=0)
    "If the current stage is the lowest available the input value equals 0"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea2
    "Type converter"
    annotation (Placement(transformation(extent={{100,-110},{120,-90}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi1 "Logical switch"
    annotation (Placement(transformation(extent={{180,-70},{200,-50}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt3
    "Type converter"
    annotation (Placement(transformation(extent={{220,-70},{240,-50}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extStaAva(
    final allowOutOfRange=false,
    final outOfRangeValue=nSta + 1,
    final nin=nSta) "Extracts stage availability for the current stage"
    annotation (Placement(transformation(extent={{-200,-180},{-180,-160}})));

  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr(
    final threshold=0.5)
    "Detects if the current stage becomes unavailable"
    annotation (Placement(transformation(extent={{-160,-180},{-140,-160}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nSta]
    "Type converter"
    annotation (Placement(transformation(extent={{-240,-180},{-220,-160}})));

  Buildings.Controls.OBC.CDL.Utilities.Assert cheStaAva1(
    final message="There are no available chiller stages. The staging cannot be performed.")
    "Checks if any stage is available"
    annotation (Placement(transformation(extent={{-20,-160},{0,-140}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nu=nSta) "Logical or"
    annotation (Placement(transformation(extent={{-60,-160},{-40,-140}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=0)
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea6 "Type converter"
    annotation (Placement(transformation(extent={{100,-190},{120,-170}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea7 "Type converter"
    annotation (Placement(transformation(extent={{100,-240},{120,-220}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt4
    "Type converter"
    annotation (Placement(transformation(extent={{220,-210},{240,-190}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea8 "Type converter"
    annotation (Placement(transformation(extent={{300,98},{320,118}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea9 "Type converter"
    annotation (Placement(transformation(extent={{300,48},{320,68}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt5
    "Type converter"
    annotation (Placement(transformation(extent={{400,68},{420,88}})));

  Buildings.Controls.OBC.CDL.Logical.And and4
    "Identifies any available stages above the current stage"
    annotation (Placement(transformation(extent={{232,76},{252,96}})));

equation
  connect(intRep.y, intRep1.u)
    annotation (Line(points={{-239,248},{-182,248}}, color={255,127,0}));
  connect(intRep1.y, intEqu1.u1)
    annotation (Line(points={{-159,248},{-122,248}},   color={255,127,0}));
  connect(matMax.y, chiInSta.u)
    annotation (Line(points={{81,228},{98,228}},  color={0,0,127}));
  connect(chiExtMatr.y, intEqu1.u2) annotation (Line(points={{-159,198},{-140,
          198},{-140,240},{-122,240}},
                                    color={255,127,0}));
  connect(chiInSta.y, yChi)
    annotation (Line(points={{121,228},{186,228},{186,170},{450,170}},
                                                   color={255,0,255}));
  connect(proInt.y, intToRea.u)
    annotation (Line(points={{1,228},{18,228}}, color={255,127,0}));
  connect(intToRea.y, matMax.u)
    annotation (Line(points={{41,228},{58,228}}, color={0,0,127}));
  connect(booToInt.y, proInt.u1) annotation (Line(points={{-59,248},{-40,248},{
          -40,234},{-22,234}},
                           color={255,127,0}));
  connect(intEqu1.y, booToInt.u)
    annotation (Line(points={{-99,248},{-82,248}}, color={255,0,255}));
  connect(chiStaMatr.y, proInt.u2) annotation (Line(points={{-99,198},{-40,198},
          {-40,222},{-22,222}}, color={255,127,0}));
  connect(staIndx.y, intGre.u1) annotation (Line(points={{-199,138},{-190,138},
          {-190,98},{-182,98}},
                          color={255,127,0}));
  connect(intRep.y, intGre.u2) annotation (Line(points={{-239,248},{-230,248},{
          -230,90},{-182,90}},
                 color={255,127,0}));
  connect(intGre.y, and2.u1) annotation (Line(points={{-159,98},{-150,98},{-150,
          88},{-142,88}},color={255,0,255}));
  connect(uAva, and2.u2) annotation (Line(points={{-480,-80},{-250,-80},{-250,
          80},{-142,80}},
                     color={255,0,255}));
  connect(staIndx.y, proInt1.u1) annotation (Line(points={{-199,138},{-70,138},
          {-70,124},{-62,124}},
                         color={255,127,0}));
  connect(booToInt1.y, proInt1.u2) annotation (Line(points={{-79,88},{-70,88},{
          -70,112},{-62,112}},
                          color={255,127,0}));
  connect(proInt1.y, intToRea1.u)
    annotation (Line(points={{-39,118},{-22,118}},
                                                 color={255,127,0}));
  connect(intToRea1.y, multiMin.u) annotation (Line(points={{1,118},{18,118}},
                                      color={0,0,127}));
  connect(intRep.y, intLes.u2) annotation (Line(points={{-239,248},{-230,248},{
          -230,-78},{-182,-78}},
               color={255,127,0}));
  connect(staIndx.y, intLes.u1) annotation (Line(points={{-199,138},{-190,138},
          {-190,-70},{-182,-70}},
                              color={255,127,0}));
  connect(uAva, and1.u2) annotation (Line(points={{-480,-80},{-312,-80},{-312,
          -98},{-142,-98}},
                      color={255,0,255}));
  connect(intLes.y, and1.u1) annotation (Line(points={{-159,-70},{-150,-70},{
          -150,-90},{-142,-90}},
                      color={255,0,255}));
  connect(proInt2.y, intToRea3.u)
    annotation (Line(points={{-39,-60},{-22,-60}}, color={255,127,0}));
  connect(intToRea3.y, multiMax.u) annotation (Line(points={{1,-60},{18,-60}},
    color={0,0,127}));
  connect(staIndx.y, proInt2.u1) annotation (Line(points={{-199,138},{-190,138},
          {-190,20},{-70,20},{-70,-54},{-62,-54}},
                           color={255,127,0}));
  connect(booToInt2.y, proInt2.u2) annotation (Line(points={{-79,-90},{-70,-90},
          {-70,-66},{-62,-66}},
                       color={255,127,0}));
  connect(multiMax.y, reaToInt1.u)
    annotation (Line(points={{41,-60},{58,-60}}, color={0,0,127}));
  connect(multiMin.y, reaToInt.u)
    annotation (Line(points={{41,118},{58,118}},   color={0,0,127}));
  connect(reaToInt.y, intGreThr.u)
    annotation (Line(points={{81,118},{98,118}},   color={255,127,0}));
  connect(intGreThr.y, swi.u2)
    annotation (Line(points={{121,118},{178,118}}, color={255,0,255}));
  connect(intToRea5.y, swi.u1) annotation (Line(points={{121,158},{160,158},{
          160,126},{178,126}},
                           color={0,0,127}));
  connect(reaToInt.y, intToRea4.u) annotation (Line(points={{81,118},{90,118},{
          90,78},{98,78}},    color={255,127,0}));
  connect(intToRea4.y, swi.u3) annotation (Line(points={{121,78},{160,78},{160,
          110},{178,110}},
                      color={0,0,127}));
  connect(swi.y, reaToInt2.u)
    annotation (Line(points={{201,118},{218,118}}, color={0,0,127}));
  connect(intGreThr.y, yHig) annotation (Line(points={{121,118},{140,118},{140,
          40},{450,40}},                   color={255,0,255}));
  connect(reaToInt3.y,yDown)  annotation (Line(points={{241,-60},{346,-60},{346,
          -40},{450,-40}},
                     color={255,127,0}));
  connect(reaToInt1.y, intLesEquThr.u)
    annotation (Line(points={{81,-60},{98,-60}}, color={255,127,0}));
  connect(intLesEquThr.y, swi1.u2)
    annotation (Line(points={{121,-60},{178,-60}},
                                                 color={255,0,255}));
  connect(intToRea2.y, swi1.u3) annotation (Line(points={{121,-100},{168,-100},
          {168,-68},{178,-68}},
                         color={0,0,127}));
  connect(swi1.y, reaToInt3.u)
    annotation (Line(points={{201,-60},{218,-60}},
                                                 color={0,0,127}));
  connect(intLesEquThr.y, yLow) annotation (Line(points={{121,-60},{120,-60},{
          120,-80},{450,-80}},
                             color={255,0,255}));
  connect(extStaAva.y,lesThr. u)
    annotation (Line(points={{-179,-170},{-162,-170}}, color={0,0,127}));
  connect(uAva, booToRea.u) annotation (Line(points={{-480,-80},{-250,-80},{
          -250,-170},{-242,-170}},
                              color={255,0,255}));
  connect(booToRea.y,extStaAva. u)
    annotation (Line(points={{-219,-170},{-202,-170}}, color={0,0,127}));
  connect(reaToInt1.y, intToRea2.u) annotation (Line(points={{81,-60},{88,-60},
          {88,-100},{98,-100}},   color={255,127,0}));
  connect(uAva, mulOr.u) annotation (Line(points={{-480,-80},{-272,-80},{-272,
          -150},{-62,-150}},                                    color={255,0,255}));
  connect(mulOr.y, cheStaAva1.u)
    annotation (Line(points={{-38.3,-150},{-22,-150}}, color={255,0,255}));
  connect(con.y, swi1.u1) annotation (Line(points={{121,-20},{168,-20},{168,-52},
          {178,-52}},        color={0,0,127}));
  connect(and2.y, booToInt1.u)
    annotation (Line(points={{-119,88},{-102,88}},
                                                 color={255,0,255}));
  connect(and1.y, booToInt2.u)
    annotation (Line(points={{-119,-90},{-102,-90}}, color={255,0,255}));
  connect(minInt.u2, maxLim.y) annotation (Line(points={{-362,64},{-370,64},{
          -370,50},{-379,50}},
                          color={255,127,0}));
  connect(maxInt.u2, minLim.y) annotation (Line(points={{-322,34},{-330,34},{
          -330,30},{-339,30}},
                          color={255,127,0}));
  connect(minInt.y, maxInt.u1) annotation (Line(points={{-339,70},{-330,70},{
          -330,46},{-322,46}},
                          color={255,127,0}));
  connect(u, minInt.u1) annotation (Line(points={{-480,80},{-410,80},{-410,76},
          {-362,76}},color={255,127,0}));
  connect(maxInt.y, intRep.u) annotation (Line(points={{-299,40},{-280,40},{
          -280,248},{-262,248}},                  color={255,127,0}));
  connect(maxInt.y, intToRea5.u) annotation (Line(points={{-299,40},{-280,40},{
          -280,158},{98,158}},
                         color={255,127,0}));
  connect(maxInt.y, extStaAva.index) annotation (Line(points={{-299,40},{-280,
          40},{-280,-190},{-190,-190},{-190,-182}},
                                                color={255,127,0}));
  connect(lesThr.y, swi2.u2) annotation (Line(points={{-139,-170},{18,-170},{18,
          -200},{178,-200}},
                       color={255,0,255}));
  connect(maxInt.y, intToRea6.u) annotation (Line(points={{-299,40},{-280,40},{
          -280,-140},{-100,-140},{-100,-180},{98,-180}},
                                                   color={255,127,0}));
  connect(reaToInt3.y, intToRea7.u) annotation (Line(points={{241,-60},{260,-60},
          {260,-150},{80,-150},{80,-230},{98,-230}},    color={255,127,0}));
  connect(swi2.y, reaToInt4.u)
    annotation (Line(points={{201,-200},{218,-200}}, color={0,0,127}));
  connect(reaToInt4.y, y)
    annotation (Line(points={{241,-200},{346,-200},{346,-160},{450,-160}},
                                                     color={255,127,0}));
  connect(reaToInt2.y, intToRea8.u) annotation (Line(points={{241,118},{264,118},
          {264,108},{298,108}}, color={255,127,0}));
  connect(intToRea8.y, swi3.u3) annotation (Line(points={{321,108},{340,108},{
          340,70},{358,70}},
                         color={0,0,127}));
  connect(intToRea9.y, swi3.u1) annotation (Line(points={{321,58},{350,58},{350,
          86},{358,86}},          color={0,0,127}));
  connect(swi3.y, reaToInt5.u)
    annotation (Line(points={{381,78},{398,78}}, color={0,0,127}));
  connect(reaToInt5.y, yUp)
    annotation (Line(points={{421,78},{436,78},{436,80},{450,80}},
                                                 color={255,127,0}));
  connect(maxInt.y, intToRea9.u) annotation (Line(points={{-299,40},{0,40},{0,
          58},{298,58}}, color={255,127,0}));
  connect(intToRea6.y, swi2.u3) annotation (Line(points={{121,-180},{156,-180},
          {156,-208},{178,-208}},color={0,0,127}));
  connect(intToRea7.y, swi2.u1) annotation (Line(points={{121,-230},{146,-230},
          {146,-192},{178,-192}},color={0,0,127}));
  connect(intGreThr.y, and4.u1) annotation (Line(points={{121,118},{156,118},{
          156,86},{230,86}},      color={255,0,255}));
  connect(lesThr.y, and4.u2) annotation (Line(points={{-139,-170},{-56,-170},{
          -56,-168},{56,-168},{56,-136},{208,-136},{208,78},{230,78}},
                                                               color={255,0,255}));
  connect(and4.y, swi3.u2) annotation (Line(points={{253,86},{334,86},{334,78},
          {358,78}},         color={255,0,255}));
  connect(yUp, yUp)
    annotation (Line(points={{450,80},{450,80}}, color={255,127,0}));
  annotation (Icon(coordinateSystem(extent={{-420,-280},{440,280}}),
                   graphics={
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
