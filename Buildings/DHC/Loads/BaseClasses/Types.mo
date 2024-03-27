within Buildings.DHC.Loads.BaseClasses;
package Types
  "Package with type definitions"
  extends Modelica.Icons.TypesPackage;
  type DistributionType = enumeration(
      HeatingWater
    "Heating water distribution system",
      ChilledWater
    "Chilled water distribution system",
      ChangeOver
    "Change-over distribution system")
    "Enumeration for the type of distribution system"
    annotation (Documentation(info="<html>
<p>
Enumeration to define the type of distribution system.
<br/>
</p>
<table border=\"1\" summary=\"Explanation of the enumeration\">
<tr>
  <th>
  Enumeration
  </th>
  <th>
  Description
  </th>
</tr>
<tr>
  <td>
  HeatingWater
  </td>
  <td>
  Use this setting for a heating water distribution system.
  </td>
</tr>
<tr>
  <td>
  ChilledWater
  </td>
  <td>
  Use this setting for a chilled water distribution system.
  </td>
</tr>
<tr>
  <td>
  ChangeOver
  </td>
  <td>
  Use this setting for a change-over distribution system.
  </td>
</tr>
</table>
</html>",revisions="<html>
<ul>
<li>
February 21, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
  type PumpControlType = enumeration(
      ConstantSpeed
    "Constant speed",
      ConstantFlow
    "Constant flow rate (three-way valves)",
      ConstantHead
    "Constant pump head",
      LinearHead
    "Linear relationship between pump head and mass flow rate",
      ConstantDp
    "Constant pressure difference at given location")
    "Enumeration for the type of distribution pump control"
    annotation (Documentation(info="<html>
<p>
Enumeration to define the type of distribution pump control.
<br/>
</p>
<table border=\"1\" summary=\"Explanation of the enumeration\">
<tr>
  <th>
  Enumeration
  </th>
  <th>
  Description
  </th>
</tr>
<tr>
  <td>
  ConstantSpeed
  </td>
  <td>
  Use this setting for a constant speed pump.
  </td>
</tr>
<tr>
  <td>
  ConstantFlow
  </td>
  <td>
  Use this setting for a constant flow system where terminal units are
  equipped with three-way valves and the pump operation can be
  approximated as constant flow and constant head.
  </td>
</tr>
<tr>
  <td>
  ConstantHead
  </td>
  <td>
  Use this setting for a pump control ensuring a constant head.
  </td>
</tr>
<tr>
  <td>
  LinearHead
  </td>
  <td>
  Use this setting for a pump control ensuring a linear variation of the
  pump head with the mass flow rate.
  </td>
</tr>
<tr>
  <td>
  ConstantDp
  </td>
  <td>
  Use this setting for a pump control ensuring a constant pressure drop
  at a given location in the distribution system.
  </td>
</tr>
</table>
</html>",revisions="<html>
<ul>
<li>
February 21, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
  annotation (
    preferredView="info",
    Documentation(
      info="<html>
<p>
This package contains type definitions.
</p>
</html>"));
end Types;
