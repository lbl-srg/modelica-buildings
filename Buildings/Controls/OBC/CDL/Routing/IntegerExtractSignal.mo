within Buildings.Controls.OBC.CDL.Routing;
block IntegerExtractSignal
  "Extract signals from an integer input signal vector"
  parameter Integer nin=1
    "Number of inputs";
  parameter Integer nout=1
    "Number of outputs";
  parameter Integer extract[nout]=1:nout
    "Extracting vector";
  Interfaces.IntegerInput u[nin]
    "Integer input signals"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.IntegerOutput y[nout]
    "Integer signals extracted from the input vector with the extraction scheme specified by the integer vector"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

initial equation
  assert(
    Modelica.Math.BooleanVectors.andTrue({(extract[i] > 0 and extract[i] <= nin) for i in 1:nout}),
    "In " + getInstanceName() + ": The element of the extracting vector has out of range value.",
    AssertionLevel.error);

equation
  for i in 1:nout loop
    y[i]=u[extract[i]];
  end for;
  annotation (
    defaultComponentName="extIntSig",
    Icon(
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={255,127,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-90,51},{-50,-49}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={255,127,0}),
        Rectangle(
          extent={{50,50},{90,-50}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={255,127,0}),
        Polygon(
          points={{-94.4104,1.90792},{-94.4104,-2.09208},{-90.4104,-0.0920762},{-94.4104,1.90792}},
          fillColor={255,127,0},
          fillPattern=FillPattern.Solid,
          lineColor={255,127,0}),
        Line(
          points={{-72,2},{-60.1395,12.907},{-49.1395,12.907}},
          color={255,127,0}),
        Line(
          points={{-73,4},{-59,40},{-49,40}},
          color={255,127,0}),
        Line(
          points={{-113,0},{-76.0373,-0.0180176}},
          color={255,127,0}),
        Ellipse(
          extent={{-81.0437,4.59255},{-71.0437,-4.90745}},
          fillColor={255,127,0},
          fillPattern=FillPattern.Solid,
          lineColor={255,127,0}),
        Line(
          points={{-73,-5},{-60,-40},{-49,-40}},
          color={255,127,0}),
        Line(
          points={{-72,-2},{-60.0698,-12.907},{-49.0698,-12.907}},
          color={255,127,0}),
        Polygon(
          points={{-48.8808,-11},{-48.8808,-15},{-44.8808,-13},{-48.8808,-11}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={255,127,0}),
        Line(
          points={{-46,13},{-35,13},{35,-30},{45,-30}},
          color={255,127,0}),
        Line(
          points={{-45,40},{-35,40},{35,0},{44,0}},
          color={255,127,0}),
        Line(
          points={{-45,-40},{-34,-40},{35,30},{44,30}},
          color={255,127,0}),
        Polygon(
          points={{-49,42},{-49,38},{-45,40},{-49,42}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={255,127,0}),
        Polygon(
          points={{-48.8728,-38.0295},{-48.8728,-42.0295},{-44.8728,-40.0295},{-48.8728,-38.0295}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={255,127,0}),
        Polygon(
          points={{-48.9983,14.8801},{-48.9983,10.8801},{-44.9983,12.8801},{-48.9983,14.8801}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={255,127,0}),
        Ellipse(
          extent={{69.3052,4.12743},{79.3052,-5.37257}},
          fillColor={255,127,0},
          fillPattern=FillPattern.Solid,
          lineColor={255,127,0}),
        Line(
          points={{80,0},{100,0}},
          color={255,127,0}),
        Polygon(
          points={{43.1618,32.3085},{43.1618,28.3085},{47.1618,30.3085},{43.1618,32.3085}},
          fillColor={255,127,0},
          fillPattern=FillPattern.Solid,
          lineColor={255,127,0}),
        Polygon(
          points={{43.2575,1.80443},{43.2575,-2.19557},{47.2575,-0.195573},{43.2575,1.80443}},
          fillColor={255,127,0},
          fillPattern=FillPattern.Solid,
          lineColor={255,127,0}),
        Polygon(
          points={{43.8805,-28.1745},{43.8805,-32.1745},{47.8805,-30.1745},{43.8805,-28.1745}},
          fillColor={255,127,0},
          fillPattern=FillPattern.Solid,
          lineColor={255,127,0}),
        Line(
          points={{48,0},{70,0}},
          color={255,127,0}),
        Line(
          points={{47,30},{60,30},{73,3}},
          color={255,127,0}),
        Line(
          points={{49,-30},{60,-30},{74,-4}},
          color={255,127,0}),
        Text(
          extent={{-150,-150},{150,-110}},
          textColor={0,0,0},
          textString="extract=%extract"),
        Text(
          textColor={0,0,255},
          extent={{-100,100},{100,140}},
          textString="%name")}),
    Documentation(
      info="<html>
<p>
Extract signals from the vector-valued integer input signal and transfer them
to the vector-valued integer output signal.
</p>
<p>
The extraction scheme is specified by the integer vector <code>extract</code>.
This vector specifies which input signals are taken and in which
order they are transferred to the output vector. Note that the
dimension of <code>extract</code> has to match the number of outputs and
the elements of <code>extract</code> has to be in the range of <code>[1, nin]</code>.
Additionally, the dimensions of the input connector signals and
the output connector signals have to be explicitly defined via the
parameters <code>nin</code> and <code>nout</code>.
</p>
<h4>Example</h4>
<p>
The specification
</p>
<pre>     nin = 7 \"Number of inputs\";
     nout = 4 \"Number of outputs\";
     extract[nout] = {6,3,3,2} \"Extracting vector\";
</pre>
<p>extracts four output signals (<code>nout=4</code>)
from the seven elements of the
input vector (<code>nin=7</code>):</p>
<pre>   y[1, 2, 3, 4] = u[6, 3, 3, 2];
</pre>
</html>",
revisions="<html>
<ul>
<li>
October 5, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end IntegerExtractSignal;
