within Buildings.Experimental.OpenBuildingControl.CDL.Integers;
block Add3 "Output the sum of the three inputs"
  extends Modelica.Blocks.Icons.IntegerBlock;

  parameter Integer k1=+1 "Gain of upper input";
  parameter Integer k2=+1 "Gain of middle input";
  parameter Integer k3=+1 "Gain of lower input";

  Modelica.Blocks.Interfaces.IntegerInput u1 "Connector 1 of Integer input signals"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.IntegerInput u2 "Connector 2 of Integer input signals"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.IntegerInput u3 "Connector 3 of Integer input signals"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.IntegerOutput y "Connector of Integer output signals"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  y = k1*u1 + k2*u2 + k3*u3;
  annotation (
    Documentation(info="<html>
<p>
This blocks computes output <b>y</b> as <i>sum</i> of the
three input signals <b>u1</b>, <b>u2</b> and <b>u3</b>:
</p>
<pre>
    <b>y</b> = k1*<b>u1</b> + k2*<b>u2</b> + k3*<b>u3</b>;
</pre>
<p>
Example:
</p>
<pre>
     parameter:   k1= +2, k2= -3, k3=1;

  results in the following equations:

     y = 2 * u1 - 3 * u2 + u3;
</pre>

</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          extent={{-100,50},{5,90}},
          lineColor={0,0,0},
          textString="%k1"),
        Text(
          extent={{-100,-20},{5,20}},
          lineColor={0,0,0},
          textString="%k2"),
        Text(
          extent={{-100,-50},{5,-90}},
          lineColor={0,0,0},
          textString="%k3"),
        Text(
          extent={{2,36},{100,-44}},
          lineColor={0,0,0},
          textString="+")}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}})));
end Add3;
