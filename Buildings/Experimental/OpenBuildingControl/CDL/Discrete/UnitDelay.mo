within Buildings.Experimental.OpenBuildingControl.CDL.Discrete;
block UnitDelay "Unit Delay Block"
  parameter Real y_start=0 "Initial value of output signal";
  extends Modelica.Blocks.Interfaces.DiscreteSISO;

equation
  when sampleTrigger then
    y = pre(u);
  end when;

initial equation
    y = y_start;
  annotation (
    Documentation(info="<html>
<p>
This block describes a unit delay:
</p>
<pre>
          1
     y = --- * u
          z
</pre>
<p>
that is, the output signal y is the input signal u of the
previous sample instant. Before the second sample instant,
the output y is identical to parameter yStart.
</p>

</html>"), Icon(
    coordinateSystem(preserveAspectRatio=true,
      extent={{-100.0,-100.0},{100.0,100.0}}),
      graphics={
    Line(points={{-30.0,0.0},{30.0,0.0}},
      color={0,0,127}),
    Text(lineColor={0,0,127},
      extent={{-90.0,10.0},{90.0,90.0}},
      textString="1"),
    Text(lineColor={0,0,127},
      extent={{-90.0,-90.0},{90.0,-10.0}},
      textString="z")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Rectangle(extent={{-60,60},{60,-60}}, lineColor={0,0,255}),
        Text(
          extent={{-160,10},{-140,-10}},
          textString="u",
          lineColor={0,0,255}),
        Text(
          extent={{115,10},{135,-10}},
          textString="y",
          lineColor={0,0,255}),
        Line(points={{-100,0},{-60,0}}, color={0,0,255}),
        Line(points={{60,0},{100,0}}, color={0,0,255}),
        Line(points={{40,0},{-40,0}}),
        Text(
          extent={{-55,55},{55,5}},
          lineColor={0,0,0},
          textString="1"),
        Text(
          extent={{-55,-5},{55,-55}},
          lineColor={0,0,0},
          textString="z")}));
end UnitDelay;
