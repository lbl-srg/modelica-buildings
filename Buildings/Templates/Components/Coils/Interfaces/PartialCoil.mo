within Buildings.Templates.Components.Coils.Interfaces;
partial model PartialCoil
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    redeclare final package Medium=MediumAir,
    final m_flow_nominal=mAir_flow_nominal);

  outer replaceable package MediumAir=Buildings.Media.Air
    "Source-side medium";
  /* 
  The following definition is needed only for Dymola that does not allow
  port_aSou and port_bSou to be instantiated without redeclaring their medium
  to a non-partial class (which is done only in the derived class).
  */
  replaceable package MediumSou=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Source-side medium";

  parameter Buildings.Templates.Components.Types.Coil typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Valve typVal
    "Type of valve"
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

  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal(final min=0)
    "Air mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dpAir_nominal(final min=0,
    displayUnit="Pa")
    "Air pressure drop"
    annotation (
      Dialog(group="Nominal condition"),
      Evaluate=true);

  outer parameter String id
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file";
  final inner parameter String funStr=
    if typ==Buildings.Templates.Components.Types.Coil.ElectricHeating
      then "Heating"
    elseif typ==Buildings.Templates.Components.Types.Coil.Evaporator
      then "Cooling"
    elseif typ==Buildings.Templates.Components.Types.Coil.WaterBasedCooling
      then "Cooling"
    elseif typ==Buildings.Templates.Components.Types.Coil.WaterBasedHeating
      then "Heating"
    else "Undefined"
    "Coil function cast as string"
    annotation (
      Dialog(group="Configuration"),
      Evaluate=true);

  Modelica.Fluid.Interfaces.FluidPort_a port_aSou(
    redeclare package Medium = MediumSou) if have_sou
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{30,-110},{50,-90}}),
        iconTransformation(extent={{40,-110},{60,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bSou(
    redeclare package Medium = MediumSou) if have_sou
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-30,-110},{-50,-90}}),
        iconTransformation(extent={{-40,-110},{-60,-90}})));
  Buildings.BoundaryConditions.WeatherData.Bus busWea if have_weaBus
    "Weather bus"
    annotation (Placement(
        transformation(extent={{-80,80},{-40,120}}), iconTransformation(extent={{-70,90},
            {-50,110}})));
  Buildings.Templates.Components.Interfaces.Bus bus
    if typ <> Buildings.Templates.Components.Types.Coil.None
    "Control bus"
    annotation (Placement(
      transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));

  annotation (
  Icon(
    graphics={
    Bitmap(
      visible=funStr=="Cooling",
      extent={{-53,-100},{53,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Coils/Cooling.svg"),
    Bitmap(
      visible=typ==Buildings.Templates.Components.Types.Coil.WaterBasedCooling,
      extent={{-100,-500},{100,-300}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Coils/ChilledWaterSupplyReturn.svg"),
    Bitmap(
      visible=funStr=="Heating",
      extent={{-53,-100},{53,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Coils/Heating.svg"),
    Bitmap(
      visible=typ==Buildings.Templates.Components.Types.Coil.WaterBasedHeating,
      extent={{-100,-500},{100,-300}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Coils/HotWaterSupplyReturn.svg"),
    Bitmap(
      visible=typ<>Buildings.Templates.Components.Types.Coil.None and
        typVal==Buildings.Templates.Components.Types.Valve.None,
      extent={{-150,-300},{50,-100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/None.svg"),
    Bitmap(
      visible=typ<>Buildings.Templates.Components.Types.Coil.None and
        typVal==Buildings.Templates.Components.Types.Valve.TwoWayModulating,
      extent={{-150,-300},{50,-100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg"),
    Bitmap(
      visible=typ<>Buildings.Templates.Components.Types.Coil.None and
        typVal==Buildings.Templates.Components.Types.Valve.ThreeWayModulating,
      extent={{-150,-300},{50,-100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/ThreeWay.svg"),
    Bitmap(
      visible=typ<>Buildings.Templates.Components.Types.Coil.None and
        (typVal==Buildings.Templates.Components.Types.Valve.TwoWayModulating or
        typVal==Buildings.Templates.Components.Types.Valve.ThreeWayModulating),
      extent={{-190,-240},{-110,-160}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulating.svg"),
    Bitmap(
      visible=typ<>Buildings.Templates.Components.Types.Coil.None,
      extent={{-50,-300},{150,-100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/None.svg")},
    coordinateSystem(preserveAspectRatio=false)),
    Diagram(
        coordinateSystem(preserveAspectRatio=false)));

end PartialCoil;
