within Buildings.DHC.EnergyTransferStations;
package Types
  "Package with type definitions"
  extends Modelica.Icons.TypesPackage;
  type ConnectionConfiguration = enumeration(
      TwoWayValve
    "Two-way valve on district side",
      Pump
    "Pump on district side")
    "Enumeration for the type of connection with the district network"
    annotation (Documentation(info="<html>
<p>
Enumeration to define the type of connection with the district network.
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
  TwoWayValve
  </td>
  <td>
  Use this setting in case of an active network with a two-way valve on
  the district side.
  </td>
</tr>
<tr>
  <td>
  Pump
  </td>
  <td>
  Use this setting in case of a passive network with a pump on the
  district side.
  </td>
</tr>
</table>
</html>",revisions="<html>
<ul>
<li>
September 2, 2020, by Jianjun Hu:<br/>
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
