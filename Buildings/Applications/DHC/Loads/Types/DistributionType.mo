within Buildings.Applications.DHC.Loads.Types;
type DistributionType = enumeration(
  HeatingWater
    "Heating water distribution system",
  ChilledWater
    "Chilled water distribution system",
  ChangeOver
    "Change-over distribution system")
  "Enumeration for the type of distribution system"
annotation(Documentation(info="<html>
<p>
Enumeration to define the type of distribution system.
</p>
</html>",
  revisions=
"<html>
<ul>
<li>
June 25, 2019, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
