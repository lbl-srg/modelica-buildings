within Buildings.Controls.OBC.CDL.Continuous.Validation;
model AddParameter "Validation model for the AddParameter block"
extends Modelica.Icons.Example;

  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    p = 0.5,
    k = 1.0)
    "Block that outputs the sum of an input plus a parameter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp1(
    duration=1,
    offset=-2,
    height=4)  "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
equation
  connect(ramp1.y, addPar.u)
    annotation (Line(points={{-39,0},{-26,0},{-12,0}}, color={0,0,127}));
  annotation (
experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Continuous/Validation/AddParameter.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.AddParameter\">
Buildings.Controls.OBC.CDL.Continuous.AddParameter</a>.
</p>
<p>
The input <code>u</code> varies from <i>-2</i> to <i>+2</i>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 17, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>

</html>"));
end AddParameter;
