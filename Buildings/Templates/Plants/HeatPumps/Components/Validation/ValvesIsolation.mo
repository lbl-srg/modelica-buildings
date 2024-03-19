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
      have_valHpOutIso=valIso.have_valHpOutIso,
      have_valHpInlIso=valIso.have_valHpInlIso,
      have_chiWat=valIso.have_chiWat,
      have_pumChiWatPriDed=valIso.have_pumChiWatPriDed,
      typPumHeaWatPri=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable,
      typPumChiWatPri=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None,
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
      have_senVChiWatSec=false,
      nSenDpHeaWatRem=0,
      nSenDpChiWatRem=0,
      nAirHan=0,
      nEquZon=0),
    THeaWatSupHp_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    TChiWatSup_nominal=Buildings.Templates.Data.Defaults.TChiWatSup)
    "Controller parameters"
    annotation (Placement(transformation(extent={{-80,270},{-60,290}})));

  parameter Data.Controller datCtlHeaInl(
    cfg(
      have_valHpOutIso=valIsoHeaInl.have_valHpOutIso,
      have_valHpInlIso=valIsoHeaInl.have_valHpInlIso,
      have_chiWat=valIsoHeaInl.have_chiWat,
      have_pumChiWatPriDed=valIsoHeaInl.have_pumChiWatPriDed,
      typPumHeaWatPri=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable,
      typPumChiWatPri=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None,
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
      have_senVHeaWatSec=false,
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
      have_senVChiWatSec=false,
      nSenDpHeaWatRem=0,
      nSenDpChiWatRem=0,
      nAirHan=0,
      nEquZon=0),
    THeaWatSupHp_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    TChiWatSup_nominal=Buildings.Templates.Data.Defaults.TChiWatSup)
    "Controller parameters"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));

  parameter Data.Controller datCtlSep(
    cfg(
      have_valHpOutIso=valIsoSep.have_valHpOutIso,
      have_valHpInlIso=valIsoSep.have_valHpInlIso,
      have_chiWat=valIsoSep.have_chiWat,
      have_pumChiWatPriDed=valIsoSep.have_pumChiWatPriDed,
      typPumHeaWatPri=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable,
      typPumChiWatPri=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable,
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
      have_senVChiWatSec=false,
      nSenDpHeaWatRem=0,
      nSenDpChiWatRem=0,
      nAirHan=0,
      nEquZon=0),
    THeaWatSupHp_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    TChiWatSup_nominal=Buildings.Templates.Data.Defaults.TChiWatSup)
    "Controller parameters"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));

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
    annotation (Placement(transformation(extent={{100,180},{120,200}})));
  Buildings.Templates.Plants.HeatPumps.Components.ValvesIsolation valIso(
    redeclare final package Medium=Medium,
    nHp=2,
    have_chiWat=true,
    have_valHpInlIso=true,
    have_valHpOutIso=true,
    have_pumChiWatPriDed=false,
    final mHeaWatHp_flow_nominal=fill(datHp.mHeaWatHp_flow_nominal, valIso.nHp),
    dpHeaWatHp_nominal=fill(datHp.dpHeaWatHp_nominal, valIso.nHp),
    mChiWatHp_flow_nominal=fill(datHp.mChiWatHp_flow_nominal, valIso.nHp),
    final energyDynamics=energyDynamics,
    y_start=0)
    "Isolation valves - CHW and HW system without separate dedicated CHW pumps"
    annotation (Placement(transformation(extent={{-124,180},{76,260}})));
  Fluid.FixedResistances.PressureDrop hp[valIso.nHp](
    redeclare each final package Medium=Medium,
    m_flow_nominal=valIso.mHeaWatHp_flow_nominal,
    dp_nominal=fill(0, valIso.nHp))
    "Heat pump HX with zero fluid resistance: pressure drop computed in valve component"
    annotation (Placement(transformation(extent={{-10,150},{-30,170}})));
  Fluid.Sources.Boundary_pT retChiWat(
    redeclare final package Medium=Medium,
    p=supChiWat.p + max(valIso.dpChiWat_nominal),
    T=Buildings.Templates.Data.Defaults.TChiWatRet,
    nPorts=1)
    "Boundary condition at CHW return"
    annotation (Placement(transformation(extent={{140,222},{120,242}})));
  Fluid.Sources.Boundary_pT retHeaWat(
    redeclare final package Medium=Medium,
    p=supHeaWat.p + max(valIso.dpHeaWat_nominal),
    T=Buildings.Templates.Data.Defaults.THeaWatRetMed,
    nPorts=1)
    "Boundary condition at HW return"
    annotation (Placement(transformation(extent={{140,110},{120,130}})));
  Fluid.Sources.Boundary_pT supChiWat(
    redeclare final package Medium=Medium,
    p=Buildings.Templates.Data.Defaults.pChiWat_rel_nominal + 101325,
    nPorts=1)
    "Boundary condition at CHW supply"
    annotation (Placement(transformation(extent={{170,238},{150,258}})));
  Fluid.Sources.Boundary_pT supHeaWat(
    redeclare final package Medium=Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=1)
    "Boundary condition at HW supply"
    annotation (Placement(transformation(extent={{170,130},{150,150}})));
  Controls.OpenLoop ctl(
    final cfg=datCtl.cfg,
    final dat=datCtl)
    "Plant controller"
    annotation (Placement(transformation(extent={{-30,270},{-50,290}})));
  Buildings.Templates.Plants.HeatPumps.Components.ValvesIsolation valIsoHeaInl(
    redeclare final package Medium=Medium,
    nHp=2,
    have_chiWat=false,
    have_valHpInlIso=true,
    have_valHpOutIso=false,
    final mHeaWatHp_flow_nominal=fill(datHp.mHeaWatHp_flow_nominal, valIso.nHp),
    dpHeaWatHp_nominal=fill(datHp.dpHeaWatHp_nominal, valIso.nHp),
    mChiWatHp_flow_nominal=fill(datHp.mChiWatHp_flow_nominal, valIso.nHp),
    final energyDynamics=energyDynamics,
    y_start=0)
    "Isolation valves - Heating only system with isolation valves at inlet"
    annotation (Placement(transformation(extent={{-120,0},{80,80}})));
  Fluid.FixedResistances.PressureDrop hpHea[valIsoHeaInl.nHp](
    redeclare each final package Medium=Medium,
    m_flow_nominal=valIsoHeaInl.mHeaWatHp_flow_nominal,
    dp_nominal=fill(0, valIsoHeaInl.nHp))
    "Heat pump HX with zero fluid resistance: pressure drop computed in valve component"
    annotation (Placement(transformation(extent={{-10,-30},{-30,-10}})));
  Fluid.Sources.Boundary_pT retHeaWat1(
    redeclare final package Medium=Medium,
    p=supHeaWat1.p + max(valIsoHeaInl.dpHeaWat_nominal),
    T=Buildings.Templates.Data.Defaults.THeaWatRetMed,
    nPorts=1)
    "Boundary condition at HW return"
    annotation (Placement(transformation(extent={{140,-70},{120,-50}})));
  Fluid.Sources.Boundary_pT supHeaWat1(
    redeclare final package Medium=Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=1)
    "Boundary condition at HW supply"
    annotation (Placement(transformation(extent={{170,-50},{150,-30}})));
  Controls.OpenLoop ctlHeaInl(
    final cfg=datCtlHeaInl.cfg,
    final dat=datCtlHeaInl)
    "Plant controller"
    annotation (Placement(transformation(extent={{-30,90},{-50,110}})));
  Buildings.Templates.Plants.HeatPumps.Components.ValvesIsolation valIsoSep(
    redeclare final package Medium=Medium,
    nHp=2,
    have_chiWat=true,
    have_valHpInlIso=true,
    have_valHpOutIso=false,
    have_pumChiWatPriDed=true,
    final mHeaWatHp_flow_nominal=fill(datHp.mHeaWatHp_flow_nominal, valIso.nHp),
    dpHeaWatHp_nominal=fill(datHp.dpHeaWatHp_nominal, valIso.nHp),
    mChiWatHp_flow_nominal=fill(datHp.mChiWatHp_flow_nominal, valIso.nHp),
    final energyDynamics=energyDynamics,
    y_start=0)
    "Isolation valves - CHW and HW system with separate dedicated CHW pumps"
    annotation (Placement(transformation(extent={{-120,-180},{80,-100}})));
  Fluid.FixedResistances.PressureDrop hpSep[valIsoSep.nHp](
    redeclare each final package Medium=Medium,
    m_flow_nominal=valIsoSep.mHeaWatHp_flow_nominal,
    dp_nominal=fill(0, valIsoSep.nHp))
    "Heat pump HX with zero fluid resistance: pressure drop computed in valve component"
    annotation (Placement(transformation(extent={{20,-270},{0,-250}})));
  Fluid.Sources.Boundary_pT supHeaWat2(
    redeclare final package Medium=Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=2)
    "Boundary condition at HW supply"
    annotation (Placement(transformation(extent={{170,-290},{150,-270}})));
  Controls.OpenLoop ctlSep(
    final cfg=datCtlSep.cfg,
    final dat=datCtlSep)
    "Plant controller"
    annotation (Placement(transformation(extent={{-30,-90},{-50,-70}})));
  Fluid.Movers.Preconfigured.SpeedControlled_y pumChiWatPri[2](
    redeclare each final package Medium=Medium,
    each addPowerToMedium=false,
    each m_flow_nominal=datHp.mChiWatHp_flow_nominal,
    each final energyDynamics=energyDynamics,
    dp_nominal=valIsoSep.dpChiWat_nominal + cheValChiWat.dpValve_nominal)
    "Primary CHW pump"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=-90,
      origin={-54,-238})));
  Fluid.Movers.Preconfigured.SpeedControlled_y pumHeaWatPri[2](
    redeclare each final package Medium=Medium,
    each addPowerToMedium=false,
    each m_flow_nominal=datHp.mHeaWatHp_flow_nominal,
    each final energyDynamics=energyDynamics,
    dp_nominal=valIsoSep.dpHeaWat_nominal + cheValHeaWat.dpValve_nominal)
    "Primary HW pump"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=-90,
      origin={-86,-224})));
  Buildings.Templates.Plants.HeatPumps.Interfaces.Bus busPla
    "Plant controller"
    annotation (Placement(iconVisible=false,transformation(extent={{80,-100},{120,-60}}),
      iconTransformation(extent={{-548,-190},{-508,-150}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal yPumHeaWatPri[2]
    "Primary HW pump speed command"
    annotation (Placement(transformation(extent={{60,-240},{40,-220}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal yPumChiWatPri[2]
    "Primary CHW pump speed command"
    annotation (Placement(transformation(extent={{90,-260},{70,-240}})));
  Buildings.Templates.Components.Interfaces.Bus busPumHeaWatPri
    "Primary HW pump control bus"
    annotation (Placement(iconVisible=false,transformation(extent={{80,-250},{120,-210}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatPri
    "Primary CHW pump control bus"
    annotation (Placement(iconVisible=false,transformation(extent={{100,-270},{140,-230}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Fluid.FixedResistances.CheckValve cheValHeaWat[2](
    redeclare each final package Medium=Medium,
    each m_flow_nominal=datHp.mHeaWatHp_flow_nominal,
    each dpValve_nominal=Buildings.Templates.Data.Defaults.dpValChe)
    "Check valve"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=90,
      origin={-86,-200})));
  Fluid.FixedResistances.CheckValve cheValChiWat[2](
    redeclare each final package Medium=Medium,
    each m_flow_nominal=datHp.mChiWatHp_flow_nominal,
    each dpValve_nominal=Buildings.Templates.Data.Defaults.dpValChe)
    "Check valve"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=90,
      origin={-54,-210})));
equation
  connect(retHeaWat.ports[1], valIso.port_aHeaWat)
    annotation (Line(points={{120,120},{-140,120},{-140,256},{-124,256}},color={0,127,255}));
  connect(retChiWat.ports[1], valIso.port_aChiWat)
    annotation (Line(points={{120,232},{76,232}},color={0,127,255}));
  connect(valIso.port_bChiWat, supChiWat.ports[1])
    annotation (Line(points={{76,248},{150,248}},color={0,127,255}));
  connect(valIso.port_bHeaWat, supHeaWat.ports[1])
    annotation (Line(points={{-124,240},{-130,240},{-130,140},{150,140}},color={0,127,255}));
  connect(ctl.bus, valIso.bus)
    annotation (Line(points={{-30,280},{-24,280},{-24,260}},color={255,204,51},thickness=0.5));
  connect(retHeaWat1.ports[1], valIsoHeaInl.port_aHeaWat)
    annotation (Line(points={{120,-60},{-140,-60},{-140,76},{-120,76}},color={0,127,255}));
  connect(valIsoHeaInl.port_bHeaWat, supHeaWat1.ports[1])
    annotation (Line(points={{-120,60},{-130,60},{-130,-40},{150,-40}},color={0,127,255}));
  connect(ctlHeaInl.bus, valIsoHeaInl.bus)
    annotation (Line(points={{-30,100},{-20,100},{-20,80}},color={255,204,51},thickness=0.5));
  connect(valIso.ports_bChiHeaWatHp, hp.port_a)
    annotation (Line(points={{26,180},{26,160},{-10,160}},color={0,127,255}));
  connect(hp.port_b, valIso.ports_aChiHeaWatHp)
    annotation (Line(points={{-30,160},{-74,160},{-74,180}},color={0,127,255}));
  connect(valIsoHeaInl.ports_bChiHeaWatHp, hpHea.port_a)
    annotation (Line(points={{30,0},{30,-20},{-10,-20}},color={0,127,255}));
  connect(hpHea.port_b, valIsoHeaInl.ports_aChiHeaWatHp)
    annotation (Line(points={{-30,-20},{-70,-20},{-70,0}},color={0,127,255}));
  connect(valIsoSep.port_bHeaWat, supHeaWat2.ports[1])
    annotation (Line(points={{-120,-120},{-130,-120},{-130,-281},{150,-281}},
      color={0,127,255}));
  connect(ctlSep.bus, valIsoSep.bus)
    annotation (Line(points={{-30,-80},{-20,-80},{-20,-100}},color={255,204,51},thickness=0.5));
  connect(valIsoSep.ports_bChiHeaWatHp, hpSep.port_a)
    annotation (Line(points={{30,-180},{30,-260},{20,-260}},color={0,127,255}));
  connect(supHeaWat2.ports[2], valIsoSep.port_aHeaWat)
    annotation (Line(points={{150,-279},{150,-270},{-140,-270},{-140,-104},{-120,-104}},
      color={0,127,255}));
  connect(hpSep.port_b, pumChiWatPri.port_a)
    annotation (Line(points={{0,-260},{-54,-260},{-54,-248}},color={0,127,255}));
  connect(hpSep.port_b, pumHeaWatPri.port_a)
    annotation (Line(points={{0,-260},{-86,-260},{-86,-234}},color={0,127,255}));
  connect(ctlSep.bus, busPla)
    annotation (Line(points={{-30,-80},{100,-80}},color={255,204,51},thickness=0.5));
  connect(busPla.pumHeaWatPri, busPumHeaWatPri)
    annotation (Line(points={{100,-80},{100,-230}},color={255,204,51},thickness=0.5));
  connect(busPumHeaWatPri.y1, yPumHeaWatPri.u)
    annotation (Line(points={{100,-230},{62,-230}},color={255,204,51},thickness=0.5));
  connect(yPumHeaWatPri.y, pumHeaWatPri.y)
    annotation (Line(points={{38,-230},{-20,-230},{-20,-224},{-74,-224}},color={0,0,127}));
  connect(busPla.pumChiWatPri, busPumChiWatPri)
    annotation (Line(points={{100,-80},{120,-80},{120,-250}},color={255,204,51},thickness=0.5));
  connect(busPumChiWatPri.y1, yPumChiWatPri.u)
    annotation (Line(points={{120,-250},{92,-250}},color={255,204,51},thickness=0.5));
  connect(yPumChiWatPri.y, pumChiWatPri.y)
    annotation (Line(points={{68,-250},{-20,-250},{-20,-238},{-42,-238}},color={0,0,127}));
  connect(valIsoSep.port_bChiWat, valIsoSep.port_aChiWat)
    annotation (Line(points={{80,-112},{90,-112},{90,-128},{80,-128}},color={0,127,255}));
  connect(pumHeaWatPri.port_b, cheValHeaWat.port_a)
    annotation (Line(points={{-86,-214},{-86,-210}},color={0,127,255}));
  connect(cheValHeaWat.port_b, valIsoSep.ports_aHeaWatHp)
    annotation (Line(points={{-86,-190},{-86,-180}},color={0,127,255}));
  connect(cheValChiWat.port_b, valIsoSep.ports_aChiWatHp)
    annotation (Line(points={{-54,-200},{-54,-180.2}},color={0,127,255}));
  connect(pumChiWatPri.port_b, cheValChiWat.port_a)
    annotation (Line(points={{-54,-228},{-54,-220}},color={0,127,255}));
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
        extent={{-200,-320},{200,320}})));
end ValvesIsolation;
