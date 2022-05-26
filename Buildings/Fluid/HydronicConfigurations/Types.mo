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
end Types;
