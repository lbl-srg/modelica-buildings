within Buildings.Controls.OBC.CDL.Routing;
block RealScalarReplicator
  "Real signal replicator"
  parameter Integer nout=1
    "Number of outputs";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u
    "Connector of Real input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y[nout]
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  y=fill(
    u,
    nout);
  annotation (
    defaultComponentName="reaScaRep",
    Icon(
      graphics={
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
          textString="%name")}),
    Documentation(
      info="<html>
<p>
This block replicates the Real input signal to an array of <code>nout</code>
identical Real output signals.
</p>
</html>",
      revisions="<html>
<ul>
<li>
July 27, 2021, by Baptiste Ravache:<br/>
Renamed to <code>RealScalarReplicator</code>.
</li>
<li>
July 24, 2017, by Jianjun Hu:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end RealScalarReplicator;
