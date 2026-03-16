within Buildings.Templates.Plants.HeatPumps.Components.Interfaces;
model PartialHeatPumpGroup
  "Interface for heat pump group"
  replaceable package MediumHeaWat = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "HW medium"
    annotation(__ctrlFlow(enable=false));

  /*
   * MediumChiWat is for internal use only.
   * It is the same as MediumHeaWat for reversible HP.
   * Non-reversible HP that can be controlled to produce either HW or CHW
   * shall be modeled with chiller components (as a chiller/heater).
   */
  final package MediumChiWat = MediumHeaWat "CHW medium";

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
  final parameter Buildings.Templates.Components.Types.HeatPumpCapability typModUni[nHp +
    nShc] =
    {if have_shc and i > nHp
    then Buildings.Templates.Components.Types.HeatPumpCapability.HeatRecovery
    elseif is_rev
    then Buildings.Templates.Components.Types.HeatPumpCapability.Reversible
    else Buildings.Templates.Components.Types.HeatPumpCapability.HeatingOnly for i in 1:nHp +
      nShc}
    "Heat pump operating mode capability – Each unit"
    annotation(Evaluate=true);
  parameter Buildings.Templates.Plants.HeatPumps.Components.Data.HeatPumpGroup dat(
    have_hp=have_hp,
    have_shc=have_shc,
    typHp=typHp,
    is_rev=is_rev,
    cpHeaWat_default=cpHeaWat_default,
    cpSou_default=cpSou_default)
    "Design and operating parameters"
    annotation(Placement(transformation(extent={{-10,-120},{10,-100}})),
      __ctrlFlow(enable=false));
  final parameter Buildings.Templates.Components.Data.HeatPump datUni[nHp +
    nShc](
    final typMod=typModUni,
    each final typ=typHp,
    each final cpHeaWat_default=cpHeaWat_default,
    each final cpSou_default=cpSou_default,
    final mHeaWat_flow_nominal=cat(
      1,
      fill(dat.mHeaWatHp_flow_nominal, nHp),
      fill(dat.mHeaWatShc_flow_nominal, nShc)),
    final mSouWwCoo_flow_nominal=cat(
      1,
      fill(dat.mSouWwCooHp_flow_nominal, nHp),
      fill(dat.mSouWwCooShc_flow_nominal, nShc)),
    final TSouHea_nominal=cat(
      1, fill(dat.TSouHeaHp_nominal, nHp), fill(dat.TSouHeaShc_nominal, nShc)),
    final mChiWat_flow_nominal=cat(
      1,
      fill(dat.mChiWatHp_flow_nominal, nHp),
      fill(dat.mChiWatShc_flow_nominal, nShc)),
    final dpSouWwHea_nominal=cat(
      1,
      fill(dat.dpSouWwHeaHp_nominal, nHp),
      fill(dat.dpSouWwHeaShc_nominal, nShc)),
    final THeaWatSup_nominal=cat(
      1,
      fill(dat.THeaWatSupHp_nominal, nHp),
      fill(dat.THeaWatSupShc_nominal, nShc)),
    final dpHeaWat_nominal=cat(
      1,
      fill(dat.dpHeaWatHp_nominal, nHp),
      fill(dat.dpHeaWatShc_nominal, nShc)),
    final mSouWwHea_flow_nominal=cat(
      1,
      fill(dat.mSouWwHeaHp_flow_nominal, nHp),
      fill(dat.mSouWwHeaShc_flow_nominal, nShc)),
    final TSouCoo_nominal=cat(
      1, fill(dat.TSouCooHp_nominal, nHp), fill(dat.TSouCooShc_nominal, nShc)),
    each final perHea=dat.perHeaHp,
    each final perCoo=dat.perCooHp,
    each final perShc=dat.perShc,
    final capCoo_nominal=cat(
      1, fill(dat.capCooHp_nominal, nHp), fill(dat.capCooShc_nominal, nShc)),
    final TChiWatSup_nominal=cat(
      1,
      fill(dat.TChiWatSupHp_nominal, nHp),
      fill(dat.TChiWatSupShc_nominal, nShc)),
    final capHea_nominal=cat(
      1, fill(dat.capHeaHp_nominal, nHp), fill(dat.capHeaShc_nominal, nShc)),
    final capCooShc_nominal=cat(
      1, fill(0, nHp), fill(dat.capCooHrShc_nominal, nShc)),
    final capHeaShc_nominal=cat(
      1, fill(0, nHp), fill(dat.capHeaHrShc_nominal, nShc)),
    final P_min=cat(1, fill(dat.PHp_min, nHp), fill(dat.PShc_min, nShc)))
    "Design and operating parameters - Each unit";
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
  parameter Boolean have_dpChiHeaWatHp = true
    "Set to true for HP CHW/HW pressure drop computed by this model, false for external computation"
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
  Buildings.Templates.Plants.HeatPumps.Interfaces.Bus bus
    "Plant control bus"
    annotation(Placement(transformation(extent={{-40,180},{0,220}}),
      iconTransformation(extent={{-20,380},{20,420}})));
  Buildings.BoundaryConditions.WeatherData.Bus busWea
    if typHp == Buildings.Templates.Components.Types.HeatPump.AirToWater
    "Weather bus"
    annotation(Placement(transformation(extent={{0,180},{40,220}}),
      iconTransformation(extent={{-220,380},{-180,420}})));
  // Diagnostics
  parameter Boolean show_T = false
    "= true, if actual temperature at port is computed"
    annotation(Dialog(tab="Advanced",
      group="Diagnostics"),
      HideResult=true);
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
      start=MediumHeaWat.h_default,
      nominal=MediumHeaWat.h_default))
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
      start=MediumHeaWat.h_default,
      nominal=MediumHeaWat.h_default))
    if have_shc
    "CHW return – SHC units"
    annotation(Placement(transformation(extent={{-10,-40},{10,40}},
      rotation=90,
      origin={60,200}),
      iconTransformation(extent={{-10,-40},{10,40}},
        rotation=90,
        origin={500,400})));
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
      visible=nHp >= 1),
    Rectangle(extent={{2240,400},{1960,0}},
      lineColor={0,0,0},
      lineThickness=1,
      visible=nHp >= 1),
    Text(extent={{1960,250},{2240,150}},
      textColor={0,0,0},
      visible=nHp >= 1,
      textString="HP-1"),
    Bitmap(extent={{1080,160},{1160,240}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Boilers/ControllerOnboard.svg",
      visible=nHp >= 2),
    Rectangle(extent={{1440,400},{1160,0}},
      lineColor={0,0,0},
      lineThickness=1,
      visible=nHp >= 2),
    Text(extent={{1160,250},{1440,150}},
      textColor={0,0,0},
      visible=nHp >= 2,
      textString="HP-2"),
    Bitmap(extent={{280,160},{360,240}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Boilers/ControllerOnboard.svg",
      visible=nHp >= 3),
    Rectangle(extent={{640,400},{360,0}},
      lineColor={0,0,0},
      lineThickness=1,
      visible=nHp >= 3),
    Text(extent={{360,250},{640,150}},
      textColor={0,0,0},
      visible=nHp >= 3,
      textString="HP-3"),
    Bitmap(extent={{-520,160},{-440,240}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Boilers/ControllerOnboard.svg",
      visible=nHp >= 4),
    Rectangle(extent={{-160,400},{-440,0}},
      lineColor={0,0,0},
      lineThickness=1,
      visible=nHp >= 4),
    Text(extent={{-440,250},{-160,150}},
      textColor={0,0,0},
      visible=nHp >= 4,
      textString="HP-4"),
    Bitmap(extent={{-1320,160},{-1240,240}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Boilers/ControllerOnboard.svg",
      visible=nHp >= 5),
    Rectangle(extent={{-960,400},{-1240,0}},
      lineColor={0,0,0},
      lineThickness=1,
      visible=nHp >= 5),
    Text(extent={{-1240,250},{-960,150}},
      textColor={0,0,0},
      visible=nHp >= 5,
      textString="HP-5"),
    Bitmap(extent={{-2120,160},{-2040,240}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Boilers/ControllerOnboard.svg",
      visible=nHp >= 6),
    Rectangle(extent={{-1760,400},{-2040,0}},
      lineColor={0,0,0},
      lineThickness=1,
      visible=nHp >= 6),
    Text(extent={{-2040,250},{-1760,150}},
      textColor={0,0,0},
      visible=nHp >= 6,
      textString="HP-6")}),
  Documentation(
    info="<html>
<p>
  This partial class provides a standard interface for heat pump group models.
</p>
</html>"));
end PartialHeatPumpGroup;
