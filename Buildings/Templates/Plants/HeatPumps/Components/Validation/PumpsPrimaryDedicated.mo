within Buildings.Templates.Plants.HeatPumps.Components.Validation;
model PumpsPrimaryDedicated
  "Validation model for dedicated primary pump component"
  extends Modelica.Icons.Example;

  replaceable package Medium = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CHW/HW medium";

  parameter Integer nHp = 2
    "Number of heat pumps (excluding SHC units)"
    annotation(Evaluate=true);
  parameter Boolean use_spePumIni = false
    "Set to true to compute pump speed at initialization, false to use default value"
    annotation(Evaluate=true);
  parameter Modelica.Fluid.Types.Dynamics energyDynamics =
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true,
      Dialog(tab="Dynamics",
        group="Conservation equations"));
  // Calculation of pump speed to meet design flow.
  parameter Real r_N[datPumHeaWatHea.nPum](
    each fixed=false,
    each start=1,
    each unit="1")
    "Relative revolution, r_N=N/N_nominal";
  parameter Real r_NDef[datPumHeaWatHea.nPum](each start=1, each unit="1") =
    fill(0.85, datPumHeaWatHea.nPum)
    "Default value for relative revolution, r_N=N/N_nominal";
  parameter Data.Controller datCtl(
    cfg(
      have_inpSch=false,
      have_hp=true,
      have_hrc=false,
      have_valHpOutIso=false,
      have_valHpInlIso=true,
      have_valShcOutIso=false,
      have_valShcInlIso=false,
      have_chiWat=true,
      have_shc=false,
      nShc=0,
      is_shcMod=false,
      typPumHeaWatPriHp=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Constant,
      typPumChiWatPriHp=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None,
      typPumHeaWatPriShc=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None,
      typPumChiWatPriShc=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None,
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
      final nPumHeaWatPri=nHp,
      have_heaWat=true,
      nPumHeaWatSec=0,
      rhoSou_default=Buildings.Media.Air.dStp,
      have_senDpHeaWatRemWir=true,
      typPumChiWatSec=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None,
      nPumChiWatPri=0,
      nSenDpHeaWatRem=0,
      nSenDpChiWatRem=0,
      nAirHan=0,
      nEquZon=0,
      have_pumPriComHp=true),
    THeaWatSup_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    TChiWatSup_nominal=Buildings.Templates.Data.Defaults.TChiWatSup,
    dpChiWatRemSet_max=fill(
      Buildings.Templates.Data.Defaults.dpChiWatRemSet_max,
      datCtl.cfg.nSenDpChiWatRem),
    dpHeaWatRemSet_max=fill(
      Buildings.Templates.Data.Defaults.dpHeaWatRemSet_max,
      datCtl.cfg.nSenDpHeaWatRem),
    staEqu={fill(1, datCtl.cfg.nHp)})
    "Controller parameters"
    annotation(Placement(transformation(extent={{-160,300},{-140,320}})));
  parameter Data.Controller datCtlNoDed(
    cfg(
      have_inpSch=false,
      have_hp=true,
      have_hrc=false,
      have_valHpOutIso=false,
      have_valHpInlIso=true,
      have_valShcOutIso=false,
      have_valShcInlIso=false,
      have_chiWat=true,
      have_shc=false,
      nShc=0,
      is_shcMod=false,
      typPumHeaWatPriHp=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable,
      typPumChiWatPriHp=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable,
      typPumHeaWatPriShc=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None,
      typPumChiWatPriShc=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None,
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
      typArrPumPri=Buildings.Templates.Components.Types.PumpArrangement.Headered,
      final nHp=nHp,
      final nPumHeaWatPri=nHp,
      have_heaWat=true,
      nPumHeaWatSec=0,
      rhoSou_default=Buildings.Media.Air.dStp,
      have_senDpHeaWatRemWir=true,
      typPumChiWatSec=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None,
      nPumChiWatPri=nHp,
      nSenDpHeaWatRem=0,
      nSenDpChiWatRem=0,
      nAirHan=0,
      nEquZon=0,
      have_pumPriComHp=false),
    THeaWatSup_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    TChiWatSup_nominal=Buildings.Templates.Data.Defaults.TChiWatSup,
    dpChiWatRemSet_max=fill(
      Buildings.Templates.Data.Defaults.dpChiWatRemSet_max,
      datCtlNoDed.cfg.nSenDpChiWatRem),
    dpHeaWatRemSet_max=fill(
      Buildings.Templates.Data.Defaults.dpHeaWatRemSet_max,
      datCtlNoDed.cfg.nSenDpHeaWatRem),
    staEqu={fill(1, datCtlNoDed.cfg.nHp)})
    "Controller parameters"
    annotation(Placement(transformation(extent={{-160,120},{-140,140}})));
  parameter Data.Controller datCtlSep(
    cfg(
      have_inpSch=false,
      have_hp=true,
      have_hrc=false,
      have_valHpOutIso=false,
      have_valHpInlIso=true,
      have_valShcOutIso=false,
      have_valShcInlIso=false,
      have_chiWat=true,
      have_shc=false,
      nShc=0,
      is_shcMod=false,
      typPumHeaWatPriHp=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Constant,
      typPumChiWatPriHp=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Constant,
      typPumHeaWatPriShc=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None,
      typPumChiWatPriShc=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None,
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
      final nPumHeaWatPri=nHp,
      final nPumChiWatPri=nHp,
      have_heaWat=true,
      nPumHeaWatSec=0,
      rhoSou_default=Buildings.Media.Air.dStp,
      have_senDpHeaWatRemWir=true,
      typPumChiWatSec=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None,
      nSenDpHeaWatRem=0,
      nSenDpChiWatRem=0,
      nAirHan=0,
      nEquZon=0,
      have_pumPriComHp=false),
    THeaWatSup_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    TChiWatSup_nominal=Buildings.Templates.Data.Defaults.TChiWatSup,
    dpChiWatRemSet_max=fill(
      Buildings.Templates.Data.Defaults.dpChiWatRemSet_max,
      datCtlSep.cfg.nSenDpChiWatRem),
    dpHeaWatRemSet_max=fill(
      Buildings.Templates.Data.Defaults.dpHeaWatRemSet_max,
      datCtlSep.cfg.nSenDpHeaWatRem),
    staEqu={fill(1, datCtlSep.cfg.nHp)})
    "Controller parameters"
    annotation(Placement(transformation(extent={{-160,-120},{-140,-100}})));
  parameter Data.Controller datCtlHea(
    cfg(
      have_inpSch=false,
      have_hp=true,
      have_hrc=false,
      have_valHpOutIso=false,
      have_valHpInlIso=false,
      have_valShcOutIso=false,
      have_valShcInlIso=false,
      have_chiWat=false,
      have_shc=false,
      nShc=0,
      is_shcMod=false,
      typPumHeaWatPriHp=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable,
      typPumChiWatPriHp=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None,
      typPumHeaWatPriShc=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None,
      typPumChiWatPriShc=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None,
      typPumHeaWatSec=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None,
      typTanHeaWat=Buildings.Templates.Components.Types.IntegrationPoint.None,
      typTanChiWat=Buildings.Templates.Components.Types.IntegrationPoint.None,
      typDis=Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Only,
      nPumChiWatSec=0,
      rhoHeaWat_default=Buildings.Media.Water.d_const,
      typCtl=Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop,
      is_rev=false,
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
      final nPumHeaWatPri=nHp,
      nPumChiWatPri=0,
      have_heaWat=true,
      nPumHeaWatSec=0,
      rhoSou_default=Buildings.Media.Air.dStp,
      have_senDpHeaWatRemWir=true,
      typPumChiWatSec=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None,
      nSenDpHeaWatRem=0,
      nSenDpChiWatRem=0,
      nAirHan=0,
      nEquZon=0,
      have_pumPriComHp=false),
    THeaWatSup_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    dpChiWatRemSet_max=fill(
      Buildings.Templates.Data.Defaults.dpChiWatRemSet_max,
      datCtlHea.cfg.nSenDpChiWatRem),
    dpHeaWatRemSet_max=fill(
      Buildings.Templates.Data.Defaults.dpHeaWatRemSet_max,
      datCtlHea.cfg.nSenDpHeaWatRem),
    staEqu={fill(1, datCtlHea.cfg.nHp)})
    "Controller parameters"
    annotation(Placement(transformation(extent={{-160,-360},{-140,-340}})));
  parameter Data.HeatPumpGroup datHp(
    have_hp=true,
    have_shc=false,
    final typHp=Buildings.Templates.Components.Types.HeatPump.AirToWater,
    final is_rev=true,
    mHeaWatHp_flow_nominal=datHp.capHeaHp_nominal / abs(
      datHp.THeaWatSupHp_nominal -
        Buildings.Templates.Data.Defaults.THeaWatRetMed) /
      Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    dpHeaWatHp_nominal=Buildings.Templates.Data.Defaults.dpHeaWatHp,
    capHeaHp_nominal=500E3,
    THeaWatSupHp_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    TSouHeaHp_nominal=Buildings.Templates.Data.Defaults.TOutHpHeaLow,
    mChiWatHp_flow_nominal=datHp.capCooHp_nominal / abs(
      datHp.TChiWatSupHp_nominal -
        Buildings.Templates.Data.Defaults.TChiWatRet) /
      Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    capCooHp_nominal=500E3,
    TChiWatSupHp_nominal=Buildings.Templates.Data.Defaults.TChiWatSup,
    TSouCooHp_nominal=Buildings.Templates.Data.Defaults.TOutHpCoo,
    PHp_min=1.0E3,
    perHeaHp(
      fileName=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Templates/Components/HeatPumps/Validation/AWHP_Heating.txt"),
      PLRSup={1},
      use_TEvaOutForTab=false,
      use_TConOutForTab=true,
      tabUppBou=[263.15, 323.15; 313.15, 323.15]),
    perCooHp(
      fileName=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Templates/Components/HeatPumps/Validation/AWHP_Cooling.txt"),
      PLRSup={1}))
    "Reversible AWHP parameters"
    annotation(Placement(transformation(extent={{-280,20},{-260,40}})));
  parameter Buildings.Templates.Components.Data.PumpMultiple datPumPriCom(
    typ=Buildings.Templates.Components.Types.Pump.Multiple,
    nPum=nHp,
    m_flow_nominal=fill(
      max(datHp.mHeaWatHp_flow_nominal, datHp.mChiWatHp_flow_nominal), nHp),
    dp_nominal=fill(
      max(datHp.dpHeaWatHp_nominal, datHp.dpChiWatHp_nominal) +
        Buildings.Templates.Data.Defaults.dpValChe + max(
        max(valChiWatIsoCom.dpValve_nominal),
        max(valHeaWatIsoCom.dpValve_nominal)),
      nHp))
    "Primary pump parameters"
    annotation(Placement(transformation(extent={{-120,220},{-100,240}})));
  parameter Buildings.Templates.Components.Data.PumpMultiple datPumHeaWat(
    typ=Buildings.Templates.Components.Types.Pump.Multiple,
    nPum=nHp,
    m_flow_nominal=fill(datHp.mHeaWatHp_flow_nominal, nHp),
    dp_nominal=fill(
      datHp.dpHeaWatHp_nominal + Buildings.Templates.Data.Defaults.dpValChe +
        max(valHeaWatIsoCom.dpValve_nominal),
      nHp))
    "Dedicated primary HW pump parameters"
    annotation(Placement(transformation(extent={{-160,-200},{-140,-180}})));
  parameter Buildings.Templates.Components.Data.PumpMultiple datPumChiWat(
    typ=Buildings.Templates.Components.Types.Pump.Multiple,
    final nPum=nHp,
    m_flow_nominal=fill(datHp.mChiWatHp_flow_nominal, nHp),
    dp_nominal=fill(
      datHp.dpChiWatHp_nominal + Buildings.Templates.Data.Defaults.dpValChe +
        max(valHeaWatIsoCom.dpValve_nominal),
      nHp))
    "Dedicated primary CHW pump parameters"
    annotation(Placement(transformation(extent={{-120,-200},{-100,-180}})));
  parameter Buildings.Templates.Components.Data.PumpMultiple datPumHeaWatHea(
    typ=Buildings.Templates.Components.Types.Pump.Multiple,
    final nPum=nHp,
    m_flow_nominal=fill(datHp.mHeaWatHp_flow_nominal, nHp),
    dp_nominal=1.5 * fill(
      datHp.dpHeaWatHp_nominal + Buildings.Templates.Data.Defaults.dpValChe +
        max(valHeaWatIsoCom.dpValve_nominal),
      nHp))
    "Dedicated primary HW pump parameters – Heating-only system"
    annotation(Placement(transformation(extent={{-160,-400},{-140,-380}})));
  parameter Buildings.Templates.Components.Data.PumpMultiple datPumHeaWatHdr(
    typ=Buildings.Templates.Components.Types.Pump.Multiple,
    nPum=nHp,
    m_flow_nominal=fill(
      datHp.mHeaWatHp_flow_nominal * nHp / datPumHeaWatHdr.nPum,
      datPumHeaWatHdr.nPum),
    dp_nominal=fill(
      datHp.dpHeaWatHp_nominal + Buildings.Templates.Data.Defaults.dpValChe +
        max(valHeaWatIsoHdr.dpValve_nominal),
      datPumHeaWatHdr.nPum))
    "Headered primary HW pump parameters"
    annotation(Placement(transformation(extent={{-160,60},{-140,80}})));
  parameter Buildings.Templates.Components.Data.PumpMultiple datPumChiWatHdr(
    typ=Buildings.Templates.Components.Types.Pump.Multiple,
    final nPum=nHp,
    m_flow_nominal=fill(
      datHp.mChiWatHp_flow_nominal * nHp / datPumChiWatHdr.nPum,
      datPumChiWatHdr.nPum),
    dp_nominal=fill(
      datHp.dpChiWatHp_nominal + Buildings.Templates.Data.Defaults.dpValChe +
        max(valChiWatIsoHdr.dpValve_nominal),
      datPumChiWatHdr.nPum))
    "Headered primary CHW pump parameters"
    annotation(Placement(transformation(extent={{-120,60},{-100,80}})));
  final parameter Buildings.Templates.Components.Data.PumpSingle datPumSin[nHp](
    each typ=datPumPriCom.typ,
    m_flow_nominal=datPumPriCom.m_flow_nominal,
    dp_nominal=datPumPriCom.dp_nominal,
    per=datPumPriCom.per,
    each rho_default=datPumPriCom.rho_default)
    "Cast multiple pump record into single pump record array";
  final parameter Buildings.Templates.Components.Data.PumpSingle datPumHeaWatHeaSin[nHp](
    each typ=datPumHeaWatHea.typ,
    m_flow_nominal=datPumHeaWatHea.m_flow_nominal,
    dp_nominal=datPumHeaWatHea.dp_nominal,
    per=datPumHeaWatHea.per,
    each rho_default=datPumHeaWatHea.rho_default)
    "Cast multiple pump record into single pump record array";
  Buildings.Templates.Plants.HeatPumps.Components.PumpsPrimaryDedicated pumPriCom(
    redeclare final package Medium=Medium,
    final nPumHeaWat=nHp,
    final nPumChiWat=0,
    final nHp=nHp,
    typArrPumPri=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
    have_pumPriComHp=true,
    have_pumHeaWatPriVar=false,
    have_pumChiWatPriVar=false,
    datPumHeaWat=datPumPriCom,
    final energyDynamics=energyDynamics)
    "Primary pumps - Heating and cooling system with common constant speed dedicated primary pumps"
    annotation(Placement(transformation(extent={{-240,160},{240,240}})));
  Fluid.FixedResistances.PressureDrop hpCom[nHp](
    redeclare each final package Medium=Medium,
    each m_flow_nominal=datHp.mHeaWatHp_flow_nominal,
    each dp_nominal=datHp.dpHeaWatHp_nominal)
    "Heat pump HX"
    annotation(Placement(transformation(extent={{10,150},{-10,170}})));
  Fluid.Sources.Boundary_pT ret(
    redeclare final package Medium=Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=nHp)
    "Boundary condition at return"
    annotation(Placement(transformation(extent={{120,270},{100,290}})));
  Controls.OpenLoop ctl(final cfg=datCtl.cfg, final dat=datCtl)
    "Plant controller"
    annotation(Placement(transformation(extent={{-100,290},{-120,310}})));
  Buildings.Templates.Plants.HeatPumps.Components.PumpsPrimaryDedicated pumPriNoDed(
    redeclare final package Medium=Medium,
    nPumHeaWat=0,
    nPumChiWat=0,
    final nHp=nHp,
    typArrPumPri=Buildings.Templates.Components.Types.PumpArrangement.Headered,
    have_pumHeaWatPriVar=false,
    have_pumChiWatPriVar=false,
    datPumHeaWat=datPumPriCom,
    final energyDynamics=energyDynamics)
    "No dedicated primary pumps (headered pumps)"
    annotation(Placement(transformation(extent={{-240,-60},{240,20}})));
  Fluid.FixedResistances.PressureDrop hpHdr[nHp](
    redeclare each final package Medium=Medium,
    each m_flow_nominal=datHp.mHeaWatHp_flow_nominal,
    each dp_nominal=datHp.dpHeaWatHp_nominal)
    "Heat pump HX"
    annotation(Placement(transformation(extent={{10,-70},{-10,-50}})));
  Fluid.Sources.Boundary_pT ret1(
    redeclare final package Medium=Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=nHp)
    "Boundary condition at return"
    annotation(Placement(transformation(extent={{120,70},{100,90}})));
  Controls.OpenLoop ctlNoDed(final cfg=datCtlNoDed.cfg, final dat=datCtlNoDed)
    "Plant controller"
    annotation(Placement(transformation(extent={{-100,110},{-120,130}})));
  Buildings.Templates.Components.Pumps.Multiple pumHeaWatPriHdr(
    have_var=false,
    final energyDynamics=energyDynamics,
    nPum=nHp,
    dat=datPumHeaWatHdr)
    "Headered primary HW pumps"
    annotation(Placement(transformation(extent={{-70,70},{-50,90}})));
  Buildings.Templates.Plants.HeatPumps.Interfaces.Bus busPla
    "Plant control bus"
    annotation(Placement(iconVisible=false,
      transformation(extent={{-100,100},{-60,140}}),
      iconTransformation(extent={{-332,42},{-292,82}})));
  Buildings.Templates.Plants.HeatPumps.Components.PumpsPrimaryDedicated pumPriSep(
    redeclare final package Medium=Medium,
    final nPumHeaWat=nHp,
    final nPumChiWat=nHp,
    final nHp=nHp,
    typArrPumPri=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
    have_pumPriComHp=false,
    have_pumHeaWatPriVar=false,
    have_pumChiWatPriVar=false,
    datPumHeaWat=datPumHeaWat,
    final datPumChiWat=datPumChiWat,
    final energyDynamics=energyDynamics)
    "Primary pumps - Heating and cooling system with separate constant speed dedicated CHW pumps"
    annotation(Placement(transformation(extent={{-240,-260},{240,-180}})));
  Controls.OpenLoop ctlSep(final cfg=datCtlSep.cfg, final dat=datCtlSep)
    "Plant controller"
    annotation(Placement(transformation(extent={{-100,-130},{-120,-110}})));
  Fluid.FixedResistances.PressureDrop hpSep[nHp](
    redeclare each final package Medium=Medium,
    each m_flow_nominal=datHp.mHeaWatHp_flow_nominal,
    each dp_nominal=datHp.dpHeaWatHp_nominal)
    "Heat pump HX"
    annotation(Placement(transformation(extent={{10,-270},{-10,-250}})));
  Buildings.Templates.Components.Actuators.Valve valHeaWatIsoCom[nHp](
    redeclare each final package Medium=Medium,
    each typ=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition,
    dat(
      each m_flow_nominal=datHp.mHeaWatHp_flow_nominal,
      each dpValve_nominal=Buildings.Templates.Data.Defaults.dpValIso,
      dpFixed_nominal=Buildings.Templates.Utilities.computeBalancingPressureDrop(
        m_flow_nominal=fill(datHp.mHeaWatHp_flow_nominal, nHp),
        dp_nominal=pumPriCom.dpValCheHeaWat_nominal *
          (datHp.mHeaWatHp_flow_nominal / max(
            datHp.mHeaWatHp_flow_nominal,
            datHp.mChiWatHp_flow_nominal)) ^ 2 .+ fill(
            datHp.dpHeaWatHp_nominal,
            nHp) .+ valHeaWatIsoCom.dpValve_nominal,
        datPum=datPumSin)),
    each from_dp=true)
    "Primary HW loop isolation valve"
    annotation(Placement(transformation(extent={{-30,270},{-10,290}})));
  Buildings.Templates.Components.Actuators.Valve valChiWatIsoCom[nHp](
    redeclare each final package Medium=Medium,
    each typ=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition,
    dat(
      each m_flow_nominal=datHp.mChiWatHp_flow_nominal,
      each dpValve_nominal=Buildings.Templates.Data.Defaults.dpValIso,
      dpFixed_nominal=Buildings.Templates.Utilities.computeBalancingPressureDrop(
        m_flow_nominal=fill(datHp.mChiWatHp_flow_nominal, nHp),
        dp_nominal=pumPriCom.dpValCheHeaWat_nominal *
          (datHp.mChiWatHp_flow_nominal / max(
            datHp.mHeaWatHp_flow_nominal,
            datHp.mChiWatHp_flow_nominal)) ^ 2 .+ fill(
            datHp.dpChiWatHp_nominal,
            nHp) .+ valChiWatIsoCom.dpValve_nominal,
        datPum=datPumSin)),
    each from_dp=true)
    "Primary CHW loop isolation valve"
    annotation(Placement(transformation(extent={{10,250},{30,270}})));
  Buildings.Templates.Plants.HeatPumps.Interfaces.Bus busPla1
    "Plant control bus"
    annotation(Placement(iconVisible=false,
      transformation(extent={{-90,280},{-50,320}}),
      iconTransformation(extent={{-332,42},{-292,82}})));
  Buildings.Templates.Components.Actuators.Valve valChiWatIsoHdr[nHp](
    redeclare each final package Medium=Medium,
    each typ=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition,
    dat(
      each m_flow_nominal=datHp.mChiWatHp_flow_nominal,
      each dpValve_nominal=Buildings.Templates.Data.Defaults.dpValIso,
      each dpFixed_nominal=0),
    each from_dp=true)
    "Primary CHW loop isolation valve"
    annotation(Placement(transformation(extent={{30,30},{50,50}})));
  Buildings.Templates.Components.Actuators.Valve valHeaWatIsoHdr[nHp](
    redeclare each final package Medium=Medium,
    each typ=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition,
    dat(
      each m_flow_nominal=datHp.mHeaWatHp_flow_nominal,
      each dpValve_nominal=Buildings.Templates.Data.Defaults.dpValIso,
      each dpFixed_nominal=0),
    each from_dp=true)
    "Primary HW loop isolation valve"
    annotation(Placement(transformation(extent={{-30,70},{-10,90}})));
  Buildings.Templates.Plants.HeatPumps.Interfaces.Bus busPla2
    "Plant control bus"
    annotation(Placement(iconVisible=false,
      transformation(extent={{-100,-140},{-60,-100}}),
      iconTransformation(extent={{-332,42},{-292,82}})));
  Buildings.Templates.Plants.HeatPumps.Components.PumpsPrimaryDedicated pumPriHea(
    redeclare final package Medium=Medium,
    nPumHeaWat=nHp,
    nPumChiWat=0,
    final nHp=nHp,
    typArrPumPri=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
    have_pumPriComHp=false,
    have_pumHeaWatPriVar=true,
    have_pumChiWatPriVar=false,
    datPumHeaWat=datPumHeaWatHea,
    final energyDynamics=energyDynamics)
    "Primary pumps - Heating-only system with variable speed dedicated primary pumps"
    annotation(Placement(transformation(extent={{-240,-460},{240,-380}})));
  Fluid.Sources.Boundary_pT ret3(
    redeclare final package Medium=Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=1)
    "Boundary condition at return"
    annotation(Placement(transformation(extent={{120,-350},{100,-330}})));
  Controls.OpenLoop ctlHea(
    final cfg=datCtlHea.cfg,
    final dat=datCtlHea,
    yPumHeaWatPriDed(k=r_N))
    "Plant controller"
    annotation(Placement(transformation(extent={{-100,-370},{-120,-350}})));
  Fluid.FixedResistances.PressureDrop hpHea[nHp](
    redeclare each final package Medium=Medium,
    each m_flow_nominal=datHp.mHeaWatHp_flow_nominal,
    each dp_nominal=datHp.dpHeaWatHp_nominal)
    "Heat pump HX"
    annotation(Placement(transformation(extent={{10,-470},{-10,-450}})));
  Fluid.FixedResistances.PressureDrop priHeaWat(
    redeclare final package Medium=Medium,
    final m_flow_nominal=sum(datPumHeaWat.m_flow_nominal),
    final dp_nominal=0)
    "Primary HW loop"
    annotation(Placement(transformation(extent={{-10,-350},{10,-330}})));
  Fluid.Sources.Boundary_pT ret2(
    redeclare final package Medium=Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=nHp)
    "Boundary condition at return"
    annotation(Placement(transformation(extent={{122,-150},{102,-130}})));
  Buildings.Templates.Components.Actuators.Valve valHeaWatIsoSep[nHp](
    redeclare each final package Medium=Medium,
    each typ=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition,
    dat(
      each m_flow_nominal=datHp.mHeaWatHp_flow_nominal,
      each dpValve_nominal=Buildings.Templates.Data.Defaults.dpValIso),
    each from_dp=true,
    each linearized=true)
    "Primary HW loop isolation valve"
    annotation(Placement(transformation(extent={{10,-150},{30,-130}})));
  Buildings.Templates.Components.Actuators.Valve valChiWatIsoSep[nHp](
    redeclare each final package Medium=Medium,
    each typ=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition,
    dat(
      each m_flow_nominal=datHp.mChiWatHp_flow_nominal,
      each dpValve_nominal=Buildings.Templates.Data.Defaults.dpValIso),
    each from_dp=true,
    each linearized=true)
    "Primary CHW loop isolation valve"
    annotation(Placement(transformation(extent={{50,-170},{70,-150}})));
  Buildings.Templates.Components.Pumps.Multiple pumChiWatPriHdr(
    have_var=false,
    final energyDynamics=energyDynamics,
    nPum=nHp,
    dat=datPumChiWatHdr)
    "Headered primary CHW pumps"
    annotation(Placement(transformation(extent={{0,30},{20,50}})));
