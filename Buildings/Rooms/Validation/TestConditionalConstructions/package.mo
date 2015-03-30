within Buildings.Rooms.Validation;
package TestConditionalConstructions "Package that tests rooms with few constructions only"
  extends Modelica.Icons.ExamplesPackage;

annotation (preferredView="info", Documentation(info="<html>
<p>
This package tests the room model for special cases
where there room only has certain constructions, such
as only exterior construction, only partitions
or only surface boundary conditions.
These test cases are not realistic rooms, but rather
test the correct implementation of the room model.
</p>
</html>"));
end TestConditionalConstructions;
