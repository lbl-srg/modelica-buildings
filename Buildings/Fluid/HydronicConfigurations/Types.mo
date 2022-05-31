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
  type ValveCharacteristic = enumeration(
      EqualPercentage
      "Equal percentage - Equal percentage and linear for three-way valves",
      Linear
      "Linear",
      Table
      "Table-specified")
    "Enumeration to specify the valve characteristic";
end Types;
