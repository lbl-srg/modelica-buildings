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
    annotation (Placement(transformation(extent={{-300,240},{-260,280}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChi[nChi]
    "Chillers in a given stage"                                                          annotation (
      Placement(transformation(extent={{260,230},{280,250}}),
        iconTransformation(extent={{100,-60},{120,-40}})));

//protected



  Buildings.Controls.OBC.CDL.Routing.IntegerReplicator intRep(nout=nSta)
    annotation (Placement(transformation(extent={{-220,250},{-200,270}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerReplicator intRep1[nSta](nout=fill(nChi, nSta))
    annotation (Placement(transformation(extent={{-160,250},{-140,270}})));
  CDL.Integers.Sources.Constant                          chiExtMatr[nSta,nChi](final k=chiExtMat)
    annotation (Placement(transformation(extent={{-160,200},{-140,220}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1[nSta,nChi]
    annotation (Placement(transformation(extent={{-100,250},{-80,270}})));
  CDL.Integers.Sources.Constant                          chiStaMat1[nSta,nChi](final k=staMat)
    "Transposed staging matrix"
    annotation (Placement(transformation(extent={{-100,200},{-80,220}})));
  Buildings.Controls.OBC.CDL.Continuous.MatrixMax matMax(
    nRow=nSta,
    nCol=nChi,
    rowMax=false)
    annotation (Placement(transformation(extent={{60,230},{80,250}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold chiInSta[nChi](threshold=fill(0.5, nChi))
    "Identifies chillers designated to operate in a given stage (regardless of the availability)"
    annotation (Placement(transformation(extent={{100,230},{120,250}})));

  CDL.Interfaces.BooleanInput uAva[nSta] "Stage availability status"
    annotation (Placement(transformation(extent={{-300,20},{-260,60}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  CDL.Integers.Product proInt[nSta,nChi]
    annotation (Placement(transformation(extent={{-20,230},{0,250}})));
  CDL.Conversions.BooleanToInteger booToInt[nSta,nChi]
    annotation (Placement(transformation(extent={{-60,250},{-40,270}})));
  CDL.Conversions.IntegerToReal intToRea[nSta,nChi]
    annotation (Placement(transformation(extent={{20,230},{40,250}})));
  CDL.Interfaces.IntegerOutput uUp(final max=nSta) "Next available stage up"
    annotation (Placement(transformation(extent={{260,110},{280,130}}),
        iconTransformation(extent={{100,40},{120,60}})));
  CDL.Interfaces.IntegerOutput uDown(final max=nSta)
    "Next available stage down" annotation (Placement(transformation(extent={{260,
            10},{280,30}}), iconTransformation(extent={{100,0},{120,20}})));
  CDL.Integers.Product proInt1[nSta]
    annotation (Placement(transformation(extent={{0,120},{20,140}})));
  CDL.Integers.Sources.Constant staRange[nSta](final k=staRan)
    annotation (Placement(transformation(extent={{-180,140},{-160,160}})));
  CDL.Integers.Greater intGre[nSta]
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));
  CDL.Conversions.BooleanToInteger booToInt1[nSta](integerFalse=fill(nSta, nSta))
    annotation (Placement(transformation(extent={{-40,78},{-20,98}})));
  CDL.Logical.And and2[nSta]
    annotation (Placement(transformation(extent={{-80,78},{-60,98}})));
  CDL.Continuous.MultiMin multiMin(nin=nSta)
    annotation (Placement(transformation(extent={{80,120},{100,140}})));
  CDL.Conversions.IntegerToReal intToRea1[nSta]
    annotation (Placement(transformation(extent={{40,120},{60,140}})));
  CDL.Conversions.RealToInteger reaToInt
    annotation (Placement(transformation(extent={{220,110},{240,130}})));
  CDL.Integers.Less intLes[nSta]
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));
  CDL.Integers.Sources.Constant minSta(final k=1)
    annotation (Placement(transformation(extent={{120,-20},{140,0}})));
  CDL.Logical.And and1[nSta]
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  CDL.Conversions.BooleanToInteger booToInt2[nSta]
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  CDL.Integers.Product proInt2[nSta]
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  CDL.Conversions.IntegerToReal intToRea3[nSta]
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  CDL.Continuous.MultiMax multiMax(nin=nSta)
    annotation (Placement(transformation(extent={{80,20},{100,40}})));
  CDL.Integers.Max maxInt1
    annotation (Placement(transformation(extent={{180,10},{200,30}})));
  CDL.Conversions.RealToInteger reaToInt1
    annotation (Placement(transformation(extent={{120,20},{140,40}})));
equation
  connect(uSta, intRep.u)
    annotation (Line(points={{-280,260},{-222,260}},   color={255,127,0}));
  connect(intRep.y, intRep1.u) annotation (Line(points={{-199,260},{-162,260}},
                                    color={255,127,0}));
  connect(intRep1.y, intEqu1.u1)
    annotation (Line(points={{-139,260},{-102,260}},   color={255,127,0}));
  connect(matMax.y, chiInSta.u)
    annotation (Line(points={{81,240},{98,240}}, color={0,0,127}));
  connect(chiExtMatr.y, intEqu1.u2) annotation (Line(points={{-139,210},{-120,210},
          {-120,252},{-102,252}},   color={255,127,0}));
  connect(chiInSta.y, yChi)
    annotation (Line(points={{121,240},{270,240}}, color={255,0,255}));
  connect(proInt.y, intToRea.u)
    annotation (Line(points={{1,240},{18,240}}, color={255,127,0}));
  connect(intToRea.y, matMax.u)
    annotation (Line(points={{41,240},{58,240}}, color={0,0,127}));
  connect(booToInt.y, proInt.u1) annotation (Line(points={{-39,260},{-30,260},{-30,
          246},{-22,246}}, color={255,127,0}));
  connect(intEqu1.y, booToInt.u)
    annotation (Line(points={{-79,260},{-62,260}}, color={255,0,255}));
  connect(chiStaMat1.y, proInt.u2) annotation (Line(points={{-79,210},{-30,210},
          {-30,234},{-22,234}}, color={255,127,0}));
  connect(staRange.y, intGre.u1) annotation (Line(points={{-159,150},{-150,150},
          {-150,110},{-142,110}}, color={255,127,0}));
  connect(intRep.y, intGre.u2) annotation (Line(points={{-199,260},{-199,102},{-142,
          102}}, color={255,127,0}));
  connect(intGre.y, and2.u1) annotation (Line(points={{-119,110},{-98,110},{-98,
          88},{-82,88}}, color={255,0,255}));
  connect(uAva, and2.u2) annotation (Line(points={{-280,40},{-182,40},{-182,80},
          {-82,80}}, color={255,0,255}));
  connect(and2.y, booToInt1.u) annotation (Line(points={{-59,88},{-42,88}},
                                       color={255,0,255}));
  connect(staRange.y, proInt1.u1) annotation (Line(points={{-159,150},{-80,150},
          {-80,136},{-2,136}}, color={255,127,0}));
  connect(booToInt1.y, proInt1.u2) annotation (Line(points={{-19,88},{-12,88},{
          -12,124},{-2,124}},
                          color={255,127,0}));
  connect(proInt1.y, intToRea1.u)
    annotation (Line(points={{21,130},{38,130}}, color={255,127,0}));
  connect(intToRea1.y, multiMin.u) annotation (Line(points={{61,130},{78,130}},
                                      color={0,0,127}));
  connect(uUp, reaToInt.y)
    annotation (Line(points={{270,120},{241,120}}, color={255,127,0}));
  connect(intRep.y, intLes.u2) annotation (Line(points={{-199,260},{-199,2},{-142,
          2}}, color={255,127,0}));
  connect(staRange.y, intLes.u1) annotation (Line(points={{-159,150},{-150,150},
          {-150,10},{-142,10}},
                              color={255,127,0}));
  connect(uAva, and1.u2) annotation (Line(points={{-280,40},{-182,40},{-182,-18},
          {-82,-18}}, color={255,0,255}));
  connect(intLes.y, and1.u1) annotation (Line(points={{-119,10},{-100,10},{-100,
          -10},{-82,-10}},
                      color={255,0,255}));
  connect(and1.y, booToInt2.u)
    annotation (Line(points={{-59,-10},{-42,-10}}, color={255,0,255}));
  connect(proInt2.y, intToRea3.u)
    annotation (Line(points={{21,30},{38,30}}, color={255,127,0}));
  connect(intToRea3.y, multiMax.u) annotation (Line(points={{61,30},{70,30},{70,
          30},{78,30}},               color={0,0,127}));
  connect(staRange.y, proInt2.u1) annotation (Line(points={{-159,150},{-106,150},
          {-106,126},{-14,126},{-14,36},{-2,36}}, color={255,127,0}));
  connect(booToInt2.y, proInt2.u2) annotation (Line(points={{-19,-10},{-19,6},{-2,
          6},{-2,24}}, color={255,127,0}));
  connect(multiMax.y, reaToInt1.u)
    annotation (Line(points={{101,30},{118,30}}, color={0,0,127}));
  connect(reaToInt1.y, maxInt1.u1) annotation (Line(points={{141,30},{164,30},{164,
          26},{178,26}}, color={255,127,0}));
  connect(minSta.y, maxInt1.u2) annotation (Line(points={{141,-10},{162,-10},{162,
          14},{178,14}}, color={255,127,0}));
  connect(maxInt1.y, uDown)
    annotation (Line(points={{201,20},{270,20}}, color={255,127,0}));
  connect(multiMin.y, reaToInt.u) annotation (Line(points={{101,130},{160,130},
          {160,120},{218,120}}, color={0,0,127}));
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
          extent={{-260,-340},{260,340}})),
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
