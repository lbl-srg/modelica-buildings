within Buildings.Controls.OBC.CDL.Utilities.Validation;
model Assert "Validate the Assert block"
  extends Modelica.Icons.Example;
  Buildings.Controls.OBC.CDL.Utilities.Assert assert(message=
        "input became false")
    "Trigger warning and print warning message"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(period=0.5)
    "Output boolean pulse"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

equation
  connect(booPul.y, assert.u)
    annotation (Line(points={{-19,0},{18,0}},   color={255,0,255}));

annotation (
  experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Utilities/Validation/Assert.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Utilities.Assert\">
Buildings.Controls.OBC.CDL.Utilities.Assert</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
November 3, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Assert;
