within Buildings.Controls.OBC.CDL.Routing;
block RealVectorReplicator "Real vector signal replicator"
  parameter Integer nin=1 "Size of input vector";
  parameter Integer nout=1 "Number of row in output";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u[nin]
    "Connector of Real vector input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y[nout, nin]
    "Connector of Real matrix output signals"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  y=fill(u, nout);
  annotation (
    defaultComponentName="reaVecRep",
    Documentation(
      info="<html>
<p>
This block replicates an Real vector input signal of size <code>nin</code>,
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
</html>"),
    Icon(graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-100,0},{-6,0}},
          color={0,0,127}),
        Line(
          points={{100,0},{10,0}},
          color={0,0,127}),
        Line(
          points={{0,0},{100,10}},
          color={0,0,127}),
        Line(
          points={{0,0},{100,-10}},
          color={0,0,127}),
        Ellipse(
          extent={{-14,16},{16,-14}},
          lineColor={0,0,0},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          textColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),
        Line(points={{-100,-10},{0,0}}, color={0,0,127}),
        Line(points={{-100,10},{0,0}}, color={0,0,127})}));
end RealVectorReplicator;
