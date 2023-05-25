within Buildings.Fluid.DXSystems.BaseClasses.Types;
type DefrostOperation = enumeration(
    reverseCycle
      "Cycle DX coil in reverse flow to defrost outdoor coil",
    resistive
      "Use resistive element on outdoor coil to defrost")
    "Enumeration defining two methods for defrost"
annotation (Documentation(info="<html>
<p>
Enumeration for the method of defrost.
The possible values are:
</p>
<table border=\"1\" summary=\"Explanation of the enumeration\">
<tr>
<th>Enumeration</th>
<th>Description</th></tr>
<tr><td><code>reverseCycle</code></td>
<td>
Cycle the refrigerant in flow in reverse to defrost the outdoor coil.
</td></tr>
<tr><td><code>resistive</code></td>
<td>
Use a resistive heating element on the outdoor coil for defrost.
</td></tr>
</table>
</html>"));
