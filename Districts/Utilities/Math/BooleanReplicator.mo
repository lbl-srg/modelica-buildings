within Districts.Utilities.Math;
block BooleanReplicator "Boolean signal replicator"
  extends Modelica.Blocks.Interfaces.BooleanBlockIcon;
  parameter Integer nout=1 "Number of outputs";
  Modelica.Blocks.Interfaces.BooleanInput u "Connector of boolean input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}},
            rotation=0)));
  Modelica.Blocks.Interfaces.BooleanOutput y[nout]
    "Connector of boolean output signals"
    annotation (Placement(transformation(extent={{100,-10},{120,10}},
            rotation=0)));
equation
  y = fill(u, nout);
  annotation (
    defaultComponentName="booRep",
    Window(
      x=0.15,
      y=0.16,
      width=0.63,
      height=0.59), Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Line(points={{-100,0},{-6,0}}, color={255,0,255}),
        Line(points={{100,0},{10,0}}, color={255,0,255}),
        Line(points={{0,0},{100,10}}, color={255,0,255}),
        Line(points={{0,0},{100,-10}}, color={255,0,255}),
        Ellipse(
          extent={{-14,16},{16,-14}},
          lineColor={255,85,255},
          fillColor={255,0,255},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics),
    Documentation(info="<html>
<p>
This block replicates the boolean input signal to an array of <code>nout</code> identical output signals.
</p>
</html>", revisions="<html>
<ul>
<li>
July 27, 2012, by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>
</html>"));
end BooleanReplicator;
