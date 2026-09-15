within Buildings.Fluid.DataCenterEquipment.Racks.Hybrid;
package LiquidCooledSinglePhaseRearDoorHex
  "Package with hybrid rack model combining liquid cooling, air cooling, and a rear door heat exchanger"
  extends Modelica.Icons.VariantsPackage;

annotation (Documentation(info="<html>
<p>
This package contains models for hybrid IT racks that combine liquid cooling,
air cooling, and a rear door heat exchanger.
The rear door heat exchanger is placed at the air outlet of the rack and
removes heat from the warm exhaust air using a liquid coolant loop.
</p>
</html>", revisions="<html>
<ul>
<li>
September 12, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end LiquidCooledSinglePhaseRearDoorHex;
