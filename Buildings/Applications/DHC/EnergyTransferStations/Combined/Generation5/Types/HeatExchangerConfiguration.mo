within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Types;
type HeatExchangerConfiguration = enumeration(
    TwoWayValve
    "Two-way valve on district side",
    Pump
    "Pump on district side")
  "Enumeration for the type of the district heat exchanger configuration"
annotation(Documentation(info="<html>
<p>
Enumeration to define the type of the district heat exchanger configuration.
<br>
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
  Use this setting for district heat exchanger with a two-way valve on district side.
  </td>
</tr>
<tr>
  <td>
  Pump
  </td>
  <td>
  Use this setting for district heat exchanger with a pump on district side.
  </td>
</tr>
</table>
</html>",
revisions="<html>
<ul>
<li>
September 2, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
