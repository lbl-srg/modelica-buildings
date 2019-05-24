within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block Configurator "Configures chiller staging"

  parameter Integer nSta = 3
    "Number of stages";

  parameter Integer nChi = 2
    "Number of chillers";

  parameter Real staMat[nSta, nChi] = {{1,0},{0,1},{1,1}}
    "Staging matrix with stages in rows and chillers in columns";

  parameter Integer chiTyp[nChi] = {1,2}
    "Chiller type: 1 - positive displacement, 2 - variable speed centrifugal, 3 - constant speed centrifugal";

  parameter Modelica.SIunits.Power chiNomCap[nChi]
    "Nominal chiller capacities";

  parameter Modelica.SIunits.Power chiMinCap[nChi]
    "Chiller unload capacities";

  final parameter Integer chiTypExp[nSta, nChi] = {chiTyp[i] for i in 1:nChi, j in 1:nSta}
    "Chiller type array expanded to allow for elementwise multiplication with the staging matrix";

  final parameter Integer chiExtMat[nSta, nChi] = {j for i in 1:nChi, j in 1:nSta}
     "Matrix used in extracting chillers at current stage";

  final parameter Real lowDia[nSta, nSta] = {if i<=j then 1 else 0 for i in 1:nSta, j in 1:nSta}
    "Lower diagonal unit matrix";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiAva[nChi]
    "Chiller availability status"
    annotation (Placement(transformation(extent={{-300,20},{-260,60}}),
        iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yAva[nSta]
    "Stage availability status array" annotation (Placement(transformation(
          extent={{260,10},{280,30}}), iconTransformation(extent={{100,-40},{
            120,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChi[nChi]
    "Chillers in a given stage (assigned and available)"                                 annotation (
      Placement(transformation(extent={{260,-250},{280,-230}}),
        iconTransformation(extent={{100,-80},{120,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yTyp[nSta](final max=nSta)
    "Nominal chiller stage types"
                         annotation (Placement(transformation(extent={{260,-50},
            {280,-30}}), iconTransformation(extent={{100,0},{120,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yNomCap[nSta](final unit="W",
      final quantity="Power") "Stage nominal capacities" annotation (Placement(
        transformation(extent={{260,100},{280,120}}), iconTransformation(extent={{100,80},
            {120,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMinCap[nSta](final unit="W",
      final quantity="Power") "Stage minimal capacities" annotation (Placement(
        transformation(extent={{260,40},{280,60}}), iconTransformation(extent={{100,40},
            {120,60}})));

//protected

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiNomCaps[nChi](
    final k=chiNomCap) "Array of nominal chiller capacities"
    annotation (Placement(transformation(extent={{-200,300},{-180,320}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiMinCaps[nChi](
    final k=chiMinCap) "Array of chiller unload capacities"
    annotation (Placement(transformation(extent={{-200,200},{-180,220}})));

  Buildings.Controls.OBC.CDL.Continuous.MatrixGain staNomCaps(K=staMat)
    annotation (Placement(transformation(extent={{-60,240},{-40,260}})));
  Buildings.Controls.OBC.CDL.Continuous.MatrixGain staMinCaps(K=staMat)
    annotation (Placement(transformation(extent={{-60,160},{-40,180}})));
  Buildings.Controls.OBC.CDL.Continuous.MatrixGain staMinCaps1(K=staMat)
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));
  Buildings.Controls.OBC.CDL.Continuous.MatrixGain staMinCaps2(K=staMat)
    annotation (Placement(transformation(extent={{-140,30},{-120,50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oneVec[nChi](final k=fill(1, nSta))
    "All chillers available"
    annotation (Placement(transformation(extent={{-200,90},{-180,110}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nChi]
    annotation (Placement(transformation(extent={{-200,30},{-180,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2[nSta](k2=fill(-1, nSta))
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold                           lesThr[nSta](threshold=fill(0.5, nSta))
    "Checks if the number of chillers available in each stage equals the design number of chillers"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiStaMat[nSta,nChi](final k=
        staMat) "Staging matrix"
    annotation (Placement(transformation(extent={{-160,-100},{-140,-80}})));
  CDL.Continuous.Sources.Constant                      staType[nSta,nChi](final k=chiTypExp)
    "Chiller stage type"
    annotation (Placement(transformation(extent={{-160,-40},{-140,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro[nSta,nChi]
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.MatrixMax matMax(ninr=nSta, ninc=nChi)
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt[nSta]
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sort sort(nin=nSta)
    annotation (Placement(transformation(extent={{80,-130},{100,-110}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1[nSta]
    annotation (Placement(transformation(extent={{40,-130},{60,-110}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1[nSta]
    annotation (Placement(transformation(extent={{120,-130},{140,-110}})));
  Buildings.Controls.OBC.CDL.Integers.Equal                        intEqu[nSta]
    annotation (Placement(transformation(extent={{160,-100},{180,-80}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(message="Chillers are not staged according to G36 recommendation: stage any positive displacement machines first, stage any variable speed centrifugal next and any constant speed centrifugal last.")
    annotation (Placement(transformation(extent={{240,-100},{260,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput                        uSta(final min=0, final
      max=nSta)       "Chiller stage"
    annotation (Placement(transformation(extent={{-300,-240},{-260,-200}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerReplicator intRep(nout=nSta)
    annotation (Placement(transformation(extent={{-220,-230},{-200,-210}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerReplicator intRep1[nSta](nout=fill(nChi, nSta))
    annotation (Placement(transformation(extent={{-160,-230},{-140,-210}})));
  CDL.Integers.Sources.Constant                          chiExtMatr[nSta,nChi](final k=chiExtMat)
    "Transposed staging matrix"
    annotation (Placement(transformation(extent={{-160,-280},{-140,-260}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1[nSta,nChi]
    annotation (Placement(transformation(extent={{-100,-230},{-80,-210}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1[nSta,nChi]
    annotation (Placement(transformation(extent={{-60,-230},{-40,-210}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiStaMat1[nSta,nChi](final k=staMat)
    "Transposed staging matrix"
    annotation (Placement(transformation(extent={{-60,-280},{-40,-260}})));
  Buildings.Controls.OBC.CDL.Continuous.Product                        pro1[nSta,nChi]
    annotation (Placement(transformation(extent={{0,-250},{20,-230}})));
  Buildings.Controls.OBC.CDL.Continuous.MatrixMax                        matMax1(
    rowMin=false,
    ninr=nSta,
    ninc=nChi)
    annotation (Placement(transformation(extent={{60,-250},{80,-230}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold chiInSta[nChi](threshold=fill(0.5, nChi))
    "Identifies chillers designated to operate in a given stage (regardless of the availability)"
    annotation (Placement(transformation(extent={{120,-250},{140,-230}})));

  CDL.Logical.MultiAnd mulAnd(nu=nSta)
    annotation (Placement(transformation(extent={{200,-100},{220,-80}})));
  CDL.Logical.And and2[nChi]
    annotation (Placement(transformation(extent={{180,-250},{200,-230}})));
  CDL.Continuous.Product                        pro2[nChi]
    annotation (Placement(transformation(extent={{-120,278},{-100,298}})));
  CDL.Continuous.Product                        pro3[nChi]
    annotation (Placement(transformation(extent={{-120,180},{-100,200}})));
equation
  connect(oneVec.y, staMinCaps1.u)
    annotation (Line(points={{-179,100},{-142,100}},
                                                   color={0,0,127}));
  connect(uChiAva, booToRea.u)
    annotation (Line(points={{-280,40},{-202,40}},
                                                 color={255,0,255}));
  connect(booToRea.y, staMinCaps2.u) annotation (Line(points={{-179,40},{-142,40}},
                                    color={0,0,127}));
  connect(staMinCaps1.y, add2.u1) annotation (Line(points={{-119,100},{-100,100},
          {-100,76},{-82,76}},color={0,0,127}));
  connect(staMinCaps2.y, add2.u2) annotation (Line(points={{-119,40},{-100.5,40},
          {-100.5,64},{-82,64}}, color={0,0,127}));
  connect(add2.y,lesThr. u)
    annotation (Line(points={{-59,70},{-42,70}}, color={0,0,127}));
  connect(lesThr.y, yAva) annotation (Line(points={{-19,70},{60,70},{60,20},{270,
          20}}, color={255,0,255}));
  connect(chiStaMat.y,pro. u2) annotation (Line(points={{-139,-90},{-100,-90},{-100,
          -56},{-82,-56}},          color={0,0,127}));
  connect(pro.y,matMax. u)
    annotation (Line(points={{-59,-50},{-42,-50}},
                                               color={0,0,127}));
  connect(matMax.y,reaToInt. u)
    annotation (Line(points={{-19,-50},{-2,-50}},
                                               color={0,0,127}));
  connect(reaToInt.y, yTyp) annotation (Line(points={{21,-50},{30,-50},{30,-40},
          {270,-40}}, color={255,127,0}));
  connect(reaToInt.y, intToRea1.u) annotation (Line(points={{21,-50},{30,-50},{30,
          -120},{38,-120}},     color={255,127,0}));
  connect(intToRea1.y, sort.u)
    annotation (Line(points={{61,-120},{78,-120}}, color={0,0,127}));
  connect(sort.y, reaToInt1.u)
    annotation (Line(points={{101,-120},{118,-120}}, color={0,0,127}));
  connect(reaToInt.y,intEqu. u1) annotation (Line(points={{21,-50},{150,-50},{150,
          -90},{158,-90}},       color={255,127,0}));
  connect(reaToInt1.y,intEqu. u2) annotation (Line(points={{141,-120},{150,-120},
          {150,-98},{158,-98}},   color={255,127,0}));
  connect(uSta, intRep.u)
    annotation (Line(points={{-280,-220},{-222,-220}}, color={255,127,0}));
  connect(intRep.y, intRep1.u) annotation (Line(points={{-199,-220},{-162,-220}},
                                    color={255,127,0}));
  connect(intRep1.y, intEqu1.u1)
    annotation (Line(points={{-139,-220},{-102,-220}}, color={255,127,0}));
  connect(intEqu1.y, booToRea1.u)
    annotation (Line(points={{-79,-220},{-62,-220}}, color={255,0,255}));
  connect(booToRea1.y, pro1.u1) annotation (Line(points={{-39,-220},{-19.5,-220},
          {-19.5,-234},{-2,-234}}, color={0,0,127}));
  connect(chiStaMat1.y, pro1.u2) annotation (Line(points={{-39,-270},{-20.5,-270},
          {-20.5,-246},{-2,-246}}, color={0,0,127}));
  connect(pro1.y, matMax1.u)
    annotation (Line(points={{21,-240},{58,-240}}, color={0,0,127}));
  connect(matMax1.y, chiInSta.u)
    annotation (Line(points={{81,-240},{118,-240}}, color={0,0,127}));
  connect(mulAnd.y, assMes.u)
    annotation (Line(points={{221.7,-90},{238,-90}}, color={255,0,255}));
  connect(intEqu.y, mulAnd.u) annotation (Line(points={{181,-90},{190,-90},
          {190,-90},{198,-90}},           color={255,0,255}));
  connect(chiExtMatr.y, intEqu1.u2) annotation (Line(points={{-139,-270},{-120,-270},
          {-120,-228},{-102,-228}}, color={255,127,0}));
  connect(staType.y, pro.u1) annotation (Line(points={{-139,-30},{-100,-30},{-100,
          -44},{-82,-44}}, color={0,0,127}));
  connect(uChiAva, and2.u1) annotation (Line(points={{-280,40},{-220,40},{-220,-180},
          {160,-180},{160,-240},{178,-240}}, color={255,0,255}));
  connect(chiInSta.y, and2.u2) annotation (Line(points={{141,-240},{150,-240},{150,
          -248},{178,-248}}, color={255,0,255}));
  connect(and2.y, yChi)
    annotation (Line(points={{201,-240},{270,-240}}, color={255,0,255}));
  connect(chiNomCaps.y, pro2.u1) annotation (Line(points={{-179,310},{-148,310},
          {-148,294},{-122,294}}, color={0,0,127}));
  connect(chiMinCaps.y, pro3.u1) annotation (Line(points={{-179,210},{-150,210},
          {-150,196},{-122,196}}, color={0,0,127}));
  connect(pro2.y, staNomCaps.u) annotation (Line(points={{-99,288},{-80,288},{
          -80,250},{-62,250}}, color={0,0,127}));
  connect(pro3.y, staMinCaps.u) annotation (Line(points={{-99,190},{-79.5,190},
          {-79.5,170},{-62,170}}, color={0,0,127}));
  connect(staNomCaps.y, yNomCap) annotation (Line(points={{-39,250},{116,250},{
          116,110},{270,110}}, color={0,0,127}));
  connect(staMinCaps.y, yMinCap) annotation (Line(points={{-39,170},{82,170},{
          82,50},{270,50}}, color={0,0,127}));
  connect(booToRea.y, pro2.u2) annotation (Line(points={{-179,40},{-162,40},{
          -162,282},{-122,282}}, color={0,0,127}));
  connect(booToRea.y, pro3.u2) annotation (Line(points={{-179,40},{-150,40},{
          -150,184},{-122,184}}, color={0,0,127}));
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
end Configurator;
