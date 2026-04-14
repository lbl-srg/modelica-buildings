within Buildings.Templates.Plants.HeatPumps.Components.Interfaces;
model PartialHeatPumpGroup
  "Interface for heat pump group"
  replaceable package MediumHeaWat = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "HW medium"
    annotation(__ctrlFlow(enable=false));

  replaceable package MediumChiWat = MediumHeaWat
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CHW medium"
    annotation(Dialog(
      enable=typMod ==
        Buildings.Templates.Components.Types.HeatPumpCapability.Polyvalent),
      __ctrlFlow(enable=false));

  /*
   * Derived classes representing AWHP shall use:
   * redeclare final package MediumSou = MediumAir
   */
  replaceable package MediumSou = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Source-side medium"
    annotation(Dialog(
      enable=typ == Buildings.Templates.Components.Types.HeatPump.WaterToWater),
      __ctrlFlow(enable=false));

  replaceable package MediumAir = Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium"
    annotation(Dialog(
      enable=typ == Buildings.Templates.Components.Types.HeatPump.AirToWater),
      __ctrlFlow(enable=false));

  parameter Boolean have_hp = true
    "Set to true for plants with non-reversible or reversible heat pumps"
    annotation(Evaluate=true,
      Dialog(group="Configuration"));
  parameter Boolean have_shc = false
    "Set to true for plants with polyvalent (SHC) units"
    annotation(Evaluate=true,
      Dialog(group="Configuration"));
  parameter Integer nHp
    "Number of heat pumps (excluding SHC units)"
    annotation(Evaluate=true,
      Dialog(group="Configuration"));
  parameter Integer nShc = 0
    "Number of polyvalent (SHC) units"
    annotation(Evaluate=true,
      Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.HeatPump typHp
    "Equipment type"
    annotation(Evaluate=true,
      Dialog(group="Configuration"));
  parameter Boolean is_rev
    "Set to true for reversible heat pumps, false for heating only"
    annotation(Evaluate=true,
      Dialog(group="Configuration"));
  // Parameter typArrPumPri only required for icon configuration, not used in equations
  parameter Buildings.Templates.Components.Types.PumpArrangement typArrPumPri =
    Buildings.Templates.Components.Types.PumpArrangement.Dedicated
    "Type of primary pump arrangement"
    annotation(Evaluate=true,
      Dialog(group="Configuration"));
  parameter Buildings.Templates.Plants.HeatPumps.Components.Data.HeatPumpGroup dat(
    have_hp=have_hp,
    have_shc=have_shc,
    typHp=typHp,
    is_rev=is_rev,
    cpHeaWat_default=cpHeaWat_default,
    cpChiWatShc_default=cpChiWat_default,
    cpSou_default=cpSou_default)
    "Design and operating parameters"
    annotation(Placement(transformation(extent={{-10,-120},{10,-100}})),
      __ctrlFlow(enable=false));
  final parameter Buildings.Templates.Components.Data.HeatPump datHp[nHp](
    each final typMod=if is_rev
      then Buildings.Templates.Components.Types.HeatPumpCapability.Reversible
      else Buildings.Templates.Components.Types.HeatPumpCapability.HeatingOnly,
    each final typ=typHp,
    each final cpHeaWat_default=cpHeaWat_default,
    each final cpSou_default=cpSou_default,
    final mHeaWat_flow_nominal=fill(dat.mHeaWatHp_flow_nominal, nHp),
    final mSouWwCoo_flow_nominal=fill(dat.mSouWwCooHp_flow_nominal, nHp),
    final TSouHea_nominal=fill(dat.TSouHeaHp_nominal, nHp),
    final mChiWat_flow_nominal=fill(dat.mChiWatHp_flow_nominal, nHp),
    final dpSouWwHea_nominal=fill(dat.dpSouWwHeaHp_nominal, nHp),
    final THeaWatSup_nominal=fill(dat.THeaWatSupHp_nominal, nHp),
    final dpHeaWat_nominal=fill(dat.dpHeaWatHp_nominal, nHp),
    final mSouWwHea_flow_nominal=fill(dat.mSouWwHeaHp_flow_nominal, nHp),
    final TSouCoo_nominal=fill(dat.TSouCooHp_nominal, nHp),
    each final perHea=dat.perHeaHp,
    each final perCoo=dat.perCooHp,
    final capCoo_nominal=fill(dat.capCooHp_nominal, nHp),
    final TChiWatSup_nominal=fill(dat.TChiWatSupHp_nominal, nHp),
    final capHea_nominal=fill(dat.capHeaHp_nominal, nHp),
    final P_min=fill(dat.PHp_min, nHp))
    if have_hp
    "Design and operating parameters - Each HP";
  final parameter Buildings.Templates.Components.Data.HeatPump datShc[nShc](
    each final typMod=Buildings.Templates.Components.Types.HeatPumpCapability.Polyvalent,
    each final typ=typHp,
    each final cpHeaWat_default=cpHeaWat_default,
    each final cpChiWatShc_default=cpChiWat_default,
    each final cpSou_default=cpSou_default,
    final mHeaWat_flow_nominal=fill(dat.mHeaWatShc_flow_nominal, nShc),
    final mSouWwCoo_flow_nominal=fill(dat.mSouWwCooShc_flow_nominal, nShc),
    final TSouHea_nominal=fill(dat.TSouHeaShc_nominal, nShc),
    final mChiWat_flow_nominal=fill(dat.mChiWatShc_flow_nominal, nShc),
    final dpSouWwHea_nominal=fill(dat.dpSouWwHeaShc_nominal, nShc),
    final THeaWatSup_nominal=fill(dat.THeaWatSupShc_nominal, nShc),
    final dpHeaWat_nominal=fill(dat.dpHeaWatShc_nominal, nShc),
    final dpChiWatShc_nominal=fill(dat.dpChiWatShc_nominal, nShc),
    final mSouWwHea_flow_nominal=fill(dat.mSouWwHeaShc_flow_nominal, nShc),
    final TSouCoo_nominal=fill(dat.TSouCooShc_nominal, nShc),
    each final perShc=dat.perShc,
    final capCoo_nominal=fill(dat.capCooShc_nominal, nShc),
    final TChiWatSup_nominal=fill(dat.TChiWatSupShc_nominal, nShc),
    final capHea_nominal=fill(dat.capHeaShc_nominal, nShc),
    final capCooShc_nominal=fill(dat.capCooHrShc_nominal, nShc),
    final capHeaShc_nominal=fill(dat.capHeaHrShc_nominal, nShc),
    final P_min=fill(dat.PShc_min, nShc))
    if have_shc
    "Design and operating parameters - Each SHC unit";
  final parameter Modelica.Units.SI.MassFlowRate mHeaWatHp_flow_nominal =
    dat.mHeaWatHp_flow_nominal
    "Design HW mass flow rate - Each heat pump";
  final parameter Modelica.Units.SI.HeatFlowRate capHeaHp_nominal =
    dat.capHeaHp_nominal
    "Design heating capacity - Each heat pump";
  final parameter Modelica.Units.SI.HeatFlowRate QHeaHp_flow_nominal =
    abs(capHeaHp_nominal)
    "Design heating heat flow rate - Each heat pump";
  final parameter Modelica.Units.SI.PressureDifference dpHeaWatHp_nominal =
    dat.dpHeaWatHp_nominal
    "Design HW pressure drop - Each heat pump";
  final parameter Modelica.Units.SI.Temperature THeaWatSupHp_nominal =
    dat.THeaWatSupHp_nominal
    "Design HW supply temperature - Each heat pump";
  final parameter Modelica.Units.SI.Temperature THeaWatRetHp_nominal =
    dat.THeaWatRetHp_nominal
    "Design HW return temperature - Each heat pump";
  final parameter Modelica.Units.SI.MassFlowRate mChiWatHp_flow_nominal =
    dat.mChiWatHp_flow_nominal
    "Design CHW mass flow rate - Each heat pump"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.PressureDifference dpChiWatHp_nominal =
    dat.dpChiWatHp_nominal
    "Design CHW pressure drop - Each heat pump";
  final parameter Modelica.Units.SI.HeatFlowRate capCooHp_nominal =
    dat.capCooHp_nominal
    "Design cooling capacity - Each heat pump";
  final parameter Modelica.Units.SI.HeatFlowRate QCooHp_flow_nominal =
    -abs(capCooHp_nominal)
    "Design cooling heat flow rate - Each heat pump";
  final parameter Modelica.Units.SI.Temperature TChiWatSupHp_nominal =
    dat.TChiWatSupHp_nominal
    "Design CHW supply temperature - Each heat pump";
  final parameter Modelica.Units.SI.Temperature TChiWatRetHp_nominal =
    dat.TChiWatRetHp_nominal
    "Design CHW return temperature - Each heat pump";
  final parameter Modelica.Units.SI.MassFlowRate mSouHeaHp_flow_nominal =
    dat.mSouHeaHp_flow_nominal
    "Design source fluid mass flow rate in heating mode - Each heat pump";
  final parameter Modelica.Units.SI.PressureDifference dpSouHeaHp_nominal =
    dat.dpSouHeaHp_nominal
    "Design source fluid pressure drop in heating mode - Each heat pump";
  final parameter Modelica.Units.SI.MassFlowRate mSouCooHp_flow_nominal =
    dat.mSouCooHp_flow_nominal
    "Design source fluid mass flow rate in cooling mode - Each heat pump";
  final parameter Modelica.Units.SI.PressureDifference dpSouCooHp_nominal =
    dat.dpSouCooHp_nominal
    "Designs source fluid pressure drop in cooling mode - Each heat pump";
  final parameter Modelica.Units.SI.Temperature TSouCooHp_nominal =
    dat.TSouCooHp_nominal
    "Design OAT or source fluid supply temperature (condenser entering) in cooling mode - Each heat pump";
  final parameter Modelica.Units.SI.Temperature TSouHeaHp_nominal =
    dat.TSouHeaHp_nominal
    "Design OAT or source fluid supply temperature (evaporator entering) in heating mode - Each heat pump";
  parameter Modelica.Fluid.Types.Dynamics energyDynamics =
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true,
      Dialog(tab="Dynamics",
        group="Conservation equations"));
  parameter Boolean allowFlowReversal = true
    "Load side flow reversal: false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions"),
      Evaluate=true);
  parameter Boolean allowFlowReversalSou = true
    "Source side flow reversal: false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions",
      enable=Buildings.Templates.Components.Types.HeatPump.WaterToWater),
      Evaluate=true);
  parameter Boolean have_dpChiHeaWat = true
    "Set to true for CHW/HW pressure drop computed by this model, false for external computation"
    annotation(Evaluate=true,
      Dialog(tab="Assumptions"));
  parameter Boolean have_dpSou = true
    "Set to true for source fluid pressure drop computed by this model, false for external computation"
    annotation(Evaluate=true,
      Dialog(tab="Assumptions",
        enable=Buildings.Templates.Components.Types.HeatPump.WaterToWater));
  final parameter MediumHeaWat.SpecificHeatCapacity cpHeaWat_default =
    MediumHeaWat.specificHeatCapacityCp(staHeaWat_default)
    "HW default specific heat capacity";
  final parameter MediumHeaWat.ThermodynamicState staHeaWat_default =
    MediumHeaWat.setState_pTX(
      T=THeaWatSupHp_nominal,
      p=MediumHeaWat.p_default,
      X=MediumHeaWat.X_default)
    "HW default state";
  final parameter MediumChiWat.SpecificHeatCapacity cpChiWat_default =
    MediumChiWat.specificHeatCapacityCp(staChiWat_default)
    "CHW default specific heat capacity";
  final parameter MediumChiWat.ThermodynamicState staChiWat_default =
    MediumChiWat.setState_pTX(
      T=TChiWatSupHp_nominal,
      p=MediumChiWat.p_default,
      X=MediumChiWat.X_default)
    "CHW default state";
  final parameter MediumSou.SpecificHeatCapacity cpSou_default =
    MediumSou.specificHeatCapacityCp(staSou_default)
    "Source fluid default specific heat capacity";
  final parameter MediumSou.ThermodynamicState staSou_default =
    MediumSou.setState_pTX(
      T=TSouHeaHp_nominal, p=MediumSou.p_default, X=MediumSou.X_default)
    "Source fluid default state";
  // Diagnostics
  parameter Boolean show_T = false
    "= true, if actual temperature at port is computed"
    annotation(Dialog(tab="Advanced",
      group="Diagnostics"),
      HideResult=true);
  Modelica.Fluid.Interfaces.FluidPorts_b ports_bChiHeaWatHp[nHp](
    redeclare each final package Medium=MediumHeaWat,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(
      start=MediumHeaWat.h_default,
      nominal=MediumHeaWat.h_default))
    if have_hp
    "CHW/HW supply – Heat pumps"
    annotation(Placement(transformation(extent={{-10,-40},{10,40}},
      rotation=90,
      origin={-180,200}),
      iconTransformation(extent={{-10,-40},{10,40}},
        rotation=90,
        origin={-820,400})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aChiHeaWatHp[nHp](
    redeclare each final package Medium=MediumHeaWat,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(
      start=MediumHeaWat.h_default,
      nominal=MediumHeaWat.h_default))
    if have_hp
    "CHW/HW return – Heat pumps"
    annotation(Placement(transformation(extent={{-10,-40},{10,40}},
      rotation=90,
      origin={180,200}),
      iconTransformation(extent={{-10,-40},{10,40}},
        rotation=90,
        origin={820,400})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_bSou[nHp + nShc](
    redeclare each final package Medium=MediumSou,
    each m_flow(
      max=if allowFlowReversalSou then +Modelica.Constants.inf else 0),
    each h_outflow(start=MediumSou.h_default, nominal=MediumSou.h_default))
    "Source fluid return (from heat pumps)"
    annotation(Placement(
      iconVisible=typHp ==
        Buildings.Templates.Components.Types.HeatPump.WaterToWater,
      transformation(extent={{-10,-40},{10,40}},
        rotation=90,
        origin={160,-200}),
      iconTransformation(extent={{-10,-40},{10,40}},
        rotation=90,
        origin={500,-398})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aSou[nHp + nShc](
    redeclare each final package Medium=MediumSou,
    each m_flow(
      min=if allowFlowReversalSou then -Modelica.Constants.inf else 0),
    each h_outflow(start=MediumSou.h_default, nominal=MediumSou.h_default))
    "Source fluid supply (to heat pumps)"
    annotation(Placement(
      iconVisible=typHp ==
        Buildings.Templates.Components.Types.HeatPump.WaterToWater,
      transformation(extent={{-10,-40},{10,40}},
        rotation=90,
        origin={-160,-200}),
      iconTransformation(extent={{-10,-40},{10,40}},
        rotation=90,
        origin={-500,-400})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_bHeaWatShc[nShc](
    redeclare each final package Medium=MediumHeaWat,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(
      start=MediumHeaWat.h_default,
      nominal=MediumHeaWat.h_default))
    if have_shc
    "HW supply – SHC units"
    annotation(Placement(transformation(extent={{-10,-40},{10,40}},
      rotation=90,
      origin={-120,200}),
      iconTransformation(extent={{-10,-40},{10,40}},
        rotation=90,
        origin={-660,400})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_bChiWatShc[nShc](
    redeclare each final package Medium=MediumChiWat,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(
      start=MediumChiWat.h_default,
      nominal=MediumChiWat.h_default))
    if have_shc
    "CHW supply – SHC units"
    annotation(Placement(transformation(extent={{-10,-40},{10,40}},
      rotation=90,
      origin={-60,200}),
      iconTransformation(extent={{-10,-40},{10,40}},
        rotation=90,
        origin={-500,400})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aHeaWatShc[nShc](
    redeclare each final package Medium=MediumHeaWat,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(
      start=MediumHeaWat.h_default,
      nominal=MediumHeaWat.h_default))
    if have_shc
    "HW return – SHC units"
    annotation(Placement(transformation(extent={{-10,-40},{10,40}},
      rotation=90,
      origin={120,200}),
      iconTransformation(extent={{-10,-40},{10,40}},
        rotation=90,
        origin={660,400})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aChiWatShc[nShc](
    redeclare each final package Medium=MediumChiWat,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(
      start=MediumChiWat.h_default,
      nominal=MediumChiWat.h_default))
    if have_shc
    "CHW return – SHC units"
    annotation(Placement(transformation(extent={{-10,-40},{10,40}},
      rotation=90,
      origin={60,200}),
      iconTransformation(extent={{-10,-40},{10,40}},
        rotation=90,
        origin={500,400})));
  Buildings.Templates.Plants.HeatPumps.Interfaces.Bus bus
    "Plant control bus"
    annotation(Placement(transformation(extent={{-40,180},{0,220}}),
      iconTransformation(extent={{-20,380},{20,420}})));
  Buildings.BoundaryConditions.WeatherData.Bus busWea
    if typHp == Buildings.Templates.Components.Types.HeatPump.AirToWater
    "Weather bus"
    annotation(Placement(transformation(extent={{0,180},{40,220}}),
      iconTransformation(extent={{-220,380},{-180,420}})));
  MediumSou.ThermodynamicState sta_aSou[nHp + nShc] =
    MediumSou.setState_phX(
      ports_aSou.p,
      noEvent(actualStream(ports_aSou.h_outflow)),
      noEvent(actualStream(ports_aSou.Xi_outflow)))
    if show_T
    "Source medium properties in port_aSou";
  MediumSou.ThermodynamicState sta_bSou[nHp + nShc] =
    MediumSou.setState_phX(
      ports_bSou.p,
      noEvent(actualStream(ports_bSou.h_outflow)),
      noEvent(actualStream(ports_bSou.Xi_outflow)))
    if show_T
    "Source medium properties in port_bSou";
  MediumHeaWat.ThermodynamicState sta_aChiHeaWatHp[nHp] =
    MediumHeaWat.setState_phX(
      ports_aChiHeaWatHp.p,
      noEvent(actualStream(ports_aChiHeaWatHp.h_outflow)),
      noEvent(actualStream(ports_aChiHeaWatHp.Xi_outflow)))
    if show_T and have_hp
    "Source medium properties in port_aChiHeaWatHp";
  MediumHeaWat.ThermodynamicState sta_bChiHeaWatHp[nHp] =
    MediumHeaWat.setState_phX(
      ports_bChiHeaWatHp.p,
      noEvent(actualStream(ports_bChiHeaWatHp.h_outflow)),
      noEvent(actualStream(ports_bChiHeaWatHp.Xi_outflow)))
    if show_T and have_hp
    "Source medium properties in port_bChiHeaWatHp";
  MediumHeaWat.ThermodynamicState sta_aHeaWatShc[nShc] =
    MediumHeaWat.setState_phX(
      ports_aHeaWatShc.p,
      noEvent(actualStream(ports_aHeaWatShc.h_outflow)),
      noEvent(actualStream(ports_aHeaWatShc.Xi_outflow)))
    if show_T and have_shc
    "Source medium properties in port_aHeaWatShc";
  MediumHeaWat.ThermodynamicState sta_bHeaWatShc[nShc] =
    MediumHeaWat.setState_phX(
      ports_bHeaWatShc.p,
      noEvent(actualStream(ports_bHeaWatShc.h_outflow)),
      noEvent(actualStream(ports_bHeaWatShc.Xi_outflow)))
    if show_T and have_shc
    "Source medium properties in port_bHeaWatShc";
  MediumChiWat.ThermodynamicState sta_aChiWatShc[nShc] =
    MediumChiWat.setState_phX(
      ports_aChiWatShc.p,
      noEvent(actualStream(ports_aChiWatShc.h_outflow)),
      noEvent(actualStream(ports_aChiWatShc.Xi_outflow)))
    if show_T and have_shc
    "Source medium properties in port_aChiWatShc";
  MediumChiWat.ThermodynamicState sta_bChiWatShc[nShc] =
    MediumChiWat.setState_phX(
      ports_bChiWatShc.p,
      noEvent(actualStream(ports_bChiWatShc.h_outflow)),
      noEvent(actualStream(ports_bChiWatShc.Xi_outflow)))
    if show_T and have_shc
    "Source medium properties in port_bChiWatShc";
  protected
  Buildings.Templates.Components.Interfaces.Bus busHp[nHp]
    if have_hp
    "Heat pump control bus"
    annotation(Placement(transformation(extent={{-20,140},{20,180}}),
      iconTransformation(extent={{-522,206},{-482,246}})));
  protected
  Buildings.Templates.Components.Interfaces.Bus busShc[nShc]
    if have_shc
    "SHC unit control bus"
    annotation(Placement(transformation(extent={{-60,140},{-20,180}}),
      iconTransformation(extent={{-522,206},{-482,246}})));
equation
  connect(bus.hp, busHp)
    annotation(Line(points={{-20,200},{-20,160},{0,160}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.shc, busShc)
    annotation(Line(points={{-20,200},{-20,160},{-40,160}},
      color={255,204,51},
      thickness=0.5));
annotation(Diagram(coordinateSystem(extent={{-200,-200},{200,200}})),
  Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-2400,-400},{2400,400}}),
    graphics={Bitmap(extent={{1880,160},{1960,240}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Boilers/ControllerOnboard.svg",
      visible=nHp + nShc >= 1),
    Rectangle(extent={{2240,400},{1960,0}},
      visible=nHp + nShc >= 1,
      lineThickness=1),
    Text(extent={{1960,250},{2240,150}},
      textColor={0,0,0},
      visible=nHp >= 1,
      textString="HP-1"),
    Bitmap(extent={{1080,160},{1160,240}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Boilers/ControllerOnboard.svg",
      visible=nHp + nShc >= 2),
    Rectangle(extent={{1440,400},{1160,0}},
      visible=nHp + nShc >= 2,
      lineThickness=1),
    Text(extent={{1160,250},{1440,150}},
      textColor={0,0,0},
      visible=nHp >= 2,
      textString="HP-2"),
    Bitmap(extent={{280,160},{360,240}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Boilers/ControllerOnboard.svg",
      visible=nHp + nShc >= 3),
    Rectangle(extent={{640,400},{360,0}},
      visible=nHp + nShc >= 3,
      lineThickness=1),
    Text(extent={{360,250},{640,150}},
      textColor={0,0,0},
      visible=nHp >= 3,
      textString="HP-3"),
    Bitmap(extent={{-520,160},{-440,240}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Boilers/ControllerOnboard.svg",
      visible=nHp + nShc >= 4),
    Rectangle(extent={{-160,400},{-440,0}},
      lineColor={0,0,0},
      lineThickness=1,
      visible=nHp + nShc >= 4),
    Text(extent={{-440,250},{-160,150}},
      textColor={0,0,0},
      visible=nHp >= 4,
      textString="HP-4"),
    Bitmap(extent={{-1320,160},{-1240,240}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Boilers/ControllerOnboard.svg",
      visible=nHp + nShc >= 5),
    Rectangle(extent={{-960,400},{-1240,0}},
      lineColor={0,0,0},
      lineThickness=1,
      visible=nHp + nShc >= 5),
    Text(extent={{-1240,250},{-960,150}},
      textColor={0,0,0},
      visible=nHp >= 5,
      textString="HP-5"),
    Bitmap(extent={{-2120,160},{-2040,240}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Boilers/ControllerOnboard.svg",
      visible=nHp + nShc >= 6),
    Rectangle(extent={{-1760,400},{-2040,0}},
      lineColor={0,0,0},
      lineThickness=1,
      visible=nHp + nShc >= 6),
    Text(extent={{-2040,250},{-1760,150}},
      textColor={0,0,0},
      visible=nHp >= 6,
      textString="HP-6"),
    Text(extent={{1960,250},{2240,150}},
      textColor={0,0,0},
      visible=nShc + nHp >= 1 and nHp < 1,
      textString="HR-" + String(1 - nHp)),
    Text(extent={{1160,250},{1440,150}},
      textColor={0,0,0},
      visible=nShc + nHp >= 2 and nHp < 2,
      textString="HR-" + String(2 - nHp)),
    Text(extent={{360,250},{640,150}},
      textColor={0,0,0},
      visible=nShc + nHp >= 3 and nHp < 3,
      textString="HR-" + String(3 - nHp)),
    Text(extent={{-440,250},{-160,150}},
      textColor={0,0,0},
      visible=nShc + nHp >= 4 and nHp < 4,
      textString="HR-" + String(4 - nHp)),
    Text(extent={{-1240,250},{-960,150}},
      textColor={0,0,0},
      visible=nShc + nHp >= 5 and nHp < 5,
      textString="HR-" + String(5 - nHp)),
    Text(extent={{-2040,250},{-1760,150}},
      textColor={0,0,0},
      visible=nShc + nHp >= 6 and nHp < 6,
      textString="HR-" + String(6 - nHp)),
    Line(points={{2400,400},{2400,-80},{2200,-80},{2200,0}},
      color={0,0,0},
      thickness=5,
      pattern=LinePattern.Dash,
      visible=nHp + nShc >= 1 and nHp < 1),
    Line(points={{1600,400},{1600,-80},{1400,-80},{1400,0}},
      color={0,0,0},
      thickness=5,
      pattern=LinePattern.Dash,
      visible=nHp + nShc >= 2 and nHp < 2),
    Line(points={{800,400},{800,-80},{600,-80},{600,0}},
      color={0,0,0},
      thickness=5,
      pattern=LinePattern.Dash,
      visible=nHp + nShc >= 3 and nHp < 3),
    Line(points={{0,400},{0,-80},{-200,-80},{-200,0}},
      color={0,0,0},
      thickness=5,
      pattern=LinePattern.Dash,
      visible=nHp + nShc >= 4 and nHp < 4),
    Line(points={{-800,400},{-800,-80},{-1000,-80},{-1000,0}},
      color={0,0,0},
      thickness=5,
      pattern=LinePattern.Dash,
      visible=nHp + nShc >= 5 and nHp < 5),
    Line(points={{-1600,400},{-1600,-80},{-1800,-80},{-1800,0}},
      color={0,0,0},
      thickness=5,
      pattern=LinePattern.Dash,
      visible=nHp + nShc >= 6 and nHp < 6),
    Line(points=if typArrPumPri ==
      Buildings.Templates.Components.Types.PumpArrangement.Headered
      then {{1000,400},{1000,-80},{1200,-80},{1200,0}}
      else {{1020,400},{1020,-80},{1200,-80},{1200,0}},
      color={0,0,0},
      thickness=5,
      visible=nHp + nShc >= 2 and nHp < 2),
    Line(points=if typArrPumPri ==
      Buildings.Templates.Components.Types.PumpArrangement.Headered
      then {{1800,400},{1800,-80},{2000,-80},{2000,0}}
      else {{1820,400},{1820,-80},{2000,-80},{2000,0}},
      color={0,0,0},
      thickness=5,
      visible=nHp + nShc >= 1 and nHp < 1),
    Line(points=if typArrPumPri ==
      Buildings.Templates.Components.Types.PumpArrangement.Headered
      then {{200,400},{200,-80},{400,-80},{400,0}}
      else {{220,400},{220,-80},{400,-80},{400,0}},
      color={0,0,0},
      thickness=5,
      visible=nHp + nShc >= 3 and nHp < 3),
    Line(points=if typArrPumPri ==
      Buildings.Templates.Components.Types.PumpArrangement.Headered
      then {{-600,400},{-600,-80},{-400,-80},{-400,0}}
      else {{-580,400},{-580,-80},{-400,-80},{-400,0}},
      color={0,0,0},
      thickness=5,
      visible=nHp + nShc >= 4 and nHp < 4),
    Line(points=if typArrPumPri ==
      Buildings.Templates.Components.Types.PumpArrangement.Headered
      then {{-1400,400},{-1400,-80},{-1200,-80},{-1200,0}}
      else {{-1380,400},{-1380,-80},{-1200,-80},{-1200,0}},
      color={0,0,0},
      thickness=5,
      visible=nHp + nShc >= 5 and nHp < 5),
    Line(points=if typArrPumPri ==
      Buildings.Templates.Components.Types.PumpArrangement.Headered
      then {{-2200,400},{-2200,-80},{-2000,-80},{-2000,0}}
      else {{-2180,400},{-2180,-80},{-2000,-80},{-2000,0}},
      color={0,0,0},
      thickness=5,
      visible=nHp + nShc >= 6 and nHp < 6)}),
  Documentation(
    info="<html>
<p>
  This partial class provides a standard interface for heat pump group models.
</p>
</html>"));
end PartialHeatPumpGroup;
