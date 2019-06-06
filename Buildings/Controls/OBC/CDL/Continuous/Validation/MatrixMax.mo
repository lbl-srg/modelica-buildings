within Buildings.Controls.OBC.CDL.Continuous.Validation;
model MatrixMax "Validation model for the MatrixMax block"

  Sources.Constant con[3,3](k={{1,2,3},{6,4,2},{3,9,6}})
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));

  Sources.Constant con1[2,3](k={{1,4,3},{2,2,6}})
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Sources.Constant con2[2,3](k={{1,2,3},{6,4,2}})
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.MatrixMax matMax(
    rowMax=false,
    nRow=3,
    nCol=3) "Matrix maximum"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));

  Buildings.Controls.OBC.CDL.Continuous.MatrixMax matMax1(
    nCol=3,
    nRow=2) "Matrix maximum"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

  Buildings.Controls.OBC.CDL.Continuous.MatrixMax matMax2(
    nCol=3,
    nRow=2) "Matrix maximum"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));

equation
  connect(con.y,matMax. u)
    annotation (Line(points={{-19,60},{-2,60}}, color={0,0,127}));
  connect(con1.y,matMax1. u)
    annotation (Line(points={{-19,0},{-2,0}}, color={0,0,127}));
  connect(con2.y,matMax2. u)
    annotation (Line(points={{-19,-60},{-2,-60}}, color={0,0,127}));
  annotation (
experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Continuous/Validation/MatrixMax.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.MatrixMax\">
Buildings.Controls.OBC.CDL.Continuous.MatrixMax</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
May 17, 2019, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>

</html>"),
    Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}));
end MatrixMax;
