within Buildings.Controls.OBC.CDL.Routing;
block BooleanScalarReplicator
  "Boolean signal replicator"
  parameter Integer nout=1
    "Number of outputs";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u
    "Connector of Boolean input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y[nout]
    "Connector of Boolean output signals"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  y=fill(
    u,
    nout);
  annotation (
    defaultComponentName="booScaRep",
    Icon(
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={255,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-100,0},{-6,0}},
          color={255,0,255}),
        Line(
          points={{100,0},{10,0}},
          color={255,0,255}),
        Line(
          points={{0,0},{100,10}},
          color={255,0,255}),
        Line(
          points={{0,0},{100,-10}},
          color={255,0,255}),
        Ellipse(
          extent={{-14,16},{16,-14}},
          lineColor={0,0,0},
          fillColor={255,0,255},
          fillPattern=FillPattern.Solid),
        Text(
          textColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name")}),
    Documentation(
      info="<html>
<p>
This block replicates the Boolean input signal to an array of <code>nout</code>
identical Boolean output signals.
</p>
</html>",
      revisions="<html>
<ul>
<li>
July 27, 2021, by Baptiste Ravache:<br/>
Renamed to <code>BooleanScalarReplicator</code>.
</li>
<li>
July 24, 2017, by Jianjun Hu:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end BooleanScalarReplicator;
