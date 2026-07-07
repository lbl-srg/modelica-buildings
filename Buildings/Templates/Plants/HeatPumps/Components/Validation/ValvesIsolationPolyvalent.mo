within Buildings.Templates.Plants.HeatPumps.Components.Validation;
model ValvesIsolationPolyvalent
  "Validation model for isolation valve component with polyvalent heat pumps"
  extends Modelica.Icons.Example;
  parameter Buildings.Templates.Plants.HeatPumps.Types.Controller typCtl =
    Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop;

  replaceable package Medium = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CHW/HW medium";

  final parameter Integer nHp = 2
    "Number of heat pumps (excluding polyvalent units)"
    annotation(Evaluate=true);
  final parameter Integer nPhp = 2
    "Number of polyvalent heat pumps"
    annotation(Evaluate=true);
  parameter Modelica.Fluid.Types.Dynamics energyDynamics =
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true,
      Dialog(tab="Dynamics",
        group="Conservation equations"));
  parameter Data.Controller datCtl(
    cfg(
      typ=Buildings.Templates.Plants.Controls.Types.PlantHeatPump.ReversiblePolyvalent,
      have_inpSch=false,
      have_hrc=false,
      have_hp=true,
      have_php=true,
      have_valHpOutIso=valIsoCom.have_valHpOutIso,
      have_valHpInlIso=valIsoCom.have_valHpInlIso,
      have_valPhpOutIso=valIsoCom.have_valPhpOutIso,
      have_valPhpInlIso=valIsoCom.have_valPhpInlIso,
      have_chiWat=valIsoCom.have_chiWat,
      typPumHeaWatPri=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable,
      typPumChiWatPri=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable,
      typPumHeaWatSec=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None,
      typTanHeaWat=Buildings.Templates.Components.Types.IntegrationPoint.None,
      typTanChiWat=Buildings.Templates.Components.Types.IntegrationPoint.None,
      typDis=Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Only,
      nPumChiWatSec=0,
      rhoHeaWat_default=Buildings.Media.Water.d_const,
      typCtl=Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop,
      is_rev=true,
      typHp=Buildings.Templates.Components.Types.HeatPump.AirToWater,
      rhoChiWat_default=Buildings.Media.Water.d_const,
      cpChiWat_default=Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
      have_hotWat=false,
      have_valChiWatMinByp=false,
      have_valHeaWatMinByp=false,
      cpHeaWat_default=Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
      cpSou_default=Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
      have_senDpChiWatRemWir=true,
      typArrPumPri=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
      final nHp=nHp,
      final nPhp=nPhp,
      final nPumHeaWatPri=nHp + nPhp,
      have_heaWat=true,
      nPumHeaWatSec=0,
      rhoSou_default=Buildings.Media.Air.dStp,
      have_senDpHeaWatRemWir=true,
      typPumChiWatSec=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None,
      final nPumChiWatPri=nPhp,
      nSenDpHeaWatRem=0,
      nSenDpChiWatRem=0,
      nAirHan=0,
      nEquZon=0,
      have_pumChiWatPriDedHp=valIsoCom.have_pumChiWatDedHp),
    THeaWatSup_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    TChiWatSup_nominal=Buildings.Templates.Data.Defaults.TChiWatSup,
    dpChiWatRemSet_max=fill(Buildings.Templates.Data.Defaults.dpChiWatRemSet_max,
        datCtl.cfg.nSenDpChiWatRem),
    dpHeaWatRemSet_max=fill(Buildings.Templates.Data.Defaults.dpHeaWatRemSet_max,
        datCtl.cfg.nSenDpHeaWatRem),
    staHp={fill(1, datCtl.cfg.nHp)}) "Controller parameters"
    annotation (Placement(transformation(extent={{-80,250},{-60,270}})));
  parameter Data.Controller datCtlSep(
    cfg(
      typ=Buildings.Templates.Plants.Controls.Types.PlantHeatPump.ReversiblePolyvalent,
      have_inpSch=false,
      have_hrc=false,
      have_hp=true,
      have_php=true,
      have_valHpOutIso=valIsoSep.have_valHpOutIso,
      have_valHpInlIso=valIsoSep.have_valHpInlIso,
      have_valPhpInlIso=valIsoSep.have_valPhpInlIso,
      have_valPhpOutIso=valIsoSep.have_valPhpOutIso,
      have_chiWat=valIsoSep.have_chiWat,
      typPumHeaWatPri=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable,
      typPumChiWatPri=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable,
      typPumHeaWatSec=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None,
      typTanHeaWat=Buildings.Templates.Components.Types.IntegrationPoint.None,
      typTanChiWat=Buildings.Templates.Components.Types.IntegrationPoint.None,
      typDis=Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Only,
      nPumChiWatSec=0,
      rhoHeaWat_default=Buildings.Media.Water.d_const,
      typCtl=Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop,
      is_rev=true,
      typHp=Buildings.Templates.Components.Types.HeatPump.AirToWater,
      rhoChiWat_default=Buildings.Media.Water.d_const,
      cpChiWat_default=Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
      have_hotWat=false,
      have_valChiWatMinByp=false,
      have_valHeaWatMinByp=false,
      cpHeaWat_default=Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
      cpSou_default=Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
      have_senDpChiWatRemWir=true,
      typArrPumPri=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
      final nHp=nHp,
      final nPhp=nPhp,
      final nPumHeaWatPri=nHp + nPhp,
      have_heaWat=true,
      nPumHeaWatSec=0,
      rhoSou_default=Buildings.Media.Air.dStp,
      have_senDpHeaWatRemWir=true,
      typPumChiWatSec=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None,
      final nPumChiWatPri=nHp + nPhp,
      nSenDpHeaWatRem=0,
      nSenDpChiWatRem=0,
      nAirHan=0,
      nEquZon=0,
      have_pumChiWatPriDedHp=valIsoSep.have_pumChiWatDedHp),
    THeaWatSup_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    TChiWatSup_nominal=Buildings.Templates.Data.Defaults.TChiWatSup,
    dpChiWatRemSet_max=fill(Buildings.Templates.Data.Defaults.dpChiWatRemSet_max,
        datCtlSep.cfg.nSenDpChiWatRem),
    dpHeaWatRemSet_max=fill(Buildings.Templates.Data.Defaults.dpHeaWatRemSet_max,
        datCtlSep.cfg.nSenDpHeaWatRem),
    staHp={fill(1, datCtlSep.cfg.nHp)}) "Controller parameters"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  parameter Data.HeatPumpGroup datHpPhp(
    final have_hp=true,
    final have_php=true,
    final typHp=Buildings.Templates.Components.Types.HeatPump.AirToWater,
    final is_rev=true,
    mHeaWatHp_flow_nominal=datHpPhp.capHeaHp_nominal/abs(datHpPhp.THeaWatSupHp_nominal
         - Buildings.Templates.Data.Defaults.THeaWatRetMed)/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    dpHeaWatHp_nominal=Buildings.Templates.Data.Defaults.dpHeaWatHp,
    capHeaHp_nominal=500E3,
    THeaWatSupHp_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    TSouHeaHp_nominal=Buildings.Templates.Data.Defaults.TOutHpHeaLow,
    mChiWatHp_flow_nominal=datHpPhp.capCooHp_nominal/abs(datHpPhp.TChiWatSupHp_nominal
         - Buildings.Templates.Data.Defaults.TChiWatRet)/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    capCooHp_nominal=500E3,
    TChiWatSupHp_nominal=Buildings.Templates.Data.Defaults.TChiWatSup,
    TSouCooHp_nominal=Buildings.Templates.Data.Defaults.TOutHpCoo,
    PHp_min=1.0E3,
    perHeaHp(
      fileName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Templates/Components/HeatPumps/Validation/AWHP_Heating.txt"),
      PLRSup={1},
      use_TEvaOutForTab=false,
      use_TConOutForTab=true,
      tabUppBou=[263.15,323.15; 313.15,323.15]),
    perCooHp(fileName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Templates/Components/HeatPumps/Validation/AWHP_Cooling.txt"),
        PLRSup={1}),
    mHeaWatPhp_flow_nominal=datHpPhp.capHeaPhp_nominal/abs(datHpPhp.THeaWatSupPhp_nominal
         - Buildings.Templates.Data.Defaults.THeaWatRetMed)/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    dpHeaWatPhp_nominal=Buildings.Templates.Data.Defaults.dpHeaWatHp,
    capHeaPhp_nominal=500E3,
    THeaWatSupPhp_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    TSouHeaPhp_nominal=Buildings.Templates.Data.Defaults.TOutHpHeaLow,
    mChiWatPhp_flow_nominal=datHpPhp.capCooPhp_nominal/abs(datHpPhp.TChiWatSupPhp_nominal
         - Buildings.Templates.Data.Defaults.TChiWatRet)/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    capCooPhp_nominal=500E3,
    dpChiWatPhp_nominal=Buildings.Templates.Data.Defaults.dpChiWatChi,
    TChiWatSupPhp_nominal=Buildings.Templates.Data.Defaults.TChiWatSup,
    TSouCooPhp_nominal=Buildings.Templates.Data.Defaults.TOutHpCoo,
    PPhp_min=1.0E3,
    capHeaShcPhp_nominal=500E3,
    capCooShcPhp_nominal=500E3,
    perPhp(
      fileNameHea=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_Heating.txt"),
      fileNameCoo=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_Cooling.txt"),
      fileNameShc=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_SHC.txt")))
    "Parameters for reversible and polyvalent heat pumps"
    annotation (Placement(transformation(extent={{-280,0},{-260,20}})));
  Buildings.Templates.Plants.HeatPumps.Components.ValvesIsolation valIsoCom(
    redeclare final package Medium=Medium,
    have_hp=true,
    have_php=true,
    final nHp=nHp,
    have_chiWat=true,
    final nPhp=nPhp,
    have_valHpInlIso=true,
    have_valHpOutIso=true,
    have_pumChiWatDedHp=false,
    final mHeaWatUni_flow_nominal=cat(1, fill(datHpPhp.mHeaWatHp_flow_nominal,
        nHp), fill(datHpPhp.mHeaWatPhp_flow_nominal, nPhp)),
    dpHeaWatUni_nominal=cat(1, fill(datHpPhp.dpHeaWatHp_nominal, nHp), fill(datHpPhp.dpHeaWatPhp_nominal,
                                      nPhp)),
    mChiWatUni_flow_nominal=cat(1, fill(datHpPhp.mChiWatHp_flow_nominal, nHp),
        fill(datHpPhp.mChiWatPhp_flow_nominal, nPhp)),
    final dpChiWatPhp_nominal=fill(datHpPhp.dpChiWatPhp_nominal, nPhp),
    final energyDynamics=energyDynamics,
    y_start=0)
    "Isolation valves – Heat pumps with common dedicated primary HW and CHW pumps, polyvalent HPs with dedicated primary pumps"
    annotation(Placement(transformation(extent={{-240,100},{240,240}})));
  Fluid.Sources.Boundary_pT supChiWat(
    redeclare final package Medium=Medium,
    p=Buildings.Templates.Data.Defaults.pChiWat_rel_nominal + 101325,
    nPorts=1)
    "Boundary condition at CHW supply"
    annotation(Placement(transformation(extent={{280,220},{260,240}})));
  Fluid.Sources.Boundary_pT supHeaWat(
    redeclare final package Medium=Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=1)
    "Boundary condition at HW supply"
    annotation(Placement(transformation(extent={{-280,160},{-260,180}})));
  Controls.OpenLoop ctl(final cfg=datCtl.cfg, final dat=datCtl)
    "Plant controller"
    annotation(Placement(transformation(extent={{-30,250},{-50,270}})));
  Buildings.Templates.Plants.HeatPumps.Components.ValvesIsolation valIsoSep(
    redeclare final package Medium=Medium,
    have_hp=true,
    have_php=true,
    final nHp=nHp,
    final nPhp=nPhp,
    have_chiWat=true,
    have_valHpInlIso=true,
    have_valPhpOutIso=true,
    have_pumChiWatDedHp=true,
    final mHeaWatUni_flow_nominal=cat(1, fill(datHpPhp.mHeaWatHp_flow_nominal,
        nHp), fill(datHpPhp.mHeaWatPhp_flow_nominal, nPhp)),
    dpHeaWatUni_nominal=cat(1, fill(datHpPhp.dpHeaWatHp_nominal, nHp), fill(
        datHpPhp.dpHeaWatPhp_nominal, nPhp)),
    mChiWatUni_flow_nominal=cat(1, fill(datHpPhp.mChiWatHp_flow_nominal, nHp),
        fill(datHpPhp.mChiWatPhp_flow_nominal, nPhp)),
    final dpChiWatPhp_nominal=fill(datHpPhp.dpChiWatPhp_nominal, nPhp),
    final energyDynamics=energyDynamics,
    y_start=0,
    from_dp=false)
    "Isolation valves - Plant with separate dedicated primary HW and CHW pumps"
    annotation(Placement(transformation(extent={{-240,-200},{240,-60}})));
  Controls.OpenLoop ctlSep(final cfg=datCtlSep.cfg, final dat=datCtlSep)
    "Plant controller"
    annotation(Placement(transformation(extent={{-30,-50},{-50,-30}})));
  Fluid.Movers.BaseClasses.IdealSource pumChiHeaWatPriHp[nHp](
    each m_flow_small=1E-6 *datHpPhp.mHeaWatHp_flow_nominal,
    each control_m_flow=false,
    each control_dp=true,
    redeclare package Medium=Medium)
    "Ideal pressure rise representing AWHP primary CHW/HW pump"
    annotation(Placement(transformation(extent={{20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi[nHp]
    "Switch pressure rise depending on operating mode"
    annotation(Placement(transformation(extent={{130,10},{110,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conDp[2, nHp](
    final k={-valIsoCom.dpHeaWat_nominal[1:nHp],
      -valIsoCom.dpChiWat_nominal[1:nHp]})
    annotation(Placement(transformation(extent={{270,-10},{250,10}})));
  Buildings.Templates.Plants.HeatPumps.Interfaces.Bus busPla1
    "Plant controller"
    annotation(Placement(iconVisible=false,
      transformation(extent={{80,240},{120,280}}),
      iconTransformation(extent={{-548,-190},{-508,-150}})));
  Buildings.Templates.Components.Interfaces.Bus busHp[nHp]
    "HP control bus"
    annotation(Placement(iconVisible=false,
      transformation(extent={{120,240},{160,280}}),
      iconTransformation(extent={{-536,100},{-496,140}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swiDpShcCon[nPhp]
    "Switch pressure rise depending on operating mode"
    annotation(Placement(transformation(extent={{100,40},{80,60}})));
  Buildings.Templates.Components.Interfaces.Bus busPhp[nPhp]
    "Polyvalent HP control bus"
    annotation(Placement(iconVisible=false,
      transformation(extent={{200,240},{240,280}}),
      iconTransformation(extent={{-536,100},{-496,140}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conDp1[2, nPhp](
    final k={-valIsoCom.dpHeaWat_nominal[nHp + 1:nHp + nPhp], fill(0, nPhp)})
    annotation(Placement(transformation(extent={{240,30},{220,50}})));
  Fluid.Movers.BaseClasses.IdealSource pumHeaWatPriPhp[nPhp](
    each m_flow_small=1E-6*datHpPhp.mHeaWatPhp_flow_nominal,
    each control_m_flow=false,
    each control_dp=true,
    redeclare package Medium=Medium)
    "Ideal pressure rise representing polyvalent HP primary HW pump"
    annotation(Placement(transformation(extent={{20,26},{0,46}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swiDpShcCon1[nPhp]
    "Switch pressure rise depending on operating mode"
    annotation(Placement(transformation(extent={{130,70},{110,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conDp2[2, nPhp](
    final k={-valIsoCom.dpChiWat_nominal[nHp + 1:nHp + nPhp], fill(0, nPhp)})
    annotation(Placement(transformation(extent={{270,60},{250,80}})));
  Fluid.Movers.BaseClasses.IdealSource pumChiWatPriPhp[nPhp](
    each m_flow_small=1E-6*datHpPhp.mChiWatPhp_flow_nominal,
    each control_m_flow=false,
    each control_dp=true,
    redeclare package Medium=Medium)
    "Ideal pressure rise representing polyvalent HP primary CHW pump"
    annotation(Placement(transformation(extent={{20,56},{0,76}})));
  Fluid.Sources.Boundary_pT supHeaWat1(
    redeclare final package Medium=Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=1)
    "Boundary condition at HW supply"
    annotation(Placement(transformation(extent={{-130,-290},{-110,-270}})));
  Buildings.Templates.Plants.HeatPumps.Interfaces.Bus busPla
    "Plant controller"
    annotation(Placement(iconVisible=false,
      transformation(extent={{80,-60},{120,-20}}),
      iconTransformation(extent={{-548,-190},{-508,-150}})));
  Fluid.Movers.Preconfigured.SpeedControlled_y pumChiWatPri[nHp + nPhp](
    redeclare each final package Medium=Medium,
    each addPowerToMedium=false,
    final m_flow_nominal=cat(1, fill(datHpPhp.mChiWatHp_flow_nominal, nHp),
        fill(datHpPhp.mChiWatPhp_flow_nominal, nPhp)),
    each final energyDynamics=energyDynamics,
    dp_nominal=valIsoSep.dpChiWat_nominal)
    "Primary CHW pump"
    annotation(Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=-90,
      origin={-40,-280})));
  Fluid.Movers.Preconfigured.SpeedControlled_y pumHeaWatPri[nHp + nPhp](
    redeclare each final package Medium=Medium,
    each addPowerToMedium=false,
    final m_flow_nominal=cat(1, fill(datHpPhp.mHeaWatHp_flow_nominal, nHp),
        fill(datHpPhp.mHeaWatPhp_flow_nominal, nPhp)),
    each final energyDynamics=energyDynamics,
    dp_nominal=valIsoSep.dpHeaWat_nominal)
    "Primary HW pump"
    annotation(Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=-90,
      origin={-80,-260})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal yPumHeaWatPri[nHp + nPhp]
    "Primary HW pump speed command"
    annotation(Placement(transformation(extent={{100,-270},{80,-250}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal yPumChiWatPri[nHp + nPhp]
    "Primary CHW pump speed command"
    annotation(Placement(transformation(extent={{130,-290},{110,-270}})));
  Buildings.Templates.Components.Interfaces.Bus busPumHeaWatPri
    "Primary HW pump control bus"
    annotation(Placement(iconVisible=false,
      transformation(extent={{120,-280},{160,-240}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatPri
    "Primary CHW pump control bus"
    annotation(Placement(iconVisible=false,
      transformation(extent={{140,-300},{180,-260}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Fluid.FixedResistances.PressureDrop hpSep[nHp](
    redeclare each final package Medium=Medium,
    each m_flow_nominal=datHpPhp.mHeaWatHp_flow_nominal,
    each dp_nominal=0)
    "Heat pump HX with zero fluid resistance: pressure drop computed in valve component"
    annotation(Placement(transformation(extent={{10,-330},{-10,-310}})));
equation
  connect(valIsoCom.port_bChiWat, supChiWat.ports[1])
    annotation(Line(points={{240,230},{260,230}},
      color={0,127,255}));
  connect(valIsoCom.port_bHeaWat, supHeaWat.ports[1])
    annotation(Line(points={{-240,170},{-260,170}},
      color={0,127,255}));
  connect(ctl.bus, valIsoCom.bus)
    annotation(Line(points={{-30,260},{0,260},{0,210}},
      color={255,204,51},
      thickness=0.5));
  connect(ctlSep.bus, valIsoSep.bus)
    annotation(Line(points={{-30,-40},{0,-40},{0,-90}},
      color={255,204,51},
      thickness=0.5));
  connect(valIsoCom.port_bChiWat, valIsoCom.port_aChiWat)
    annotation(Line(points={{240,230},{240,190}},
      color={0,127,255}));
  connect(valIsoCom.port_bHeaWat, valIsoCom.port_aHeaWat)
    annotation(Line(points={{-240,170},{-240,210}},
      color={0,127,255}));
  connect(valIsoCom.ports_bChiHeaWatHp, pumChiHeaWatPriHp.port_a)
    annotation(Line(points={{66,100},{66,0},{20,0}},
      color={0,127,255}));
  connect(pumChiHeaWatPriHp.port_b, valIsoCom.ports_aChiHeaWatHp)
    annotation(Line(points={{0,0},{-44,0},{-44,100}},
      color={0,127,255}));
  connect(ctl.bus, busPla1)
    annotation(Line(points={{-30,260},{100,260}},
      color={255,204,51},
      thickness=0.5));
  connect(swi.y, pumChiHeaWatPriHp.dp_in)
    annotation(Line(points={{108,20},{4,20},{4,8}},
      color={0,0,127}));
  connect(busPla1.hp, busHp)
    annotation(Line(points={{100,260},{140,260}},
      color={255,204,51},
      thickness=0.5));
  connect(busHp.y1Hea, swi.u2)
    annotation(Line(points={{140,260},{202,260},{202,20},{132,20}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla1.php, busPhp)
    annotation(Line(points={{100,260},{220,260}},
      color={255,204,51},
      thickness=0.5));
  connect(busPhp.y1Hea, swiDpShcCon.u2)
    annotation(Line(points={{220,260},{220,50},{102,50}},
      color={255,204,51},
      thickness=0.5));
  connect(valIsoCom.ports_bHeaWatPhp,pumHeaWatPriPhp. port_a)
    annotation(Line(points={{50,100},{40,100},{40,36},{20,36}},
      color={0,127,255}));
  connect(pumHeaWatPriPhp.port_b, valIsoCom.ports_aHeaWatPhp)
    annotation(Line(points={{0,36},{-28,36},{-28,100}},
      color={0,127,255}));
  connect(swiDpShcCon.y,pumHeaWatPriPhp. dp_in)
    annotation(Line(points={{78,50},{4,50},{4,44}},
      color={0,0,127}));
  connect(busPhp.y1Coo, swiDpShcCon1.u2)
    annotation(Line(points={{220,260},{220,80},{132,80}},
      color={255,204,51},
      thickness=0.5));
  connect(swiDpShcCon1.y,pumChiWatPriPhp. dp_in)
    annotation(Line(points={{108,80},{4,80},{4,74}},
      color={0,0,127}));
  connect(valIsoCom.ports_bChiWatPhp,pumChiWatPriPhp. port_a)
    annotation(Line(points={{34,100},{34,66},{20,66}},
      color={0,127,255}));
  connect(pumChiWatPriPhp.port_b, valIsoCom.ports_aChiWatPhp)
    annotation(Line(points={{0,66},{-12,66},{-12,100}},
      color={0,127,255}));
  connect(conDp[2, :].y, swi.u3)
    annotation(Line(points={{248,0},{140,0},{140,12},{132,12}},
      color={0,0,127}));
  connect(conDp[1, :].y, swi.u1)
    annotation(Line(points={{248,0},{140,0},{140,28},{132,28}},
      color={0,0,127}));
  connect(conDp2[1, :].y, swiDpShcCon1.u1)
    annotation(Line(points={{248,70},{140,70},{140,88},{132,88}},
      color={0,0,127}));
  connect(conDp2[2, :].y, swiDpShcCon1.u3)
    annotation(Line(points={{248,70},{140,70},{140,72},{132,72}},
      color={0,0,127}));
  connect(conDp1[1, :].y, swiDpShcCon.u1)
    annotation(Line(points={{218,40},{120,40},{120,58},{102,58}},
      color={0,0,127}));
  connect(conDp1[2, :].y, swiDpShcCon.u3)
    annotation(Line(points={{218,40},{120,40},{120,42},{102,42}},
      color={0,0,127}));
  connect(valIsoSep.port_bHeaWat, valIsoSep.port_aHeaWat)
    annotation(Line(points={{-240,-130},{-240,-90}},
      color={0,127,255}));
  connect(valIsoSep.port_bChiWat, valIsoSep.port_aChiWat)
    annotation(Line(points={{240,-70},{240,-110}},
      color={0,127,255}));
  connect(ctlSep.bus, busPla)
    annotation(Line(points={{-30,-40},{100,-40}},
      color={255,204,51},
      thickness=0.5));
  connect(busPumHeaWatPri.y1, yPumHeaWatPri.u)
    annotation(Line(points={{140,-260},{102,-260}},
      color={255,204,51},
      thickness=0.5));
  connect(yPumHeaWatPri.y, pumHeaWatPri.y)
    annotation(Line(points={{78,-260},{-68,-260}},
      color={0,0,127}));
  connect(busPumChiWatPri.y1, yPumChiWatPri.u)
    annotation(Line(points={{160,-280},{132,-280}},
      color={255,204,51},
      thickness=0.5));
  connect(yPumChiWatPri.y, pumChiWatPri.y)
    annotation(Line(points={{108,-280},{-28,-280}},
      color={0,0,127}));
  connect(valIsoSep.ports_bChiWatPhp, pumChiWatPri[nHp + 1:nHp + nPhp].port_a)
    annotation(Line(points={{34,-200},{34,-296},{-40,-296},{-40,-290}},
      color={0,127,255}));
  connect(busPla.pumHeaWatPri, busPumHeaWatPri)
    annotation(Line(points={{100,-40},{280,-40},{280,-260},{140,-260}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla.pumChiWatPri, busPumChiWatPri)
    annotation(Line(points={{100,-40},{280,-40},{280,-280},{160,-280}},
      color={255,204,51},
      thickness=0.5));
  connect(valIsoSep.ports_bChiHeaWatHp, hpSep.port_a)
    annotation(Line(points={{66,-200},{66,-320},{10,-320}},
      color={0,127,255}));
  connect(hpSep.port_b, pumChiWatPri[1:nHp].port_a)
    annotation(Line(points={{-10,-320},{-40,-320},{-40,-290}},
      color={0,127,255}));
  connect(hpSep.port_b, pumHeaWatPri[1:nHp].port_a)
    annotation(Line(points={{-10,-320},{-80,-320},{-80,-270}},
      color={0,127,255}));
  connect(valIsoSep.ports_bHeaWatPhp, pumHeaWatPri[nHp + 1:nHp + nPhp].port_a)
    annotation(Line(points={{50,-200},{50,-300},{-80,-300},{-80,-270}},
      color={0,127,255}));
  connect(supHeaWat1.ports[1], pumHeaWatPri[1].port_a)
    annotation(Line(points={{-110,-280},{-80,-280},{-80,-270}},
      color={0,127,255}));
  connect(pumChiWatPri[1:nHp].port_b, valIsoSep.ports_aChiWatHp)
    annotation(Line(points={{-40,-270},{-40,-240},{-60,-240},{-60,-200}},
      color={0,127,255}));
  connect(pumHeaWatPri[1:nHp].port_b, valIsoSep.ports_aHeaWatHp)
    annotation(Line(points={{-80,-250},{-80,-200},{-76,-200}},
      color={0,127,255}));
  connect(pumHeaWatPri[nHp + 1:nHp + nPhp].port_b, valIsoSep.ports_aHeaWatPhp)
    annotation(Line(points={{-80,-250},{-80,-220},{-28,-220},{-28,-200}},
      color={0,127,255}));
  connect(pumChiWatPri[nHp + 1:nHp + nPhp].port_b, valIsoSep.ports_aChiWatPhp)
    annotation(Line(points={{-40,-270},{-40,-240},{-12,-240},{-12,-200}},
      color={0,127,255}));
annotation(__Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/HeatPumps/Components/Validation/ValvesIsolationPolyvalent.mos"
    "Simulate and plot"),
  experiment(Tolerance=1e-6,
    StopTime=5000.0),
  Diagram(coordinateSystem(extent={{-300,-400},{300,400}})),
  Documentation(
    revisions="<html>
<ul>
  <li>
    July 10, 2026, by Antoine Gautier:<br />
    First implementation.
  </li>
</ul>
</html>",
    info="<html>
<p>
  This model validates the model
  <a href=\"modelica://Buildings.Templates.Plants.HeatPumps.Components.ValvesIsolation\">
    Buildings.Templates.Plants.HeatPumps.Components.ValvesIsolation</a>
  for two configurations, each with two identical AWHP and two identical
  polyvalent units.
</p>

<ul>
  <li>
    AWHP with isolation valves at both the inlet and outlet, polyvalent units
    without isolation valves: component <code>valIsoCom</code>.
  </li>
  <li>
    AWHP with isolation valves at the inlet only, polyvalent units with
    isolation valves at the outlet only: component <code>valIsoSep</code>.
  </li>
</ul>
<p>
  Open-loop controls are used throughout. The simulation allows verifying that
  the design flow rate is achieved in each unit when the isolation valves are
  open and/or the primary pumps are on.
</p>
</html>"));
end ValvesIsolationPolyvalent;
