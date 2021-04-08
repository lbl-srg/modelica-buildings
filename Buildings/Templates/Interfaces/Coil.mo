within Buildings.Templates.Interfaces;
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
    annotation (Dialog(group="Configuration"));
  parameter Types.HeatExchanger typHex
    "Type of heat exchanger"
    annotation (Dialog(group="Configuration"));
  parameter Boolean have_sou = false
    "Set to true for fluid ports on the source side"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_weaBus = false
    "Set to true to use a waether bus"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_senTem = false
    "Set to true to use a leaving air temperature sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  outer parameter String id
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file";
  final inner parameter String funStr=
    if Modelica.Utilities.Strings.find(insNam, "coiCoo")<>0 then "Cooling"
    elseif Modelica.Utilities.Strings.find(insNam, "coiHea")<>0 then "Heating"
    elseif Modelica.Utilities.Strings.find(insNam, "coiReh")<>0 then "Reheat"
    else "Undefined"
    "String used to identify the coil function"
    annotation (
      Dialog(group="Configuration"),
      Evaluate=true);
  final parameter String insNam = getInstanceName()
    "Instance name"
    annotation(Evaluate=true);

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
  BaseClasses.Connectors.BusInterface busCon if typ <> Types.Coil.None
    "Control bus" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));

  BaseClasses.Sensors.Wrapper TLvg(
    redeclare final package Medium=MediumAir,
    final typ=if have_senTem then Templates.Types.Sensor.Temperature else
      Templates.Types.Sensor.None)
    "Leaving air temperature sensor"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
protected
  Modelica.Fluid.Interfaces.FluidPort_b port_bIns(
    redeclare final package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Inside fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{70,-10},{50,10}})));

equation
  connect(port_bIns, TLvg.port_a)
    annotation (Line(points={{60,0},{70,0}},          color={0,127,255}));
  connect(TLvg.port_b, port_b)
    annotation (Line(points={{90,0},{100,0}},           color={0,127,255}));
  connect(busCon, TLvg.busCon) annotation (Line(
      points={{0,100},{0,96},{80,96},{80,10}},
      color={255,204,51},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                                              Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Coil;
