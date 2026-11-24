within Buildings.Controls.OBC.RadiantSystems;
package CoolingAndHeating "Radiant Control Sequence"
annotation (Documentation(info="<html>
<p>
This package contains a radiant control module and its constitutive blocks.
</p>
<p>
The main controller module, <a href=\"modelica://Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.ControlPlusLockouts\">
Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.ControlPlusLockouts</a>, determines heating and cooling control for a radiant slab. 
</p>
<p>
Blocks in the <a href=\"modelica://Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.Lockouts\">
Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.Lockouts</a> and <a href=\"modelica://Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.SlabTemperatureSignal\">
Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.SlabTemperatureSignal</a> packages are the composite pieces of the above control block. 
</p>
</html>", revisions="<html>
<ul>
<li>
October 6, 2020, by Fiona Woods:<br/>
First implementation.
</li>
</ul>
</html>"),Icon(graphics={
      Rectangle(
        extent={{-100,100},{100,-100}},
        lineColor={217,67,180},
        lineThickness=1,
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-78,0},{42,-18}},
        lineColor={217,67,180},
        lineThickness=1,
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Line(
        points={{-78,0},{-22,48},{78,48},{42,0}},
        color={217,67,180},
        thickness=1),
      Line(
        points={{78,48},{78,30},{42,-18}},
        color={217,67,180},
        thickness=1)}));
end CoolingAndHeating;
