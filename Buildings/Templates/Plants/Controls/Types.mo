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
  type PlantHeatPump = enumeration(
    HeatingOnly
     "Heating-only with non-reversible heat pumps",
    Reversible
      "Heating and cooling with reversible heat pumps",
    ReversibleHeatRecovery
      "Heating and cooling with reversible heat pumps and heat recovery chiller",
    ReversiblePolyvalent
      "Heating and cooling with reversible heat pumps and polyvalent heat pumps",
    Polyvalent
      "Heating and cooling with polyvalent heat pumps")
    "Enumeration to specify the type of heat pump plant";
  annotation (Documentation(info="<html>
<p>
This package provides type definitions.
</p>
</html>"));
end Types;
