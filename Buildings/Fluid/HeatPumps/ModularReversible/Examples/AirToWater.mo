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
      origin={-210,-30})));
  Fluid.HeatExchangers.SensibleCooler_T loaHw(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mHw_flow_nominal,
    show_T=true,
    final dp_nominal=0,
    final energyDynamics=energyDynamics,
    tau=300,
    QMin_flow=-QHea_flow_nominal)
    "HW system approximated by prescribed return temperature"
    annotation (Placement(transformation(extent={{110,-210},{130,-190}})));
  Fluid.HeatExchangers.Heater_T loaChw(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mChw_flow_nominal,
    show_T=true,
    final dp_nominal=0,
    final energyDynamics=energyDynamics,
    tau=300,
    QMax_flow=-QCoo_flow_nominal)
    "CHW system system approximated by prescribed return temperature"
    annotation (Placement(transformation(extent={{110,-50},{130,-30}})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage valDisHw(
    redeclare final package Medium=Medium,
    m_flow_nominal=mHw_flow_nominal,
    dpValve_nominal=3E4,
    dpFixed_nominal=dpHwRemSet_max - 3E4)
    "Distribution system approximated by variable flow resistance"
    annotation (Placement(transformation(extent={{150,-210},{170,-190}})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage valDisChw(
    redeclare final package Medium=Medium,
    m_flow_nominal=mChw_flow_nominal,
    dpValve_nominal=3E4,
    dpFixed_nominal=dpChwRemSet_max - 3E4)
    "Distribution system approximated by variable flow resistance"
    annotation (Placement(transformation(extent={{150,-50},{170,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TDum(
    k=293.15,
    y(final unit="K",
      displayUnit="degC"))
    "Placeholder signal for request generator"
    annotation (Placement(transformation(extent={{-220,210},{-200,230}})));
  Fluid.Sensors.RelativePressure dpHwRem(
    redeclare final package Medium = Medium)
    "HW differential pressure at one remote location"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={100,-220})));
  Fluid.Sensors.RelativePressure dpChwRem(
    redeclare final package Medium = Medium)
    "CHW differential pressure at one remote location"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={100,-60})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.PlantRequests reqPlaRes(
    final heaCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased, final
      cooCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased)
    "Plant and reset request"
    annotation (Placement(transformation(extent={{90,182},{70,202}})));
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
    annotation (Placement(transformation(extent={{-220,170},{-200,190}})));
  Buildings.Controls.OBC.CDL.Reals.PID ctlEquZon[2](
    each k=0.1,
    each Ti=60,
    each final reverseActing=true) "Zone equipment controller"
    annotation (Placement(transformation(extent={{70,150},{90,170}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter norFlo[2](
    k={1/mHw_flow_nominal,
        1/mChw_flow_nominal}) "Normalize flow rate" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={220,0})));
  Fluid.Sensors.MassFlowRate mChw_flow(
    redeclare final package Medium=Medium)
    "CHW mass flow rate"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={200,-60})));
  Fluid.Sensors.MassFlowRate mHw_flow(
    redeclare final package Medium=Medium)
    "HW mass flow rate"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={200,-220})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter TChwRetPre(p=TChwRet_nominal -
        TChwSup_nominal) "Prescribed CHW return temperature"
    annotation (Placement(transformation(extent={{-170,120},{-150,140}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter THwRetPre(p=THwRet_nominal -
        THwSup_nominal) "Prescribed HW return temperature"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
  Buildings.Controls.OBC.CDL.Reals.Max max2
    "Limit prescribed HWRT"
    annotation (Placement(transformation(extent={{-60,100},{-40,120}})));
  Buildings.Controls.OBC.CDL.Reals.Min min1
    "Limit prescribed CHWRT"
    annotation (Placement(transformation(extent={{-130,120},{-110,140}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply mulInt[2]
    "Importance multiplier"
    annotation (Placement(transformation(extent={{0,190},{-20,210}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant cst[2](
    each k=10)
    "Constant"
    annotation (Placement(transformation(extent={{40,230},{20,250}})));
  Buildings.Fluid.FixedResistances.PressureDrop pipHw(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mHw_flow_nominal,
    final dp_nominal=dpHwLocSet_max - dpHwRemSet_max)
    "Piping"
    annotation (Placement(transformation(extent={{80,-250},{60,-230}})));
  Buildings.Fluid.FixedResistances.PressureDrop pipChw(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mChw_flow_nominal,
    final dp_nominal=dpChwLocSet_max - dpChwRemSet_max)
    "Piping"
    annotation (Placement(transformation(extent={{80,-90},{60,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(
    k=293.15) "Constant limiting prescribed return temperature"
    annotation (Placement(transformation(extent={{-220,140},{-200,160}})));
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
    dpHw_nominal=30000,
    dpChw_nominal=40000)
    "Modular heat pump"
    annotation (Placement(transformation(extent={{-140,-84},{-120,-64}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant on(k=true)
    "On/off command"
    annotation (Placement(transformation(extent={{-220,-80},{-200,-60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant mode(
    k=Buildings.Fluid.HeatPumps.Types.OperatingModes.shc)
    "Operating mode command"
    annotation (Placement(transformation(extent={{-220,-130},{-200,-110}})));
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
    annotation (Placement(transformation(extent={{-220,-170},{-200,-150}})));
  Sensors.TemperatureTwoPort TChwSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=hp.mEva_flow_nominal,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    T_start=TChwSup_nominal) "CHW supply temperature"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Sensors.TemperatureTwoPort THwSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=hp.mCon_flow_nominal,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    T_start=THwSup_nominal) "HW supply temperature"
    annotation (Placement(transformation(extent={{-60,-210},{-40,-190}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSupSet[2](k={
        THwSup_nominal,TChwSup_nominal}) "Supply temperature setpoints"
    annotation (Placement(transformation(extent={{-220,0},{-200,20}})));
  Sources.Boundary_pT pChwRet(
    redeclare final package Medium = Medium,
    p=Buildings.Templates.Data.Defaults.pChiWat_rel_nominal + 101325,
    nPorts=1) "Pressure boundary conditions at HP inlet" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,-120})));
  Sources.Boundary_pT pHwRet(
    redeclare final package Medium = Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=1) "Pressure boundary condition at HP inlet" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-130,-160})));
  Movers.Preconfigured.SpeedControlled_y pumChwPri(
    redeclare final package Medium=Medium,
    final energyDynamics=energyDynamics,
    addPowerToMedium=false,
    m_flow_nominal=hp.mEva_flow_nominal,
    dp_nominal=dpChwLocSet_max + hp.dpChw_nominal) "Primary CHW pump"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Movers.Preconfigured.SpeedControlled_y pumHwPri(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    addPowerToMedium=false,
    m_flow_nominal=hp.mCon_flow_nominal,
    dp_nominal=dpHwLocSet_max + hp.dpHw_nominal) "Primary HW pump"
    annotation (Placement(transformation(extent={{-10,-210},{10,-190}})));
  Actuators.Valves.TwoWayTable  valHwIso(
    redeclare final package Medium = Medium,
    final m_flow_nominal=hp.mCon_flow_nominal,
    flowCharacteristics=hp.chaValHwIso,
    dpValve_nominal=hp.dpValIso_nominal,
    strokeTime=10,
    init=Modelica.Blocks.Types.Init.InitialState,
    dpFixed_nominal=hp.dpHw_nominal)
    "HW isolation valve"
    annotation (Placement(transformation(extent={{-90,-210},{-70,-190}})));
  Actuators.Valves.TwoWayTable  valChwIso(
    redeclare final package Medium = Medium,
    final m_flow_nominal=hp.mEva_flow_nominal,
    dpValve_nominal=hp.dpValIso_nominal,
    init=Modelica.Blocks.Types.Init.InitialState,
    dpFixed_nominal=hp.dpChw_nominal,
    flowCharacteristics=hp.chaValChwIso) "CHW isolation valve"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum sumNumUni(nin=3)
    "Total number of enabled modules"
    annotation (Placement(transformation(extent={{-220,-210},{-200,-190}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(message="Number of enabled modules exceeds number of modules")
    "Assert condition on number of enabled modules"
             annotation (Placement(transformation(extent={{-192,-250},{-172,
            -230}})));
  Buildings.Controls.OBC.CDL.Integers.LessEqualThreshold intLesEquThr(t=hp.nUni)
    "True if number of enabled modules lower or equal to number of modules"
    annotation (Placement(transformation(extent={{-192,-210},{-172,-190}})));
  Sensors.RelativePressure dpChwHea(redeclare final package Medium = Medium)
    "Module CHW header differential pressure" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-60,-60})));
  Sensors.RelativePressure dpHwHea(redeclare final package Medium = Medium)
    "Mpdule HW header differential pressure" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-60,-220})));
  Actuators.Valves.TwoWayLinear valChwByp(
    redeclare final package Medium = Medium,
    final m_flow_nominal=hp.mEva_flow_nominal/hp.nUni,
    dpValve_nominal=hp.dpChw_nominal,
    init=Modelica.Blocks.Types.Init.InitialState)
    "CHW minimum flow bypass valve" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={40,-60})));
  Templates.Plants.Controls.Utilities.PIDWithEnable ctlPumChwPri(k=0.01, r=
        dpChwRemSet_max) "Primary CHW pump controller"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpHeaSet[2](k={hp.dpHw_nominal,
        hp.dpChw_nominal}) "Module header dp setpoint"
    annotation (Placement(transformation(extent={{-220,40},{-200,60}})));
  Templates.Plants.Controls.Utilities.PIDWithEnable ctlValChwByp(
    k=1,
    Ti=0.1,
    r=hp.dpChw_nominal,
    y_reset=1,
    y_neutral=0) "CHW minimum flow bypass valve controller"
    annotation (Placement(transformation(extent={{-30,30},{-10,50}})));
  Templates.Plants.Controls.Utilities.PIDWithEnable ctlPumHwPri(k=0.01, r=
        dpHwRemSet_max) "Primary HW pump controller"
    annotation (Placement(transformation(extent={{-30,-170},{-10,-150}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpRemSet[2](k={
        dpHwRemSet_max,dpChwRemSet_max}) "Remote dp setpoint"
    annotation (Placement(transformation(extent={{-220,80},{-200,100}})));
  Sensors.TemperatureTwoPort THwRet(redeclare final package Medium = Medium,
      final m_flow_nominal=hp.mCon_flow_nominal) "HW return temperature"
    annotation (Placement(transformation(extent={{-70,-250},{-90,-230}})));
  Sensors.TemperatureTwoPort TChwRet(redeclare final package Medium = Medium,
      final m_flow_nominal=hp.mEva_flow_nominal) "CHW return temperature"
    annotation (Placement(transformation(extent={{-70,-90},{-90,-70}})));
  Actuators.Valves.TwoWayLinear valHwByp(
    redeclare final package Medium = Medium,
    final m_flow_nominal=hp.mCon_flow_nominal/hp.nUni,
    dpValve_nominal=hp.dpHw_nominal,
    init=Modelica.Blocks.Types.Init.InitialState)
    "HW minimum flow bypass valve" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={40,-220})));
  Templates.Plants.Controls.Utilities.PIDWithEnable ctlValHwByp(
    k=1,
    Ti=0.1,
    r=hp.dpHw_nominal,
    y_reset=1,
    y_neutral=0) "HW minimum flow bypass valve controller"
    annotation (Placement(transformation(extent={{-30,-130},{-10,-110}})));
equation
  connect(loaChw.port_b, valDisChw.port_a)
    annotation (Line(points={{130,-40},{150,-40}},
                                                 color={0,127,255}));
  connect(loaHw.port_b, valDisHw.port_a)
    annotation (Line(points={{130,-200},{150,-200}},
                                                   color={0,127,255}));
  connect(TDum.y, reqPlaRes.TAirSup)
    annotation (Line(points={{-198,220},{60,220},{60,200},{92,200}},  color={0,0,127}));
  connect(TDum.y, reqPlaRes.TAirSupSet)
    annotation (Line(points={{-198,220},{60,220},{60,195},{92,195}},  color={0,0,127}));
  connect(valDisChw.y_actual, reqPlaRes.uCooCoiSet)
    annotation (Line(points={{165,-33},{180,-33},{180,189},{92,189}},color={0,0,127}));
  connect(valDisHw.y_actual, reqPlaRes.uHeaCoiSet)
    annotation (Line(points={{165,-193},{176,-193},{176,184},{92,184}},color={0,0,127}));
  connect(valDisChw.port_b, mChw_flow.port_a)
    annotation (Line(points={{170,-40},{200,-40},{200,-50}},color={0,127,255}));
  connect(valDisHw.port_b, mHw_flow.port_a)
    annotation (Line(points={{170,-200},{200,-200},{200,-210}},color={0,127,255}));
  connect(mHw_flow.m_flow, norFlo[1].u)
    annotation (Line(points={{211,-220},{220,-220},{220,-12}},color={0,0,127}));
  connect(mChw_flow.m_flow, norFlo[2].u)
    annotation (Line(points={{211,-60},{220,-60},{220,-12}},color={0,0,127}));
  connect(norFlo.y, ctlEquZon.u_m)
    annotation (Line(points={{220,12},{220,140},{80,140},{80,148}},
                                                                color={0,0,127}));
  connect(ctlEquZon[2].y, valDisChw.y)
    annotation (Line(points={{92,160},{100,160},{100,30},{160,30},{160,-28}},
      color={0,0,127}));
  connect(ctlEquZon[1].y, valDisHw.y)
    annotation (Line(points={{92,160},{140,160},{140,-44},{160,-44},{160,-188}},
      color={0,0,127}));
  connect(TChwRetPre.y, min1.u1) annotation (Line(points={{-148,130},{-140,130},
          {-140,136},{-132,136}}, color={0,0,127}));
  connect(min1.y, loaChw.TSet)
    annotation (Line(points={{-108,130},{100,130},{100,-32},{108,-32}},
                                                                 color={0,0,127}));
  connect(max2.y, loaHw.TSet)
    annotation (Line(points={{-38,110},{84,110},{84,-192},{108,-192}},
                                                                   color={0,0,127}));
  connect(cst.y, mulInt.u1)
    annotation (Line(points={{18,240},{10,240},{10,206},{2,206}},
                                                               color={255,127,0}));
  connect(mChw_flow.port_b, pipChw.port_a)
    annotation (Line(points={{200,-70},{200,-80},{80,-80}},  color={0,127,255}));
  connect(mHw_flow.port_b, pipHw.port_a)
    annotation (Line(points={{200,-230},{200,-240},{80,-240}},color={0,127,255}));
  connect(con.y, min1.u2)
    annotation (Line(points={{-198,150},{-140,150},{-140,124},{-132,124}},
                                                                     color={0,0,127}));
  connect(con.y, max2.u1)
    annotation (Line(points={{-198,150},{-70,150},{-70,116},{-62,116}},
                                                                     color={0,0,127}));
  connect(THwRetPre.y, max2.u2) annotation (Line(points={{-78,110},{-70,110},{
          -70,104},{-62,104}},
                         color={0,0,127}));
  connect(weaDat.weaBus, hp.weaBus) annotation (Line(
      points={{-200,-30},{-130,-30},{-130,-64}},
      color={255,204,51},
      thickness=0.5));
  connect(mode.y, hp.mode) annotation (Line(points={{-198,-120},{-180,-120},{
          -180,-78},{-142,-78}},
                           color={255,127,0}));
  connect(reqPlaRes.yChiPlaReq, mulInt[2].u2) annotation (Line(points={{68,195},
          {20,195},{20,194},{2,194}}, color={255,127,0}));
  connect(reqPlaRes.yHotWatPlaReq, mulInt[1].u2) annotation (Line(points={{68,184},
          {20,184},{20,194},{2,194}}, color={255,127,0}));
  connect(ratFlo.y, ctlEquZon.u_s)
    annotation (Line(points={{-198,180},{-66,180},{-66,160},{68,160}},
                                                   color={0,0,127}));
  connect(on.y, hp.on) annotation (Line(points={{-198,-70},{-184,-70},{-184,-76},
          {-142,-76}},color={255,0,255}));
  connect(THwSup.T, TChwRetPre.u) annotation (Line(points={{-50,-189},{-50,48},
          {-180,48},{-180,130},{-172,130}},color={0,0,127}));
  connect(TChwSup.T, THwRetPre.u) annotation (Line(points={{-30,-29},{-30,0},{
          -178,0},{-178,110},{-102,110}},   color={0,0,127}));
  connect(TSupSet[1].y, hp.THwSet) annotation (Line(points={{-198,10},{-180,10},
          {-180,-70},{-142,-70}},color={0,0,127}));
  connect(TSupSet[2].y, hp.TChwSet) annotation (Line(points={{-198,10},{-180,10},
          {-180,-74},{-142,-74}},color={0,0,127}));
  connect(TChwSup.port_b, pumChwPri.port_a)
    annotation (Line(points={{-20,-40},{-10,-40}},
                                                color={0,127,255}));
  connect(pumChwPri.port_b, loaChw.port_a)
    annotation (Line(points={{10,-40},{110,-40}},color={0,127,255}));
  connect(dpChwRem.port_a, loaChw.port_a)
    annotation (Line(points={{100,-50},{100,-40},{110,-40}},
                                                          color={0,127,255}));
  connect(dpChwRem.port_b, pipChw.port_a)
    annotation (Line(points={{100,-70},{100,-80},{80,-80}},color={0,127,255}));
  connect(dpHwRem.port_b, pipHw.port_a) annotation (Line(points={{100,-230},{
          100,-240},{80,-240}},
                     color={0,127,255}));
  connect(dpHwRem.port_a, loaHw.port_a) annotation (Line(points={{100,-210},{
          100,-200},{110,-200}},
                      color={0,127,255}));
  connect(pHwRet.ports[1], hp.port_a1) annotation (Line(points={{-140,-160},{
          -150,-160},{-150,-68},{-140,-68}},
                                       color={0,127,255}));
  connect(THwSup.port_b, pumHwPri.port_a)
    annotation (Line(points={{-40,-200},{-10,-200}},color={0,127,255}));
  connect(pumHwPri.port_b, loaHw.port_a)
    annotation (Line(points={{10,-200},{110,-200}},color={0,127,255}));
  connect(hp.port_b1, valHwIso.port_a) annotation (Line(points={{-120,-68},{
          -100,-68},{-100,-200},{-90,-200}},
                                       color={0,127,255}));
  connect(valHwIso.port_b, THwSup.port_a)
    annotation (Line(points={{-70,-200},{-60,-200}}, color={0,127,255}));
  connect(hp.yValHwIso, valHwIso.y) annotation (Line(points={{-122,-63},{-122,
          -60},{-96,-60},{-96,-180},{-80,-180},{-80,-188}},
                                      color={0,0,127}));
  connect(valChwIso.port_b, TChwSup.port_a)
    annotation (Line(points={{-70,-40},{-40,-40}}, color={0,127,255}));
  connect(hp.port_b2, valChwIso.port_a) annotation (Line(points={{-140,-80},{
          -160,-80},{-160,-40},{-90,-40}}, color={0,127,255}));
  connect(hp.yValChwIso, valChwIso.y) annotation (Line(points={{-138,-85},{-138,
          -88},{-94,-88},{-94,-20},{-80,-20},{-80,-28}},   color={0,0,127}));
  connect(sumNumUni.y,intLesEquThr. u)
    annotation (Line(points={{-198,-200},{-194,-200}},
                                             color={255,127,0}));
  connect(intLesEquThr.y,assMes. u)
    annotation (Line(points={{-170,-200},{-166,-200},{-166,-220},{-200,-220},{
          -200,-240},{-194,-240}},           color={255,0,255}));
  connect(hp.nUniShc, sumNumUni.u[1]) annotation (Line(points={{-133,-86},{-133,
          -90},{-230,-90},{-230,-202.333},{-222,-202.333}},   color={255,127,0}));
  connect(hp.nUniCoo, sumNumUni.u[2]) annotation (Line(points={{-130,-86},{-130,
          -90},{-230,-90},{-230,-200},{-222,-200}},   color={255,127,0}));
  connect(hp.nUniHea, sumNumUni.u[3]) annotation (Line(points={{-127,-86},{-127,
          -90},{-230,-90},{-230,-197.667},{-222,-197.667}},   color={255,127,0}));
  connect(pumChwPri.port_b, valChwByp.port_a)
    annotation (Line(points={{10,-40},{40,-40},{40,-50}}, color={0,127,255}));
  connect(dpChwRem.p_rel, ctlPumChwPri.u_m) annotation (Line(points={{91,-60},{
          80,-60},{80,-20},{-20,-20},{-20,-12}},
                                              color={0,0,127}));
  connect(on.y, ctlPumChwPri.uEna) annotation (Line(points={{-198,-70},{-184,
          -70},{-184,-16},{-24,-16},{-24,-12}},
                                           color={255,0,255}));
  connect(ctlPumChwPri.y, pumChwPri.y)
    annotation (Line(points={{-8,0},{0,0},{0,-28}}, color={0,0,127}));
  connect(dpHeaSet[2].y, ctlValChwByp.u_s)
    annotation (Line(points={{-198,50},{-116,50},{-116,40},{-32,40}},
                                                  color={0,0,127}));
  connect(ctlValChwByp.y, valChwByp.y) annotation (Line(points={{-8,40},{20,40},
          {20,-60},{28,-60}}, color={0,0,127}));
  connect(dpChwHea.p_rel, ctlValChwByp.u_m) annotation (Line(points={{-51,-60},
          {-48,-60},{-48,20},{-20,20},{-20,28}},color={0,0,127}));
  connect(on.y, ctlValChwByp.uEna) annotation (Line(points={{-198,-70},{-184,
          -70},{-184,22},{-24,22},{-24,28}},
                                        color={255,0,255}));
  connect(dpHwRem.p_rel, ctlPumHwPri.u_m) annotation (Line(points={{91,-220},{
          80,-220},{80,-180},{-20,-180},{-20,-172}},
                                                  color={0,0,127}));
  connect(ctlPumHwPri.y, pumHwPri.y)
    annotation (Line(points={{-8,-160},{0,-160},{0,-188}}, color={0,0,127}));
  connect(on.y, ctlPumHwPri.uEna) annotation (Line(points={{-198,-70},{-184,-70},
          {-184,-180},{-24,-180},{-24,-172}}, color={255,0,255}));
  connect(dpRemSet[2].y, ctlPumChwPri.u_s) annotation (Line(points={{-198,90},{
          -38,90},{-38,0},{-32,0}},
                                color={0,0,127}));
  connect(dpRemSet[1].y, ctlPumHwPri.u_s) annotation (Line(points={{-198,90},{
          -38,90},{-38,-160},{-32,-160}},
                                      color={0,0,127}));
  connect(pChwRet.ports[1], hp.port_a2)
    annotation (Line(points={{-120,-120},{-120,-80}}, color={0,127,255}));
  connect(pipHw.port_b, THwRet.port_a)
    annotation (Line(points={{60,-240},{-70,-240}}, color={0,127,255}));
  connect(THwRet.port_b, hp.port_a1) annotation (Line(points={{-90,-240},{-150,
          -240},{-150,-68},{-140,-68}},            color={0,127,255}));
  connect(pipChw.port_b, TChwRet.port_a)
    annotation (Line(points={{60,-80},{-70,-80}},   color={0,127,255}));
  connect(TChwRet.port_b, hp.port_a2) annotation (Line(points={{-90,-80},{-120,
          -80}},                        color={0,127,255}));
  connect(pumHwPri.port_b, valHwByp.port_a) annotation (Line(points={{10,-200},
          {40,-200},{40,-210}}, color={0,127,255}));
  connect(on.y, ctlValHwByp.uEna) annotation (Line(points={{-198,-70},{-184,-70},
          {-184,-140},{-24,-140},{-24,-132}}, color={255,0,255}));
  connect(dpHwHea.p_rel, ctlValHwByp.u_m) annotation (Line(points={{-51,-220},{
          -40,-220},{-40,-142},{-20,-142},{-20,-132}}, color={0,0,127}));
  connect(ctlValHwByp.y, valHwByp.y) annotation (Line(points={{-8,-120},{20,
          -120},{20,-220},{28,-220}}, color={0,0,127}));
  connect(dpHeaSet[1].y, ctlValHwByp.u_s) annotation (Line(points={{-198,50},{
          -40,50},{-40,-120},{-32,-120}}, color={0,0,127}));
  connect(valHwByp.port_b, THwRet.port_a) annotation (Line(points={{40,-230},{
          40,-240},{-70,-240}}, color={0,127,255}));
  connect(valChwByp.port_b, TChwRet.port_a) annotation (Line(points={{40,-70},{
          40,-80},{-70,-80}},   color={0,127,255}));
  connect(dpChwHea.port_a, TChwRet.port_a) annotation (Line(points={{-60,-70},{
          -60,-80},{-70,-80}},   color={0,127,255}));
  connect(valChwIso.port_b, dpChwHea.port_b) annotation (Line(points={{-70,-40},
          {-60,-40},{-60,-50}}, color={0,127,255}));
  connect(dpHwHea.port_a, THwRet.port_a) annotation (Line(points={{-60,-230},{
          -60,-240},{-70,-240}}, color={0,127,255}));
  connect(valHwIso.port_b, dpHwHea.port_b) annotation (Line(points={{-70,-200},
          {-60,-200},{-60,-210}}, color={0,127,255}));
  connect(TChwSup.T, ctlPumChwPri.u_s) annotation (Line(points={{-30,-29},{-30,
          -14.5},{-32,-14.5},{-32,0}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/ModularReversible/Examples/AirToWater.mos"
        "Simulate and plot"),
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
        extent={{-240,-260},{240,260}}, grid={2,2})),
    Icon(coordinateSystem(extent={{-240,-260},{240,260}})));
end AirToWater;
