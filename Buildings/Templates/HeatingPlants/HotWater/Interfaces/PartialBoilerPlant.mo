within Buildings.Templates.HeatingPlants.HotWater.Interfaces;
partial model PartialBoilerPlant
  "Interface class for HW boiler plant"
  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "HW medium";

  parameter Buildings.Templates.HeatingPlants.HotWater.Types.PlantBoiler typ
    "Type of boilers"
    annotation (Evaluate=true, Dialog(group="Boilers"));
  parameter Buildings.Templates.Components.Types.ModelBoilerHotWater typMod=
    Buildings.Templates.Components.Types.ModelBoilerHotWater.Polynomial
    "Type of boiler model"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  final parameter Boolean have_boiCon =
    typ==Buildings.Templates.HeatingPlants.HotWater.Types.PlantBoiler.Condensing
    or typ==Buildings.Templates.HeatingPlants.HotWater.Types.PlantBoiler.Hybrid
    "Set to true if the plant includes condensing boilers"
    annotation (Evaluate=true);
  final parameter Boolean have_boiNon=
    typ==Buildings.Templates.HeatingPlants.HotWater.Types.PlantBoiler.NonCondensing
    or typ==Buildings.Templates.HeatingPlants.HotWater.Types.PlantBoiler.Hybrid
    "Set to true if the plant includes non-condensing boilers"
    annotation (Evaluate=true);

  parameter Integer nBoiCon
    "Number of condensing boilers"
    annotation (Evaluate=true, Dialog(group="Boilers",
    enable=have_boiCon));
  parameter Integer nBoiNon
    "Number of non-condensing boilers"
    annotation (Evaluate=true, Dialog(group="Boilers",
    enable=have_boiNon));

  parameter Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary typPumHeaWatPriCon(
    start=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.Variable)
    "Type of primary HW pumps - Condensing boilers"
    annotation (Evaluate=true, Dialog(group="Primary HW loop",
    enable=have_boiCon));
  parameter Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary typPumHeaWatPriNon(
    start=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.Variable)
    "Type of primary HW pumps - Non-condensing boilers"
    annotation (Evaluate=true, Dialog(group="Primary HW loop",
    enable=have_boiNon));

  final parameter Boolean have_bypHeaWatFix=
    typPumHeaWatSec <> Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None
    "Set to true if the plant has a fixed HW bypass"
    annotation(Evaluate=true, Dialog(group="Primary HW loop"));
  final parameter Boolean have_valHeaWatMinByp=
    (have_boiCon and have_varPumHeaWatPri or have_boiNon and have_varPumHeaWatPriNon) and
    typPumHeaWatSec==Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None
    "Set to true if the plant has a HW minimum flow bypass valve"
    annotation(Evaluate=true, Dialog(group="Primary HW loop"));

  parameter Integer nPumHeaWatPriCon(
    start=1,
    final min=0)=if have_boiCon then nBoiCon else 0
    "Number of primary HW pumps - Condensing boilers"
    annotation (Evaluate=true, Dialog(group="Primary HW loop",
    enable=have_boiCon and
    typArrPumHeaWatPriCon==Buildings.Templates.Components.Types.PumpArrangement.Headered));
  parameter Buildings.Templates.Components.Types.PumpArrangement typArrPumHeaWatPriCon
    "Type of primary HW pump arrangement - Condensing boilers"
    annotation (Evaluate=true, Dialog(group="Primary HW loop", enable=have_boiCon));
  final parameter Boolean have_varPumHeaWatPriCon=
    have_boiCon and
    (typPumHeaWatPriCon==Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.FactoryVariable or
    typPumHeaWatPriCon==Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.Variable)
    "Set to true for variable speed primary HW pumps - Condensing boilers"
    annotation (Evaluate=true, Dialog(group="Primary HW loop"));

  parameter Integer nPumHeaWatPriNon(
    start=1,
    final min=0)=if have_boiNon then nBoiNon else 0
    "Number of primary HW pumps - Non-condensing boilers"
    annotation (Evaluate=true, Dialog(group="Primary HW loop",
    enable=have_boiNon and
    typArrPumHeaWatPriNon==Buildings.Templates.Components.Types.PumpArrangement.Headered));
  parameter Buildings.Templates.Components.Types.PumpArrangement typArrPumHeaWatPriNon
    "Type of primary HW pump arrangement - Non-condensing boilers"
    annotation (Evaluate=true, Dialog(group="Primary HW loop", enable=have_boiNon));
  final parameter Boolean have_varPumHeaWatPriNon=
    have_boiNon and
    (typPumHeaWatPriNon==Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.FactoryVariable or
    typPumHeaWatPriNon==Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.Variable)
    "Set to true for variable speed primary HW pumps - Non-condensing boilers"
    annotation (Evaluate=true, Dialog(group="Primary HW loop"));

  final parameter Boolean have_varPumHeaWatPri=
    have_varPumHeaWatPriCon or have_varPumHeaWatPriNon
    "Set to true for variable speed primary HW pumps"
    annotation (Evaluate=true, Dialog(group="Primary HW loop"));

  parameter Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary typPumHeaWatSec(
    start=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None)
    "Type of secondary HW pumps"
    annotation (Evaluate=true, Dialog(group="Secondary HW loop"));
  final parameter Boolean have_pumHeaWatSec=
    typPumHeaWatSec==Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.Centralized
    "Set to true if the plant includes secondary HW pumps"
    annotation(Evaluate=true, Dialog(group="Secondary HW loop"));
  parameter Integer nPumHeaWatSec(
    start=1,
    final min=0)=if have_pumHeaWatSec then max(nBoiCon, nBoiNon) else 0
    "Number of secondary HW pumps"
    annotation (Evaluate=true, Dialog(group="Secondary HW loop",
    enable=have_pumHeaWatSec));
  parameter Integer nLooHeaWatSec=1
    "Number of secondary HW loops for distributed secondary distribution"
    annotation (Evaluate=true, Dialog(group="Secondary HW loop",
    enable=typPumHeaWatSec==Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.Distributed));

  parameter Buildings.Templates.HeatingPlants.HotWater.Types.Controller typCtl
    "Type of controller"
    annotation (Evaluate=true, Dialog(group="Controls", enable=false));
  parameter Integer nAirHan(
    final min=0)=0
    "Number of air handling units served by the plant"
    annotation(Evaluate=true,
    Dialog(group="Controls",
    enable=typCtl==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36));
  parameter Integer nEquZon(
    final min=0)=0
    "Number of terminal units (zone equipment) served by the plant"
    annotation(Evaluate=true,
    Dialog(group="Controls",
    enable=typCtl==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36));

  // See derived class for additional bindings of parameters not defined at top-level.
  parameter Buildings.Templates.HeatingPlants.HotWater.Data.BoilerPlant dat(
    final have_boiCon=have_boiCon,
    final have_boiNon=have_boiNon,
    final nBoiCon=nBoiCon,
    final nBoiNon=nBoiNon,
    final typMod=typMod,
    final typPumHeaWatSec=typPumHeaWatSec,
    final nPumHeaWatPriCon=nPumHeaWatPriCon,
    final nPumHeaWatPriNon=nPumHeaWatPriNon,
    final nPumHeaWatSec=nPumHeaWatSec,
    final have_valHeaWatMinByp=have_valHeaWatMinByp,
    final typArrPumHeaWatPriCon=typArrPumHeaWatPriCon,
    final typArrPumHeaWatPriNon=typArrPumHeaWatPriNon,
    final have_varPumHeaWatPri=have_varPumHeaWatPri,
    final typCtl=typCtl,
    final rho_default=rho_default)
    "Design and operating parameters";

  final parameter Modelica.Units.SI.MassFlowRate mHeaWatPriCon_flow_nominal=
    sum(dat.pumHeaWatPriCon.m_flow_nominal)
    "Primary HW mass flow rate - All condensing boilers";
  final parameter Modelica.Units.SI.MassFlowRate mHeaWatPriNon_flow_nominal=
    sum(dat.pumHeaWatPriNon.m_flow_nominal)
    "Primary HW mass flow rate - All non-condensing boilers";
  final parameter Modelica.Units.SI.MassFlowRate mHeaWatPri_flow_nominal=
    max(mHeaWatPriCon_flow_nominal, mHeaWatPriNon_flow_nominal)
    "Primary HW mass flow rate";
  // FIXME: How to assign HW flow in case of distributed secondary pumps?
  final parameter Modelica.Units.SI.MassFlowRate mHeaWat_flow_nominal=
    if typPumHeaWatSec==Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None
      then mHeaWatPri_flow_nominal
    elseif typPumHeaWatSec==Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.Centralized
      then sum(dat.pumHeaWatSec.m_flow_nominal)
    else mHeaWatPri_flow_nominal
    "HW mass flow rate (total, distributed to consumers)";
  final parameter Modelica.Units.SI.HeatFlowRate cap_nominal=
    sum(dat.boiCon.capBoi_nominal) + sum(dat.boiNon.capBoi_nominal)
    "Heating capacity (total)";
  final parameter Modelica.Units.SI.Temperature THeaWatSup_nominal=
    dat.ctl.THeaWatSup_nominal
    "Maximum HW supply temperature";

  parameter Modelica.Units.SI.Time tau=30
    "Time constant at nominal flow"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation (Dialog(tab="Assumptions"), Evaluate=true);
  parameter Boolean show_T = false
    "= true, if actual temperature at port is computed"
    annotation(Dialog(tab="Advanced",group="Diagnostics"));

  final parameter Medium.Density rho_default=
    Medium.density(sta_default)
    "HW default density";
  final parameter Medium.ThermodynamicState sta_default=
     Medium.setState_pTX(
       T=Buildings.Templates.Data.Defaults.THeaWatSup,
       p=Medium.p_default,
       X=Medium.X_default)
    "HW default state";

  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare final package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "HW return"
    annotation (Placement(transformation(extent={{290,-250},{310,-230}}),
        iconTransformation(extent={{192,-110},{212,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare final package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start = Medium.h_default, nominal = Medium.h_default))
    "HW supply"
    annotation (Placement(transformation(extent={{290,-10},{310,10}}),
        iconTransformation(extent={{192,-10},{212,10}})));
  Buildings.Templates.HeatingPlants.HotWater.Interfaces.Bus bus
    "Plant control bus" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-300,140}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-200,100})));
  Buildings.Templates.AirHandlersFans.Interfaces.Bus busAirHan[nAirHan]
    if nAirHan>0
    "Air handling unit control bus"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={300,180}), iconTransformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={200,140})));
  Buildings.Templates.ZoneEquipment.Interfaces.Bus busEquZon[nEquZon]
    if nEquZon>0
    "Terminal unit control bus"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={300,100}),
        iconTransformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={202,60})));

  Modelica.Units.SI.MassFlowRate m_flow(start=_m_flow_start)=port_a.m_flow
    "Mass flow rate from port_a to port_b (m_flow > 0 is design flow direction)";

  Modelica.Units.SI.PressureDifference dp(
    start=_dp_start,
    displayUnit="Pa")=port_a.p - port_b.p
    "Pressure difference between port_a and port_b";

  Medium.ThermodynamicState sta_a=
    if allowFlowReversal then
      Medium.setState_phX(port_a.p,
                          noEvent(actualStream(port_a.h_outflow)),
                          noEvent(actualStream(port_a.Xi_outflow)))
    else
      Medium.setState_phX(port_a.p,
                          noEvent(inStream(port_a.h_outflow)),
                          noEvent(inStream(port_a.Xi_outflow)))
      if show_T "Medium properties in port_a";

  Medium.ThermodynamicState sta_b=
    if allowFlowReversal then
      Medium.setState_phX(port_b.p,
                          noEvent(actualStream(port_b.h_outflow)),
                          noEvent(actualStream(port_b.Xi_outflow)))
    else
      Medium.setState_phX(port_b.p,
                          noEvent(port_b.h_outflow),
                          noEvent(port_b.Xi_outflow))
       if show_T "Medium properties in port_b";

