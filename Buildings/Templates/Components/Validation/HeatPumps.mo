within Buildings.Templates.Components.Validation;
model HeatPumps
  "Validation model for heat pump component"
  extends Modelica.Icons.Example;

  replaceable package Medium = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "HW or CHW medium";

  parameter Modelica.Fluid.Types.Dynamics energyDynamics =
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true,
      Dialog(tab="Dynamics",
        group="Conservation equations"));
  parameter Buildings.Templates.Components.Data.HeatPump datHpAwNrv(
    final cpHeaWat_default=hpAwNrv.cpHeaWat_default,
    final cpSou_default=hpAwNrv.cpSou_default,
    final typ=hpAwNrv.typ,
    final typMod=hpAwNrv.typMod,
    mHeaWat_flow_nominal=datHpAw.capHea_nominal / abs(
      datHpAw.THeaWatSup_nominal -
        Buildings.Templates.Data.Defaults.THeaWatRetMed) /
      Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    dpHeaWat_nominal=Buildings.Templates.Data.Defaults.dpHeaWatHp,
    capHea_nominal=500E3,
    THeaWatSup_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    TSouHea_nominal=Buildings.Templates.Data.Defaults.TOutHpHeaLow,
    P_min=1.0E3,
    perHea(
      fileName=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Templates/Components/HeatPumps/Validation/AWHP_Heating.txt"),
      PLRSup={1},
      use_TEvaOutForTab=false,
      use_TConOutForTab=true,
      tabUppBou=[263.15, 323.15; 313.15, 323.15]))
    "Non-reversible AWHP parameters"
    annotation(Placement(transformation(extent={{100,140},{120,160}})));
  parameter Buildings.Templates.Components.Data.HeatPump datHpAw(
    final cpHeaWat_default=hpAw.cpHeaWat_default,
    final cpSou_default=hpAw.cpSou_default,
    final typ=hpAw.typ,
    final typMod=hpAw.typMod,
    mHeaWat_flow_nominal=datHpAw.capHea_nominal / abs(
      datHpAw.THeaWatSup_nominal -
        Buildings.Templates.Data.Defaults.THeaWatRetMed) /
      Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    dpHeaWat_nominal=Buildings.Templates.Data.Defaults.dpHeaWatHp,
    capHea_nominal=500E3,
    THeaWatSup_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    mChiWat_flow_nominal=datHpAw.capCoo_nominal / abs(
      datHpAw.TChiWatSup_nominal -
        Buildings.Templates.Data.Defaults.TChiWatRet) /
      Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    capCoo_nominal=500E3,
    TChiWatSup_nominal=Buildings.Templates.Data.Defaults.TChiWatSup,
    TSouCoo_nominal=Buildings.Templates.Data.Defaults.TOutHpCoo,
    TSouHea_nominal=Buildings.Templates.Data.Defaults.TOutHpHeaLow,
    P_min=1.0E3,
    perHea(
      fileName=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Templates/Components/HeatPumps/Validation/AWHP_Heating.txt"),
      PLRSup={1},
      use_TEvaOutForTab=false,
      use_TConOutForTab=true,
      tabUppBou=[263.15, 323.15; 313.15, 323.15]),
    perCoo(
      fileName=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Templates/Components/HeatPumps/Validation/AWHP_Cooling.txt"),
      PLRSup={1},
      tabLowBou=[253.15, 265.15; 317.15, 278.15]))
    "Reversible AWHP parameters"
    annotation(Placement(transformation(extent={{100,60},{120,80}})));
  parameter Data.HeatPump datShc(
    final cpHeaWat_default=shc.cpHeaWat_default,
    final cpSou_default=shc.cpSou_default,
    final typ=shc.typ,
    final typMod=shc.typMod,
    mHeaWat_flow_nominal=datShc.capHea_nominal / abs(
      datShc.THeaWatSup_nominal -
        Buildings.Templates.Data.Defaults.THeaWatRetMed) /
      Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    dpHeaWat_nominal=Buildings.Templates.Data.Defaults.dpHeaWatHp,
    capHea_nominal=500E3,
    THeaWatSup_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    mChiWat_flow_nominal=datShc.capCoo_nominal / abs(
      datShc.TChiWatSup_nominal -
        Buildings.Templates.Data.Defaults.TChiWatRet) /
      Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    dpChiWatShc_nominal=Buildings.Templates.Data.Defaults.dpChiWatChi,
    capCoo_nominal=500E3,
    TChiWatSup_nominal=Buildings.Templates.Data.Defaults.TChiWatSup,
    TSouCoo_nominal=Buildings.Templates.Data.Defaults.TOutHpCoo,
    TSouHea_nominal=Buildings.Templates.Data.Defaults.TOutHpHeaLow,
    P_min=1.0E3,
    capHeaShc_nominal=500E3,
    capCooShc_nominal=500E3,
    perShc(
      PLRHeaSup={1},
      PLRCooSup={1},
      PLRShcSup={1},
      use_TConOutForTab=true,
      use_TEvaOutForTab=true,
      devIde="",
      fileNameHea=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_Heating.txt"),
      fileNameCoo=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_Cooling.txt"),
      fileNameShc=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_SHC.txt")))
    "SHC unit parameters"
    annotation(Placement(transformation(extent={{100,-120},{120,-100}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiWatSupSet(
    k=datHpAw.TChiWatSup_nominal,
    y(final unit="K", displayUnit="degC"))
    "CHWST setpoint"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=0,
      origin={-110,160})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaWatSupSet(
    k=datHpAw.THeaWatSup_nominal,
    y(final unit="K", displayUnit="degC"))
    "HW supply temperature setpoint"
    annotation(Placement(transformation(extent={{-120,190},{-100,210}})));
  Buildings.Templates.Components.HeatPumps.AirToWater hpAw(
    typMod=Buildings.Templates.Components.Types.HeatPumpCapability.Reversible,
    show_T=true,
    redeclare final package MediumHeaWat=Medium,
    final dat=datHpAw,
    final energyDynamics=energyDynamics)
    "Reversible AWHP"
    annotation(Placement(transformation(extent={{80,30},{100,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin THeaWatRet(
    amplitude=datHpAw.THeaWatSup_nominal - datHpAw.THeaWatRet_nominal,
    freqHz=3 / 3000,
    y(final unit="K", displayUnit="degC"),
    offset=datHpAw.THeaWatRet_nominal,
    startTime=0)
    "HW return temperature value"
    annotation(Placement(transformation(extent={{-120,110},{-100,130}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1(
    table=[0, 0; 0.5, 1],
    timeScale=1000,
    period=3000)
    "Heat pump Enable signal"
    annotation(Placement(transformation(extent={{-160,170},{-140,190}})));
  Fluid.Sensors.TemperatureTwoPort TSup(
    redeclare final package Medium=Medium,
    final m_flow_nominal=datHpAw.mChiWat_flow_nominal)
    "Supply temperature"
    annotation(Placement(transformation(extent={{110,30},{130,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1Hea(
    table=[0, 0; 2, 1],
    timeScale=1000,
    period=3000) "Heat pump heating mode signal"
    annotation(Placement(transformation(extent={{-160,130},{-140,150}})));
  Fluid.Sources.Boundary_pT sup(
    redeclare final package Medium=Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=4)
    "Boundary condition at distribution system supply"
    annotation(Placement(transformation(extent={{180,30},{160,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TChiWatRet(
    amplitude=datHpAw.TChiWatRet_nominal - datHpAw.TChiWatSup_nominal,
    freqHz=3 / 3000,
    y(final unit="K", displayUnit="degC"),
    offset=datHpAw.TChiWatRet_nominal,
    startTime=0)
    "CHW return temperature value"
    annotation(Placement(transformation(extent={{-120,70},{-100,90}})));
  Fluid.Sources.Boundary_pT inlHp(
    redeclare final package Medium=Medium,
    use_p_in=true,
    use_T_in=true,
    nPorts=3) "Boundary conditions of CHW/HW at HP inlet"
    annotation(Placement(transformation(extent={{-10,30},{10,50}})));
  Buildings.Controls.OBC.CDL.Reals.Switch TRetAct
    "Active return temperature"
    annotation(Placement(transformation(extent={{-70,90},{-50,110}})));
  Buildings.Controls.OBC.CDL.Reals.Switch pInl_rel
    "Active inlet gaupe pressure"
    annotation(Placement(transformation(extent={{-70,10},{-50,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant pHeaWatInl(
    k=sup.p + hpAw.dpHeaWat_nominal)
    "HW inlet pressure"
    annotation(Placement(transformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant pChiWatInl(
    k=sup.p + hpAw.dpChiWat_nominal)
    "CHW inlet pressure"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=0,
      origin={-110,0})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    annotation(Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=0,
      origin={170,180})));
  Fluid.Sensors.TemperatureTwoPort TRet(
    redeclare final package Medium=Medium,
    final m_flow_nominal=datHpAw.mChiWat_flow_nominal)
    "Return temperature"
    annotation(Placement(transformation(extent={{30,30},{50,50}})));
  Buildings.Templates.Components.HeatPumps.AirToWater hpAwNrv(
    typMod=Buildings.Templates.Components.Types.HeatPumpCapability.HeatingOnly,
    redeclare final package MediumHeaWat=Medium,
    final energyDynamics=energyDynamics,
    final dat=datHpAwNrv)
    "Non-reversible AWHP"
    annotation(Placement(transformation(extent={{80,110},{100,130}})));
  Fluid.Sensors.TemperatureTwoPort TRet1(
    redeclare final package Medium=Medium,
    final m_flow_nominal=datHpAw.mChiWat_flow_nominal)
    "Return temperature"
    annotation(Placement(transformation(extent={{30,110},{50,130}})));
  Fluid.Sensors.TemperatureTwoPort TSup1(
    redeclare final package Medium=Medium,
    final m_flow_nominal=datHpAw.mChiWat_flow_nominal)
    "Supply temperature"
    annotation(Placement(transformation(extent={{110,110},{130,130}})));
  Buildings.Templates.Components.HeatPumps.WaterToWater hpWw(
    typMod=Buildings.Templates.Components.Types.HeatPumpCapability.Reversible,
    show_T=true,
    redeclare final package MediumHeaWat=Medium,
    final dat=datHpWw,
    final energyDynamics=energyDynamics,
    have_dpChiHeaWat=false,
    have_dpSou=false)
    "Reversible WWHP - CHW/HW and source fluid pressure drops computed externally"
    annotation(Placement(transformation(extent={{80,-50},{100,-30}})));
  parameter Data.HeatPump datHpWw(
    final cpHeaWat_default=hpWw.cpHeaWat_default,
    final cpSou_default=hpWw.cpSou_default,
    final typ=hpWw.typ,
    final typMod=hpWw.typMod,
    mHeaWat_flow_nominal=datHpAw.capHea_nominal / abs(
      datHpAw.THeaWatSup_nominal -
        Buildings.Templates.Data.Defaults.THeaWatRetMed) /
      Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    dpHeaWat_nominal=Buildings.Templates.Data.Defaults.dpHeaWatHp,
    capHea_nominal=500E3,
    THeaWatSup_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    mChiWat_flow_nominal=datHpAw.capCoo_nominal / abs(
      datHpAw.TChiWatSup_nominal -
        Buildings.Templates.Data.Defaults.TChiWatRet) /
      Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    capCoo_nominal=500E3,
    TChiWatSup_nominal=Buildings.Templates.Data.Defaults.TChiWatSup,
    TSouCoo_nominal=Buildings.Templates.Data.Defaults.TSouHpCoo,
    TSouHea_nominal=Buildings.Templates.Data.Defaults.TSouHpHea,
    dpSouWwHea_nominal=Buildings.Templates.Data.Defaults.dpChiWatChi,
    mSouWwCoo_flow_nominal=datHpWw.mSouWwHea_flow_nominal,
    mSouWwHea_flow_nominal=datHpWw.mHeaWat_flow_nominal,
    P_min=50,
    perHea(
      fileName=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/Examples/TableData2DLoadDep_HP.txt"),
      PLRSup={0.45, 0.5, 0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.9, 1.0},
      use_TEvaOutForTab=true,
      use_TConOutForTab=true,
      tabUppBou=[276.45, 336.15; 303.15, 336.15]),
    perCoo(
      fileName=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/Examples/TableData2DLoadDep_Chiller.txt"),
      PLRSup={0.45, 0.5, 0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.9, 1.0},
      use_TConOutForTab=true,
      tabLowBou=[292.15, 276.45; 336.15, 276.45]))
    "Reversible WWHP parameters"
    annotation(Placement(transformation(extent={{100,-20},{120,0}})));
  Fluid.Sensors.TemperatureTwoPort TRet2(
    redeclare final package Medium=Medium,
    final m_flow_nominal=datHpAw.mChiWat_flow_nominal)
    "Return temperature"
    annotation(Placement(transformation(extent={{30,-50},{50,-30}})));
  Fluid.Sensors.TemperatureTwoPort TSup2(
    redeclare final package Medium=Medium,
    final m_flow_nominal=datHpAw.mChiWat_flow_nominal)
    "Supply temperature"
    annotation(Placement(transformation(extent={{110,-50},{130,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TSouHea(
    y(final unit="K", displayUnit="degC"),
    height=4,
    duration=500,
    offset=datHpWw.TSouHea_nominal,
    startTime=2400)
    "Source fluid supply temperature value"
    annotation(Placement(transformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TSouCoo(
    y(final unit="K", displayUnit="degC"),
    height=-4,
    duration=500,
    offset=datHpWw.TSouCoo_nominal,
    startTime=1400)
    "Source fluid supply temperature value"
    annotation(Placement(transformation(extent={{-120,-90},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Switch TSouAct
    "Active source fluid supply temperature"
    annotation(Placement(transformation(extent={{-70,-50},{-50,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Switch pInl_rel1
    "Active inlet gaupe pressure"
    annotation(Placement(transformation(extent={{-70,-110},{-50,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant pSouInlHea(
    k=retSou.p + hpWw.dpSouHea_nominal)
    "Source fluid inlet pressure"
    annotation(Placement(transformation(extent={{-160,-70},{-140,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant pSouInlCoo(
    k=retSou.p + hpWw.dpSouCoo_nominal)
    "Source fluid inlet pressure"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=0,
      origin={-150,-108})));
  Fluid.Sources.Boundary_pT inlHpSou(
    redeclare final package Medium=Medium,
    use_p_in=true,
    use_T_in=true,
    nPorts=1)
    "Boundary conditions or source side fluid at HP inlet"
    annotation(Placement(transformation(extent={{-10,-70},{10,-50}})));
  Fluid.Sources.Boundary_pT retSou(
    redeclare final package Medium=Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=1)
    "Boundary condition at source system return"
    annotation(Placement(transformation(extent={{190,-70},{170,-50}})));
  Fluid.FixedResistances.PressureDrop res(
    redeclare final package Medium=Medium,
    final m_flow_nominal=datHpWw.mHeaWat_flow_nominal,
    final dp_nominal=datHpWw.dpHeaWat_nominal)
    "CHW/HW pressure drop computed externally"
    annotation(Placement(transformation(extent={{50,-50},{70,-30}})));
  Fluid.FixedResistances.PressureDrop resSou(
    redeclare final package Medium=Medium,
    final m_flow_nominal=datHpWw.mSouWwHea_flow_nominal,
    final dp_nominal=datHpWw.dpSouWwHea_nominal)
    "Source fluid pressure drop computed externally"
    annotation(Placement(transformation(extent={{50,-70},{70,-50}})));
  Fluid.Sources.Boundary_pT inlChiWatShc(
    redeclare final package Medium = Medium,
    p=supChiWatShc.p + datShc.dpChiWat_nominal,
    use_T_in=true,
    nPorts=1) "Boundary conditions of CHW at HP inlet"
    annotation (Placement(transformation(extent={{-10,-170},{10,-150}})));
  Fluid.Sources.Boundary_pT supChiWatShc(
    redeclare final package Medium = Medium,
    p=Buildings.Templates.Data.Defaults.pChiWat_rel_nominal + 101325,
    nPorts=1) "Boundary condition at CHW supply"
    annotation (Placement(transformation(extent={{190,-170},{170,-150}})));
  Buildings.Templates.Components.HeatPumps.AirToWater shc(
    typMod=Buildings.Templates.Components.Types.HeatPumpCapability.Polyvalent,
    show_T=true,
    redeclare final package MediumHeaWat = Medium,
    final dat=datShc,
    final energyDynamics=energyDynamics) "SHC unit"
    annotation (Placement(transformation(extent={{80,-210},{100,-190}})));
  Fluid.Sensors.TemperatureTwoPort THeaWatSupShc(redeclare final package Medium
      = Medium, final m_flow_nominal=datShc.mHeaWat_flow_nominal)
    "HW supply temperature"
    annotation (Placement(transformation(extent={{110,-210},{130,-190}})));
  Fluid.Sensors.TemperatureTwoPort THeaWatRetShc(redeclare final package Medium
      = Medium, final m_flow_nominal=datShc.mHeaWat_flow_nominal)
    "HW return temperature"
    annotation (Placement(transformation(extent={{30,-210},{50,-190}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1Coo(
    table=[0,0; 0.5,1; 2.5,0],
    timeScale=1000,
    period=3000) "SHC unit cooling on/off command"
    annotation (Placement(transformation(extent={{-128,-150},{-108,-130}})));
  Fluid.Sensors.TemperatureTwoPort TChiWatRetShc(redeclare final package Medium
      = Medium, final m_flow_nominal=datShc.mChiWat_flow_nominal)
    "CHW return temperature"
    annotation (Placement(transformation(extent={{50,-170},{70,-150}})));
  Fluid.Sensors.TemperatureTwoPort TChiWatSupShc(redeclare final package Medium
      = Medium, final m_flow_nominal=datShc.mChiWat_flow_nominal)
    "CHW supply temperature"
    annotation (Placement(transformation(extent={{110,-166},{130,-146}})));
  Fluid.Sources.Boundary_pT inlHeaWatShc(
    redeclare final package Medium = Medium,
    p=sup.p + datShc.dpHeaWat_nominal,
    use_T_in=true,
    nPorts=1) "Boundary conditions of HW at SHC inlet"
    annotation (Placement(transformation(extent={{-10,-210},{10,-190}})));
  protected
  Interfaces.Bus bus
    "HP control bus"
    annotation(Placement(transformation(extent={{-40,60},{0,100}}),
      iconTransformation(extent={{-276,6},{-236,46}})));
  protected
  Interfaces.Bus bus1
    "HP control bus"
    annotation(Placement(transformation(extent={{-40,140},{0,180}}),
      iconTransformation(extent={{-276,6},{-236,46}})));
  protected
  Interfaces.Bus bus2
    "HP control bus"
    annotation(Placement(transformation(extent={{-40,-20},{0,20}}),
      iconTransformation(extent={{-276,6},{-236,46}})));
protected
  Interfaces.Bus busShc "SHC unit control bus" annotation (Placement(
        transformation(extent={{-40,-160},{0,-120}}), iconTransformation(extent
          ={{-276,6},{-236,46}})));
equation
  connect(TSup.port_b, sup.ports[1])
    annotation(Line(points={{130,40},{160,40},{160,38.5}},
      color={0,127,255}));
  connect(THeaWatRet.y, TRetAct.u1)
    annotation(Line(points={{-98,120},{-90,120},{-90,108},{-72,108}},
      color={0,0,127}));
  connect(y1Hea.y[1], TRetAct.u2)
    annotation(Line(points={{-138,140},{-80,140},{-80,100},{-72,100}},
      color={255,0,255}));
  connect(TChiWatRet.y, TRetAct.u3)
    annotation(Line(points={{-98,80},{-90,80},{-90,92},{-72,92}},
      color={0,0,127}));
  connect(hpAw.port_b, TSup.port_a)
    annotation(Line(points={{100,40},{110,40}},
      color={0,127,255}));
  connect(TRetAct.y, inlHp.T_in)
    annotation(Line(points={{-48,100},{-38,100},{-38,44},{-12,44}},
      color={0,0,127}));
  connect(y1Hea.y[1], bus.y1Hea)
    annotation(Line(points={{-138,140},{-42,140},{-42,80},{-20,80}},
      color={255,0,255}));
  connect(pInl_rel.y, inlHp.p_in)
    annotation(Line(points={{-48,20},{-36,20},{-36,48},{-12,48}},
      color={0,0,127}));
  connect(pHeaWatInl.y, pInl_rel.u1)
    annotation(Line(points={{-98,40},{-90,40},{-90,28},{-72,28}},
      color={0,0,127}));
  connect(pChiWatInl.y, pInl_rel.u3)
    annotation(Line(points={{-98,0},{-84,0},{-84,12},{-72,12}},
      color={0,0,127}));
  connect(y1Hea.y[1], pInl_rel.u2)
    annotation(Line(
      points={{-138,140},{-138,140.526},{-80,140.526},{-80,20},{-72,20}},
      color={255,0,255}));
  connect(bus, hpAw.bus)
    annotation(Line(points={{-20,80},{90,80},{90,50}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, hpAw.busWea)
    annotation(Line(points={{160,180},{140,180},{140,56},{84,56},{84,50}},
      color={255,204,51},
      thickness=0.5));
  connect(inlHp.ports[1], TRet.port_a)
    annotation(Line(points={{10,38.6667},{20,38.6667},{20,40},{30,40}},
      color={0,127,255}));
  connect(TRet.port_b, hpAw.port_a)
    annotation(Line(points={{50,40},{80,40}},
      color={0,127,255}));
  connect(bus1, hpAwNrv.bus)
    annotation(Line(points={{-20,160},{90,160},{90,130}},
      color={255,204,51},
      thickness=0.5));
  connect(y1.y[1], bus1.y1)
    annotation(Line(points={{-138,180},{-40,180},{-40,160},{-20,160}},
      color={255,0,255}));
  connect(hpAwNrv.port_b, TSup1.port_a)
    annotation(Line(points={{100,120},{110,120}},
      color={0,127,255}));
  connect(TRet1.port_b, hpAwNrv.port_a)
    annotation(Line(points={{50,120},{80,120}},
      color={0,127,255}));
  connect(TSup1.port_b, sup.ports[2])
    annotation(Line(points={{130,120},{160,120},{160,39.5}},
      color={0,127,255}));
  connect(inlHp.ports[2], TRet1.port_a)
    annotation(Line(points={{10,40},{20,40},{20,120},{30,120}},
      color={0,127,255}));
  connect(weaDat.weaBus, hpAwNrv.busWea)
    annotation(Line(points={{160,180},{140,180},{140,134},{84,134},{84,130}},
      color={255,204,51},
      thickness=0.5));
  connect(hpWw.port_b, TSup2.port_a)
    annotation(Line(points={{100,-40},{110,-40}},
      color={0,127,255}));
  connect(TSup2.port_b, sup.ports[3])
    annotation(Line(points={{130,-40},{160,-40},{160,40.5}},
      color={0,127,255}));
  connect(inlHp.ports[3], TRet2.port_a)
    annotation(Line(points={{10,41.3333},{10,40},{20,40},{20,-40},{30,-40}},
      color={0,127,255}));
  connect(bus2, hpWw.bus)
    annotation(Line(points={{-20,0},{90,0},{90,-30}},
      color={255,204,51},
      thickness=0.5));
  connect(TSouHea.y, TSouAct.u1)
    annotation(Line(points={{-98,-40},{-86,-40},{-86,-32},{-72,-32}},
      color={0,0,127}));
  connect(y1Hea.y[1], TSouAct.u2)
    annotation(Line(points={{-138,140},{-80,140},{-80,-40},{-72,-40}},
      color={255,0,255}));
  connect(TSouCoo.y, TSouAct.u3)
    annotation(Line(points={{-98,-80},{-76,-80},{-76,-48},{-72,-48}},
      color={0,0,127}));
  connect(pSouInlHea.y, pInl_rel1.u1)
    annotation(Line(points={{-138,-60},{-94,-60},{-94,-92},{-72,-92}},
      color={0,0,127}));
  connect(pSouInlCoo.y, pInl_rel1.u3)
    annotation(Line(points={{-138,-108},{-72,-108}},
      color={0,0,127}));
  connect(y1Hea.y[1], pInl_rel1.u2)
    annotation(Line(points={{-138,140},{-80,140},{-80,-100},{-72,-100}},
      color={255,0,255}));
  connect(retSou.ports[1], hpWw.port_bSou)
    annotation(Line(points={{170,-60},{170,-64},{74,-64},{74,-50},{80,-50}},
      color={0,127,255}));
  connect(TSouAct.y, inlHpSou.T_in)
    annotation(Line(points={{-48,-40},{-42,-40},{-42,-56},{-12,-56}},
      color={0,0,127}));
  connect(pInl_rel1.y, inlHpSou.p_in)
    annotation(Line(points={{-48,-100},{-44,-100},{-44,-52},{-12,-52}},
      color={0,0,127}));
  connect(y1.y[1], bus2.y1)
    annotation(Line(points={{-138,180},{-40,180},{-40,0},{-20,0}},
      color={255,0,255}));
  connect(y1Hea.y[1], bus2.y1Hea)
    annotation(Line(points={{-138,140},{-42,140},{-42,0},{-20,0}},
      color={255,0,255}));
  connect(TRet2.port_b, res.port_a)
    annotation(Line(points={{50,-40},{50,-40}},
      color={0,127,255}));
  connect(res.port_b, hpWw.port_a)
    annotation(Line(points={{70,-40},{80,-40}},
      color={0,127,255}));
  connect(hpWw.port_aSou, resSou.port_b)
    annotation(Line(points={{100,-50},{106,-50},{106,-60},{70,-60}},
      color={0,127,255}));
  connect(inlHpSou.ports[1], resSou.port_a)
    annotation(Line(points={{10,-60},{50,-60}},
      color={0,127,255}));
  connect(shc.port_b, THeaWatSupShc.port_a)
    annotation (Line(points={{100,-200},{110,-200}}, color={0,127,255}));
  connect(THeaWatRetShc.port_b, shc.port_a)
    annotation (Line(points={{50,-200},{80,-200}}, color={0,127,255}));
  connect(busShc, shc.bus) annotation (Line(
      points={{-20,-140},{90,-140},{90,-190}},
      color={255,204,51},
      thickness=0.5));
  connect(THeaWatSupShc.port_b, sup.ports[4]) annotation (Line(points={{130,
          -200},{160,-200},{160,41.5}}, color={0,127,255}));
  connect(TChiWatRet.y, inlChiWatShc.T_in) annotation (Line(points={{-98,80},{
          -90,80},{-90,-156},{-12,-156}}, color={0,0,127}));
  connect(weaDat.weaBus, shc.busWea)
    annotation(Line(points={{160,180},{140,180},{140,-164},{84,-164},{84,-190}},
      color={255,204,51},
      thickness=0.5));
  connect(y1Hea.y[1], busShc.y1Hea) annotation (Line(points={{-138,140},{-40,
          140},{-40,-138},{-20,-138},{-20,-140}},
                                           color={255,0,255}));
  connect(TChiWatSupSet.y, busShc.TChiWatSet) annotation (Line(points={{-98,160},
          {-20,160},{-20,-140}},           color={0,0,127}));
  connect(THeaWatSupSet.y, busShc.THeaWatSet) annotation (Line(points={{-98,200},
          {-20,200},{-20,-140}},           color={0,0,127}));
  connect(THeaWatSupSet.y, bus1.THeaWatSet)
    annotation (Line(points={{-98,200},{-20,200},{-20,160}},
                                                           color={0,0,127}));
  connect(THeaWatSupSet.y, bus.THeaWatSet)
    annotation (Line(points={{-98,200},{-20,200},{-20,80}},
                                                          color={0,0,127}));
  connect(THeaWatSupSet.y, bus2.THeaWatSet)
    annotation (Line(points={{-98,200},{-20,200},{-20,0}}, color={0,0,127}));
  connect(THeaWatSupSet.y, busShc.THeaWatSet)
    annotation (Line(points={{-98,200},{-20,200},{-20,-140}},
                                                            color={0,0,127}));
  connect(y1Coo.y[1], busShc.y1Coo)
    annotation (Line(points={{-106,-140},{-20,-140}},color={255,0,255}));
  connect(TChiWatSupSet.y, bus.TChiWatSet) annotation (Line(points={{-98,160},{
          -20,160},{-20,80}},     color={0,0,127}));
  connect(TChiWatSupSet.y, bus2.TChiWatSet) annotation (Line(points={{-98,160},
          {-20,160},{-20,0}},     color={0,0,127}));
  connect(y1.y[1], bus.y1) annotation (Line(points={{-138,180},{-40,180},{-40,
          80},{-20,80}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(inlChiWatShc.ports[1], TChiWatRetShc.port_a)
    annotation (Line(points={{10,-160},{50,-160}}, color={0,127,255}));
  connect(TChiWatRetShc.port_b, shc.port_aChiWat) annotation (Line(points={{70,
          -160},{100,-160},{100,-190}}, color={0,127,255}));
  connect(supChiWatShc.ports[1], TChiWatSupShc.port_b) annotation (Line(points=
          {{170,-160},{170,-156},{130,-156}}, color={0,127,255}));
  connect(TChiWatSupShc.port_a, shc.port_bChiWat) annotation (Line(points={{110,
          -156},{80,-156},{80,-190}}, color={0,127,255}));
  connect(inlHeaWatShc.ports[1], THeaWatRetShc.port_a)
    annotation (Line(points={{10,-200},{30,-200}}, color={0,127,255}));
  connect(THeaWatRet.y, inlHeaWatShc.T_in) annotation (Line(points={{-98,120},{
          -92,120},{-92,-196},{-12,-196}}, color={0,0,127}));
annotation(Diagram(coordinateSystem(extent={{-200,-220},{200,220}}, grid={2,2})),
  __Dymola_Commands(
    file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Components/Validation/HeatPumps.mos"
      "Simulate and plot"),
  experiment(Tolerance=1e-6,
    StartTime=10497600.0,
    StopTime=10505600.0),
  Documentation(
    info="<html>
<p>
  This model validates the models
  <a href=\"modelica://Buildings.Templates.Components.HeatPumps.AirToWater\">
    Buildings.Templates.Components.HeatPumps.AirToWater</a> and
  <a href=\"modelica://Buildings.Templates.Components.HeatPumps.WaterToWater\">
    Buildings.Templates.Components.HeatPumps.WaterToWater</a> in a configuration
  in which the heat pump components are exposed to a constant differential
  pressure and a varying return temperature.
</p>
<p>
  The AWHP model (suffix <code>Aw</code>) is configured to represent either 
  a non-reversible heat pump (suffix <code>Nrv</code>) or a reversible 
  heat pump that switches between cooling and heating mode.
</p>
<p>
  The WWHP model (suffix <code>Ww</code>) is configured to represent a  
  reversible heat pump that switches between cooling and heating mode.
</p>
<p>
  The polyvalent unit model (suffix <code>Shc</code>) switches between 
  cooling-only, heating-only and simultaneous heating and cooling mode.
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
end HeatPumps;
