within Buildings.Controls.OBC.CDL.Continuous.Validation;
model MatrixMin "Validation model for the MatrixMin block"

  Sources.Constant                                   con
              "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));

  Buildings.Controls.OBC.CDL.Continuous.MatrixMin matMin
    annotation (Placement(transformation(extent={{8,26},{28,46}})));
  annotation (
experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Continuous/Validation/MatrixGain.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.MatrixGain\">
Buildings.Controls.OBC.CDL.Continuous.MatrixGain</a>.
</p>
<p>
The input vector output two identical values <code>u[1]</code> and 
<code>u[2]</code> that vary from <i>0.0</i> to <i>+2</i>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 11, 2019, by Milica Grahovac:<br/>
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
