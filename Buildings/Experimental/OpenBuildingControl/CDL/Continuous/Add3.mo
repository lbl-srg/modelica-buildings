within Buildings.Experimental.OpenBuildingControl.CDL.Continuous;
block Add3 "Output the sum of the three inputs"
  extends Modelica.Blocks.Icons.Block;

  parameter Real k1=+1 "Gain of upper input";
  parameter Real k2=+1 "Gain of middle input";
  parameter Real k3=+1 "Gain of lower input";
  Modelica.Blocks.Interfaces.RealInput u1 "Connector 1 of Real input signals"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput u2 "Connector 2 of Real input signals"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput u3 "Connector 3 of Real input signals"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealOutput y "Connector of Real output signals"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  y = k1*u1 + k2*u2 + k3*u3;
  annotation (
    Documentation(info="<html>
<p>
This blocks computes output <code>y</code> as <i>sum</i> of the
three input signals <code>u1</code>, <code>u2</code> and <code>u3</code>:
</p>
<pre>
    <code>y</code> = k1*<code>u1</code> + k2*<code>u2</code> + k3*<code>u3</code>;
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
            100,100}}), graphics={Rectangle(
            extent={{-100,-100},{100,100}},
            lineColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),Text(
            extent={{-100,50},{5,90}},
            lineColor={0,0,0},
            textString="k1"),Text(
            extent={{-100,-20},{5,20}},
            lineColor={0,0,0},
            textString="k2"),Text(
            extent={{-100,-50},{5,-90}},
            lineColor={0,0,0},
            textString="k3"),Text(
            extent={{2,46},{100,-34}},
            lineColor={0,0,0},
            textString="+")}));
end Add3;
