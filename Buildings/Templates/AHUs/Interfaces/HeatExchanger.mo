within Buildings.Templates.AHUs.Interfaces;
model HeatExchanger
  extends Fluid.Interfaces.PartialFourPortInterface;

  parameter Types.HeatExchanger typ
    "Type of HX"
    annotation (Dialog(group="Heat exchanger"));
  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal
  "Nominal mass flow rate";
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal
  "Nominal mass flow rate";
  parameter Modelica.SIunits.PressureDifference dp1_nominal
  "Pressure difference";
  parameter Modelica.SIunits.PressureDifference dp2_nominal
  "Pressure difference";

  outer parameter String id=""
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HeatExchanger;
