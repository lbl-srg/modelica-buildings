within Buildings.Templates.Plants.HeatPumps.Components.Validation;
model PumpsPrimaryDedicated
  "Validation model for dedicated primary pump component"
  extends Modelica.Icons.Example;
  parameter Buildings.Templates.Plants.HeatPumps.Types.Controller typCtl=
    Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop;
  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CHW/HW medium";
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,
    Dialog(tab="Dynamics",group="Conservation equations"));
  parameter Data.Controller datCtl(
    cfg(
      have_valHpOutIso=false,
      have_valHpInlIso=true,
      have_chiWat=true,
      have_pumChiWatPriDed=false,
      typPumHeaWatSec=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None,
      typDis=Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Only,
      nPumChiWatSec=0,
      rhoHeaWat_default=Buildings.Media.Water.d_const,
      typCtl=Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop,
      is_rev=true,
      typ=Buildings.Templates.Components.Types.HeatPump.AirToWater,
      rhoChiWat_default=Buildings.Media.Water.d_const,
      cpChiWat_default=Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
      have_hotWat=false,
      have_valChiWatMinByp=false,
      have_valHeaWatMinByp=false,
      typMod=Buildings.Templates.Components.Types.HeatPumpModel.EquationFit,
      have_senVHeaWatSec=false,
      have_varPumChiWatPri=false,
      cpHeaWat_default=Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
      cpSou_default=Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
      have_varPumHeaWatPri=false,
      have_senDpChiWatLoc=false,
      typArrPumPri=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
      nHp=2,
      nPumHeaWatPri=2,
      have_heaWat=true,
      nPumHeaWatSec=0,
      rhoSou_default=Buildings.Media.Air.dStp,
      have_senDpHeaWatLoc=false,
      typPumChiWatSec=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None,
      nPumChiWatPri=0,
      have_senVChiWatSec=false,
      nSenDpHeaWatRem=0,
      nSenDpChiWatRem=0,
      nAirHan=0,
      nEquZon=0),
    THeaWatSupHp_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    TChiWatSupHp_nominal=Buildings.Templates.Data.Defaults.TChiWatSup)
    "Controller parameters"
    annotation (Placement(transformation(extent={{-120,260},{-100,280}})));
  parameter Data.Controller datCtlNoDed(
    cfg(
      have_valHpOutIso=false,
      have_valHpInlIso=true,
      have_chiWat=true,
      have_pumChiWatPriDed=false,
      typPumHeaWatSec=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None,
      typDis=Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Only,
      nPumChiWatSec=0,
      rhoHeaWat_default=Buildings.Media.Water.d_const,
      typCtl=Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop,
      is_rev=true,
      typ=Buildings.Templates.Components.Types.HeatPump.AirToWater,
      rhoChiWat_default=Buildings.Media.Water.d_const,
      cpChiWat_default=Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
      have_hotWat=false,
      have_valChiWatMinByp=false,
      have_valHeaWatMinByp=false,
      typMod=Buildings.Templates.Components.Types.HeatPumpModel.EquationFit,
      have_senVHeaWatSec=false,
      have_varPumChiWatPri=false,
      cpHeaWat_default=Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
      cpSou_default=Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
      have_varPumHeaWatPri=false,
      have_senDpChiWatLoc=false,
      typArrPumPri=Buildings.Templates.Components.Types.PumpArrangement.Headered,
      nHp=2,
      nPumHeaWatPri=2,
      have_heaWat=true,
      nPumHeaWatSec=0,
      rhoSou_default=Buildings.Media.Air.dStp,
      have_senDpHeaWatLoc=false,
      typPumChiWatSec=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None,
      nPumChiWatPri=0,
      have_senVChiWatSec=false,
      nSenDpHeaWatRem=0,
      nSenDpChiWatRem=0,
      nAirHan=0,
      nEquZon=0),
    THeaWatSupHp_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    TChiWatSupHp_nominal=Buildings.Templates.Data.Defaults.TChiWatSup)
    "Controller parameters"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));

  parameter Data.Controller datCtlSep(
    cfg(
      have_valHpOutIso=false,
      have_valHpInlIso=true,
      have_chiWat=true,
      have_pumChiWatPriDed=true,
      typPumHeaWatSec=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None,
      typDis=Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Only,
      nPumChiWatSec=0,
      rhoHeaWat_default=Buildings.Media.Water.d_const,
      typCtl=Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop,
      is_rev=true,
      typ=Buildings.Templates.Components.Types.HeatPump.AirToWater,
      rhoChiWat_default=Buildings.Media.Water.d_const,
      cpChiWat_default=Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
      have_hotWat=false,
      have_valChiWatMinByp=false,
      have_valHeaWatMinByp=false,
      typMod=Buildings.Templates.Components.Types.HeatPumpModel.EquationFit,
      have_senVHeaWatSec=false,
      have_varPumChiWatPri=false,
      cpHeaWat_default=Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
      cpSou_default=Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
      have_varPumHeaWatPri=false,
      have_senDpChiWatLoc=false,
      typArrPumPri=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
      nHp=2,
      nPumHeaWatPri=2,
      nPumChiWatPri=2,
      have_heaWat=true,
      nPumHeaWatSec=0,
      rhoSou_default=Buildings.Media.Air.dStp,
      have_senDpHeaWatLoc=false,
      typPumChiWatSec=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None,
      have_senVChiWatSec=false,
      nSenDpHeaWatRem=0,
      nSenDpChiWatRem=0,
      nAirHan=0,
      nEquZon=0),
    THeaWatSupHp_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    TChiWatSupHp_nominal=Buildings.Templates.Data.Defaults.TChiWatSup)
    "Controller parameters"
    annotation (Placement(transformation(extent={{-120,-160},{-100,-140}})));
  parameter Data.Controller datCtlHea(
    cfg(
      have_valHpOutIso=false,
      have_valHpInlIso=false,
      have_chiWat=false,
      have_pumChiWatPriDed=false,
      typPumHeaWatSec=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None,
      typDis=Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Only,
      nPumChiWatSec=0,
      rhoHeaWat_default=Buildings.Media.Water.d_const,
      typCtl=Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop,
      is_rev=false,
      typ=Buildings.Templates.Components.Types.HeatPump.AirToWater,
      rhoChiWat_default=Buildings.Media.Water.d_const,
      cpChiWat_default=Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
      have_hotWat=false,
      have_valChiWatMinByp=false,
      have_valHeaWatMinByp=false,
      typMod=Buildings.Templates.Components.Types.HeatPumpModel.EquationFit,
      have_senVHeaWatSec=false,
      have_varPumChiWatPri=false,
      cpHeaWat_default=Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
      cpSou_default=Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
      have_varPumHeaWatPri=true,
      have_senDpChiWatLoc=false,
      typArrPumPri=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
      nHp=2,
      nPumHeaWatPri=2,
      nPumChiWatPri=0,
      have_heaWat=true,
      nPumHeaWatSec=0,
      rhoSou_default=Buildings.Media.Air.dStp,
      have_senDpHeaWatLoc=false,
      typPumChiWatSec=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None,
      have_senVChiWatSec=false,
      nSenDpHeaWatRem=0,
      nSenDpChiWatRem=0,
      nAirHan=0,
      nEquZon=0),
    THeaWatSupHp_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed)
    "Controller parameters"
    annotation (Placement(transformation(extent={{-120,-360},{-100,-340}})));
  parameter Data.HeatPumpGroup datHp(
    final nHp=2,
    final typ=Buildings.Templates.Components.Types.HeatPump.AirToWater,
    final is_rev=true,
    final typMod=Buildings.Templates.Components.Types.HeatPumpModel.EquationFit,
    mHeaWatHp_flow_nominal=datHp.capHeaHp_nominal / abs(datHp.THeaWatSupHp_nominal -
      Buildings.Templates.Data.Defaults.THeaWatRetMed) / Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    dpHeaWatHp_nominal=Buildings.Templates.Data.Defaults.dpHeaWatHp,
    capHeaHp_nominal=500E3,
    THeaWatSupHp_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    TSouHeaHp_nominal=Buildings.Templates.Data.Defaults.TOutHpHeaLow,
    mChiWatHp_flow_nominal=datHp.capCooHp_nominal / abs(datHp.TChiWatSupHp_nominal -
      Buildings.Templates.Data.Defaults.TChiWatRet) / Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    capCooHp_nominal=500E3,
    TChiWatSupHp_nominal=Buildings.Templates.Data.Defaults.TChiWatSup,
    TSouCooHp_nominal=Buildings.Templates.Data.Defaults.TOutHpCoo,
    perFitHp(
      hea(
        P=datHp.capHeaHp_nominal / Buildings.Templates.Data.Defaults.COPHpAwHea,
        coeQ={- 4.2670305442, - 0.7381077035, 6.0049480456, 0, 0},
        coeP={- 4.9107455513, 5.3665308366, 0.5447612754, 0, 0},
        TRefLoa=Buildings.Templates.Data.Defaults.THeaWatRetMed,
        TRefSou=Buildings.Templates.Data.Defaults.TOutHpHeaLow),
      coo(
        P=datHp.capCooHp_nominal / Buildings.Templates.Data.Defaults.COPHpAwCoo,
        coeQ={- 2.2545246871, 6.9089257665, - 3.6548225094, 0, 0},
        coeP={- 5.8086010402, 1.6894933858, 5.1167787436, 0, 0},
        TRefLoa=Buildings.Templates.Data.Defaults.TChiWatRet,
        TRefSou=Buildings.Templates.Data.Defaults.TOutHpCoo)))
    "HP parameters"
    annotation (Placement(transformation(extent={{100,160},{120,180}})));
  parameter Buildings.Templates.Components.Data.PumpMultiple datPumPri(
    typ=Buildings.Templates.Components.Types.Pump.Multiple,
    nPum=datHp.nHp,
    m_flow_nominal=fill(max(datHp.mHeaWatHp_flow_nominal, datHp.mChiWatHp_flow_nominal),
        datHp.nHp),
    dp_nominal=fill(max(datHp.dpHeaWatHp_nominal, datHp.dpChiWatHp_nominal) +
        Buildings.Templates.Data.Defaults.dpValChe + max(max(valChiWatIso.dpValve_nominal),
        max(valHeaWatIso.dpValve_nominal)), datHp.nHp))
  "Primary pump parameters"
    annotation (Placement(transformation(extent={{140,160},{160,180}})));
  parameter Buildings.Templates.Components.Data.PumpMultiple datPumHeaWat(
    typ=Buildings.Templates.Components.Types.Pump.Multiple,
    nPum=datHp.nHp,
    m_flow_nominal=fill(datHp.mHeaWatHp_flow_nominal, datHp.nHp),
    dp_nominal=fill(datHp.dpHeaWatHp_nominal + Buildings.Templates.Data.Defaults.dpValChe
     + max(valHeaWatIso.dpValve_nominal), datHp.nHp)) "Dedicated primary HW pump parameters"
    annotation (Placement(transformation(extent={{100,-260},{120,-240}})));
  parameter Buildings.Templates.Components.Data.PumpMultiple datPumChiWat(
    typ=Buildings.Templates.Components.Types.Pump.Multiple,
    nPum=datHp.nHp,
    m_flow_nominal=fill(datHp.mChiWatHp_flow_nominal,datHp.nHp),
    dp_nominal=fill(datHp.dpChiWatHp_nominal + Buildings.Templates.Data.Defaults.dpValChe
    + max(valHeaWatIso.dpValve_nominal), datHp.nHp))
    "Dedicated primary CHW pump parameters"
    annotation (Placement(transformation(extent={{140,-260},{160,-240}})));
  Buildings.Templates.Plants.HeatPumps.Components.PumpsPrimaryDedicated pumPri(
    redeclare final package Medium=Medium,
    nHp=2,
    typArrPumPri=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
    have_pumChiWatPriDed=false,
    have_varPumHeaWatPri=false,
    datPumHeaWat=datPumPri,
    final energyDynamics=energyDynamics)
    "Primary pumps - CHW and HW system with common constant speed dedicated primary pumps"
    annotation (Placement(transformation(extent={{-120,160},{80,240}})));
  Fluid.FixedResistances.PressureDrop hp[pumPri.nHp](
    redeclare each final package Medium=Medium,
    each m_flow_nominal=datHp.mHeaWatHp_flow_nominal,
    each dp_nominal=datHp.dpHeaWatHp_nominal)
    "Heat pump HX"
    annotation (Placement(transformation(extent={{-10,130},{-30,150}})));
  Fluid.Sources.Boundary_pT ret(
    redeclare final package Medium = Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=datHp.nHp)
              "Boundary condition at return"
    annotation (Placement(transformation(extent={{80,270},{60,290}})));
  Controls.OpenLoop ctl(final cfg=datCtl.cfg, final dat=datCtl)
    "Plant controller"
    annotation (Placement(transformation(extent={{-100,290},{-120,310}})));


  Buildings.Templates.Plants.HeatPumps.Components.PumpsPrimaryDedicated pumPriNoDed(
    redeclare final package Medium = Medium,
    nHp=2,
    typArrPumPri=Buildings.Templates.Components.Types.PumpArrangement.Headered,
    datPumHeaWat=datPumPri,
    final energyDynamics=energyDynamics)
    "No dedicated primary pumps (headered pumps)"
    annotation (Placement(transformation(extent={{-120,-60},{80,20}})));

  Fluid.FixedResistances.PressureDrop hpNoDed[pumPri.nHp](
    redeclare each final package Medium = Medium,
    each m_flow_nominal=datHp.mHeaWatHp_flow_nominal,
    each dp_nominal=datHp.dpHeaWatHp_nominal) "Heat pump HX"
    annotation (Placement(transformation(extent={{-10,-90},{-30,-70}})));
  Fluid.Sources.Boundary_pT ret1(
    redeclare final package Medium = Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=datHp.nHp)
              "Boundary condition at return"
    annotation (Placement(transformation(extent={{70,70},{50,90}})));
  Controls.OpenLoop ctlNoDed(final cfg=datCtlNoDed.cfg, final dat=datCtlNoDed)
    "Plant controller"
    annotation (Placement(transformation(extent={{-100,90},{-120,110}})));
  Buildings.Templates.Components.Pumps.Multiple pumPriHdr(
    have_var=false,
    final energyDynamics=energyDynamics,
    nPum=2,
    dat=datPumPri) "Headered primary pumps"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Templates.Plants.HeatPumps.Interfaces.Bus busPla
    "Plant control bus" annotation (Placement(iconVisible=false,transformation(extent={{-100,80},
            {-60,120}}), iconTransformation(extent={{-332,42},{-292,82}})));

  Buildings.Templates.Plants.HeatPumps.Components.PumpsPrimaryDedicated pumPriSep(
    redeclare final package Medium = Medium,
    nHp=2,
    typArrPumPri=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
    have_pumChiWatPriDed=true,
    have_varPumHeaWatPri=false,
    have_varPumChiWatPri=false,
    datPumHeaWat=datPumHeaWat,
    final datPumChiWat=datPumChiWat,
    final energyDynamics=energyDynamics)
    "Primary pumps - CHW and HW system with separate constant speed dedicated CHW pumps"
    annotation (Placement(transformation(extent={{-120,-260},{80,-180}})));

  Fluid.Sources.Boundary_pT ret2(
    redeclare final package Medium = Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=datHp.nHp)
              "Boundary condition at return"
    annotation (Placement(transformation(extent={{70,-150},{50,-130}})));
  Controls.OpenLoop ctlSep(final cfg=datCtlSep.cfg, final dat=datCtlSep)
    "Plant controller"
    annotation (Placement(transformation(extent={{-100,-130},{-120,-110}})));
  Fluid.FixedResistances.PressureDrop hpSep[pumPri.nHp](
    redeclare each final package Medium = Medium,
    each m_flow_nominal=datHp.mHeaWatHp_flow_nominal,
    each dp_nominal=datHp.dpHeaWatHp_nominal) "Heat pump HX"
    annotation (Placement(transformation(extent={{-10,-290},{-30,-270}})));
  Buildings.Templates.Components.Actuators.Valve valHeaWatIso[datHp.nHp](
    redeclare each final package Medium = Medium,
    each typ=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition, dat(
    each m_flow_nominal=datHp.mHeaWatHp_flow_nominal,
    each dpValve_nominal=Buildings.Templates.Data.Defaults.dpValIso,
    dpFixed_nominal=datPumPri.dp_nominal - valHeaWatIso.dpValve_nominal -
    fill(Buildings.Templates.Data.Defaults.dpValChe, datHp.nHp) ./
    datPumPri.m_flow_nominal .^2 .* valHeaWatIso.m_flow_nominal .^2 -
    fill(datHp.dpHeaWatHp_nominal, datHp.nHp)),
    each from_dp=true)
    "Primary HW loop isolation valve"
    annotation (Placement(transformation(extent={{-10,270},{10,290}})));
  Buildings.Templates.Components.Actuators.Valve valChiWatIso[datHp.nHp](
    redeclare each final package Medium = Medium,
    each typ=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition, dat(
    each m_flow_nominal=datHp.mChiWatHp_flow_nominal,
    each dpValve_nominal=Buildings.Templates.Data.Defaults.dpValIso,
    dpFixed_nominal=datPumPri.dp_nominal - valChiWatIso.dpValve_nominal -
    fill(Buildings.Templates.Data.Defaults.dpValChe, datHp.nHp) ./
    datPumPri.m_flow_nominal .^2 .* valChiWatIso.m_flow_nominal .^2 -
    fill(datHp.dpChiWatHp_nominal, datHp.nHp)),
    each from_dp=true)
    "Primary CHW loop isolation valve"
    annotation (Placement(transformation(extent={{-40,250},{-20,270}})));
  Buildings.Templates.Plants.HeatPumps.Interfaces.Bus busPla1
    "Plant control bus" annotation (Placement(iconVisible=false, transformation(extent={{-90,280},
            {-50,320}}), iconTransformation(extent={{-332,42},{-292,82}})));
  Buildings.Templates.Components.Actuators.Valve valChiWatIsoNoDed[datHp.nHp](
    redeclare each final package Medium = Medium,
    each typ=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition,
    dat(
      each m_flow_nominal=datHp.mChiWatHp_flow_nominal,
      each dpValve_nominal=Buildings.Templates.Data.Defaults.dpValIso,
      dpFixed_nominal=datPumPri.dp_nominal - valChiWatIsoNoDed.dpValve_nominal -
          fill(Buildings.Templates.Data.Defaults.dpValChe, datHp.nHp) ./
          datPumPri.m_flow_nominal .^ 2 .* valChiWatIsoNoDed.m_flow_nominal .^ 2
           - fill(datHp.dpChiWatHp_nominal, datHp.nHp)),
    each from_dp=true) "Primary CHW loop isolation valve"
    annotation (Placement(transformation(extent={{-20,48},{0,68}})));
  Buildings.Templates.Components.Actuators.Valve valHeaWatIsoNoDed[datHp.nHp](
    redeclare each final package Medium = Medium,
    each typ=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition,
    dat(
      each m_flow_nominal=datHp.mHeaWatHp_flow_nominal,
      each dpValve_nominal=Buildings.Templates.Data.Defaults.dpValIso,
      dpFixed_nominal=datPumPri.dp_nominal - valHeaWatIsoNoDed.dpValve_nominal -
          fill(Buildings.Templates.Data.Defaults.dpValChe, datHp.nHp) ./
          datPumPri.m_flow_nominal .^ 2 .* valHeaWatIsoNoDed.m_flow_nominal .^ 2
           - fill(datHp.dpHeaWatHp_nominal, datHp.nHp)),
    each from_dp=true) "Primary HW loop isolation valve"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Buildings.Templates.Components.Actuators.Valve valHeaWatIsoSep[datHp.nHp](
    redeclare each final package Medium = Medium,
    each typ=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition,
    dat(each m_flow_nominal=datHp.mHeaWatHp_flow_nominal, each dpValve_nominal=
          Buildings.Templates.Data.Defaults.dpValIso),
    each from_dp=true,
    each linearized=true)
    "Primary HW loop isolation valve"
    annotation (Placement(transformation(extent={{-20,-150},{0,-130}})));
  Buildings.Templates.Components.Actuators.Valve valChiWatIsoSep[datHp.nHp](
    redeclare each final package Medium = Medium,
    each typ=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition,
    dat(each m_flow_nominal=datHp.mChiWatHp_flow_nominal, each dpValve_nominal=
          Buildings.Templates.Data.Defaults.dpValIso),
    each from_dp=true,
    each linearized=true) "Primary CHW loop isolation valve"
    annotation (Placement(transformation(extent={{-50,-170},{-30,-150}})));
  Buildings.Templates.Plants.HeatPumps.Interfaces.Bus busPla2
    "Plant control bus" annotation (Placement(iconVisible=false, transformation(extent={{-100,
            -140},{-60,-100}}),
                         iconTransformation(extent={{-332,42},{-292,82}})));
  Buildings.Templates.Plants.HeatPumps.Components.PumpsPrimaryDedicated pumPriHea(
    redeclare final package Medium = Medium,
    nHp=2,
    typArrPumPri=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
    have_pumChiWatPriDed=false,
    have_varPumHeaWatPri=true,
    datPumHeaWat=datPumHeaWat,
    final energyDynamics=energyDynamics)
    "Primary pumps - Heating only system with variable speed dedicated primary pumps"
    annotation (Placement(transformation(extent={{-120,-460},{80,-380}})));

  Fluid.Sources.Boundary_pT ret3(
    redeclare final package Medium = Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=1) "Boundary condition at return"
    annotation (Placement(transformation(extent={{70,-350},{50,-330}})));
  Controls.OpenLoop ctlHea(final cfg=datCtlHea.cfg, final dat=datCtlHea)
    "Plant controller"
    annotation (Placement(transformation(extent={{-100,-330},{-120,-310}})));
  Fluid.FixedResistances.PressureDrop hpHea[pumPri.nHp](
    redeclare each final package Medium = Medium,
    each m_flow_nominal=datHp.mHeaWatHp_flow_nominal,
    each dp_nominal=datHp.dpHeaWatHp_nominal) "Heat pump HX"
    annotation (Placement(transformation(extent={{-10,-490},{-30,-470}})));
  Fluid.FixedResistances.PressureDrop priHeaWat(
    redeclare final package Medium = Medium,
    final m_flow_nominal=sum(datPumHeaWat.m_flow_nominal),
    final dp_nominal=0)
    "Primary HW loop"
    annotation (Placement(transformation(extent={{-10,-350},{10,-330}})));
