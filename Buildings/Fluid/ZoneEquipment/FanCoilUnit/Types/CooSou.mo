within Buildings.Fluid.ZoneEquipment.FanCoilUnit.Types;
type CooSou = enumeration(
    eleDX "Electric direct expansion cooling coil",
    heaPum "Electric heat pump cooling coil",
    chiWat "Chilled-water cooling coil")
    "Enumeration for the cooling coil types"
    annotation (Documentation(info="<html>
<p>
Enumeration for the type of cooling coil used in the zone equipment.
The possible values are
</p>
<ol>
<li>
eleDX - Electric direct expansion cooling coil
</li>
<li>
chiWat - Chilled-water cooling coil
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
