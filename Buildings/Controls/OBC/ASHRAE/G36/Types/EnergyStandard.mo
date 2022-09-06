within Buildings.Controls.OBC.ASHRAE.G36.Types;
type EnergyStandard = enumeration(
    Not_Specified "Not specified",
    ASHRAE90_1_2016
      "ASHRAE 90.1-2016 energy code",
    California_Title_24_2016
      "California Title 24-2016")
  "Enumeration to configure the energy standard"
annotation (
 Evaluate=true, Documentation(info="<html>
<p>
Enumeration to define the energy standard. Possible values are:
</p>
<table border=\"1\" summary=\"Explanation of the enumeration\">
<tr>
<th>Enumeration</th>
<th>Description</th></tr>
<tr><td><code>Not_specified</code></td>
<td>
Not specified.
</td></tr>
<tr><td><code>ASHRAE90_1_2016</code></td>
<td>
ASHRAE 90.1-2016 energy code.
</td></tr>
<tr><td><code>California_Title_24_2016</code></td>
<td>
California Title 24-2016.
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
