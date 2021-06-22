within Buildings.Controls.OBC.CDL.Routing;
model IntegerArrayFilter
  "Filter an integer array of based on a boolean mask"
  parameter Integer nin "Size of input array";
  parameter Integer nout "Size of output array";
  parameter Boolean fil[nin]=fill(true,nin) "Array mask";

  Interfaces.IntegerInput u[nin]
    "Connector of Integer input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.IntegerOutput y[nout]
    "Connector of Integer output signals"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  Integer filId[nout] = Modelica.Math.BooleanVectors.index(fil)
    "Indices of included element in input array";

initial equation
  assert(nout==sum({if y then 1 else 0 for y in fil}),
    "The size of the output array does not match the 
    size of included elements in the mask");
equation
  y = u[filId];
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={255,127,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          lineColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),
        Polygon(
          points={{-60,80},{-60,-80},{20,-10},{60,-10},{80,10},{20,10},{-60,80}},
          lineColor={0,0,0},
          fillColor={255,127,0},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Line(points={{-100,0},{-60,0}}, color={255,127,0}),
        Line(points={{70,0},{100,0}}, color={255,127,0})}),      Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
June 22, 2021, by Baptiste Ravache:<br/>
First implementation
</li>
</ul>
</html>"));
end IntegerArrayFilter;
