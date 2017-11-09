within Buildings.Controls.OBC.CDL.Continuous.Sources.Validation;
model Sine "Validation model for Sine"
  extends Modelica.Icons.Example;

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin(
    amplitude=5,
    freqHz=1/60,
    phase=0,
    offset=10,
    startTime=10) "Sine source block"
    annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
  annotation (
  experiment(StopTime=130.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Continuous/Sources/Validation/Sine.mos"
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
November 06, 2017, by Milica Grahovac:<br/>
First CDL implementation.
</li>
</ul>
</html>"));
end Sine;
