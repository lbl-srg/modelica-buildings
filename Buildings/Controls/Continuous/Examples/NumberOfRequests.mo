within Buildings.Controls.Continuous.Examples;
model NumberOfRequests
  "Example model for block that outputs the number of requests"
  extends Modelica.Icons.Example;
  Buildings.Controls.Continuous.NumberOfRequests numReq(
    nin=2,
    threShold=0,
    kind=0) annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Modelica.Blocks.Sources.Sine sine(freqHz=2)
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Modelica.Blocks.Sources.Pulse pulse(period=0.35)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
equation
  connect(sine.y, numReq.u[1]) annotation (Line(points={{-39,-10},{-19.5,-10},{
          -19.5,29},{-2,29}}, color={0,0,127}));
  connect(pulse.y, numReq.u[2]) annotation (Line(points={{-39,30},{-20,30},{-20,
          31},{-2,31}}, color={0,0,127}));
 annotation (experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/Continuous/Examples/NumberOfRequests.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
January 12, 2017, by Thierry S. Nouidui:<br/>
Modified example to prevent simultaneous events
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/646\">#646</a>.
</li>
<li>
November 21, 2011, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>", info="<html>
<p>
Example that demonstrates the use of the block
<a href=\"modelica://Buildings.Controls.Continuous.NumberOfRequests\">
Buildings.Controls.Continuous.NumberOfRequests</a>.
The parameters of the block are such that the output is incremented
for each input signal that is strictly larger than <i>0</i>.
The figure below shows the inputs and the output of the block.
</p>
<p align=\"center\">
<img alt=\"Simulation results\" src=\"modelica://Buildings/Resources/Images/Controls/Continuous/Examples/NumberOfRequests.png\" border=\"1\" />
</p>
</html>"));
end NumberOfRequests;
