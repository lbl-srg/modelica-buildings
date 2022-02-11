within Buildings.Examples.ScalableBenchmarks.ZoneScaling.BaseClasses;
package Types "Package with type definitions"
  extends Modelica.Icons.TypesPackage;

  type BuildingSize = enumeration(
      TwoFloors "Building with 2 floors and 2 HVAC systems, serving a total of 10 zones",
      FourFloors "Building with 4 floors and 4 HVAC systems, serving a total of 40 zones",
      TenFloors "Building with 10 floors and 10 HVAC systems, serving a total of 100 zones")
      "Building size" annotation (
      Documentation(info="<html>
<p>
Enumeration for the size of building in scalable models.
</p>
<ol>
<li>
TwoFloors: Building with 2 floors and 2 HVAC systems, serving a total of 10 zones.
</li>
<li>
FourFloors: Building with 4 floors and 4 HVAC systems, serving a total of 40 zones.
</li>
<li>
TenFloors: Building with 10 floors and 10 HVAC systems, serving a total of 100 zones.
</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
February 09, 2022, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>"));
  annotation (Documentation(info="<html>
<p>
This package contains type definitions.
</p>
</html>"));
end Types;
