within Buildings.Templates.Components;
package Types "Generic types for template components"
  extends Modelica.Icons.TypesPackage;
  type Coil = enumeration(
      ElectricHeating
      "Electric heating coil",
      EvaporatorMultiStage
      "Evaporator coil with multi-stage compressor",
      EvaporatorVariableSpeed
      "Evaporator coil with variable speed compressor",
      None
      "No coil",
      WaterBasedCooling
      "Chilled water coil",
      WaterBasedHeating
      "Hot water coil")
    "Enumeration to configure the coil";
  type Damper = enumeration(
      NoPath
      "No fluid path",
      Barometric
      "Barometric damper",
      Modulating
      "Modulating damper",
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
  type Fan = enumeration(
      None
      "No fan",
      SingleConstant
      "Single fan - Constant speed",
      SingleVariable
      "Single fan - Variable speed",
      ArrayVariable
      "Fan array - Variable speed")
    "Enumeration to configure the fan";
  type FanSingle = enumeration(
      Housed
      "Housed centrifugal fan",
      Plug
      "Plug fan",
      Propeller
      "Propeller fan")
    "Enumeration to specify the type of single fan";
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
      ThreeWayModulating
      "Three-way junction")
    "Enumeration to configure the fluid junction";
  type Pump = enumeration(
      None
      "No pump",
      ParallelVariable
      "Parallel pumps (identical) - Variable speed",
      SingleConstant
      "Single pump - Constant speed",
      SingleVariable
      "Single pump - Variable speed")
    "Enumeration to configure the pump";
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
      PumpedCoilThreeWay
      "Pumped coil with three-way valve",
      PumpedCoilTwoWay
      "Pumped coil with two-way valve",
      ThreeWayModulating
      "Three-way modulating valve",
      ThreeWayTwoPosition
      "Three-way two-position valve",
      TwoWayModulating
      "Two-way modulating valve",
      TwoWayTwoPosition
      "Two-way two-position valve")
    "Enumeration to configure the valve";
end Types;
