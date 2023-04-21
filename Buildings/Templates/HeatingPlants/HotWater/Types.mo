within Buildings.Templates.HeatingPlants.HotWater;
package Types "Package with type definitions"
  extends Modelica.Icons.TypesPackage;
type Boiler = enumeration(
    Condensing "Condensing boilers only",
    Hybrid "Condensing and non-condensing boilers (hybrid plant)",
    NonCondensing "Non-condensing boilers only")
    "Enumeration to specify the type of boilers";
type Controller = enumeration(
    Guideline36
    "Guideline 36 controller for boiler plant",
    OpenLoop
    "Open loop controller")
  "Enumeration to configure the plant controller";
type PrimaryOverflowMeasurement = enumeration(
    FlowDecoupler "Flow meter in the decoupler",
    FlowDifference "Primary and secondary loop flow meters",
    TemperatureSupplySensor "Delta-T with single HWST sensor measuring combined flow of all boilers",
    TemperatureBoilerSensor "Delta-T with weighted average of HWST of all boilers proven on")
  "Enumeration to configure the sensors for variable speed primary pumps control in primary-secondary plants";
type PumpsPrimary = enumeration(
    FactoryConstant "Primary pump provided with boiler with factory controls - Constant speed",
    FactoryVariable "Primary pump provided with boiler with factory controls - Variable speed",
    Constant "Constant speed pump",
    Variable "Variable speed pump")
    "Enumeration to specify the type of primary HW pumps";
type PumpsSecondary = enumeration(
    None "No secondary pumps (primary-only)",
    Centralized "Variable secondary centralized")
    "Enumeration to specify the type of secondary HW pumps";
type SensorLocation = enumeration(
    Return "Sensor in the return line",
    Supply "Sensor in the supply line")
    "Enumeration to specify the sensor location";
  annotation (Documentation(info="<html>
<p>
This package contains type definitions.
</p>
</html>"));
end Types;
