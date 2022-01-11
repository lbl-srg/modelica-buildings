within Buildings.Controls.OBC.CDL.Routing;
block IntegerVectorReplicator "Integer vector signal replicator"
  parameter Integer nin=1 "Size of input vector";
  parameter Integer nout=1 "Number of row in output";
  Interfaces.IntegerInput u[nin]
    "Connector of Integer vector input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.IntegerOutput y[nout, nin]
    "Connector of Integer matrix output signals"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  y=fill(u, nout);
  annotation (
    defaultComponentName="intVecRep",
    Icon(
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={255,127,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-100,0},{-6,0}},
          color={255,127,0}),
        Line(
          points={{100,0},{10,0}},
          color={255,127,0}),
        Line(
          points={{0,0},{100,10}},
          color={255,127,0}),
        Line(
          points={{0,0},{100,-10}},
          color={255,127,0}),
        Ellipse(
          extent={{-14,16},{16,-14}},
          lineColor={0,0,0},
          fillColor={255,127,0},
          fillPattern=FillPattern.Solid),
        Text(
          textColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),
        Line(points={{-100,-10},{0,0}}, color={255,127,0}),
        Line(points={{-100,10},{0,0}}, color={255,127,0})}),
    Documentation(
      info="<html>
<p>
This block replicates an Integer vector input signal of size <code>nin</code>,
to a matrix with <code>nout</code> rows and <code>nin</code> columns,
where each row is duplicating the input vector.
</p>
</html>",
      revisions="<html>
<ul>
<li>
June 22, 2021, by Baptiste Ravache:<br/>
First implementation
</li>
</ul>
</html>"));
end IntegerVectorReplicator;
