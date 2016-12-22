within Buildings.Experimental.OpenBuildingControl.CDL.Logical;
block GreaterEqual
  "Output y is true, if input u1 is greater or equal than input u2"
  extends Modelica.Blocks.Interfaces.partialBooleanComparison;

equation
  y = u1 >= u2;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -100},{100,100}}), graphics={
        Ellipse(extent={{32,10},{52,-10}}, lineColor={0,0,127}),
        Line(points={{-100,-80},{42,-80},{42,0}}, color={0,0,127}),
        Line(
          points={{-54,22},{-8,2},{-54,-18}},
          thickness=0.5),
        Line(
          points={{-52,-36},{-6,-14}},
          thickness=0.5)}), Documentation(info="<html>
<p>
The output is <b>true</b> if Real input u1 is greater than or equal to
Real input u2, otherwise the output is <b>false</b>.
</p>
</html>"));
end GreaterEqual;
