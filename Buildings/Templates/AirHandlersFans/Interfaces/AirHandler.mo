within Buildings.Templates.AirHandlersFans.Interfaces;
partial model AirHandler "Base interface class for air handler"
  inner replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium";

  parameter Boolean isModCtrSpe = true
    "Set to true to activate the control specification mode"
    annotation(Evaluate=true);

  parameter Buildings.Templates.AirHandlersFans.Types.Configuration typ
    "Type of system"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_porRel = typ==Types.Configuration.ExhaustOnly
    "Set to true for relief (exhaust) fluid port"
    annotation (
      Evaluate=true,
      Dialog(
        group="Configuration",
        enable=false));

  parameter Modelica.SIunits.MassFlowRate mSup_flow_nominal=
    dat.getReal(varName=id + ".Mechanical.Supply air mass flow rate.value")
    "Supply air mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate mRet_flow_nominal=
    dat.getReal(varName=id + ".Mechanical.Return air mass flow rate.value")
    "Return air mass flow rate"
    annotation (Dialog(group="Nominal condition"));

  inner parameter String id
    "System name"
    annotation (
      Evaluate=true,
      Dialog(group="Configuration"));
  outer parameter ExternData.JSONFile dat
    "External parameter file";

  // See FIXME below for those parameters.
  inner parameter Integer nZon
    "Number of served zones"
    annotation (
      Evaluate=true,
      Dialog(group="Configuration"));
  inner parameter Integer nGro(min=1)
    "Number of zone groups"
    annotation (
      Evaluate=true,
      Dialog(group="Configuration"));

  /* FIXME: Evaluate function call at compile time, FE ExternData.
  inner parameter Integer nZon=
    dat.getArraySize1D(varName=id + ".Terminal unit identifiers.value")
    "Number of served zones"
    annotation (
      Evaluate=true,
      Dialog(group="Configuration"));
  inner parameter Integer nGro=
    dat.getArraySize1D(varName=id + ".Zone group names.value")
    "Number of zone groups"
    annotation (
      Evaluate=true,
      Dialog(group="Configuration"));
      */

  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  Modelica.Fluid.Interfaces.FluidPort_a port_Out(
    redeclare final package Medium = MediumAir,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default))
    if typ <> AirHandlersFans.Types.Configuration.ExhaustOnly
    "Outdoor air intake"
    annotation (Placement(transformation(
          extent={{-310,-210},{-290,-190}}), iconTransformation(extent={{-210,
            -110},{-190,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_Sup(
    redeclare final package Medium =MediumAir,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default)) if typ
     == AirHandlersFans.Types.Configuration.SupplyOnly or typ ==
    AirHandlersFans.Types.Configuration.SingleDuct
    "Supply air" annotation (
      Placement(transformation(extent={{290,-210},{310,-190}}),
        iconTransformation(extent={{190,-110},{210,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_SupCol(
    redeclare final package Medium =MediumAir,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default))
    if typ == AirHandlersFans.Types.Configuration.DualDuct
    "Dual duct cold deck air supply"
    annotation (Placement(transformation(
          extent={{290,-250},{310,-230}}), iconTransformation(extent={{190,
            -180},{210,-160}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_SupHot(
    redeclare final package Medium =MediumAir,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default))
    if typ == AirHandlersFans.Types.Configuration.DualDuct
    "Dual duct hot deck air supply"
    annotation (Placement(
        transformation(extent={{290,-170},{310,-150}}), iconTransformation(
          extent={{190,-40},{210,-20}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_Ret(
    redeclare final package Medium =MediumAir,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default))
    if typ <> AirHandlersFans.Types.Configuration.SupplyOnly
    "Return air"
    annotation (Placement(transformation(extent={{290,-90},{310,-70}}),
        iconTransformation(extent={{190,90},{210,110}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_Rel(
    redeclare final package Medium = MediumAir,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default))
    if typ <> AirHandlersFans.Types.Configuration.SupplyOnly and have_porRel
    "Relief (exhaust) air"
    annotation (Placement(transformation(
          extent={{-310,-90},{-290,-70}}), iconTransformation(extent={{-210,90},
            {-190,110}})));

  Bus bus
    "AHU control bus"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-300,0}), iconTransformation(
        extent={{-20,-19},{20,19}},
        rotation=90,
        origin={-199,160})));

  ZoneEquipment.Interfaces.Bus busTer[nZon]
    "Terminal unit control bus" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={300,0}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={198,160})));

    annotation (
    Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-200,-200},{200,200}}), graphics={
        Text(
          extent={{-155,-218},{145,-258}},
          lineColor={0,0,255},
          textString="%name"), Rectangle(
          extent={{-200,200},{200,-200}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
    Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-300,-280},{300,
            280}}), graphics={
        Rectangle(
          extent={{-300,40},{300,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={245,239,184},
          pattern=LinePattern.None)}));
end AirHandler;
