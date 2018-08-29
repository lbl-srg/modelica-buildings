within Buildings.Controls.OBC.CDL.Routing;
block BooleanReplicator "Boolean signal replicator"
  parameter Integer nout=1 "Number of outputs";
  Interfaces.BooleanInput u "Connector of Boolean input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.BooleanOutput y[nout] "Connector of Boolean output signals"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  y = fill(u, nout);

annotation (
    defaultComponentName="booRep",
    Icon(graphics={Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={255,0,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Line(points={{-100,0},{-6,0}}, color={255,0,255}),
        Line(points={{100,0},{10,0}}, color={255,0,255}),
        Line(points={{0,0},{100,10}}, color={255,0,255}),
        Line(points={{0,0},{100,-10}}, color={255,0,255}),
        Ellipse(
          extent={{-14,16},{16,-14}},
          lineColor={0,0,0},
          fillColor={255,0,255},
          fillPattern=FillPattern.Solid),
        Text(
          lineColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name")}),
    Documentation(info="<html>
<p>
This block replicates the Boolean input signal to an array of <code>nout</code>
identical Boolean output signals.
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
end BooleanReplicator;
