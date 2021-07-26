within Buildings.Controls.OBC.CDL.Routing;
block BooleanArrayFilter
  "Filter a boolean array based on a boolean mask"
  parameter Integer nin "Size of input array";
  parameter Integer nout "Size of output array";
  parameter Boolean msk[nin]=fill(true,nin) "Array mask";

  Interfaces.BooleanInput u[nin]
    "Connector of Boolean input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Interfaces.BooleanOutput y[nout]
    "Connector of Boolean output signals"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  parameter Integer mskId[nout] = Modelica.Math.BooleanVectors.index(msk)
    "Indices of included element in input array";

initial equation
  assert(nout==sum({if msk[i] then 1 else 0 for i in 1:nin}),
    "In " + getInstanceName() + ": The size of the output array does not
    match the size of included elements in the mask.");
equation
  y = u[mskId];
  annotation (
    defaultComponentName="booArrFil",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={255,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-102,0},{-60,0}}, color={255,0,255}),
        Line(points={{70,0},{100,0}}, color={255,0,255}),
        Text(
          lineColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),
        Polygon(
          points={{-60,80},{-60,-80},{20,-10},{60,-10},{80,10},{20,10},{-60,80}},
          lineColor={0,0,0},
          fillColor={255,0,255},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5)}),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
June 22, 2021, by Baptiste Ravache:<br/>
First implementation
</li>
</ul>
</html>", info="<html>
<p>
This block filters a Boolean array of size <code>nin</code> to
an array of size <code>nout</code> given a Boolean mask
<code>msk</code>.
</p>
<p>
If an entry in <code>msk</code> is <code>true</code>, then the value
of this input will be sent to the output <code>y</code>, otherwise it
will be discarded.
</p>
<p>
The parameter <code>msk</code> must have exactly <code>nout</code> entries
set to <code>true</code>, otherwise an error message is issued.
</p>
</html>"));
end BooleanArrayFilter;
