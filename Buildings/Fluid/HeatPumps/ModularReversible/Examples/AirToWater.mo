within Buildings.Fluid.HeatPumps.ModularReversible.Examples;
model AirToWater "Validation of AWHP plant template"
  extends Modelica.Icons.Example;
  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Main medium (common for CHW and HW)";
  parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal=1500E3;
  parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal=-1500E3;
  parameter Modelica.Units.SI.MassFlowRate mHw_flow_nominal=
    abs(QHea_flow_nominal / (THwSup_nominal - THwRet_nominal)) /
    Buildings.Utilities.Psychrometrics.Constants.cpWatLiq;
  parameter Modelica.Units.SI.MassFlowRate mChw_flow_nominal=
    abs(QCoo_flow_nominal / (TChwSup_nominal - TChwRet_nominal)) /
    Buildings.Utilities.Psychrometrics.Constants.cpWatLiq;
  parameter Modelica.Units.SI.Temperature THwSup_nominal=
    Buildings.Templates.Data.Defaults.THeaWatSupMed;
  parameter Modelica.Units.SI.Temperature TChwSup_nominal=
    Buildings.Templates.Data.Defaults.TChiWatSup;
  parameter Modelica.Units.SI.Temperature THwRet_nominal=
    Buildings.Templates.Data.Defaults.THeaWatRetMed;
  parameter Modelica.Units.SI.Temperature TChwRet_nominal=
    Buildings.Templates.Data.Defaults.TChiWatRet;

  parameter Modelica.Units.SI.PressureDifference dpChwRemSet_max=
    Buildings.Templates.Data.Defaults.dpChiWatRemSet_max;
  parameter Modelica.Units.SI.PressureDifference dpHwRemSet_max=
    Buildings.Templates.Data.Defaults.dpHeaWatRemSet_max;
  parameter Modelica.Units.SI.PressureDifference dpChwLocSet_max=
    Buildings.Templates.Data.Defaults.dpChiWatLocSet_max;
  parameter Modelica.Units.SI.PressureDifference dpHwLocSet_max=
    Buildings.Templates.Data.Defaults.dpHeaWatLocSet_max;
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,
    Dialog(tab="Dynamics",group="Conservation equations"));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    "Outdoor conditions"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={-210,-40})));
  Fluid.HeatExchangers.SensibleCooler_T loaHw(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mHw_flow_nominal,
    show_T=true,
    final dp_nominal=0,
    final energyDynamics=energyDynamics,
    tau=300,
    QMin_flow=-QHea_flow_nominal)
    "HW system approximated by prescribed return temperature"
    annotation (Placement(transformation(extent={{70,-170},{90,-150}})));
  Fluid.HeatExchangers.Heater_T loaChw(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mChw_flow_nominal,
    show_T=true,
    final dp_nominal=0,
    final energyDynamics=energyDynamics,
    tau=300,
    QMax_flow=-QCoo_flow_nominal)
    "CHW system system approximated by prescribed return temperature"
    annotation (Placement(transformation(extent={{70,-70},{90,-50}})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage valDisHw(
    redeclare final package Medium=Medium,
    m_flow_nominal=mHw_flow_nominal,
    dpValve_nominal=3E4,
    dpFixed_nominal=dpHwRemSet_max - 3E4)
    "Distribution system approximated by variable flow resistance"
    annotation (Placement(transformation(extent={{110,-170},{130,-150}})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage valDisChw(
    redeclare final package Medium=Medium,
    m_flow_nominal=mChw_flow_nominal,
    dpValve_nominal=3E4,
    dpFixed_nominal=dpChwRemSet_max - 3E4)
    "Distribution system approximated by variable flow resistance"
    annotation (Placement(transformation(extent={{110,-70},{130,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TDum(
    k=293.15,
    y(final unit="K",
      displayUnit="degC"))
    "Placeholder signal for request generator"
    annotation (Placement(transformation(extent={{-220,150},{-200,170}})));
  Fluid.Sensors.RelativePressure dpHwRem(
    redeclare final package Medium = Medium)
    "HW differential pressure at one remote location"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,-180})));
  Fluid.Sensors.RelativePressure dpChwRem(
    redeclare final package Medium = Medium)
    "CHW differential pressure at one remote location"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,-80})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.PlantRequests reqPlaRes(
    final heaCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased, final
      cooCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased)
    "Plant and reset request"
    annotation (Placement(transformation(extent={{90,122},{70,142}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable ratFlo(
    table=[
      0, 0, 0;
      5, 0, 0;
      7, 1, 0;
      12, 0.2, 0.2;
      16, 0, 1;
      22, 0.1, 0.1;
      24, 0, 0],
    timeScale=3600)
    "Source signal for flow rate ratio – Index 1 for HW, 2 for CHW"
    annotation (Placement(transformation(extent={{-220,90},{-200,110}})));
  Buildings.Controls.OBC.CDL.Reals.PID ctlEquZon[2](
    each k=0.1,
    each Ti=60,
    each final reverseActing=true) "Zone equipment controller"
    annotation (Placement(transformation(extent={{70,90},{90,110}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter norFlo[2](
    k={1/mHw_flow_nominal,
        1/mChw_flow_nominal}) "Normalize flow rate" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={180,0})));
  Fluid.Sensors.MassFlowRate mChw_flow(
    redeclare final package Medium=Medium)
    "CHW mass flow rate"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={160,-80})));
  Fluid.Sensors.MassFlowRate mHw_flow(
    redeclare final package Medium=Medium)
    "HW mass flow rate"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={160,-180})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter TChwRet(
    p=TChwRet_nominal - TChwSup_nominal)
    "Prescribed CHW return temperature"
    annotation (Placement(transformation(extent={{-170,50},{-150,70}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter THwRet(
    p=THwRet_nominal - THwSup_nominal)
    "Prescribed HW return temperature"
    annotation (Placement(transformation(extent={{-170,10},{-150,30}})));
  Buildings.Controls.OBC.CDL.Reals.Max max2
    "Limit prescribed HWRT"
    annotation (Placement(transformation(extent={{-130,10},{-110,30}})));
  Buildings.Controls.OBC.CDL.Reals.Min min1
    "Limit prescribed CHWRT"
    annotation (Placement(transformation(extent={{-130,50},{-110,70}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply mulInt[2]
    "Importance multiplier"
    annotation (Placement(transformation(extent={{0,130},{-20,150}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant cst[2](
    each k=10)
    "Constant"
    annotation (Placement(transformation(extent={{40,170},{20,190}})));
  Buildings.Fluid.FixedResistances.PressureDrop pipHw(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mHw_flow_nominal,
    final dp_nominal=dpHwLocSet_max - dpHwRemSet_max)
    "Piping"
    annotation (Placement(transformation(extent={{0,-210},{-20,-190}})));
  Buildings.Fluid.FixedResistances.PressureDrop pipChw(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mChw_flow_nominal,
    final dp_nominal=dpChwLocSet_max - dpChwRemSet_max)
    "Piping"
    annotation (Placement(transformation(extent={{0,-110},{-20,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(
    k=293.15) "Constant limiting prescribed return temperature"
    annotation (Placement(transformation(extent={{-220,30},{-200,50}})));
  Buildings.Fluid.HeatPumps.ModularReversible.TableData2DLoadDepSHC hp(
    redeclare final package MediumCon=Medium,
    redeclare final package MediumEva=Medium,
    final mCon_flow_nominal=mHw_flow_nominal,
    final mEva_flow_nominal=mChw_flow_nominal,
    nUni=3,
    final use_preDro=false,
    QHeaShc_flow_nominal=QHea_flow_nominal,
    QCooShc_flow_nominal=QCoo_flow_nominal,
    final dat=dat,
    final QHea_flow_nominal=QHea_flow_nominal,
    final QCoo_flow_nominal=QCoo_flow_nominal,
    final TConHea_nominal=THwSup_nominal,
    TEvaHea_nominal=Buildings.Templates.Data.Defaults.TOutHpHeaLow,
    final TConCoo_nominal=TChwSup_nominal,
    TEvaCoo_nominal=Buildings.Templates.Data.Defaults.TOutHpCoo,
    dpHw_nominal=300000,
    dpChw_nominal=400000)
    "Modular heat pump"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant on(k=true)
    "On/off command"
    annotation (Placement(transformation(extent={{-220,-90},{-200,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant mode(
    k=Buildings.Fluid.HeatPumps.Types.OperatingModes.shc)
    "Operating mode command"
    annotation (Placement(transformation(extent={{-220,-140},{-200,-120}})));
  parameter Data.TableData2DLoadDepSHC.Generic dat(
    PLRHeaSup={1},
    PLRCooSup={1},
    PLRShcSup={1},
    fileNameHea=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_Heating.txt"),
    fileNameCoo=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_Cooling.txt"),
    fileNameShc=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_SHC.txt"),
    mCon_flow_nominal=1.7,
    mEva_flow_nominal=3.5,
    dpCon_nominal=30E3,
    dpEva_nominal=40E3,
    devIde="",
    use_TEvaOutForTab=true,
    use_TConOutForTab=true) "Performance data"
    annotation (Placement(transformation(extent={{-220,-180},{-200,-160}})));
  Sensors.TemperatureTwoPort TChwSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=hp.mEva_flow_nominal,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    T_start=TChwSup_nominal) "CHW supply temperature"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  Sensors.TemperatureTwoPort THwSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=hp.mCon_flow_nominal,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    T_start=THwSup_nominal) "HW supply temperature"
    annotation (Placement(transformation(extent={{-40,-170},{-20,-150}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSupSet[2](k={
        THwSup_nominal,TChwSup_nominal}) "Supply temperature setpoints"
    annotation (Placement(transformation(extent={{-220,-10},{-200,10}})));
  Sources.Boundary_pT pChwRet(
    redeclare final package Medium = Medium,
    p=Buildings.Templates.Data.Defaults.pChiWat_rel_nominal + 101325,
    nPorts=1) "Pressure boundary conditions at HP inlet" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-130})));
  Sources.Boundary_pT pHwRet(
    redeclare final package Medium = Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=1) "Pressure boundary condition at HP inlet" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-110,-160})));
  Movers.Preconfigured.SpeedControlled_y pumChwPri(
    redeclare final package Medium=Medium,
    final energyDynamics=energyDynamics,
    addPowerToMedium=false,
    m_flow_nominal=hp.mEva_flow_nominal,
    dp_nominal=dpChwLocSet_max + hp.dpChw_nominal) "Primary CHW pump"
    annotation (Placement(transformation(extent={{10,-70},{30,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant FIXME(k=0.5) "Constant"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Movers.Preconfigured.SpeedControlled_y pumHwPri(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    addPowerToMedium=false,
    m_flow_nominal=hp.mCon_flow_nominal,
    dp_nominal=dpHwLocSet_max + hp.dpHw_nominal) "Primary HW pump"
    annotation (Placement(transformation(extent={{10,-170},{30,-150}})));
  Actuators.Valves.TwoWayTable  valHwIso(
    redeclare final package Medium = Medium,
    final m_flow_nominal=hp.mCon_flow_nominal,
    flowCharacteristics=hp.chaValHwIso,
    dpValve_nominal=hp.dpValIso_nominal,
    strokeTime=10,
    init=Modelica.Blocks.Types.Init.InitialState,
    dpFixed_nominal=hp.dpHw_nominal)
    "HW isolation valve"
    annotation (Placement(transformation(extent={{-70,-170},{-50,-150}})));
  Actuators.Valves.TwoWayTable  valChwIso(
    redeclare final package Medium = Medium,
    final m_flow_nominal=hp.mEva_flow_nominal,
    dpValve_nominal=hp.dpValIso_nominal,
    init=Modelica.Blocks.Types.Init.InitialState,
    dpFixed_nominal=hp.dpChw_nominal,
    flowCharacteristics=hp.chaValChwIso)
    "CHW isolation valve"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum sumNumUni(nin=3)
    "Total number of enabled modules"
    annotation (Placement(transformation(extent={{-210,-230},{-190,-210}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(message="Number of enabled modules exceeds number of modules")
    "Assert condition on number of enabled modules"
             annotation (Placement(transformation(extent={{-150,-230},{-130,-210}})));
  Buildings.Controls.OBC.CDL.Integers.LessEqualThreshold intLesEquThr(t=hp.nUni)
    "True if number of enabled modules lower or equal to number of modules"
    annotation (Placement(transformation(extent={{-180,-230},{-160,-210}})));
equation
  connect(loaChw.port_b, valDisChw.port_a)
    annotation (Line(points={{90,-60},{110,-60}},color={0,127,255}));
  connect(loaHw.port_b, valDisHw.port_a)
    annotation (Line(points={{90,-160},{110,-160}},color={0,127,255}));
  connect(TDum.y, reqPlaRes.TAirSup)
    annotation (Line(points={{-198,160},{60,160},{60,140},{92,140}},  color={0,0,127}));
  connect(TDum.y, reqPlaRes.TAirSupSet)
    annotation (Line(points={{-198,160},{60,160},{60,135},{92,135}},  color={0,0,127}));
  connect(valDisChw.y_actual, reqPlaRes.uCooCoiSet)
    annotation (Line(points={{125,-53},{140,-53},{140,129},{92,129}},color={0,0,127}));
  connect(valDisHw.y_actual, reqPlaRes.uHeaCoiSet)
    annotation (Line(points={{125,-153},{136,-153},{136,124},{92,124}},color={0,0,127}));
  connect(valDisChw.port_b, mChw_flow.port_a)
    annotation (Line(points={{130,-60},{160,-60},{160,-70}},color={0,127,255}));
  connect(valDisHw.port_b, mHw_flow.port_a)
    annotation (Line(points={{130,-160},{160,-160},{160,-170}},color={0,127,255}));
  connect(mHw_flow.m_flow, norFlo[1].u)
    annotation (Line(points={{171,-180},{180,-180},{180,-12}},color={0,0,127}));
  connect(mChw_flow.m_flow, norFlo[2].u)
    annotation (Line(points={{171,-80},{180,-80},{180,-12}},color={0,0,127}));
  connect(norFlo.y, ctlEquZon.u_m)
    annotation (Line(points={{180,12},{180,60},{80,60},{80,88}},color={0,0,127}));
  connect(ctlEquZon[2].y, valDisChw.y)
    annotation (Line(points={{92,100},{100,100},{100,-40},{120,-40},{120,-48}},
      color={0,0,127}));
  connect(ctlEquZon[1].y, valDisHw.y)
    annotation (Line(points={{92,100},{100,100},{100,-104},{120,-104},{120,-148}},
      color={0,0,127}));
  connect(TChwRet.y, min1.u1)
    annotation (Line(points={{-148,60},{-140,60},{-140,66},{-132,66}},
                                                                     color={0,0,127}));
  connect(min1.y, loaChw.TSet)
    annotation (Line(points={{-108,60},{60,60},{60,-52},{68,-52}},
                                                                 color={0,0,127}));
  connect(max2.y, loaHw.TSet)
    annotation (Line(points={{-108,20},{58,20},{58,-152},{68,-152}},
                                                                   color={0,0,127}));
  connect(cst.y, mulInt.u1)
    annotation (Line(points={{18,180},{10,180},{10,146},{2,146}},
                                                               color={255,127,0}));
  connect(mChw_flow.port_b, pipChw.port_a)
    annotation (Line(points={{160,-90},{160,-100},{0,-100}}, color={0,127,255}));
  connect(mHw_flow.port_b, pipHw.port_a)
    annotation (Line(points={{160,-190},{160,-200},{0,-200}}, color={0,127,255}));
  connect(con.y, min1.u2)
    annotation (Line(points={{-198,40},{-140,40},{-140,54},{-132,54}},
                                                                     color={0,0,127}));
  connect(con.y, max2.u1)
    annotation (Line(points={{-198,40},{-140,40},{-140,26},{-132,26}},
                                                                     color={0,0,127}));
  connect(THwRet.y, max2.u2)
    annotation (Line(points={{-148,20},{-140,20},{-140,14},{-132,14}},
                                                                     color={0,0,127}));
  connect(weaDat.weaBus, hp.weaBus) annotation (Line(
      points={{-200,-40},{-110,-40},{-110,-70}},
      color={255,204,51},
      thickness=0.5));
  connect(mode.y, hp.mode) annotation (Line(points={{-198,-130},{-180,-130},{-180,
          -84},{-122,-84}},color={255,127,0}));
  connect(reqPlaRes.yChiPlaReq, mulInt[2].u2) annotation (Line(points={{68,135},
          {20,135},{20,134},{2,134}}, color={255,127,0}));
  connect(reqPlaRes.yHotWatPlaReq, mulInt[1].u2) annotation (Line(points={{68,124},
          {20,124},{20,134},{2,134}}, color={255,127,0}));
  connect(ratFlo.y, ctlEquZon.u_s)
    annotation (Line(points={{-198,100},{68,100}}, color={0,0,127}));
  connect(on.y, hp.on) annotation (Line(points={{-198,-80},{-184,-80},{-184,-82},
          {-122,-82}},color={255,0,255}));
  connect(THwSup.T, TChwRet.u) annotation (Line(points={{-30,-149},{-30,-22},{
          -180,-22},{-180,60},{-172,60}},
                                     color={0,0,127}));
  connect(TChwSup.T, THwRet.u) annotation (Line(points={{-10,-49},{-10,-20},{
          -178,-20},{-178,20},{-172,20}},
                                     color={0,0,127}));
  connect(TSupSet[1].y, hp.THwSet) annotation (Line(points={{-198,0},{-184,0},{-184,
          -76},{-122,-76}},      color={0,0,127}));
  connect(TSupSet[2].y, hp.TChwSet) annotation (Line(points={{-198,0},{-184,0},{
          -184,-80},{-122,-80}}, color={0,0,127}));
  connect(TChwSup.port_b, pumChwPri.port_a)
    annotation (Line(points={{0,-60},{10,-60}}, color={0,127,255}));
  connect(pumChwPri.port_b, loaChw.port_a)
    annotation (Line(points={{30,-60},{70,-60}}, color={0,127,255}));
  connect(pipChw.port_b, hp.port_a2) annotation (Line(points={{-20,-100},{-40,
          -100},{-40,-86},{-100,-86}},
                                color={0,127,255}));
  connect(dpChwRem.port_a, loaChw.port_a)
    annotation (Line(points={{40,-70},{40,-60},{70,-60}}, color={0,127,255}));
  connect(dpChwRem.port_b, pipChw.port_a)
    annotation (Line(points={{40,-90},{40,-100},{0,-100}}, color={0,127,255}));
  connect(dpHwRem.port_b, pipHw.port_a) annotation (Line(points={{40,-190},{40,
          -200},{0,-200}},
                     color={0,127,255}));
  connect(dpHwRem.port_a, loaHw.port_a) annotation (Line(points={{40,-170},{40,
          -160},{70,-160}},
                      color={0,127,255}));
  connect(pipHw.port_b, hp.port_a1) annotation (Line(points={{-20,-200},{-140,
          -200},{-140,-74},{-120,-74}},
                                 color={0,127,255}));
  connect(pChwRet.ports[1], hp.port_a2)
    annotation (Line(points={{-100,-130},{-100,-86}},
                                                    color={0,127,255}));
  connect(pHwRet.ports[1], hp.port_a1) annotation (Line(points={{-120,-160},{
          -140,-160},{-140,-74},{-120,-74}},
                                       color={0,127,255}));
  connect(FIXME.y, pumChwPri.y)
    annotation (Line(points={{-78,0},{20,0},{20,-48}}, color={0,0,127}));
  connect(THwSup.port_b, pumHwPri.port_a)
    annotation (Line(points={{-20,-160},{10,-160}}, color={0,127,255}));
  connect(pumHwPri.port_b, loaHw.port_a)
    annotation (Line(points={{30,-160},{70,-160}}, color={0,127,255}));
  connect(FIXME.y, pumHwPri.y) annotation (Line(points={{-78,0},{6,0},{6,-104},{
          20,-104},{20,-148}}, color={0,0,127}));
  connect(hp.port_b1, valHwIso.port_a) annotation (Line(points={{-100,-74},{-80,
          -74},{-80,-160},{-70,-160}}, color={0,127,255}));
  connect(valHwIso.port_b, THwSup.port_a)
    annotation (Line(points={{-50,-160},{-40,-160}}, color={0,127,255}));
  connect(hp.yValHwIso, valHwIso.y) annotation (Line(points={{-102,-69},{-102,
          -66},{-60,-66},{-60,-148}}, color={0,0,127}));
  connect(valChwIso.port_b, TChwSup.port_a)
    annotation (Line(points={{-40,-60},{-20,-60}}, color={0,127,255}));
  connect(hp.port_b2, valChwIso.port_a) annotation (Line(points={{-120,-86},{
          -128,-86},{-128,-60},{-60,-60}}, color={0,127,255}));
  connect(hp.yValChwIso, valChwIso.y) annotation (Line(points={{-118,-91},{-118,
          -94},{-130,-94},{-130,-42},{-50,-42},{-50,-48}}, color={0,0,127}));
  connect(sumNumUni.y,intLesEquThr. u)
    annotation (Line(points={{-188,-220},{-182,-220}},
                                             color={255,127,0}));
  connect(intLesEquThr.y,assMes. u)
    annotation (Line(points={{-158,-220},{-152,-220}},
                                             color={255,0,255}));
  connect(hp.nUniShc, sumNumUni.u[1]) annotation (Line(points={{-113,-92},{-113,
          -100},{-230,-100},{-230,-222.333},{-212,-222.333}}, color={255,127,0}));
  connect(hp.nUniCoo, sumNumUni.u[2]) annotation (Line(points={{-110,-92},{-110,
          -100},{-230,-100},{-230,-220},{-212,-220}}, color={255,127,0}));
  connect(hp.nUniHea, sumNumUni.u[3]) annotation (Line(points={{-107,-92},{-107,
          -100},{-230,-100},{-230,-217.667},{-212,-217.667}}, color={255,127,0}));
  annotation (
    experiment(
      Tolerance=1e-6,
      StopTime=86400.0),
    Documentation(
      info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Templates.Plants.HeatPumps.AirToWater\">
Buildings.Templates.Plants.HeatPumps.AirToWater</a>
by simulating a <i>24</i>-hour period with overlapping heating and
cooling loads.
The heating loads reach their peak value first, the cooling loads reach it last.
</p>
<p>
Three equally sized heat pumps are modeled, which can all be lead/lag alternated.
A heat recovery chiller is included (<code>pla.have_hrc_select=true</code>) 
and connected to the HW and CHW return pipes (sidestream integration).
A unique aggregated load is modeled on each loop by means of a cooling or heating
component controlled to maintain a constant <i>&Delta;T</i>
and a modulating valve controlled to track a prescribed flow rate.
An importance multiplier of <i>10</i> is applied to the plant requests
and reset requests generated from the valve position.
</p>
<p>
Simulating this model shows how the plant responds to a varying load by
</p>
<ul>
<li>
staging or unstaging the AWHPs and associated primary pumps,
</li>
<li>
rotating lead/lag alternate equipment to ensure even wear,
</li>
<li>
resetting the supply temperature and remote differential pressure
in both the CHW and HW loops based on the valve position,
</li>
<li>
staging and controlling the secondary pumps to meet the
remote differential pressure setpoint.
</li>
</ul>
<h4>Details</h4>
<p>
By default, all valves within the plant are modeled considering a linear
variation of the pressure drop with the flow rate (<code>pla.linearized=true</code>),
as opposed to the quadratic relationship usually considered for
a turbulent flow regime.
By limiting the size of the system of nonlinear equations, this setting
reduces the risk of solver failure and the time to solution for testing
various plant configurations.
</p>
</html>",
      revisions="<html>
<ul>
<li>
May 31, 2024, by Antoine Gautier:<br/>
Added sidestream HRC and refactored the model after updating the HP plant template.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3808\">#3808</a>.
</li>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(
      coordinateSystem(
        extent={{-240,-240},{240,240}}, grid={2,2})));
end AirToWater;
