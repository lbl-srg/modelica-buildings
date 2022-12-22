within Buildings.Controls.OBC.ASHRAE.G36.Types;
type ASHRAEClimateZone = enumeration(
    Not_Specified "Not specified",
    Zone_1A "Zone 1A, Very Hot and Humid",
    Zone_1B "Zone 1B, Very Hot and Dry",
    Zone_2A "Zone 2A, Hot and Humid",
    Zone_2B "Zone 2B, Hot and Dry",
    Zone_3A "Zone 3A, Warm and Humid",
    Zone_3B "Zone 3B, Warm and Dry",
    Zone_3C "Zone 3C, Warm and Marine",
    Zone_4A "Zone 4A, Mixed and Humid",
    Zone_4B "Zone 4B, Mixed and Dry",
    Zone_4C "Zone 4C, Mixed and Marine",
    Zone_5A "Zone 5A, Cool and Humid",
    Zone_5B "Zone 5B, Cool and Dry",
    Zone_5C "Zone 5C, Cool and Marine",
    Zone_6A "Zone 6A, Cold and Humid",
    Zone_6B "Zone 6B, Cold and Dry",
    Zone_7  "Zone 7, Very Cold",
    Zone_8  "Zone 8, Subarctic")
  "Enumeration of ASHRAE climate zone"
annotation (
 Evaluate=true, Documentation(info="<html>
<p>
Enumeration of different ASHRAE climate zones. Possible values are:
</p>
<table border=\"1\" summary=\"Explanation of the enumeration\">
<tr>
<th>Enumeration</th>
<th>Description</th></tr>
<tr><td><code>Not_Specified</code></td>
<td>
Not specified.
</td></tr>
<tr><td><code>Zone_1A</code></td>
<td>
Zone 1A, Very Hot and Humid.
</td></tr>
<tr><td><code>Zone_1B</code></td>
<td>
Zone 1B, Very Hot and Dry.
</td></tr>
<tr><td><code>Zone_2A</code></td>
<td>
Zone 2A, Hot and Humid.
</td></tr>
<tr><td><code>Zone_2B</code></td>
<td>
Zone 2B, Hot and Dry.
</td></tr>
<tr><td><code>Zone_3A</code></td>
<td>
Zone 3A, Warm and Humid.
</td></tr>
<tr><td><code>Zone_3B</code></td>
<td>
Zone 3B, Warm and Dry.
</td></tr>
<tr><td><code>Zone_3C</code></td>
<td>
Zone 3C, Warm and Marine.
</td></tr>
<tr><td><code>Zone_4A</code></td>
<td>
Zone 4A, Mixed and Humid.
</td></tr>
<tr><td><code>Zone_4B</code></td>
<td>
Zone 4B, Mixed and Dry.
</td></tr>
<tr><td><code>Zone_4C</code></td>
<td>
Zone 4C, Mixed and Marine.
</td></tr>
<tr><td><code>Zone_5A</code></td>
<td>
Zone 5A, Cool and Humid.
</td></tr>
<tr><td><code>Zone_5B</code></td>
<td>
Zone 5B, Cool and Dry.
</td></tr>
<tr><td><code>Zone_5C</code></td>
<td>
Zone 5C, Cool and Marine.
</td></tr>
<tr><td><code>Zone_6A</code></td>
<td>
Zone 6A, Cold and Humid.
</td></tr>
<tr><td><code>Zone_6B</code></td>
<td>
Zone 6B, Cold and Dry.
</td></tr>
<tr><td><code>Zone_7</code></td>
<td>
Zone 7, Very Cold.
</td></tr>
<tr><td><code>Zone_8</code></td>
<td>
Zone 8, Subarctic.
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
