within Buildings.Controls.Discrete.Examples;
model BooleanDelay "Example model for boolean delay"
  extends Modelica.Icons.Example;
  Buildings.Controls.Discrete.BooleanDelay del(samplePeriod=0.05)
                                               annotation (Placement(
        transformation(extent={{0,-20},{20,0}})));
  Modelica.Blocks.Sources.BooleanPulse booleanPulse(
    period=0.1,
    width=50,
    startTime=0.01)
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
equation
  connect(booleanPulse.y, del.u) annotation (Line(points={{-39,-10},{-22,-10},{-2,
          -10}},
        color={255,0,255}));
 annotation (experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/Discrete/Examples/BooleanDelay.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Example that demonstrates the use of the boolean delay block.
The output signal of the block is delayed by one sampling interval.
</p>
</html>", revisions="<html>
<ul>
<li>
January 3, 2017, by Michael Wetter:<br/>
Changed sampling interval to avoid simultaneous events.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/641\">#641</a>.
</li>
<li>
November 21, 2011, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>"));
end BooleanDelay;