initial equation
  // Calculation of pump speed to provide design flow.
  if use_spePumIni then
    fill(0, nHp) = Buildings.Templates.Utilities.computeBalancingPressureDrop(
      m_flow_nominal=fill(datHp.mHeaWatHp_flow_nominal, nHp),
      dp_nominal=pumPriHea.dpValCheHeaWat_nominal .+ fill(
          datHp.dpHeaWatHp_nominal,
          nHp) .+ fill(Buildings.Templates.Data.Defaults.dpValIso, nHp),
      datPum=datPumHeaWatHeaSin,
      r_N=r_N);
  else
    r_N = r_NDef;
  end if;
equation
  for i in 1:nHp loop
    connect(priHeaWat.port_a, pumPriHea.ports_bHeaWat[i])
      annotation(Line(points={{-10,-340},{-76,-340},{-76,-380}},
        color={0,127,255}));
    connect(priHeaWat.port_b, pumPriHea.ports_aChiHeaWat[i])
      annotation(Line(points={{10,-340},{65.8,-340},{65.8,-380}},
        color={0,127,255}));
  end for;
  connect(pumPriCom.ports_bChiHeaWatHp, hpCom.port_a)
    annotation(Line(points={{82,160},{10,160}},
      color={0,127,255}));
  connect(hpCom.port_b, pumPriCom.ports_aChiHeaWatHp)
    annotation(Line(points={{-10,160},{-82,160}},
      color={0,127,255}));
  connect(pumPriNoDed.ports_bChiHeaWatHp, hpHdr.port_a)
    annotation(Line(points={{82,-60},{10,-60}},
      color={0,127,255}));
  connect(hpHdr.port_b, pumPriNoDed.ports_aChiHeaWatHp)
    annotation(Line(points={{-10,-60},{-82,-60}},
      color={0,127,255}));
  connect(pumPriNoDed.ports_bChiHeaWat, pumHeaWatPriHdr.ports_a)
    annotation(Line(points={{-44,20},{-80,20},{-80,80},{-70,80}},
      color={0,127,255}));
  connect(ctlNoDed.bus, busPla)
    annotation(Line(points={{-100,120},{-80,120}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla.pumHeaWatPri, pumHeaWatPriHdr.bus)
    annotation(Line(points={{-80,120},{-60,120},{-60,90}},
      color={255,204,51},
      thickness=0.5));
  connect(pumPriSep.ports_bChiHeaWatHp, hpSep.port_a)
    annotation(Line(points={{82,-260},{10,-260}},
      color={0,127,255}));
  connect(hpSep.port_b, pumPriSep.ports_aChiHeaWatHp)
    annotation(Line(points={{-10,-260},{-82,-260}},
      color={0,127,255}));
  connect(pumPriCom.ports_bChiHeaWat, valHeaWatIsoCom.port_a)
    annotation(Line(points={{-44,240},{-44,280},{-30,280}},
      color={0,127,255}));
  connect(valHeaWatIsoCom.port_b, pumPriCom.ports_aChiHeaWat)
    annotation(Line(points={{-10,280},{65.8,280},{65.8,240}},
      color={0,127,255}));
  connect(pumPriCom.ports_bChiHeaWat, valChiWatIsoCom.port_a)
    annotation(Line(points={{-44,240},{-44,260},{10,260}},
      color={0,127,255}));
  connect(valChiWatIsoCom.port_b, pumPriCom.ports_aChiHeaWat)
    annotation(Line(points={{30,260},{65.8,260},{65.8,240}},
      color={0,127,255}));
  connect(ctl.bus, busPla1)
    annotation(Line(points={{-100,300},{-70,300}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla1.valHeaWatHpInlIso, valHeaWatIsoCom.bus)
    annotation(Line(points={{-70,300},{-20,300},{-20,290}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla1.valChiWatHpInlIso, valChiWatIsoCom.bus)
    annotation(Line(points={{-70,300},{20,300},{20,270}},
      color={255,204,51},
      thickness=0.5));
  connect(pumHeaWatPriHdr.ports_b, valHeaWatIsoHdr.port_a)
    annotation(Line(points={{-50,80},{-30,80}},
      color={0,127,255}));
  connect(valHeaWatIsoHdr.port_b, pumPriNoDed.ports_aChiHeaWat)
    annotation(Line(points={{-10,80},{65.8,80},{65.8,20}},
      color={0,127,255}));
  connect(valChiWatIsoHdr.port_b, pumPriNoDed.ports_aChiHeaWat)
    annotation(Line(points={{50,40},{65.8,40},{65.8,20}},
      color={0,127,255}));
  connect(ret1.ports, valHeaWatIsoHdr.port_b)
    annotation(Line(points={{100,80},{-10,80}},
      color={0,127,255}));
  connect(busPla.valHeaWatHpInlIso, valHeaWatIsoHdr.bus)
    annotation(Line(points={{-80,120},{-20,120},{-20,90}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla.valChiWatHpInlIso, valChiWatIsoHdr.bus)
    annotation(Line(points={{-80,120},{40,120},{40,50}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla1, pumPriCom.bus)
    annotation(Line(points={{-70,300},{0,300},{0,240}},
      color={255,204,51},
      thickness=0.5));
  connect(ctlSep.bus, busPla2)
    annotation(Line(points={{-100,-120},{-80,-120}},
      color={255,204,51},
      thickness=0.5));
  connect(pumPriHea.ports_bChiHeaWatHp, hpHea.port_a)
    annotation(Line(points={{82,-460},{10,-460}},
      color={0,127,255}));
  connect(hpHea.port_b, pumPriHea.ports_aChiHeaWatHp)
    annotation(Line(points={{-10,-460},{-82,-460}},
      color={0,127,255}));
  connect(ctlHea.bus, pumPriHea.bus)
    annotation(Line(points={{-100,-360},{0,-360},{0,-380}},
      color={255,204,51},
      thickness=0.5));
  connect(ret3.ports[1], priHeaWat.port_b)
    annotation(Line(points={{100,-340},{10,-340}},
      color={0,127,255}));
  connect(valHeaWatIsoCom.port_b, ret.ports)
    annotation(Line(points={{-10,280},{100,280}},
      color={0,127,255}));
  connect(busPla2.valHeaWatHpInlIso, valHeaWatIsoSep.bus)
    annotation(Line(points={{-80,-120},{20,-120},{20,-130}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla2.valChiWatHpInlIso, valChiWatIsoSep.bus)
    annotation(Line(points={{-80,-120},{60,-120},{60,-150}},
      color={255,204,51},
      thickness=0.5));
  connect(pumPriSep.ports_bHeaWat, valHeaWatIsoSep.port_a)
    annotation(Line(points={{-76,-180},{-76,-140},{10,-140}},
      color={0,127,255}));
  connect(valHeaWatIsoSep.port_b, pumPriSep.ports_aChiHeaWat)
    annotation(Line(points={{30,-140},{65.8,-140},{65.8,-180}},
      color={0,127,255}));
  connect(busPla2, pumPriSep.bus)
    annotation(Line(points={{-80,-120},{0,-120},{0,-180}},
      color={255,204,51},
      thickness=0.5));
  connect(valHeaWatIsoSep.port_b, ret2.ports)
    annotation(Line(points={{30,-140},{102,-140}},
      color={0,127,255}));
  connect(pumPriSep.ports_bChiWat, valChiWatIsoSep.port_a)
    annotation(Line(points={{-60,-180},{-60,-160},{50,-160}},
      color={0,127,255}));
  connect(valChiWatIsoSep.port_b, pumPriSep.ports_aChiHeaWat)
    annotation(Line(points={{70,-160},{65.8,-160},{65.8,-180}},
      color={0,127,255}));
  connect(pumChiWatPriHdr.ports_b, valChiWatIsoHdr.port_a)
    annotation(Line(points={{20,40},{30,40}},
      color={0,127,255}));
  connect(pumPriNoDed.ports_bChiHeaWat, pumChiWatPriHdr.ports_a)
    annotation(Line(points={{-44,20},{-60,20},{-60,40},{0,40}},
      color={0,127,255}));
  connect(busPla.pumChiWatPri, pumChiWatPriHdr.bus)
    annotation(Line(points={{-80,120},{10,120},{10,50}},
      color={255,204,51},
      thickness=0.5));
annotation(__Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/HeatPumps/Components/Validation/PumpsPrimaryDedicated.mos"
    "Simulate and plot"),
  experiment(Tolerance=1e-6,
    StopTime=5000.0),
  Diagram(coordinateSystem(extent={{-300,-520},{300,360}})),
  Documentation(
    info="<html>
<p>
  This model validates the model
  <a href=\"modelica://Buildings.Templates.Plants.HeatPumps.Components.PumpsPrimaryDedicated\">
    Buildings.Templates.Plants.HeatPumps.Components.PumpsPrimaryDedicated</a>
  for the following configurations.
</p>
<ul>
  <li>
    Reversible heat pumps with a single dedicated primary pump serving both
    CHW and HW circuits: component <code>pumPriCom</code>.
  </li>
  <li>
    Reversible heat pumps with headered constant speed primary pumps:
    component <code>pumPriHdr</code>.
  </li>
  <li>
    Reversible heat pumps with separate constant speed dedicated HW and CHW
    pumps: component <code>pumPriSep</code>.
  </li>
  <li>
    Heating-only heat pumps with variable speed dedicated primary pumps:
    component <code>pumPriHea</code>.
  </li>
</ul>
<p>
  In each configuration, two identical heat pumps are represented by fixed
  flow resistances (components <code>hp*</code>).
</p>
<p>
  The model uses open loop controls and the simulation allows verifying that
  design flow is obtained in each loop and each heat pump when the pumps are
  enabled.
</p>
<p>
  In the configuration with a single dedicated primary pump serving both CHW
  and HW circuits, this requires adjusting the design pressure drop of the
  balancing valves which are modeled by fixed flow resistances in the
  isolation valve components <code>valHeaWatIsoCom</code> and
  <code>valChiWatIsoCom</code>. This adjustment is done programmatically using
  the function
  <a href=\"modelica://Buildings.Templates.Utilities.computeBalancingPressureDrop\">
    Buildings.Templates.Utilities.computeBalancingPressureDrop</a>.
</p>
<p>
  Similarly, in the configuration with variable speed pumps
  <code>pumPriHea</code>, the design head of the pumps is voluntarily chosen
  higher than necessary and the required pump speed needed to provide the
  design HP flow is computed at initialization by solving for a balancing
  valve pressure drop of zero. Note that this requires solving a numerical
  Jacobian at initialization. Although this is handled well by various
  Modelica tools, the parameter <code>use_spePumIni</code> allows switching to
  a default value in this validation model for better integration into the
  continuous integration test workflow.
</p>
</html>",
    revisions="<html>
<ul>
  <li>
    March 29, 2024, by Antoine Gautier:<br />
    First implementation.
  </li>
</ul>
</html>"));
end PumpsPrimaryDedicated;
