within Buildings.Templates.Plants.Components.Controls;
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
  type PrimaryOverflowMeasurement = enumeration(
    FlowDecoupler "Flow meter in the decoupler",
    FlowDifference "Primary and secondary loop flow meters",
    TemperatureSupplySensor "Delta-T with single supply temperature sensor measuring combined flow",
    TemperatureUnitSensor "Delta-T with weighted average of supply temperature sensors of all units proven on")
  "Enumeration to configure the sensors for variable speed primary pump control in primary-secondary plants";
end Types;
