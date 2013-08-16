within Districts.Utilities;
block SimulationTime "Simulation time"
  extends Modelica.Blocks.Interfaces.SO;
equation
  y = time;
  annotation (
    defaultComponentName="simTim",
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
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{0,0},{40,0}},
          color={0,0,0},
          thickness=0.5)}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics),
    Documentation(info="<html>
<p>
This component generates a time signal by using the simulation time.
The model is used to allow the simulation to start from any
time without having to set the parameters for the clock, as
would be necessairy for the model
<a href=\"modelica:Modelica.Blocks.Sources.Clock\">
Modelica.Blocks.Sources.Clock</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
May 18, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end SimulationTime;
