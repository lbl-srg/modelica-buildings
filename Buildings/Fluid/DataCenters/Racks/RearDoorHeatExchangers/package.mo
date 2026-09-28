within Buildings.Fluid.DataCenters.Racks;
package RearDoorHeatExchangers "Package with models for rear door heat exchangers"
  extends Modelica.Icons.Package;

annotation (
  Documentation(
    info="<html>
<p>
Package with standalone models for rear door heat exchangers used in IT racks.
A rear door heat exchanger is mounted at the back of the rack and removes heat from
the warm server exhaust air using a liquid coolant loop.
</p>
<p>
Two variants are provided:
</p>
<ul>
<li>
<a href=\"modelica://Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.Passive\">
Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.Passive</a>:
the air is driven through the heat exchanger by the server fans inside the rack.
No additional fan is required.
</li>
<li>
<a href=\"modelica://Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.Active\">
Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.Active</a>:
an integrated fan drives the air through the heat exchanger, allowing independent
control of the air flow rate. A PI controller regulates the fan speed to maintain
a target air outlet temperature.
</li>
</ul>
</html>",
    revisions="<html>
<ul>
<li>
September 18, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={
        Rectangle(
          lineColor={128,128,128},
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Rectangle(
          extent={{-82,63},{86,56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-84,-57},{84,-64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-54,88},{56,-84}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{56,88},{-54,-84}}, color={0,0,0},
          thickness=0.5)}));
end RearDoorHeatExchangers;
