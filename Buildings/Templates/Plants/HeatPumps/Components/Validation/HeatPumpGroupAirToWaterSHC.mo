within Buildings.Templates.Plants.HeatPumps.Components.Validation;
model HeatPumpGroupAirToWaterSHC
  "Validation model for heat pump group with AWHP and SHC units"
  extends Modelica.Icons.Example;

  replaceable package Medium = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CHW/HW medium";

  final parameter Integer nHp = 3
    "Number of heat pumps (excluding SHC units)"
    annotation(Evaluate=true);
  final parameter Integer nShc = 1
    "Number of polyvalent (SHC) units"
    annotation(Evaluate=true);
  parameter Modelica.Fluid.Types.Dynamics energyDynamics =
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true,
      Dialog(tab="Dynamics",
        group="Conservation equations"));
  parameter Data.Controller datCtlPlaShc(
    cfg(
      have_hrc=false,
      have_inpSch=false,
      have_chiWat=false,
      typPumHeaWatPri=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable,
      typPumChiWatPri=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None,
      typPumHeaWatSec=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None,
      typTanHeaWat=Buildings.Templates.Components.Types.IntegrationPoint.None,
      typTanChiWat=Buildings.Templates.Components.Types.IntegrationPoint.None,
      have_pumHeaWatPriVar=true,
      have_pumChiWatPriVar=false,
      typDis=Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Only,
      have_pumChiWatPriDed=false,
      nPumChiWatSec=0,
      rhoHeaWat_default=Buildings.Media.Water.d_const,
      typCtl=Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop,
      is_rev=shc.is_rev,
      typHp=shc.typHp,
      rhoChiWat_default=Buildings.Media.Water.d_const,
      cpChiWat_default=shc.cpChiWat_default,
      have_hotWat=false,
      have_valChiWatMinByp=false,
      have_valHeaWatMinByp=false,
      have_valHpInlIso=false,
      have_valHpOutIso=false,
      cpHeaWat_default=shc.cpHeaWat_default,
      cpSou_default=shc.cpSou_default,
      have_senDpChiWatRemWir=true,
      typArrPumPri=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
      nHp=nHp,
      nPumHeaWatPri=nHp,
      have_heaWat=true,
      nPumHeaWatSec=0,
      rhoSou_default=Buildings.Media.Air.dStp,
      have_senDpHeaWatRemWir=true,
      typPumChiWatSec=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None,
      nPumChiWatPri=nHp,
      nSenDpHeaWatRem=1,
      nSenDpChiWatRem=1,
      nAirHan=0,
      nEquZon=0,
      final have_hp=shc.have_hp,
      final have_shc=shc.have_shc,
      is_shcMod=false,
      final nShc=nShc,
      have_valShcInlIso=false,
      have_valShcOutIso=false),
    THeaWatSup_nominal=datShc.THeaWatSupHp_nominal,
    dpChiWatRemSet_max=fill(
      Buildings.Templates.Data.Defaults.dpChiWatRemSet_max,
      datCtlPlaShc.cfg.nSenDpChiWatRem),
    dpHeaWatRemSet_max=fill(
      Buildings.Templates.Data.Defaults.dpHeaWatRemSet_max,
      datCtlPlaShc.cfg.nSenDpHeaWatRem),
    staEqu={fill(1, nHp)})
    "Controller parameters"
    annotation(Placement(transformation(extent={{-100,160},{-80,180}})));
  parameter Data.Controller datCtlPlaAw(
    cfg(
      have_hrc=false,
      have_inpSch=false,
      have_chiWat=true,
      typPumHeaWatPri=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable,
      typPumChiWatPri=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable,
      typPumHeaWatSec=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None,
      typTanHeaWat=Buildings.Templates.Components.Types.IntegrationPoint.None,
      typTanChiWat=Buildings.Templates.Components.Types.IntegrationPoint.None,
      have_pumHeaWatPriVar=true,
      have_pumChiWatPriVar=true,
      typDis=Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Only,
      have_pumChiWatPriDed=false,
      nPumChiWatSec=0,
      rhoHeaWat_default=Buildings.Media.Water.d_const,
      typCtl=Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop,
      is_rev=hpAw.is_rev,
      typHp=hpAw.typHp,
      rhoChiWat_default=Buildings.Media.Water.d_const,
      cpChiWat_default=hpAw.cpChiWat_default,
      have_hotWat=false,
      have_valChiWatMinByp=false,
      have_valHeaWatMinByp=false,
      have_valHpInlIso=true,
      have_valHpOutIso=true,
      cpHeaWat_default=hpAw.cpHeaWat_default,
      cpSou_default=hpAw.cpSou_default,
      have_senDpChiWatRemWir=true,
      typArrPumPri=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
      nHp=nHp,
      nPumHeaWatPri=nHp,
      have_heaWat=true,
      nPumHeaWatSec=0,
      rhoSou_default=Buildings.Media.Air.dStp,
      have_senDpHeaWatRemWir=true,
      typPumChiWatSec=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None,
      nPumChiWatPri=nHp,
      nSenDpHeaWatRem=1,
      nSenDpChiWatRem=1,
      nAirHan=0,
      nEquZon=0,
      final have_hp=hpAw.have_hp,
      final have_shc=hpAw.have_shc,
      final is_shcMod=false,
      final nShc=nShc,
      have_valShcInlIso=false,
      have_valShcOutIso=false),
    THeaWatSup_nominal=datHp.THeaWatSupHp_nominal,
    TChiWatSup_nominal=datHp.TChiWatSupHp_nominal,
    dpChiWatRemSet_max=fill(
      Buildings.Templates.Data.Defaults.dpChiWatRemSet_max,
      datCtlPlaAw.cfg.nSenDpChiWatRem),
    dpHeaWatRemSet_max=fill(
      Buildings.Templates.Data.Defaults.dpHeaWatRemSet_max,
      datCtlPlaAw.cfg.nSenDpHeaWatRem),
    staEqu={fill(1, nHp)})
    "Controller parameters"
    annotation(Placement(transformation(extent={{-260,-180},{-240,-160}})));
  parameter Data.HeatPumpGroup datShc(
    have_hp=false,
    have_shc=true,
    is_rev=false,
    final cpHeaWat_default=shc.cpHeaWat_default,
    final cpSou_default=shc.cpSou_default,
    final typHp=shc.typHp,
    mHeaWatShc_flow_nominal=datHp.capHeaShc_nominal / abs(
      datHp.THeaWatSupShc_nominal -
        Buildings.Templates.Data.Defaults.THeaWatRetMed) /
      Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    dpHeaWatShc_nominal=Buildings.Templates.Data.Defaults.dpHeaWatHp,
    capHeaShc_nominal=500E3,
    THeaWatSupShc_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    TSouHeaShc_nominal=Buildings.Templates.Data.Defaults.TOutHpHeaLow,
    mChiWatShc_flow_nominal=datHp.capCooShc_nominal / abs(
      datHp.TChiWatSupShc_nominal -
        Buildings.Templates.Data.Defaults.TChiWatRet) /
      Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    capCooShc_nominal=500E3,
    TChiWatSupShc_nominal=Buildings.Templates.Data.Defaults.TChiWatSup,
    TSouCooShc_nominal=Buildings.Templates.Data.Defaults.TOutHpCoo,
    PShc_min=1.0E3,
    capHeaHrShc_nominal=500E3,
    capCooHrShc_nominal=500E3,
    perShc(
      fileNameHea=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_Heating.txt"),
      fileNameCoo=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_Cooling.txt"),
      fileNameShc=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_SHC.txt")))
    "Non-reversible AWHP parameters"
    annotation(Placement(transformation(extent={{-60,160},{-40,180}})));
  parameter Data.HeatPumpGroup datHp(
    have_hp=true,
    have_shc=true,
    final cpHeaWat_default=hpAw.cpHeaWat_default,
    final cpSou_default=hpAw.cpSou_default,
    final typHp=hpAw.typHp,
    final is_rev=hpAw.is_rev,
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
      PLRSup={1}),
    mHeaWatShc_flow_nominal=datHp.capHeaShc_nominal / abs(
      datHp.THeaWatSupShc_nominal -
        Buildings.Templates.Data.Defaults.THeaWatRetMed) /
      Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    dpHeaWatShc_nominal=Buildings.Templates.Data.Defaults.dpHeaWatHp,
    capHeaShc_nominal=500E3,
    THeaWatSupShc_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    TSouHeaShc_nominal=Buildings.Templates.Data.Defaults.TOutHpHeaLow,
    mChiWatShc_flow_nominal=datHp.capCooShc_nominal / abs(
      datHp.TChiWatSupShc_nominal -
        Buildings.Templates.Data.Defaults.TChiWatRet) /
      Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    capCooShc_nominal=500E3,
    TChiWatSupShc_nominal=Buildings.Templates.Data.Defaults.TChiWatSup,
    TSouCooShc_nominal=Buildings.Templates.Data.Defaults.TOutHpCoo,
    PShc_min=1.0E3,
    capHeaHrShc_nominal=500E3,
    capCooHrShc_nominal=500E3,
    perShc(
      fileNameHea=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_Heating.txt"),
      fileNameCoo=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_Cooling.txt"),
      fileNameShc=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_SHC.txt")))
    "Reversible AWHP parameters"
    annotation(Placement(transformation(extent={{-220,-180},{-200,-160}})));
  Fluid.Sources.Boundary_pT sup(
    redeclare final package Medium=Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=2)
    "Boundary condition at distribution system supply"
    annotation(Placement(transformation(extent={{200,130},{180,150}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    annotation(Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=0,
      origin={240,180})));
  Controls.OpenLoop ctlPlaShc(
    final cfg=datCtlPlaShc.cfg,
    final dat=datCtlPlaShc)
    "Plant controller"
    annotation(Placement(transformation(extent={{10,170},{-10,190}})));
  HeatPumpGroups.AirToWater shc(
    redeclare final package MediumHeaWat=Medium,
    have_hp=false,
    have_shc=true,
    final nHp=0,
    final nShc=nShc,
    is_rev=false,
    final dat=datShc,
    final energyDynamics=energyDynamics)
    "SHC units only"
    annotation(Placement(transformation(extent={{280,40},{-200,120}})));
  HeatPumpGroups.AirToWater hpAw(
    redeclare final package MediumHeaWat=Medium,
    have_shc=true,
    final nHp=nHp,
    final nShc=nShc,
    is_rev=true,
    final dat=datHp,
    final energyDynamics=energyDynamics)
    "Reversible AWHP and SHC unit"
    annotation(Placement(transformation(extent={{280,-200},{-200,-120}})));
  Controls.OpenLoop ctlPlaAw(final cfg=datCtlPlaAw.cfg, final dat=datCtlPlaAw)
    "Plant controller"
    annotation(Placement(transformation(extent={{-10,-50},{-30,-30}})));
  Fluid.Sources.Boundary_pT inlHp(
    redeclare final package Medium=Medium,
    use_p_in=true,
    use_T_in=true,
    nPorts=nHp)
    "Boundary conditions at HP inlet"
    annotation(Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Fluid.Sensors.TemperatureTwoPort TRet[nHp](
    redeclare each final package Medium=Medium,
    each final m_flow_nominal=datHp.mHeaWatHp_flow_nominal)
    "Return temperature"
    annotation(Placement(transformation(extent={{-70,-50},{-50,-30}})));
  Fluid.Sources.Boundary_pT sup1(
    redeclare final package Medium=Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=5)
    "Boundary condition at distribution system supply"
    annotation(Placement(transformation(extent={{200,-50},{180,-30}})));
  Fluid.Sensors.TemperatureTwoPort TSup[nHp](
    redeclare each final package Medium=Medium,
    each final m_flow_nominal=datHp.mHeaWatHp_flow_nominal)
    "Supply temperature"
    annotation(Placement(transformation(extent={{140,-90},{160,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin THeaWatRet1(
    amplitude=datHp.THeaWatSupHp_nominal - datHp.THeaWatRetHp_nominal,
    freqHz=3 / 3000,
    y(final unit="K", displayUnit="degC"),
    offset=datHp.THeaWatRetHp_nominal,
    startTime=0)
    "HW return temperature value"
    annotation(Placement(transformation(extent={{-290,-70},{-270,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TChiWatRet(
    amplitude=datHp.TChiWatRetHp_nominal - datHp.TChiWatSupHp_nominal,
    freqHz=3 / 3000,
    y(final unit="K", displayUnit="degC"),
    offset=datHp.TChiWatRetHp_nominal,
    startTime=0)
    "CHW return temperature value"
    annotation(Placement(transformation(extent={{-290,-110},{-270,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant pHeaWatInl1(
    k=sup.p + hpAw.dpHeaWatHp_nominal)
    "HW inlet pressure"
    annotation(Placement(transformation(extent={{-290,10},{-270,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant pChiWatInl(
    k=sup.p + hpAw.dpChiWatHp_nominal)
    "CHW inlet pressure"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=0,
      origin={-280,-20})));
  Buildings.Controls.OBC.CDL.Reals.Switch TRetAct
    "Active return temperature"
    annotation(Placement(transformation(extent={{-240,-90},{-220,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Switch pInl_rel
    "Active inlet gaupe pressure"
    annotation(Placement(transformation(extent={{-240,-10},{-220,10}})));
  Buildings.Templates.Plants.HeatPumps.Interfaces.Bus busPla
    "Plant controller"
    annotation(Placement(iconVisible=false,
      transformation(extent={{-20,-20},{20,20}}),
      iconTransformation(extent={{-548,-190},{-508,-150}})));
  Buildings.Templates.Components.Interfaces.Bus busHp[nHp]
    "HP control bus"
    annotation(Placement(iconVisible=false,
      transformation(extent={{-60,-20},{-20,20}}),
      iconTransformation(extent={{-536,100},{-496,140}})));
  Fluid.Sources.Boundary_pT inlHeaWatShc(
    redeclare final package Medium=Medium,
    use_p_in=true,
    use_T_in=true,
    nPorts=2)
    "Boundary conditions at SHC unit inlet"
    annotation(Placement(transformation(extent={{-150,-70},{-130,-50}})));
  Fluid.Sources.Boundary_pT inlChiWatShc(
    redeclare final package Medium=Medium,
    use_p_in=true,
    use_T_in=true,
    nPorts=2)
    "Boundary conditions at SHC unit inlet"
    annotation(Placement(transformation(extent={{-120,-90},{-100,-70}})));
equation
  connect(ctlPlaShc.bus, shc.bus)
    annotation(Line(points={{10,180},{40,180},{40,120}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, shc.busWea)
    annotation(Line(points={{230,180},{60,180},{60,120}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, hpAw.busWea)
    annotation(Line(points={{230,180},{220,180},{220,0},{60,0},{60,-120}},
      color={255,204,51},
      thickness=0.5));
  connect(ctlPlaAw.bus, hpAw.bus)
    annotation(Line(points={{-10,-40},{40,-40},{40,-120}},
      color={255,204,51},
      thickness=0.5));
  connect(inlHp.ports, TRet.port_a)
    annotation(Line(points={{-70,-38.6667},{-70,-40}},
      color={0,127,255}));
  connect(TRet.port_b, hpAw.ports_aChiHeaWatHp)
    annotation(Line(points={{-50,-40},{-42,-40},{-42,-120}},
      color={0,127,255}));
  connect(TSup.port_b, sup1.ports[1:3])
    annotation(Line(points={{160,-80},{180,-80},{180,-40}},
      color={0,127,255}));
  connect(hpAw.ports_bChiHeaWatHp, TSup.port_a)
    annotation(Line(points={{122,-120},{122,-80},{140,-80}},
      color={0,127,255}));
  connect(THeaWatRet1.y, TRetAct.u1)
    annotation(Line(points={{-268,-60},{-260,-60},{-260,-72},{-242,-72}},
      color={0,0,127}));
  connect(TChiWatRet.y, TRetAct.u3)
    annotation(Line(points={{-268,-100},{-250,-100},{-250,-88},{-242,-88}},
      color={0,0,127}));
  connect(pHeaWatInl1.y, pInl_rel.u1)
    annotation(Line(points={{-268,20},{-260,20},{-260,8},{-242,8}},
      color={0,0,127}));
  connect(pChiWatInl.y, pInl_rel.u3)
    annotation(Line(points={{-268,-20},{-260,-20},{-260,-8},{-242,-8}},
      color={0,0,127}));
  connect(pInl_rel.y, inlHp.p_in)
    annotation(Line(points={{-218,0},{-156,0},{-156,-32},{-92,-32}},
      color={0,0,127}));
  connect(TRetAct.y, inlHp.T_in)
    annotation(Line(points={{-218,-80},{-156,-80},{-156,-36},{-92,-36}},
      color={0,0,127}));
  connect(busPla, ctlPlaAw.bus)
    annotation(Line(points={{0,0},{0,-40},{-10,-40}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla.hp, busHp)
    annotation(Line(points={{0,0},{-40,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busHp[1].y1Hea, pInl_rel.u2)
    annotation(Line(
      points={{-40,-6.66667},{-40,16},{-250,16},{-250,0},{-242,0}},
      color={255,204,51},
      thickness=0.5));
  connect(pInl_rel.u2, TRetAct.u2)
    annotation(Line(points={{-242,0},{-250,0},{-250,-80},{-242,-80}},
      color={255,0,255}));
  connect(hpAw.ports_bChiWatShc[1], sup1.ports[4])
    annotation(Line(points={{90,-120},{90,-40},{180,-40},{180,-39.2}},
      color={0,127,255}));
  connect(hpAw.ports_bHeaWatShc[1], sup1.ports[5])
    annotation(Line(points={{106,-120},{106,-60},{180,-60},{180,-38.4}},
      color={0,127,255}));
  connect(inlHeaWatShc.ports[1], hpAw.ports_aHeaWatShc[1])
    annotation(Line(points={{-130,-60},{-26,-60},{-26,-120}},
      color={0,127,255}));
  connect(inlChiWatShc.ports[1], hpAw.ports_aChiWatShc[1])
    annotation(Line(points={{-100,-80},{-10,-80},{-10,-120}},
      color={0,127,255}));
  connect(TChiWatRet.y, inlChiWatShc.T_in)
    annotation(Line(points={{-268,-100},{-140,-100},{-140,-76},{-122,-76}},
      color={0,0,127}));
  connect(THeaWatRet1.y, inlHeaWatShc.T_in)
    annotation(Line(points={{-268,-60},{-160,-60},{-160,-56},{-152,-56}},
      color={0,0,127}));
  connect(pChiWatInl.y, inlChiWatShc.p_in)
    annotation(Line(points={{-268,-20},{-196,-20},{-196,-72},{-122,-72}},
      color={0,0,127}));
  connect(pHeaWatInl1.y, inlHeaWatShc.p_in)
    annotation(Line(points={{-268,20},{-160,20},{-160,-52},{-152,-52}},
      color={0,0,127}));
  connect(inlHeaWatShc.ports[2], shc.ports_aHeaWatShc[1])
    annotation(Line(
      points={{-130,-60},{-120,-60},{-120,140},{-26,140},{-26,120}},
      color={0,127,255}));
  connect(inlChiWatShc.ports[2], shc.ports_aChiWatShc[1])
    annotation(Line(points={{-100,-80},{-100,130},{-10,130},{-10,120}},
      color={0,127,255}));
  connect(shc.ports_bChiWatShc[1], sup.ports[2])
    annotation(Line(points={{90,120},{90,140},{180,140}},
      color={0,127,255}));
  connect(shc.ports_bHeaWatShc[1], sup.ports[1])
    annotation(Line(points={{106,120},{106,130},{180,130},{180,140}},
      color={0,127,255}));
annotation(Diagram(coordinateSystem(extent={{-300,-200},{300,200}},
  grid={2,2})),
  __Dymola_Commands(
    file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/HeatPumps/Components/Validation/HeatPumpGroupAirToWater.mos"
      "Simulate and plot"),
  experiment(Tolerance=1e-6,
    StartTime=10497600.0,
    StopTime=10505600.0),
  Documentation(
    info="<html>
<p>
  This model validates the model
  <a href=\"modelica://Buildings.Templates.Plants.HeatPumps.Components.HeatPumpGroups.AirToWater\">
    Buildings.Templates.Plants.HeatPumps.Components.HeatPumpGroups.AirToWater</a>
  in a configuration in which the heat pump components are exposed to a
  constant differential pressure and a varying return temperature.
</p>
<p>
  The model is configured to represent either a non-reversible heat pump
  (component <code>hpAwNrv</code>) or a reversible heat pump (component
  <code>hpAw</code>) that switches between cooling and heating mode.
</p>
</html>",
    revisions="<html>
<ul>
  <li>
    August 21, 2025, by Antoine Gautier:<br />
    Refactored with load-dependent 2D table data heat pump model.<br />
    This is for
    <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4152\">#4152</a>.
  </li>
  <li>
    March 29, 2024, by Antoine Gautier:<br />
    First implementation.
  </li>
</ul>
</html>"));
end HeatPumpGroupAirToWaterSHC;
