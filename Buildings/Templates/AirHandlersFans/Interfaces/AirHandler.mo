within Buildings.Templates.AirHandlersFans.Interfaces;
partial model AirHandler "Base interface class for air handler"
  inner replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium";
  inner replaceable package MediumCoo=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Cooling medium (such as CHW)"
    annotation(Dialog(enable=have_souCoiCoo));
  inner replaceable package MediumHea=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Heating medium (such as HHW)"
    annotation(Dialog(enable=have_souCoiHeaPre or have_souCoiHeaReh));

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

  parameter Boolean have_souCoiCoo = coiCoo.have_sou
    "Set to true if cooling coil requires fluid ports on the source side"
    annotation (Evaluate=true, Dialog(group="Cooling coil"));
  parameter Boolean have_souCoiHeaPre=coiHeaPre.have_sou
    "Set to true if heating coil requires fluid ports on the source side"
    annotation (Evaluate=true, Dialog(group="Heating coil"));
  parameter Boolean have_souCoiHeaReh=coiHeaReh.have_sou
    "Set to true if reheat coil requires fluid ports on the source side"
    annotation (Evaluate=true, Dialog(group="Heating coil"));

  inner parameter Modelica.Units.SI.MassFlowRate mAirSup_flow_nominal=
    dat.getReal(varName=id + ".mechanical.mAirSup_flow_nominal.value")
    "Supply air mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  inner parameter Modelica.Units.SI.MassFlowRate mAirRet_flow_nominal=
    dat.getReal(varName=id + ".mechanical.mAirRet_flow_nominal.value")
    "Return air mass flow rate"
    annotation (Dialog(group="Nominal condition"));

  inner parameter String id
    "System tag"
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

  /* FIXME: Evaluate function call at compile time
  inner parameter Integer nZon=
    ExternData.Functions.JSON.readArraySize1D(
      fileName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/Data/Templates/Validation/systems.json"),
      varName=id + ".identification.idTerArr.value")
    "Number of served zones"
    annotation (
      Evaluate=true,
      Dialog(group="Configuration"));
  inner parameter Integer nGro=
    ExternData.Functions.JSON.readArraySize1D(
      fileName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/Data/Templates/Validation/systems.json"),
      varName=id + ".identification.namGro.value")
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
  Modelica.Fluid.Interfaces.FluidPort_b port_coiCooRet(
    redeclare final package Medium = MediumCoo) if have_souCoiCoo
    "Cooling coil return port"
    annotation (Placement(
      transformation(extent={{50,-290},{70,-270}}),
      iconTransformation(extent={{-40,-210},{-20,-190}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_coiCooSup(
    redeclare final package Medium = MediumCoo) if have_souCoiCoo
    "Cooling coil supply port"
    annotation (Placement(
        transformation(extent={{90,-290},{110,-270}}),iconTransformation(
          extent={{20,-208},{40,-188}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_coiHeaPreRet(redeclare final
      package Medium = MediumHea) if have_souCoiHeaPre
    "Heating coil (preheat position) return port" annotation (Placement(
        transformation(extent={{-30,-290},{-10,-270}}), iconTransformation(
          extent={{-160,-210},{-140,-190}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_coiHeaPreSup(redeclare final
      package Medium = MediumHea) if have_souCoiHeaPre
    "Heating coil (preheat position) supply port" annotation (Placement(
        transformation(extent={{10,-290},{30,-270}}), iconTransformation(extent={{-100,
            -210},{-80,-190}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_coiHeaRehRet(redeclare final
      package Medium = MediumHea) if have_souCoiHeaReh
    "Heating coil (reheat position) return port" annotation (Placement(
        transformation(extent={{130,-290},{150,-270}}), iconTransformation(
          extent={{80,-210},{100,-190}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_coiHeaRehSup(redeclare final
      package Medium = MediumHea) if have_souCoiHeaReh
    "Heating coil (reheat position) supply port" annotation (Placement(
        transformation(extent={{170,-290},{190,-270}}), iconTransformation(
          extent={{140,-210},{160,-190}})));
  Bus bus
    "AHU control bus"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-300,0}), iconTransformation(
        extent={{-20,-19},{20,19}},
        rotation=90,
        origin={-199,160})));
  BoundaryConditions.WeatherData.Bus busWea
    "Weather bus"
    annotation (Placement(transformation(extent={{-20,260},{20,300}}),
      iconTransformation(extent={{-20,182},{20,218}})));

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
