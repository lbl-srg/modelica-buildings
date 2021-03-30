within Buildings.Templates.Interfaces;
partial model HeatExchangerDX
  // Air medium needed for type compatibility with DX coil models.
  // And binding of m_flow_nominal with performance data record parameter.
  extends Fluid.Interfaces.PartialTwoPort(
    redeclare package Medium=Buildings.Media.Air);

  parameter Types.HeatExchanger typ
    "Type of heat exchanger"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  // DX coils get nominal air flow rate from data record.
  // Only the air pressure drop needs to be declared.
  parameter Modelica.SIunits.PressureDifference dp_nominal
    "Air pressure drop"
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
  .Buildings.Templates.BaseClasses.Connectors.BusInterface busCon "Control bus"
    annotation (Placement(transformation(
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
