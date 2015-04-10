within Buildings.Airflow.Multizone;
package Types "Package with type definitions"

  type densitySelection = enumeration(
      fromTop "Density from top port",
      fromBottom "Density from bottom port",
      actual "Actual density based on flow direction")
    "Enumeration to select density in medium column" annotation (
      Documentation(info="<html>
<p>
Enumeration to define the choice of valve flow coefficient
(to be selected via choices menu):
</p>
<table border=\"1\" summary=\"Explanation of the enumeration\">
<tr><th>Enumeration</th>
    <th>Description</th></tr>
<tr><td>fromTop</td>
    <td>
Use this setting to use the density from the volume that is connected
to the top port.
    </td></tr>
<tr><td>fromBottom</td>
    <td>
Use this setting to use the density from the volume that is connected
to the bottom port.
</td></tr>
<tr><td>actual</td>
    <td>Use this setting to use the density based on the actual flow direction.
</td></tr>
 </table>
</html>"));
annotation (preferredView="info", Documentation(info="<html>
This package contains type definitions.
</html>"));
end Types;
