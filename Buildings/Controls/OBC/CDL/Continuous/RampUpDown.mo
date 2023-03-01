within Buildings.Controls.OBC.CDL.Continuous;
block RampUpDown "Limit the changing rate of the input"

  parameter Real raisingSlewRate
    "Speed with which to increase the output";
  parameter Real fallingSlewRate=-raisingSlewRate
    "Speed with which to decrease the output";
  parameter Real Td = raisingSlewRate*0.001
    "Derivative time constant";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput u
    "Real input"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput active
    "True: ramping output"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Ramped output"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Continuous.LimitSlewRate ramLim(
    final raisingSlewRate=raisingSlewRate,
    final fallingSlewRate=fallingSlewRate,
    final Td=Td)
    "Limit the increase or decrease rate of input"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Limit the input ramping when the condition is true"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

equation
  connect(active, swi.u2) annotation (Line(points={{-120,-80},{-20,-80},{-20,0},
          {-2,0}},   color={255,0,255}));
  connect(u, ramLim.u)
    annotation (Line(points={{-120,0},{-80,0},{-80,40},{-62,40}}, color={0,0,127}));
  connect(ramLim.y, swi.u1) annotation (Line(points={{-38,40},{-20,40},{-20,8},{
          -2,8}},   color={0,0,127}));
  connect(u, swi.u3) annotation (Line(points={{-120,0},{-80,0},{-80,-8},{-2,-8}},
        color={0,0,127}));
  connect(swi.y, y) annotation (Line(points={{22,0},{120,0}},
        color={0,0,127}));
annotation (defaultComponentName="ramUpDow",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          textColor={0,0,255},
          extent={{-100,100},{100,140}},
          textString="%name")}),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
  Documentation(info="<html>
<p>
Block that limits the rate of change of the input <code>u</code> by a ramp
if the boolean input <code>active</code> is <code>true</code>.
It computes a threshold for the rate of change between
input <code>u</code> and output <code>y</code> as
<code>thr = (u-y)/Td</code>, where <code>Td &gt; 0</code> is  parameter.
The output <code>y</code> is computed as follows:
<br/>
If <code>thr &lt; fallingSlewRate</code>, then <code>dy/dt = fallingSlewRate</code>,
<br/>
if <code>thr &gt; raisingSlewRate</code>, then <code>dy/dt = raisingSlewRate</code>,
<br/>
otherwise, <code>dy/dt = thr</code>.
</p>
<h4>Implementation</h4>
<p>
For the block to work with arbitrary inputs and in order to produce a differential output,
the input is numerically differentiated with derivative time constant <code>Td</code>.
Smaller time constant <code>Td</code> means nearer ideal derivative.
</p>
</html>",
revisions="<html>
<ul>
<li>
November 16, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end RampUpDown;
