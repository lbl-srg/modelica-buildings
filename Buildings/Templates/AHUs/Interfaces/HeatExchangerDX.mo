within Buildings.Templates.AHUs.Interfaces;
partial model HeatExchangerDX
  extends Fluid.Interfaces.PartialTwoPortInterface;

  parameter Types.HeatExchanger typ
    "Type of HX"
    annotation (Evaluate=true, Dialog(group="Heat exchanger"));
  parameter Modelica.SIunits.PressureDifference dp_nominal
    "Pressure difference"
    annotation (Dialog(group="Nominal condition"));

  outer parameter String funStr
    "String used to identify the coil function";
  outer parameter String id
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file";

  BoundaryConditions.WeatherData.Bus weaBus
    "Weather bus"
    annotation (Placement(
        transformation(extent={{-80,80},{-40,120}}),
        iconTransformation(extent={{-70,90},
            {-50,110}})));
  .Buildings.Templates.BaseClasses.AhuBus ahuBus "Control bus" annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HeatExchangerDX;
