within Buildings.Experimental.OpenBuildingControl.CDL.SetPoints;
block StandardTime "Standard time"
  extends Modelica.Blocks.Icons.Block;
  Interfaces.RealOutput y "Connector of Real output signal" annotation (Placement(
        transformation(extent={{100,-10},{120,10}})));
  annotation (Documentation(info="<html>

</html>"));
equation
  y = time;
  annotation (
    defaultComponentName="modTim",
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
        Ellipse(extent={{-80,80},{80,-80}}, lineColor={160,160,164},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Line(points={{0,80},{0,60}}, color={160,160,164}),
        Line(points={{80,0},{60,0}}, color={160,160,164}),
        Line(points={{0,-80},{0,-60}}, color={160,160,164}),
        Line(points={{-80,0},{-60,0}}, color={160,160,164}),
        Line(points={{37,70},{26,50}}, color={160,160,164}),
        Line(points={{70,38},{49,26}}, color={160,160,164}),
        Line(points={{71,-37},{52,-27}}, color={160,160,164}),
        Line(points={{39,-70},{29,-51}}, color={160,160,164}),
        Line(points={{-39,-70},{-29,-52}}, color={160,160,164}),
        Line(points={{-71,-37},{-50,-26}}, color={160,160,164}),
        Line(points={{-71,37},{-54,28}}, color={160,160,164}),
        Line(points={{-38,70},{-28,51}}, color={160,160,164}),
        Line(
          points={{0,0},{-50,50}},
          thickness=0.5),
        Line(
          points={{0,0},{40,0}},
          thickness=0.5)}),
    Documentation(info="<html>
    <p>This component outputs the standard time, which starts at the value at 
    which the simulation starts. For example, if a simulation starts 
    at <i>t=-1</i>, then this block outputs first <i>t=-1</i>, 
    and its output is advanced at the same rate as the simulation time. </p>
    <p>The standard is used to allow the simulation to start from any time 
    without having  to set the parameters for the clock, as would be 
    necessary for the standard 
    <a href=\"modelica://Modelica.Blocks.Sources.Clock\">Modelica.Blocks.Sources.Clock</a>. </p>
</html>", revisions="<html>
<ul>
<li>
February 23, 2017, by Milica Grahovac:<br/>
First CDL implementation.
</li>
<li>
January 16, 2015, by Michael Wetter:<br/>
Moved block from
<code>Buildings.Utilities.SimulationTime</code>
to
<code>Buildings.Utilities.Time.ModelTime</code>.
</li>
<li>
May 18, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end StandardTime;
