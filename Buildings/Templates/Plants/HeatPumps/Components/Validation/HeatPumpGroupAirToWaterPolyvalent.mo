within Buildings.Templates.Plants.HeatPumps.Components.Validation;
model HeatPumpGroupAirToWaterPolyvalent
  "Validation model for AWHP group with polyvalent HP"
  extends Modelica.Icons.Example;

  replaceable package Medium = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CHW/HW medium";

  final parameter Integer nHp = 3
    "Number of heat pumps (excluding polyvalent units)"
    annotation(Evaluate=true);
  final parameter Integer nPhp=1 "Number of polyvalent heat pumps"
    annotation(Evaluate=true);
  parameter Modelica.Fluid.Types.Dynamics energyDynamics =
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true,
      Dialog(tab="Dynamics",
        group="Conservation equations"));
  parameter Data.Controller datCtlPlaPhp(
    cfg(
      have_hrc=false,
      have_inpSch=false,
      have_chiWat=true,
      typPumHeaWatPriHp=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None,
      typPumHeaWatPriPhp=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable,
      typPumChiWatPriPhp=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable,
      typPumHeaWatSec=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None,
      typTanHeaWat=Buildings.Templates.Components.Types.IntegrationPoint.None,
      typTanChiWat=Buildings.Templates.Components.Types.IntegrationPoint.None,
      typDis=Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Only,
      nPumChiWatSec=0,
      rhoHeaWat_default=Buildings.Media.Water.d_const,
      typCtl=Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop,
      is_rev=php.is_rev,
      typHp=php.typHp,
      rhoChiWat_default=Buildings.Media.Water.d_const,
      cpChiWat_default=php.cpChiWat_default,
      have_hotWat=false,
      have_valChiWatMinByp=false,
      have_valHeaWatMinByp=false,
      have_valHpInlIso=false,
      have_valHpOutIso=false,
      cpHeaWat_default=php.cpHeaWat_default,
      cpSou_default=php.cpSou_default,
      have_senDpChiWatRemWir=true,
      typArrPumPri=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
      nHp=0,
      final nPumHeaWatPri=nPhp,
      have_heaWat=true,
      nPumHeaWatSec=0,
      rhoSou_default=Buildings.Media.Air.dStp,
      have_senDpHeaWatRemWir=true,
      typPumChiWatSec=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None,
      final nPumChiWatPri=nPhp,
      nSenDpHeaWatRem=1,
      nSenDpChiWatRem=1,
      nAirHan=0,
      nEquZon=0,
      final have_hp=php.have_hp,
      final have_php=php.have_php,
      final nPhp=nPhp,
      have_valPhpInlIso=false,
      have_valPhpOutIso=false,
      have_pumChiWatPriDedHp=false,
      typPumChiWatPriDedHp=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None),
    THeaWatSup_nominal=datPhp.THeaWatSupHp_nominal,
    TChiWatSup_nominal=datHpPhp.TChiWatSupHp_nominal,
    dpChiWatRemSet_max=fill(Buildings.Templates.Data.Defaults.dpChiWatRemSet_max,
        datCtlPlaPhp.cfg.nSenDpChiWatRem),
    dpHeaWatRemSet_max=fill(Buildings.Templates.Data.Defaults.dpHeaWatRemSet_max,
        datCtlPlaPhp.cfg.nSenDpHeaWatRem),
    staHp={fill(1, nHp)}) "Controller parameters"
    annotation (Placement(transformation(extent={{-100,160},{-80,180}})));
  parameter Data.Controller datCtlPlaHpPhp(
    cfg(
      have_hrc=false,
      have_inpSch=false,
      have_chiWat=true,
      typPumHeaWatPriHp=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable,
      typPumHeaWatPriPhp=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable,
      typPumChiWatPriPhp=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable,
      typPumHeaWatSec=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None,
      typTanHeaWat=Buildings.Templates.Components.Types.IntegrationPoint.None,
      typTanChiWat=Buildings.Templates.Components.Types.IntegrationPoint.None,
      typDis=Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Only,
      nPumChiWatSec=0,
      rhoHeaWat_default=Buildings.Media.Water.d_const,
      typCtl=Buildings.Templates.Plants.HeatPumps.Types.Controller.OpenLoop,
      is_rev=hpPhp.is_rev,
      typHp=hpPhp.typHp,
      rhoChiWat_default=Buildings.Media.Water.d_const,
      cpChiWat_default=hpPhp.cpChiWat_default,
      have_hotWat=false,
      have_valChiWatMinByp=false,
      have_valHeaWatMinByp=false,
      have_valHpInlIso=true,
      have_valHpOutIso=true,
      cpHeaWat_default=hpPhp.cpHeaWat_default,
      cpSou_default=hpPhp.cpSou_default,
      have_senDpChiWatRemWir=true,
      typArrPumPri=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
      nHp=nHp,
      final nPumHeaWatPri=nHp + nPhp,
      have_heaWat=true,
      nPumHeaWatSec=0,
      rhoSou_default=Buildings.Media.Air.dStp,
      have_senDpHeaWatRemWir=true,
      typPumChiWatSec=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None,
      final nPumChiWatPri=nPhp,
      nSenDpHeaWatRem=1,
      nSenDpChiWatRem=1,
      nAirHan=0,
      nEquZon=0,
      final have_hp=hpPhp.have_hp,
      final have_php=hpPhp.have_php,
      final nPhp=nPhp,
      have_valPhpInlIso=false,
      have_valPhpOutIso=false,
      have_pumChiWatPriDedHp=false,
      typPumChiWatPriDedHp=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None),
    THeaWatSup_nominal=datHpPhp.THeaWatSupHp_nominal,
    TChiWatSup_nominal=datHpPhp.TChiWatSupHp_nominal,
    dpChiWatRemSet_max=fill(Buildings.Templates.Data.Defaults.dpChiWatRemSet_max,
        datCtlPlaHpPhp.cfg.nSenDpChiWatRem),
    dpHeaWatRemSet_max=fill(Buildings.Templates.Data.Defaults.dpHeaWatRemSet_max,
        datCtlPlaHpPhp.cfg.nSenDpHeaWatRem),
    staHp={fill(1, nHp)}) "Controller parameters"
    annotation (Placement(transformation(extent={{-260,-180},{-240,-160}})));
  parameter Data.HeatPumpGroup datPhp(
    have_hp=false,
    have_php=true,
    is_rev=false,
    final cpHeaWat_default=php.cpHeaWat_default,
    final cpSou_default=php.cpSou_default,
    final typHp=php.typHp,
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
    perShc(
      fileNameHea=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_Heating.txt"),
      fileNameCoo=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_Cooling.txt"),
      fileNameShc=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_SHC.txt")))
    "Parameters for group of polyvalent HPs"
    annotation (Placement(transformation(extent={{-60,160},{-40,180}})));
  parameter Data.HeatPumpGroup datHpPhp(
    have_hp=true,
    have_php=true,
    final cpHeaWat_default=hpPhp.cpHeaWat_default,
    final cpSou_default=hpPhp.cpSou_default,
    final typHp=hpPhp.typHp,
    final is_rev=hpPhp.is_rev,
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
    perShc(
      fileNameHea=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_Heating.txt"),
      fileNameCoo=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_Cooling.txt"),
      fileNameShc=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_SHC.txt")))
    "Parameters for group of reversible AWHP and polyvalent HP"
    annotation (Placement(transformation(extent={{-220,-180},{-200,-160}})));
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
    final cfg=datCtlPlaPhp.cfg,
    final dat=datCtlPlaPhp)
    "Plant controller"
    annotation(Placement(transformation(extent={{10,170},{-10,190}})));
  HeatPumpGroups.AirToWater php(
    redeclare final package MediumHeaWat=Medium,
    have_hp=false,
    have_php=true,
    final nHp=0,
    final nPhp=nPhp,
    is_rev=false,
    final dat=datPhp,
    final energyDynamics=energyDynamics,
    show_T=true) "Polyvalent HP only"
    annotation(Placement(transformation(extent={{280,40},{-200,120}})));
  HeatPumpGroups.AirToWater hpPhp(
    redeclare final package MediumHeaWat=Medium,
    have_php=true,
    final nHp=nHp,
    final nPhp=nPhp,
    is_rev=true,
    final dat=datHpPhp,
    final energyDynamics=energyDynamics,
    show_T=true) "AWHP group with reversible and polyvalent units"
    annotation(Placement(transformation(extent={{280,-200},{-200,-120}})));
  Controls.OpenLoop ctlPlaAw(
    final cfg=datCtlPlaHpPhp.cfg,
    final dat=datCtlPlaHpPhp)
    "Plant controller"
    annotation(Placement(transformation(extent={{-10,-50},{-30,-30}})));
  Fluid.Sources.Boundary_pT inlHp(
    redeclare final package Medium=Medium,
    use_p_in=true,
    use_T_in=true,
    nPorts=nHp)
    "Boundary conditions at HP inlet"
    annotation(Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Fluid.Sensors.TemperatureTwoPort TChiHeaWatRetHp[nHp](
    redeclare each final package Medium=Medium,
    each final m_flow_nominal=datHpPhp.mHeaWatHp_flow_nominal)
    "Reversible HP CHW/HW return temperature"
    annotation(Placement(transformation(extent={{-70,-50},{-50,-30}})));
  Fluid.Sources.Boundary_pT sup1(
    redeclare final package Medium=Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=5)
    "Boundary condition at distribution system supply"
    annotation(Placement(transformation(extent={{200,-50},{180,-30}})));
  Fluid.Sensors.TemperatureTwoPort TChiHeaWatSupHp[nHp](
    redeclare each final package Medium=Medium,
    each final m_flow_nominal=datHpPhp.mHeaWatHp_flow_nominal)
    "Reversible HP CHW/HW supply temperature"
    annotation(Placement(transformation(extent={{140,-90},{160,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin THeaWatRet1(
    amplitude=datHpPhp.THeaWatSupHp_nominal -datHpPhp.THeaWatRetHp_nominal,
    freqHz=3 / 3000,
    y(final unit="K", displayUnit="degC"),
    offset=datHpPhp.THeaWatRetHp_nominal,
    startTime=0)
    "HW return temperature value"
    annotation(Placement(transformation(extent={{-290,-70},{-270,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TChiWatRet(
    amplitude=datHpPhp.TChiWatRetHp_nominal -datHpPhp.TChiWatSupHp_nominal,
    freqHz=3 / 3000,
    y(final unit="K", displayUnit="degC"),
    offset=datHpPhp.TChiWatRetHp_nominal,
    startTime=0)
    "CHW return temperature value"
    annotation(Placement(transformation(extent={{-290,-110},{-270,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant pHeaWatInl1(
    k=sup.p +hpPhp.dpHeaWatHp_nominal)
    "HW inlet pressure"
    annotation(Placement(transformation(extent={{-290,10},{-270,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant pChiWatInl(
    k=sup.p +hpPhp.dpChiWatHp_nominal)
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
  Fluid.Sources.Boundary_pT inlHeaWatPhp(
    redeclare final package Medium=Medium,
    p=sup1.p +datHpPhp.dpHeaWatPhp_nominal,
    use_T_in=true,
    nPorts=2)
    "Boundary conditions at polyvalent HP inlet"
    annotation(Placement(transformation(extent={{-150,-70},{-130,-50}})));
  Fluid.Sources.Boundary_pT inlChiWatPhp(
    redeclare final package Medium=Medium,
    p=sup1.p +datHpPhp.dpChiWatPhp_nominal,
    use_T_in=true,
    nPorts=2)
    "Boundary conditions at polyvalent HP inlet"
    annotation(Placement(transformation(extent={{-120,-90},{-100,-70}})));
equation
  connect(ctlPlaShc.bus,php. bus)
    annotation(Line(points={{10,180},{40,180},{40,120}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus,php. busWea)
    annotation(Line(points={{230,180},{60,180},{60,120}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus,hpPhp. busWea)
    annotation(Line(points={{230,180},{220,180},{220,0},{60,0},{60,-120}},
      color={255,204,51},
      thickness=0.5));
  connect(ctlPlaAw.bus,hpPhp. bus)
    annotation(Line(points={{-10,-40},{40,-40},{40,-120}},
      color={255,204,51},
      thickness=0.5));
  connect(inlHp.ports, TChiHeaWatRetHp.port_a)
    annotation(Line(points={{-70,-40},{-70,-40}},
      color={0,127,255}));
  connect(TChiHeaWatRetHp.port_b,hpPhp. ports_aChiHeaWatHp)
    annotation(Line(points={{-50,-40},{-42,-40},{-42,-120}},
      color={0,127,255}));
  connect(TChiHeaWatSupHp.port_b, sup1.ports[1:3])
    annotation(Line(points={{160,-80},{180,-80},{180,-40}},
      color={0,127,255}));
  connect(hpPhp.ports_bChiHeaWatHp, TChiHeaWatSupHp.port_a)
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
  connect(hpPhp.ports_bChiWatPhp[1], sup1.ports[4])
    annotation(Line(points={{90,-120},{90,-40},{180,-40},{180,-39.2}},
      color={0,127,255}));
  connect(hpPhp.ports_bHeaWatPhp[1], sup1.ports[5])
    annotation(Line(points={{106,-120},{106,-60},{180,-60},{180,-38.4}},
      color={0,127,255}));
  connect(inlHeaWatPhp.ports[1],hpPhp. ports_aHeaWatPhp[1])
    annotation(Line(points={{-130,-61},{-26,-61},{-26,-120}},
      color={0,127,255}));
  connect(inlChiWatPhp.ports[1],hpPhp. ports_aChiWatPhp[1])
    annotation(Line(points={{-100,-81},{-10,-81},{-10,-120}},
      color={0,127,255}));
  connect(TChiWatRet.y, inlChiWatPhp.T_in)
    annotation(Line(points={{-268,-100},{-140,-100},{-140,-76},{-122,-76}},
      color={0,0,127}));
  connect(THeaWatRet1.y, inlHeaWatPhp.T_in)
    annotation(Line(points={{-268,-60},{-160,-60},{-160,-56},{-152,-56}},
      color={0,0,127}));
  connect(inlHeaWatPhp.ports[2],php. ports_aHeaWatPhp[1])
    annotation(Line(
      points={{-130,-59},{-120,-59},{-120,140},{-26,140},{-26,120}},
      color={0,127,255}));
  connect(inlChiWatPhp.ports[2],php. ports_aChiWatPhp[1])
    annotation(Line(points={{-100,-79},{-100,130},{-10,130},{-10,120}},
      color={0,127,255}));
  connect(php.ports_bHeaWatPhp[1], sup.ports[1])
    annotation(Line(points={{106,120},{106,130},{180,130},{180,139}},
      color={0,127,255}));
  connect(php.ports_bChiWatPhp, sup.ports[2:2])
    annotation(Line(points={{90,120},{90,141},{180,141}},
      color={0,127,255}));
annotation(Diagram(coordinateSystem(extent={{-300,-200},{300,200}},
  grid={2,2})),
  __Dymola_Commands(
    file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/HeatPumps/Components/Validation/HeatPumpGroupAirToWaterPolyvalent.mos"
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
  in a configuration in which the heat pump group components are exposed to a
  constant differential pressure and a varying return temperature.
</p>
<p>
  The model is configured to represent either a single polyvalent HP without
  reversible heat pumps (component <code>php</code>) or a group of reversible
  heat pumps with a single polyvalent HP (component <code>hpPhp</code>).
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
end HeatPumpGroupAirToWaterPolyvalent;
