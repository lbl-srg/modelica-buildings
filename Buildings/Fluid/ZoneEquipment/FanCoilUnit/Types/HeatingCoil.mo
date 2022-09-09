within Buildings.Fluid.ZoneEquipment.FanCoilUnit.Types;
type HeatingCoil = enumeration(
    electric "Electric resistance heating coil",
    heatingHotWater "Hot-water heating coil")
    "Enumeration for the heating coil types"
    annotation (Documentation(info="<html>
<p>
Enumeration for the type of heating coil used in the zone equipment.
The possible values are
</p>
<ol>
<li>
electric
</li>
<li>
heatingHotWater
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
