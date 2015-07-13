within Buildings.HeatTransfer.Radiosity;
block RadiositySplitter
  "Splits the incoming radiosity into two flows based on an input signal"
  extends Modelica.Blocks.Icons.Block;

  Interfaces.RadiosityInflow JIn "Inflowing radiosity"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Modelica.Blocks.Interfaces.RealInput u(min=0, max=1)
    "u times incoming radiosity"
    annotation (Placement(
        transformation(extent={{-140,-80},{-100,-40}}), iconTransformation(
          extent={{-140,-80},{-100,-40}})));
  Interfaces.RadiosityOutflow JOut_1 "u times incoming radiosity"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));

  Interfaces.RadiosityOutflow JOut_2 "(1-u) times incoming radiosity"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
equation
  JOut_1 = u    * JIn;
  JOut_2 = (1-u)* JIn;
  annotation (
defaultComponentName="radSpl",
    Documentation(info="<html>
<p>
This blocks splits the incoming radiosity into two fluxes according to
</p>
<p align=\"center\" style=\"font-style:italic;\">
  J<sub>Out,1</sub> = u J<sub>In</sub>,<br/>
  J<sub>Out,2</sub> = (1-u)  J<sub>In</sub>.
</p>
<p>
This block may be used to split the radiosity flux into a fraction that
strikes the shaded part of a window, and a fraction that strikes the
non-shaded part.
</p>
</html>", revisions="<html>
<ul>
<li>
June 27, 2013, by Michael Wetter:<br/>
Changed model because the outflowing radiosity has been changed to be a non-negative quantity.
See track issue <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/158\">#158</a>.
</li>
<li>
October 23 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(
    preserveAspectRatio=true,
    extent={{-100,-100},{100,100}},
    grid={2,2}), graphics={
    Line(points={{-100,60},{-40,60},{-30,40}}, color={0,0,127}),
    Line(points={{-100,-60},{-40,-60},{-30,-40}}, color={0,0,127}),
    Line(points={{50,0},{100,0}}, color={0,0,127}),
    Line(points={{-30,0},{30,0}}, color={0,0,0}),
    Line(points={{-15,25.99},{15,-25.99}}, color={0,0,0}),
    Line(points={{-15,-25.99},{15,25.99}}, color={0,0,0}),
    Ellipse(extent={{-50,50},{50,-50}}, lineColor={0,0,127}),
    Line(points={{102,60},{42,60},{32,40}},    color={0,0,255}),
    Line(points={{102,-60},{42,-60},{32,-40}},    color={0,0,255})}),
    Diagram(coordinateSystem(
    preserveAspectRatio=true,
    extent={{-100,-100},{100,100}},
    grid={2,2}), graphics={
    Rectangle(
      extent={{-100,-100},{100,100}},
      lineColor={0,0,255},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid),
    Line(points={{-100,60},{-40,60},{-30,40}}, color={0,0,255}),
    Line(points={{-100,-60},{-40,-60},{-30,-40}}, color={0,0,255}),
    Line(points={{50,0},{100,0}}, color={0,0,255}),
    Line(points={{-30,0},{30,0}}, color={0,0,0}),
    Line(points={{-15,25.99},{15,-25.99}}, color={0,0,0}),
    Line(points={{-15,-25.99},{15,25.99}}, color={0,0,0}),
    Ellipse(extent={{-50,50},{50,-50}}, lineColor={0,0,255}),
    Line(points={{100,60},{40,60},{30,40}},    color={0,0,255}),
    Line(points={{100,-60},{40,-60},{30,-40}},    color={0,0,255})}));
end RadiositySplitter;
