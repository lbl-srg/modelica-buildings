within Buildings.Controls.OBC.CDL.Continuous;
block Hysteresis
  "Transform Real to Boolean signal with Hysteresis"
  parameter Real uLow
    "if y=true and u<uLow, switch to y=false";
  parameter Real uHigh
    "if y=false and u>uHigh, switch to y=true";
  parameter Boolean pre_y_start=false
    "Value of pre(y) at initial time";
  Interfaces.RealInput u
    "Real input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.BooleanOutput y
    "Boolean output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

initial equation
  assert(
    uHigh > uLow,
    "Hysteresis limits wrong. uHigh must be larger than uLow");
  pre(y)=pre_y_start;

equation
  y=not pre(y) and u > uHigh or pre(y) and u >= uLow;
  annotation (
    defaultComponentName="hys",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
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
          extent={{71,7},{85,-7}},
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
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,68},{-80,-29}},
          color={192,192,192}),
        Polygon(
          points={{92,-29},{70,-21},{70,-37},{92,-29}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-79,-29},{84,-29}},
          color={192,192,192}),
        Line(
          points={{-79,-29},{41,-29}}),
        Line(
          points={{-15,-21},{1,-29},{-15,-36}}),
        Line(
          points={{41,51},{41,-29}}),
        Line(
          points={{33,3},{41,22},{50,3}}),
        Line(
          points={{-49,51},{81,51}}),
        Line(
          points={{-4,59},{-19,51},{-4,43}}),
        Line(
          points={{-59,29},{-49,11},{-39,29}}),
        Line(
          points={{-49,51},{-49,-29}}),
        Text(
          extent={{-92,-49},{-9,-92}},
          textColor={192,192,192},
          textString="%uLow"),
        Text(
          extent={{2,-49},{91,-92}},
          textColor={192,192,192},
          textString="%uHigh"),
        Rectangle(
          extent={{-91,-49},{-8,-92}},
          lineColor={192,192,192}),
        Line(
          points={{-49,-29},{-49,-49}},
          color={192,192,192}),
        Rectangle(
          extent={{2,-49},{91,-92}},
          lineColor={192,192,192}),
        Line(
          points={{41,-29},{41,-49}},
          color={192,192,192}),
        Text(
          extent={{-150,150},{150,110}},
          textColor={0,0,255},
          textString="%name")}),
    Documentation(
      info="<html>
<p>
Block that transforms a <code>Real</code> input signal into a <code>Boolean</code>
output signal:
</p>
<ul>
<li> When the output was <code>false</code> and the input becomes
     greater than the parameter <code>uHigh</code>, the output
     switches to <code>true</code>.
</li>
<li> When the output was <code>true</code> and the input becomes
     less than the parameter <code>uLow</code>, the output
     switches to <code>false</code>.
</li>
</ul>
<p>
The start value of the output is defined via parameter
<code>pre_y_start</code> (= value of <code>pre(y)</code> at initial time).
The default value of this parameter is <code>false</code>.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/CDL/Continuous/Hysteresis.png\"
     alt=\"Hysteresis.png\" />
</p>
</html>",
      revisions="<html>
<ul>
<li>
October 3, 2017, by Michael Wetter:<br/>
Removed start value for parameters, and moved assertion to <code>initial equation</code>.
</li>
<li>
January 3, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end Hysteresis;
