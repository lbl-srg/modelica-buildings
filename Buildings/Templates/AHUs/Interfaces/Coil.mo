within Buildings.Templates.AHUs.Interfaces;
partial model Coil
  extends Buildings.Fluid.Interfaces.PartialTwoPort(
    redeclare final package Medium=MediumAir);

  replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium";
  replaceable package MediumSou=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Source side medium"
    annotation(Dialog(enable=have_sou));

  parameter Types.Coil typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Types.Actuator typAct
    "Type of actuator"
    annotation (Dialog(group="Actuator"));
  parameter Types.HeatExchanger typHex
    "Type of HX"
    annotation (Dialog(group="Heat exchanger"));
  parameter Boolean have_sou = false
    "Set to true for fluid ports on the source side"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_weaBus = false
    annotation (Evaluate=true, Dialog(group="Configuration"));

  // Conditional
  Modelica.Fluid.Interfaces.FluidPort_a port_aSou(
    redeclare final package Medium = MediumSou) if have_sou
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-50,-110},{-30,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bSou(
    redeclare final package Medium = MediumSou) if have_sou
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{50,-110},{30,-90}})));
  BoundaryConditions.WeatherData.Bus weaBus if have_weaBus
    annotation (Placement(
        transformation(extent={{-80,80},{-40,120}}), iconTransformation(extent={{-70,90},
            {-50,110}})));
  Templates.BaseClasses.AhuBus ahuBus if typ<>Types.Coil.None
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}),    iconTransformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                                              Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Coil;
