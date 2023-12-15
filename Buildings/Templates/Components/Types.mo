within Buildings.Templates.Components;
package Types "Package with type definitions"
  extends Modelica.Icons.TypesPackage;
  type Chiller = enumeration(
      AirCooled
      "Air-cooled compression chiller",
      WaterCooled
      "Water-cooled compression chiller")
    "Enumeration to specify the type of chiller";
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
  type Cooler = enumeration(
      None
      "No external cooler (typically for air-cooled chillers)",
      CoolingTowerClosed
      "Closed-circuit cooling tower",
      CoolingTowerOpen
      "Open-circuit cooling tower",
      DryCooler
      "Dry cooler")
    "Enumeration to configure the condenser water cooling equipment";
  type Damper = enumeration(
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
  type HeatPump = enumeration(
      AirSource
      "Air-source (air-to-water) heat pump",
      WaterSource
      "Water-source (brine or water-to-water) heat pump")
    "Enumeration to specify the type of heat pump";
  type IconPipe = enumeration(
      None
      "No line",
      Return
      "Return pipe - Dashed line",
      Supply
      "Supply pipe - Solid line")
    "Enumeration to specify the pipe symbol";
  type Pump = enumeration(
      None
      "No pump",
      Single
      "Single pump",
      Multiple
      "Multiple pumps in parallel")
    "Enumeration to configure the pump";
  type PumpArrangement = enumeration(
      Dedicated "Dedicated pumps",
      Headered "Headered pumps") "Enumeration to specify the pump arrangement";
  type Sensor = enumeration(
      DifferentialPressure
      "Differential pressure",
      HumidityRatio
      "Humidity ratio",
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
      "Flow cross",
      FlowMeter
      "Flow meter")
    "Enumeration to specify the type of volume flow rate sensor";
  // RFE: Add support for PICV.
  type Valve = enumeration(
      None
      "No valve",
      ThreeWayModulating
      "Three-way modulating valve",
      ThreeWayTwoPosition
      "Three-way two-position valve",
      TwoWayModulating
      "Two-way modulating valve",
      TwoWayTwoPosition
      "Two-way two-position valve")
    "Enumeration to configure the valve";
  type ValveCharacteristicTwoWay = enumeration(
      EqualPercentage
      "Equal percentage",
      Linear
      "Linear",
      PressureIndependent
      "Pressure independent (mass flow rate only dependent of input signal)",
      Table
      "Table-specified")
    "Enumeration to specify the characteristic of two-way valves"
    annotation (
      Documentation(info="<html>
<p>
Enumeration that defines the characteristic of two-way valves.
</p>
<table summary=\"summary\"  border=\"1\">
<tr><th>Enumeration</th>
    <th>Description</th></tr>
<tr><td>EqualPercentage</td>
    <td>Equal percentage</td></tr>
<tr><td>Linear</td>
    <td>Linear</td></tr>
<tr><td>PressureIndependent</td>
    <td>Pressure independent (mass flow rate only dependent of input signal)</td></tr>
<tr><td>Table</td>
    <td>Table-specified</td></tr>
</table>
</html>"));
  type ValveCharacteristicThreeWay = enumeration(
      EqualPercentageLinear
      "Equal percentage (direct) and linear (bypass)",
      Linear
      "Linear (both direct and bypass)",
      Table
      "Table-specified (both direct and bypass)")
    "Enumeration to specify the characteristic of the bypass valve"
    annotation (
      Documentation(info="<html>
<p>
Enumeration that defines the characteristic of three-way valves.
</p>
<table summary=\"summary\"  border=\"1\">
<tr><th>Enumeration</th>
    <th>Description</th></tr>
<tr><td>EqualPercentageLinear</td>
    <td>Equal percentage (direct) and linear (bypass)</td></tr>
<tr><td>Linear</td>
    <td>Linear (both direct and bypass)</td></tr>
<tr><td>Table</td>
<td>Table-specified (both direct and bypass)</td></tr>
</table>
</html>"));
  annotation (Documentation(info="<html>
<p>
This package contains type definitions.
</p>
</html>"));
end Types;
