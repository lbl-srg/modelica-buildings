within Buildings.Controls.OBC.CDL.Routing;
block IntegerReplicator "Integer signal replicator"
  parameter Integer nout=1 "Number of outputs";
  Interfaces.IntegerInput u "Connector of Integer input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.IntegerOutput y[nout] "Connector of Integer output signals"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  y = fill(u, nout);

annotation (
    defaultComponentName="intRep",
    Icon(graphics={Rectangle(
            extent={{-100,-100},{100,100}},
            lineColor={255,127,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
        Line(points={{-100,0},{-6,0}}, color={255,127,0}),
        Line(points={{100,0},{10,0}}, color={255,127,0}),
        Line(points={{0,0},{100,10}}, color={255,127,0}),
        Line(points={{0,0},{100,-10}}, color={255,127,0}),
        Ellipse(
          extent={{-14,16},{16,-14}},
          lineColor={0,0,0},
          fillColor={255,127,0},
          fillPattern=FillPattern.Solid),
        Text(
          lineColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name")}),
    Documentation(info="<html>
<p>
This block replicates the Integer input signal to an array of <code>nout</code>
identical Integer output signals.
</p>
</html>", revisions="<html>
<ul>
<li>
July 24, 2017, by Jianjun Hu:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end IntegerReplicator;
