within Buildings.Templates.AHUs.Interfaces;
model HeatExchangerWater
  extends Fluid.Interfaces.PartialFourPortInterface;

  parameter Types.HeatExchanger typ
    "Type of HX"
    annotation (Dialog(group="Heat exchanger"));
  parameter Modelica.SIunits.PressureDifference dp1_nominal
    "Pressure difference";
  parameter Modelica.SIunits.PressureDifference dp2_nominal
    "Pressure difference";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HeatExchangerWater;
