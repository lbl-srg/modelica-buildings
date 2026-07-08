within Buildings.Templates.Plants.HeatPumps.Components.Validation;
model PumpsPrimaryDedicatedPolyvalent
  "Validation model for dedicated primary pump component with polyvalent heat pumps"
  extends Modelica.Icons.Example;

  replaceable package Medium = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CHW/HW medium";

  final parameter Integer nHp = 2
    "Number of heat pumps (excluding polyvalent HPs)"
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
      have_hp=true,
      have_hrc=false,
      have_valHpOutIso=false,
      have_valHpInlIso=true,
      have_valPhpOutIso=false,
      have_valPhpInlIso=false,
      have_chiWat=true,
      have_php=true,
      final nPhp=nPhp,
      typPumHeaWatPri=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Constant,
      typPumChiWatPri=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Constant,
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
      final nPumHeaWatPri=nHp + nPhp,
      final nPumChiWatPri=nPhp,
      have_heaWat=true,
      nPumHeaWatSec=0,
      rhoSou_default=Buildings.Media.Air.dStp,
      have_senDpHeaWatRemWir=true,
      typPumChiWatSec=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None,
      nSenDpHeaWatRem=0,
      nSenDpChiWatRem=0,
      nAirHan=0,
      nEquZon=0,
      have_pumChiWatPriDedHp=false),
    THeaWatSup_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    TChiWatSup_nominal=Buildings.Templates.Data.Defaults.TChiWatSup,
    dpChiWatRemSet_max=fill(
      Buildings.Templates.Data.Defaults.dpChiWatRemSet_max,
      datCtl.cfg.nSenDpChiWatRem),
    dpHeaWatRemSet_max=fill(
      Buildings.Templates.Data.Defaults.dpHeaWatRemSet_max,
      datCtl.cfg.nSenDpHeaWatRem),
    staHp={fill(1, datCtl.cfg.nHp)})
    "Controller parameters"
    annotation(Placement(transformation(extent={{-180,290},{-160,310}})));
  parameter Data.Controller datCtlNoDed(
    cfg(
      typ=Buildings.Templates.Plants.Controls.Types.PlantHeatPump.ReversiblePolyvalent,
      have_inpSch=false,
      have_hp=true,
      have_hrc=false,
      have_valHpOutIso=true,
      have_valHpInlIso=true,
      have_valPhpOutIso=false,
      have_valPhpInlIso=true,
      have_chiWat=true,
      have_php=true,
      final nPhp=nPhp,
      typPumHeaWatPri=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Constant,
      typPumChiWatPri=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Constant,
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
      have_pumChiWatPriDedHp=false),
    THeaWatSup_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    TChiWatSup_nominal=Buildings.Templates.Data.Defaults.TChiWatSup,
    dpChiWatRemSet_max=fill(
      Buildings.Templates.Data.Defaults.dpChiWatRemSet_max,
      datCtlNoDed.cfg.nSenDpChiWatRem),
    dpHeaWatRemSet_max=fill(
      Buildings.Templates.Data.Defaults.dpHeaWatRemSet_max,
      datCtlNoDed.cfg.nSenDpHeaWatRem),
    staHp={fill(1, datCtlNoDed.cfg.nHp)})
    "Controller parameters"
    annotation(Placement(transformation(extent={{-280,-10},{-260,10}})));
  parameter Data.Controller datCtlSep(
    cfg(
      typ=Buildings.Templates.Plants.Controls.Types.PlantHeatPump.ReversiblePolyvalent,
      have_inpSch=false,
      have_hp=true,
      have_hrc=false,
      have_valHpOutIso=false,
      have_valHpInlIso=true,
      have_valPhpOutIso=false,
      have_valPhpInlIso=false,
      have_chiWat=true,
      have_php=true,
      final nPhp=nPhp,
      typPumHeaWatPri=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Constant,
      typPumChiWatPri=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Constant,
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
      final nPumHeaWatPri=nHp + nPhp,
      final nPumChiWatPri=nHp + nPhp,
      have_heaWat=true,
      nPumHeaWatSec=0,
      rhoSou_default=Buildings.Media.Air.dStp,
      have_senDpHeaWatRemWir=true,
      typPumChiWatSec=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None,
      nSenDpHeaWatRem=0,
      nSenDpChiWatRem=0,
      nAirHan=0,
      nEquZon=0,
      have_pumChiWatPriDedHp=true),
    THeaWatSup_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    TChiWatSup_nominal=Buildings.Templates.Data.Defaults.TChiWatSup,
    dpChiWatRemSet_max=fill(
      Buildings.Templates.Data.Defaults.dpChiWatRemSet_max,
      datCtlSep.cfg.nSenDpChiWatRem),
    dpHeaWatRemSet_max=fill(
      Buildings.Templates.Data.Defaults.dpHeaWatRemSet_max,
      datCtlSep.cfg.nSenDpHeaWatRem),
    staHp={fill(1, datCtlSep.cfg.nHp)})
    "Controller parameters"
    annotation(Placement(transformation(extent={{-180,-290},{-160,-270}})));
  parameter Data.HeatPumpGroup datHpPhp(
    have_hp=true,
    have_php=true,
    final typHp=Buildings.Templates.Components.Types.HeatPump.AirToWater,
    final is_rev=true,
    mHeaWatHp_flow_nominal=datHpPhp.capHeaHp_nominal / abs(
      datHpPhp.THeaWatSupHp_nominal -
        Buildings.Templates.Data.Defaults.THeaWatRetMed) /
      Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    dpHeaWatHp_nominal=Buildings.Templates.Data.Defaults.dpHeaWatHp,
    capHeaHp_nominal=500E3,
    THeaWatSupHp_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    TSouHeaHp_nominal=Buildings.Templates.Data.Defaults.TOutHpHeaLow,
    mChiWatHp_flow_nominal=datHpPhp.capCooHp_nominal / abs(
      datHpPhp.TChiWatSupHp_nominal -
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
      PLRSup={1}),
    mHeaWatPhp_flow_nominal=datHpPhp.capHeaPhp_nominal / abs(
      datHpPhp.THeaWatSupPhp_nominal -
        Buildings.Templates.Data.Defaults.THeaWatRetMed) /
      Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    dpHeaWatPhp_nominal=Buildings.Templates.Data.Defaults.dpHeaWatHp,
    capHeaPhp_nominal=500E3,
    THeaWatSupPhp_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    TSouHeaPhp_nominal=Buildings.Templates.Data.Defaults.TOutHpHeaLow,
    mChiWatPhp_flow_nominal=datHpPhp.capCooPhp_nominal / abs(
      datHpPhp.TChiWatSupPhp_nominal -
        Buildings.Templates.Data.Defaults.TChiWatRet) /
      Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    capCooPhp_nominal=500E3,
    dpChiWatPhp_nominal=Buildings.Templates.Data.Defaults.dpChiWatChi,
    TChiWatSupPhp_nominal=Buildings.Templates.Data.Defaults.TChiWatSup,
    TSouCooPhp_nominal=Buildings.Templates.Data.Defaults.TOutHpCoo,
    PPhp_min=1.0E3,
    capHeaShcPhp_nominal=500E3,
    capCooShcPhp_nominal=500E3,
    perPhp(
      fileNameHea=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_Heating.txt"),
      fileNameCoo=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_Cooling.txt"),
      fileNameShc=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_SHC.txt")))
    "Parameters for reversible and polyvalent heat pumps"
    annotation(Placement(transformation(extent={{-280,-120},{-260,-100}})));
  parameter Buildings.Templates.Components.Data.PumpMultiple datPumPriCom(
    typ=Buildings.Templates.Components.Types.Pump.Multiple,
    nPum=nHp + nPhp,
    m_flow_nominal=cat(
      1,
      fill(
        max(datHpPhp.mHeaWatHp_flow_nominal, datHpPhp.mChiWatHp_flow_nominal),
        nHp),
      fill(datHpPhp.mHeaWatPhp_flow_nominal, nPhp)),
    dp_nominal=cat(
      1,
      fill(
        max(datHpPhp.dpHeaWatHp_nominal, datHpPhp.dpChiWatHp_nominal) +
          Buildings.Templates.Data.Defaults.dpValChe + max(
            max(valChiWatIsoCom.dpValve_nominal),
            max(valHeaWatIsoCom.dpValve_nominal)),
        nHp),
      fill(
        datHpPhp.dpHeaWatHp_nominal +
          Buildings.Templates.Data.Defaults.dpValChe,
        nPhp)))
    "Primary pump parameters – Configuration with common HW/CHW pump for HP"
    annotation(Placement(transformation(extent={{-160,240},{-140,260}})));
  parameter Buildings.Templates.Components.Data.PumpMultiple datPumHeaWat(
    typ=Buildings.Templates.Components.Types.Pump.Multiple,
    nPum=nHp + nPhp,
    m_flow_nominal=cat(
      1,
      fill(datHpPhp.mHeaWatHp_flow_nominal, nHp),
      fill(datHpPhp.mHeaWatPhp_flow_nominal, nPhp)),
    dp_nominal=cat(
      1,
      fill(
        datHpPhp.dpHeaWatHp_nominal +
          Buildings.Templates.Data.Defaults.dpValChe + max(
            valHeaWatIsoCom.dpValve_nominal),
        nHp),
      fill(
        datHpPhp.dpHeaWatPhp_nominal +
          Buildings.Templates.Data.Defaults.dpValChe,
        nPhp)))
    "Dedicated primary HW pump parameters – HP and polyvalent HPs"
    annotation(Placement(transformation(extent={{-160,-360},{-140,-340}})));
  parameter Buildings.Templates.Components.Data.PumpMultiple datPumChiWat(
    typ=Buildings.Templates.Components.Types.Pump.Multiple,
    final nPum=nHp + nPhp,
    m_flow_nominal=cat(
      1,
      fill(datHpPhp.mChiWatHp_flow_nominal, nHp),
      fill(datHpPhp.mChiWatPhp_flow_nominal, nPhp)),
    dp_nominal=cat(
      1,
      fill(
        datHpPhp.dpChiWatHp_nominal +
          Buildings.Templates.Data.Defaults.dpValChe + max(
            valHeaWatIsoCom.dpValve_nominal),
        nHp),
      fill(
        datHpPhp.dpChiWatPhp_nominal +
          Buildings.Templates.Data.Defaults.dpValChe,
        nPhp)))
    "Dedicated primary CHW pump parameters – HP and polyvalent HPs"
    annotation(Placement(transformation(extent={{-120,-360},{-100,-340}})));
  parameter Buildings.Templates.Components.Data.PumpMultiple datPumHeaWatHdr(
    typ=Buildings.Templates.Components.Types.Pump.Multiple,
    nPum=nHp + nPhp,
    m_flow_nominal=fill(
      (datHpPhp.mHeaWatHp_flow_nominal * nHp +
        datHpPhp.mHeaWatPhp_flow_nominal * nPhp) / datPumHeaWatHdr.nPum,
      datPumHeaWatHdr.nPum),
    dp_nominal=fill(
      max(datHpPhp.dpHeaWatHp_nominal, datHpPhp.dpHeaWatPhp_nominal) +
        Buildings.Templates.Data.Defaults.dpValChe + max(
          valHeaWatIsoHdr.dpValve_nominal),
      datPumHeaWatHdr.nPum))
    "Headered primary HW pump parameters – HP and polyvalent HPs"
    annotation(Placement(transformation(extent={{-240,-80},{-220,-60}})));
  parameter Buildings.Templates.Components.Data.PumpMultiple datPumChiWatHdr(
    typ=Buildings.Templates.Components.Types.Pump.Multiple,
    final nPum=nHp + nPhp,
    m_flow_nominal=fill(
      (datHpPhp.mChiWatHp_flow_nominal * nHp +
        datHpPhp.mChiWatPhp_flow_nominal * nPhp) / datPumChiWatHdr.nPum,
      datPumChiWatHdr.nPum),
    dp_nominal=fill(
      max(datHpPhp.dpChiWatHp_nominal, datHpPhp.dpChiWatPhp_nominal) +
        Buildings.Templates.Data.Defaults.dpValChe + max(
          valChiWatIsoHdr.dpValve_nominal),
      datPumChiWatHdr.nPum))
    "Headered primary CHW pump parameters – HP and polyvalent HPs"
    annotation(Placement(transformation(extent={{-200,-80},{-180,-60}})));
  parameter Buildings.Templates.Components.Data.PumpMultiple datPumChiWatPhp(
    typ=Buildings.Templates.Components.Types.Pump.Multiple,
    final nPum=nPhp,
    m_flow_nominal=fill(datHpPhp.mChiWatPhp_flow_nominal, nPhp),
    dp_nominal=fill(
      datHpPhp.dpChiWatPhp_nominal + Buildings.Templates.Data.Defaults.dpValChe,
      nPhp))
    "Dedicated primary CHW pump parameters – Polyvalent heat pumps"
    annotation(Placement(transformation(extent={{-120,240},{-100,260}})));
  final parameter Buildings.Templates.Components.Data.PumpSingle datPumComSin[nHp +
    nPhp](
    each typ=datPumPriCom.typ,
    m_flow_nominal=datPumPriCom.m_flow_nominal,
    dp_nominal=datPumPriCom.dp_nominal,
    per=datPumPriCom.per,
    each rho_default=datPumPriCom.rho_default)
    "Cast multiple pump record into single pump record array";
  final parameter Buildings.Templates.Components.Data.PumpSingle datPumHeaWatHdrSin[nHp +
    nPhp](
    each typ=datPumHeaWatHdr.typ,
    m_flow_nominal=datPumHeaWatHdr.m_flow_nominal,
    dp_nominal=datPumHeaWatHdr.dp_nominal,
    per=datPumHeaWatHdr.per,
    each rho_default=datPumHeaWatHdr.rho_default)
    "Cast multiple pump record into single pump record array";
  final parameter Buildings.Templates.Components.Data.PumpSingle datPumChiWatHdrSin[nHp +
    nPhp](
    each typ=datPumChiWatHdr.typ,
    m_flow_nominal=datPumChiWatHdr.m_flow_nominal,
    dp_nominal=datPumChiWatHdr.dp_nominal,
    per=datPumChiWatHdr.per,
    each rho_default=datPumChiWatHdr.rho_default)
    "Cast multiple pump record into single pump record array";
  Buildings.Templates.Plants.HeatPumps.Interfaces.Bus busPla2
    "Plant control bus"
    annotation(Placement(iconVisible=false,
      transformation(extent={{-100,-300},{-60,-260}}),
      iconTransformation(extent={{-332,42},{-292,82}})));
  Buildings.Templates.Plants.HeatPumps.Components.PumpsPrimaryDedicated pumPriCom(
    redeclare final package Medium=Medium,
    final nPumHeaWat=nHp + nPhp,
    final nPumChiWat=nPhp,
    have_hp=true,
    have_php=true,
    final nHp=nHp,
    final nPhp=nPhp,
    typArrPumPri=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
    have_pumPriComHp=true,
    have_pumHeaWatPriVar=false,
    have_pumChiWatPriVar=false,
    datPumHeaWat=datPumPriCom,
    final datPumChiWat=datPumChiWatPhp,
    final energyDynamics=energyDynamics)
    "Primary pumps – Heat pumps with common constant speed dedicated primary pumps"
    annotation(Placement(transformation(extent={{-240,160},{240,240}})));
  Fluid.FixedResistances.PressureDrop hpCom[nHp](
    redeclare each final package Medium=Medium,
    each m_flow_nominal=datHpPhp.mHeaWatHp_flow_nominal,
    each dp_nominal=datHpPhp.dpHeaWatHp_nominal)
    "Heat pump HX"
    annotation(Placement(transformation(extent={{10,130},{-10,150}})));
  Fluid.Sources.Boundary_pT ret(
    redeclare final package Medium=Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=nHp)
    "Boundary condition at return"
    annotation(Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=90,
      origin={100,290})));
  Controls.OpenLoop ctl(final cfg=datCtl.cfg, final dat=datCtl)
    "Plant controller"
    annotation(Placement(transformation(extent={{-120,290},{-140,310}})));
  Buildings.Templates.Plants.HeatPumps.Components.PumpsPrimaryDedicated pumPriNoDed(
    redeclare final package Medium=Medium,
    final nPumHeaWat=0,
    final nPumChiWat=0,
    have_hp=true,
    have_php=true,
    final nHp=nHp,
    final nPhp=nPhp,
    typArrPumPri=Buildings.Templates.Components.Types.PumpArrangement.Headered,
    have_pumPriComHp=false,
    have_pumHeaWatPriVar=false,
    have_pumChiWatPriVar=false,
    datPumHeaWat=datPumPriCom,
    final energyDynamics=energyDynamics)
    "No dedicated primary pumps (headered pumps)"
    annotation(Placement(transformation(extent={{-240,-180},{240,-100}})));
  Fluid.FixedResistances.PressureDrop hpHdr[nHp](
    redeclare each final package Medium=Medium,
    each m_flow_nominal=datHpPhp.mHeaWatHp_flow_nominal,
    each dp_nominal=datHpPhp.dpHeaWatHp_nominal)
    "Heat pump HX"
    annotation(Placement(transformation(extent={{10,-210},{-10,-190}})));
  Controls.OpenLoop ctlNoDed(final cfg=datCtlNoDed.cfg, final dat=datCtlNoDed)
    "Plant controller"
    annotation(Placement(transformation(extent={{-220,-10},{-240,10}})));
  Buildings.Templates.Components.Pumps.Multiple pumHeaWatPriHdr(
    have_var=false,
    final energyDynamics=energyDynamics,
    nPum=nHp + nPhp,
    dat=datPumHeaWatHdr)
    "Headered primary HW pumps"
    annotation(Placement(transformation(extent={{-110,-50},{-90,-30}})));
  Buildings.Templates.Plants.HeatPumps.Interfaces.Bus busPla
    "Plant control bus"
    annotation(Placement(iconVisible=false,
      transformation(extent={{-220,-20},{-180,20}}),
      iconTransformation(extent={{-332,42},{-292,82}})));
  Buildings.Templates.Plants.HeatPumps.Components.PumpsPrimaryDedicated pumPriSep(
    redeclare final package Medium=Medium,
    final nPumHeaWat=nHp + nPhp,
    final nPumChiWat=nHp + nPhp,
    have_hp=true,
    have_php=true,
    final nHp=nHp,
    final nPhp=nPhp,
    typArrPumPri=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
    have_pumPriComHp=false,
    have_pumHeaWatPriVar=false,
    have_pumChiWatPriVar=false,
    datPumHeaWat=datPumHeaWat,
    final datPumChiWat=datPumChiWat,
    final energyDynamics=energyDynamics)
    "Primary pumps – Heat pumps with separate constant speed dedicated CHW pumps"
    annotation(Placement(transformation(extent={{-240,-420},{240,-340}})));
  Fluid.Sources.Boundary_pT ret2(
    redeclare final package Medium=Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=nHp)
    "Boundary condition at return"
    annotation(Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=90,
      origin={100,-290})));
  Controls.OpenLoop ctlSep(final cfg=datCtlSep.cfg, final dat=datCtlSep)
    "Plant controller"
    annotation(Placement(transformation(extent={{-120,-290},{-140,-270}})));
  Fluid.FixedResistances.PressureDrop hpSep[nHp](
    redeclare each final package Medium=Medium,
    each m_flow_nominal=datHpPhp.mHeaWatHp_flow_nominal,
    each dp_nominal=datHpPhp.dpHeaWatHp_nominal)
    "Heat pump HX"
    annotation(Placement(transformation(extent={{10,-450},{-10,-430}})));
  Buildings.Templates.Components.Actuators.Valve valHeaWatIsoCom[nHp](
    redeclare each final package Medium=Medium,
    each typ=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition,
    dat(
      each m_flow_nominal=datHpPhp.mHeaWatHp_flow_nominal,
      each dpValve_nominal=Buildings.Templates.Data.Defaults.dpValIso,
      dpFixed_nominal=Buildings.Templates.Utilities.computeBalancingPressureDrop(
        m_flow_nominal=fill(datHpPhp.mHeaWatHp_flow_nominal, nHp),
        dp_nominal=pumPriCom.dpValCheHeaWat_nominal[1:nHp] *
          (datHpPhp.mHeaWatHp_flow_nominal / max(
            datHpPhp.mHeaWatHp_flow_nominal, datHpPhp.mChiWatHp_flow_nominal)) ^
          2 .+ fill(datHpPhp.dpHeaWatHp_nominal, nHp) .+
          valHeaWatIsoCom.dpValve_nominal,
        datPum=datPumComSin[1:nHp])),
    each from_dp=true)
    "Primary HW loop isolation valve"
    annotation(Placement(transformation(extent={{10,270},{30,290}})));
  Buildings.Templates.Components.Actuators.Valve valChiWatIsoCom[nHp](
    redeclare each final package Medium=Medium,
    each typ=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition,
    dat(
      each m_flow_nominal=datHpPhp.mChiWatHp_flow_nominal,
      each dpValve_nominal=Buildings.Templates.Data.Defaults.dpValIso,
      dpFixed_nominal=Buildings.Templates.Utilities.computeBalancingPressureDrop(
        m_flow_nominal=fill(datHpPhp.mChiWatHp_flow_nominal, nHp),
        dp_nominal=pumPriCom.dpValCheHeaWat_nominal[1:nHp] *
          (datHpPhp.mChiWatHp_flow_nominal / max(
            datHpPhp.mHeaWatHp_flow_nominal, datHpPhp.mChiWatHp_flow_nominal)) ^
          2 .+ fill(datHpPhp.dpChiWatHp_nominal, nHp) .+
          valChiWatIsoCom.dpValve_nominal,
        datPum=datPumComSin[1:nHp])),
    each from_dp=true)
    "Primary CHW loop isolation valve"
    annotation(Placement(transformation(extent={{30,250},{50,270}})));
  Buildings.Templates.Plants.HeatPumps.Interfaces.Bus busPla1
    "Plant control bus"
    annotation(Placement(iconVisible=false,
      transformation(extent={{-120,280},{-80,320}}),
      iconTransformation(extent={{-332,42},{-292,82}})));
  Buildings.Templates.Components.Actuators.Valve valChiWatIsoHdr[nHp + nPhp](
    redeclare each final package Medium=Medium,
    each typ=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition,
    dat(
      m_flow_nominal=cat(
        1,
        fill(datHpPhp.mChiWatHp_flow_nominal, nHp),
        fill(datHpPhp.mChiWatPhp_flow_nominal, nPhp)),
      each dpValve_nominal=Buildings.Templates.Data.Defaults.dpValIso,
      dpFixed_nominal=Buildings.Templates.Utilities.computeBalancingPressureDrop(
        m_flow_nominal=valChiWatIsoHdr.m_flow_nominal,
        dp_nominal=pumChiWatPriHdr.dpValChe_nominal .+ cat(
          1,
          fill(datHpPhp.dpChiWatHp_nominal, nHp),
          fill(datHpPhp.dpChiWatPhp_nominal, nPhp)) .+
          valChiWatIsoHdr.dpValve_nominal,
        datPum=datPumChiWatHdrSin)),
    each from_dp=true)
    "CHW isolation valve"
    annotation(Placement(transformation(extent={{20,-70},{40,-50}})));
  Buildings.Templates.Components.Actuators.Valve valHeaWatIsoHdr[nHp + nPhp](
    redeclare each final package Medium=Medium,
    each typ=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition,
    dat(
      m_flow_nominal=cat(
        1,
        fill(datHpPhp.mHeaWatHp_flow_nominal, nHp),
        fill(datHpPhp.mHeaWatPhp_flow_nominal, nPhp)),
      each dpValve_nominal=Buildings.Templates.Data.Defaults.dpValIso,
      dpFixed_nominal=Buildings.Templates.Utilities.computeBalancingPressureDrop(
        m_flow_nominal=valHeaWatIsoHdr.m_flow_nominal,
        dp_nominal=pumHeaWatPriHdr.dpValChe_nominal .+ cat(
          1,
          fill(datHpPhp.dpHeaWatHp_nominal, nHp),
          fill(datHpPhp.dpHeaWatPhp_nominal, nPhp)) .+
          valHeaWatIsoHdr.dpValve_nominal,
        datPum=datPumHeaWatHdrSin)),
    each from_dp=true)
    "HW isolation valve"
    annotation(Placement(transformation(extent={{-10,-50},{10,-30}})));
  Buildings.Templates.Components.Actuators.Valve valHeaWatIsoSep[nHp](
    redeclare each final package Medium=Medium,
    each typ=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition,
    dat(
      each m_flow_nominal=datHpPhp.mHeaWatHp_flow_nominal,
      each dpValve_nominal=Buildings.Templates.Data.Defaults.dpValIso),
    each from_dp=true,
    each linearized=true)
    "Primary HW loop isolation valve"
    annotation(Placement(transformation(extent={{-30,-310},{-10,-290}})));
  Buildings.Templates.Components.Actuators.Valve valChiWatIsoSep[nHp](
    redeclare each final package Medium=Medium,
    each typ=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition,
    dat(
      each m_flow_nominal=datHpPhp.mChiWatHp_flow_nominal,
      each dpValve_nominal=Buildings.Templates.Data.Defaults.dpValIso),
    each from_dp=true,
    each linearized=true)
    "Primary CHW loop isolation valve"
    annotation(Placement(transformation(extent={{10,-330},{30,-310}})));
  Buildings.Templates.Components.Pumps.Multiple pumChiWatPriHdr(
    have_var=false,
    final energyDynamics=energyDynamics,
    nPum=nHp + nPhp,
    dat=datPumChiWatHdr)
    "Headered primary CHW pumps"
    annotation(Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Fluid.FixedResistances.PressureDrop phpConSep[nPhp](
    redeclare each final package Medium=Medium,
    each m_flow_nominal=datHpPhp.mHeaWatPhp_flow_nominal,
    each dp_nominal=datHpPhp.dpHeaWatPhp_nominal)
    "Polyvalent HP condenser"
    annotation(Placement(transformation(extent={{-20,-470},{-40,-450}})));
  Fluid.FixedResistances.PressureDrop phpEvaSep[nPhp](
    redeclare each final package Medium=Medium,
    each m_flow_nominal=datHpPhp.mChiWatPhp_flow_nominal,
    each dp_nominal=datHpPhp.dpChiWatPhp_nominal)
    "Polyvalent HP evaporator"
    annotation(Placement(transformation(extent={{10,-490},{-10,-470}})));
  Fluid.FixedResistances.PressureDrop phpConHdr[nPhp](
    redeclare each final package Medium=Medium,
    each m_flow_nominal=datHpPhp.mHeaWatPhp_flow_nominal,
    each dp_nominal=datHpPhp.dpHeaWatPhp_nominal)
    "Polyvalent HP condenser"
    annotation(Placement(transformation(extent={{-20,-230},{-40,-210}})));
  Fluid.FixedResistances.PressureDrop phpEvaHdr[nPhp](
    redeclare each final package Medium=Medium,
    each m_flow_nominal=datHpPhp.mChiWatPhp_flow_nominal,
    each dp_nominal=datHpPhp.dpChiWatPhp_nominal)
    "Polyvalent HP evaporator"
    annotation(Placement(transformation(extent={{10,-250},{-10,-230}})));
  Fluid.FixedResistances.PressureDrop phpConCom[nPhp](
    redeclare each final package Medium=Medium,
    each m_flow_nominal=datHpPhp.mHeaWatPhp_flow_nominal,
    each dp_nominal=datHpPhp.dpHeaWatPhp_nominal)
    "Polyvalent HP condenser"
    annotation(Placement(transformation(extent={{-20,110},{-40,130}})));
  Fluid.FixedResistances.PressureDrop phpEvaCom[nPhp](
    redeclare each final package Medium=Medium,
    each m_flow_nominal=datHpPhp.mChiWatPhp_flow_nominal,
    each dp_nominal=datHpPhp.dpChiWatPhp_nominal)
    "Polyvalent HP evaporator"
    annotation(Placement(transformation(extent={{10,90},{-10,110}})));
  Fluid.Sources.Boundary_pT ret3(
    redeclare final package Medium=Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=nPhp)
    "Boundary condition at return"
    annotation(Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=90,
      origin={140,-290})));
  Fluid.Sources.Boundary_pT ret4(
    redeclare final package Medium=Medium,
    p=Buildings.Templates.Data.Defaults.pChiWat_rel_nominal + 101325,
    nPorts=nPhp)
    "Boundary condition at return"
    annotation(Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=90,
      origin={180,-290})));
  Fluid.Sources.Boundary_pT ret7(
    redeclare final package Medium=Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=nPhp)
    "Boundary condition at return"
    annotation(Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=90,
      origin={140,290})));
  Fluid.Sources.Boundary_pT ret8(
    redeclare final package Medium=Medium,
    p=Buildings.Templates.Data.Defaults.pChiWat_rel_nominal + 101325,
    nPorts=nPhp)
    "Boundary condition at return"
    annotation(Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=90,
      origin={180,290})));
  Fluid.Sources.Boundary_pT ret1(
    redeclare final package Medium=Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=nHp + nPhp)
    "Boundary condition at return"
    annotation(Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=90,
      origin={100,-10})));
  Fluid.Sources.Boundary_pT ret5(
    redeclare final package Medium=Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=nPhp)
    "Boundary condition at return"
    annotation(Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=90,
      origin={120,-50})));
