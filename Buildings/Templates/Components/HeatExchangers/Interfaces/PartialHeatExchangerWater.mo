within Buildings.Templates.Components.HeatExchangers.Interfaces;
partial model PartialHeatExchangerWater
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface;

  parameter Buildings.Templates.Components.Types.HeatExchanger typ
    "Type of heat exchanger"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Modelica.SIunits.PressureDifference dp1_nominal
    "Liquid pressure drop"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dp2_nominal
    "Air pressure drop"
    annotation (Dialog(group="Nominal condition"));

  outer parameter String funStr
    "String used to identify the coil function";
  outer parameter String id
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialHeatExchangerWater;
