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

  parameter Buildings.Templates.Components.Types.HeatPump typ
    "Type of heat pump"
    annotation (Evaluate=true, Dialog(group="Heat pumps"));

  parameter Buildings.Templates.Plants.HeatPumps.Configuration.HeatPumpPlant cfg(
    final typ=typ,
    final have_heaWat=have_heaWat,
    final have_hotWat=have_hotWat,
    final have_chiWat=have_chiWat,
    final nHeaPum=nHeaPum,
    final nPumHeaWatPri=nPumHeaWatPri,
    final nPumHeaWatSec=nPumHeaWatSec,
    final have_valHeaWatMinByp=have_valHeaWatMinByp,
    final typArrPumHeaWatPri=typArrPumHeaWatPri,
    final typPumHeaWatSec=typPumHeaWatSec,
    final typDisHeaWat=typDisHeaWat)
    "Configuration parameters"
    annotation(__ctrlFlow(enable=false));

  final parameter Boolean have_heaWat=true
    "Set to true if the plant provides HW"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_hotWat=false
    "Set to true if the plant provides DHW"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  // RFE: To be exposed when templates include optional CHW service.
  final parameter Boolean have_chiWat=false
    "Set to true if the plant provides CHW"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Integer nHeaPum(
    start=1,
    final min=1)
    "Total number of heat pumps"
    annotation (Evaluate=true, Dialog(group="Heat pumps"));
  parameter Integer nHeaPumHotWat(
    final min=0,
    final max=nHeaPum)=if have_hotWat then nHeaPum else 0
    "Number of heat pumps that can provide DHW"
    annotation (Evaluate=true, Dialog(group="Heat pumps", enable=have_hotWat));

  parameter Buildings.Templates.Plants.HeatPumps.Types.Distribution typDisHeaWat
    "Type of HW distribution system"
    annotation (Evaluate=true, Dialog(group="Primary HW loop"));

  final parameter Boolean have_bypHeaWatFix=
    typPumHeaWatSec <> Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None
    "Set to true if the HW loop has a fixed bypass"
    annotation(Evaluate=true, Dialog(group="Primary HW loop"));
  final parameter Boolean have_valHeaWatMinByp=
    typDisHeaWat==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only
    "Set to true if the HW loop has a minimum flow bypass valve"
    annotation(Evaluate=true, Dialog(group="Primary HW loop"));

  parameter Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary typPumHeaWatPri(
    start=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable)
    "Type of primary HW pumps"
    annotation (Evaluate=true, Dialog(group="Primary HW loop"));
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
    if typPumHeaWatPri<>Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.FactoryVariable and
      typPumHeaWatPri<>Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.FactoryConstant
    then typArrPumHeaWatPri_select else
    Buildings.Templates.Components.Types.PumpArrangement.Dedicated
    "Type of primary HW pump arrangement"
    annotation (Evaluate=true, Dialog(group="Primary HW loop"));

  // RFE: Currently, only centralized secondary HP pumps are supported for primary-secondary plants.
  final parameter Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary typPumHeaWatSec=
    if typDisHeaWat==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Variable2
     or typDisHeaWat==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1And2 then
     Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized
    else Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None
    "Type of secondary HW pumps"
    annotation (Evaluate=true, Dialog(group="Secondary HW loop"));
  parameter Integer nPumHeaWatSec(
    final min=0)=
    if typDisHeaWat==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only then 0
    else nHeaPum
    "Number of secondary CHW pumps"
    annotation (Evaluate=true, Dialog(group="Secondary CHW loop",
    enable=typDisHeaWat==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Variable2
     or typDisHeaWat==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1And2));

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
  parameter Buildings.Templates.Plants.HeatPumps.Data.HeatPumpPlant dat(cfg=cfg)
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
  final parameter Modelica.Units.SI.HeatFlowRate capHea_nominal=
    sum(abs(dat.heaPum.capHea_nominal))
    "Heating capacity - All units";
  final parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal=
    capHea_nominal
    "Heating heat flow rate - All units";
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

  final parameter MediumHeaWat.Density rhoHeaWat_default=
    MediumHeaWat.density(staHeaWat_default)
    "HW default density";
  final parameter MediumHeaWat.ThermodynamicState staHeaWat_default=
    MediumHeaWat.setState_pTX(
      T=Buildings.Templates.Data.Defaults.THeaWatSupLow,
      p=MediumHeaWat.p_default,
      X=MediumHeaWat.X_default)
    "HW default state";

  Modelica.Fluid.Interfaces.FluidPort_a port_aHeaWat(
    redeclare final package Medium = MediumHeaWat,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumHeaWat.h_default, nominal=MediumHeaWat.h_default))
    if have_heaWat
    "HW return"
    annotation (Placement(transformation(extent={{290,-50},{310,-30}}),
        iconTransformation(extent={{192,-110},{212,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bHeaWat(
    redeclare final package Medium = MediumHeaWat,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumHeaWat.h_default, nominal=MediumHeaWat.h_default))
    if have_heaWat
    "HW supply"
    annotation (Placement(transformation(extent={{290,30},{310,50}}),
        iconTransformation(extent={{192,-10},{212,10}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_aChiWat(
    redeclare final package Medium = MediumChiWat,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumChiWat.h_default, nominal=MediumChiWat.h_default))
    if have_chiWat
    "CHW return"
    annotation (Placement(transformation(extent={{290,-290},{310,-270}}),
        iconTransformation(extent={{192,-110},{212,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bChiWat(
    redeclare final package Medium = MediumChiWat,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumChiWat.h_default, nominal=MediumChiWat.h_default))
    if have_chiWat
    "CHW supply"
    annotation (Placement(transformation(extent={{290,-210},{310,-190}}),
        iconTransformation(extent={{192,-10},{212,10}})));

  Buildings.Templates.Plants.HeatPumps.Interfaces.Bus bus
    "Plant control bus" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-300,200}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-200,100})));
  Buildings.Templates.AirHandlersFans.Interfaces.Bus busAirHan[nAirHan]
    if nAirHan>0
    "Air handling unit control bus"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={300,240}), iconTransformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={200,140})));
  Buildings.Templates.ZoneEquipment.Interfaces.Bus busEquZon[nEquZon]
    if nEquZon>0
    "Terminal unit control bus"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={300,160}),
        iconTransformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={202,60})));
  BoundaryConditions.WeatherData.Bus busWea
    "Weather bus"
    annotation (Placement(transformation(extent={{-20,280},{20,320}}),
      iconTransformation(extent={{-792,-62},{-772,-42}})));
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
        Text(
          extent={{-149,-214},{151,-254}},
          textColor={0,0,255},
          textString="%name"),
        Ellipse(
          extent={{130,20},{170,-20}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,100,199},
          startAngle=0,
          endAngle=360,
          visible=typPumHeaWatSec<>Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None),
        Polygon(
          points={{150,19},{150,-19},{169,0},{150,19}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255},
          visible=typPumHeaWatSec<>Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None),
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
          fillColor={255,255,255}),
        Rectangle(
          extent={{-160,130},{-60,30}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-130,100},{-90,60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-122,96},{-126,68}}, color={0,0,0}),
        Line(points={{-98,96},{-94,68}}, color={0,0,0}),
        Rectangle(
          extent={{-160,-32},{-60,-132}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-130,-62},{-90,-102}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-122,-66},{-126,-94}}, color={0,0,0}),
        Line(points={{-98,-66},{-94,-94}}, color={0,0,0})}),
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
