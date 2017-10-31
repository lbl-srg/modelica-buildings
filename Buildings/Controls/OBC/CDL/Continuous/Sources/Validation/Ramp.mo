within Buildings.Controls.OBC.CDL.Continuous.Sources.Validation;
model Ramp "Validation model for the Ramp"
extends Modelica.Icons.Example;

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram(
    height = 2,
    duration = 3,
    offset=0.5,
    startTime = 1.0)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  annotation (
  experiment(StopTime=5.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Continuous/Sources/Validation/Ramp.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp\">
Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 17, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Ramp;
