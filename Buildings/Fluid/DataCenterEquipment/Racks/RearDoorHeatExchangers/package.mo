within Buildings.Fluid.DataCenterEquipment.Racks;
package RearDoorHeatExchangers "Package with models for rear door heat exchangers"
  extends Modelica.Icons.VariantsPackage;

annotation (
  Documentation(
    info="<html>
<p>
Package with standalone models for rear door heat exchangers (RDHx) used in IT racks.
A rear door heat exchanger is mounted at the back of the rack and removes heat from
the warm server exhaust air using a liquid coolant loop.
</p>
<p>
Two variants are provided:
</p>
<ul>
<li>
<a href=\"modelica://Buildings.Fluid.DataCenterEquipment.Racks.RearDoorHeatExchangers.Passive\">
Passive</a>: the air is driven through the HX by the server fans inside the rack.
No additional fan is required.
</li>
<li>
<a href=\"modelica://Buildings.Fluid.DataCenterEquipment.Racks.RearDoorHeatExchangers.Active\">
Active</a>: an integrated fan drives the air through the HX, allowing independent
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
</html>"));
end RearDoorHeatExchangers;
