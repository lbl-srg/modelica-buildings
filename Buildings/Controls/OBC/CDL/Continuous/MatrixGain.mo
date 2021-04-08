within Buildings.Controls.OBC.CDL.Continuous;
block MatrixGain
  "Output the product of a gain matrix with the input signal vector"
  parameter Real K[:,:]=[
    1,0;
    0,1]
    "Gain matrix which is multiplied with the input";
  Interfaces.RealInput u[nin]
    "Connector of Real input signals"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.RealOutput y[nout]
    "Connector of Real output signals"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  parameter Integer nin=size(
    K,
    2)
    "Number of inputs";
  parameter Integer nout=size(
    K,
    1)
    "Number of outputs";

equation
  y=K*u;
  annotation (
    defaultComponentName="matGai",
    Documentation(
      info="<html>
<p>
This blocks computes output vector <i>y</i> as the product of the
gain matrix <i>K</i> with the input signal vector <i>u</i> as
<i>y = K u</i>.
For example,
</p>
<pre>
   parameter Real K[:,:] = [0.12 2; 3 1.5];
</pre>
<p>
results in
</p>
<pre>
     | y[1] |     | 0.12  2.00 |   | u[1] |
     |      |  =  |            | * |      |
     | y[2] |     | 3.00  1.50 |   | u[2] |
</pre>

</html>",
      revisions="<html>
<ul>
<li>
February 11, 2019, by Milica Grahovac:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"),
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
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{-50,-30},{20,38}},
          lineColor={0,0,0},
          textString="[  ]"),
        Text(
          extent={{8,-30},{80,10}},
          lineColor={0,0,0},
          textString="*")}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-50,-30},{20,38}},
          lineColor={0,0,0},
          textString="[  ]"),
        Text(
          extent={{8,-30},{80,10}},
          lineColor={0,0,0},
          textString="*")}));
end MatrixGain;
