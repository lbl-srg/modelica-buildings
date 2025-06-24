within Buildings.Fluid.HeatPumps.ModularReversible.Examples;
model TableData2DLoadDepSHCDetailed
  "Validation of AWHP plant template"
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
    y_start=0,
    dpFixed_nominal=dpHwRemSet_max - 3E4)
    "Distribution system approximated by variable flow resistance"
    annotation (Placement(transformation(extent={{150,-210},{170,-190}})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage valDisChw(
    redeclare final package Medium=Medium,
    m_flow_nominal=mChw_flow_nominal,
    dpValve_nominal=3E4,
    y_start=0,
    dpFixed_nominal=dpChwRemSet_max - 3E4)
    "Distribution system approximated by variable flow resistance"
    annotation (Placement(transformation(extent={{150,-50},{170,-30}})));
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
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable ratFlo(table=[0,0,0; 5,0,0;
        7,1,0; 12,0.4,0.4; 16,0,1; 22,0.1,0.1; 24,0,0],
    timeScale=3600)
    "Source signal for flow rate ratio – Index 1 for HW, 2 for CHW"
    annotation (Placement(transformation(extent={{-220,170},{-200,190}})));
  Buildings.Controls.OBC.CDL.Reals.PID ctlEquZon[2](
    each k=0.1,
    each Ti=60,
    each final reverseActing=true) "Zone equipment controller"
    annotation (Placement(transformation(extent={{70,50},{90,70}})));
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
    annotation (Placement(transformation(extent={{-170,150},{-150,170}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter THwRetPre(p=THwRet_nominal -
        THwSup_nominal) "Prescribed HW return temperature"
    annotation (Placement(transformation(extent={{-170,110},{-150,130}})));
  Buildings.Controls.OBC.CDL.Reals.Max max2
    "Limit prescribed HWRT"
    annotation (Placement(transformation(extent={{-130,110},{-110,130}})));
  Buildings.Controls.OBC.CDL.Reals.Min min1
    "Limit prescribed CHWRT"
    annotation (Placement(transformation(extent={{-130,150},{-110,170}})));
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
    annotation (Placement(transformation(extent={{-220,130},{-200,150}})));
  Buildings.Fluid.HeatPumps.ModularReversible.TableData2DLoadDepSHC hp(
    redeclare final package MediumCon=Medium,
    redeclare final package MediumEva=Medium,
    final energyDynamics=energyDynamics,
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
    annotation (Placement(transformation(extent={{-150,-84},{-130,-64}})));
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
        origin={-140,-120})));
  Sources.Boundary_pT pHwRet(
    redeclare final package Medium = Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=1) "Pressure boundary condition at HP inlet" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-140,-160})));
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
    init=Modelica.Blocks.Types.Init.InitialState,
    dpFixed_nominal=hp.dpHw_nominal)
    "HW isolation valve"
    annotation (Placement(transformation(extent={{-110,-210},{-90,-190}})));
  Actuators.Valves.TwoWayTable  valChwIso(
    redeclare final package Medium = Medium,
    final m_flow_nominal=hp.mEva_flow_nominal,
    dpValve_nominal=hp.dpValIso_nominal,
    init=Modelica.Blocks.Types.Init.InitialState,
    dpFixed_nominal=hp.dpChw_nominal,
    flowCharacteristics=hp.chaValChwIso) "CHW isolation valve"
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));
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
    from_dp=true,
    dpValve_nominal=hp.dpChw_nominal,
    init=Modelica.Blocks.Types.Init.InitialState)
    "CHW minimum flow bypass valve" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={40,-60})));
  Templates.Plants.Controls.Utilities.PIDWithEnable ctlPumChwPri(
    k=0.1,
    Ti=60,
    r=dpChwRemSet_max)
    "Primary CHW pump controller"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpHeaSet[2](k={hp.dpHw_nominal,
        hp.dpChw_nominal}) "Module header dp setpoint"
    annotation (Placement(transformation(extent={{-220,40},{-200,60}})));
  Templates.Plants.Controls.Utilities.PIDWithEnable ctlValChwByp(
    k=0.1,
    Ti=60,
    r=hp.dpChw_nominal,
    y_reset=1,
    y_neutral=1)
    "CHW minimum flow bypass valve controller"
    annotation (Placement(transformation(extent={{-30,30},{-10,50}})));
  Templates.Plants.Controls.Utilities.PIDWithEnable ctlPumHwPri(
    k=0.1,
    Ti=60,
    r=dpHwRemSet_max) "Primary HW pump controller"
    annotation (Placement(transformation(extent={{-30,-170},{-10,-150}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpRemSet[2](k={
        dpHwRemSet_max,dpChwRemSet_max}) "Remote dp setpoint"
    annotation (Placement(transformation(extent={{-220,80},{-200,100}})));
  Sensors.TemperatureTwoPort THwRetPla(redeclare final package Medium = Medium,
      final m_flow_nominal=hp.mCon_flow_nominal) "Plant HW return temperature"
    annotation (Placement(transformation(extent={{-70,-250},{-90,-230}})));
  Sensors.TemperatureTwoPort TChwRetPla(redeclare final package Medium = Medium,
      final m_flow_nominal=hp.mEva_flow_nominal) "Plant CHW return temperature"
    annotation (Placement(transformation(extent={{-70,-90},{-90,-70}})));
  Actuators.Valves.TwoWayLinear valHwByp(
    redeclare final package Medium = Medium,
    final m_flow_nominal=hp.mCon_flow_nominal/hp.nUni,
    from_dp=true,
    dpValve_nominal=hp.dpHw_nominal,
    init=Modelica.Blocks.Types.Init.InitialState)
    "HW minimum flow bypass valve" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={40,-220})));
  Templates.Plants.Controls.Utilities.PIDWithEnable ctlValHwByp(
    k=0.1,
    Ti=60,
    r=hp.dpHw_nominal,
    y_reset=1,
    y_neutral=1)
    "HW minimum flow bypass valve controller"
    annotation (Placement(transformation(extent={{-30,-130},{-10,-110}})));
  Sensors.TemperatureTwoPort TChwRet(redeclare final package Medium = Medium,
      final m_flow_nominal=hp.mEva_flow_nominal) "CHW return temperature"
    annotation (Placement(transformation(extent={{170,-90},{150,-70}})));
  Sensors.TemperatureTwoPort THwRet(redeclare final package Medium = Medium,
      final m_flow_nominal=hp.mCon_flow_nominal) "HW return temperature"
    annotation (Placement(transformation(extent={{170,-250},{150,-230}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold valChwReq(t=1E-1, h=5E-2)
    "CHW plant request from terminal valve"
    annotation (Placement(transformation(extent={{160,170},{140,190}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold valHwReq(t=1E-1, h=5E-2)
    "HW plant request from terminal valve"
    annotation (Placement(transformation(extent={{160,210},{140,230}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger reqHea
    "Heating plant request"
    annotation (Placement(transformation(extent={{130,210},{110,230}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger reqCoo
    "Cooling plant request"
    annotation (Placement(transformation(extent={{132,170},{112,190}})));
  Buildings.Controls.OBC.CDL.Logical.Or on "HP commanded on"
    annotation (Placement(transformation(extent={{50,190},{30,210}})));
  Buildings.Controls.OBC.CDL.Logical.And onAndHea
    "HP commanded on and heating enabled"
    annotation (Placement(transformation(extent={{10,210},{-10,230}})));
  Buildings.Controls.OBC.CDL.Logical.And onAndCoo
    "HP commanded on and cooling enabled"
    annotation (Placement(transformation(extent={{10,170},{-10,190}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold staValChwIso(t=0.9/hp.nUni,
      h=0.1/hp.nUni) "CHW isolation valve open end switch status"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold staValHwIso(t=0.9/hp.nUni,
      h=0.1/hp.nUni) "HW isolation valve open end switch status"
    annotation (Placement(transformation(extent={{-80,-190},{-60,-170}})));
  Templates.Plants.Controls.Enabling.Enable enaHea(typ=Buildings.Templates.Plants.Controls.Types.Application.Heating,
      TOutLck=295.15) "Enable heating"
    annotation (Placement(transformation(extent={{90,210},{70,230}})));
  Templates.Plants.Controls.Enabling.Enable enaCoo(typ=Buildings.Templates.Plants.Controls.Types.Application.Cooling,
      TOutLck=290.15) "Enable cooling"
    annotation (Placement(transformation(extent={{90,170},{70,190}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger intModCoo(integerTrue
      =2) "Cast to integer for operating mode command"
    annotation (Placement(transformation(extent={{-50,170},{-70,190}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger intModHea(integerTrue
      =1) "Cast to integer for operating mode command"
    annotation (Placement(transformation(extent={{-50,210},{-70,230}})));
  Buildings.Controls.OBC.CDL.Integers.Add mode "Operating mode"
    annotation (Placement(transformation(extent={{-90,210},{-110,230}})));
equation
  connect(loaChw.port_b, valDisChw.port_a)
    annotation (Line(points={{130,-40},{150,-40}},
                                                 color={0,127,255}));
  connect(loaHw.port_b, valDisHw.port_a)
    annotation (Line(points={{130,-200},{150,-200}},
                                                   color={0,127,255}));
  connect(valDisChw.port_b, mChw_flow.port_a)
    annotation (Line(points={{170,-40},{200,-40},{200,-50}},color={0,127,255}));
  connect(valDisHw.port_b, mHw_flow.port_a)
    annotation (Line(points={{170,-200},{200,-200},{200,-210}},color={0,127,255}));
  connect(mHw_flow.m_flow, norFlo[1].u)
    annotation (Line(points={{211,-220},{220,-220},{220,-12}},color={0,0,127}));
  connect(mChw_flow.m_flow, norFlo[2].u)
    annotation (Line(points={{211,-60},{220,-60},{220,-12}},color={0,0,127}));
  connect(norFlo.y, ctlEquZon.u_m)
    annotation (Line(points={{220,12},{220,20},{80,20},{80,48}},color={0,0,127}));
  connect(ctlEquZon[2].y, valDisChw.y)
    annotation (Line(points={{92,60},{160,60},{160,-28}},
      color={0,0,127}));
  connect(ctlEquZon[1].y, valDisHw.y)
    annotation (Line(points={{92,60},{140,60},{140,-180},{160,-180},{160,-188}},
      color={0,0,127}));
  connect(TChwRetPre.y, min1.u1) annotation (Line(points={{-148,160},{-140,160},
          {-140,166},{-132,166}}, color={0,0,127}));
  connect(min1.y, loaChw.TSet)
    annotation (Line(points={{-108,160},{24,160},{24,-32},{108,-32}},
                                                                 color={0,0,127}));
  connect(max2.y, loaHw.TSet)
    annotation (Line(points={{-108,120},{22,120},{22,-192},{108,-192}},
                                                                   color={0,0,127}));
  connect(con.y, min1.u2)
    annotation (Line(points={{-198,140},{-140,140},{-140,154},{-132,154}},
                                                                     color={0,0,127}));
  connect(con.y, max2.u1)
    annotation (Line(points={{-198,140},{-140,140},{-140,126},{-132,126}},
                                                                     color={0,0,127}));
  connect(THwRetPre.y, max2.u2) annotation (Line(points={{-148,120},{-140,120},{
          -140,114},{-132,114}},
                         color={0,0,127}));
  connect(weaDat.weaBus, hp.weaBus) annotation (Line(
      points={{-200,-30},{-140,-30},{-140,-64}},
      color={255,204,51},
      thickness=0.5));
  connect(ratFlo.y, ctlEquZon.u_s)
    annotation (Line(points={{-198,180},{-100,180},{-100,60},{68,60}},
                                                   color={0,0,127}));
  connect(TSupSet[1].y, hp.THwSet) annotation (Line(points={{-198,10},{-180,10},
          {-180,-70},{-152,-70}},color={0,0,127}));
  connect(TSupSet[2].y, hp.TChwSet) annotation (Line(points={{-198,10},{-180,10},
          {-180,-74},{-152,-74}},color={0,0,127}));
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
  connect(pHwRet.ports[1], hp.port_a1) annotation (Line(points={{-150,-160},{
          -160,-160},{-160,-68},{-150,-68}},
                                       color={0,127,255}));
  connect(THwSup.port_b, pumHwPri.port_a)
    annotation (Line(points={{-40,-200},{-10,-200}},color={0,127,255}));
  connect(pumHwPri.port_b, loaHw.port_a)
    annotation (Line(points={{10,-200},{110,-200}},color={0,127,255}));
  connect(hp.port_b1, valHwIso.port_a) annotation (Line(points={{-130,-68},{
          -120,-68},{-120,-200},{-110,-200}},
                                       color={0,127,255}));
  connect(valHwIso.port_b, THwSup.port_a)
    annotation (Line(points={{-90,-200},{-60,-200}}, color={0,127,255}));
  connect(hp.yValHwIso, valHwIso.y) annotation (Line(points={{-132,-63},{-132,
          -60},{-100,-60},{-100,-188}},
                                      color={0,0,127}));
  connect(valChwIso.port_b, TChwSup.port_a)
    annotation (Line(points={{-90,-40},{-40,-40}}, color={0,127,255}));
  connect(hp.port_b2, valChwIso.port_a) annotation (Line(points={{-150,-80},{
          -170,-80},{-170,-40},{-110,-40}},color={0,127,255}));
  connect(hp.yValChwIso, valChwIso.y) annotation (Line(points={{-148,-85},{-148,
          -88},{-114,-88},{-114,-22},{-100,-22},{-100,-28}},
                                                           color={0,0,127}));
  connect(sumNumUni.y,intLesEquThr. u)
    annotation (Line(points={{-198,-200},{-194,-200}},
                                             color={255,127,0}));
  connect(intLesEquThr.y,assMes. u)
    annotation (Line(points={{-170,-200},{-166,-200},{-166,-220},{-200,-220},{
          -200,-240},{-194,-240}},           color={255,0,255}));
  connect(hp.nUniShc, sumNumUni.u[1]) annotation (Line(points={{-143,-86},{-143,
          -90},{-230,-90},{-230,-202.333},{-222,-202.333}},   color={255,127,0}));
  connect(hp.nUniCoo, sumNumUni.u[2]) annotation (Line(points={{-140,-86},{-140,
          -90},{-230,-90},{-230,-200},{-222,-200}},   color={255,127,0}));
  connect(hp.nUniHea, sumNumUni.u[3]) annotation (Line(points={{-137,-86},{-137,
          -90},{-230,-90},{-230,-197.667},{-222,-197.667}},   color={255,127,0}));
  connect(pumChwPri.port_b, valChwByp.port_a)
    annotation (Line(points={{10,-40},{40,-40},{40,-50}}, color={0,127,255}));
  connect(dpChwRem.p_rel, ctlPumChwPri.u_m) annotation (Line(points={{91,-60},{
          80,-60},{80,-20},{-20,-20},{-20,-12}},
                                              color={0,0,127}));
  connect(ctlPumChwPri.y, pumChwPri.y)
    annotation (Line(points={{-8,0},{0,0},{0,-28}}, color={0,0,127}));
  connect(dpHeaSet[2].y, ctlValChwByp.u_s)
    annotation (Line(points={{-198,50},{-40,50},{-40,40},{-32,40}},
                                                  color={0,0,127}));
  connect(ctlValChwByp.y, valChwByp.y) annotation (Line(points={{-8,40},{20,40},
          {20,-60},{28,-60}}, color={0,0,127}));
  connect(dpChwHea.p_rel, ctlValChwByp.u_m) annotation (Line(points={{-51,-60},
          {-44,-60},{-44,20},{-20,20},{-20,28}},color={0,0,127}));
  connect(dpHwRem.p_rel, ctlPumHwPri.u_m) annotation (Line(points={{91,-220},{
          80,-220},{80,-180},{-20,-180},{-20,-172}},
                                                  color={0,0,127}));
  connect(ctlPumHwPri.y, pumHwPri.y)
    annotation (Line(points={{-8,-160},{0,-160},{0,-188}}, color={0,0,127}));
  connect(dpRemSet[2].y, ctlPumChwPri.u_s) annotation (Line(points={{-198,90},{
          -38,90},{-38,0},{-32,0}},
                                color={0,0,127}));
  connect(dpRemSet[1].y, ctlPumHwPri.u_s) annotation (Line(points={{-198,90},{
          -38,90},{-38,-160},{-32,-160}},
                                      color={0,0,127}));
  connect(pChwRet.ports[1], hp.port_a2)
    annotation (Line(points={{-130,-120},{-130,-80}}, color={0,127,255}));
  connect(pipHw.port_b, THwRetPla.port_a)
    annotation (Line(points={{60,-240},{-70,-240}}, color={0,127,255}));
  connect(THwRetPla.port_b, hp.port_a1) annotation (Line(points={{-90,-240},{
          -160,-240},{-160,-68},{-150,-68}}, color={0,127,255}));
  connect(pipChw.port_b, TChwRetPla.port_a)
    annotation (Line(points={{60,-80},{-70,-80}}, color={0,127,255}));
  connect(TChwRetPla.port_b, hp.port_a2)
    annotation (Line(points={{-90,-80},{-130,-80}}, color={0,127,255}));
  connect(pumHwPri.port_b, valHwByp.port_a) annotation (Line(points={{10,-200},
          {40,-200},{40,-210}}, color={0,127,255}));
  connect(dpHwHea.p_rel, ctlValHwByp.u_m) annotation (Line(points={{-51,-220},{
          -40,-220},{-40,-140},{-20,-140},{-20,-132}}, color={0,0,127}));
  connect(ctlValHwByp.y, valHwByp.y) annotation (Line(points={{-8,-120},{20,
          -120},{20,-220},{28,-220}}, color={0,0,127}));
  connect(dpHeaSet[1].y, ctlValHwByp.u_s) annotation (Line(points={{-198,50},{
          -40,50},{-40,-120},{-32,-120}}, color={0,0,127}));
  connect(valHwByp.port_b, THwRetPla.port_a) annotation (Line(points={{40,-230},
          {40,-240},{-70,-240}}, color={0,127,255}));
  connect(valChwByp.port_b, TChwRetPla.port_a)
    annotation (Line(points={{40,-70},{40,-80},{-70,-80}}, color={0,127,255}));
  connect(dpChwHea.port_a, TChwRetPla.port_a) annotation (Line(points={{-60,-70},
          {-60,-80},{-70,-80}}, color={0,127,255}));
  connect(valChwIso.port_b, dpChwHea.port_b) annotation (Line(points={{-90,-40},
          {-60,-40},{-60,-50}}, color={0,127,255}));
  connect(dpHwHea.port_a, THwRetPla.port_a) annotation (Line(points={{-60,-230},
          {-60,-240},{-70,-240}}, color={0,127,255}));
  connect(valHwIso.port_b, dpHwHea.port_b) annotation (Line(points={{-90,-200},
          {-60,-200},{-60,-210}}, color={0,127,255}));
  connect(mChw_flow.port_b, TChwRet.port_a) annotation (Line(points={{200,-70},
          {200,-80},{170,-80}}, color={0,127,255}));
  connect(TChwRet.port_b, pipChw.port_a)
    annotation (Line(points={{150,-80},{80,-80}}, color={0,127,255}));
  connect(mHw_flow.port_b, THwRet.port_a) annotation (Line(points={{200,-230},{
          200,-240},{170,-240}}, color={0,127,255}));
  connect(THwRet.port_b, pipHw.port_a)
    annotation (Line(points={{150,-240},{80,-240}}, color={0,127,255}));
  connect(TChwSup.T, TChwRetPre.u) annotation (Line(points={{-30,-29},{-30,-20},
          {-178,-20},{-178,160},{-172,160}}, color={0,0,127}));
  connect(THwSup.T, THwRetPre.u) annotation (Line(points={{-50,-189},{-50,-18},
          {-176,-18},{-176,120},{-172,120}},           color={0,0,127}));
  connect(valDisChw.y_actual, valChwReq.u) annotation (Line(points={{165,-33},{
          170,-33},{170,180},{162,180}},
                                     color={0,0,127}));
  connect(valDisHw.y_actual, valHwReq.u) annotation (Line(points={{165,-193},{
          176,-193},{176,220},{162,220}},
                                      color={0,0,127}));
  connect(on.y, hp.on) annotation (Line(points={{28,200},{-184,200},{-184,-76},
          {-152,-76}}, color={255,0,255}));
  connect(onAndHea.y, ctlValHwByp.uEna) annotation (Line(points={{-12,220},{-42,
          220},{-42,-138},{-24,-138},{-24,-132}}, color={255,0,255}));
  connect(onAndCoo.y, ctlValChwByp.uEna) annotation (Line(points={{-12,180},{
          -36,180},{-36,22},{-24,22},{-24,28}},
                                  color={255,0,255}));
  connect(valChwIso.y_actual, staValChwIso.u) annotation (Line(points={{-95,-33},
          {-95,-32},{-90,-32},{-90,0},{-82,0}}, color={0,0,127}));
  connect(staValChwIso.y, ctlPumChwPri.uEna) annotation (Line(points={{-58,0},{
          -46,0},{-46,-18},{-24,-18},{-24,-12}}, color={255,0,255}));
  connect(valHwIso.y_actual, staValHwIso.u) annotation (Line(points={{-95,-193},
          {-95,-192},{-88,-192},{-88,-180},{-82,-180}}, color={0,0,127}));
  connect(staValHwIso.y, ctlPumHwPri.uEna) annotation (Line(points={{-58,-180},
          {-24,-180},{-24,-172}}, color={255,0,255}));
  connect(valHwReq.y, reqHea.u)
    annotation (Line(points={{138,220},{132,220}}, color={255,0,255}));
  connect(valChwReq.y, reqCoo.u)
    annotation (Line(points={{138,180},{134,180}}, color={255,0,255}));
  connect(reqHea.y, enaHea.nReqPla)
    annotation (Line(points={{108,220},{92,220}}, color={255,127,0}));
  connect(reqCoo.y, enaCoo.nReqPla)
    annotation (Line(points={{110,180},{92,180}}, color={255,127,0}));
  connect(con.y, enaHea.TOut) annotation (Line(points={{-198,140},{100,140},{
          100,216},{92,216}}, color={0,0,127}));
  connect(con.y, enaCoo.TOut) annotation (Line(points={{-198,140},{100,140},{
          100,176},{92,176}}, color={0,0,127}));
  connect(enaHea.y1, on.u1) annotation (Line(points={{68,220},{60,220},{60,200},
          {52,200}}, color={255,0,255}));
  connect(enaCoo.y1, on.u2) annotation (Line(points={{68,180},{60,180},{60,192},
          {52,192}}, color={255,0,255}));
  connect(enaHea.y1, onAndHea.u1)
    annotation (Line(points={{68,220},{12,220}}, color={255,0,255}));
  connect(on.y, onAndHea.u2) annotation (Line(points={{28,200},{20,200},{20,212},
          {12,212}}, color={255,0,255}));
  connect(enaCoo.y1, onAndCoo.u1)
    annotation (Line(points={{68,180},{12,180}}, color={255,0,255}));
  connect(on.y, onAndCoo.u2) annotation (Line(points={{28,200},{20,200},{20,172},
          {12,172}}, color={255,0,255}));
  connect(onAndHea.y, intModHea.u)
    annotation (Line(points={{-12,220},{-48,220}}, color={255,0,255}));
  connect(onAndCoo.y, intModCoo.u)
    annotation (Line(points={{-12,180},{-48,180}}, color={255,0,255}));
  connect(intModHea.y, mode.u1) annotation (Line(points={{-72,220},{-80,220},{
          -80,226},{-88,226}}, color={255,127,0}));
  connect(intModCoo.y, mode.u2) annotation (Line(points={{-72,180},{-80,180},{
          -80,214},{-88,214}}, color={255,127,0}));
  connect(mode.y, hp.mode) annotation (Line(points={{-112,220},{-186,220},{-186,
          -78},{-152,-78}}, color={255,127,0}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/ModularReversible/Examples/TableData2DLoadDepSHCDetailed.mos"
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
July 1, 2025, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(
      coordinateSystem(
        extent={{-240,-260},{240,260}}, grid={2,2})));
end TableData2DLoadDepSHCDetailed;
