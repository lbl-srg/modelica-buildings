within Buildings.Templates.Components;
package Types "Package with type definitions"
  extends Modelica.Icons.TypesPackage;
  type Coil = enumeration(
      ElectricHeating
      "Modulating electric heating coil",
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
  type CoolingTower = enumeration(
      Merkel
      "Merkel model of a cooling tower")
    "Enumeration to configure the cooling tower";
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
  type Pump = enumeration(
      None
      "No pump",
      Constant
      "Constant speed",
      Variable
      "Variable speed")
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
  // RFE: Add support for PICV.
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
  annotation (Documentation(info="<html>
<p>
This package contains type definitions.
</p>
</html>"));
end Types;
