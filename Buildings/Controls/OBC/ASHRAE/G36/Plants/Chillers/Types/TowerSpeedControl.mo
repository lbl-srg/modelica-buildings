within Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Types;
type TowerSpeedControl  = enumeration(
    CondenserWaterReturnTemperaure
  "Control tower fan speed to maintain condenser water return temperature setpoint",
    CondenserWaterSupplyTemperature
  "Control tower fan speed to maintain condenser water return temperature setpoint")
  "Cooling tower fan speed control type enumeration"
 annotation (
Documentation(info="<html>
<p>
It provides constants that indicate the tower fan speed control stategies.
The control types are enumerated per
ASHRAE Guideline 36-2021, section 5.20.12.2.
</p>
</html>", revisions="<html>
<ul>
<li>
August 21, 2025, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
