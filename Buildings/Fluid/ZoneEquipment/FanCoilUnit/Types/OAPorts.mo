within Buildings.Fluid.ZoneEquipment.FanCoilUnit.Types;
type OAPorts = enumeration(
    oaMix "Has in-built OA mixer",
    oaPorts "Has exposed ports for connecting to outdoor air",
    noOA "Has no OA")
    "Enumeration for the OA port types"
    annotation (Documentation(info="<html>
<p>
Enumeration for the type of heating coil used in the zone equipment.
The possible values are
</p>
<ol>
<li>
ele - Electric resistance heating coil
</li>
<li>
hotWat - Hot-water heating coil
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