equation
  for i in 1:pumPriHea.nHp loop
  connect(pumPriHea.ports_bChiHeaWat[i], priHeaWat.port_a) annotation (Line(
        points={{-70,-380},{-68,-380},{-68,-340},{-10,-340}}, color={0,127,255}));
  connect(priHeaWat.port_b, pumPriHea.ports_aChiHeaWat[i]) annotation (Line(
        points={{10,-340},{30,-340},{30,-380}}, color={0,127,255}));
  end for;
  connect(pumPri.ports_bChiHeaWatHp, hp.port_a)
    annotation (Line(points={{30,160},{30,140},{-10,140}},
                                                       color={0,127,255}));
  connect(hp.port_b,pumPri. ports_aChiHeaWatHp)
    annotation (Line(points={{-30,140},{-70,140},{-70,160}},
                                                          color={0,127,255}));
  connect(pumPriNoDed.ports_bChiHeaWatHp, hpNoDed.port_a)
    annotation (Line(points={{30,-60},{30,-80},{-10,-80}}, color={0,127,255}));
  connect(hpNoDed.port_b, pumPriNoDed.ports_aChiHeaWatHp) annotation (Line(
        points={{-30,-80},{-70,-80},{-70,-60}}, color={0,127,255}));
  connect(pumPriNoDed.ports_bChiHeaWat,pumPriHdr. ports_a) annotation (Line(
        points={{-70,20},{-70,60},{-60,60}},   color={0,127,255}));
  connect(ctlNoDed.bus, busPla) annotation (Line(
      points={{-100,100},{-80,100}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla.pumHeaWatPri,pumPriHdr. bus) annotation (Line(
      points={{-80,100},{-50,100},{-50,70}},
      color={255,204,51},
      thickness=0.5));
  connect(pumPriSep.ports_bChiHeaWatHp, hpSep.port_a) annotation (Line(points={{30,-260},
          {30,-280},{-10,-280}},          color={0,127,255}));
  connect(hpSep.port_b, pumPriSep.ports_aChiHeaWatHp) annotation (Line(points={{-30,
          -280},{-70,-280},{-70,-260}},     color={0,127,255}));
  connect(pumPri.ports_bChiHeaWat, valHeaWatIso.port_a) annotation (Line(points={{-70,240},
          {-70,280},{-10,280}},           color={0,127,255}));
  connect(valHeaWatIso.port_b, pumPri.ports_aChiHeaWat)
    annotation (Line(points={{10,280},{30,280},{30,240}}, color={0,127,255}));
  connect(pumPri.ports_bChiHeaWat, valChiWatIso.port_a) annotation (Line(points={{-70,240},
          {-70,260},{-40,260}},           color={0,127,255}));
  connect(valChiWatIso.port_b, pumPri.ports_aChiHeaWat)
    annotation (Line(points={{-20,260},{30,260},{30,240}}, color={0,127,255}));
  connect(ctl.bus, busPla1) annotation (Line(
      points={{-100,300},{-70,300}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla1.valHeaWatHpInlIso, valHeaWatIso.bus) annotation (Line(
      points={{-70,300},{0,300},{0,290}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla1.valChiWatHpInlIso, valChiWatIso.bus) annotation (Line(
      points={{-70,300},{-30,300},{-30,270}},
      color={255,204,51},
      thickness=0.5));
  connect(ret.ports, valHeaWatIso.port_b)
    annotation (Line(points={{60,280},{10,280}},          color={0,127,255}));
  connect(pumPriHdr.ports_b, valChiWatIsoNoDed.port_a)
    annotation (Line(points={{-40,60},{-30,60},{-30,58},{-20,58}},
                                                 color={0,127,255}));
  connect(pumPriHdr.ports_b, valHeaWatIsoNoDed.port_a) annotation (Line(points={
          {-40,60},{-30,60},{-30,80},{0,80}}, color={0,127,255}));
  connect(valHeaWatIsoNoDed.port_b, pumPriNoDed.ports_aChiHeaWat)
    annotation (Line(points={{20,80},{30,80},{30,20}}, color={0,127,255}));
  connect(valChiWatIsoNoDed.port_b, pumPriNoDed.ports_aChiHeaWat)
    annotation (Line(points={{0,58},{30,58},{30,20}}, color={0,127,255}));
  connect(ret1.ports, valHeaWatIsoNoDed.port_b)
    annotation (Line(points={{50,80},{20,80}}, color={0,127,255}));
  connect(busPla.valHeaWatHpInlIso, valHeaWatIsoNoDed.bus) annotation (Line(
      points={{-80,100},{10,100},{10,90}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla.valChiWatHpInlIso, valChiWatIsoNoDed.bus) annotation (Line(
      points={{-80,100},{-10,100},{-10,68}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla1, pumPri.bus) annotation (Line(
      points={{-70,300},{-20,300},{-20,240}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla2.valHeaWatHpInlIso, valHeaWatIsoSep.bus) annotation (Line(
      points={{-80,-120},{-10,-120},{-10,-130}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla2.valChiWatHpInlIso, valChiWatIsoSep.bus) annotation (Line(
      points={{-80,-120},{-40,-120},{-40,-150}},
      color={255,204,51},
      thickness=0.5));
  connect(ctlSep.bus, busPla2) annotation (Line(
      points={{-100,-120},{-80,-120}},
      color={255,204,51},
      thickness=0.5));
  connect(pumPriSep.ports_bHeaWat, valHeaWatIsoSep.port_a) annotation (Line(
        points={{-86,-180},{-86,-140},{-20,-140}}, color={0,127,255}));
  connect(pumPriSep.ports_bChiWat, valChiWatIsoSep.port_a) annotation (Line(
        points={{-54,-180},{-54,-160},{-50,-160}}, color={0,127,255}));
  connect(valHeaWatIsoSep.port_b, pumPriSep.ports_aChiHeaWat) annotation (Line(
        points={{0,-140},{30,-140},{30,-180}}, color={0,127,255}));
  connect(valChiWatIsoSep.port_b, pumPriSep.ports_aChiHeaWat) annotation (Line(
        points={{-30,-160},{30,-160},{30,-180}}, color={0,127,255}));
  connect(ret2.ports, valHeaWatIsoSep.port_b)
    annotation (Line(points={{50,-140},{0,-140}}, color={0,127,255}));
  connect(busPla2, pumPriSep.bus) annotation (Line(
      points={{-80,-120},{-20,-120},{-20,-180}},
      color={255,204,51},
      thickness=0.5));
  connect(pumPriHea.ports_bChiHeaWatHp, hpHea.port_a) annotation (Line(points={{
          30,-460},{30,-480},{-10,-480}}, color={0,127,255}));
  connect(hpHea.port_b, pumPriHea.ports_aChiHeaWatHp) annotation (Line(points={{
          -30,-480},{-70,-480},{-70,-460}}, color={0,127,255}));

  connect(priHeaWat.port_b, ret3.ports[1])
    annotation (Line(points={{10,-340},{50,-340}}, color={0,127,255}));
  connect(ctlHea.bus, pumPriHea.bus) annotation (Line(
      points={{-100,-320},{-20,-320},{-20,-380}},
      color={255,204,51},
      thickness=0.5));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/HeatPumps/Components/Validation/PumpsPrimaryDedicated.mos"
        "Simulate and plot"),
    experiment(
      Tolerance=1e-6,
      StopTime=5000.0),
    Diagram(
      coordinateSystem(
        extent={{-200,-520},{200,360}})));
end PumpsPrimaryDedicated;
