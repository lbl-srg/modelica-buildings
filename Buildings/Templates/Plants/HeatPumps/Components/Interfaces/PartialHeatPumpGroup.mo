within Buildings.Templates.Plants.HeatPumps.Components.Interfaces;
model PartialHeatPumpGroup
  replaceable package MediumHeaWat=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "HW medium"
    annotation (__ctrlFlow(enable=false));
  /*
  MediumChiWat is for internal use only.
  It is the same as MediumHeaWat for reversible HP.
  Non-reversible HP that can be controlled to produce either HW or CHW
  shall be modeled with chiller components (as a chiller/heater).
  */
    final package MediumChiWat=MediumHeaWat
    "CHW medium";
  /*
  Derived classes representing AWHP shall use:
  redeclare final package MediumSou = MediumAir
  */
    replaceable package MediumSou=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Source-side medium"
    annotation (Dialog(enable=typ==Buildings.Templates.Components.Types.HeatPump.WaterToWater),
      __ctrlFlow(enable=false));
  replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium"
    annotation (Dialog(enable=typ==Buildings.Templates.Components.Types.HeatPump.AirToWater),
  __ctrlFlow(enable=false));
  parameter Integer nHp(
    final min=1)
    "Number of heat pumps"
    annotation (Evaluate=true,
    Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.HeatPump typ
    "Equipment type"
    annotation (Evaluate=true,
    Dialog(group="Configuration"));
  parameter Boolean is_rev
    "Set to true for reversible heat pumps, false for heating only"
    annotation (Evaluate=true,
    Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.HeatPumpModel typMod=Buildings.Templates.Components.Types.HeatPumpModel.ModularTableData2D
    "Type of heat pump model"
    annotation (Evaluate=true,
    Dialog(group="Configuration"),
    __ctrlFlow(enable=false));
  parameter Buildings.Templates.Plants.HeatPumps.Components.Data.HeatPumpGroup dat(
    nHp=nHp,
    typ=typ,
    is_rev=is_rev,
    typMod=typMod,
    cpHeaWat_default=cpHeaWat_default,
    cpSou_default=cpSou_default)
    "Design and operating parameters"
    annotation (Placement(transformation(extent={{170,170},{190,190}})),
    __ctrlFlow(enable=false));
  final parameter Buildings.Templates.Components.Data.HeatPump datHp[nHp](
    each final is_rev=is_rev,
    each final typ=typ,
    each final typMod=typMod,
    each final cpHeaWat_default=cpHeaWat_default,
    each final cpSou_default=cpSou_default,
    each final mHeaWat_flow_nominal=dat.mHeaWatHp_flow_nominal,
    each final mSouWwCoo_flow_nominal=dat.mSouWwCooHp_flow_nominal,
    each final TSouHea_nominal=dat.TSouHeaHp_nominal,
    each final mChiWat_flow_nominal=dat.mChiWatHp_flow_nominal,
    each final dpSouWwHea_nominal=dat.dpSouWwHeaHp_nominal,
    each final THeaWatSup_nominal=dat.THeaWatSupHp_nominal,
    each final dpHeaWat_nominal=dat.dpHeaWatHp_nominal,
    each final mSouWwHea_flow_nominal=dat.mSouWwHeaHp_flow_nominal,
    each final TSouCoo_nominal=dat.TSouCooHp_nominal,
    each final modHea=dat.modHeaHp,
    each final modCoo=dat.modCooHp,
    each final perFit=dat.perFitHp,
    each final capCoo_nominal=dat.capCooHp_nominal,
    each final TChiWatSup_nominal=dat.TChiWatSupHp_nominal,
    each final capHea_nominal=dat.capHeaHp_nominal)
    "Design and operating parameters - Each heat pump";
  final parameter Modelica.Units.SI.MassFlowRate mHeaWatHp_flow_nominal=dat.mHeaWatHp_flow_nominal
    "Design HW mass flow rate - Each heat pump";
  final parameter Modelica.Units.SI.HeatFlowRate capHeaHp_nominal=dat.capHeaHp_nominal
    "Design heating capacity - Each heat pump";
  final parameter Modelica.Units.SI.HeatFlowRate QHeaHp_flow_nominal=abs(capHeaHp_nominal)
    "Design heating heat flow rate - Each heat pump";
  final parameter Modelica.Units.SI.PressureDifference dpHeaWatHp_nominal=dat.dpHeaWatHp_nominal
    "Design HW pressure drop - Each heat pump";
  final parameter Modelica.Units.SI.Temperature THeaWatSupHp_nominal=dat.THeaWatSupHp_nominal
    "Design HW supply temperature - Each heat pump";
  final parameter Modelica.Units.SI.Temperature THeaWatRetHp_nominal=dat.THeaWatRetHp_nominal
    "Design HW return temperature - Each heat pump";
  final parameter Modelica.Units.SI.MassFlowRate mChiWatHp_flow_nominal=dat.mChiWatHp_flow_nominal
    "Design CHW mass flow rate - Each heat pump"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.PressureDifference dpChiWatHp_nominal=dat.dpChiWatHp_nominal
    "Design CHW pressure drop - Each heat pump";
  final parameter Modelica.Units.SI.HeatFlowRate capCooHp_nominal=dat.capCooHp_nominal
    "Design cooling capacity - Each heat pump";
  final parameter Modelica.Units.SI.HeatFlowRate QCooHp_flow_nominal=- abs(capCooHp_nominal)
    "Design cooling heat flow rate - Each heat pump";
  final parameter Modelica.Units.SI.Temperature TChiWatSupHp_nominal=dat.TChiWatSupHp_nominal
    "Design CHW supply temperature - Each heat pump";
  final parameter Modelica.Units.SI.Temperature TChiWatRetHp_nominal=dat.TChiWatRetHp_nominal
    "Design CHW return temperature - Each heat pump";
  final parameter Modelica.Units.SI.MassFlowRate mSouHeaHp_flow_nominal=dat.mSouHeaHp_flow_nominal
    "Design source fluid mass flow rate in heating mode - Each heat pump";
  final parameter Modelica.Units.SI.PressureDifference dpSouHeaHp_nominal=dat.dpSouHeaHp_nominal
    "Design source fluid pressure drop in heating mode - Each heat pump";
  final parameter Modelica.Units.SI.MassFlowRate mSouCooHp_flow_nominal=dat.mSouCooHp_flow_nominal
    "Design source fluid mass flow rate in cooling mode - Each heat pump";
  final parameter Modelica.Units.SI.PressureDifference dpSouCooHp_nominal=dat.dpSouCooHp_nominal
    "Designs source fluid pressure drop in cooling mode - Each heat pump";
  final parameter Modelica.Units.SI.Temperature TSouCooHp_nominal=dat.TSouCooHp_nominal
    "Design OAT or source fluid supply temperature (condenser entering) in cooling mode - Each heat pump";
  final parameter Modelica.Units.SI.Temperature TSouHeaHp_nominal=dat.TSouHeaHp_nominal
    "Design OAT or source fluid supply temperature (evaporator entering) in heating mode - Each heat pump";
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,
    Dialog(tab="Dynamics",group="Conservation equations"));
  parameter Boolean allowFlowReversal=true
    "Load side flow reversal: false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation (Dialog(tab="Assumptions"),
    Evaluate=true);
  parameter Boolean allowFlowReversalSou=true
    "Source side flow reversal: false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation (Dialog(tab="Assumptions",
      enable=Buildings.Templates.Components.Types.HeatPump.WaterToWater),
    Evaluate=true);
  parameter Boolean have_preDroChiHeaWat=true
    "Set to true for CHW/HW pressure drop computed by this model, false for external computation"
    annotation (Evaluate=true,
    Dialog(tab="Assumptions"));
  parameter Boolean have_preDroSou=true
    "Set to true for source fluid pressure drop computed by this model, false for external computation"
    annotation (Evaluate=true,
    Dialog(tab="Assumptions",
      enable=Buildings.Templates.Components.Types.HeatPump.WaterToWater));
  final parameter MediumHeaWat.SpecificHeatCapacity cpHeaWat_default=
    MediumHeaWat.specificHeatCapacityCp(staHeaWat_default)
    "HW default specific heat capacity";
  final parameter MediumHeaWat.ThermodynamicState staHeaWat_default=MediumHeaWat.setState_pTX(
    T=THeaWatSupHp_nominal,
    p=MediumHeaWat.p_default,
    X=MediumHeaWat.X_default)
    "HW default state";
  final parameter MediumChiWat.SpecificHeatCapacity cpChiWat_default=
    MediumChiWat.specificHeatCapacityCp(staChiWat_default)
    "CHW default specific heat capacity";
  final parameter MediumChiWat.ThermodynamicState staChiWat_default=MediumChiWat.setState_pTX(
    T=TChiWatSupHp_nominal,
    p=MediumChiWat.p_default,
    X=MediumChiWat.X_default)
    "CHW default state";
  final parameter MediumSou.SpecificHeatCapacity cpSou_default=MediumSou.specificHeatCapacityCp(staSou_default)
    "Source fluid default specific heat capacity";
  final parameter MediumSou.ThermodynamicState staSou_default=MediumSou.setState_pTX(
    T=TSouHeaHp_nominal,
    p=MediumSou.p_default,
    X=MediumSou.X_default)
    "Source fluid default state";
  Modelica.Fluid.Interfaces.FluidPorts_b ports_bChiHeaWat[nHp](
    redeclare each final package Medium=MediumHeaWat,
    each m_flow(
      max=if allowFlowReversal then + Modelica.Constants.inf else 0),
    each h_outflow(
      start=MediumHeaWat.h_default,
      nominal=MediumHeaWat.h_default))
    "CHW/HW supply"
    annotation (Placement(transformation(extent={{-10,-40},{10,40}},rotation=90,
      origin={-120,200}),
      iconTransformation(extent={{-10,-40},{10,40}},rotation=90,origin={-500,400})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aChiHeaWat[nHp](
    redeclare each final package Medium=MediumHeaWat,
    each m_flow(
      min=if allowFlowReversal then - Modelica.Constants.inf else 0),
    each h_outflow(
      start=MediumHeaWat.h_default,
      nominal=MediumHeaWat.h_default))
    "CHW/HW return"
    annotation (Placement(transformation(extent={{-10,-40},{10,40}},rotation=90,
      origin={120,200}),
      iconTransformation(extent={{-10,-40},{10,40}},rotation=90,origin={500,400})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_bSou[nHp](
    redeclare each final package Medium=MediumSou,
    each m_flow(
      max=if allowFlowReversalSou then + Modelica.Constants.inf else 0),
    each h_outflow(
      start=MediumSou.h_default,
      nominal=MediumSou.h_default))
    "Source fluid return (from heat pumps)"
    annotation (Placement(iconVisible=typ==Buildings.Templates.Components.Types.HeatPump.WaterToWater,
      transformation(extent={{-10,-40},{10,40}},rotation=90,origin={120,-200}),
      iconTransformation(extent={{-10,-40},{10,40}},rotation=90,origin={500,-398})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aSou[nHp](
    redeclare each final package Medium=MediumSou,
    each m_flow(
      min=if allowFlowReversalSou then - Modelica.Constants.inf else 0),
    each h_outflow(
      start=MediumSou.h_default,
      nominal=MediumSou.h_default))
    "Source fluid supply (to heat pumps)"
    annotation (Placement(iconVisible=typ==Buildings.Templates.Components.Types.HeatPump.WaterToWater,
      transformation(extent={{-10,-40},{10,40}},rotation=90,origin={-120,-200}),
      iconTransformation(extent={{-10,-40},{10,40}},rotation=90,origin={-500,-400})));
  Buildings.Templates.Plants.HeatPumps.Interfaces.Bus bus
    "Plant control bus"
    annotation (Placement(transformation(extent={{-20,180},{20,220}}),
      iconTransformation(extent={{-20,380},{20,420}})));
  Buildings.BoundaryConditions.WeatherData.Bus busWea
    if typ == Buildings.Templates.Components.Types.HeatPump.AirToWater
    "Weather bus"
    annotation (Placement(transformation(extent={{20,180},{60,220}}),
      iconTransformation(extent={{-220,380},{-180,420}})));
  // Diagnostics
  parameter Boolean show_T=false
    "= true, if actual temperature at port is computed"
    annotation (Dialog(tab="Advanced",group="Diagnostics"),HideResult=true);
  MediumHeaWat.ThermodynamicState sta_aChiHeaWat[nHp]=MediumHeaWat.setState_phX(ports_aChiHeaWat.p, noEvent(actualStream(ports_aChiHeaWat.h_outflow)), noEvent(actualStream(ports_aChiHeaWat.Xi_outflow)))
    if show_T
    "CHW/HW medium properties in port_aChiHeaWat";
  MediumHeaWat.ThermodynamicState sta_bChiHeaWat[nHp]=MediumHeaWat.setState_phX(ports_bChiHeaWat.p, noEvent(actualStream(ports_bChiHeaWat.h_outflow)), noEvent(actualStream(ports_bChiHeaWat.Xi_outflow)))
    if show_T
    "CHW/HW medium properties in port_bChiHeaWat";
  MediumSou.ThermodynamicState sta_aSou[nHp]=MediumSou.setState_phX(ports_aSou.p, noEvent(actualStream(ports_aSou.h_outflow)), noEvent(actualStream(ports_aSou.Xi_outflow)))
    if show_T
    "Source medium properties in port_aSou";
  MediumSou.ThermodynamicState sta_bSou[nHp]=MediumSou.setState_phX(ports_bSou.p, noEvent(actualStream(ports_bSou.h_outflow)), noEvent(actualStream(ports_bSou.Xi_outflow)))
    if show_T
    "Source medium properties in port_bSou";
protected
  Buildings.Templates.Components.Interfaces.Bus busHp[nHp]
    "Heat pump control bus"
    annotation (Placement(transformation(extent={{-20,140},{20,180}}),
      iconTransformation(extent={{-522,206},{-482,246}})));
equation
  connect(bus.hp, busHp)
    annotation (Line(points={{0,200},{0,200},{0,160}},color={255,204,51},thickness=0.5));
  annotation (
    Diagram(
      coordinateSystem(
        extent={{-200,-200},{200,200}})),
    Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-1000,-400},{1000,400}})));
end PartialHeatPumpGroup;
