within Buildings.Experimental.OpenBuildingControl.CDL.Integers;
block Add "Output the sum of the two inputs"
  extends Modelica.Blocks.Icons.IntegerBlock;

  parameter Integer k1=+1 "Gain of upper input";
  parameter Integer k2=+1 "Gain of lower input";

  Modelica.Blocks.Interfaces.IntegerInput u1 "Connector of Integer input signal 1" annotation (Placement(
        transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.IntegerInput u2 "Connector of Integer input signal 2" annotation (Placement(
        transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.IntegerOutput y "Connector of Integer output signal" annotation (Placement(
        transformation(extent={{100,-10},{120,10}})));

equation
  y = k1*u1 + k2*u2;
  annotation (
    Documentation(info="<html>
<p>
This blocks computes output <code>y</code> as <i>sum</i> of the
two input signals <code>u1</code> and <code>u2</code>:
</p>
<pre>
    <code>y</code> = k1*<code>u1</code> + k2*<code>u2</code>;
</pre>
<p>
Example:
</p>
<pre>
     parameter:   k1= +2, k2= -3

  results in the following equations:

     y = 2 * u1 - 3 * u2
</pre>

</html>"),
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Text(
          lineColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),
        Line(points={{-100,60},{-74,24},{-44,24}}, color={255,127,0}),
        Line(points={{-100,-60},{-74,-28},{-42,-28}}, color={255,127,0}),
        Ellipse(lineColor={255,127,0}, extent={{-50,-50},{50,50}}),
        Line(points={{50,0},{100,0}}, color={255,127, 0}),
        Text(extent={{-40,-20},{36,48}}, textString="+"),
        Text(extent={{-100,52},{5,92}}, textString="%k1"),
        Text(extent={{-100,-92},{5,-52}}, textString="%k2")}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}})));
end Add;
