within Buildings.Fluid.ZoneEquipment.BaseClasses1;
package Types "Package with type definitions"
  extends Modelica.Icons.TypesPackage;

  type HeaSou = enumeration(
      ele "Electric resistance heating coil",
      hotWat "Hot-water heating coil",
      heaPum "Electric heat pump heating coil",
      noHea "No heating coil")
      "Enumeration for the heating coil types"
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
  type CooSou = enumeration(
      eleDX "Electric direct expansion cooling coil",
      heaPum "Electric heat pump cooling coil",
      chiWat "Chilled-water cooling coil",
      noCoo "No cooling coil")
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
  type SystemTypes = enumeration(
      fcu,
      ptac,
      pthp,
      windowAC,
      unitHeater,
      zoneOAUnit,
      unitVentilator)
      "Enumeration for the zonal HVAC system types"
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
annotation (Documentation(info="<html>
This package contains type definitions for fan coil units.
  </html>"));
end Types;
