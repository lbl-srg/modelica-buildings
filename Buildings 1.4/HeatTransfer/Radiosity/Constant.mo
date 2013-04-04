within Buildings.HeatTransfer.Radiosity;
block Constant "Generate constant radiosity signal"
  parameter Real k(max=0, start=0)
    "Radiosity that leaves this component (k <= 0)";
  extends Modelica.Blocks.Interfaces.BlockIcon;

  Interfaces.RadiosityOutflow JOut annotation (Placement(transformation(extent={
            {100,-10},{120,10}}), iconTransformation(extent={{100,-10},{120,10}})));
equation
  JOut = k;
  annotation (defaultComponentName="const",
    Icon(coordinateSystem(
    preserveAspectRatio=true,
    extent={{-100,-100},{100,100}},
    grid={2,2}), graphics={
    Line(points={{-80,68},{-80,-80}}, color={192,192,192}),
    Polygon(
      points={{-80,90},{-88,68},{-72,68},{-80,90}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Line(points={{-88,50},{84,50}},   color={192,192,192}),
    Polygon(
      points={{92,50},{70,58},{70,42},{92,50}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Line(points={{-80,-28},{80,-28}},
                                  color={0,0,0}),
    Text(
      extent={{-150,-150},{150,-110}},
      lineColor={0,0,0},
      textString="k=%k")}),
    Diagram(coordinateSystem(
    preserveAspectRatio=true,
    extent={{-100,-100},{100,100}},
    grid={2,2})),
Documentation(info="<html>
<p>
Constant radiosity source. This model requires <i>k &le; 0</i> because the
radiosity leaves the component and hence needs to be negative or zero.
</p>
<p>
This model is used in 
<a href=\"modelica:Buildings.HeatTransfer.BaseClasses.DummyConstructionExterior\">
Buildings.HeatTransfer.BaseClasses.DummyConstructionExterior</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
November 22, 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end Constant;
