within Buildings.Templates.HeatingPlants.HotWater.Interfaces;
partial model PartialBoilerPlant
  "Interface class for HW boiler plant"
  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "HW medium";

  parameter Buildings.Templates.HeatingPlants.HotWater.Types.Boiler typ
    "Type of boilers"
    annotation (Evaluate=true, Dialog(group="Boilers"));
  parameter Buildings.Templates.Components.Types.BoilerHotWaterModel typMod=
    Buildings.Templates.Components.Types.BoilerHotWaterModel.Polynomial
    "Type of boiler model"
    annotation (Evaluate=true, Dialog(group="Boilers"));

  final parameter Boolean have_boiCon =
    typ==Buildings.Templates.HeatingPlants.HotWater.Types.Boiler.Condensing
    or typ==Buildings.Templates.HeatingPlants.HotWater.Types.Boiler.Hybrid
    "Set to true if the plant includes condensing boilers"
    annotation (Evaluate=true);
  final parameter Boolean have_boiNon=
    typ==Buildings.Templates.HeatingPlants.HotWater.Types.Boiler.NonCondensing
    or typ==Buildings.Templates.HeatingPlants.HotWater.Types.Boiler.Hybrid
    "Set to true if the plant includes non-condensing boilers"
    annotation (Evaluate=true);

  parameter Integer nBoiCon_select(start=0)
    "Number of condensing boilers"
    annotation (Evaluate=true, Dialog(group="Boilers",
    enable=have_boiCon));
  parameter Integer nBoiNon_select(start=0)
    "Number of non-condensing boilers"
    annotation (Evaluate=true, Dialog(group="Boilers",
    enable=have_boiNon));
  final parameter Integer nBoiCon = if have_boiCon then nBoiCon_select else 0
    "Number of condensing boilers"
    annotation (Evaluate=true, Dialog(group="Boilers"));
  final parameter Integer nBoiNon = if have_boiNon then nBoiNon_select else 0
    "Number of non-condensing boilers"
    annotation (Evaluate=true, Dialog(group="Boilers"));

  parameter Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary typPumHeaWatPriCon(
    start=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.Variable)
    "Type of primary HW pumps"
    annotation (Evaluate=true, Dialog(group="Primary HW loop - Condensing boilers",
    enable=have_boiCon));
  parameter Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary typPumHeaWatPriNon(
    start=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.Variable)
    "Type of primary HW pumps"
    annotation (Evaluate=true, Dialog(group="Primary HW loop - Non-condensing boilers",
    enable=have_boiNon));

  final parameter Boolean have_bypHeaWatFixCon=
    if typ==Buildings.Templates.HeatingPlants.HotWater.Types.Boiler.Condensing then
    typPumHeaWatSec <> Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None
    else true
    "Set to true if the condensing boiler group has a fixed HW bypass"
    annotation(Evaluate=true, Dialog(group="Primary HW loop - Condensing boilers"));
  final parameter Boolean have_bypHeaWatFixNon=
    if typ==Buildings.Templates.HeatingPlants.HotWater.Types.Boiler.NonCondensing then
    typPumHeaWatSec <> Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None
    else true
    "Set to true if the non-condensing boiler group has a fixed HW bypass"
    annotation(Evaluate=true, Dialog(group="Primary HW loop - Non-condensing boilers"));
  // FIXME: Add condition for boilers with non-zero minimum flow.
  final parameter Boolean have_valHeaWatMinBypCon=
    typ==Buildings.Templates.HeatingPlants.HotWater.Types.Boiler.Condensing and
    have_varPumHeaWatPriCon and
    typPumHeaWatSec==Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None
    "Set to true if the condensing boiler group has a HW minimum flow bypass valve"
    annotation(Evaluate=true, Dialog(group="Primary HW loop - Condensing boilers"));
  // FIXME: Add condition for boilers with non-zero minimum flow.
  final parameter Boolean have_valHeaWatMinBypNon=
    typ==Buildings.Templates.HeatingPlants.HotWater.Types.Boiler.NonCondensing and
    have_varPumHeaWatPriNon and
    typPumHeaWatSec==Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None
    "Set to true if the non-condensing boiler group has a HW minimum flow bypass valve"
    annotation(Evaluate=true, Dialog(group="Primary HW loop - Non-condensing boilers"));

  parameter Integer nPumHeaWatPriCon_select(
    start=0,
    final min=0)=nBoiCon
    "Number of primary HW pumps"
    annotation (Evaluate=true, Dialog(group="Primary HW loop - Condensing boilers",
    enable=have_boiCon and
    typArrPumHeaWatPriCon==Buildings.Templates.Components.Types.PumpArrangement.Headered));
  final parameter Integer nPumHeaWatPriCon=
    if have_boiCon then (
      if typArrPumHeaWatPriCon==Buildings.Templates.Components.Types.PumpArrangement.Headered
        then nPumHeaWatPriCon_select
      else nBoiCon)
    else 0
    "Number of primary HW pumps"
    annotation (Evaluate=true, Dialog(group="Primary HW loop - Condensing boilers"));
  parameter Buildings.Templates.Components.Types.PumpArrangement typArrPumHeaWatPriCon_select(
    start=Buildings.Templates.Components.Types.PumpArrangement.Headered)
    "Type of primary HW pump arrangement"
    annotation (Evaluate=true, Dialog(group="Primary HW loop - Condensing boilers",
    enable=have_boiCon and
    typPumHeaWatPriCon<>Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.FactoryVariable and
    typPumHeaWatPriCon<>Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.FactoryConstant));
  final parameter Buildings.Templates.Components.Types.PumpArrangement typArrPumHeaWatPriCon=
    if have_boiCon and
    typPumHeaWatPriCon<>Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.FactoryVariable and
    typPumHeaWatPriCon<>Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.FactoryConstant
    then typArrPumHeaWatPriCon_select else
    Buildings.Templates.Components.Types.PumpArrangement.Dedicated
    "Type of primary HW pump arrangement"
    annotation (Evaluate=true, Dialog(group="Primary HW loop - Condensing boilers"));
  final parameter Boolean have_varPumHeaWatPriCon=
    typPumHeaWatPriCon==Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.FactoryVariable or
    typPumHeaWatPriCon==Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.Variable
    "Set to true for variable speed primary HW pumps"
    annotation (Evaluate=true, Dialog(group="Primary HW loop - Condensing boilers"));

  parameter Integer nPumHeaWatPriNon_select(
    start=0,
    final min=0)=nBoiNon
    "Number of primary HW pumps"
    annotation (Evaluate=true, Dialog(group="Primary HW loop - Non-condensing boilers",
    enable=have_boiNon and
    typArrPumHeaWatPriNon==Buildings.Templates.Components.Types.PumpArrangement.Headered));
  final parameter Integer nPumHeaWatPriNon=
    if have_boiNon then (
      if typArrPumHeaWatPriNon==Buildings.Templates.Components.Types.PumpArrangement.Headered
        then nPumHeaWatPriNon_select
      else nBoiNon)
    else 0
    "Number of primary HW pumps"
    annotation (Evaluate=true, Dialog(group="Primary HW loop - Non-condensing boilers",
    enable=have_boiNon and
    typArrPumHeaWatPriNon==Buildings.Templates.Components.Types.PumpArrangement.Headered));
  parameter Buildings.Templates.Components.Types.PumpArrangement typArrPumHeaWatPriNon_select(
    start=Buildings.Templates.Components.Types.PumpArrangement.Headered)
    "Type of primary HW pump arrangement"
    annotation (Evaluate=true, Dialog(group="Primary HW loop - Non-condensing boilers",
    enable=have_boiNon and
    typPumHeaWatPriNon<>Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.FactoryVariable and
    typPumHeaWatPriNon<>Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.FactoryConstant));
  final parameter Buildings.Templates.Components.Types.PumpArrangement typArrPumHeaWatPriNon=
    if have_boiNon and
    typPumHeaWatPriNon<>Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.FactoryVariable and
    typPumHeaWatPriNon<>Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.FactoryConstant then
    typArrPumHeaWatPriNon_select else Buildings.Templates.Components.Types.PumpArrangement.Dedicated
    "Type of primary HW pump arrangement"
    annotation (Evaluate=true, Dialog(group="Primary HW loop - Non-condensing boilers"));
  final parameter Boolean have_varPumHeaWatPriNon=
    typPumHeaWatPriNon==Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.FactoryVariable or
    typPumHeaWatPriNon==Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.Variable
    "Set to true for variable speed primary HW pumps"
    annotation (Evaluate=true, Dialog(group="Primary HW loop - Non-condensing boilers"));

  parameter Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary typPumHeaWatSec1_select(
    start=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None)
    "Type of secondary HW pumps"
    annotation (Evaluate=true, Dialog(group="Secondary HW loop", enable=
    typ<>Buildings.Templates.HeatingPlants.HotWater.Types.Boiler.Hybrid));
  parameter Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary typPumHeaWatSec2_select(
    start=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.Centralized)
    "Type of secondary HW pumps"
    annotation (Evaluate=true, Dialog(group="Secondary HW loop", enable=
    typ==Buildings.Templates.HeatingPlants.HotWater.Types.Boiler.Hybrid),
    choices(
    choice=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.Centralized
      "Variable secondary centralized",
    choice=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.Distributed
      "Variable secondary distributed"));
  final parameter Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary typPumHeaWatSec=
    if typ<>Buildings.Templates.HeatingPlants.HotWater.Types.Boiler.Hybrid then typPumHeaWatSec1_select
    else typPumHeaWatSec2_select
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
    annotation (Evaluate=true, Dialog(group="Secondary HW loop", enable=
    typPumHeaWatSec==Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.Distributed));

  parameter Buildings.Templates.HeatingPlants.HotWater.Types.Controller typCtl
    "Type of controller"
    annotation (Evaluate=true, Dialog(group="Controls"));
  parameter Integer nAirHan
    "Number of air handling units served by the plant"
    annotation(Evaluate=true, Dialog(group="Controls"));
  parameter Integer nEquZon
    "Number of terminal units (zone equipment) served by the plant"
    annotation(Evaluate=true, Dialog(group="Controls"));

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
    final have_valHeaWatMinBypCon=have_valHeaWatMinBypCon,
    final have_valHeaWatMinBypNon=have_valHeaWatMinBypNon,
    final typArrPumHeaWatPriCon=typArrPumHeaWatPriCon,
    final typArrPumHeaWatPriNon=typArrPumHeaWatPriNon,
    final have_varPumHeaWatPriCon=have_varPumHeaWatPriCon,
    final have_varPumHeaWatPriNon=have_varPumHeaWatPriNon,
    final typCtl=typCtl,
    final rho_default=rho_default)
    "Design and operating parameters"
    annotation (Placement(transformation(extent={{-280,240},{-260,260}})));

  final parameter Modelica.Units.SI.MassFlowRate mHeaWatPriCon_flow_nominal=
    sum(dat.pumHeaWatPriCon.m_flow_nominal)
    "Primary HW mass flow rate - Condensing boilers";
  final parameter Modelica.Units.SI.MassFlowRate mHeaWatPriNon_flow_nominal=
    sum(dat.pumHeaWatPriNon.m_flow_nominal)
    "Primary HW mass flow rate - Non-condensing boilers";
  // FIXME: How to assign HW flow in case of distributed secondary pumps?
  final parameter Modelica.Units.SI.MassFlowRate mHeaWat_flow_nominal=
    if typPumHeaWatSec==Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None
      then (if have_boiCon then mHeaWatPriCon_flow_nominal else mHeaWatPriNon_flow_nominal)
    elseif typPumHeaWatSec==Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.Centralized
      then sum(dat.pumHeaWatSec.m_flow_nominal)
    else max(mHeaWatPriCon_flow_nominal, mHeaWatPriNon_flow_nominal)
    "HW mass flow rate (total, distributed to consumers)";
  final parameter Modelica.Units.SI.HeatFlowRate cap_nominal=
    (if have_boiCon then sum(dat.boiCon.capBoi_nominal) else 0) +
    (if have_boiNon then sum(dat.boiNon.capBoi_nominal) else 0)
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
        extent={{-200,198},{202,-202}},
        lineColor={0,0,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Line(
          points={{-60,-60},{50,-60},{50,0}},
          color={28,108,200},
          thickness=5),
        Ellipse(
          extent={{-40,-40},{0,-80}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,100,199}),
        Line(
          points={{-60,100},{50,100},{50,0},{200,0}},
          color={28,108,200},
          thickness=5),
        Rectangle(
          extent={{-180,-40},{-60,-120}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-149,-214},{151,-254}},
          textColor={0,0,255},
          textString="%name"),
        Polygon(
          points={{-121,-90},{-133,-108},{-107,-108},{-121,-90}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-180,120},{-60,40}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-121,70},{-133,52},{-107,52},{-121,70}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{130,20},{170,-20}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,100,199},
          startAngle=0,
          endAngle=360,
          visible=typPumHeaWatSec == Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.Centralized),
        Polygon(
          points={{150,20},{150,-20},{170,0},{150,20}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255},
          visible=typPumHeaWatSec == Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.Centralized),

        Line(
          points={{200,-100},{-60,-100}},
          color={28,108,200},
          pattern=LinePattern.Dash,
          thickness=5),
        Ellipse(
          extent={{-40,120},{0,80}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,100,199}),
        Polygon(
          points={{-20,120},{-20,80},{0,100},{-20,120}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255}),
        Line(
          points={{-60,60},{20,60},{20,-98}},
          color={28,108,200},
          thickness=5,
          pattern=LinePattern.Dash),
        Line(
          points={{102,-2},{102,-102}},
          color={28,108,200},
          thickness=5),
        Polygon(
          points={{-20,-40},{-20,-80},{0,-60},{-20,-40}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255})}),
   Diagram(coordinateSystem(
      preserveAspectRatio=false,
      extent={{-300,-280},{300,280}})),
    Documentation(revisions="<html>
<ul>
<li>
April 28, 2023, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This partial class provides a standard interface for hot water boiler
plant models.
</p>
</html>"));
end PartialBoilerPlant;
