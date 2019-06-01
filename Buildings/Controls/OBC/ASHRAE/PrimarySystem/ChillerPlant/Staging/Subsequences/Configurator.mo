within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block Configurator "Configures chiller staging"

  parameter Integer nSta = 3
    "Number of stages";

  parameter Integer nChi = 2
    "Number of chillers";

  parameter Integer staMat[nSta, nChi] = {{1,0},{0,1},{1,1}}
    "Staging matrix with stages in rows and chillers in columns";

  parameter Integer chiTyp[nChi] = {1,2}
    "Chiller type: 1 - positive displacement, 2 - variable speed centrifugal, 3 - constant speed centrifugal";

  parameter Modelica.SIunits.Power chiNomCap[nChi]
    "Nominal chiller capacities";

  parameter Modelica.SIunits.Power chiMinCap[nChi]
    "Chiller unload capacities";

  final parameter Integer chiTypExp[nSta, nChi] = {chiTyp[i] for i in 1:nChi, j in 1:nSta}
    "Chiller type array expanded to allow for elementwise multiplication with the staging matrix";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiAva[nChi]
    "Chiller availability status"
    annotation (Placement(transformation(extent={{-300,-20},{-260,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yAva[nSta]
    "Stage availability status array" annotation (Placement(transformation(
          extent={{260,-30},{280,-10}}), iconTransformation(extent={{100,-80},{
            120,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yTyp[nSta](final max=nSta)
    "Nominal chiller stage types"
                         annotation (Placement(transformation(extent={{260,-90},
            {280,-70}}), iconTransformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yNomCap[nSta](final unit="W",
      final quantity="Power") "Stage nominal capacities" annotation (Placement(
        transformation(extent={{260,60},{280,80}}),   iconTransformation(extent={{100,60},
            {120,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMinCap[nSta](final unit="W",
      final quantity="Power") "Stage minimal capacities" annotation (Placement(
        transformation(extent={{260,0},{280,20}}),  iconTransformation(extent={{100,40},
            {120,60}})));

//protected

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiNomCaps[nChi](
    final k=chiNomCap) "Array of nominal chiller capacities"
    annotation (Placement(transformation(extent={{-180,180},{-160,200}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiMinCaps[nChi](
    final k=chiMinCap) "Array of chiller unload capacities"
    annotation (Placement(transformation(extent={{-180,120},{-160,140}})));

  Buildings.Controls.OBC.CDL.Continuous.MatrixGain staNomCaps(K=staMat)
    annotation (Placement(transformation(extent={{-120,180},{-100,200}})));
  Buildings.Controls.OBC.CDL.Continuous.MatrixGain staMinCaps(K=staMat)
    annotation (Placement(transformation(extent={{-120,120},{-100,140}})));
  Buildings.Controls.OBC.CDL.Continuous.MatrixGain staMinCaps1(K=staMat)
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Continuous.MatrixGain staMinCaps2(K=staMat)
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oneVec[nChi](final k=fill(1, nSta))
    "All chillers available"
    annotation (Placement(transformation(extent={{-180,50},{-160,70}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nChi]
    annotation (Placement(transformation(extent={{-180,-10},{-160,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2[nSta](k2=fill(-1, nSta))
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold                           lesThr[nSta](threshold=fill(0.5, nSta))
    "Checks if the number of chillers available in each stage equals the design number of chillers"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiStaMat[nSta,nChi](final k=
        staMat) "Staging matrix"
    annotation (Placement(transformation(extent={{-180,-140},{-160,-120}})));
  CDL.Continuous.Sources.Constant                      staType[nSta,nChi](final k=chiTypExp)
    "Chiller stage type"
    annotation (Placement(transformation(extent={{-180,-80},{-160,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro[nSta,nChi]
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.MatrixMax matMax(nRow=nSta, nCol=nChi)
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt[nSta]
    annotation (Placement(transformation(extent={{-20,-100},{0,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sort sort(nin=nSta)
    annotation (Placement(transformation(extent={{60,-170},{80,-150}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1[nSta]
    annotation (Placement(transformation(extent={{20,-170},{40,-150}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1[nSta]
    annotation (Placement(transformation(extent={{100,-170},{120,-150}})));
  Buildings.Controls.OBC.CDL.Integers.Equal                        intEqu[nSta]
    annotation (Placement(transformation(extent={{140,-140},{160,-120}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(message="Chillers are not staged according to G36 recommendation: stage any positive displacement machines first, stage any variable speed centrifugal next and any constant speed centrifugal last.")
    annotation (Placement(transformation(extent={{220,-140},{240,-120}})));

  CDL.Logical.MultiAnd mulAnd(nu=nSta)
    annotation (Placement(transformation(extent={{180,-140},{200,-120}})));
equation
  connect(chiNomCaps.y, staNomCaps.u) annotation (Line(points={{-159,190},{-122,
          190}},                color={0,0,127}));
  connect(oneVec.y, staMinCaps1.u)
    annotation (Line(points={{-159,60},{-122,60}}, color={0,0,127}));
  connect(chiMinCaps.y, staMinCaps.u) annotation (Line(points={{-159,130},{-122,
          130}},                         color={0,0,127}));
  connect(uChiAva, booToRea.u)
    annotation (Line(points={{-280,0},{-182,0}}, color={255,0,255}));
  connect(booToRea.y, staMinCaps2.u) annotation (Line(points={{-159,0},{-122,0}},
                                    color={0,0,127}));
  connect(staMinCaps1.y, add2.u1) annotation (Line(points={{-99,60},{-80,60},{-80,
          36},{-62,36}},      color={0,0,127}));
  connect(staMinCaps2.y, add2.u2) annotation (Line(points={{-99,0},{-80.5,0},{-80.5,
          24},{-62,24}},         color={0,0,127}));
  connect(add2.y,lesThr. u)
    annotation (Line(points={{-39,30},{-22,30}}, color={0,0,127}));
  connect(lesThr.y, yAva) annotation (Line(points={{1,30},{80,30},{80,-20},{270,
          -20}},color={255,0,255}));
  connect(chiStaMat.y,pro. u2) annotation (Line(points={{-159,-130},{-130,-130},
          {-130,-96},{-122,-96}},   color={0,0,127}));
  connect(pro.y,matMax. u)
    annotation (Line(points={{-99,-90},{-62,-90}},
                                               color={0,0,127}));
  connect(matMax.y,reaToInt. u)
    annotation (Line(points={{-39,-90},{-22,-90}},
                                               color={0,0,127}));
  connect(reaToInt.y, yTyp) annotation (Line(points={{1,-90},{10,-90},{10,-80},{
          270,-80}},  color={255,127,0}));
  connect(reaToInt.y, intToRea1.u) annotation (Line(points={{1,-90},{10,-90},{10,
          -160},{18,-160}},     color={255,127,0}));
  connect(intToRea1.y, sort.u)
    annotation (Line(points={{41,-160},{58,-160}}, color={0,0,127}));
  connect(sort.y, reaToInt1.u)
    annotation (Line(points={{81,-160},{98,-160}},   color={0,0,127}));
  connect(reaToInt.y,intEqu. u1) annotation (Line(points={{1,-90},{130,-90},{130,
          -130},{138,-130}},     color={255,127,0}));
  connect(reaToInt1.y,intEqu. u2) annotation (Line(points={{121,-160},{130,-160},
          {130,-138},{138,-138}}, color={255,127,0}));
  connect(mulAnd.y, assMes.u)
    annotation (Line(points={{201.7,-130},{218,-130}},
                                                     color={255,0,255}));
  connect(intEqu.y, mulAnd.u) annotation (Line(points={{161,-130},{178,-130}},
                                          color={255,0,255}));
  connect(staType.y, pro.u1) annotation (Line(points={{-159,-70},{-130,-70},{-130,
          -84},{-122,-84}},color={0,0,127}));
  connect(staNomCaps.y, yNomCap) annotation (Line(points={{-99,190},{160,190},{160,
          70},{270,70}}, color={0,0,127}));
  connect(staMinCaps.y, yMinCap) annotation (Line(points={{-99,130},{100,130},{100,
          10},{270,10}}, color={0,0,127}));
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
          extent={{-260,-240},{260,240}})),
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
