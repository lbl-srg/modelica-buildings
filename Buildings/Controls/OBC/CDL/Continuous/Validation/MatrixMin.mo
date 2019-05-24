within Buildings.Controls.OBC.CDL.Continuous.Validation;
model MatrixMin "Validation model for the MatrixMin block"

  Sources.Constant con[3,3](k={{-1,-2,-3},{-6,-4,-2},{-3,-9,-6}})
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));

  Sources.Constant con1[2,3](k={{-1,-4,-3},{-2,-2,-6}})
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Sources.Constant con2[2,3](k={{-1,-2,-3},{-6,-4,-2}})
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.MatrixMin matMin(
    nRow=3,
    nCol=3,
    rowMin=false) "Matrix minimum"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));

  Buildings.Controls.OBC.CDL.Continuous.MatrixMin matMin1(
    nCol=3,
    rowMin=false,
    nRow=2) "Matrix minimum"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

  Buildings.Controls.OBC.CDL.Continuous.MatrixMin matMin2(
    nCol=3,
    rowMin=true,
    nRow=2) "Matrix minimum"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));

equation
  connect(con.y, matMin.u)
    annotation (Line(points={{-19,60},{-2,60}}, color={0,0,127}));
  connect(con1.y, matMin1.u)
    annotation (Line(points={{-19,0},{-2,0}}, color={0,0,127}));
  connect(con2.y, matMin2.u)
    annotation (Line(points={{-19,-60},{-2,-60}}, color={0,0,127}));
  annotation (
experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Continuous/Validation/MatrixMin.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.MatrixMin\">
Buildings.Controls.OBC.CDL.Continuous.MatrixMin</a>.
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
end MatrixMin;
