within Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature.BaseClasses;
block SourceSelector
  "Block that selects as its output either a parameter value or its input"
  extends Modelica.Blocks.Interfaces.SO;
  parameter Boolean useInput "Use input (if true) or parameter value (if false)"
    annotation(Evaluate=true);
  parameter Real p "Parameter value";
  Modelica.Blocks.Interfaces.RealInput uCon if useInput
    "Input signal from input connector"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-120,70},{-100,90}})));
equation
  if not useInput then
    y = p;
  end if;
  connect(uCon, y);
  annotation (
  defaultComponentName="souSel",
Documentation(info="<html>
<p>
Block that produces at its output the input value <code>uCon</code>
or the parameter value <code>p</code> depending on the parameter value
<code>useInput</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 28, 2023, by Philip Groesdonk:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
      Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Line(points={{12,0},{100,0}},
          color={0,0,127}),
        Line(points={{-100,80},{-38,80}},
          color={0,0,127}),
        Line(points={{-40,80},{8,0}},
          color={0,0,127},
          visible=useInput,
          thickness=1),
        Ellipse(lineColor={0,0,255},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{2,-8},{18,8}})}));
end SourceSelector;
