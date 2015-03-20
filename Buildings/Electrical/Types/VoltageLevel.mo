within Buildings.Electrical.Types;
type VoltageLevel = enumeration(
    Low "Low voltage",
    Medium "Medium voltage",
    High "High voltage") "Enumeration that defines the type of voltage level"
  annotation (Documentation(revisions="<html>
<ul>
<li>
March 19, 2015, by Marco Bonvini:<br/>
Added documentation.
</li>
</ul>
</html>", info="<html>
This type is used to define which type of voltage level is used.
This is typically used for computing or selecting the line cables.
</html>"));
