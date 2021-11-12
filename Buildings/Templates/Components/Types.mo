within Buildings.Templates.Components;
package Types "Generic types for template components"
  extends Modelica.Icons.TypesPackage;
  type Actuator = enumeration(
      None
      "No valve",
      TwoWayValve
      "Two-way valve",
      ThreeWayValve
      "Three-way valve",
      PumpedCoilTwoWayValve
      "Pumped coil with two-way valve",
      PumpedCoilThreeWayValve
      "Pumped coil with three-way valve")
    "Enumeration to configure the actuator";
  type Coil = enumeration(
      DirectExpansion
      "Direct expansion",
      None
      "No coil",
      WaterBased
      "Water-based coil")
    "Enumeration to configure the coil";
  type CoilFunction = enumeration(
      Cooling
      "Cooling",
      Heating
      "Heating",
      Reheat
      "Reheat")
    "Enumeration to specify the coil function";
  type Damper = enumeration(
      NoPath
      "No fluid path",
      Barometric
      "Barometric damper",
      Modulated
      "Modulated damper",
      None
      "No damper",
      PressureIndependent
      "Pressure independent damper",
      TwoPosition
      "Two-position damper")
    "Enumeration to configure the damper";
  type DamperBlades = enumeration(
      Opposed
      "Opposed blades",
      Parallel
      "Parallel blades")
    "Enumeration to specify the damper blades";
  type HeatExchanger = enumeration(
      None
      "No heat exchanger",
      DXMultiStage
      "Direct expansion - Multi-stage",
      DXVariableSpeed
      "Direct expansion - Variable speed",
      WetCoilEffectivenessNTU
      "Water based - Effectiveness-NTU wet",
      DryCoilEffectivenessNTU
      "Water based - Effectiveness-NTU dry",
      WetCoilCounterFlow
      "Water based - Discretized wet")
    "Enumeration to configure the heat exchanger";
  type Fan = enumeration(
      None
      "No fan",
      SingleConstant
      "Single fan - Constant speed",
      SingleTwoSpeed
      "Single fan - Two speed",
      SingleVariable
      "Single fan - Variable speed",
      MultipleConstant
      "Multiple fans (identical) - Constant speed",
      MultipleTwoSpeed
      "Multiple fans (identical) - Two speed",
      MultipleVariable
      "Multiple fans (identical) - Variable speed")
    "Enumeration to configure the fan";
  type Location = enumeration(
      OutdoorAir,
      MinimumOutdoorAir,
      Relief,
      Return,
      Supply,
      Terminal)
    "Enumeration to specify the equipment location";
  type Sensor = enumeration(
      DifferentialPressure
      "Differential pressure",
      HumidityRatio
      "Humidity ratio",
      None
      "None",
      PPM
      "PPM",
      RelativeHumidity
      "Relative humidity",
      SpecificEnthalpy
      "Specific enthalpy",
      Temperature
      "Temperature",
      VolumeFlowRate
      "Volume flow rate")
    "Enumeration to configure the sensor";
  type SensorDifferentialPressure = enumeration(
      External
      "Static pressure tips - In-duct and external",
      Static
      "Static pressure tips - In-duct",
      Total
      "Total pressure tubes - In-duct")
    "Enumeration to configure the differential pressure sensor";
  type SensorTemperature = enumeration(
      Standard
      "Standard sensor",
      Averaging
      "Averaging sensor",
      InWell
      "Sensor in well")
    "Enumeration to configure the temperature sensor";
end Types;
