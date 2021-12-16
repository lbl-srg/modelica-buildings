within Buildings.Templates.Components.HeatExchangers.Interfaces;
partial model PartialCoilWater
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface;

  parameter Buildings.Templates.Components.Types.HeatExchanger typ
    "Type of heat exchanger"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Modelica.Units.SI.PressureDifference dp1_nominal
    "Liquid pressure drop"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dp2_nominal
    "Air pressure drop"
    annotation (Dialog(group="Nominal condition"));

  outer parameter String funStr
    "String used to identify the coil function";
  outer parameter String id
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
    Bitmap(
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/HeatExchangers/Generic.svg")}),
                                            Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialCoilWater;
