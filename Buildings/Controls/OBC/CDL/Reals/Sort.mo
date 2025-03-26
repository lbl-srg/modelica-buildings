within Buildings.Controls.OBC.CDL.Reals;
block Sort
  "Sort elements of input vector in ascending or descending order"
  parameter Integer nin(
    final min=0)=0
    "Number of input connections"
    annotation (Dialog(connectorSizing=true),HideResult=true);
  parameter Boolean ascending=true
    "Set to true if ascending order, otherwise order is descending";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u[nin]
    "Connector of Real input signals"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y[nin]
    "Connector of Real output signals"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yIdx[nin]
    "Indices of the sorted vector with respect to the original vector"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}}),
      iconTransformation(extent={{100,-80},{140,-40}})));
equation
  (y, yIdx)=Modelica.Math.Vectors.sort(
    u,
    ascending=ascending);

  annotation (
    defaultComponentName="sort",
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
          textColor={0,0,255}),
        Text(
          extent={{-58,70},{54,-60}},
          textColor={0,0,89},
          textString="sort")}),
    Documentation(
      info="<html>
<p>
Block that sorts the elements of the input signal <i>u</i>.
If the parameter <code>ascending = true</code>, then the output signal <i>y</i> satisfies
<i>y<sub>i</sub> &lt;= y<sub>i+1</sub></i> for all <i>i &isin; {1, ..., n-1}</i>.
Otherwise, it satisfies
<i>y<sub>i</sub> &gt;= y<sub>i+1</sub></i> for all <i>i &isin; {1, ..., n-1}</i>.
The output signal <i>yIdx</i> contains the indices of the sorted elements,
with respect to the input vector <i>u</i>.
</p>
<h4>Usage</h4>
<p>
Note that this block shall only be used for input signals <code>u</code> that are
time sampled.<br/>
Otherwise, in simulation, numerical noise from a nonlinear solver or from an
implicit time integration algorithm may cause the simulation to stall.
Numerical noise can be present if an input depends
on a state variable or a quantity that requires an iterative solution,
such as a temperature or a mass flow rate of an HVAC system.<br/>
In real controllers, measurement noise may cause the output to change frequently.
</p>
<p>
This block may for example be used in a variable air volume flow
controller to access the position of the dampers that are most open.
</p>
</html>", revisions="<html>
<ul>
<li>
April 18, 2024, by Jianjun Hu:<br/>
Added an output variable with the indices of the sorted elements.
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3809\">issue 3809</a>.
</li>
<li>
March 2, 2020, by Michael Wetter:<br/>
Changed icon to display dynamically the output value.
</li>
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
