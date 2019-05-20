within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block ConfiguratorT "Configures chiller staging"

  parameter Integer nSta = 3
    "Number of stages";

  parameter Integer nChi = 2
    "Number of chillers";

  parameter Integer chiTyp[nChi] = fill(1, nChi)
  "Chiller type: positive displacement, variable speed centrifugal, constant speed centrifugal";

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

//protected

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiNomCaps[nChi](
    final k=chiNomCap) "Array of nominal chiller capacities"
    annotation (Placement(transformation(extent={{-200,250},{-180,270}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiMinCaps[nChi](
    final k=chiMinCap) "Array of chiller unload capacities"
    annotation (Placement(transformation(extent={{-200,170},{-180,190}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiStaMat[nSta,nChi](
    final k=staMat)
                   "Staging matrix"
    annotation (Placement(transformation(extent={{-200,-160},{-180,-140}})));
  CDL.Interfaces.BooleanOutput staAva[nSta] "Stage availability status array"
    annotation (Placement(transformation(extent={{260,-70},{280,-50}}),
        iconTransformation(extent={{100,-100},{120,-80}})));
  CDL.Interfaces.RealOutput yStaNomCap[nSta](final unit="W", final quantity="Power")
    "Stage nominal capacities" annotation (Placement(transformation(extent={{260,
            50},{280,70}}), iconTransformation(extent={{100,60},{120,80}})));
  CDL.Interfaces.RealOutput yStaMinCap[nSta](final unit="W", final quantity="Power")
    "Stage minimal capacities" annotation (Placement(transformation(extent={{260,
            -10},{280,10}}), iconTransformation(extent={{100,20},{120,40}})));
  CDL.Integers.Sources.Constant staType[nSta,nChi](final k=chiTypExp)
    "Chiller stage type"
    annotation (Placement(transformation(extent={{-200,-100},{-180,-80}})));
  CDL.Continuous.Sort sort(nin=nSta)
    "this should check if stage type is as recommended and throw warning if sorted not equal generated stage type"
    annotation (Placement(transformation(extent={{20,-160},{40,-140}})));
  CDL.Continuous.MatrixGain staNomCaps(K=staMat)
    annotation (Placement(transformation(extent={{-120,210},{-100,230}})));
  CDL.Continuous.MatrixGain staMinCaps(K=staMat)
    annotation (Placement(transformation(extent={{-120,130},{-100,150}})));
  CDL.Continuous.Product pro[nSta,nChi]
    annotation (Placement(transformation(extent={{-100,-120},{-80,-100}})));
  CDL.Continuous.MatrixMax matMax(ninr=nSta, ninc=nChi)
    annotation (Placement(transformation(extent={{-40,-120},{-20,-100}})));
  CDL.Conversions.IntegerToReal intToRea[nSta,nChi]
    annotation (Placement(transformation(extent={{-160,-100},{-140,-80}})));
  CDL.Conversions.RealToInteger reaToInt[nSta]
    annotation (Placement(transformation(extent={{120,-120},{140,-100}})));
  CDL.Conversions.RealToInteger reaToInt1[nSta]
    annotation (Placement(transformation(extent={{60,-162},{80,-142}})));
  CDL.Integers.Equal intEqu[nSta] "check if all true (sum = nSta)"
    annotation (Placement(transformation(extent={{160,-180},{180,-160}})));
  CDL.Continuous.MatrixGain staMinCaps1(K=staMat)
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));
  CDL.Continuous.MatrixGain staMinCaps2(K=staMat)
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));
  CDL.Continuous.Sources.Constant oneVec[nChi](final k=fill(1, nSta))
    "All chillers available"
    annotation (Placement(transformation(extent={{-200,40},{-180,60}})));
  CDL.Conversions.BooleanToReal booToRea[nChi]
    annotation (Placement(transformation(extent={{-200,-10},{-180,10}})));
  CDL.Continuous.Add add2[nSta](k2=fill(-1, nSta))
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  CDL.Continuous.GreaterThreshold greThr[nSta](threshold=fill(0.5, nSta))
    "Checks if the number of chillers available in each stage equals the design number of chillers"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  CDL.Interfaces.IntegerOutput staTyp[nSta](
    final max=nSta,
    final min=1,
    final start=3) "Chiller stage type" annotation (Placement(transformation(
          extent={{260,-130},{280,-110}}), iconTransformation(extent={{100,40},
            {120,60}})));
equation
  connect(chiNomCaps.y, staNomCaps.u) annotation (Line(points={{-179,260},{-140,
          260},{-140,220},{-122,220}},
                                color={0,0,127}));
  connect(staNomCaps.y, yStaNomCap) annotation (Line(points={{-99,220},{100,220},
          {100,60},{270,60}},
                         color={0,0,127}));
  connect(staMinCaps.y, yStaMinCap) annotation (Line(points={{-99,140},{80,140},
          {80,0},{270,0}},   color={0,0,127}));
  connect(staType.y, intToRea.u)
    annotation (Line(points={{-179,-90},{-162,-90}}, color={255,127,0}));
  connect(intToRea.y, pro.u1) annotation (Line(points={{-139,-90},{-120,-90},{-120,
          -104},{-102,-104}}, color={0,0,127}));
  connect(chiStaMat.y, pro.u2) annotation (Line(points={{-179,-150},{-120,-150},
          {-120,-116},{-102,-116}}, color={0,0,127}));
  connect(pro.y,matMax. u)
    annotation (Line(points={{-79,-110},{-42,-110}}, color={0,0,127}));
  connect(matMax.y, reaToInt.u)
    annotation (Line(points={{-19,-110},{118,-110}}, color={0,0,127}));
  connect(matMax.y, sort.u) annotation (Line(points={{-19,-110},{0,-110},{0,-150},
          {18,-150}}, color={0,0,127}));
  connect(sort.y, reaToInt1.u) annotation (Line(points={{41,-150},{50,-150},{50,
          -152},{58,-152}}, color={0,0,127}));
  connect(reaToInt.y, intEqu.u1) annotation (Line(points={{141,-110},{150,-110},
          {150,-170},{158,-170}}, color={255,127,0}));
  connect(reaToInt1.y, intEqu.u2) annotation (Line(points={{81,-152},{120,-152},
          {120,-178},{158,-178}}, color={255,127,0}));
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
  connect(add2.y, greThr.u)
    annotation (Line(points={{-59,20},{-42,20}}, color={0,0,127}));
  connect(greThr.y, staAva) annotation (Line(points={{-19,20},{60,20},{60,-60},{
          270,-60}}, color={255,0,255}));
  connect(reaToInt.y, staTyp) annotation (Line(points={{141,-110},{202,-110},{
          202,-120},{270,-120}}, color={255,127,0}));
  annotation (defaultComponentName = "staCon",
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
