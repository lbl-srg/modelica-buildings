within Buildings.Templates.Plants.Controls;
package Types
  "Package with type definitions"
  extends Modelica.Icons.TypesPackage;
  type Application = enumeration(
    Cooling
      "Cooling system",
    Heating
      "Heating system")
    "Enumeration to specify the type of application";
  type Actuator = enumeration(
    Modulating
      "Modulating",
    TwoPosition
      "Two-position")
    "Enumeration to specify the type of actuator";
  type EquipmentConnection = enumeration(
    Parallel
      "Parallel piped",
    Series
      "Series piped")
    "Enumeration to specify the type of connection between equipment and primary loop";
  annotation (Documentation(info="<html>
<p>
This package provides type definitions.
</p>
</html>"));
end Types;
