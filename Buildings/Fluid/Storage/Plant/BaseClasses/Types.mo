within Buildings.Fluid.Storage.Plant.BaseClasses;
package Types "Package with type definitions"
  extends Modelica.Icons.TypesPackage;

  type Setup = enumeration(
      ClosedLocal "A closed tank that only allows local charging",
      ClosedRemote "A closed tank that allows remote charging",
      Open "An open tank")
    "Enumeration for storage plant setup";
 annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains type definitions the storage plant setup.
</p>
</html>"));
end Types;
