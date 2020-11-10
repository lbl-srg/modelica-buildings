within Buildings.Controls.OBC.CDL.Continuous;
block LessThreshold "Output y is true, if input u is less than threshold"

  parameter Real t=0 "Threshold for comparison";

  parameter Real h(final min=0)=0 "Hysteresis"
    annotation(Evaluate=true);

  parameter Boolean pre_y_start=false "Value of pre(y) at initial time"
    annotation(Dialog(tab="Advanced"));

  Interfaces.RealInput u "Input"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Interfaces.BooleanOutput y "Output"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  final parameter Boolean have_hysteresis = h >= 1E-10
  "True if the block has no hysteresis"
  annotation(Evaluate=true);

  LessWithHysteresis lesHys(
     final h=h,
     final t=t,
     final pre_y_start=pre_y_start) if have_hysteresis
        "Block with hysteresis"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  LessNoHysteresis lesNoHys(
      final t=t) if not have_hysteresis
    "Block without hysteresis"
     annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));


  block LessNoHysteresis "Less block without hysteresis"

    parameter Real t=0 "Threshold for comparison";

    Interfaces.RealInput u "Input u"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

    Interfaces.BooleanOutput y "Output y"
      annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  equation
    y = u < t;
    annotation (Icon(graphics={
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
  end LessNoHysteresis;

  block LessWithHysteresis "Less block without hysteresis"

    parameter Real t=0 "Threshold for comparison";

    parameter Real h(final min=0)=0 "Hysteresis"
      annotation(Evaluate=true);

    parameter Boolean pre_y_start=false "Value of pre(y) at initial time"
      annotation(Dialog(tab="Advanced"));

    Interfaces.RealInput u "Input u"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

    Interfaces.BooleanOutput y "Output y"
      annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  initial equation
    assert(h >= 0, "Hysteresis must not be negative");
    pre(y) = pre_y_start;
  equation
    y = (not pre(y) and u < t or pre(y) and u <= t + h);
    annotation (Icon(graphics={
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
          Text(extent={{-64,62},{62,92}},
            lineColor={0,0,0},
            textString="h=%h")}));
  end LessWithHysteresis;

equation
  connect(u, lesHys.u) annotation (Line(points={{-120,0},{-66,0},{-66,30},{-12,
          30}}, color={0,0,127}));
  connect(lesHys.y, y) annotation (Line(points={{12,30},{60,30},{60,0},{120,0}},
        color={255,0,255}));
  connect(u, lesNoHys.u) annotation (Line(points={{-120,0},{-66,0},{-66,-30},{
          -12,-30}}, color={0,0,127}));
  connect(lesNoHys.y, y) annotation (Line(points={{12,-30},{60,-30},{60,0},{120,
          0}}, color={255,0,255}));

  annotation (
        defaultComponentName="lesThr",
        Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}),
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
          lineColor=DynamicSelect({235,235,235}, if y then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if y then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid),
        Line(
          points={{2,10},{-16,2},{2,-8}},
          thickness=0.5),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          lineColor={0,0,255}),
        Text(extent={{-64,62},{62,92}},
          lineColor={0,0,0},
          textString="h=%h"),
        Text(extent={{-88,-18},{-21,24}},
          lineColor={0,0,0},
          textString=DynamicSelect("", String(u, leftjustified=false, significantDigits=3))),
        Text(extent={{4,-18},{71,24}},
          lineColor={0,0,0},
          textString="%t",
          visible=h < 1E-10),
        Text(extent={{22,20},{89,62}},
          lineColor=DynamicSelect({0,0,0}, if y then {135,135,135} else {0,0,0}),
          textString=DynamicSelect("", String(t, leftjustified=false, significantDigits=3)),
          visible=h >= 1E-10),
        Text(extent={{20,-56},{87,-14}},
          lineColor=DynamicSelect({0,0,0}, if not y then {135,135,135} else {0,0,0}),
          textString=DynamicSelect("", String(t+h, leftjustified=false, significantDigits=3)),
          visible=h >= 1E-10)}),
Documentation(info="<html>
<p>
Block that outputs <code>true</code> if the Real input <code>u</code>
is less than a threshold <code>t</code>, optionally within a hysteresis <code>h</code>.
</p>
<p>
The parameter <code>h</code> is used to specify a hysteresis.
If <i>h &gt; 0</i>, then the output switches to <code>true</code> if <i>u &lt; t</i>,
where <i>t</i> is the threshold,
and it switches to <code>false</code> if <i>u &lt; t+h</i>.
</p>
<p>
Enabling hysteresis can avoid frequent switching.
Adding hysteresis is recommended in real controllers to guard against sensor noise, and
in simulation to guard against numerical noise. Numerical noise can be present if
an input depends on a state variable or a quantity that requires an iterative solution, such as
a temperature or a mass flow rate of an HVAC system.
To disable hysteresis, set <i>h=0</i>.
</p>
</html>", revisions="<html>
<ul>
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
end LessThreshold;
