within Buildings.Controls.Continuous.Examples;
model OffTimer "Example model for off timer"
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.BooleanPulse booleanPulse(period=0.2)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.Continuous.OffTimer offTim1
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Buildings.Controls.Continuous.OffTimer offTim2
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Modelica.Blocks.Logical.Not not1
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
equation
  connect(booleanPulse.y, offTim1.u) annotation (Line(
      points={{-59,10},{-2,10}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(booleanPulse.y, not1.u) annotation (Line(
      points={{-59,10},{-50,10},{-50,-30},{-42,-30}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(offTim2.u, not1.y) annotation (Line(
      points={{-2,-30},{-19,-30}},
      color={255,0,255},
      smooth=Smooth.None));
 annotation (
experiment(StopTime=1),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/Continuous/Examples/OffTimer.mos"
        "Simulate and plot"),
    Documentation(
info="<html>
<p>
Example that demonstrates the use of the model
<a href=\"modelica://Buildings.Controls.Continuous.OffTimer\">
Buildings.Controls.Continuous.OffTimer</a>.
The input to the two timers are alternating boolean values.
Whenever the input becomes <code>false(=0)</code>, the timer is reset.
The figures below show the input and output of the blocks.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/Continuous/Examples/OffTimer1.png\" border=\"1\" alt=\"Input and output of the OffTimer offTim1.\"/><br/>
<img src=\"modelica://Buildings/Resources/Images/Controls/Continuous/Examples/OffTimer2.png\" border=\"1\" alt=\"Input and output of the OffTimer offTim1.\"/>
</p>
</html>",
revisions="<html>
<ul>
<li>
November 21, 2011, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>"));
end OffTimer;
