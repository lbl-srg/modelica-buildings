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
    final is_rev=hpAwNrv.is_rev,
    final is_shc=hpAwNrv.is_shc,
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
    annotation(Placement(transformation(extent={{80,100},{100,120}})));
  parameter Buildings.Templates.Components.Data.HeatPump datHpAw(
    final cpHeaWat_default=hpAw.cpHeaWat_default,
    final cpSou_default=hpAw.cpSou_default,
    final typ=hpAw.typ,
    final is_rev=hpAw.is_rev,
    final is_shc=hpAw.is_shc,
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
    annotation(Placement(transformation(extent={{80,20},{100,40}})));
  parameter Data.HeatPump datShc(
    final cpHeaWat_default=shc.cpHeaWat_default,
    final cpSou_default=shc.cpSou_default,
    final typ=shc.typ,
    final is_rev=shc.is_rev,
    final is_shc=shc.is_shc,
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
    capCoo_nominal=500E3,
    TChiWatSup_nominal=Buildings.Templates.Data.Defaults.TChiWatSup,
    TSouCoo_nominal=Buildings.Templates.Data.Defaults.TOutHpCoo,
    TSouHea_nominal=Buildings.Templates.Data.Defaults.TOutHpHeaLow,
    P_min=1.0E3,
    capHeaShc_nominal=500E3,
    capCooShc_nominal=500E3,
    perShc(
      fileNameHea=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_Heating.txt"),
      fileNameCoo=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_Cooling.txt"),
      fileNameShc=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_SHC.txt")))
    "SHC unit parameters"
    annotation(Placement(transformation(extent={{80,-180},{100,-160}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiWatSupSet(
    k=datHpAw.TChiWatSup_nominal,
    y(final unit="K", displayUnit="degC"))
    "CHWST setpoint"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=0,
      origin={-110,120})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaWatSupSet(
    k=datHpAw.THeaWatSup_nominal,
    y(final unit="K", displayUnit="degC"))
    "HW supply temperature setpoint"
    annotation(Placement(transformation(extent={{-120,150},{-100,170}})));
  Buildings.Templates.Components.HeatPumps.AirToWater hpAw(
    typMod=Buildings.Templates.Components.Types.HeatPumpCapability.Reversible,
    show_T=true,
    redeclare final package MediumHeaWat=Medium,
    final dat=datHpAw,
    final energyDynamics=energyDynamics)
    "Reversible AWHP"
    annotation(Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin THeaWatRet(
    amplitude=datHpAw.THeaWatSup_nominal - datHpAw.THeaWatRet_nominal,
    freqHz=3 / 3000,
    y(final unit="K", displayUnit="degC"),
    offset=datHpAw.THeaWatRet_nominal,
    startTime=0)
    "HW return temperature value"
    annotation(Placement(transformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1(
    table=[0, 0; 0.5, 1],
    timeScale=1000,
    period=3000)
    "Heat pump Enable signal"
    annotation(Placement(transformation(extent={{-160,130},{-140,150}})));
  Fluid.Sensors.TemperatureTwoPort TSup(
    redeclare final package Medium=Medium,
    final m_flow_nominal=datHpAw.mChiWat_flow_nominal)
    "Supply temperature"
    annotation(Placement(transformation(extent={{90,-10},{110,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1Hea(
    table=[0, 0; 2, 1],
    timeScale=1000,
    period=3000)
    "Heat pump heating mode signal"
    annotation(Placement(transformation(extent={{-160,90},{-140,110}})));
  Buildings.Controls.OBC.CDL.Reals.Switch TSetAct(
    y(final unit="K", displayUnit="degC"))
    "Active supply temperature setpoint"
    annotation(Placement(transformation(extent={{-70,90},{-50,110}})));
  Fluid.Sources.Boundary_pT sup(
    redeclare final package Medium=Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=6)
    "Boundary condition at distribution system supply"
    annotation(Placement(transformation(extent={{160,-10},{140,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TChiWatRet(
    amplitude=datHpAw.TChiWatRet_nominal - datHpAw.TChiWatSup_nominal,
    freqHz=3 / 3000,
    y(final unit="K", displayUnit="degC"),
    offset=datHpAw.TChiWatRet_nominal,
    startTime=0)
    "CHW return temperature value"
    annotation(Placement(transformation(extent={{-120,30},{-100,50}})));
  Fluid.Sources.Boundary_pT inlHp(
    redeclare final package Medium=Medium,
    use_p_in=true,
    use_T_in=true,
    nPorts=6)
    "Boundary conditions of CHW/HW at HP inlet"
    annotation(Placement(transformation(extent={{-30,-10},{-10,10}})));
  Buildings.Controls.OBC.CDL.Reals.Switch TRetAct
    "Active return temperature"
    annotation(Placement(transformation(extent={{-70,50},{-50,70}})));
  Buildings.Controls.OBC.CDL.Reals.Switch pInl_rel
    "Active inlet gaupe pressure"
    annotation(Placement(transformation(extent={{-70,-30},{-50,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant pHeaWatInl(
    k=sup.p + hpAw.dpHeaWat_nominal)
    "HW inlet pressure"
    annotation(Placement(transformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant pChiWatInl(
    k=sup.p + hpAw.dpChiWat_nominal)
    "CHW inlet pressure"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=0,
      origin={-110,-40})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    annotation(Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=0,
      origin={150,140})));
  Fluid.Sensors.TemperatureTwoPort TRet(
    redeclare final package Medium=Medium,
    final m_flow_nominal=datHpAw.mChiWat_flow_nominal)
    "Return temperature"
    annotation(Placement(transformation(extent={{10,-10},{30,10}})));
  Buildings.Templates.Components.HeatPumps.AirToWater hpAwNrv(
    typMod=Buildings.Templates.Components.Types.HeatPumpCapability.HeatingOnly,
    redeclare final package MediumHeaWat=Medium,
    final energyDynamics=energyDynamics,
    final dat=datHpAwNrv)
    "Non-reversible AWHP"
    annotation(Placement(transformation(extent={{60,70},{80,90}})));
  Fluid.Sensors.TemperatureTwoPort TRet1(
    redeclare final package Medium=Medium,
    final m_flow_nominal=datHpAw.mChiWat_flow_nominal)
    "Return temperature"
    annotation(Placement(transformation(extent={{10,70},{30,90}})));
  Fluid.Sensors.TemperatureTwoPort TSup1(
    redeclare final package Medium=Medium,
    final m_flow_nominal=datHpAw.mChiWat_flow_nominal)
    "Supply temperature"
    annotation(Placement(transformation(extent={{90,70},{110,90}})));
  Buildings.Templates.Components.HeatPumps.WaterToWater hpWw(
    typMod=Buildings.Templates.Components.Types.HeatPumpCapability.Reversible,
    show_T=true,
    redeclare final package MediumHeaWat=Medium,
    final dat=datHpWw,
    final energyDynamics=energyDynamics,
    have_dpChiHeaWat=false,
    have_dpSou=false)
    "Reversible WWHP - CHW/HW and source fluid pressure drops computed externally"
    annotation(Placement(transformation(extent={{60,-90},{80,-70}})));
  parameter Data.HeatPump datHpWw(
    final cpHeaWat_default=hpWw.cpHeaWat_default,
    final cpSou_default=hpWw.cpSou_default,
    final typ=hpWw.typ,
    final is_rev=hpWw.is_rev,
    final is_shc=hpWw.is_shc,
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
    annotation(Placement(transformation(extent={{80,-60},{100,-40}})));
  Fluid.Sensors.TemperatureTwoPort TRet2(
    redeclare final package Medium=Medium,
    final m_flow_nominal=datHpAw.mChiWat_flow_nominal)
    "Return temperature"
    annotation(Placement(transformation(extent={{10,-90},{30,-70}})));
  Fluid.Sensors.TemperatureTwoPort TSup2(
    redeclare final package Medium=Medium,
    final m_flow_nominal=datHpAw.mChiWat_flow_nominal)
    "Supply temperature"
    annotation(Placement(transformation(extent={{90,-90},{110,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TSouHea(
    y(final unit="K", displayUnit="degC"),
    height=4,
    duration=500,
    offset=datHpWw.TSouHea_nominal,
    startTime=2400)
    "Source fluid supply temperature value"
    annotation(Placement(transformation(extent={{-120,-90},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TSouCoo(
    y(final unit="K", displayUnit="degC"),
    height=-4,
    duration=500,
    offset=datHpWw.TSouCoo_nominal,
    startTime=1400)
    "Source fluid supply temperature value"
    annotation(Placement(transformation(extent={{-120,-130},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Switch TSouAct
    "Active source fluid supply temperature"
    annotation(Placement(transformation(extent={{-70,-90},{-50,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Switch pInl_rel1
    "Active inlet gaupe pressure"
    annotation(Placement(transformation(extent={{-70,-150},{-50,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant pSouInlHea(
    k=retSou.p + hpWw.dpSouHea_nominal)
    "Source fluid inlet pressure"
    annotation(Placement(transformation(extent={{-160,-110},{-140,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant pSouInlCoo(
    k=retSou.p + hpWw.dpSouCoo_nominal)
    "Source fluid inlet pressure"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=0,
      origin={-150,-148})));
  Fluid.Sources.Boundary_pT inlHpSou(
    redeclare final package Medium=Medium,
    use_p_in=true,
    use_T_in=true,
    nPorts=1)
    "Boundary conditions or source side fluid at HP inlet"
    annotation(Placement(transformation(extent={{-30,-110},{-10,-90}})));
  Fluid.Sources.Boundary_pT retSou(
    redeclare final package Medium=Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=1)
    "Boundary condition at source system return"
    annotation(Placement(transformation(extent={{170,-130},{150,-110}})));
  Fluid.FixedResistances.PressureDrop res(
    redeclare final package Medium=Medium,
    final m_flow_nominal=datHpWw.mHeaWat_flow_nominal,
    final dp_nominal=datHpWw.dpHeaWat_nominal)
    "CHW/HW pressure drop computed externally"
    annotation(Placement(transformation(extent={{30,-90},{50,-70}})));
  Fluid.FixedResistances.PressureDrop resSou(
    redeclare final package Medium=Medium,
    final m_flow_nominal=datHpWw.mSouWwHea_flow_nominal,
    final dp_nominal=datHpWw.dpSouWwHea_nominal)
    "Source fluid pressure drop computed externally"
    annotation(Placement(transformation(extent={{30,-110},{50,-90}})));
  Fluid.Sources.Boundary_pT inlShc(
    redeclare final package Medium=Medium,
    use_p_in=true,
    use_T_in=true,
    nPorts=2)
    "Boundary conditions of CHW at HP inlet"
    annotation(Placement(transformation(extent={{-30,-210},{-10,-190}})));
  Fluid.Sources.Boundary_pT supShc(
    redeclare final package Medium=Medium,
    p=Buildings.Templates.Data.Defaults.pChiWat_rel_nominal + 101325,
    nPorts=2)
    "Boundary condition at CHW supply"
    annotation(Placement(transformation(extent={{170,-200},{150,-180}})));
  Buildings.Templates.Components.HeatPumps.AirToWater shc(
    typMod=Buildings.Templates.Components.Types.HeatPumpCapability.HeatRecovery,
    show_T=true,
    redeclare final package MediumHeaWat=Medium,
    final dat=datShc,
    final energyDynamics=energyDynamics)
    "SHC unit"
    annotation(Placement(transformation(extent={{60,-230},{80,-210}})));
  Fluid.Sensors.TemperatureTwoPort TSup3(
    redeclare final package Medium=Medium,
    final m_flow_nominal=datHpAw.mChiWat_flow_nominal)
    "Supply temperature"
    annotation(Placement(transformation(extent={{90,-230},{110,-210}})));
  Fluid.Sensors.TemperatureTwoPort TRet3(
    redeclare final package Medium=Medium,
    final m_flow_nominal=datHpAw.mChiWat_flow_nominal)
    "Return temperature"
    annotation(Placement(transformation(extent={{10,-230},{30,-210}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable mode(
    table=[0, 3; 1, 2; 2, 1],
    timeScale=1000,
    period=3000)
    "SHC unit operating mode signal"
    annotation(Placement(transformation(extent={{-120,-190},{-100,-170}})));
  Buildings.Templates.Components.HeatPumps.AirToWater shcTwo[2](
    typMod={Buildings.Templates.Components.Types.HeatPumpCapability.Reversible,
      Buildings.Templates.Components.Types.HeatPumpCapability.HeatRecovery},
    each show_T=true,
    redeclare each final package MediumHeaWat=Medium,
    final dat={datHpAw, datShc},
    each final energyDynamics=energyDynamics)
    "SHC unit"
    annotation(Placement(transformation(extent={{60,-270},{80,-250}})));
  protected
  Interfaces.Bus bus
    "HP control bus"
    annotation(Placement(transformation(extent={{20,20},{60,60}}),
      iconTransformation(extent={{-276,6},{-236,46}})));
  protected
  Interfaces.Bus bus1
    "HP control bus"
    annotation(Placement(transformation(extent={{20,100},{60,140}}),
      iconTransformation(extent={{-276,6},{-236,46}})));
  protected
  Interfaces.Bus bus2
    "HP control bus"
    annotation(Placement(transformation(extent={{20,-60},{60,-20}}),
      iconTransformation(extent={{-276,6},{-236,46}})));
  protected
  Interfaces.Bus bus3
    "HP control bus"
    annotation(Placement(transformation(extent={{20,-200},{60,-160}}),
      iconTransformation(extent={{-276,6},{-236,46}})));
  protected
  Interfaces.Bus bus4
    "HP control bus"
    annotation(Placement(transformation(extent={{-8,-284},{32,-244}}),
      iconTransformation(extent={{-276,6},{-236,46}})));
  protected
  Interfaces.Bus bus5
    "HP control bus"
    annotation(Placement(transformation(extent={{156,-284},{196,-244}}),
      iconTransformation(extent={{-276,6},{-236,46}})));
equation
  connect(y1Hea.y[1], TSetAct.u2)
    annotation(Line(points={{-138,100},{-72,100}},
      color={255,0,255}));
  connect(TChiWatSupSet.y, TSetAct.u3)
    annotation(Line(points={{-98,120},{-94,120},{-94,92},{-72,92}},
      color={0,0,127}));
  connect(THeaWatSupSet.y, TSetAct.u1)
    annotation(Line(points={{-98,160},{-90,160},{-90,108},{-72,108}},
      color={0,0,127}));
  connect(TSup.port_b, sup.ports[1])
    annotation(Line(points={{110,0},{140,0},{140,-1.66667}},
      color={0,127,255}));
  connect(THeaWatRet.y, TRetAct.u1)
    annotation(Line(points={{-98,80},{-90,80},{-90,68},{-72,68}},
      color={0,0,127}));
  connect(y1Hea.y[1], TRetAct.u2)
    annotation(Line(points={{-138,100},{-80,100},{-80,60},{-72,60}},
      color={255,0,255}));
  connect(TChiWatRet.y, TRetAct.u3)
    annotation(Line(points={{-98,40},{-90,40},{-90,52},{-72,52}},
      color={0,0,127}));
  connect(hpAw.port_b, TSup.port_a)
    annotation(Line(points={{80,0},{90,0}},
      color={0,127,255}));
  connect(TRetAct.y, inlHp.T_in)
    annotation(Line(points={{-48,60},{-38,60},{-38,4},{-32,4}},
      color={0,0,127}));
  connect(y1Hea.y[1], bus.y1Hea)
    annotation(Line(points={{-138,100},{-80,100},{-80,40},{40,40}},
      color={255,0,255}));
  connect(y1.y[1], bus.y1)
    annotation(Line(points={{-138,140},{-40,140},{-40,120},{40,120},{40,40}},
      color={255,0,255}));
  connect(TSetAct.y, bus.TSet)
    annotation(Line(points={{-48,100},{40,100},{40,40}},
      color={0,0,127}));
  connect(pInl_rel.y, inlHp.p_in)
    annotation(Line(points={{-48,-20},{-36,-20},{-36,8},{-32,8}},
      color={0,0,127}));
  connect(pHeaWatInl.y, pInl_rel.u1)
    annotation(Line(points={{-98,0},{-90,0},{-90,-12},{-72,-12}},
      color={0,0,127}));
  connect(pChiWatInl.y, pInl_rel.u3)
    annotation(Line(points={{-98,-40},{-84,-40},{-84,-28},{-72,-28}},
      color={0,0,127}));
  connect(y1Hea.y[1], pInl_rel.u2)
    annotation(Line(
      points={{-138,100},{-138,100.526},{-80,100.526},{-80,-20},{-72,-20}},
      color={255,0,255}));
  connect(bus, hpAw.bus)
    annotation(Line(points={{40,40},{70,40},{70,10}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, hpAw.busWea)
    annotation(Line(points={{140,140},{120,140},{120,16},{64,16},{64,10}},
      color={255,204,51},
      thickness=0.5));
  connect(inlHp.ports[1], TRet.port_a)
    annotation(Line(points={{-10,-1.66667},{0,-1.66667},{0,0},{10,0}},
      color={0,127,255}));
  connect(TRet.port_b, hpAw.port_a)
    annotation(Line(points={{30,0},{60,0}},
      color={0,127,255}));
  connect(bus1, hpAwNrv.bus)
    annotation(Line(points={{40,120},{70,120},{70,90}},
      color={255,204,51},
      thickness=0.5));
  connect(y1.y[1], bus1.y1)
    annotation(Line(points={{-138,140},{-40,140},{-40,120},{40,120}},
      color={255,0,255}));
  connect(hpAwNrv.port_b, TSup1.port_a)
    annotation(Line(points={{80,80},{90,80}},
      color={0,127,255}));
  connect(TRet1.port_b, hpAwNrv.port_a)
    annotation(Line(points={{30,80},{60,80}},
      color={0,127,255}));
  connect(TSup1.port_b, sup.ports[2])
    annotation(Line(points={{110,80},{140,80},{140,-1}},
      color={0,127,255}));
  connect(inlHp.ports[2], TRet1.port_a)
    annotation(Line(points={{-10,-1},{0,-1},{0,80},{10,80}},
      color={0,127,255}));
  connect(weaDat.weaBus, hpAwNrv.busWea)
    annotation(Line(points={{140,140},{120,140},{120,94},{64,94},{64,90}},
      color={255,204,51},
      thickness=0.5));
  connect(THeaWatSupSet.y, bus1.TSet)
    annotation(Line(points={{-98,160},{40,160},{40,120}},
      color={0,0,127}));
  connect(hpWw.port_b, TSup2.port_a)
    annotation(Line(points={{80,-80},{90,-80}},
      color={0,127,255}));
  connect(TSup2.port_b, sup.ports[3])
    annotation(Line(points={{110,-80},{140,-80},{140,-0.333333}},
      color={0,127,255}));
  connect(inlHp.ports[3], TRet2.port_a)
    annotation(Line(points={{-10,-0.333333},{-10,0},{0,0},{0,-80},{10,-80}},
      color={0,127,255}));
  connect(bus2, hpWw.bus)
    annotation(Line(points={{40,-40},{70,-40},{70,-70}},
      color={255,204,51},
      thickness=0.5));
  connect(TSouHea.y, TSouAct.u1)
    annotation(Line(points={{-98,-80},{-86,-80},{-86,-72},{-72,-72}},
      color={0,0,127}));
  connect(y1Hea.y[1], TSouAct.u2)
    annotation(Line(points={{-138,100},{-80,100},{-80,-80},{-72,-80}},
      color={255,0,255}));
  connect(TSouCoo.y, TSouAct.u3)
    annotation(Line(points={{-98,-120},{-76,-120},{-76,-88},{-72,-88}},
      color={0,0,127}));
  connect(pSouInlHea.y, pInl_rel1.u1)
    annotation(Line(points={{-138,-100},{-94,-100},{-94,-132},{-72,-132}},
      color={0,0,127}));
  connect(pSouInlCoo.y, pInl_rel1.u3)
    annotation(Line(points={{-138,-148},{-72,-148}},
      color={0,0,127}));
  connect(y1Hea.y[1], pInl_rel1.u2)
    annotation(Line(points={{-138,100},{-80,100},{-80,-140},{-72,-140}},
      color={255,0,255}));
  connect(retSou.ports[1], hpWw.port_bSou)
    annotation(Line(points={{150,-120},{54,-120},{54,-90},{60,-90}},
      color={0,127,255}));
  connect(TSouAct.y, inlHpSou.T_in)
    annotation(Line(points={{-48,-80},{-42,-80},{-42,-96},{-32,-96}},
      color={0,0,127}));
  connect(pInl_rel1.y, inlHpSou.p_in)
    annotation(Line(points={{-48,-140},{-44,-140},{-44,-92},{-32,-92}},
      color={0,0,127}));
  connect(TSetAct.y, bus2.TSet)
    annotation(Line(points={{-48,100},{40,100},{40,-40}},
      color={0,0,127}));
  connect(y1.y[1], bus2.y1)
    annotation(Line(points={{-138,140},{-40,140},{-40,-40},{40,-40}},
      color={255,0,255}));
  connect(y1Hea.y[1], bus2.y1Hea)
    annotation(Line(points={{-138,100},{-80,100},{-80,-40},{40,-40}},
      color={255,0,255}));
  connect(TRet2.port_b, res.port_a)
    annotation(Line(points={{30,-80},{30,-80}},
      color={0,127,255}));
  connect(res.port_b, hpWw.port_a)
    annotation(Line(points={{50,-80},{60,-80}},
      color={0,127,255}));
  connect(hpWw.port_aSou, resSou.port_b)
    annotation(Line(points={{80,-90},{86,-90},{86,-100},{50,-100}},
      color={0,127,255}));
  connect(inlHpSou.ports[1], resSou.port_a)
    annotation(Line(points={{-10,-100},{30,-100}},
      color={0,127,255}));
  connect(shc.port_b, TSup3.port_a)
    annotation(Line(points={{80,-220},{90,-220}},
      color={0,127,255}));
  connect(TRet3.port_b, shc.port_a)
    annotation(Line(points={{30,-220},{60,-220}},
      color={0,127,255}));
  connect(bus3, shc.bus)
    annotation(Line(points={{40,-180},{70,-180},{70,-210}},
      color={255,204,51},
      thickness=0.5));
  connect(inlHp.ports[4], TRet3.port_a)
    annotation(Line(points={{-10,0.333333},{0,0.333333},{0,-220},{10,-220}},
      color={0,127,255}));
  connect(TSup3.port_b, sup.ports[4])
    annotation(Line(points={{110,-220},{140,-220},{140,0.333333}},
      color={0,127,255}));
  connect(inlShc.ports[1], shc.port_aChiWat)
    annotation(Line(points={{-10,-201},{80,-201},{80,-210}},
      color={0,127,255}));
  connect(supShc.ports[1], shc.port_bChiWat)
    annotation(Line(points={{150,-191},{60,-191},{60,-210}},
      color={0,127,255}));
  connect(pChiWatInl.y, inlShc.p_in)
    annotation(Line(points={{-98,-40},{-84,-40},{-84,-192},{-32,-192}},
      color={0,0,127}));
  connect(TChiWatRet.y, inlShc.T_in)
    annotation(Line(points={{-98,40},{-90,40},{-90,-196},{-32,-196}},
      color={0,0,127}));
  connect(weaDat.weaBus, shc.busWea)
    annotation(Line(points={{140,140},{120,140},{120,-204},{64,-204},{64,-210}},
      color={255,204,51},
      thickness=0.5));
  connect(y1.y[1], bus3.y1)
    annotation(Line(
      points={{-138,140},{-40,140},{-40,-160},{40,-160},{40,-180}},
      color={255,0,255}));
  connect(mode.y[1], bus3.mode)
    annotation(Line(points={{-98,-180},{40,-180}},
      color={255,127,0}));
  connect(TChiWatSupSet.y, bus3.TChiWatSupSet)
    annotation(Line(points={{-98,120},{-42,120},{-42,-180},{40,-180}},
      color={0,0,127}));
  connect(THeaWatSupSet.y, bus3.THeaWatSupSet)
    annotation(Line(points={{-98,160},{-44,160},{-44,-180},{40,-180}},
      color={0,0,127}));
  connect(y1.y[1], bus4.y1)
    annotation(Line(
      points={{-138,140},{-68,140},{-68,-244},{12,-244},{12,-264}},
      color={255,0,255}));
  connect(mode.y[1], bus4.mode)
    annotation(Line(points={{-98,-180},{-130,-180},{-130,-264},{12,-264}},
      color={255,127,0}));
  connect(TChiWatSupSet.y, bus4.TChiWatSupSet)
    annotation(Line(points={{-98,120},{-98,-264},{12,-264}},
      color={0,0,127}));
  connect(THeaWatSupSet.y, bus4.THeaWatSupSet)
    annotation(Line(points={{-98,160},{-72,160},{-72,-264},{12,-264}},
      color={0,0,127}));
  connect(bus4, shcTwo[2].bus)
    annotation(Line(points={{12,-264},{70,-264},{70,-250}},
      color={255,204,51},
      thickness=0.5));
  connect(y1Hea.y[1], bus5.y1Hea)
    annotation(Line(points={{-138,100},{80,100},{80,-264},{176,-264}},
      color={255,0,255}));
  connect(y1.y[1], bus5.y1)
    annotation(Line(
      points={{-138,140},{120,140},{120,-314},{176,-314},{176,-264}},
      color={255,0,255}));
  connect(TSetAct.y, bus5.TSet)
    annotation(Line(points={{-48,100},{176,100},{176,-264}},
      color={0,0,127}));
  connect(bus5, shcTwo[1].bus)
    annotation(Line(points={{176,-264},{124,-264},{124,-250},{70,-250}},
      color={255,204,51},
      thickness=0.5));
  connect(inlHp.ports[5], shcTwo[1].port_a)
    annotation(Line(points={{-10,1},{-10,-130},{60,-130},{60,-260}},
      color={0,127,255}));
  connect(inlHp.ports[6], shcTwo[2].port_a)
    annotation(Line(points={{-10,1.66667},{26,1.66667},{26,-260},{60,-260}},
      color={0,127,255}));
  connect(shcTwo[1].port_b, sup.ports[5])
    annotation(Line(points={{80,-260},{114,-260},{114,1},{140,1}},
      color={0,127,255}));
  connect(shcTwo[2].port_b, sup.ports[6])
    annotation(Line(points={{80,-260},{110,-260},{110,1.66667},{140,1.66667}},
      color={0,127,255}));
  connect(weaDat.weaBus, shcTwo[1].busWea)
    annotation(Line(points={{140,140},{140,-55},{64,-55},{64,-250}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, shcTwo[2].busWea)
    annotation(Line(points={{140,140},{102,140},{102,-250},{64,-250}},
      color={255,204,51},
      thickness=0.5));
  connect(inlShc.ports[2], shcTwo[2].port_aChiWat)
    annotation(Line(points={{-10,-199},{36,-199},{36,-250},{80,-250}},
      color={0,127,255}));
  connect(supShc.ports[2], shcTwo[2].port_bChiWat)
    annotation(Line(points={{150,-189},{106,-189},{106,-250},{60,-250}},
      color={0,127,255}));
annotation(Diagram(coordinateSystem(extent={{-180,-180},{180,180}})),
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
  The AWHP model is configured to represent either a non-reversible heat pump
  (suffix <code>Nrv</code>) or a reversible heat pump that switches between
  cooling and heating mode.
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
