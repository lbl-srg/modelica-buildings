within Buildings.Controls.OBC.CDL.Logical.Validation;
model FallingEdge "Validation model for the falling edge block"

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
      width=0.5, period=1.0) "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp2(
    duration=5,
    offset=0,
    height=20) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triggeredSampler
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
equation
  connect(booPul.y, falEdg.u)
    annotation (Line(points={{-19,0},{-10,0},{-2,0}},
                                                    color={255,0,255}));
  connect(ramp2.y, triggeredSampler.u)
    annotation (Line(points={{21,50},{29.5,50},{38,50}}, color={0,0,127}));
  connect(falEdg.y, triggeredSampler.trigger) annotation (Line(points={{21,0},{
          36,0},{50,0},{50,38.2}}, color={255,0,255}));
  annotation (
  experiment(StopTime=5.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Logical/Validation/FallingEdge.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.FallingEdge\">
Buildings.Controls.OBC.CDL.Logical.FallingEdge</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 1, 2017, by Jianjun Hu:<br/>
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
end FallingEdge;
