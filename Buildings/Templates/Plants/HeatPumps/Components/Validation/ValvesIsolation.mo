within Buildings.Templates.Plants.HeatPumps.Components.Validation;
model ValvesIsolation
  "Validation model for isolation valve component"
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
      have_pumHeaWatPriVar=true,
      have_pumChiWatPriVar=false,
      have_inpSch=false,
      have_hrc=false,
      have_valHpOutIso=valIsoCom.have_valHpOutIso,
      have_valHpInlIso=valIsoCom.have_valHpInlIso,
      have_chiWat=valIsoCom.have_chiWat,
      have_pumChiWatPriDed=valIsoCom.have_pumChiWatPriDed,
      typPumHeaWatPri=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable,
      typPumChiWatPri=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None,
      typPumHeaWatSec=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None,
      typTanHeaWat = Buildings.Templates.Components.Types.IntegrationPoint.None,
      typTanChiWat = Buildings.Templates.Components.Types.IntegrationPoint.None,
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
      cpHeaWat_default=Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
      cpSou_default=Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
      have_senDpChiWatRemWir=true,
      typArrPumPri=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
      nHp=2,
      nPumHeaWatPri=2,
      have_heaWat=true,
      nPumHeaWatSec=0,
      rhoSou_default=Buildings.Media.Air.dStp,
      have_senDpHeaWatRemWir=true,
      typPumChiWatSec=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None,
      nPumChiWatPri=0,
      nSenDpHeaWatRem=0,
      nSenDpChiWatRem=0,
      nAirHan=0,
      nEquZon=0),
    THeaWatSup_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    TChiWatSup_nominal=Buildings.Templates.Data.Defaults.TChiWatSup,
    dpChiWatRemSet_max=fill(Buildings.Templates.Data.Defaults.dpChiWatRemSet_max,
        datCtl.cfg.nSenDpChiWatRem),
    dpHeaWatRemSet_max=fill(Buildings.Templates.Data.Defaults.dpHeaWatRemSet_max,
        datCtl.cfg.nSenDpHeaWatRem),
    staEqu={fill(1, datCtl.cfg.nHp)}) "Controller parameters"
    annotation (Placement(transformation(extent={{-80,370},{-60,390}})));
  parameter Data.Controller datCtlHeaInl(
    cfg(
      have_pumHeaWatPriVar=true,
      have_pumChiWatPriVar=false,
      have_inpSch=false,
      have_hrc=false,
      have_valHpOutIso=valIsoHeaInl.have_valHpOutIso,
      have_valHpInlIso=valIsoHeaInl.have_valHpInlIso,
      have_chiWat=valIsoHeaInl.have_chiWat,
      have_pumChiWatPriDed=valIsoHeaInl.have_pumChiWatPriDed,
      typPumHeaWatPri=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable,
      typPumChiWatPri=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None,
      typTanHeaWat = Buildings.Templates.Components.Types.IntegrationPoint.None,
      typTanChiWat = Buildings.Templates.Components.Types.IntegrationPoint.None,
      is_rev=false,
      typPumHeaWatSec=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None,
      typDis=Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Only,
      nPumChiWatSec=0,
      rhoHeaWat_default=Buildings.Media.Water.d_const,
      typCtl=Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop,
      typ=Buildings.Templates.Components.Types.HeatPump.AirToWater,
      rhoChiWat_default=Buildings.Media.Water.d_const,
      cpChiWat_default=Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
      have_hotWat=false,
      have_valChiWatMinByp=false,
      have_valHeaWatMinByp=false,
      typMod=Buildings.Templates.Components.Types.HeatPumpModel.EquationFit,
      cpHeaWat_default=Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
      cpSou_default=Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
      have_senDpChiWatRemWir=true,
      typArrPumPri=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
      nHp=2,
      nPumHeaWatPri=2,
      have_heaWat=true,
      nPumHeaWatSec=0,
      rhoSou_default=Buildings.Media.Air.dStp,
      have_senDpHeaWatRemWir=true,
      typPumChiWatSec=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None,
      nPumChiWatPri=0,
      nSenDpHeaWatRem=0,
      nSenDpChiWatRem=0,
      nAirHan=0,
      nEquZon=0),
    THeaWatSup_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    TChiWatSup_nominal=Buildings.Templates.Data.Defaults.TChiWatSup,
        dpChiWatRemSet_max=fill(Buildings.Templates.Data.Defaults.dpChiWatRemSet_max, datCtlHeaInl.cfg.nSenDpChiWatRem),
    dpHeaWatRemSet_max=fill(Buildings.Templates.Data.Defaults.dpHeaWatRemSet_max, datCtlHeaInl.cfg.nSenDpHeaWatRem),
    staEqu={fill(1, datCtlHeaInl.cfg.nHp)})
    "Controller parameters"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));
  parameter Data.Controller datCtlSep(
    cfg(
      have_pumHeaWatPriVar=true,
      have_pumChiWatPriVar=false,
      have_inpSch=false,
      have_hrc=false,
      have_valHpOutIso=valIsoSep.have_valHpOutIso,
      have_valHpInlIso=valIsoSep.have_valHpInlIso,
      have_chiWat=valIsoSep.have_chiWat,
      have_pumChiWatPriDed=valIsoSep.have_pumChiWatPriDed,
      typPumHeaWatPri=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable,
      typPumChiWatPri=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable,
      typPumHeaWatSec=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None,
      typTanHeaWat = Buildings.Templates.Components.Types.IntegrationPoint.None,
      typTanChiWat = Buildings.Templates.Components.Types.IntegrationPoint.None,
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
      cpHeaWat_default=Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
      cpSou_default=Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
      have_senDpChiWatRemWir=true,
      typArrPumPri=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
      nHp=2,
      nPumHeaWatPri=2,
      have_heaWat=true,
      nPumHeaWatSec=0,
      rhoSou_default=Buildings.Media.Air.dStp,
      have_senDpHeaWatRemWir=true,
      typPumChiWatSec=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None,
      nPumChiWatPri=2,
      nSenDpHeaWatRem=0,
      nSenDpChiWatRem=0,
      nAirHan=0,
      nEquZon=0),
    THeaWatSup_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    TChiWatSup_nominal=Buildings.Templates.Data.Defaults.TChiWatSup,
    dpChiWatRemSet_max=fill(Buildings.Templates.Data.Defaults.dpChiWatRemSet_max, datCtlSep.cfg.nSenDpChiWatRem),
    dpHeaWatRemSet_max=fill(Buildings.Templates.Data.Defaults.dpHeaWatRemSet_max, datCtlSep.cfg.nSenDpHeaWatRem),
    staEqu={fill(1, datCtlSep.cfg.nHp)})
    "Controller parameters"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
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
    annotation (Placement(transformation(extent={{-40,190},{-20,210}})));
  Buildings.Templates.Plants.HeatPumps.Components.ValvesIsolation valIsoCom(
    redeclare final package Medium = Medium,
    nHp=2,
    have_chiWat=true,
    have_valHpInlIso=true,
    have_valHpOutIso=true,
    have_pumChiWatPriDed=false,
    final mHeaWatHp_flow_nominal=fill(datHp.mHeaWatHp_flow_nominal, valIsoCom.nHp),
    dpHeaWatHp_nominal=fill(datHp.dpHeaWatHp_nominal, valIsoCom.nHp),
    mChiWatHp_flow_nominal=fill(datHp.mChiWatHp_flow_nominal, valIsoCom.nHp),
    final energyDynamics=energyDynamics,
    y_start=0)
    "Isolation valves - Heating and cooling system with common dedicated primary HW and CHW pumps"
    annotation (Placement(transformation(extent={{-240,220},{240,360}})));
  Fluid.FixedResistances.PressureDrop hpCom[valIsoCom.nHp](
    redeclare each final package Medium = Medium,
    m_flow_nominal=valIsoCom.mHeaWatHp_flow_nominal,
    dp_nominal=fill(0, valIsoCom.nHp))
    "Heat pump HX with zero fluid resistance: pressure drop computed in valve component"
    annotation (Placement(transformation(extent={{10,210},{-10,230}})));
  Fluid.Sources.Boundary_pT retChiWat(
    redeclare final package Medium = Medium,
    p=supChiWat.p + max(valIsoCom.dpChiWat_nominal),
    T=Buildings.Templates.Data.Defaults.TChiWatRet,
    nPorts=1) "Boundary condition at CHW return"
    annotation (Placement(transformation(extent={{280,300},{260,320}})));
  Fluid.Sources.Boundary_pT retHeaWat(
    redeclare final package Medium = Medium,
    p=supHeaWat.p + max(valIsoCom.dpHeaWat_nominal),
    T=Buildings.Templates.Data.Defaults.THeaWatRetMed,
    nPorts=1) "Boundary condition at HW return"
    annotation (Placement(transformation(extent={{-280,320},{-260,340}})));
  Fluid.Sources.Boundary_pT supChiWat(
    redeclare final package Medium=Medium,
    p=Buildings.Templates.Data.Defaults.pChiWat_rel_nominal + 101325,
    nPorts=1)
    "Boundary condition at CHW supply"
    annotation (Placement(transformation(extent={{280,340},{260,360}})));
  Fluid.Sources.Boundary_pT supHeaWat(
    redeclare final package Medium=Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=1)
    "Boundary condition at HW supply"
    annotation (Placement(transformation(extent={{-280,280},{-260,300}})));
  Controls.OpenLoop ctl(
    final cfg=datCtl.cfg,
    final dat=datCtl)
    "Plant controller"
    annotation (Placement(transformation(extent={{-30,370},{-50,390}})));
  Buildings.Templates.Plants.HeatPumps.Components.ValvesIsolation valIsoHeaInl(
    redeclare final package Medium = Medium,
    nHp=2,
    have_chiWat=false,
    have_pumChiWatPriDed=false,
    have_valHpInlIso=true,
    have_valHpOutIso=false,
    final mHeaWatHp_flow_nominal=fill(datHp.mHeaWatHp_flow_nominal, valIsoCom.nHp),
    dpHeaWatHp_nominal=fill(datHp.dpHeaWatHp_nominal, valIsoCom.nHp),
    mChiWatHp_flow_nominal=fill(datHp.mChiWatHp_flow_nominal, valIsoCom.nHp),
    final energyDynamics=energyDynamics,
    y_start=0)
    "Isolation valves - Heating-only system with isolation valves at HP inlet"
    annotation (Placement(transformation(extent={{-240,-40},{240,100}})));
  Fluid.FixedResistances.PressureDrop hpHea[valIsoHeaInl.nHp](
    redeclare each final package Medium=Medium,
    m_flow_nominal=valIsoHeaInl.mHeaWatHp_flow_nominal,
    dp_nominal=fill(0, valIsoHeaInl.nHp))
    "Heat pump HX with zero fluid resistance: pressure drop computed in valve component"
    annotation (Placement(transformation(extent={{10,-50},{-10,-30}})));
  Fluid.Sources.Boundary_pT retHeaWat1(
    redeclare final package Medium=Medium,
    p=supHeaWat1.p + max(valIsoHeaInl.dpHeaWat_nominal),
    T=Buildings.Templates.Data.Defaults.THeaWatRetMed,
    nPorts=1)
    "Boundary condition at HW return"
    annotation (Placement(transformation(extent={{-280,60},{-260,80}})));
  Fluid.Sources.Boundary_pT supHeaWat1(
    redeclare final package Medium=Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=1)
    "Boundary condition at HW supply"
    annotation (Placement(transformation(extent={{-280,20},{-260,40}})));
  Controls.OpenLoop ctlHeaInl(
    final cfg=datCtlHeaInl.cfg,
    final dat=datCtlHeaInl)
    "Plant controller"
    annotation (Placement(transformation(extent={{-30,110},{-50,130}})));
  Buildings.Templates.Plants.HeatPumps.Components.ValvesIsolation valIsoSep(
    redeclare final package Medium = Medium,
    nHp=2,
    have_chiWat=true,
    have_valHpInlIso=true,
    have_valHpOutIso=false,
    have_pumChiWatPriDed=true,
    final mHeaWatHp_flow_nominal=fill(datHp.mHeaWatHp_flow_nominal, valIsoCom.nHp),
    dpHeaWatHp_nominal=fill(datHp.dpHeaWatHp_nominal, valIsoCom.nHp),
    mChiWatHp_flow_nominal=fill(datHp.mChiWatHp_flow_nominal, valIsoCom.nHp),
    final energyDynamics=energyDynamics,
    y_start=0,
    from_dp=false)
    "Isolation valves - Heating and cooling system with separate dedicated primary HW and CHW pumps"
    annotation (Placement(transformation(extent={{-240,-280},{240,-140}})));
  Fluid.FixedResistances.PressureDrop hpSep[valIsoSep.nHp](
    redeclare each final package Medium=Medium,
    m_flow_nominal=valIsoSep.mHeaWatHp_flow_nominal,
    dp_nominal=fill(0, valIsoSep.nHp))
    "Heat pump HX with zero fluid resistance: pressure drop computed in valve component"
    annotation (Placement(transformation(extent={{10,-370},{-10,-350}})));
  Fluid.Sources.Boundary_pT supHeaWat2(
    redeclare final package Medium=Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=2)
    "Boundary condition at HW supply"
    annotation (Placement(transformation(extent={{-280,-200},{-260,-180}})));
  Controls.OpenLoop ctlSep(
    final cfg=datCtlSep.cfg,
    final dat=datCtlSep)
    "Plant controller"
    annotation (Placement(transformation(extent={{-30,-130},{-50,-110}})));
  Fluid.Movers.Preconfigured.SpeedControlled_y pumChiWatPri[2](
    redeclare each final package Medium=Medium,
    each addPowerToMedium=false,
    each m_flow_nominal=datHp.mChiWatHp_flow_nominal,
    each final energyDynamics=energyDynamics,
    dp_nominal=valIsoSep.dpChiWat_nominal + cheValChiWat.dpValve_nominal)
    "Primary CHW pump"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=-90,
      origin={-34,-334})));
  Fluid.Movers.Preconfigured.SpeedControlled_y pumHeaWatPri[2](
    redeclare each final package Medium=Medium,
    each addPowerToMedium=false,
    each m_flow_nominal=datHp.mHeaWatHp_flow_nominal,
    each final energyDynamics=energyDynamics,
    dp_nominal=valIsoSep.dpHeaWat_nominal + cheValHeaWat.dpValve_nominal)
    "Primary HW pump"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=-90,
      origin={-66,-320})));
  Buildings.Templates.Plants.HeatPumps.Interfaces.Bus busPla
    "Plant controller"
    annotation (Placement(iconVisible=false,transformation(extent={{80,-140},{120,
            -100}}),
      iconTransformation(extent={{-548,-190},{-508,-150}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal yPumHeaWatPri[2]
    "Primary HW pump speed command"
    annotation (Placement(transformation(extent={{80,-336},{60,-316}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal yPumChiWatPri[2]
    "Primary CHW pump speed command"
    annotation (Placement(transformation(extent={{110,-356},{90,-336}})));
  Buildings.Templates.Components.Interfaces.Bus busPumHeaWatPri
    "Primary HW pump control bus"
    annotation (Placement(iconVisible=false,transformation(extent={{100,-346},{140,
            -306}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatPri
    "Primary CHW pump control bus"
    annotation (Placement(iconVisible=false,transformation(extent={{120,-366},{160,
            -326}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Fluid.FixedResistances.CheckValve cheValHeaWat[2](
    redeclare each final package Medium=Medium,
    each m_flow_nominal=datHp.mHeaWatHp_flow_nominal,
    each dpValve_nominal=Buildings.Templates.Data.Defaults.dpValChe)
    "Check valve"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=90,
      origin={-66,-296})));
  Fluid.FixedResistances.CheckValve cheValChiWat[2](
    redeclare each final package Medium=Medium,
    each m_flow_nominal=datHp.mChiWatHp_flow_nominal,
    each dpValve_nominal=Buildings.Templates.Data.Defaults.dpValChe)
    "Check valve"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=90,
      origin={-34,-306})));
equation
  connect(retHeaWat.ports[1], valIsoCom.port_aHeaWat) annotation (Line(points={{-260,
          330},{-240,330}},                           color={0,127,255}));
  connect(retChiWat.ports[1], valIsoCom.port_aChiWat)
    annotation (Line(points={{260,310},{240,310}}, color={0,127,255}));
  connect(valIsoCom.port_bChiWat, supChiWat.ports[1])
    annotation (Line(points={{240,350},{260,350}}, color={0,127,255}));
  connect(valIsoCom.port_bHeaWat, supHeaWat.ports[1]) annotation (Line(points={{-240,
          290},{-260,290}},                color={0,127,255}));
  connect(ctl.bus, valIsoCom.bus) annotation (Line(
      points={{-30,380},{0,380},{0,330}},
      color={255,204,51},
      thickness=0.5));
  connect(retHeaWat1.ports[1], valIsoHeaInl.port_aHeaWat)
    annotation (Line(points={{-260,70},{-240,70}},                     color={0,127,255}));
  connect(valIsoHeaInl.port_bHeaWat, supHeaWat1.ports[1])
    annotation (Line(points={{-240,30},{-260,30}},                     color={0,127,255}));
  connect(ctlHeaInl.bus, valIsoHeaInl.bus)
    annotation (Line(points={{-30,120},{0,120},{0,70}},    color={255,204,51},thickness=0.5));
  connect(valIsoCom.ports_bChiHeaWatHp, hpCom.port_a)
    annotation (Line(points={{50,220},{10,220}}, color={0,127,255}));
  connect(hpCom.port_b, valIsoCom.ports_aChiHeaWatHp)
    annotation (Line(points={{-10,220},{-50,220}}, color={0,127,255}));
  connect(valIsoHeaInl.ports_bChiHeaWatHp, hpHea.port_a)
    annotation (Line(points={{50,-40},{10,-40}},        color={0,127,255}));
  connect(hpHea.port_b, valIsoHeaInl.ports_aChiHeaWatHp)
    annotation (Line(points={{-10,-40},{-50,-40}},        color={0,127,255}));
  connect(valIsoSep.port_bHeaWat, supHeaWat2.ports[1])
    annotation (Line(points={{-240,-210},{-260,-210},{-260,-191}},
      color={0,127,255}));
  connect(ctlSep.bus, valIsoSep.bus)
    annotation (Line(points={{-30,-120},{0,-120},{0,-170}},  color={255,204,51},thickness=0.5));
  connect(valIsoSep.ports_bChiHeaWatHp, hpSep.port_a)
    annotation (Line(points={{50,-280},{50,-360},{10,-360}},color={0,127,255}));
  connect(supHeaWat2.ports[2], valIsoSep.port_aHeaWat)
    annotation (Line(points={{-260,-189},{-260,-170},{-240,-170}},
      color={0,127,255}));
  connect(ctlSep.bus, busPla)
    annotation (Line(points={{-30,-120},{100,-120}},
                                                  color={255,204,51},thickness=0.5));
  connect(busPla.pumHeaWatPri, busPumHeaWatPri)
    annotation (Line(points={{100,-120},{280,-120},{280,-326},{120,-326}},
                                                   color={255,204,51},thickness=0.5));
  connect(busPumHeaWatPri.y1, yPumHeaWatPri.u)
    annotation (Line(points={{120,-326},{82,-326}},color={255,204,51},thickness=0.5));
  connect(yPumHeaWatPri.y, pumHeaWatPri.y)
    annotation (Line(points={{58,-326},{0,-326},{0,-320},{-54,-320}},    color={0,0,127}));
  connect(busPla.pumChiWatPri, busPumChiWatPri)
    annotation (Line(points={{100,-120},{280,-120},{280,-346},{140,-346}},
                                                             color={255,204,51},thickness=0.5));
  connect(busPumChiWatPri.y1, yPumChiWatPri.u)
    annotation (Line(points={{140,-346},{112,-346}},
                                                   color={255,204,51},thickness=0.5));
  connect(yPumChiWatPri.y, pumChiWatPri.y)
    annotation (Line(points={{88,-346},{0,-346},{0,-334},{-22,-334}},    color={0,0,127}));
  connect(pumHeaWatPri.port_b, cheValHeaWat.port_a)
    annotation (Line(points={{-66,-310},{-66,-306}},color={0,127,255}));
  connect(cheValHeaWat.port_b, valIsoSep.ports_aHeaWatHp)
    annotation (Line(points={{-66,-286},{-66,-280}},color={0,127,255}));
  connect(cheValChiWat.port_b, valIsoSep.ports_aChiWatHp)
    annotation (Line(points={{-34,-296},{-34,-280}},  color={0,127,255}));
  connect(pumChiWatPri.port_b, cheValChiWat.port_a)
    annotation (Line(points={{-34,-324},{-34,-316}},color={0,127,255}));
  connect(hpSep.port_b, pumChiWatPri.port_a) annotation (Line(points={{-10,-360},
          {-34,-360},{-34,-344}}, color={0,127,255}));
  connect(hpSep.port_b, pumHeaWatPri.port_a) annotation (Line(points={{-10,-360},
          {-66,-360},{-66,-330}}, color={0,127,255}));
  connect(valIsoSep.port_bChiWat, valIsoSep.port_aChiWat) annotation (Line(
        points={{240,-150},{260,-150},{260,-190},{240,-190},{240,-190}}, color=
          {0,127,255}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/HeatPumps/Components/Validation/ValvesIsolation.mos"
        "Simulate and plot"),
    experiment(
      Tolerance=1e-6,
      StopTime=5000.0),
    Diagram(
      coordinateSystem(
        extent={{-300,-400},{300,400}})),
    Documentation(revisions="<html>
<ul>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model validates the model
<a href=\"modelica://Buildings.Templates.Plants.HeatPumps.Components.ValvesIsolation\">
Buildings.Templates.Plants.HeatPumps.Components.ValvesIsolation</a>
for the following configurations.
</p>
<ul>
<li>
Heating and cooling system with common dedicated primary HW and CHW pumps
and isolation valves at both heat pump inlet and outlet: 
component <code>valIsoCom</code>.
</li>
<li>
Heating-only system with isolation valves at heat pump inlet: 
component <code>valIsoHeaInl</code>.
</li>
<li>
Heating and cooling system with separate dedicated primary HW and CHW pumps
and isolation valves at heat pump inlet: 
component <code>valIsoSep</code>.
</li>
</ul>
<p>
In each configuration, two identical heat pumps are represented by fixed 
flow resistances (components <code>hp*</code>). 
</p>
<p>
The model uses open loop controls and the simulation allows verifying that design 
flow is obtained in each loop and each heat pump when the valves are open.
</p>
</html>"));
end ValvesIsolation;
