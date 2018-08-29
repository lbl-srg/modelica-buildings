within Buildings.Controls.OBC.CDL.Continuous;
block Sort "Sort elements of input vector in ascending or descending order"

  parameter Integer nin(min=0) = 0 "Number of input connections"
    annotation (Dialog(connectorSizing=true), HideResult=true);

  parameter Boolean ascending=true
    "= true if ascending order, otherwise descending order";
  Interfaces.RealInput u[nin] "Connector of Real input signals"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.RealOutput y[nin] "Connector of Real output signals"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  y = Modelica.Math.Vectors.sort(u, ascending=ascending);
  annotation (
defaultComponentName="sort",
Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
          100,100}}), graphics={Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid), Text(
        extent={{-150,150},{150,110}},
        textString="%name",
        lineColor={0,0,255}),
               Text(
          extent={{-58,70},{54,-60}},
          lineColor={0,0,89},
          textString="sort")}),
Documentation(info="<html>
<p>
Block that sorts the elements of the input signal <i>u</i>.
If the parameter <code>ascending = true</code>, then the output signal satisfies
<i>y<sub>i</sub> &lt;= y<sub>i+1</sub></i> for all <i>i &isin; {1, ..., n-1}</i>.
Otherwise, it satisfies
<i>y<sub>i</sub> &gt;= y<sub>i+1</sub></i> for all <i>i &isin; {1, ..., n-1}</i>.
</p>
<p>
This block may for example be used in a variable air volume flow
controller to access the position of the dampers that are most open.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 22, 2017, by Michael Wetter:<br/>
Reimplemented function to make it work with OpenModelica.
</li>
<li>
September 14, 2017, by Jianjun Hu:<br/>
Changed model name.
</li>
<li>
January 10, 2017, by Milica Grahovac:<br/>
Initial CDL implementation.
</li>
<li>
November 21, 2011, by Michael Wetter:<br/>
Removed <code>assert</code> statement.
</li>
<li>
November 25, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Sort;
