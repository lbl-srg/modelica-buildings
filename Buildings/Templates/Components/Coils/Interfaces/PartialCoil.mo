within Buildings.Templates.Components.Coils.Interfaces;
partial model PartialCoil
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    redeclare final package Medium=MediumAir,
    final m_flow_nominal=mAir_flow_nominal);

  outer replaceable package MediumAir=Buildings.Media.Air
    "Source-side medium";
  /* The following definition is needed only for Dymola that does not allow
  port_aSou and port_bSou to be instantiated without redeclaring their medium
  to a non-partial class (which is done only in the derived class).
  */
  replaceable package MediumSou=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Source-side medium";

  parameter Buildings.Templates.Components.Types.Coil typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.CoilFunction fun
    "Coil function"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Actuator typAct
    "Type of actuator"
    annotation (Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.HeatExchanger typHex
    "Type of heat exchanger"
    annotation (Dialog(group="Configuration"));
  parameter Boolean have_sou = false
    "Set to true for fluid ports on the source side"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_weaBus = false
    "Set to true to use a waether bus"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  inner parameter Modelica.SIunits.MassFlowRate mAir_flow_nominal(min=0)=
    dat.getReal(varName=id + ".Mechanical." + funStr + " coil.Air mass flow rate.value")
    "Air mass flow rate"
    annotation (Dialog(
      group="Nominal condition"),
      Evaluate=true);

  inner parameter Modelica.SIunits.PressureDifference dpAir_nominal(
    displayUnit="Pa")=
    dat.getReal(varName=id + ".Mechanical." + funStr + " coil.Air pressure drop.value")
    "Air pressure drop"
    annotation (
      Dialog(group="Nominal condition"),
      Evaluate=true);

  outer parameter String id
    "System identifier";
  outer parameter Templates.BaseClasses.ExternDataLocal.JSONFile dat
    "External parameter file";
  final inner parameter String funStr=
    if fun==Buildings.Templates.Components.Types.CoilFunction.Cooling
      then "Cooling"
    elseif fun==Buildings.Templates.Components.Types.CoilFunction.Heating
      then "Heating"
    elseif fun==Buildings.Templates.Components.Types.CoilFunction.Reheat
      then "Reheat"
    else "Undefined"
    "Coil function cast as string"
    annotation (
      Dialog(group="Configuration"),
      Evaluate=true);

  Modelica.Fluid.Interfaces.FluidPort_a port_aSou(
    redeclare package Medium = MediumSou) if have_sou
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-50,-110},{-30,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bSou(
    redeclare package Medium = MediumSou) if have_sou
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{50,-110},{30,-90}})));
  Buildings.BoundaryConditions.WeatherData.Bus busWea if have_weaBus
    "Weather bus"
    annotation (Placement(
        transformation(extent={{-80,80},{-40,120}}), iconTransformation(extent={{-70,90},
            {-50,110}})));
  Buildings.Templates.Components.Interfaces.Bus bus
    if typ <> Buildings.Templates.Components.Types.Coil.None
    "Control bus"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));

  annotation (Icon(
    coordinateSystem(preserveAspectRatio=false), graphics={
      Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
      Diagram(
        coordinateSystem(preserveAspectRatio=false)));

end PartialCoil;
