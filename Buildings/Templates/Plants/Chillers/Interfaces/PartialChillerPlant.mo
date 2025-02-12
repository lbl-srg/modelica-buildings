within Buildings.Templates.Plants.Chillers.Interfaces;
partial model PartialChillerPlant "Interface class for chiller plant"
  replaceable package MediumChiWat=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CHW medium";
  replaceable package MediumCon=Modelica.Media.Interfaces.PartialMedium
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium model for condenser cooling fluid";

  inner parameter Boolean viewDiagramAll=false
    "Set to true to view all component icons and connection lines in diagram"
    annotation (Dialog(tab="Graphics"));

  parameter Buildings.Templates.Components.Types.Chiller typChi
    "Type of chiller"
    annotation (Evaluate=true, Dialog(group="Chillers"));
  parameter Integer nChi(
    start=1,
    final min=1)
    "Number of chillers"
    annotation (Evaluate=true, Dialog(group="Chillers"));
  // The following parameter stores the user selection.
  parameter Buildings.Templates.Plants.Chillers.Types.ChillerArrangement typArrChi_select(
    start=Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel)
    "Type of chiller arrangement"
    annotation (Evaluate=true, Dialog(group="Chillers", enable=nChi>1));
  // The following parameter stores the actual configuration setting.
  final parameter Buildings.Templates.Plants.Chillers.Types.ChillerArrangement typArrChi=
    if nChi==1 then Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel
    else typArrChi_select
    "Type of chiller arrangement"
    annotation (Evaluate=true, Dialog(group="Chillers"));

  parameter Buildings.Templates.Plants.Chillers.Types.Distribution typDisChiWat
    "Type of CHW distribution system"
    annotation (Evaluate=true, Dialog(group="Primary CHW loop"));

  final parameter Boolean have_bypChiWatFix=
    typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Variable2 or
    typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2 or
    typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2Distributed
    "Set to true if the plant has a fixed CHW bypass"
    annotation(Evaluate=true, Dialog(group="Primary CHW loop"));
  final parameter Boolean have_pumChiWatSec=
    typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Variable2 or
    typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2
    "Set to true if the plant includes secondary CHW pumps"
    annotation(Evaluate=true, Dialog(group="Secondary CHW loop"));

  parameter Integer nPumChiWatPri(
    start=1,
    final min=1)=nChi
    "Number of primary CHW pumps"
    annotation (Evaluate=true, Dialog(group="Primary CHW loop",
    enable=typArrPumChiWatPri == Buildings.Templates.Components.Types.PumpArrangement.Headered));
  // The following parameter stores the user selection.
  parameter Buildings.Templates.Components.Types.PumpArrangement
    typArrPumChiWatPri_select(start=Buildings.Templates.Components.Types.PumpArrangement.Headered)
    "Type of primary CHW pump arrangement"
    annotation (Evaluate=true, Dialog(group="Primary CHW loop",
    enable=typEco == Buildings.Templates.Plants.Chillers.Types.Economizer.None
      and typArrChi == Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel));
  // The following parameter stores the actual configuration setting.
  final parameter Buildings.Templates.Components.Types.PumpArrangement
    typArrPumChiWatPri=if typEco <> Buildings.Templates.Plants.Chillers.Types.Economizer.None
       or typArrChi == Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series
       then Buildings.Templates.Components.Types.PumpArrangement.Headered else
      typArrPumChiWatPri_select "Type of primary CHW pump arrangement"
    annotation (Evaluate=true, Dialog(group="Primary CHW loop"));
  // The following parameter stores the user selection.
  // This parameter is only needed to specify variable speed pumps operated at a constant speed.
  parameter Boolean have_pumChiWatPriVar_select=false
    "Set to true for variable speed primary CHW pumps operated at one or more fixed speeds, false for constant speed pumps"
    annotation (Evaluate=true, Dialog(group="Primary CHW loop", enable=
    typDisChiWat == Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Only
    or typDisChiWat == Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Variable2));
  // The following parameter stores the actual configuration setting.
  final parameter Boolean have_pumChiWatPriVar=
    if (typDisChiWat == Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Only
      or typDisChiWat == Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Variable2)
      then have_pumChiWatPriVar_select else true
    "Set to true for variable speed primary CHW pumps, false for constant speed pumps"
    annotation (Evaluate=true, Dialog(group="Primary CHW loop"));
  final parameter Boolean have_pumChiWatPriVarCom=true
    "Set to true for single common speed signal for primary CHW pumps, false for dedicated signals"
    annotation (Evaluate=true, Dialog(group="Primary CHW loop"));

  parameter Integer nPumChiWatSec(
    start=1,
    final min=0)=if typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Only
     or typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1Only then 0
    else nChi
    "Number of secondary CHW pumps"
    annotation (Evaluate=true, Dialog(group="Secondary CHW loop",
    enable=typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Variable2
     or typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2
     or typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2Distributed));
  parameter Integer nLooChiWatSec=1
    "Number of secondary CHW loops for distributed secondary distribution"
    annotation (Evaluate=true, Dialog(group="Secondary CHW loop",
    enable=typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2Distributed));

  parameter Buildings.Templates.Components.Types.Cooler typCoo(
    start=Buildings.Templates.Components.Types.Cooler.CoolingTowerOpen)
    "Condenser water cooling equipment"
    annotation(Evaluate=true, Dialog(group="Coolers",
    enable=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Integer nCoo(
    start=if typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled
    then 1 else 0,
    final min=if typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled
    then 1 else 0)=nChi
    "Number of cooler units"
    annotation (Evaluate=true, Dialog(group="Coolers",
    enable=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));

  parameter Integer nPumConWat(
    start=if typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled
    then 1 else 0,
    final min=if typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled
    then 1 else 0)=nChi
    "Number of CW pumps"
    annotation (Evaluate=true, Dialog(group="CW loop",
    enable=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled
           and typArrPumConWat == Buildings.Templates.Components.Types.PumpArrangement.Headered));
  // The following parameter stores the user selection.
  parameter Buildings.Templates.Components.Types.PumpArrangement
    typArrPumConWat_select(start=Buildings.Templates.Components.Types.PumpArrangement.Headered)
    "Type of CW pump arrangement"
    annotation (Evaluate=true, Dialog(group="CW loop",
    enable=typChi == Buildings.Templates.Components.Types.Chiller.WaterCooled
       and typEco == Buildings.Templates.Plants.Chillers.Types.Economizer.None));
  // The following parameter stores the actual configuration setting.
  final parameter Buildings.Templates.Components.Types.PumpArrangement
    typArrPumConWat=
      if typChi==Buildings.Templates.Components.Types.Chiller.AirCooled then
        Buildings.Templates.Components.Types.PumpArrangement.Dedicated
      elseif typEco<>Buildings.Templates.Plants.Chillers.Types.Economizer.None
        then Buildings.Templates.Components.Types.PumpArrangement.Headered else
      typArrPumConWat_select
    "Type of CW pump arrangement"
    annotation (Evaluate=true, Dialog(group="CW loop"));
  // The following parameter stores the user selection.
  parameter Boolean have_pumConWatVar_select=false
    "Set to true for variable speed CW pumps, false for constant speed pumps"
    annotation (Evaluate=true, Dialog(group="CW loop",
      enable=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled and
      typEco==Buildings.Templates.Plants.Chillers.Types.Economizer.None));
  // The following parameter stores the actual configuration setting.
  final parameter Boolean have_pumConWatVar=
    if typEco<>Buildings.Templates.Plants.Chillers.Types.Economizer.None
      then true
    else false
    "Set to true for variable speed CW pumps, false for constant speed pumps"
    annotation (Evaluate=true, Dialog(group="CW loop"));
  final parameter Boolean have_pumConWatVarCom=
    if typEco<>Buildings.Templates.Plants.Chillers.Types.Economizer.None
      then true
    elseif typArrPumConWat==Buildings.Templates.Components.Types.PumpArrangement.Dedicated
      then false
    else true
    "Set to true for single common speed signal for CW pumps, false for dedicated signals"
    annotation (Evaluate=true, Dialog(group="CW loop"));

  parameter Buildings.Templates.Plants.Chillers.Types.Economizer typEco(
    start=Buildings.Templates.Plants.Chillers.Types.Economizer.None)
    "Type of WSE"
    annotation (Evaluate=true, Dialog(group="Waterside economizer",
    enable=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));

  parameter Buildings.Templates.Plants.Chillers.Types.Controller typCtl
    "Type of controller"
    annotation (Evaluate=true, Dialog(group="Controls", enable=false));
  parameter Integer nAirHan(
    final min=0)=0
    "Number of air handling units served by the plant"
    annotation(Evaluate=true,
    Dialog(group="Controls",
    enable=typCtl == Buildings.Templates.Plants.Chillers.Types.Controller.G36));
  parameter Integer nEquZon(
    final min=0)=0
    "Number of terminal units (zone equipment) served by the plant"
    annotation(Evaluate=true,
    Dialog(group="Controls",
    enable=typCtl == Buildings.Templates.Plants.Chillers.Types.Controller.G36));

  // Following parameters to be assigned by derived classes.
  parameter Buildings.Templates.Components.Types.Valve typValChiWatChiIso
    "Type of chiller CHW isolation valve"
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

  parameter Buildings.Templates.Plants.Chillers.Configuration.ChillerPlant cfg(
    final cpChiWat_default=cpChiWat_default,
    final cpCon_default=cpCon_default,
    final have_pumChiWatPriVar=have_pumChiWatPriVar,
    final have_pumChiWatPriVarCom=have_pumChiWatPriVarCom,
    final have_pumChiWatSec=have_pumChiWatSec,
    final have_pumConWatVar=have_pumConWatVar,
    final have_pumConWatVarCom=have_pumConWatVarCom,
    final nAirHan=nAirHan,
    final nChi=nChi,
    final nCoo=nCoo,
    final nEquZon=nEquZon,
    final nLooChiWatSec=nLooChiWatSec,
    final nPumChiWatPri=nPumChiWatPri,
    final nPumChiWatSec=nPumChiWatSec,
    final nPumConWat=nPumConWat,
    final rhoChiWat_default=rhoChiWat_default,
    final rhoCon_default=rhoCon_default,
    final typArrChi=typArrChi,
    final typArrPumChiWatPri=typArrPumChiWatPri,
    final typArrPumConWat=typArrPumConWat,
    final typChi=typChi,
    final typCoo=typCoo,
    final typCtl=typCtl,
    final typDisChiWat=typDisChiWat,
    final typEco=typEco,
    final typValChiWatChiIso=typValChiWatChiIso,
    final typValConWatChiIso=typValConWatChiIso,
    final typValCooInlIso=typValCooInlIso,
    final typValCooOutIso=typValCooOutIso)
    "Configurationj parameters";
  parameter Buildings.Templates.Plants.Chillers.Data.ChillerPlant dat
    "Design and operating parameters";

  final parameter Modelica.Units.SI.MassFlowRate mChiWatPri_flow_nominal=
    sum(dat.pumChiWatPri.m_flow_nominal)
    "Primary CHW mass flow rate (total)";
  final parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_nominal=
    if typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Variable2 or
      typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2
      then sum(dat.pumChiWatSec.m_flow_nominal)
    elseif typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2Distributed
      then sum(dat.ctl.VChiWatSec_flow_nominal) * rhoChiWat_default
    else mChiWatPri_flow_nominal
    "CHW mass flow rate (total, distributed to consumers)";
  final parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal=
    if typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled or
      typChi==Buildings.Templates.Components.Types.Chiller.AirCooled then
      sum(dat.chi.mConChi_flow_nominal)
    else 0
    "Condenser cooling fluid mass flow rate (total)";
  final parameter Modelica.Units.SI.HeatFlowRate cap_nominal=
    sum(abs(dat.chi.capChi_nominal))
    "Cooling capacity (total)";
  final parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal(final max=0)=
    -cap_nominal
    "Design cooling heat flow rate (total)";
  final parameter Modelica.Units.SI.Temperature TChiWatSup_nominal=
    min(dat.chi.TChiWatSupChi_nominal)
    "Minimum CHW supply temperature";
  final parameter Modelica.Units.SI.Temperature TChiWatRet_nominal=
    TChiWatSup_nominal - Q_flow_nominal / cpChiWat_default /
    mChiWat_flow_nominal
    "CHW return temperature - Each heat pump"
    annotation (Dialog(group="Nominal condition"));

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
  parameter Boolean linearized = false
    "= true, use linear relation between m_flow and dp for all valves"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  final parameter MediumChiWat.Density rhoChiWat_default=
    MediumChiWat.density(staChiWat_default)
    "CHW default density";
  final parameter MediumChiWat.SpecificHeatCapacity cpChiWat_default=
    MediumChiWat.density(staChiWat_default)
    "CHW default specific heat capacity";
  final parameter MediumChiWat.ThermodynamicState staChiWat_default=
     MediumChiWat.setState_pTX(
       T=Buildings.Templates.Data.Defaults.TChiWatSup,
       p=MediumChiWat.p_default,
       X=MediumChiWat.X_default)
    "CHW default state";
  final parameter MediumCon.Density rhoCon_default=
    MediumCon.density(staCon_default)
    "Condenser cooling fluid default density";
  final parameter MediumCon.SpecificHeatCapacity cpCon_default=
    MediumCon.density(staCon_default)
    "Condenser cooling fluid default specific heat capacity";
  final parameter MediumCon.ThermodynamicState staCon_default=
     MediumCon.setState_pTX(
       T=Buildings.Templates.Data.Defaults.TConEnt_max,
       p=MediumCon.p_default,
       X=MediumCon.X_default)
    "Condenser cooling fluid default state";

  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare final package Medium = MediumChiWat,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumChiWat.h_default, nominal=MediumChiWat.h_default))
    "CHW return"
    annotation (Placement(transformation(extent={{290,-270},{310,-250}}),
        iconTransformation(extent={{192,-110},{212,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare final package Medium = MediumChiWat,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start = MediumChiWat.h_default, nominal = MediumChiWat.h_default))
    "CHW supply"
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
  Buildings.Templates.Plants.Chillers.Interfaces.Bus bus
    "CHW plant control bus" annotation (Placement(transformation(
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

  Modelica.Units.SI.MassFlowRate m_flow(start=_m_flow_start)=port_a.m_flow
    "Mass flow rate from port_a to port_b (m_flow > 0 is design flow direction)";

  Modelica.Units.SI.PressureDifference dp(
    start=_dp_start,
    displayUnit="Pa")=port_a.p - port_b.p
    "Pressure difference between port_a and port_b";

  MediumChiWat.ThermodynamicState sta_a=
    if allowFlowReversal then
      MediumChiWat.setState_phX(port_a.p,
                          noEvent(actualStream(port_a.h_outflow)),
                          noEvent(actualStream(port_a.Xi_outflow)))
    else
      MediumChiWat.setState_phX(port_a.p,
                          noEvent(inStream(port_a.h_outflow)),
                          noEvent(inStream(port_a.Xi_outflow)))
      if show_T "Medium properties in port_a";

  MediumChiWat.ThermodynamicState sta_b=
    if allowFlowReversal then
      MediumChiWat.setState_phX(port_b.p,
                          noEvent(actualStream(port_b.h_outflow)),
                          noEvent(actualStream(port_b.Xi_outflow)))
    else
      MediumChiWat.setState_phX(port_b.p,
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
  if typArrPumChiWatPri == Buildings.Templates.Components.Types.PumpArrangement.Dedicated then
    assert(nPumChiWatPri==nChi,
      "In " + getInstanceName() + ": " +
      "In case of dedicated pumps, the number of primary CHW pumps (=" +
      String(nPumChiWatPri) + ") must be equal to the number of chillers (=" +
      String(nChi) + ").");
  end if;
  if typChi == Buildings.Templates.Components.Types.Chiller.WaterCooled and
      typArrPumConWat == Buildings.Templates.Components.Types.PumpArrangement.Dedicated then
    assert(nPumConWat==nChi,
      "In " + getInstanceName() + ": " +
      "In case of dedicated pumps, the number of CW pumps (=" +
      String(nPumConWat) + ") must be equal to the number of chillers (=" +
      String(nChi) + ").");
  end if;

  annotation (
    defaultComponentName="plaChiWat",
    Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-200,-200},{200,200}}),
    graphics={
      Rectangle(
          extent={{-200,200},{200,-200}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-149,-214},{151,-254}},
          textColor={0,0,255},
          textString="%name"),
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
          visible=have_pumChiWatSec),
        Polygon(
          points={{150,19},{150,-19},{169,0},{150,19}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255},
          visible=have_pumChiWatSec),
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
          points={{-20,119},{-20,81},{-1,100},{-20,119}},
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
          points={{-20,-41},{-20,-79},{-1,-60},{-20,-41}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255}),
        Rectangle(
          extent={{-180,-20},{-60,-140}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-50,8},{50,-8}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-80,-78},
          rotation=90),
        Rectangle(
          extent={{-50,8},{50,-8}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-160,-78},
          rotation=90),
        Rectangle(
          extent={{-2,32},{2,-32}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-120,-108},
          rotation=-90),
        Ellipse(
          extent={{-136,-92},{-104,-124}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,8},{-10,-8},{10,-8},{0,8}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-128,-48},
          rotation=-90),
        Polygon(
          points={{-8,0},{8,10},{8,-10},{-8,0}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-112,-48},
          rotation=360),
        Rectangle(
          extent={{-2,8},{2,-8}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-96,-48},
          rotation=-90),
        Line(points={{-134,-100},{-112,-94}}, color={0,0,0}),
        Rectangle(
          extent={{-2,8},{2,-8}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-144,-48},
          rotation=-90),
        Line(points={{-134,-116},{-112,-122}}, color={0,0,0}),
        Rectangle(
          extent={{-180,140},{-60,20}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-50,8},{50,-8}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-80,82},
          rotation=90),
        Rectangle(
          extent={{-50,8},{50,-8}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-160,82},
          rotation=90),
        Rectangle(
          extent={{-2,32},{2,-32}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-120,52},
          rotation=-90),
        Ellipse(
          extent={{-136,68},{-104,36}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,8},{-10,-8},{10,-8},{0,8}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-128,112},
          rotation=-90),
        Polygon(
          points={{-8,0},{8,10},{8,-10},{-8,0}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-112,112},
          rotation=360),
        Rectangle(
          extent={{-2,8},{2,-8}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-96,112},
          rotation=-90),
        Line(points={{-134,60},{-112,66}}, color={0,0,0}),
        Rectangle(
          extent={{-2,8},{2,-8}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-144,112},
          rotation=-90),
        Line(points={{-134,44},{-112,38}}, color={0,0,0})}),
   Diagram(coordinateSystem(
      preserveAspectRatio=false,
      extent={{-300,-300},{300,300}})),
    Documentation(info="<html>
<p>
This partial class provides a standard interface for chilled water plant templates.
</p>
<p>
The following modeling assumptions and limitations are considered.
</p>
<ul>
<li>
The chillers are assumed to be of the same type as defined
by the enumeration
<a href=\"modelica://Buildings.Templates.Components.Types.Chiller\">
Buildings.Templates.Components.Types.Chiller</a>.
</li>
<li>
The number of installed chillers is supposed to be equal
to the number of chillers operating at design conditions.
The same holds true for CW and CHW pump groups.
</li>
<li>
Variable speed primary CHW pumps are controlled to the same speed,
whether they are in a dedicated or headered arrangement.
</li>
<li>
Variable speed CW pumps are controlled to different speeds
if they are in a dedicated arrangement.
Otherwise they are controlled to the same speed.
</li>
<li>
A plant with a WSE requires variable speed CW pumps that must be
in a headered arrangement.
</li>
<li>
To allow for a WSE, the plant must have water-cooled chillers.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
November 18, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialChillerPlant;
