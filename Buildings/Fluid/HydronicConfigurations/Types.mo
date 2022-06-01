within Buildings.Fluid.HydronicConfigurations;
package Types "Package with type definitions"
  extends Modelica.Icons.TypesPackage;

  type ControlFunction = enumeration(
      ChangeOver
    "Change-over",
      Cooling
    "Cooling",
      Heating
    "Heating")
  "Enumeration to specify the circuit function in case of built-in controls";
  type ControlVariable = enumeration(
      ReturnTemperature
    "Consumer circuit return temperature",
      SupplyTemperature
    "Consumer circuit supply temperature")
  "Enumeration to specify the controlled variable";
  type Pump = enumeration(
      SingleConstant
      "Single pump - Constant speed",
      SingleVariable
      "Single pump - Variable speed")
    "Enumeration to specify the type of pump";
  type PumpModel = enumeration(
      Head
      "Pump with ideally controlled head as input",
      MassFlowRate
      "Pump with ideally controlled mass flow rate as input",
      SpeedFractional
      "Pump with ideally controlled normalized speed as input",
      SpeedRotational
      "Pump with ideally controlled rotational speed as input")
    "Enumeration to specify the type of pump model";
  type Valve = enumeration(
      ThreeWay
    "Three-way valve",
      TwoWay
    "Two-way valve")
    "Enumeration to specify the type of control valve";
  type ValveCharacteristic = enumeration(
      EqualPercentage
      "Equal percentage - Equal percentage and linear for three-way valves",
      Linear
      "Linear",
      Table
      "Table-specified")
    "Enumeration to specify the control valve characteristic";
end Types;
