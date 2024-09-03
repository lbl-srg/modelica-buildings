within Buildings.ThermalZones.ISO13790.Data;
record Light = ISO13790.Data.Generic(
    heaC=110000,
    facMas=2.5) "Light"
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
Internal heat capacity per unit area of the floor for light buildings.
</p>
</html>"));
