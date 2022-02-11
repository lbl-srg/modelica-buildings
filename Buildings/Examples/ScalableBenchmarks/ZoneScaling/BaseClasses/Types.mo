within Buildings.Examples.ScalableBenchmarks.ZoneScaling.BaseClasses;
package Types "Package with type definitions"
  extends Modelica.Icons.TypesPackage;

  type BuildingSize = enumeration(
      TwoFloors "Large building with 2 floors, 10 zones",
      FourFloors "Large building with 4 floors, 10 zones",
      TenFloors "Large building with 10 floors, 10 zones")
      "Building size" annotation (
      Documentation(info="<html>
<p>
Enumeration for the size of building in scalable models.
</p>
<ol>
<li>
TwoFloors
</li>
<li>
FourFloors
</li>
<li>
TenFloors
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
