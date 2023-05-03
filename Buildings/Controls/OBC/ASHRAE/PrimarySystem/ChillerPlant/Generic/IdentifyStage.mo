within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic;
block IdentifyStage
  "Identify current stage according to the proven on status of the chillers"

  parameter Integer nSta = 3
    "Number of chiller stages";

  parameter Integer nChi = 2
    "Number of chillers";

  parameter Integer staMat[nSta, nChi] = {{1,0},{0,1},{1,1}}
    "Staging matrix with chiller stage as row index and chiller as column index";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Vector of chiller proven on status: true=ON"
    annotation(Placement(transformation(extent={{-140,10},{-100,50}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput ySta
    "Current stage index"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}}),
        iconTransformation(extent={{100,-20},{140,20}})));

protected
  final parameter Real staInd[nSta] = {i for i in 1:nSta}
    "Stage index vector";
  Buildings.Controls.OBC.CDL.Routing.BooleanVectorReplicator booVecRep(
    final nin=nChi,
    final nout=nSta)
    "Replicate boolean vector to be a matric with total stages as row size and total chillers as column size"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nSta,nChi]
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[nSta,nChi]
    "Output true if the first integer input one equals to the second integer input"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea [nSta,nChi]
    "Convert boolean to real"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Buildings.Controls.OBC.CDL.Continuous.MatrixMax rowMax(
    final nRow=nSta,
    final nCol=nChi)
    "Outputs the row-wise maximum"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.MatrixMin rowMin(
    final nRow=nSta,
    final nCol=nChi)
    "Outputs the row-wise minimum"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul[nSta]
    "Output product of the inputs"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con[nSta](
    final k=staInd)
    "Stage indices"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul1[nSta]
    "Output vector with the elements which equal to either zero or current stage index"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum curSta(
    final nin=nSta)
    "Current stage"
    annotation (Placement(transformation(extent={{30,-70},{50,-50}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt "Convert real to integer signal"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant chiStaMatr[nSta,nChi](
    final k=staMat)
    "Staging matrix"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));

equation
  connect(uChi, booVecRep.u)
    annotation (Line(points={{-120,30},{-82,30}}, color={255,0,255}));
  connect(booVecRep.y, booToInt.u)
    annotation (Line(points={{-58,30},{-42,30}}, color={255,0,255}));
  connect(chiStaMatr.y, intEqu.u1)
    annotation (Line(points={{-18,70},{-2,70}}, color={255,127,0}));
  connect(booToInt.y, intEqu.u2) annotation (Line(points={{-18,30},{-10,30},{-10,
          62},{-2,62}}, color={255,127,0}));
  connect(intEqu.y, booToRea.u)
    annotation (Line(points={{22,70},{38,70}}, color={255,0,255}));
  connect(booToRea.y,rowMax. u) annotation (Line(points={{62,70},{70,70},{70,10},
          {-90,10},{-90,-20},{-82,-20}},color={0,0,127}));
  connect(booToRea.y,rowMin. u) annotation (Line(points={{62,70},{70,70},{70,10},
          {-90,10},{-90,-60},{-82,-60}},color={0,0,127}));
  connect(rowMax.y, mul.u1) annotation (Line(points={{-58,-20},{-50,-20},{-50,-34},
          {-42,-34}},color={0,0,127}));
  connect(rowMin.y, mul.u2) annotation (Line(points={{-58,-60},{-50,-60},{-50,-46},
          {-42,-46}},color={0,0,127}));
  connect(mul.y, mul1.u1) annotation (Line(points={{-18,-40},{-10,-40},{-10,-54},
          {-2,-54}}, color={0,0,127}));
  connect(con.y, mul1.u2) annotation (Line(points={{-18,-80},{-10,-80},{-10,-66},
          {-2,-66}}, color={0,0,127}));
  connect(mul1.y, curSta.u)
    annotation (Line(points={{22,-60},{28,-60}}, color={0,0,127}));
  connect(curSta.y, reaToInt.u)
    annotation (Line(points={{52,-60},{58,-60}}, color={0,0,127}));
  connect(reaToInt.y, ySta)
    annotation (Line(points={{82,-60},{120,-60}}, color={255,127,0}));

annotation (defaultComponentName="ideSta",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          textColor={0,0,255},
          textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=false)),
Documentation(info="<html>
<p>
This subsequence is not directly specified in 1711 as it provides
a side calculation pertaining to generalization of the staging 
sequences for any number of chillers and stages provided by the 
user.
</p>
<p>
The subsequence outputs the current stage index <code>ySta</code> according
to the chillers proven on status <code>uChi</code>
given a staging matrix <code>staMat</code>.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 3, 2023, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end IdentifyStage;
