within Buildings.Controls.OBC.CDL.Utilities.Validation;
model Assert "Validate the Assert block"
  extends Modelica.Icons.Example;
  Buildings.Controls.OBC.CDL.Utilities.Assert assert
    "Trigger warning and print warning message"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(period=0.5)
    "Output boolean pulse"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

equation
  connect(booPul.y, assert.u)
    annotation (Line(points={{-59,50},{38,50}}, color={255,0,255}));

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
