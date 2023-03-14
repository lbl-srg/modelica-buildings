within Buildings.Templates.HeatingPlants.HotWater.Interfaces;
partial model PartialHotWaterPlant "Interface class for HW plant"
  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "HW medium";

  parameter Buildings.Templates.HeatingPlants.HotWater.Types.Plant typ
    "Type of plant"
    annotation (Evaluate=true, Dialog(enable=false));
  parameter Integer nUni(
    start=1,
    final min=1)
    "Number of heating units"
    annotation (Evaluate=true, Dialog(group="Heating equipment"));
  parameter
    Buildings.Templates.HeatingPlants.HotWater.Types.Distribution
    typDisHeaWat "Type of HW distribution system"
    annotation (Evaluate=true,
      Dialog(group="Primary HW loop"));

  final parameter Boolean have_bypHeaWatFix=
    typDisHeaWat==Buildings.Templates.HeatingPlants.HotWater.Types.Distribution.Constant1Variable2 or
    typDisHeaWat==Buildings.Templates.HeatingPlants.HotWater.Types.Distribution.Variable1And2 or
    typDisHeaWat==Buildings.Templates.HeatingPlants.HotWater.Types.Distribution.Variable1And2Distributed
    "Set to true if the plant has a fixed HW bypass"
    annotation(Evaluate=true, Dialog(group="Primary HW loop"));
  final parameter Boolean have_pumHeaWatSec=
    typDisHeaWat==Buildings.Templates.HeatingPlants.HotWater.Types.Distribution.Constant1Variable2 or
    typDisHeaWat==Buildings.Templates.HeatingPlants.HotWater.Types.Distribution.Variable1And2
    "Set to true if the plant includes secondary HW pumps"
    annotation(Evaluate=true, Dialog(group="Secondary HW loop"));

  parameter Integer nPumHeaWatPri(
    start=1,
    final min=1)=nUni
    "Number of primary HW pumps"
    annotation (Evaluate=true, Dialog(group="Primary HW loop",
    enable=typArrPumHeaWatPri==Buildings.Templates.Components.Types.PumpArrangement.Headered));
  final parameter Buildings.Templates.Components.Types.PumpArrangement typArrPumHeaWatPri
    "Type of primary HW pump arrangement"
    annotation (Evaluate=true, Dialog(group="Primary HW loop"));
  final parameter Boolean have_varPumHeaWatPri=
    if (typDisHeaWat==Buildings.Templates.HeatingPlants.HotWater.Types.Distribution.Constant1Only or
       typDisHeaWat==Buildings.Templates.HeatingPlants.HotWater.Types.Distribution.Constant1Variable2) and
       not have_varPumHeaWatPri_select then false
    else true
    "Set to true for variable speed primary HW pumps, false for constant speed pumps"
    annotation (Evaluate=true, Dialog(group="Primary HW loop"));
  final parameter Boolean have_varComPumHeaWatPri=true
    "Set to true for single common speed signal for primary HW pumps, false for dedicated signals"
    annotation (Evaluate=true, Dialog(group="Primary HW loop"));

  parameter Integer nPumHeaWatSec(
    start=1,
    final min=0)=if typDisHeaWat==Buildings.Templates.HeatingPlants.HotWater.Types.Distribution.Constant1Only
     or typDisHeaWat==Buildings.Templates.HeatingPlants.HotWater.Types.Distribution.Variable1Only then 0
    else nUni
    "Number of secondary HW pumps"
    annotation (Evaluate=true, Dialog(group="Secondary HW loop",
    enable=typDisHeaWat==Buildings.Templates.HeatingPlants.HotWater.Types.Distribution.Constant1Variable2
     or typDisHeaWat==Buildings.Templates.HeatingPlants.HotWater.Types.Distribution.Variable1And2
     or typDisHeaWat==Buildings.Templates.HeatingPlants.HotWater.Types.Distribution.Variable1And2Distributed));
  parameter Integer nLooHeaWatSec=1
    "Number of secondary HW loops for distributed secondary distribution"
    annotation (Evaluate=true, Dialog(group="Secondary HW loop",
    enable=typDisHeaWat==Buildings.Templates.HeatingPlants.HotWater.Types.Distribution.Variable1And2Distributed));

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

  // Following parameters to be assigned by derived classes.
  parameter Buildings.Templates.Components.Types.Valve typValHeaWatChiIso
    "Type of chiller HW isolation valve"
    annotation (Evaluate=true, Dialog(group="Chillers"));
  parameter Buildings.Templates.Components.Types.Valve typValConWatChiIso
    "Type of chiller CW isolation valve"
    annotation (Evaluate=true, Dialog(group="Chillers"));
  parameter Buildings.Templates.Components.Types.Valve typValCooInlIso
    "Cooler inlet isolation valve"
    annotation (Evaluate=true, Dialog(group="Coolers"));
  parameter Buildings.Templates.Components.Types.Valve typValCooOutIso
    "Cooler outlet isolation valve"
    annotation (Evaluate=true, Dialog(group="Coolers"));

  parameter Buildings.Templates.HeatingPlants.HotWater.Data.ChilledWaterPlant dat(
    typChi=typChi,
    nUni=nUni,
    nPumHeaWatPri=nPumHeaWatPri,
    nPumConWat=nPumConWat,
    typDisHeaWat=typDisHeaWat,
    nPumHeaWatSec=nPumHeaWatSec,
    typCoo=typCoo,
    nCoo=nCoo,
    have_varPumConWat=have_varPumConWat,
    typEco=typEco,
    typCtl=typCtl,
    rhoHeaWat_default=rhoHeaWat_default,
    rhoConWat_default=rhoCon_default)
    "Design and operating parameters";

  final parameter Modelica.Units.SI.MassFlowRate mHeaWatPri_flow_nominal=
    sum(dat.PumHeaWatPri.m_flow_nominal)
    "Primary HW mass flow rate (total)";
  final parameter Modelica.Units.SI.MassFlowRate mHeaWat_flow_nominal=
    if typDisHeaWat==Buildings.Templates.HeatingPlants.HotWater.Types.Distribution.Constant1Variable2 or
      typDisHeaWat==Buildings.Templates.HeatingPlants.HotWater.Types.Distribution.Variable1And2
      then sum(dat.pumHeaWatSec.m_flow_nominal)
    elseif typDisHeaWat==Buildings.Templates.HeatingPlants.HotWater.Types.Distribution.Variable1And2Distributed
      then sum(dat.ctl.VHeaWatSec_flow_nominal) * rhoHeaWat_default
    else mHeaWatPri_flow_nominal
    "HW mass flow rate (total, distributed to consumers)";
  final parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal=
    if typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled then
      sum(dat.chi.mConWatChi_flow_nominal)
    elseif typChi==Buildings.Templates.Components.Types.Chiller.AirCooled then
      sum(dat.chi.mConAirChi_flow_nominal)
    else 0
    "Condenser cooling fluid mass flow rate (total)";
  final parameter Modelica.Units.SI.HeatFlowRate cap_nominal=
    sum(dat.chi.capChi_nominal)
    "Cooling capacity (total)";
  final parameter Modelica.Units.SI.Temperature THeaWatSup_nominal=
    min(dat.chi.THeaWatChiSup_nominal)
    "Minimum HW supply temperature";

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
  Buildings.BoundaryConditions.WeatherData.Bus busWea
    "Weather data bus"
    annotation (Placement(transformation(
      extent={{-20,20},{20,-20}},
      rotation=180,
      origin={0,280}), iconTransformation(
        extent={{-20,20},{20,-20}},
        rotation=180,
        origin={0,200})));
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
  if typArrPumHeaWatPri == Buildings.Templates.Components.Types.PumpArrangement.Dedicated then
    assert(nPumHeaWatPri==nUni,
      "In " + getInstanceName() + ": " +
      "In case of dedicated pumps, the number of primary HW pumps (=" +
      String(nPumHeaWatPri) + ") must be equal to the number of chillers (=" +
      String(nUni) + ").");
  end if;
  if typChi == Buildings.Templates.Components.Types.Chiller.WaterCooled and
      typArrPumConWat == Buildings.Templates.Components.Types.PumpArrangement.Dedicated then
    assert(nPumConWat==nUni,
      "In " + getInstanceName() + ": " +
      "In case of dedicated pumps, the number of CW pumps (=" +
      String(nPumConWat) + ") must be equal to the number of chillers (=" +
      String(nUni) + ").");
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
end PartialHotWaterPlant;
