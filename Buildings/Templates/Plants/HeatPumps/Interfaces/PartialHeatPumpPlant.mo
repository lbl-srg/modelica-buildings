within Buildings.Templates.Plants.HeatPumps.Interfaces;
partial model PartialHeatPumpPlant
  "Interface class for heat pump plant"
  replaceable package MediumSou=Modelica.Media.Interfaces.PartialMedium
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium model for source-side fluid"
    annotation (__ctrlFlow(enable=false));
  replaceable package MediumHeaWat=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "HW medium"
    annotation (__ctrlFlow(enable=false));
  replaceable package MediumHotWat=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "DHW medium"
    annotation (__ctrlFlow(enable=false));
  replaceable package MediumChiWat=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CHW medium"
    annotation (__ctrlFlow(enable=false));

  parameter Buildings.Templates.Plants.HeatPumps.Types.HeatPump typ
    "Type of heat pump"
    annotation (Evaluate=true, Dialog(group="Heat pumps"));
  parameter Integer nHeaPum(
    start=1,
    final min=1)
    "Number of heat pumps"
    annotation (Evaluate=true, Dialog(group="Heat pumps"));
  parameter Integer nHeaPumHotWat(
    final min=0,
    final max=nHeaPum)=0
    "Number of heat pumps that can provide DHW"
    annotation (Evaluate=true, Dialog(group="Heat pumps"));

  parameter Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary typPumHeaWatPri(
    start=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable)
    "Type of primary HW pumps"
    annotation (Evaluate=true, Dialog(group="Primary HW loop"));

  final parameter Boolean have_bypHeaWatFix=
    typPumHeaWatSec <> Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None
    "Set to true if the HW loop has a fixed bypass"
    annotation(Evaluate=true, Dialog(group="Primary HW loop"));
  final parameter Boolean have_valHeaWatMinByp=
    have_varPumHeaWatPri and
    typPumHeaWatSec==Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None
    "Set to true if the HW loop has a minimum flow bypass valve"
    annotation(Evaluate=true, Dialog(group="Primary HW loop"));

  parameter Integer nPumHeaWatPri_select(
    start=0,
    final min=0)=nHeaPum
    "Number of primary HW pumps"
    annotation (Evaluate=true, Dialog(group="Primary HW loop",
    enable=typArrPumHeaWatPri==Buildings.Templates.Components.Types.PumpArrangement.Headered));
  final parameter Integer nPumHeaWatPri=
    if typArrPumHeaWatPri==Buildings.Templates.Components.Types.PumpArrangement.Headered
      then nPumHeaWatPri_select
    else nHeaPum
    "Number of primary HW pumps"
    annotation (Evaluate=true, Dialog(group="Primary HW loop"));
  parameter Buildings.Templates.Components.Types.PumpArrangement typArrPumHeaWatPri_select(
    start=Buildings.Templates.Components.Types.PumpArrangement.Headered)
    "Type of primary HW pump arrangement"
    annotation (Evaluate=true, Dialog(group="Primary HW loop",
    enable= typPumHeaWatPri<>Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.FactoryVariable and
      typPumHeaWatPri<>Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.FactoryConstant));
  final parameter Buildings.Templates.Components.Types.PumpArrangement typArrPumHeaWatPri=
    if typPumHeaWatPriCon<>Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.FactoryVariable and
      typPumHeaWatPriCon<>Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.FactoryConstant
    then typArrPumHeaWatPri_select else
    Buildings.Templates.Components.Types.PumpArrangement.Dedicated
    "Type of primary HW pump arrangement"
    annotation (Evaluate=true, Dialog(group="Primary HW loop"));
  final parameter Boolean have_varPumHeaWatPri=
    typPumHeaWatPri==Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.FactoryVariable or
    typPumHeaWatPri==Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable
    "Set to true for variable speed primary HW pumps"
    annotation (Evaluate=true, Dialog(group="Primary HW loop"));

  parameter Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary typPumHeaWatSec(
    start=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None)
    "Type of secondary HW pumps"
    annotation (Evaluate=true, Dialog(group="Secondary HW loop"),
    choices(
    choice=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None
      "No secondary pumps (primary-only)",
    choice=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized
      "Variable secondary centralized"));
  final parameter Boolean have_pumHeaWatSec=
    typPumHeaWatSec==Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized
    "Set to true if the plant includes secondary HW pumps"
    annotation(Evaluate=true, Dialog(group="Secondary HW loop"));
  parameter Integer nPumHeaWatSec(
    start=1,
    final min=0)=if have_pumHeaWatSec then nHeaPum else 0
    "Number of secondary HW pumps"
    annotation (Evaluate=true, Dialog(group="Secondary HW loop", enable=have_pumHeaWatSec));

  parameter Buildings.Templates.Plants.HeatPumps.Types.Controller typCtl
    "Type of controller"
    annotation (Evaluate=true, Dialog(group="Controls"));
  parameter Integer nAirHan
    "Number of air handling units served by the plant"
    annotation(Evaluate=true, Dialog(group="Controls"));
  parameter Integer nEquZon
    "Number of terminal units (zone equipment) served by the plant"
    annotation(Evaluate=true, Dialog(group="Controls"));

  // See derived class for additional bindings of parameters not defined at top-level.
  parameter Buildings.Templates.Plants.HeatPumps.Data.HeatPumpPlant dat(
    final nHeaPum=nHeaPum,
    final typPumHeaWatSec=typPumHeaWatSec,
    final nPumHeaWatPri=nPumHeaWatPri,
    final nPumHeaWatSec=nPumHeaWatSec,
    final have_valHeaWatMinByp=have_valHeaWatMinByp,
    final typArrPumHeaWatPri=typArrPumHeaWatPri,
    final have_varPumHeaWatPri=have_varPumHeaWatPri,
    final typCtl=typCtl,
    final rho_default=rho_default)
    "Design and operating parameters"
    annotation (Placement(transformation(extent={{-280,240},{-260,260}})));

  final parameter Modelica.Units.SI.MassFlowRate mHeaWatPri_flow_nominal=
    sum(dat.pumHeaWatPri.m_flow_nominal)
    "Primary HW mass flow rate";
  final parameter Modelica.Units.SI.MassFlowRate mHeaWat_flow_nominal=
    if typPumHeaWatSec==Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None
      then mHeaWatPri_flow_nominal
    else sum(dat.pumHeaWatSec.m_flow_nominal)
    "HW mass flow rate (total, distributed to consumers)";
  final parameter Modelica.Units.SI.HeatFlowRate cap_nominal=
    sum(dat.heaPum.cap_nominal)
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
  Buildings.Templates.Plants.HeatPumps.Interfaces.Bus bus
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
  if typArrPumHeaWatPri==Buildings.Templates.Components.Types.PumpArrangement.Dedicated then
    assert(nPumHeaWatPri==nHeaPum,
      "In " + getInstanceName() + ": " +
      "In case of dedicated pumps, the number of primary HW pumps (=" +
      String(nPumHeaWatPri) + ") must be equal to the number of heat pumps (=" +
      String(nHeaPum) + ").");
  end if;

  annotation (
    defaultComponentName="plaHeaPum",
    Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-200,-200},{200,200}}),
    graphics={
      Rectangle(
          extent={{-200,200},{200,-200}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-60,-60},{50,-60},{50,0}},
          color={238,46,47},
          thickness=5),
        Ellipse(
          extent={{-40,-40},{0,-80}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,100,199}),
        Line(
          points={{-60,100},{50,100},{50,0},{200,0}},
          color={238,46,47},
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
          visible=typPumHeaWatSec == Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized),
        Polygon(
          points={{150,19},{150,-19},{169,0},{150,19}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255},
          visible=typPumHeaWatSec == Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized),
        Line(
          points={{200,-100},{-60,-100}},
          color={238,46,47},
          pattern=LinePattern.Dash,
          thickness=5),
        Ellipse(
          extent={{-40,120},{0,80}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,100,199}),
        Polygon(
          points={{-20,119},{-20,81},{-1,100},{-20,119}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255}),
        Line(
          points={{-60,60},{20,60},{20,-98}},
          color={238,46,47},
          thickness=5,
          pattern=LinePattern.Dash),
        Line(
          points={{102,-2},{102,-102}},
          color={238,46,47},
          thickness=5),
        Polygon(
          points={{-20,-41},{-20,-79},{-1,-60},{-20,-41}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255})}),
   Diagram(coordinateSystem(
      preserveAspectRatio=false,
      extent={{-300,-300},{300,300}})),
    Documentation(revisions="<html>
<ul>
<li>
FIXME, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This partial class provides a standard interface for heat pump
plant models.
</p>
</html>"));
end PartialHeatPumpPlant;
