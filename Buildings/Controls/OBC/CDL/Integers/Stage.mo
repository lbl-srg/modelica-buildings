within Buildings.Controls.OBC.CDL.Integers;
block Stage "Output total stages that should be enabled"

  parameter Integer n(final min=1)
    "Maximum stages that could be enabled";

  parameter Real holdDuration(
    final quantity="Time",
    final unit="s",
    min=0)
    "Minimum time that the output needs to be held constant. Set to 0 to disable hold time";

  parameter Real h=0.02/n "Hysteresis for comparing input with threshold";

  parameter Integer pre_y_start = 0
    "Value of pre(y) at initial time";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput u(
    final min=0,
    final max=1)
    "Real input for specifying stages"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput y(
    final min=1,
    final max=n)
    "Total number of stages that should be enabled"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

protected
  final parameter Real staThr[n]={(i - 1)/n for i in 1:n}
    "Stage thresholds";
  discrete Real tNext
    "Next check point if it has passed the minimum hold time";
  discrete Real upperThreshold
    "Current upper bound of the stage range which the input is in";
  discrete Real lowerThreshold
    "Current lower bound of the stage range which the input is in";
  Boolean checkUpper
    "Check if the input value is greater than the upper bound";
  Boolean checkLower
    "Check if the input value is greater than the lower bound";

initial equation
  upperThreshold = 0;
  lowerThreshold = 0;
  pre(checkUpper) = false;
  pre(checkLower) = true;
  tNext =time + holdDuration;
  pre(y)=pre_y_start;

equation
  checkUpper = not pre(checkUpper) and (u > (pre(upperThreshold) + h)) or pre(checkUpper) and (u >= (pre(upperThreshold) - h));
  checkLower = not pre(checkLower) and (u > (pre(lowerThreshold) + h)) or pre(checkLower) and (u >= (pre(lowerThreshold) - h));

  when (time >= pre(tNext) and ((checkUpper) or not (checkLower))) then
    tNext =time + holdDuration;
    y =if (u >= staThr[n]) then n else sum({(if ((u < staThr[i]) and (u >=
      staThr[i - 1])) then i - 1 else 0) for i in 2:n});
    upperThreshold =if (y == n) then staThr[n] else staThr[y + 1];
    lowerThreshold = if (y == 0) then pre(lowerThreshold) else staThr[y];
  end when;

annotation (defaultComponentName="seqBin",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
    graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=5.0,
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Text(
          extent={{-100,140},{100,100}},
          textString="%name",
          textColor={0,0,255}),
        Text(
          extent={{-98,14},{-54,-12}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(u,
            leftJustified=false,
            significantDigits=3))),
        Text(
          extent={{56,16},{100,-10}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftJustified=false,
            significantDigits=3))),
        Text(
          extent={{-62,70},{64,100}},
          textColor={0,0,0},
          textString="h=%h")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
  Documentation(info="<html>
<p>
Block that outputs the total number of stages that should be enabled.
</p>
<p>
The block compares the input <code>u</code> with the threshold of each stage. If the input it is greater
than a stage threshold, the corresponding stage should be enabled.
The block outputs the total number of stages that should be enabled.
</p>
<p>
The parameter <code>n</code> specifies the maximum number of stages.
The stage thresholds are evenly distributed, i.e. the thresholds
for stages <code>[1, 2, 3, ... , n]</code> are
<code>[0, 1/n, 2/n, ... , (n-1)/n]</code>.
It holds each stage by the minimum duration time of <codE>holdDuration</code>.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 8, by Jianjun Hu:<br/>
First implementation.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3103\">issue 3103</a>
</li>
</ul>
</html>"));
end Stage;
