within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Staging.Subsequences;
block ChangeCells "Identify changing cells"

  parameter Integer nTowCel = 4
    "Total number of cooling tower cells";
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uCelNum
    "Total number of cells that should be enabled"
    annotation (Placement(transformation(extent={{-180,-40},{-140,0}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uTowSta[nTowCel]
    "Vector of tower cells proven on status: true=enabled tower cell"
    annotation (Placement(transformation(extent={{-180,-80},{-140,-40}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yTowSta[nTowCel]
    "True: tower cell should be enabled"
    annotation (Placement(transformation(extent={{120,40},{160,80}}),
        iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChaCel[nTowCel]
    "True: the cell should change status, either become enabled or disabled"
    annotation (Placement(transformation(extent={{120,0},{160,40}}),
        iconTransformation(extent={{100,-60},{140,-20}})));

protected
  final parameter Integer celInd[nTowCel]={i for i in 1:nTowCel}
    "Tower cell index, {1,2,...,n}";
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[nTowCel](
    final k=celInd)
    "Tower cell index array"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intRep(
    final nout=nTowCel)
    "Replicate integer input"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Not chaCel[nTowCel] "True: the cell should change the status"
    annotation (Placement(transformation(extent={{80,10},{100,30}})));
  Buildings.Controls.OBC.CDL.Integers.LessEqual intLesEqu[nTowCel]
    "True: the cell should be enabled"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nTowCel]
    "Convert boolean to equal"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[nTowCel]
    "True: cooling tower cell status is the same as commanded on"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1[nTowCel]
    "Convert boolean to equal"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));

equation
  connect(uCelNum, intRep.u)
    annotation (Line(points={{-160,-20},{-122,-20}}, color={255,127,0}));
  connect(conInt.y, intLesEqu.u1)
    annotation (Line(points={{-98,20},{-62,20}}, color={255,127,0}));
  connect(intRep.y, intLesEqu.u2) annotation (Line(points={{-98,-20},{-80,-20},{
          -80,12},{-62,12}}, color={255,127,0}));
  connect(uTowSta, booToInt1.u)
    annotation (Line(points={{-160,-60},{-22,-60}}, color={255,0,255}));
  connect(intLesEqu.y, booToInt.u)
    annotation (Line(points={{-38,20},{-22,20}}, color={255,0,255}));
  connect(booToInt.y, intEqu.u1)
    annotation (Line(points={{2,20},{38,20}}, color={255,127,0}));
  connect(booToInt1.y, intEqu.u2) annotation (Line(points={{2,-60},{20,-60},{20,
          12},{38,12}}, color={255,127,0}));
  connect(intEqu.y, chaCel.u)
    annotation (Line(points={{62,20},{78,20}}, color={255,0,255}));
  connect(chaCel.y, yChaCel)
    annotation (Line(points={{102,20},{140,20}}, color={255,0,255}));
  connect(intLesEqu.y, yTowSta) annotation (Line(points={{-38,20},{-30,20},{-30,
          60},{140,60}}, color={255,0,255}));
annotation (defaultComponentName="ideChaCel",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
    graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          textColor={0,0,255},
          textString="%name")}),
 Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-140,-80},{120,80}})),
 Documentation(info="<html>
<p>
This block identifies the cooling tower cells that should change the enabling
status, either should be enabled or disabled.
</p>
<p>
It assumes that the cells are enabled in order as cell 1, 2, 3, etc.
</p>
</html>", revisions="<html>
<ul>
<li>
July 26, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ChangeCells;
