within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block Status
  "Outputs next available lower and higher stage, whether curent stage is lowest and/or is highest and current stage chillers"

  parameter Integer nSta = 3
    "Number of stages";

  parameter Integer nChi = 2
    "Number of chillers";

  final parameter Integer staRan[nSta] = {i for i in 1:nSta}
  "Range with all possible stage values";

  parameter Integer staMat[nSta, nChi] = {{1,0},{0,1},{1,1}}
    "Staging matrix with stages in rows and chillers in columns";

  final parameter Integer chiExtMat[nSta, nChi] = {j for i in 1:nChi, j in 1:nSta}
     "Matrix used in extracting chillers at current stage";

  final parameter Integer lowDia[nSta, nSta] = {if i<=j then 1 else 0 for i in 1:nSta, j in 1:nSta}
    "Lower diagonal unit matrix";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uSta(final min=0, final
      max=nSta)       "Chiller stage"
    annotation (Placement(transformation(extent={{-340,100},{-300,140}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHig "Operating in the highest available stage"
    annotation (Placement(transformation(extent={{300,-50},{320,-30}}),
        iconTransformation(extent={{100,-60},{120,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLow "Operating in the lowest available stage"
    annotation (Placement(transformation(extent={{300,-150},{320,-130}}),
        iconTransformation(extent={{100,-60},{120,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChi[nChi]
    "Chillers in a given stage" annotation (
      Placement(transformation(extent={{300,90},{320,110}}),
        iconTransformation(extent={{100,-60},{120,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput uUp(final min=1, final max=nSta) "Next available stage up"
    annotation (Placement(transformation(extent={{300,-10},{320,10}}),
        iconTransformation(extent={{100,40},{120,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput uDown(final min=1, final max=nSta)
    "Next available stage down" annotation (Placement(transformation(extent={{300,
            -110},{320,-90}}),
                            iconTransformation(extent={{100,0},{120,20}})));

//protected



  Buildings.Controls.OBC.CDL.Routing.IntegerReplicator intRep(nout=nSta)
    annotation (Placement(transformation(extent={{-280,110},{-260,130}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerReplicator intRep1[nSta](nout=fill(nChi, nSta))
    annotation (Placement(transformation(extent={{-220,110},{-200,130}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant                          chiExtMatr[nSta,nChi](final k=chiExtMat)
    annotation (Placement(transformation(extent={{-220,60},{-200,80}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1[nSta,nChi]
    annotation (Placement(transformation(extent={{-120,110},{-100,130}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant                          chiStaMat1[nSta,nChi](final k=staMat)
    "Transposed staging matrix"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  Buildings.Controls.OBC.CDL.Continuous.MatrixMax matMax(
    nRow=nSta,
    nCol=nChi,
    rowMax=false)
    annotation (Placement(transformation(extent={{80,90},{100,110}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold chiInSta[nChi](threshold=fill(0.5, nChi))
    "Identifies chillers designated to operate in a given stage (regardless of the availability)"
    annotation (Placement(transformation(extent={{120,90},{140,110}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uAva[nSta] "Stage availability status"
    annotation (Placement(transformation(extent={{-340,-120},{-300,-80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Integers.Product proInt[nSta,nChi]
    annotation (Placement(transformation(extent={{0,90},{20,110}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nSta,nChi]
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea[nSta,nChi]
    annotation (Placement(transformation(extent={{40,90},{60,110}})));

  Buildings.Controls.OBC.CDL.Integers.Product proInt1[nSta]
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant staRange[nSta](final k=staRan)
    annotation (Placement(transformation(extent={{-220,0},{-200,20}})));
  Buildings.Controls.OBC.CDL.Integers.Greater intGre[nSta]
    annotation (Placement(transformation(extent={{-180,-40},{-160,-20}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1[nSta](integerFalse=fill(nSta + 1,
        nSta))
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Controls.OBC.CDL.Logical.And and2[nSta]
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMin multiMin(nin=nSta)
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1[nSta]
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    annotation (Placement(transformation(extent={{80,-20},{100,0}})));
  Buildings.Controls.OBC.CDL.Integers.Less intLes[nSta]
    annotation (Placement(transformation(extent={{-180,-140},{-160,-120}})));
  Buildings.Controls.OBC.CDL.Logical.And and1[nSta]
    annotation (Placement(transformation(extent={{-120,-160},{-100,-140}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt2[nSta]
    annotation (Placement(transformation(extent={{-80,-160},{-60,-140}})));
  Buildings.Controls.OBC.CDL.Integers.Product proInt2[nSta]
    annotation (Placement(transformation(extent={{-40,-120},{-20,-100}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea3[nSta]
    annotation (Placement(transformation(extent={{0,-120},{20,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax multiMax(nin=nSta)
    annotation (Placement(transformation(extent={{40,-120},{60,-100}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    annotation (Placement(transformation(extent={{80,-120},{100,-100}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr(threshold=nSta)
    "Current stage is the highest available stage"
    annotation (Placement(transformation(extent={{118,-20},{138,0}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea5
    annotation (Placement(transformation(extent={{120,20},{140,40}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea4
    annotation (Placement(transformation(extent={{118,-60},{138,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{198,-20},{218,0}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    annotation (Placement(transformation(extent={{228,-20},{248,0}})));

  Buildings.Controls.OBC.CDL.Integers.LessEqualThreshold intLesEquThr(threshold=0)
    "Current stage is the highest available stage"
    annotation (Placement(transformation(extent={{118,-120},{138,-100}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea2
    annotation (Placement(transformation(extent={{118,-160},{138,-140}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    annotation (Placement(transformation(extent={{198,-120},{218,-100}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt3
    annotation (Placement(transformation(extent={{228,-120},{248,-100}})));
  CDL.Routing.RealExtractor                        extStaCap(
                          final nin=nSta,
    allowOutOfRange=true,
    final outOfRangeValue=nSta + 1)
    "Extracts the nominal capacity at the current stage"
    annotation (Placement(transformation(extent={{-220,-220},{-200,-200}})));
  CDL.Utilities.Assert                        cheStaAva(final message="Unavailable stage passed as input.")
    "Checks if current stage is available"
    annotation (Placement(transformation(extent={{-140,-220},{-120,-200}})));
  CDL.Continuous.GreaterThreshold greThr(threshold=0.5)
    annotation (Placement(transformation(extent={{-180,-220},{-160,-200}})));
  CDL.Conversions.BooleanToReal booToRea[nSta]
    annotation (Placement(transformation(extent={{-260,-220},{-240,-200}})));
  CDL.Utilities.Assert                        cheStaAva1(final message="There are no available chiller stages. The staging cannot be performed.")
    "Checks if any stage is available"
    annotation (Placement(transformation(extent={{-40,-220},{-20,-200}})));
  CDL.Logical.MultiOr mulOr(nu=nSta)
    annotation (Placement(transformation(extent={{-80,-220},{-60,-200}})));
  CDL.Continuous.Sources.Constant con(k=0)
    annotation (Placement(transformation(extent={{160,-80},{180,-60}})));
equation
  connect(uSta, intRep.u)
    annotation (Line(points={{-320,120},{-282,120}},   color={255,127,0}));
  connect(intRep.y, intRep1.u) annotation (Line(points={{-259,120},{-222,120}},
                                    color={255,127,0}));
  connect(intRep1.y, intEqu1.u1)
    annotation (Line(points={{-199,120},{-122,120}},   color={255,127,0}));
  connect(matMax.y, chiInSta.u)
    annotation (Line(points={{101,100},{118,100}},
                                                 color={0,0,127}));
  connect(chiExtMatr.y, intEqu1.u2) annotation (Line(points={{-199,70},{-160,70},
          {-160,112},{-122,112}},   color={255,127,0}));
  connect(chiInSta.y, yChi)
    annotation (Line(points={{141,100},{310,100}}, color={255,0,255}));
  connect(proInt.y, intToRea.u)
    annotation (Line(points={{21,100},{38,100}},color={255,127,0}));
  connect(intToRea.y, matMax.u)
    annotation (Line(points={{61,100},{78,100}}, color={0,0,127}));
  connect(booToInt.y, proInt.u1) annotation (Line(points={{-59,120},{-20,120},{-20,
          106},{-2,106}},  color={255,127,0}));
  connect(intEqu1.y, booToInt.u)
    annotation (Line(points={{-99,120},{-82,120}}, color={255,0,255}));
  connect(chiStaMat1.y, proInt.u2) annotation (Line(points={{-99,70},{-20,70},{-20,
          94},{-2,94}},         color={255,127,0}));
  connect(staRange.y, intGre.u1) annotation (Line(points={{-199,10},{-190,10},{-190,
          -30},{-182,-30}},       color={255,127,0}));
  connect(intRep.y, intGre.u2) annotation (Line(points={{-259,120},{-240,120},{-240,
          -38},{-182,-38}},
                 color={255,127,0}));
  connect(intGre.y, and2.u1) annotation (Line(points={{-159,-30},{-140,-30},{-140,
          -50},{-122,-50}},
                         color={255,0,255}));
  connect(uAva, and2.u2) annotation (Line(points={{-320,-100},{-270,-100},{-270,
          -58},{-122,-58}},
                     color={255,0,255}));
  connect(and2.y, booToInt1.u) annotation (Line(points={{-99,-50},{-82,-50}},
                                       color={255,0,255}));
  connect(staRange.y, proInt1.u1) annotation (Line(points={{-199,10},{-120,10},{
          -120,-4},{-42,-4}},  color={255,127,0}));
  connect(booToInt1.y, proInt1.u2) annotation (Line(points={{-59,-50},{-52,-50},
          {-52,-16},{-42,-16}},
                          color={255,127,0}));
  connect(proInt1.y, intToRea1.u)
    annotation (Line(points={{-19,-10},{-2,-10}},color={255,127,0}));
  connect(intToRea1.y, multiMin.u) annotation (Line(points={{21,-10},{38,-10}},
                                      color={0,0,127}));
  connect(intRep.y, intLes.u2) annotation (Line(points={{-259,120},{-240,120},{-240,
          -138},{-182,-138}},
               color={255,127,0}));
  connect(staRange.y, intLes.u1) annotation (Line(points={{-199,10},{-190,10},{-190,
          -130},{-182,-130}}, color={255,127,0}));
  connect(uAva, and1.u2) annotation (Line(points={{-320,-100},{-270,-100},{-270,
          -158},{-122,-158}},
                      color={255,0,255}));
  connect(intLes.y, and1.u1) annotation (Line(points={{-159,-130},{-140,-130},{-140,
          -150},{-122,-150}},
                      color={255,0,255}));
  connect(and1.y, booToInt2.u)
    annotation (Line(points={{-99,-150},{-82,-150}},
                                                   color={255,0,255}));
  connect(proInt2.y, intToRea3.u)
    annotation (Line(points={{-19,-110},{-2,-110}},
                                               color={255,127,0}));
  connect(intToRea3.y, multiMax.u) annotation (Line(points={{21,-110},{38,-110}},
                                      color={0,0,127}));
  connect(staRange.y, proInt2.u1) annotation (Line(points={{-199,10},{-190,10},{
          -190,-104},{-42,-104}},                 color={255,127,0}));
  connect(booToInt2.y, proInt2.u2) annotation (Line(points={{-59,-150},{-50,-150},
          {-50,-116},{-42,-116}},
                       color={255,127,0}));
  connect(multiMax.y, reaToInt1.u)
    annotation (Line(points={{61,-110},{78,-110}},
                                                 color={0,0,127}));
  connect(multiMin.y, reaToInt.u)
    annotation (Line(points={{61,-10},{78,-10}},   color={0,0,127}));
  connect(reaToInt.y, intGreThr.u)
    annotation (Line(points={{101,-10},{116,-10}}, color={255,127,0}));
  connect(intGreThr.y, swi.u2)
    annotation (Line(points={{139,-10},{196,-10}}, color={255,0,255}));
  connect(uSta, intToRea5.u) annotation (Line(points={{-320,120},{-290,120},{-290,
          40},{-52,40},{-52,30},{118,30}},
                           color={255,127,0}));
  connect(intToRea5.y, swi.u1) annotation (Line(points={{141,30},{180,30},{180,-2},
          {196,-2}},       color={0,0,127}));
  connect(reaToInt.y, intToRea4.u) annotation (Line(points={{101,-10},{110,-10},
          {110,-50},{116,-50}},
                              color={255,127,0}));
  connect(intToRea4.y, swi.u3) annotation (Line(points={{139,-50},{188,-50},{188,
          -18},{196,-18}},
                      color={0,0,127}));
  connect(uUp, reaToInt2.y) annotation (Line(points={{310,0},{258,0},{258,-10},{
          249,-10}},  color={255,127,0}));
  connect(swi.y, reaToInt2.u)
    annotation (Line(points={{219,-10},{226,-10}}, color={0,0,127}));
  connect(intGreThr.y, yHig) annotation (Line(points={{139,-10},{160,-10},{160,-40},
          {310,-40}},                      color={255,0,255}));
  connect(reaToInt3.y, uDown) annotation (Line(points={{249,-110},{252,-110},{252,
          -100},{310,-100}},
                     color={255,127,0}));
  connect(reaToInt1.y, intLesEquThr.u)
    annotation (Line(points={{101,-110},{116,-110}},
                                                 color={255,127,0}));
  connect(intLesEquThr.y, swi1.u2)
    annotation (Line(points={{139,-110},{196,-110}},
                                                 color={255,0,255}));
  connect(intToRea2.y, swi1.u3) annotation (Line(points={{139,-150},{188,-150},{
          188,-118},{196,-118}},
                         color={0,0,127}));
  connect(swi1.y, reaToInt3.u)
    annotation (Line(points={{219,-110},{226,-110}},
                                                 color={0,0,127}));
  connect(intLesEquThr.y, yLow) annotation (Line(points={{139,-110},{160,-110},{
          160,-140},{310,-140}},
                             color={255,0,255}));
  connect(greThr.y, cheStaAva.u)
    annotation (Line(points={{-159,-210},{-142,-210}}, color={255,0,255}));
  connect(extStaCap.y, greThr.u)
    annotation (Line(points={{-199,-210},{-182,-210}}, color={0,0,127}));
  connect(uAva, booToRea.u) annotation (Line(points={{-320,-100},{-270,-100},{-270,
          -210},{-262,-210}}, color={255,0,255}));
  connect(booToRea.y, extStaCap.u)
    annotation (Line(points={{-239,-210},{-222,-210}}, color={0,0,127}));
  connect(uSta, extStaCap.index) annotation (Line(points={{-320,120},{-290,120},
          {-290,-240},{-210,-240},{-210,-222}}, color={255,127,0}));
  connect(reaToInt1.y, intToRea2.u) annotation (Line(points={{101,-110},{108,-110},
          {108,-150},{116,-150}}, color={255,127,0}));
  connect(uAva, mulOr.u) annotation (Line(points={{-320,-100},{-270,-100},{-270,
          -180},{-92,-180},{-92,-210},{-82,-210}},              color={255,0,255}));
  connect(mulOr.y, cheStaAva1.u)
    annotation (Line(points={{-58.3,-210},{-42,-210}}, color={255,0,255}));
  connect(con.y, swi1.u1) annotation (Line(points={{181,-70},{188,-70},{188,
          -102},{196,-102}}, color={0,0,127}));
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
          extent={{-300,-280},{300,180}})),
Documentation(info="<html>
<p>
Configures the chiller staging based on the nominal <code>chiNomCap</code> and 
minimal <code>chiMinCap</code> chiller capacities and the chiller staging matrix <code>staMat</code>. 
The rows in <code>staMat</code> correspond to array indices in <code>chiNomCap</code>
and <code>chiMinCap</code>.
</p>
<p>
The outputs of the staging configurator are:
<ul>
<li>

</li>
<li>

</li>


</p>

</p>
</html>",
revisions="<html>
<ul>
<li>
January 13, 2019, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Status;
