within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences;
block ChillerIndices "Returns chiller indices for the current stage"

  parameter Integer nSta = 3
    "Number of chiller stages";

  parameter Integer nChi = 2
    "Number of chillers";

  parameter Integer staMat[nSta, nChi] = {{1,0},{0,1},{1,1}}
    "Staging matrix with stages in rows and chillers in columns";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput u(
    final min=0,
    final max=nSta,
    final start=0) "Current chiller stage"
    annotation (Placement(transformation(extent={{-240,0},{-200,40}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChi[nChi]
    "Chiller status setpoint vector for the current stage"
    annotation (Placement(transformation(extent={{200,-20},{240,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

protected
  final parameter Integer staInd[nSta] = {i for i in 1:nSta}
    "Stage index vector";

  final parameter Integer staIndMat[nSta, nChi] = {j for i in 1:nChi, j in 1:nSta}
    "Matrix of staging matrix dimensions with stage indices in each column";

  final parameter Integer lowDia[nSta, nSta] = {if i<=j then 1 else 0 for i in 1:nSta, j in 1:nSta}
    "Lower diagonal unit matrix";

  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intRep(
    final nout=nSta) "Replicates signal to a length equal the stage count"
    annotation (Placement(transformation(extent={{-180,10},{-160,30}})));

  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intRep1[nSta](
    final nout=fill(nChi, nSta)) "Replicates signal to dimensions of the staging matrix"
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant staIndMatr[nSta,nChi](
    final k=staIndMat) "Matrix with stage index in each column"
    annotation (Placement(transformation(extent={{-140,-40},{-120,-20}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1[nSta,nChi]
    "Outputs a zero matrix populated with ones in the current stage index row"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant chiStaMatr[nSta,nChi](
    final k=staMat) "Staging matrix"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.MatrixMax matMax(
    final nRow=nSta,
    final nCol=nChi,
    final rowMax=false) "Column-wise matrix maximum"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold chiInSta[nChi](t=fill(0.5, nChi))
    "Identifies chillers designated to operate in a given stage"
    annotation (Placement(transformation(extent={{140,-10},{160,10}})));

  Buildings.Controls.OBC.CDL.Integers.Multiply proInt[nSta,nChi]
    "Outputs a zero matrix populated with ones for any available chiller in the current stage"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nSta,nChi](
    final integerTrue=fill(1, nSta, nChi),
    final integerFalse=fill(0, nSta, nChi))
    "Type converter"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea[nSta,nChi]
    "Type converter"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

equation
  connect(intRep.y, intRep1.u)
    annotation (Line(points={{-158,20},{-142,20}}, color={255,127,0}));
  connect(intRep1.y, intEqu1.u1)
    annotation (Line(points={{-118,20},{-82,20}}, color={255,127,0}));
  connect(matMax.y, chiInSta.u)
    annotation (Line(points={{122,0},{138,0}},    color={0,0,127}));
  connect(staIndMatr.y, intEqu1.u2) annotation (Line(points={{-118,-30},{-100,-30},
          {-100,12},{-82,12}},         color={255,127,0}));
  connect(chiInSta.y, yChi)
    annotation (Line(points={{162,0},{220,0}},
          color={255,0,255}));
  connect(proInt.y, intToRea.u)
    annotation (Line(points={{42,0},{58,0}},    color={255,127,0}));
  connect(intToRea.y, matMax.u)
    annotation (Line(points={{82,0},{98,0}},     color={0,0,127}));
  connect(booToInt.y, proInt.u1) annotation (Line(points={{-18,20},{0,20},{0,6},
          {18,6}},            color={255,127,0}));
  connect(intEqu1.y, booToInt.u)
    annotation (Line(points={{-58,20},{-42,20}},   color={255,0,255}));
  connect(chiStaMatr.y, proInt.u2) annotation (Line(points={{-38,-30},{0,-30},{0,
          -6},{18,-6}},         color={255,127,0}));
  connect(u, intRep.u) annotation (Line(points={{-220,20},{-182,20}},
                       color={255,127,0}));
  annotation (defaultComponentName = "chiInd",
        Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          textColor={0,0,255},
          textString="%name")}),
        Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-200,-60},{200,60}})),
Documentation(info="<html>
<p>
This subsequence is not directly specified in 1711 as it provides
a side calculation pertaining to generalization of the staging 
sequences for any number of chillers and stages provided by the 
user.
</p>
<p>
The subsequence outputs a vector of chiller indices <code>yChi</code>
for a stage index input <code>u</code> given a staging matrix <code>staMat</code>.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 15, 2020, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end ChillerIndices;
