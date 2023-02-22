within Buildings.ThermalZones.ISO13790.Data;
record Heavy = ISO13790.Data.Generic(
    heaC=260000,
    facMas=3) "Heavy"
     annotation (
  Documentation(revisions="<html>
<ul>
<li>
Mar 16, 2022, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul>
</html>",
info="<html>
<p>
Internal heat capacity per unit area of the floor for heavy buildings.
</p>
</html>"));
