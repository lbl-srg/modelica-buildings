within Buildings.Fluid.ZoneEquipment.BaseClasses;
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
<li>
heaPum - Electric heat-pump heating coil
</li>
<li>
noHea - No heating coil
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
<li>
noCoo - No cooling coil
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
Enumeration for the type of OA ports used in the zone equipment.
The possible values are
</p>
<ol>
<li>
oaMix - Equipment has an in-built OA mixer.
</li>
<li>
oaPorts - Equipment has a mixed air inlet and a return air outlet that can be 
connected to an OA mixer externally.
</li>
<li>
noOA - Equipment directly connects the return port to the supply fan inlet port, 
wih 100% return air.
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
      fcu "Fan coil unit",
      ptac "Packaged terminal air conditioner",
      pthp "Packaged terminal heat pump",
      windowAC "Window AC",
      unitHeater "Unit heater",
      zoneOAUnit "Zone OA unit",
      unitVentilator "Unit ventilator")
      "Enumeration for the zonal HVAC system types"
      annotation (Documentation(info="<html>
<p>
Enumeration for the zone equipment system types.
The possible values are
</p>
<ol>
<li>
fcu - Fan coil unit
</li>
<li>
ptac - Packaged terminal air conditioner
</li>
<li>
pthp - Packaged terminal heat pump
</li>
<li>
windowAC - Window AC
</li>
<li>
unitHeater - Unit heater
</li>
<li>
zoneOAUnit - Zone OA unit
</li>
<li>
unitVentilator - Unit ventilator
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
  type FanTypes = enumeration(
      conSpeFan "Constant speed fan",
      varSpeFan "Variable speed fan",
      mulSpeFan "Multiple speed fan")
    "Enumeration for the zonal HVAC fan types"
      annotation (Documentation(info="<html>
<p>
Enumeration for the zone equipment fan types.
The possible values are
</p>
<ol>
<li>
conSpeFan - Constant speed fan
</li>
<li>
varSpeFan - Variable speed fan
</li>
<li>
mulSpeFan - Multiple speed fan
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
  type SupHeaSou = enumeration(
      ele "Electric resistance heating coil",
      hotWat "Hot-water heating coil",
      noHea "No heating coil")
    "Enumeration for the supplemental heating coil types"
      annotation (Documentation(info="<html>
<p>
Enumeration for the type of heating coil used in the zone equipment.
The possible values are
</p>
<ol>
<li>
ele - Electric resistance supplemental heating coil
</li>
<li>
hotWat - Hot-water supplemental heating coil
</li>
<li>
noHea - No supplemental heating coil
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
This package contains type definitions for zone HVAC equipment.
  </html>"));
end Types;
