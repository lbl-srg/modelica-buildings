within Buildings.Controls.OBC.CDL.Integers;
block SequenceBinary "Output total stages that should be enabled"

  parameter Integer nSta(
    final min=1)
    "Maximum stages that could be enabled";
  parameter Real minStaHol(
    final quantity="Time",
    final unit="s")
    "Minimum time on each stage";

  parameter Integer pre_y_start = 0
    "Value of pre(y) at initial time";
  parameter Real h = 0.02*1/nSta
    "Hysteresis for comparing input with threshold";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput u(
    final min=0,
    final max=1)
    "Real input for specifying stages"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput y
    "Total number of stages that should be enabled"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

protected
  final parameter Real staInt = 1/nSta
    "Stage interval";
  final parameter Real staThr[nSta] = {(i-1)*staInt for i in 1:nSta}
    "Stage thresholds";
  discrete Real tNext
    "Next check point if it has passed the minimum hold time";
  discrete Real upperThreshold
    "Current upper bound of the stage range which the input is in";
  discrete Real lowerThreshold
    "Current lower bound of the stage range which the input is in";
  discrete Real uTem
    "Sampled input value";
  Boolean checkUpper
    "Check if the input value is greater than the upper bound";
  Boolean checkLower
    "Check if the input value is greater than the lower bound";

initial equation
  upperThreshold = 0;
  lowerThreshold = 0;
  pre(checkUpper) = false;
  pre(checkLower) = true;
  tNext = minStaHol;
  pre(y)=pre_y_start;
  uTem = 0;

equation
  checkUpper = not pre(checkUpper) and (u > (pre(upperThreshold) + h)) or pre(checkUpper) and (u >= (pre(upperThreshold) - h));
  checkLower = not pre(checkLower) and (u > (pre(lowerThreshold) + h)) or pre(checkLower) and (u >= (pre(lowerThreshold) - h));

  when (time >= pre(tNext) and ((checkUpper) or not (checkLower))) then
    uTem = u;
    tNext = time + minStaHol;
    y = if (uTem >= staThr[nSta]) then nSta else sum({(if ((uTem < staThr[i]) and (uTem >= staThr[i-1])) then i-1 else 0) for i in 2:nSta});
    upperThreshold = if (y == nSta) then staThr[nSta] else staThr[y+1];
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
Block that outputs total number of stages that should be enabled (<code>true</code>).
It compares the input <code>u</code> with the threshold of each stage. When it is greater
than a stage threshold, the corresponding stage should be enabled. It then outputs the total
number of stages that are enabled.
</p>
<p>
The parameter <code>nSta</code> specifies the maximum number of stages.
It assumes that the stage thresholds are evenly distributed, i.e. the thresholds
for stages <code>[1, 2, 3, ... , nSta]</code> are
<code>[0, 1/nSta, 2/nSta, ... , (nSta-1)/nSta]</code>.
It holds each stage by the minimum duration time of <codE>minStaHol</code>.
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
end SequenceBinary;
