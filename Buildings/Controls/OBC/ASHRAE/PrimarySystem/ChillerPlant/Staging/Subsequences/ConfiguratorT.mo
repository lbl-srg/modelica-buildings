within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block ConfiguratorT "Configures chiller staging"

  parameter Integer nSta = 3
    "Number of stages";

  parameter Integer nChi = 2
    "Number of chillers";

  parameter Integer chiTyp[nChi] = {1,2}
  "Chiller type: positive displacement, variable speed centrifugal, constant speed centrifugal";
                                        //fill(1, nChi)

  parameter Integer chiTypExp[nSta, nChi] = {chiTyp[i] for i in 1:nChi, j in 1:nSta}
  "Chiller type array expanded to allow for elementwise multiplication with the staging matrix";

  parameter Real staMat[nSta, nChi] = {{1,0},{0,1},{1,1}}
    "Array of nominal capacities at each individual stage with row index representing the chiller index";

  parameter Modelica.SIunits.Power chiNomCap[nChi] = fill(5e5, nChi)
    "Array of nominal chiller capacities";

  parameter Modelica.SIunits.Power chiMinCap[nChi] = fill(1e5, nChi)
    "Array of chiller unload capacities";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiAva[nChi]
    "Chiller availability status"
    annotation (Placement(transformation(extent={{-300,-20},{-260,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput staAva[nSta] "Stage availability status array"
    annotation (Placement(transformation(extent={{260,-70},{280,-50}}),
        iconTransformation(extent={{100,-100},{120,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaNomCap[nSta](
    final unit="W", final quantity="Power")
    "Stage nominal capacities" annotation (Placement(transformation(
    extent={{260,50},{280,70}}), iconTransformation(extent={{100,60},{120,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaMinCap[nSta](final unit="W", final quantity="Power")
    "Stage minimal capacities" annotation (Placement(transformation(extent={{260,
            -10},{280,10}}), iconTransformation(extent={{100,20},{120,40}})));

//protected

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiNomCaps[nChi](
    final k=chiNomCap) "Array of nominal chiller capacities"
    annotation (Placement(transformation(extent={{-200,250},{-180,270}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiMinCaps[nChi](
    final k=chiMinCap) "Array of chiller unload capacities"
    annotation (Placement(transformation(extent={{-200,170},{-180,190}})));


  Buildings.Controls.OBC.CDL.Continuous.MatrixGain staNomCaps(K=staMat)
    annotation (Placement(transformation(extent={{-120,210},{-100,230}})));
  Buildings.Controls.OBC.CDL.Continuous.MatrixGain staMinCaps(K=staMat)
    annotation (Placement(transformation(extent={{-120,130},{-100,150}})));
  Buildings.Controls.OBC.CDL.Continuous.MatrixGain staMinCaps1(K=staMat)
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));
  Buildings.Controls.OBC.CDL.Continuous.MatrixGain staMinCaps2(K=staMat)
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oneVec[nChi](final k=fill(1, nSta))
    "All chillers available"
    annotation (Placement(transformation(extent={{-200,40},{-180,60}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nChi]
    annotation (Placement(transformation(extent={{-200,-10},{-180,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2[nSta](k2=fill(-1, nSta))
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  CDL.Continuous.LessThreshold                           lesThr[nSta](threshold=fill(0.5, nSta))
    "Checks if the number of chillers available in each stage equals the design number of chillers"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput staTyp[nSta](
    final max=nSta) "Chiller stage type" annotation (Placement(transformation(
          extent={{260,-130},{280,-110}}), iconTransformation(extent={{100,40},
            {120,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiStaMat[nSta,nChi](final k=
        staMat)              "Staging matrix"
    annotation (Placement(transformation(extent={{-180,-176},{-160,-156}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant staType[nSta,nChi](final k=chiTypExp)
    "Chiller stage type"
    annotation (Placement(transformation(extent={{-180,-116},{-160,-96}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro[nSta,nChi]
    annotation (Placement(transformation(extent={{-80,-136},{-60,-116}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea[nSta,nChi]
    annotation (Placement(transformation(extent={{-140,-116},{-120,-96}})));
  Buildings.Controls.OBC.CDL.Continuous.MatrixMax matMax(ninr=nSta, ninc=nChi)
    annotation (Placement(transformation(extent={{-40,-136},{-20,-116}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt[nSta]
    annotation (Placement(transformation(extent={{0,-136},{20,-116}})));
  Buildings.Controls.OBC.CDL.Continuous.Sort sort(nin=nSta)
    annotation (Placement(transformation(extent={{80,-210},{100,-190}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1[nSta]
    annotation (Placement(transformation(extent={{40,-210},{60,-190}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1[nSta]
    annotation (Placement(transformation(extent={{120,-210},{140,-190}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[nSta]
    annotation (Placement(transformation(extent={{160,-180},{180,-160}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(message="Chillers are not staged according to G36 recommendation")
    annotation (Placement(transformation(extent={{240,-180},{260,-160}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(nu=3)
    annotation (Placement(transformation(extent={{200,-180},{220,-160}})));
equation
  connect(chiNomCaps.y, staNomCaps.u) annotation (Line(points={{-179,260},{-140,
          260},{-140,220},{-122,220}},
                                color={0,0,127}));
  connect(staNomCaps.y, yStaNomCap) annotation (Line(points={{-99,220},{100,220},
          {100,60},{270,60}},
                         color={0,0,127}));
  connect(staMinCaps.y, yStaMinCap) annotation (Line(points={{-99,140},{80,140},
          {80,0},{270,0}},   color={0,0,127}));
  connect(oneVec.y, staMinCaps1.u)
    annotation (Line(points={{-179,50},{-142,50}}, color={0,0,127}));
  connect(chiMinCaps.y, staMinCaps.u) annotation (Line(points={{-179,180},{-150.5,
          180},{-150.5,140},{-122,140}}, color={0,0,127}));
  connect(uChiAva, booToRea.u)
    annotation (Line(points={{-280,0},{-202,0}}, color={255,0,255}));
  connect(booToRea.y, staMinCaps2.u) annotation (Line(points={{-179,0},{-160.5,0},
          {-160.5,-10},{-142,-10}}, color={0,0,127}));
  connect(staMinCaps1.y, add2.u1) annotation (Line(points={{-119,50},{-100,50},{
          -100,26},{-82,26}}, color={0,0,127}));
  connect(staMinCaps2.y, add2.u2) annotation (Line(points={{-119,-10},{-100.5,-10},
          {-100.5,14},{-82,14}}, color={0,0,127}));
  connect(add2.y,lesThr. u)
    annotation (Line(points={{-59,20},{-42,20}}, color={0,0,127}));
  connect(lesThr.y, staAva) annotation (Line(points={{-19,20},{60,20},{60,-60},{
          270,-60}}, color={255,0,255}));
  connect(staType.y,intToRea. u)
    annotation (Line(points={{-159,-106},{-142,-106}},
                                                     color={255,127,0}));
  connect(intToRea.y,pro. u1) annotation (Line(points={{-119,-106},{-100,-106},{
          -100,-120},{-82,-120}},
                              color={0,0,127}));
  connect(chiStaMat.y,pro. u2) annotation (Line(points={{-159,-166},{-100,-166},
          {-100,-132},{-82,-132}},  color={0,0,127}));
  connect(pro.y,matMax. u)
    annotation (Line(points={{-59,-126},{-42,-126}},
                                               color={0,0,127}));
  connect(matMax.y,reaToInt. u)
    annotation (Line(points={{-19,-126},{-2,-126}},
                                               color={0,0,127}));
  connect(reaToInt.y, staTyp) annotation (Line(points={{21,-126},{30,-126},{30,-120},
          {270,-120}},       color={255,127,0}));
  connect(reaToInt.y, intToRea1.u) annotation (Line(points={{21,-126},{30,-126},
          {30,-200},{38,-200}}, color={255,127,0}));
  connect(intToRea1.y, sort.u)
    annotation (Line(points={{61,-200},{78,-200}}, color={0,0,127}));
  connect(sort.y, reaToInt1.u)
    annotation (Line(points={{101,-200},{118,-200}}, color={0,0,127}));
  connect(reaToInt.y, intEqu.u1) annotation (Line(points={{21,-126},{150,-126},{
          150,-170},{158,-170}}, color={255,127,0}));
  connect(reaToInt1.y, intEqu.u2) annotation (Line(points={{141,-200},{150,-200},
          {150,-178},{158,-178}}, color={255,127,0}));
  connect(intEqu.y, mulAnd.u[1:3]) annotation (Line(points={{181,-170},{190,
          -170},{190,-174.667},{198,-174.667}},
                                          color={255,0,255}));
  connect(mulAnd.y, assMes.u)
    annotation (Line(points={{221.7,-170},{238,-170}}, color={255,0,255}));
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
          extent={{-260,-300},{260,300}})),
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
end ConfiguratorT;
