within Buildings.BoundaryConditions.WeatherData.BaseClasses;
block SourceSelector
  "Block that selects as its output either a parameter value or its input"
  extends Modelica.Blocks.Interfaces.SO;
  parameter Buildings.BoundaryConditions.Types.DataSource datSou "Data source"
    annotation(Evaluate=true);
  parameter Real p "Parameter value";
  Modelica.Blocks.Interfaces.RealInput uFil
   if datSou == Buildings.BoundaryConditions.Types.DataSource.File
    "Input signal from file reader"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-120,-90},{-100,-70}})));
  Modelica.Blocks.Interfaces.RealInput uCon
  if datSou == Buildings.BoundaryConditions.Types.DataSource.Input
    "Input signal from input connector"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-120,70},{-100,90}})));
equation
  if datSou == Buildings.BoundaryConditions.Types.DataSource.Parameter then
    y = p;
  end if;
  connect(uCon, y);
  connect(uFil, y);
  annotation (
  defaultComponentName="souSel",
Documentation(info="<html>
<p>
Block that produces at its output the input value <code>uCon</code>, <code>uFil</code>
or the parameter value <code>p</code> depending on the parameter value
<code>datSou</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 14, 2020, by Michael Wetter:<br/>
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
        Line(points={{-100,-80},{-40,-80},{-40,-80}},
          color={0,0,127}),
        Line(points={{-100,80},{-38,80}},
          color={0,0,127}),
        Line(points={{-38,80},{6,2}},
          color={0,0,127},
          visible=datSou == Buildings.BoundaryConditions.Types.DataSource.File,
          thickness=1),
        Line(points={{-40,-80},{8,0}},
          color={0,0,127},
          visible=datSou == Buildings.BoundaryConditions.Types.DataSource.Input,
          thickness=1),
        Ellipse(lineColor={0,0,255},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{2,-8},{18,8}})}));
end SourceSelector;
