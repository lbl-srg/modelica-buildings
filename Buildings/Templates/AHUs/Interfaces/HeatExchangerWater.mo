within Buildings.Templates.AHUs.Interfaces;
partial model HeatExchangerWater
  extends Fluid.Interfaces.PartialFourPortInterface;

  parameter Types.HeatExchanger typ
    "Type of HX"
    annotation (Evaluate=true, Dialog(group="Heat exchanger"));
  parameter Modelica.SIunits.PressureDifference dp1_nominal
    "Pressure difference"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dp2_nominal
    "Pressure difference"
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
end HeatExchangerWater;
