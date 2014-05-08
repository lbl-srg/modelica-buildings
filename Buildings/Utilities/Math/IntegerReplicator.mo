within Buildings.Utilities.Math;
block IntegerReplicator "Integer signal replicator"
  extends Modelica.Blocks.Icons.IntegerBlock;
  parameter Integer nout=1 "Number of outputs";
  Modelica.Blocks.Interfaces.IntegerInput u "Connector of integer input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}},
            rotation=0)));
  Modelica.Blocks.Interfaces.IntegerOutput y[nout]
    "Connector of integer output signals"
    annotation (Placement(transformation(extent={{100,-10},{120,10}},
            rotation=0)));
equation
  y = Buildings.Utilities.Math.Functions.integerReplicator(u=u, nout=nout);
  annotation (
    defaultComponentName="intRep",
    Window(
      x=0.15,
      y=0.16,
      width=0.63,
      height=0.59), Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Line(points={{-100,0},{-6,0}}, color={255,128,0}),
        Line(points={{100,0},{10,0}}, color={255,128,0}),
        Line(points={{0,0},{100,10}}, color={255,128,0}),
        Line(points={{0,0},{100,-10}}, color={255,128,0}),
        Ellipse(
          extent={{-14,16},{16,-14}},
          lineColor={255,128,0},
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2})),
    Documentation(info="<html>
<p>
This block replicates the integer input signal to an array of <code>nout</code> identical output signals.
</p>
</html>", revisions="<html>
<p><ul>
<li>November 28, 2013, by Marcus Fuchs:<br/>Changed block to use Functions.integerReplicator. </li>
<li>August 31, 2012, by Michael Wetter:<br/>Revised documentation. </li>
<li>July 27, 2012, by Kaustubh Phalak:<br/>First implementation. </li>
</ul></p>
</html>"));
end IntegerReplicator;
