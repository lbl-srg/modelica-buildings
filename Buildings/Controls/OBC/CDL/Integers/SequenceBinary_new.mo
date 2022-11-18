within Buildings.Controls.OBC.CDL.Integers;
block SequenceBinary_new "Output total stages that should be ON"

  parameter Integer nSta(
    final min=1)
    "Maximum stages that could be ON";
  parameter Real minStaOn(
    final quantity="Time",
    final unit="s")
    "Minimum time on each stage";

  parameter Integer y_start=0;
  parameter Real h=0.01
    "Hysteresis for comparing input with threshold";


  Buildings.Controls.OBC.CDL.Interfaces.RealInput u(
    final min=0,
    final max=1)
    "Real input for specifying stages"
    annotation (Placement(transformation(extent={{-138,-20},{-98,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput y
    "Total number of stages that should be ON"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

protected
  final parameter Real staInt = 1/nSta
    "Stage interval";
//   final parameter Real staThr[nSta]= {(i-1)*staInt+h for i in 1:nSta}
//     "Stage thresholds";
  discrete Real tNext;
  discrete Real upperThreshold;
  discrete Real lowerThreshold;
  Boolean checkUpper;
  Boolean checkLower;

equation
  checkUpper = not pre(checkUpper) and u > (upperThreshold + h) or pre(checkUpper) and u >= (upperThreshold - h);
  checkLower = not pre(checkLower) and u > (lowerThreshold + h) or pre(checkLower) and u >= (lowerThreshold - h);

  // not pre(y) and u > uHigh or pre(y) and u >= uLow;
  when (time >= pre(tNext) and checkUpper) then
    tNext = time + minStaOn;
    y = pre(y)+1;
    upperThreshold = (pre(y)+1)*staInt;
    lowerThreshold = pre(y)*staInt;
  elsewhen (time >= pre(tNext) and not checkLower) then
    tNext = time + minStaOn;
    y = pre(y)-1;
    upperThreshold = pre(y)*staInt;
    lowerThreshold = (pre(y)-1)*staInt;
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
Block that outputs total number of stages that should be ON (<code>true</code>).
It compares the input <code>u</code> with the threshold of each stage. When it is greater
than a stage threshold, the corresponding stage should be ON. It then sums up total
number of stages that are ON.
</p>
<p>
The parameter <code>nSta</code> specifies the maximum number of stages.
It assumes that the stage thresholds are evenly distributed, i.e. the thresholds
for stages <code>[1, 2, 3, ... , nSta]</code> are
<code>[0, 1/nSta, 2/nSta, ... , (nSta-1)/nSta]</code>.
It holds each stage ON (or OFF) by the minimum duration time of <codE>minStaOn</code>
(or <code>minStaOff</code>).
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
end SequenceBinary_new;
