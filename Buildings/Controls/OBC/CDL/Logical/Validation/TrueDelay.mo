within Buildings.Controls.OBC.CDL.Logical.Validation;
model TrueDelay "Validation model for the TrueDelay block"
extends Modelica.Icons.Example;

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
      width=0.5, period=1.5) "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay onDelay(delayTime=0)
    "Delay a rising edge of the input, but do not delay a falling edge."
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay onDelay1(delayTime=0.5)
    "Delay a rising edge of the input, but do not delay a falling edge."
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay onDelay2(delayTime=0.8)
    "Delay a rising edge of the input, but do not delay a falling edge."
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));

equation
  connect(booPul.y, onDelay.u)
    annotation (Line(points={{-19,30},{18,30}}, color={255,0,255}));
  connect(booPul.y, onDelay1.u)
    annotation (Line(points={{-19,30},{0,30},{0,-10},{18,-10}},
      color={255,0,255}));
  connect(booPul.y, onDelay2.u)
    annotation (Line(points={{-19,30},{0,30},{0,-50},{18,-50}},
      color={255,0,255}));

annotation (
  experiment(StopTime=5.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Logical/Validation/TrueDelay.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.TrueDelay\">
Buildings.Controls.OBC.CDL.Logical.TrueDelay</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 2, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>

</html>"));
end TrueDelay;
