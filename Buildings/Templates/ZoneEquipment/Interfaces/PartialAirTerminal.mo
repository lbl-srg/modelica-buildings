within Buildings.Templates.ZoneEquipment.Interfaces;
partial model PartialAirTerminal
  "Interface class for air terminal unit"

  replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium"
    annotation(__Linkage(enable=false));
  replaceable package MediumHeaWat=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "HHW medium"
    annotation(Dialog(enable=have_souHeaWat), __Linkage(enable=false));

  parameter Buildings.Templates.ZoneEquipment.Types.Configuration typ
    "Type of system"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  final parameter String id=dat.id
   "System tag"
    annotation (Dialog(group="Configuration"));

  parameter Boolean have_souChiWat
    "Set to true if system uses CHW"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_souHeaWat
    "Set to true if system uses HHW"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  replaceable parameter Buildings.Templates.ZoneEquipment.Data.PartialAirTerminal dat(
    final typ=typ,
    final have_souChiWat=have_souChiWat,
    final have_souHeaWat=have_souHeaWat)
    "Design and operating parameters"
    annotation (Placement(transformation(extent={{270,250},{290,270}})));

  // Design parameters
  final parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal=
    dat.mAir_flow_nominal
    "Discharge air mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mAirPri_flow_nominal
    "Primary air mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_nominal
    "Total CHW mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mHeaWat_flow_nominal
    "Total HHW mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate QChiWat_flow_nominal
    "Total CHW heat flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate QHeaWat_flow_nominal
    "Total HHW heat flow rate"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.Time tau=20
    "Time constant at nominal flow"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"),
      __Linkage(enable=false));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"),
      __Linkage(enable=false));

  final parameter Boolean allowFlowReversalAir=true
    "= true to allow flow reversal, false restricts to design direction - Air side"
    annotation (Dialog(tab="Assumptions"), Evaluate=true,
      __Linkage(enable=false));
  parameter Boolean allowFlowReversalLiq=true
    "= true to allow flow reversal, false restricts to design direction - CHW and HW side"
    annotation (Dialog(tab="Assumptions", enable=have_souChiWat or have_souHeaWat),
      Evaluate=true,
      __Linkage(enable=false));
  parameter Boolean show_T = false
    "= true, if actual temperature at ports of subcomponents is computed"
    annotation(Dialog(tab="Advanced",group="Diagnostics"),
      __Linkage(enable=false));

  Modelica.Fluid.Interfaces.FluidPort_a port_Sup(
    redeclare final package Medium = MediumAir,
    m_flow(min=if allowFlowReversalAir then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default))
    if typ <> Buildings.Templates.ZoneEquipment.Types.Configuration.DualDuct
    "Supply air from AHU"
    annotation (
      Placement(transformation(extent={{-310,-210},{-290,-190}}),
        iconTransformation(extent={{-210,-10},{-190,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_SupCol(
    redeclare final package Medium = MediumAir,
    m_flow(min=if allowFlowReversalAir then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default))
    if typ == Buildings.Templates.ZoneEquipment.Types.Configuration.DualDuct
    "Dual duct cold deck air supply from AHU"
    annotation (Placement(transformation(
          extent={{-310,-250},{-290,-230}}), iconTransformation(extent={{-210,-110},
            {-190,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_SupHot(
    redeclare final package Medium = MediumAir,
    m_flow(min=if allowFlowReversalAir then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default))
    if typ == Buildings.Templates.ZoneEquipment.Types.Configuration.DualDuct
    "Dual duct hot deck air supply from AHU"
    annotation (Placement(
        transformation(extent={{-310,-170},{-290,-150}}), iconTransformation(
          extent={{-210,90},{-190,110}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_Dis(
    redeclare final package Medium =MediumAir,
    m_flow(max=if allowFlowReversalAir then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default))
    "Discharge air"
    annotation (Placement(transformation(extent={{290,-210},{310,-190}}),
        iconTransformation(extent={{190,-10},{210,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_Ret(
    redeclare final package Medium =MediumAir,
    m_flow(max=if allowFlowReversalAir then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default))
    if typ == Buildings.Templates.ZoneEquipment.Types.Configuration.FanPowered
     or typ == Buildings.Templates.ZoneEquipment.Types.Configuration.Induction
    "Return air"
    annotation (Placement(
        transformation(extent={{290,-90},{310,-70}}), iconTransformation(
          extent={{190,90},{210,110}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_aHeaWat(
    redeclare final package Medium = MediumHeaWat,
    m_flow(min=if allowFlowReversalLiq then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumHeaWat.h_default, nominal=MediumHeaWat.h_default))
    if have_souHeaWat
    "HHW supply port" annotation (
      Placement(transformation(extent={{10,-290},{30,-270}}),
        iconTransformation(extent={{40,-210},{60,-190}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bHeaWat(
    redeclare final package Medium = MediumHeaWat,
    m_flow(max=if allowFlowReversalLiq then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumHeaWat.h_default, nominal=MediumHeaWat.h_default))
    if have_souHeaWat
    "HHW return port" annotation (
      Placement(transformation(extent={{-30,-290},{-10,-270}}),
        iconTransformation(extent={{-60,-210},{-40,-190}})));

  Buildings.Templates.ZoneEquipment.Interfaces.Bus bus
    "Terminal unit control bus"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-300,0}), iconTransformation(
        extent={{-20,-19},{20,19}},
        rotation=90,
        origin={-199,160})));

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-200,-200},{200,200}}), graphics={
        Text(
          extent={{-155,-218},{145,-258}},
          textColor={0,0,255},
          textString="%name"), Rectangle(
          extent={{-200,200},{200,-200}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
                                       Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-300,-280},{300,
            280}})),
    Documentation(info="<html>
<p>
This partial class provides a standard interface for air terminal unit templates.
</p>
</html>"));
end PartialAirTerminal;
