within Buildings.Controls.OBC.CDL.Continuous;
block MultiSum
  "Sum of Reals, y = k[1]*u[1] + k[2]*u[2] + ... + k[n]*u[n]"

  parameter Integer nin(min=0) = 0 "Number of input connections"
    annotation (Dialog(connectorSizing=true), HideResult=true);
  parameter Real k[nin]=fill(1, nin) "Input gains";
  Interfaces.RealInput u[nin] "Connector of Real input signals"
    annotation (Placement(transformation(extent={{-140,70},{-100,-70}})));
  Interfaces.RealOutput y "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,17},{134,-17}})));
equation
  if size(u, 1) > 0 then
    y = k*u;
  else
    y = 0;
  end if;

  annotation (
  defaultComponentName="mulSum",
  Icon(graphics={
       Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
       Text(
          extent={{-200,-110},{200,-140}},
          lineColor={0,0,0},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="%k"), Text(
          extent={{-82,84},{82,-52}},
          lineColor={0,0,0},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="+"),
        Text(
          extent={{-144,150},{156,110}},
          textString="%name",
          lineColor={0,0,255})}),
    Documentation(info="<html>
<p>
Block that outputs
</p>
<p align=\"center\" style=\"font-style:italic;\">
y = &sum;<sub>i=1</sub><sup>n</sup> k<sub>i</sub> &nbsp; u<sub>i</sub>,
</p>
<p>
where <i>k</i> is a parameter with <i>n</i> elements and <i>u</i> is
an input of the same length.
The dimension of <i>u</i> can be enlarged by
drawing an additional connection line. The connection is automatically connected
to this new free index.
</p>

<p>
If no connection to the input connector <i>u</i> is present,
the output is <i>y=0</i>.
</p>
<p>
See
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.Validation.MultiSum\">
Buildings.Controls.OBC.CDL.Continuous.Validation.MultiSum</a>
for an example.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 28, 2017, by Jianjun Hu:<br/>
First implementation, based on the implementation of the Modelica Standard
Library. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/825\">issue 825</a>.
</li>
</ul>
</html>"));
end MultiSum;
