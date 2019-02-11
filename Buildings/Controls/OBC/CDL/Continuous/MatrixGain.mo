within Buildings.Controls.OBC.CDL.Continuous;
block MatrixGain
  "Output the product of a gain matrix with the input signal vector"

  parameter Real K[:, :]=[1, 0; 0, 1]
    "Gain matrix which is multiplied with the input";

  Interfaces.RealInput u[nin] "Connector of Real input signals"
    annotation (Placement(
      transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.RealOutput y[nout] "Connector of Real output signals"
    annotation (Placement(
      transformation(extent={{100,-10},{120,10}})));

protected
  parameter Integer nin=size(K, 2) "Number of inputs";
  parameter Integer nout=size(K, 1) "Number of outputs";

equation
  y = K*u;
  annotation (
    defaultComponentName="matGai",
    Documentation(info="<html>
<p>
This blocks computes output vector <b>y</b> as <i>product</i> of the
gain matrix <b>K</b> with the input signal vector <b>u</b>:
</p>
<pre>
    <b>y</b> = <b>K</b> * <b>u</b>;
</pre>
<p>
Example:
</p>
<pre>
   parameter: <b>K</b> = [0.12 2; 3 1.5]

   results in the following equations:

     | y[1] |     | 0.12  2.00 |   | u[1] |
     |      |  =  |            | * |      |
     | y[2] |     | 3.00  1.50 |   | u[2] |
</pre>

</html>", revisions="<html>
<ul>
<li>
February 11, 2019, by Milica Grahovac:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
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
          extent={{8,-30},{80,10}},
          lineColor={0,0,0},
          textString="*"),    Text(
          extent={{-46,-30},{24,38}},
          lineColor={0,0,0},
          textString="[  ]")}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={Rectangle(
            extent={{-100,-100},{100,100}},
            lineColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
                              Text(
          extent={{8,-30},{80,10}},
          lineColor={0,0,0},
          textString="*"),    Text(
          extent={{-46,-30},{24,38}},
          lineColor={0,0,0},
          textString="[  ]")}));
end MatrixGain;
