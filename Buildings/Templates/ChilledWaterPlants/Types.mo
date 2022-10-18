within Buildings.Templates.ChilledWaterPlants;
package Types
  extends Modelica.Icons.TypesPackage;
  type ChillerArrangement = enumeration(
      Parallel
      "Parallel chillers",
      Series
      "Series chillers")
      "Enumeration to configure the chiller arrangement";
  type ChillerCompressor = enumeration(
      ConstantSpeed "Constant speed centrifugal",
      VariableSpeed "Variable speed centrifugal",
      PositiveDisplacement "Positive displacement (screw or scroll)")
      "Enumeration to specify the type of compressor";
  type ChillerLiftControl = enumeration(
      None "No head pressure control (e.g. magnetic bearing chiller)",
      BuiltIn "Head pressure control built into chiller’s controller (AO available)",
      External "Head pressure control by BAS")
    "Enumeration to specify the type of head pressure control";
  type Controller = enumeration(
      Guideline36 "Guideline 36 control sequence",
      OpenLoop "Open loop")
      "Enumeration to specify the plant controller";
  type CoolerFanSpeedControl = enumeration(
      ReturnTemperature "Condenser water return temperature control",
      SupplyTemperature "Condenser water supply temperature control")
      "Enumeration to specify the cooler fan speed control";
  type Distribution = enumeration(
      Constant1Only "Constant primary-only",
      Variable1Only "Variable primary-only",
      Constant1Variable2 "Constant primary - Variable secondary centralized",
      Variable1And2 "Variable primary - Variable secondary centralized",
      Variable1And2Distributed "Variable primary - Variable secondary distributed")
      "Enumeration to specify the type of CHW distribution system";
  type Economizer = enumeration(
      None "No waterside economizer",
      HeatExchangerWithPump "Heat exchanger with pump for CHW flow control",
      HeatExchangerWithValve "Heat exchanger with bypass valve for CHW flow control")
      "Enumeration to configure the WSE";
  type PrimaryOverflowMeasurement = enumeration(
      FlowDecoupler "Flow meter in the decoupler",
      FlowDifference "Primary and secondary loop flow meters",
      TemperatureSupplySensor "Delta-T with single CHWST sensor measuring combined flow of all chillers",
      TemperatureChillerSensor "Delta-T with weighted average of CHWST of all chillers proven on")
    "Enumeration to configure the sensors for primary CHW pump control in variable primary-variable secondary plants";
  type SensorLocation = enumeration(
      Return "Sensor in the return line",
      Supply "Sensor in the supply line")
      "Enumeration to specify the sensor location";
end Types;
