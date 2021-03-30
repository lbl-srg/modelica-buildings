within Buildings.Controls.OBC.CDL.Continuous;
block Greater
  "Output y is true, if input u1 is greater than input u2"
  parameter Real h(
    final min=0)=0
    "Hysteresis"
    annotation (Evaluate=true);
  parameter Boolean pre_y_start=false
    "Value of pre(y) at initial time"
    annotation (Dialog(tab="Advanced"));
  Interfaces.RealInput u1
    "Input u1"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.RealInput u2
    "Input u2"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Interfaces.BooleanOutput y
    "Output y"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  final parameter Boolean have_hysteresis=h >= 1E-10
    "True if the block has no hysteresis"
    annotation (Evaluate=true);
  GreaterWithHysteresis greHys(
    final h=h,
    final pre_y_start=pre_y_start) if have_hysteresis
    "Block with hysteresis"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  GreaterNoHysteresis greNoHys if not have_hysteresis
    "Block without hysteresis"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  block GreaterNoHysteresis
    "Greater block without hysteresis"
    Interfaces.RealInput u1
      "Input u1"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Interfaces.RealInput u2
      "Input u2"
      annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
    Interfaces.BooleanOutput y
      "Output y"
      annotation (Placement(transformation(extent={{100,-20},{140,20}})));

  equation
    y=u1 > u2;
    annotation (
      Icon(
        graphics={
          Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            lineThickness=5.0,
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            borderPattern=BorderPattern.Raised),
          Text(
            extent={{-150,150},{150,110}},
            textString="%name",
            lineColor={0,0,255})}));
  end GreaterNoHysteresis;
  block GreaterWithHysteresis
    "Greater block without hysteresis"
    parameter Real h(
      final min=0)=0
      "Hysteresis"
      annotation (Evaluate=true);
    parameter Boolean pre_y_start=false
      "Value of pre(y) at initial time"
      annotation (Dialog(tab="Advanced"));
    Interfaces.RealInput u1
      "Input u1"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Interfaces.RealInput u2
      "Input u2"
      annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
    Interfaces.BooleanOutput y
      "Output y"
      annotation (Placement(transformation(extent={{100,-20},{140,20}})));

  initial equation
    assert(
      h >= 0,
      "Hysteresis must not be negative");
    pre(y)=pre_y_start;

  equation
    y=(not pre(y) and u1 > u2 or pre(y) and u1 >= u2-h);
    annotation (
      Icon(
        graphics={
          Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            lineThickness=5.0,
            fillColor={210,210,210},
            fillPattern=FillPattern.Solid,
            borderPattern=BorderPattern.Raised),
          Text(
            extent={{-150,150},{150,110}},
            textString="%name",
            lineColor={0,0,255}),
          Text(
            extent={{-64,62},{62,92}},
            lineColor={0,0,0},
            textString="h=%h")}));
  end GreaterWithHysteresis;

equation
  connect(u1,greHys.u1)
    annotation (Line(points={{-120,0},{-66,0},{-66,30},{-12,30}},color={0,0,127}));
  connect(u2,greHys.u2)
    annotation (Line(points={{-120,-80},{-60,-80},{-60,22},{-12,22}},color={0,0,127}));
  connect(greHys.y,y)
    annotation (Line(points={{12,30},{60,30},{60,0},{120,0}},color={255,0,255}));
  connect(u1,greNoHys.u1)
    annotation (Line(points={{-120,0},{-66,0},{-66,-30},{-12,-30}},color={0,0,127}));
  connect(u2,greNoHys.u2)
    annotation (Line(points={{-120,-80},{-60,-80},{-60,-38},{-12,-38}},color={0,0,127}));
  connect(greNoHys.y,y)
    annotation (Line(points={{12,-30},{60,-30},{60,0},{120,0}},color={255,0,255}));
  annotation (
    defaultComponentName="gre",
    Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=5.0,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Ellipse(
          extent={{73,7},{87,-7}},
          lineColor=DynamicSelect({235,235,235},
            if y then
              {0,255,0}
            else
              {235,235,235}),
          fillColor=DynamicSelect({235,235,235},
            if y then
              {0,255,0}
            else
              {235,235,235}),
          fillPattern=FillPattern.Solid),
        Line(
          points={{-100,-80},{42,-80},{42,-62}},
          color={0,0,127}),
        Line(
          points={{-12,14},{18,2},{-12,-8}},
          thickness=0.5),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{-64,62},{62,92}},
          lineColor={0,0,0},
          textString="h=%h"),
        Text(
          extent={{-88,-18},{-21,24}},
          lineColor={0,0,0},
          textString=DynamicSelect("",String(u1,
            leftjustified=false,
            significantDigits=3))),
        Text(
          extent={{-86,-76},{-19,-34}},
          lineColor={0,0,0},
          textString=DynamicSelect("",String(u2,
            leftjustified=false,
            significantDigits=3))),
        Text(
          extent={{22,20},{89,62}},
          lineColor=DynamicSelect({235,235,235},
            if y then
              {135,135,135}
            else
              {0,0,0}),
          textString=DynamicSelect("",String(u2,
            leftjustified=false,
            significantDigits=3)),
          visible=h >= 1E-10),
        Text(
          extent={{22,20},{89,62}},
          lineColor=DynamicSelect({235,235,235},
            if y then
              {135,135,135}
            else
              {0,0,0}),
          textString=DynamicSelect("",String(u2,
            leftjustified=false,
            significantDigits=3)),
          visible=h >= 1E-10),
        Text(
          extent={{20,-56},{87,-14}},
          lineColor=DynamicSelect({235,235,235},
            if not y then
              {135,135,135}
            else
              {0,0,0}),
          textString=DynamicSelect("",String(u2-h,
            leftjustified=false,
            significantDigits=3)),
          visible=h >= 1E-10)}),
    Documentation(
      info="<html>
<p>
Block that outputs <code>true</code> if the Real input <code>u1</code>
is greater than the Real input <code>u2</code>, optionally within a hysteresis <code>h</code>.
</p>
<p>
The parameter <code>h &ge; 0</code> is used to specify a hysteresis.
If <i>h &ne; 0</i>, then the output switches to <code>true</code> if <i>u<sub>1</sub> &gt; u<sub>2</sub></i>,
and it switches to <code>false</code> if <i>u<sub>1</sub> &lt; u<sub>2</sub> - h</i>.
If <i>h = 0</i>, the output is <i>y=u<sub>1</sub> &gt; u<sub>2</sub></i>.
</p>
<p>
Enabling hysteresis can avoid frequent switching.
Adding hysteresis is recommended in real controllers to guard against sensor noise, and
in simulation to guard against numerical noise. Numerical noise can be present if
an input depends on a state variable or a quantity that requires an iterative solution, such as
a temperature or a mass flow rate of an HVAC system.
To disable hysteresis, set <code>h=0</code>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
February 3, 2021, by Antoine Gautier:<br/>
Corrected documentation.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2246\">issue 2246</a>.
</li>
<li>
August 5, 2020, by Michael Wetter:<br/>
Added hysteresis.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2076\">issue 2076</a>.
</li>
<li>
January 3, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end Greater;
