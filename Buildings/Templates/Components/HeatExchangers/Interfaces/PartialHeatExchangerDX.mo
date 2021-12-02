within Buildings.Templates.Components.HeatExchangers.Interfaces;
partial model PartialHeatExchangerDX
  // Air medium needed for type compatibility with DX coil models.
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;

  parameter Buildings.Templates.Components.Types.HeatExchanger typ
    "Type of heat exchanger"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  // DX coils get nominal air flow rate from data record.
  // Only the air pressure drop needs to be declared.
  parameter Modelica.SIunits.PressureDifference dp_nominal
    "Air pressure drop"
    annotation (Dialog(group="Nominal condition"));

  replaceable parameter
    Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.DXCoil datCoi
    constrainedby Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.DXCoil
    "Performance record"
    annotation(choicesAllMatching=true);

  outer parameter Boolean have_dryCon
    "Set to true for purely sensible cooling of the condenser";
  outer parameter String funStr
    "String used to identify the coil function";
  outer parameter String id
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file";

  BoundaryConditions.WeatherData.Bus busWea
    "Weather bus"
    annotation (Placement(
        transformation(extent={{-80,80},{-40,120}}),
        iconTransformation(extent={{-70,90},
            {-50,110}})));
  Buildings.Templates.Components.Interfaces.Bus bus
    "Control bus"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialHeatExchangerDX;
