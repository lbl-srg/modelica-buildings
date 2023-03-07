within Buildings.Controls.OBC.CDL.Continuous;
block Ramp "Limit the changing rate of the input"

  parameter Real raisingSlewRate(
    min=Constants.small,
    unit="1/s")
    "Maximum speed with which to increase the output";
  parameter Real fallingSlewRate(
    max=-Constants.small,
    unit="1/s")=-raisingSlewRate
    "Maximum speed with which to decrease the output";
  parameter Real Td(
    final quantity="Time",
    final unit="s",
    min=Constants.eps)=raisingSlewRate*0.001
    "Derivative time constant";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput u
    "Connector of Real input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput active
    "Set to false to disable rate limiter"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Continuous.LimitSlewRate ramLim(
    final raisingSlewRate=raisingSlewRate,
    final fallingSlewRate=fallingSlewRate,
    final Td=Td)
    "Limit the input change"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Switch to limit the input change"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

initial equation
  assert(
    raisingSlewRate > 0,
    "raisingSlewRate must be larger than zero.");
  assert(
    fallingSlewRate < 0,
    "fallingSlewRate must be less than zero.");

equation
  connect(active, swi.u2) annotation (Line(points={{-120,-80},{40,-80},{40,0},{
          58,0}},  color={255,0,255}));
  connect(u, swi.u3) annotation (Line(points={{-120,0},{-80,0},{-80,-8},{58,-8}},
        color={0,0,127}));
  connect(ramLim.y, swi.u1) annotation (Line(points={{12,40},{40,40},{40,8},{58,
          8}}, color={0,0,127}));
  connect(swi.y, y) annotation (Line(points={{82,0},{120,0}}, color={0,0,127}));
  connect(u, ramLim.u) annotation (Line(points={{-120,0},{-80,0},{-80,40},{-12,40}},
                color={0,0,127}));
annotation (defaultComponentName="ram",
  Icon(coordinateSystem(preserveAspectRatio=false),
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          textColor={0,0,255},
          extent={{-100,100},{100,140}},
          textString="%name"),
        Line(
          points={{-90,-80},{82,-80}},
          color={192,192,192}),
        Polygon(
          points={{90,-80},{68,-72},{68,-88},{90,-80}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,58},{-80,-90}},
          color={192,192,192}),
        Polygon(
          points={{-80,80},{-88,58},{-72,58},{-80,80}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,-44},{-60,20},{-44,26},{40,8},{40,-4}},
             color={0,0,127}),
        Line(points={{-80,-80},{-60,-80},{-60,-50},{40,-50},{40,-80},{58,-80}},
            color={254,0,254}),
        Text(
          extent={{226,60},{106,10}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftJustified=false,
            significantDigits=3))),
        Line(points={{40,-4},{58,-28},{76,28}},
             color={0,0,127})}),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
  Documentation(info="<html>
<p>
Block that limits the rate of change of the input <code>u</code> by a ramp
if the boolean input <code>active</code> is <code>true</code>,
otherwise the block outputs <code>y = u</code>.
</p>
<p>
This block computes a threshold for the rate of change between
input <code>u</code> and output <code>y</code> as
<code>thr = (u-y)/Td</code>, where <code>Td &gt; 0</code> is a parameter.
The output <code>y</code> is computed as follows:
<ul>
<li>
If <code>thr &lt; fallingSlewRate</code>, then <code>dy/dt = fallingSlewRate</code>,
</li>
<li>
if <code>thr &gt; raisingSlewRate</code>, then <code>dy/dt = raisingSlewRate</code>,
</li>
<li>
otherwise, <code>dy/dt = thr</code>.
</li>
</ul>
<p>
Note that when the output <code>activate</code> switches to <code>false</code>,
the output <code>y</code> can have a jump.
</p>
<h4>Implementation</h4>
<p>
For the block to work with arbitrary inputs and in order to produce a differentiable output,
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
end Ramp;
