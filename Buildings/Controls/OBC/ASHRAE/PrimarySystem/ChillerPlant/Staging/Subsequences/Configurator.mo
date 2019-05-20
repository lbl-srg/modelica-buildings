within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block Configurator "Configures chiller staging"

  parameter Integer nSta = 3
    "Number of stages";

  parameter Integer nChi = 2
    "Number of chillers";

  parameter Integer chiTyp[nChi] = fill(1, nChi)
  "Chiller type: positive displacement, variable speed centrifugal, constant speed centrifugal";

  parameter Integer chiTypExp[nSta, nChi] = {chiTyp[j] for j in 1:nChi, i in 1:nSta}
  "Chiller type array expanded to allow for elementwise multiplication with the staging matrix";

  parameter Real staMat[nSta, nChi] = fill(0, nSta, nChi)
    "Array of nominal capacities at each individual stage with row index representing the chiller index";

  parameter Modelica.SIunits.Power chiNomCap[nChi] = fill(5e5, nChi)
    "Array of nominal chiller capacities";

  parameter Modelica.SIunits.Power chiMinCap[nChi] = fill(0.2*chiNomCap[1], nChi)
    "Array of chiller unload capacities";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiAva[nChi]
    "Chiller availability status"
    annotation (Placement(transformation(extent={{-300,-20},{-260,20}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));

//protected

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiNomCaps[nSta](
    final k=chiNomCap) "Array of nominal chiller capacities"
    annotation (Placement(transformation(extent={{-200,80},{-180,100}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiMinCaps[nSta](
    final k=chiMinCap) "Array of chiller unload capacities"
    annotation (Placement(transformation(extent={{-200,0},{-180,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiStaMat[nChi,nSta](final k=
        staMat)        "Staging matrix"
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
  CDL.Integers.Sources.Constant staType[nChi,nSta](final k=staTypExp)
    "Chiller stage type"
    annotation (Placement(transformation(extent={{-200,-100},{-180,-80}})));
  CDL.Interfaces.IntegerOutput staTyp[nSta] "Stage type array" annotation (
      Placement(transformation(extent={{260,-130},{280,-110}}),
        iconTransformation(extent={{-452,60},{-432,80}})));
  CDL.Continuous.Sort sort(nin=nSta)
    "this should check if stage type is as recommended and throw warning if sorted not equal generated stage type"
    annotation (Placement(transformation(extent={{20,-160},{40,-140}})));
  CDL.Continuous.MatrixGain staNomCaps(K=staMat)
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  CDL.Continuous.MatrixGain staMinCaps(K=staMat)
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));
  CDL.Continuous.Product pro[nChi,nSta]
    annotation (Placement(transformation(extent={{-100,-120},{-80,-100}})));
  CDL.Continuous.MatrixMax matMin
    annotation (Placement(transformation(extent={{-40,-120},{-20,-100}})));
  CDL.Conversions.IntegerToReal intToRea[nChi,nSta]
    annotation (Placement(transformation(extent={{-160,-100},{-140,-80}})));
  CDL.Conversions.RealToInteger reaToInt[nSta]
    annotation (Placement(transformation(extent={{120,-120},{140,-100}})));
  CDL.Utilities.Assert assMes
    annotation (Placement(transformation(extent={{200,-240},{220,-220}})));
  CDL.Conversions.RealToInteger reaToInt1[nSta]
    annotation (Placement(transformation(extent={{60,-162},{80,-142}})));
  CDL.Integers.Equal intEqu[nSta] "check if all true (sum = nSta)"
    annotation (Placement(transformation(extent={{166,-178},{186,-158}})));
  CDL.Interfaces.IntegerInput                        uSta(final min=0, final
      max=nSta)       "Chiller stage"
    annotation (Placement(transformation(extent={{-300,60},{-260,100}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
equation
  connect(chiNomCaps.y, staNomCaps.u) annotation (Line(points={{-179,90},{-150,90},
          {-150,50},{-122,50}}, color={0,0,127}));
  connect(chiMinCaps.y, staMinCaps.u) annotation (Line(points={{-179,10},{-150,10},
          {-150,-30},{-122,-30}}, color={0,0,127}));
  connect(staNomCaps.y, yStaNomCap) annotation (Line(points={{-99,50},{82,50},{82,
          60},{270,60}}, color={0,0,127}));
  connect(staMinCaps.y, yStaMinCap) annotation (Line(points={{-99,-30},{82,-30},
          {82,0},{270,0}},   color={0,0,127}));
  connect(staType.y, intToRea.u)
    annotation (Line(points={{-179,-90},{-162,-90}}, color={255,127,0}));
  connect(intToRea.y, pro.u1) annotation (Line(points={{-139,-90},{-120,-90},{
          -120,-104},{-102,-104}}, color={0,0,127}));
  connect(chiStaMat.y, pro.u2) annotation (Line(points={{-179,-150},{-120,-150},
          {-120,-116},{-102,-116}}, color={0,0,127}));
  connect(pro.y, matMin.u)
    annotation (Line(points={{-79,-110},{-42,-110}}, color={0,0,127}));
  connect(matMin.y, reaToInt.u)
    annotation (Line(points={{-19,-110},{118,-110}}, color={0,0,127}));
  connect(reaToInt.y, staTyp) annotation (Line(points={{141,-110},{200,-110},{
          200,-120},{270,-120}}, color={255,127,0}));
  connect(matMin.y, sort.u) annotation (Line(points={{-19,-110},{0,-110},{0,
          -150},{18,-150}}, color={0,0,127}));
  connect(sort.y, reaToInt1.u) annotation (Line(points={{41,-150},{50,-150},{50,
          -152},{58,-152}}, color={0,0,127}));
  connect(reaToInt.y, intEqu.u1) annotation (Line(points={{141,-110},{154,-110},
          {154,-168},{164,-168}}, color={255,127,0}));
  connect(reaToInt1.y, intEqu.u2) annotation (Line(points={{81,-152},{122,-152},
          {122,-176},{164,-176}}, color={255,127,0}));
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
end Configurator;
