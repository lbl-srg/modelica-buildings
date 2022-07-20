within Buildings.Fluid.ZoneEquipment.FanCoilUnit.Types;
type capacityControl = enumeration(
    multispeedCyclingFanConstantWater "Multi-speed cycling fan with constant water flow rate",
    constantSpeedContinuousFanVariableWater "Constant speed continuous fan with variable water flow rate",
    variableSpeedFanConstantWater "Variable-speed fan with constant water flow rate",
    variableSpeedFanVariableWater "Variable-speed fan with variable water flow rate",
    multispeedFanCyclingSpeedConstantWater "Multi-speed fan with cycling between speeds and constant water flow",
    ASHRAE_90_1 "Fan speed control based on ASHRAE 90.1")
  "Enumeration for the capacity control types"
annotation (Documentation(info="<html>
<p>
Enumeration for the type of capacity control used in the zone equipment.
The possible values are
</p>
<ol>
<li>
multispeedCyclingFanConstantWater
</li>
<li>
constantSpeedContinuousFanVariableWater
</li>
<li>
variableSpeedFanConstantWater
</li>
<li>
variableSpeedFanVariableWater
</li>
<li>
multispeedFanCyclingSpeedConstantWater
</li>
<li>
ASHRAE_90_1
</li>
</ol>
</html>",
revisions="<html>
<ul>
<li>
April 20, 2022 by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
