within Buildings.Controls.OBC.CDL.Integers;
block GreaterEqual
  "Output y is true, if input u1 is greater or equal than input u2"
  parameter Integer h(
    final min=0)=0
    "Hysteresis"
    annotation (Evaluate=true);
  parameter Boolean pre_y_start=false
    "Value of pre(y) at initial time"
    annotation (Dialog(tab="Advanced"));
  Interfaces.IntegerInput u1
    "Connector of first Integer input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.IntegerInput u2
    "Connector of second Integer input signal"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Interfaces.BooleanOutput y
    "Connector of Boolean output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  final parameter Boolean have_hysteresis=h > 0
    "True if the block has no hysteresis"
    annotation (Evaluate=true);
  GreaterWithHysteresis greEquHys(
    final h=h,
    final pre_y_start=pre_y_start) if have_hysteresis
    "Block with hysteresis"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  GreaterNoHysteresis greEquNoHys if not have_hysteresis
    "Block without hysteresis"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  block GreaterNoHysteresis
    "Greater block without hysteresis"
    Interfaces.IntegerInput u1
      "Input u1"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Interfaces.IntegerInput u2
      "Input u2"
      annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
    Interfaces.BooleanOutput y
      "Output y"
      annotation (Placement(transformation(extent={{100,-20},{140,20}})));

  equation
    y=u1 >= u2;
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
            textColor={255,127,0})}));
  end GreaterNoHysteresis;

  block GreaterWithHysteresis
    "Greater block without hysteresis"
    parameter Integer h(
      final min=0)=0
      "Hysteresis"
      annotation (Evaluate=true);
    parameter Boolean pre_y_start=false
      "Value of pre(y) at initial time"
      annotation (Dialog(tab="Advanced"));
    Interfaces.IntegerInput u1
      "Input u1"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Interfaces.IntegerInput u2
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
    y=(not pre(y) and u1 >= u2 or pre(y) and u1 >= u2-h);
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
            textColor={255,127,0}),
          Text(
            extent={{-64,62},{62,92}},
            textColor={255,127,0},
            textString="h=%h")}));
  end GreaterWithHysteresis;

equation
  connect(u2,greEquHys.u2)
    annotation (Line(points={{-120,-80},{-60,-80},{-60,22},{-12,22}},color={255,127,0}));
  connect(greEquHys.y,y)
    annotation (Line(points={{12,30},{60,30},{60,0},{120,0}},color={255,0,255}));
  connect(u2,greEquNoHys.u2)
    annotation (Line(points={{-120,-80},{-60,-80},{-60,-38},{-12,-38}},color={255,127,0}));
  connect(greEquNoHys.y,y)
    annotation (Line(points={{12,-30},{60,-30},{60,0},{120,0}},color={255,0,255}));
  connect(u1, greEquNoHys.u1) annotation (Line(points={{-120,0},{-66,0},{-66,-30},{-12,-30}},
          color={255,127,0}));
  connect(u1, greEquHys.u1) annotation (Line(points={{-120,0},{-66,0},{-66,30},{-12,30}},
          color={255,127,0}));
  annotation (
    defaultComponentName="intGreEqu",
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
          points={{-102,-80},{40,-80},{40,0}},
          color={255,127,0}),
        Text(
          extent={{-100,140},{100,100}},
          textString="%name",
          textColor={0,0,255}),
        Text(
          extent={{-64,62},{62,92}},
          textColor={255,127,0},
          textString="h=%h"),
        Text(
          extent={{-88,-18},{-21,24}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(u1,
            leftJustified=false,
            significantDigits=3))),
        Text(
          extent={{-86,-76},{-19,-34}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(u2,
            leftJustified=false,
            significantDigits=3))),
        Text(
          extent={{22,20},{89,62}},
          textColor=DynamicSelect({235,235,235},
            if y then
              {135,135,135}
            else
              {0,0,0}),
          textString=DynamicSelect("",String(u2,
            leftJustified=false,
            significantDigits=3)),
          visible=h >= 1E-10),
        Text(
          extent={{22,20},{89,62}},
          textColor=DynamicSelect({235,235,235},
            if y then
              {135,135,135}
            else
              {0,0,0}),
          textString=DynamicSelect("",String(u2,
            leftJustified=false,
            significantDigits=3)),
          visible=h >= 1E-10),
        Text(
          extent={{20,-56},{87,-14}},
          textColor=DynamicSelect({235,235,235},
            if not y then
              {135,135,135}
            else
              {0,0,0}),
          textString=DynamicSelect("",String(u2-h,
            leftJustified=false,
            significantDigits=3)),
          visible=h >= 1E-10),
        Line(
          points={{-20,14},{12,0},{-20,-14}},
          thickness=0.5,
          color={255,127,0}),
        Line(
          points={{-20,-26},{12,-10}},
          thickness=0.5,
          color={255,127,0}),
        Ellipse(
          extent={{30,10},{50,-10}},
          lineColor={255,127,0})}),
    Documentation(
      info="<html>
<p>
Block that outputs <code>true</code> if the Integer input <code>u1</code>
is greater than or equal to the Integer input <code>u2</code>, optionally within a hysteresis <code>h</code>.
</p>
<p>
The parameter <code>h &ge; 0</code> is used to specify a hysteresis.
If <i>h &ne; 0</i>, then the output switches to <code>true</code> if <i>u<sub>1</sub> &ge; u<sub>2</sub></i>,
and it switches to <code>false</code> if <i>u<sub>1</sub> &lt; u<sub>2</sub> - h</i>.
If <i>h = 0</i>, the output is <i>y=u<sub>1</sub> &ge; u<sub>2</sub></i>.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 27, 2022, by Jianjun Hu:<br/>
Added hysteresis.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2978\">issue 2978</a>.
</li>
<li>
August 30, 2017, by Jianjun Hu:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end GreaterEqual;
