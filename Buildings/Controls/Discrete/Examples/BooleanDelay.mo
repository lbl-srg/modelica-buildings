within Buildings.Controls.Discrete.Examples;
model BooleanDelay "Example model for boolean delay"
  extends Modelica.Icons.Example;
  Buildings.Controls.Discrete.BooleanDelay del(samplePeriod=0.1)
                                               annotation (Placement(
        transformation(extent={{0,-20},{20,0}})));
  Modelica.Blocks.Sources.BooleanPulse booleanPulse(period=0.25)
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
equation
  connect(booleanPulse.y, del.u) annotation (Line(points={{-39,-10},{-2,-10}},
        color={255,0,255}));
 annotation (experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/Discrete/Examples/BooleanDelay.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Example that demonstrates the use of the boolean delay block.
The output signal of the block is delayed by one sampling interval
to produce a response as shown in the figure below in which the sampling
interval is <i>0.1</i> second, as indicated by the markers.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/Discrete/Examples/BooleanDelay.png\" border=\"1\" alt=\"Input and output of the boolean delay.\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
November 21, 2011, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>"));
end BooleanDelay;
