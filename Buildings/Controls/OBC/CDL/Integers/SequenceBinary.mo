within Buildings.Controls.OBC.CDL.Integers;
block SequenceBinary "Output total stages that should be ON"

  parameter Integer nSta(
    final min=1)
    "Maximum stages that could be ON";
  parameter Real minStaOn(
    final quantity="Time",
    final unit="s")
    "Minimum stage ON duration";
  parameter Real minStaOff(
    final quantity="Time",
    final unit="s")=minStaOn
    "Minimum stage OFF duration";
  parameter Real h
    "Hysteresis for comparing input with threshold";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput u(
    final min=0,
    final max=1)
    "Real input for specifying stages"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput y
    "Total number of stages that should be ON"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

protected
  final parameter Real staInt = 1/nSta
    "Stage interval";
  final parameter Real staThr[nSta]= {(i-1)*staInt+h for i in 1:nSta}
    "Stage thresholds";
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep(
    final nout=nSta)
    "Replicate input"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr[nSta](
    final t=staThr,
    final h=fill(h/2, nSta))
    "Check if the input is greater than thresholds"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol[nSta](
    final trueHoldDuration=fill(minStaOn,nSta),
    final falseHoldDuration=fill(minStaOff, nSta))
    "Hold the minimum time of stage ON and OFF"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nSta]
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum mulSumInt(
    final nin=nSta)
    "Calculate total number of stages that should be ON"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));

equation
  connect(greThr.y, truFalHol.u)
    annotation (Line(points={{-28,0},{-12,0}}, color={255,0,255}));
  connect(truFalHol.y, booToInt.u)
    annotation (Line(points={{12,0},{28,0}},color={255,0,255}));
  connect(booToInt.y, mulSumInt.u)
    annotation (Line(points={{52,0},{68,0}}, color={255,127,0}));
  connect(mulSumInt.y, y) annotation (Line(points={{92,0},{120,0}},
        color={255,127,0}));
  connect(u, reaScaRep.u)
    annotation (Line(points={{-120,0},{-92,0}}, color={0,0,127}));
  connect(reaScaRep.y, greThr.u)
    annotation (Line(points={{-68,0},{-52,0}}, color={0,0,127}));

annotation (defaultComponentName="seqBin",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
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
  Diagram(coordinateSystem(preserveAspectRatio=false)),
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
end SequenceBinary;
