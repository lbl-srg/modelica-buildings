within Buildings.Controls.OBC.ASHRAE.G36.Types;
type VentilationStandard = enumeration(
    ASHRAE62_1
      "ASHRAE 62.1",
    California_Title_24
      "California Title 24")
  "Enumeration to configure the ventilation standard"
annotation (
 Evaluate=true, Documentation(info="<html>
<p>
Enumeration to define the ventilation standard. Possible values are:
</p>
<table border=\"1\" summary=\"Explanation of the enumeration\">
<tr>
<th>Enumeration</th>
<th>Description</th></tr>
<tr><td><code>ASHRAE62_1</code></td>
<td>
ASHRAE 62.1.
</td></tr>
<tr><td><code>California_Title_24</code></td>
<td>
California Title 24.
</td></tr>
</table>
</html>", revisions="<html>
<ul>
<li>
March 22, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
