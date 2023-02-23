within Buildings.Controls.OBC.CDL.Routing;
block RealExtractor
  "Extract scalar signal out of real signal vector dependent on integer input index"
  parameter Integer nin=1
    "Number of inputs";
  Interfaces.IntegerInput index
    "Index of input vector element to be extracted out"
    annotation (Placement(transformation(origin={0,-120},extent={{-20,-20},{20,20}},rotation=90)));
  Interfaces.RealInput u[nin]
    "Real input signals"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.RealOutput y
    "Real signal extracted from input vector, u[index]"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  assert(
     index > 0 and index <= nin,
     "In " + getInstanceName() + ": The extract index is out of the range.",
     AssertionLevel.warning);
  y = u[min(nin, max(1, index))];

annotation (defaultComponentName="extIndRea",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-80,50},{-40,-50}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-84.4104,1.9079},{-84.4104,-2.09208},{-80.4104,-0.09208},{-84.4104,1.9079}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-62,2},{-50.1395,12.907},{-39.1395,12.907}},
          color={0,0,127}),
        Line(
          points={{-63,4},{-49,40},{-39,40}},
          color={0,0,127}),
        Line(
          points={{-102,0},{-65.0373,-0.01802}},
          color={0,0,127}),
        Ellipse(
          extent={{-70.0437,4.5925},{-60.0437,-4.90745}},
          lineColor={0,0,127},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-63,-5},{-50,-40},{-39,-40}},
          color={0,0,127}),
        Line(
          points={{-62,-2},{-50.0698,-12.907},{-39.0698,-12.907}},
          color={0,0,127}),
        Polygon(
          points={{-38.8808,-11},{-38.8808,-15},{-34.8808,-13},{-38.8808,-11}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-39,42},{-39,38},{-35,40},{-39,42}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-38.8728,-38.0295},{-38.8728,-42.0295},{-34.8728,-40.0295},{-38.8728,-38.0295}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-38.9983,14.8801},{-38.9983,10.8801},{-34.9983,12.8801},{-38.9983,14.8801}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-30,50},{30,-50}},
          fillColor={235,235,235},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127}),
        Line(
          points={{100,0},{0,0}},
          color={0,0,127}),
        Line(
          points={{0,2},{0,-104}},
          color={255,128,0}),
        Line(
          points={{-35,40},{-20,40}},
          color={0,0,127}),
        Line(
          points={{-35,13},{-20,13}},
          color={0,0,127}),
        Line(
          points={{-35,-13},{-20,-13}},
          color={0,0,127}),
        Line(
          points={{-35,-40},{-20,-40}},
          color={0,0,127}),
        Polygon(
          points={{0,0},{-20,13},{-20,13},{0,0},{0,0}},
          lineColor={0,0,127}),
        Ellipse(
          extent={{-6,6},{6,-6}},
          lineColor={255,128,0},
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid),
        Text(
          textColor={0,0,255},
          extent={{-100,100},{100,140}},
          textString="%name")}),
    Documentation(
      info="<html>
<p>
Block that returns
</p>
<pre>    y = u[index];
</pre>
<p>
where <code>u</code> is a vector-valued <code>Real</code> input signal and
<code>index</code> is an <code>Integer</code> input signal. When the <code>index</code>
is out of range,
</p>
<ul>
<li>
then <code>y = u[nin]</code> if <code>index &gt; nin</code>, and
</li>
<li>
<code>y = u[1]</code> if <code>index &lt; 1</code>.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
October 14, 2022, by Jianjun Hu:<br/>
Changed output from a specified value to the element with the nearest valid index when the index input is out of range.
</li>
<li>
July 19, 2018, by Jianjun Hu:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end RealExtractor;
