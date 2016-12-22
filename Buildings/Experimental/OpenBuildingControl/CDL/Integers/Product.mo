within Buildings.Experimental.OpenBuildingControl.CDL.Integers;
block Product "Output product of the two inputs"
  extends Modelica.Blocks.Icons.IntegerBlock;

  Modelica.Blocks.Interfaces.IntegerInput u1 "Connector of Integer input signal 1" annotation (Placement(
        transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.IntegerInput u2 "Connector of Integer input signal 2" annotation (Placement(
        transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.IntegerOutput y "Connector of Integer output signal" annotation (Placement(
        transformation(extent={{100,-10},{120,10}})));

equation
  y = u1*u2;
  annotation (
    Documentation(info="<html>
<p>
This blocks computes the output <code>y</code> (element-wise)
as <i>product</i> of the corresponding elements of
the two inputs <code>u1</code> and <code>u2</code>:
</p>
<pre>
    y = u1 * u2;
</pre>

</html>"),
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Line(points={{-100,60},{-40,60},{-30,40}}, color={255,127,0}),
        Line(points={{-100,-60},{-40,-60},{-30,-40}}, color={255,127,0}),
        Line(points={{50,0},{100,0}}, color={255,127,0}),
        Line(points={{-30,0},{30,0}}),
        Line(points={{-15,25.99},{15,-25.99}}),
        Line(points={{-15,-25.99},{15,25.99}}),
        Ellipse(lineColor={255,127,0}, extent={{-50,-50},{50,50}})}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}})));
end Product;
