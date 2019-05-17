within Buildings.Controls.OBC.CDL.Continuous;
block MatrixMin "Output vector of row- or column-wise maximum values"

  parameter Boolean rowMin = true "If true outputs row-wise minimum, otherwise column-wise";

  Interfaces.RealInput u[:, :] "Connector of Real input signals"
    annotation (Placement(
      transformation(extent={{-140,-20},{-100,20}})));

  Interfaces.RealOutput y[if rowMin then size(u, 1) else size(u, 2)] "Connector of Real output signals"
    annotation (Placement(
      transformation(extent={{100,-10},{120,10}})));

equation
  if rowMin then
    y = {min(u[i,:]) for i in 1:size(u, 1)};
  else
    y = {min(u[:,i]) for i in 1:size(u, 2)};
  end if
  annotation (
    defaultComponentName="matMin",
    Documentation(info="<html>
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
          extent={{-32,-30},{38,38}},
          lineColor={0,0,0},
          textString="[  ]")}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={Rectangle(
            extent={{-100,-100},{100,100}},
            lineColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
                              Text(
          extent={{-28,-30},{42,38}},
          lineColor={0,0,0},
          textString="[  ]")}));

  annotation (Icon(graphics={
        Line(points={{46,28},{46,-28},{36,58},{22,82},{-32,86},{0,48},{32,88},{22,
              86},{16,84},{20,48}}, color={28,108,200}),
        Line(points={{42,28},{42,-28}}, color={28,108,200}),
        Line(points={{-182,120},{-184,58},{-134,168},{-126,120},{-74,52},{-74,-18},
              {-190,88}}, color={28,108,200}),
        Line(points={{-62,34},{-62,-34}}, color={28,108,200}),
        Line(points={{-188,158},{-188,76}}, color={28,108,200}),
        Line(points={{-158,192},{-60,196}}, color={28,108,200}),
        Rectangle(extent={{-174,194},{-144,146}}, lineColor={28,108,200}),
        Line(points={{-196,176},{-196,-2}}, color={28,108,200}),
        Line(points={{-200,200},{2,200},{0,202},{-144,206}}, color={28,108,200}),
        Line(points={{0,200},{100,200}}, color={28,108,200}),
        Line(points={{-100,180},{100,180},{-4,12}}, color={28,108,200}),
        Line(points={{-80,0},{80,0}}),
        Line(points={{-80,0},{80,0}}),
        Line(points={{-80,50},{-80,-62},{-210,-52}}, color={28,108,200}),
        Line(points={{-80,0},{80,0}}),
        Line(points={{-80,0},{80,0}}),
        Line(points={{-80,0},{80,0}}),
        Text(
          extent={{-74,62},{-68,64}},
          lineColor={28,108,200},
          textString="fsdfsdf"),
        Line(points={{-92,56},{-76,-20}}, color={0,0,127}),
        Line(points={{-64,70},{-62,-6},{-52,76},{-10,72},{-12,78},{14,64}},
            color={0,0,127}),
        Text(
          textString="Edit Here",
          extent={{-108,142},{-128,158}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-118,144},{-118,150}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="asdfasdfadsf")}), Diagram(graphics={
        Line(points={{-80,0},{80,0}})}));
end MatrixMin;