protected
  final parameter Modelica.Units.SI.MassFlowRate _m_flow_start=0
    "Start value for m_flow, used to avoid a warning if not set in m_flow, and to avoid m_flow.start in parameter window";
  final parameter Modelica.Units.SI.PressureDifference _dp_start(
    displayUnit="Pa")=0
    "Start value for dp, used to avoid a warning if not set in dp, and to avoid dp.start in parameter window";

initial equation
  if have_boiCon and typArrPumHeaWatPriCon==Buildings.Templates.Components.Types.PumpArrangement.Dedicated then
    assert(nPumHeaWatPriCon==nBoiCon,
      "In " + getInstanceName() + ": " +
      "In case of dedicated pumps, the number of primary HW pumps (=" +
      String(nPumHeaWatPriCon) + ") must be equal to the number of boilers (=" +
      String(nBoiCon) + ").");
  end if;
  if have_boiNon and typArrPumHeaWatPriNon==Buildings.Templates.Components.Types.PumpArrangement.Dedicated then
    assert(nPumHeaWatPriNon==nBoiNon,
      "In " + getInstanceName() + ": " +
      "In case of dedicated pumps, the number of primary HW pumps (=" +
      String(nPumHeaWatPriNon) + ") must be equal to the number of boilers (=" +
      String(nBoiNon) + ").");
  end if;

  annotation (
    defaultComponentName="plaHeaWat",
    Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-200,-200},{200,200}}),
    graphics={
      Rectangle(
        extent={{-200,200},{202,-200}},
        lineColor={0,0,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-149,-214},{151,-254}},
          textColor={0,0,255},
          textString="%name")}),
   Diagram(coordinateSystem(
      preserveAspectRatio=false,
      extent={{-300,-280},{300,280}})));
end PartialBoilerPlant;
