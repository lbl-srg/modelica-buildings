within Buildings.Templates.Components;
package Types "Generic types for template components"
  extends Modelica.Icons.TypesPackage;
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
      "Parallel blades",
      VAV
      "VAV damper")
    "Enumeration to specify the type of damper blades";
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
  type Junction = enumeration(
      None
      "No junction",
      ThreeWay
      "Three-way junction")
    "Enumeration to configure the fluid junction";
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
  type FanSingle = enumeration(
      Housed
      "Housed centrifugal fan",
      Plug
      "Plug fan",
      Propeller
      "Propeller fan")
    "Enumeration to specify the type of single fan";
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
  type SensorTemperature = enumeration(
      Standard
      "Standard sensor",
      Averaging
      "Averaging sensor",
      InWell
      "Sensor in well")
    "Enumeration to specify the type of temperature sensor";
  type SensorVolumeFlowRate = enumeration(
      AFMS
      "Airflow measuring station",
      FlowCross
      "Averaging sensor",
      FlowMeter
      "Flow meter")
    "Enumeration to specify the type of volume flow rate sensor";
  type Valve = enumeration(
      None
      "No valve",
      TwoWay
      "Two-way valve",
      ThreeWay
      "Three-way valve",
      PumpedCoilTwoWay
      "Pumped coil with two-way valve",
      PumpedCoilThreeWay
      "Pumped coil with three-way valve")
    "Enumeration to configure the valve";
end Types;
