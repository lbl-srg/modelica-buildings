within Buildings.Controls.Discrete;
block BooleanDelay "Zero order hold for boolean variable"
  extends Modelica.Blocks.Interfaces.BooleanSISO;
  extends Modelica.Blocks.Interfaces.DiscreteBlock(
    firstTrigger(fixed=true,
                 start=firstTrigger_start));
  parameter Boolean firstTrigger_start=false
    "Start value for rising edge signals first sample instant"
    annotation (Dialog(tab="Initialization"));
protected
  Boolean ySample;
algorithm
  when {sampleTrigger, initial()} then
    y := ySample;
    ySample := u;
  end when;

  annotation (Icon(graphics={Line(points={{-72,-48},{-46,-48},{-46,-6},{-20,-6},
              {-20,18},{0,18},{0,58},{24,58},{24,14},{44,14},{44,-6},{50,-6},{
              50,-6},{68,-6}})}),
defaultComponentName="del",
Documentation(
info="<html>
<p>
Block that delays the boolean input signal by
one sampling interval.
For example,
if <i>u</i> denotes the input,
<i>y</i> denotes the output, and
<i>t<sub>i</sub></i> and <i>t<sub>i+1</sub></i>
denote subsequent sampling
instants, then the model outputs
</p>
<p align=\"center\" style=\"font-style:italic;\">
y(t<sub>i+1</sub>) = u(t<sub>i</sub>).
</p>
</html>",
revisions="<html>
<ul>
<li>
June 6, 2015, by Michael Wetter:<br/>
Set start value and <code>fixed</code> attribute
for <code>firstTrigger</code>
to avoid a translation warning in pedantic mode
in Dymola 2016.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/266\">#266</a>.
</li>
<li>
November 21, 2011, by Michael Wetter:<br/>
Improved documentation.
</li>
<li>
November 26, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end BooleanDelay;
