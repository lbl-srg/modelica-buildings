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
    annotation (Placement(transformation(extent={{-160,100},{-120,140}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput y
    "Total number of stages that should be ON"
    annotation (Placement(transformation(extent={{220,0},{260,40}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Change cha
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Logical.Latch lat
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Discrete.TriggeredSampler triSam
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Conversions.IntegerToReal intToRea
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Conversions.RealToInteger reaToInt
    annotation (Placement(transformation(extent={{180,10},{200,30}})));
  Logical.Timer tim(t=minStaOn)
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));
  Logical.Pre pre
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
protected
  final parameter Real staInt = 1/nSta
    "Stage interval";
  final parameter Real staThr[nSta]= {(i-1)*staInt+h for i in 1:nSta}
    "Stage thresholds";
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep(
    final nout=nSta)
    "Replicate input"
    annotation (Placement(transformation(extent={{-100,110},{-80,130}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr[nSta](
    final t=staThr,
    final h=fill(h/2, nSta))
    "Check if the input is greater than thresholds"
    annotation (Placement(transformation(extent={{-60,110},{-40,130}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nSta]
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{-20,110},{0,130}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum mulSumInt(
    final nin=nSta)
    "Calculate total number of stages that should be ON"
    annotation (Placement(transformation(extent={{20,110},{40,130}})));

equation
  connect(booToInt.y, mulSumInt.u)
    annotation (Line(points={{2,120},{18,120}},
                                             color={255,127,0}));
  connect(u, reaScaRep.u)
    annotation (Line(points={{-140,120},{-102,120}},
                                                color={0,0,127}));
  connect(reaScaRep.y, greThr.u)
    annotation (Line(points={{-78,120},{-62,120}},
                                               color={0,0,127}));

  connect(mulSumInt.y, cha.u) annotation (Line(points={{42,120},{70,120},{70,92},
          {-110,92},{-110,-50},{-102,-50}},
                                         color={255,127,0}));
  connect(intToRea.y, triSam.u)
    annotation (Line(points={{-78,60},{-42,60}},
                                              color={0,0,127}));
  connect(mulSumInt.y, intToRea.u) annotation (Line(points={{42,120},{70,120},{70,
          92},{-110,92},{-110,60},{-102,60}},
                                           color={255,127,0}));
  connect(cha.y, lat.u)
    annotation (Line(points={{-78,-50},{-62,-50}},color={255,0,255}));
  connect(reaToInt.y, y) annotation (Line(points={{202,20},{240,20}},
                color={255,127,0}));
  connect(lat.y, tim.u)
    annotation (Line(points={{-38,-50},{78,-50}},color={255,0,255}));
  connect(greThr.y, booToInt.u)
    annotation (Line(points={{-38,120},{-22,120}},
                                                color={255,0,255}));
  connect(tim.passed, pre.u) annotation (Line(points={{102,-58},{110,-58},{110,
          -120},{-110,-120},{-110,-90},{-102,-90}},
                                              color={255,0,255}));
  connect(pre.y, lat.clr) annotation (Line(points={{-78,-90},{-70,-90},{-70,-56},
          {-62,-56}},color={255,0,255}));
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
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-140},{120,140}})),
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
