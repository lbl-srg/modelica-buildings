within Buildings.Controls.OBC.CDL.Logical.Validation;
model LessThreshold "Validation model for the LessThreshold block"
extends Modelica.Icons.Example;

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp1(
    duration=1,
    offset=-2,
    height=4)  "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-36,-10},{-16,10}})));

  Buildings.Controls.OBC.CDL.Logical.LessEqualThreshold lesThr
    annotation (Placement(transformation(extent={{16,-10},{36,10}})));

equation
  connect(ramp1.y, lesThr.u)
    annotation (Line(points={{-15,0},{0,0},{14,0}}, color={0,0,127}));
  annotation (
  experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Logical/Validation/LessThreshold.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.LessThreshold\">
Buildings.Controls.OBC.CDL.Logical.LessThreshold</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 1, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>

</html>"));
end LessThreshold;