equation
  connect(pumPriCom.ports_bChiHeaWatHp, hpCom.port_a)
    annotation(Line(points={{82,160},{82,140},{10,140}},
      color={0,127,255}));
  connect(hpCom.port_b, pumPriCom.ports_aChiHeaWatHp)
    annotation(Line(points={{-10,140},{-82,140},{-82,160}},
      color={0,127,255}));
  connect(pumPriNoDed.ports_bChiHeaWatHp, hpHdr.port_a)
    annotation(Line(points={{82,-180},{82,-200},{10,-200}},
      color={0,127,255}));
  connect(hpHdr.port_b, pumPriNoDed.ports_aChiHeaWatHp)
    annotation(Line(points={{-10,-200},{-82,-200},{-82,-180}},
      color={0,127,255}));
  connect(ctlNoDed.bus, busPla)
    annotation(Line(points={{-220,0},{-200,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla.pumHeaWatPri, pumHeaWatPriHdr.bus)
    annotation(Line(points={{-200,0},{-100,0},{-100,-30}},
      color={255,204,51},
      thickness=0.5));
  connect(pumPriSep.ports_bChiHeaWatHp, hpSep.port_a)
    annotation(Line(points={{82,-420},{82,-440},{10,-440}},
      color={0,127,255}));
  connect(hpSep.port_b, pumPriSep.ports_aChiHeaWatHp)
    annotation(Line(points={{-10,-440},{-82,-440},{-82,-420}},
      color={0,127,255}));
  connect(pumPriCom.ports_bChiHeaWat, valHeaWatIsoCom.port_a)
    annotation(Line(points={{-44,240},{-44,280},{10,280}},
      color={0,127,255}));
  connect(valHeaWatIsoCom.port_b, pumPriCom.ports_aChiHeaWat)
    annotation(Line(points={{30,280},{65.8,280},{65.8,240}},
      color={0,127,255}));
  connect(pumPriCom.ports_bChiHeaWat, valChiWatIsoCom.port_a)
    annotation(Line(points={{-44,240},{-44,260},{30,260}},
      color={0,127,255}));
  connect(valChiWatIsoCom.port_b, pumPriCom.ports_aChiHeaWat)
    annotation(Line(points={{50,260},{65.8,260},{65.8,240}},
      color={0,127,255}));
  connect(ctl.bus, busPla1)
    annotation(Line(points={{-120,300},{-100,300}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla1.valHeaWatHpInlIso, valHeaWatIsoCom.bus)
    annotation(Line(points={{-100,300},{20,300},{20,290}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla1.valChiWatHpInlIso, valChiWatIsoCom.bus)
    annotation(Line(points={{-100,300},{40,300},{40,270}},
      color={255,204,51},
      thickness=0.5));
  connect(ret.ports, valHeaWatIsoCom.port_b)
    annotation(Line(points={{100,280},{30,280}},
      color={0,127,255}));
  connect(busPla1, pumPriCom.bus)
    annotation(Line(points={{-100,300},{0,300},{0,240}},
      color={255,204,51},
      thickness=0.5));
  connect(pumPriSep.ports_bHeaWat, valHeaWatIsoSep.port_a)
    annotation(Line(points={{-76,-340},{-76,-300},{-30,-300}},
      color={0,127,255}));
  connect(pumPriSep.ports_bChiWat, valChiWatIsoSep.port_a)
    annotation(Line(points={{-60,-340},{-60,-320},{10,-320}},
      color={0,127,255}));
  connect(valHeaWatIsoSep.port_b, pumPriSep.ports_aChiHeaWat)
    annotation(Line(points={{-10,-300},{65.8,-300},{65.8,-340}},
      color={0,127,255}));
  connect(valChiWatIsoSep.port_b, pumPriSep.ports_aChiHeaWat)
    annotation(Line(points={{30,-320},{65.8,-320},{65.8,-340}},
      color={0,127,255}));
  connect(ret2.ports, valHeaWatIsoSep.port_b)
    annotation(Line(points={{100,-300},{-10,-300}},
      color={0,127,255}));
  connect(valChiWatIsoHdr[nHp + 1:nHp + nPhp].port_b, pumPriNoDed.ports_aChiWat)
    annotation(Line(points={{40,-60},{40,-100},{34,-100}},
      color={0,127,255}));
  connect(valHeaWatIsoHdr[nHp + 1:nHp + nPhp].port_b, pumPriNoDed.ports_aHeaWat)
    annotation(Line(points={{10,-40},{50,-40},{50,-100}},
      color={0,127,255}));
  connect(phpConSep.port_b, pumPriSep.ports_aHeaWatPhp)
    annotation(Line(points={{-40,-460},{-66,-460},{-66,-420}},
      color={0,127,255}));
  connect(pumPriSep.ports_bHeaWatRetShc, phpConSep.port_a)
    annotation(Line(points={{66,-420},{66,-460},{-20,-460}},
      color={0,127,255}));
  connect(pumPriSep.ports_bChiWatRetShc, phpEvaSep.port_a)
    annotation(Line(points={{50,-420},{50,-480},{10,-480}},
      color={0,127,255}));
  connect(phpEvaSep.port_b, pumPriSep.ports_aChiWatPhp)
    annotation(Line(points={{-10,-480},{-50,-480},{-50,-420}},
      color={0,127,255}));
  connect(pumPriNoDed.ports_bChiWatRetShc, phpEvaHdr.port_a)
    annotation(Line(points={{50,-180},{50,-240},{10,-240}},
      color={0,127,255}));
  connect(phpEvaHdr.port_b, pumPriNoDed.ports_aChiWatPhp)
    annotation(Line(points={{-10,-240},{-50,-240},{-50,-180}},
      color={0,127,255}));
  connect(pumPriNoDed.ports_bHeaWatRetShc, phpConHdr.port_a)
    annotation(Line(points={{66,-180},{66,-220},{-20,-220}},
      color={0,127,255}));
  connect(phpConHdr.port_b, pumPriNoDed.ports_aHeaWatPhp)
    annotation(Line(points={{-40,-220},{-66,-220},{-66,-180}},
      color={0,127,255}));
  connect(pumPriCom.ports_bChiWatRetShc, phpEvaCom.port_a)
    annotation(Line(points={{50,160},{50,100},{10,100}},
      color={0,127,255}));
  connect(phpEvaCom.port_b, pumPriCom.ports_aChiWatPhp)
    annotation(Line(points={{-10,100},{-50,100},{-50,160}},
      color={0,127,255}));
  connect(pumPriCom.ports_bHeaWatRetShc, phpConCom.port_a)
    annotation(Line(points={{66,160},{66,120},{-20,120}},
      color={0,127,255}));
  connect(phpConCom.port_b, pumPriCom.ports_aHeaWatPhp)
    annotation(Line(points={{-40,120},{-66,120},{-66,160}},
      color={0,127,255}));
  connect(pumPriCom.ports_bHeaWatSupShc, pumPriCom.ports_aHeaWat)
    annotation(Line(points={{-28,240},{-28,254},{50,254},{50,240}},
      color={0,127,255}));
  connect(pumPriCom.ports_bChiWatSupShc, pumPriCom.ports_aChiWat)
    annotation(Line(points={{-12,240},{-12,248},{34,248},{34,240}},
      color={0,127,255}));
  connect(pumPriSep.ports_bHeaWatSupShc, pumPriSep.ports_aHeaWat)
    annotation(Line(points={{-28,-340},{-28,-326},{50,-326},{50,-340}},
      color={0,127,255}));
  connect(pumPriSep.ports_bChiWatSupShc, pumPriSep.ports_aChiWat)
    annotation(Line(points={{-12,-340},{-12,-332},{34,-332},{34,-340}},
      color={0,127,255}));
  connect(busPla.pumChiWatPri, pumChiWatPriHdr.bus)
    annotation(Line(points={{-200,0},{-30,0},{-30,-50}},
      color={255,204,51},
      thickness=0.5));
  connect(ret3.ports, pumPriSep.ports_aHeaWat)
    annotation(Line(points={{140,-300},{140,-326},{50,-326},{50,-340}},
      color={0,127,255}));
  connect(ret4.ports, pumPriSep.ports_aChiWat)
    annotation(Line(points={{180,-300},{180,-332},{34,-332},{34,-340}},
      color={0,127,255}));
  connect(ret7.ports, pumPriCom.ports_aHeaWat)
    annotation(Line(points={{140,280},{140,254},{50,254},{50,240}},
      color={0,127,255}));
  connect(ret8.ports, pumPriCom.ports_aChiWat)
    annotation(Line(points={{180,280},{180,248},{34,248},{34,240}},
      color={0,127,255}));
  // HACK(AntoineGautier): Connecting busPla.valHeaWatPhpInlIso directly
  // to valHeaWatIsoHdr[nHp + 1:nHp + nPhp].bus i.e.
  // connect(busPla.valHeaWatPhpInlIso, valHeaWatIsoHdr[nHp + 1:nHp + nPhp].bus)
  // yields a translation error with OCT 1.55.
  connect(busPla2, pumPriSep.bus)
    annotation(Line(points={{-80,-280},{0,-280},{0,-340}},
      color={255,204,51},
      thickness=0.5));
  // HACK(AntoineGautier): Connecting busPla2.valHeaWatHpInlIso and busPla2.valChiWatHpInlIso
  // **before** connecting busPla2 yields a NullPointerException with OCT 1.55.
  connect(ctlSep.bus, busPla2)
    annotation(Line(points={{-120,-280},{-80,-280}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla2.valHeaWatHpInlIso, valHeaWatIsoSep.bus)
    annotation(Line(points={{-80,-280},{-20,-280},{-20,-290}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla2.valChiWatHpInlIso, valChiWatIsoSep.bus)
    annotation(Line(points={{-80,-280},{20,-280},{20,-310}},
      color={255,204,51},
      thickness=0.5));
  connect(valHeaWatIsoHdr[1:nHp].port_b, pumPriNoDed.ports_aChiHeaWat)
    annotation(Line(points={{10,-40},{68,-40},{68,-100},{65.8,-100}},
      color={0,127,255}));
  connect(valChiWatIsoHdr[1:nHp].port_b, pumPriNoDed.ports_aChiHeaWat)
    annotation(Line(points={{40,-60},{62,-60},{62,-100},{65.8,-100}},
      color={0,127,255}));
  connect(busPla.valHeaWatPhpInlIso, valHeaWatIsoHdr[nHp + 1:nHp + nPhp].bus)
    annotation(Line(points={{-200,0},{6,0},{6,-30},{0,-30}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla.valChiWatPhpInlIso, valChiWatIsoHdr[nHp + 1:nHp + nPhp].bus)
    annotation(Line(points={{-200,0},{36,0},{36,-50},{30,-50}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla.valHeaWatHpInlIso[1:nHp], valHeaWatIsoHdr[1:nHp].bus)
    annotation(Line(points={{-200,0},{0,0},{0,-30}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla.valChiWatHpInlIso[1:nHp], valChiWatIsoHdr[1:nHp].bus)
    annotation(Line(points={{-200,0},{30,0},{30,-50}},
      color={255,204,51},
      thickness=0.5));
  connect(pumPriNoDed.ports_bChiWatSupShc, pumChiWatPriHdr.ports_a[nHp + 1:nHp +
    nPhp])
    annotation(Line(points={{-12,-100},{-12,-80},{-40,-80},{-40,-60}},
      color={0,127,255}));
  connect(pumPriNoDed.ports_bHeaWatSupShc, pumHeaWatPriHdr.ports_a[nHp + 1:nHp +
    nPhp])
    annotation(Line(points={{-28,-100},{-28,-90},{-110,-90},{-110,-40}},
      color={0,127,255}));
  connect(pumPriNoDed.ports_bChiHeaWat, pumHeaWatPriHdr.ports_a[1:nHp])
    annotation(Line(points={{-44,-100},{-120,-100},{-120,-40},{-110,-40}},
      color={0,127,255}));
  connect(pumPriNoDed.ports_bChiHeaWat, pumChiWatPriHdr.ports_a[1:nHp])
    annotation(Line(points={{-44,-100},{-44,-60},{-40,-60}},
      color={0,127,255}));
  connect(pumChiWatPriHdr.ports_b, valChiWatIsoHdr.port_a)
    annotation(Line(points={{-20,-60},{20,-60}},
      color={0,127,255}));
  connect(pumHeaWatPriHdr.ports_b, valHeaWatIsoHdr.port_a)
    annotation(Line(points={{-90,-40},{-10,-40}},
      color={0,127,255}));
  connect(ret1.ports, valHeaWatIsoHdr.port_b)
    annotation(Line(points={{100,-20},{100,-40},{10,-40}},
      color={0,127,255}));
  connect(ret5.ports, valChiWatIsoHdr[nHp + 1:nHp + nPhp].port_b)
    annotation(Line(points={{120,-60},{40,-60}},
      color={0,127,255}));
annotation(__Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/HeatPumps/Components/Validation/PumpsPrimaryDedicatedPolyvalent.mos"
    "Simulate and plot"),
  experiment(Tolerance=1e-06,
    StopTime=5000),
  Diagram(coordinateSystem(extent={{-300,-520},{300,360}})),
  Documentation(
    info="<html>
<p>
  This model validates the model
  <a href=\"modelica://Buildings.Templates.Plants.HeatPumps.Components.PumpsPrimaryDedicated\">
    Buildings.Templates.Plants.HeatPumps.Components.PumpsPrimaryDedicated</a>
  for the following plant configurations.
</p>
<ul>
  <li>
    Heat pumps with a single dedicated primary pump serving both CHW and HW
    circuits, polyvalent units with constant speed dedicated primary pumps:
    component <code>pumPriCom</code>.
  </li>
  <li>
    Plant with headered constant speed primary pumps: component
    <code>pumPriHdr</code>.
  </li>
  <li>
    Plant with separate constant speed dedicated HW and CHW pumps: component
    <code>pumPriSep</code>.
  </li>
</ul>
<p>
  In each configuration, two identical heat pumps and two identical polyvalent
  units are represented by fixed flow resistances (components
  <code>hp*</code>, <code>phpCon*</code> and <code>phpEva*</code>).
</p>
<p>
  The model uses open loop controls and the simulation allows verifying that
  design flow is obtained in each loop and each unit when the pumps are
  enabled.
</p>
<p>
  In the configurations with headered pumps, or with a single dedicated
  primary pump serving both CHW and HW circuits, this requires adjusting the
  design pressure drop of the balancing valves which are modeled by fixed flow
  resistances in the isolation valve components <code>valHeaWatIso*</code> and
  <code>valChiWatIso*</code>. This adjustment is done programmatically using
  the function
  <a href=\"modelica://Buildings.Templates.Utilities.computeBalancingPressureDrop\">
    Buildings.Templates.Utilities.computeBalancingPressureDrop</a>.
</p>
</html>",
    revisions="<html>
<ul>
  <li>
    July 10, 2026, by Antoine Gautier:<br />
    First implementation.
  </li>
</ul>
</html>"));
end PumpsPrimaryDedicatedPolyvalent;
