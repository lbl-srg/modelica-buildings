within Buildings.Controls.OBC.CDL.Logical.Validation;
model TriggeredTrapezoid
  "Validation model for the TriggeredTrapezoid block"
extends Modelica.Icons.Example;

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
      width=0.5, period=2) "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-26,-10},{-6,10}})));
  Buildings.Controls.OBC.CDL.Logical.TriggeredTrapezoid triggeredTrapezoid1(
    amplitude = 5,
    rising = 0.3,
    offset = 1.5) "Triggered trapezoid generator"
    annotation (Placement(transformation(extent={{26,-10},{46,10}})));

equation
  connect(booPul.y, triggeredTrapezoid1.u)
    annotation (Line(points={{-5,0},{9.5,0},{24,0}}, color={255,0,255}));
  annotation (
  experiment(StopTime=5.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Logical/Validation/TriggeredTrapezoid.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.TriggeredTrapezoid\">
Buildings.Controls.OBC.CDL.Logical.TriggeredTrapezoid</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 2, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>

</html>"));
end TriggeredTrapezoid;
