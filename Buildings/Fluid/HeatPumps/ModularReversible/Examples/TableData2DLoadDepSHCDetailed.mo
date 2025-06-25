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
      origin={-250,-30})));
  Fluid.HeatExchangers.SensibleCooler_T loaHw(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mHw_flow_nominal,
    show_T=true,
    final dp_nominal=0,
    final energyDynamics=energyDynamics,
    tau=300,
    QMin_flow=-QHea_flow_nominal)
    "HW system approximated by prescribed return temperature"
    annotation (Placement(transformation(extent={{110,-250},{130,-230}})));
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
    annotation (Placement(transformation(extent={{150,-250},{170,-230}})));
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
        origin={100,-260})));
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
    annotation (Placement(transformation(extent={{-260,170},{-240,190}})));
  Buildings.Controls.OBC.CDL.Reals.PID ctlEquZon[2](
    each k=0.1,
    each Ti=60,
    each final reverseActing=true) "Zone equipment controller"
    annotation (Placement(transformation(extent={{90,100},{110,120}})));
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
      origin={200,-260})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter TChwRetPre(p=TChwRet_nominal -
        TChwSup_nominal) "Prescribed CHW return temperature"
    annotation (Placement(transformation(extent={{-210,150},{-190,170}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter THwRetPre(p=THwRet_nominal -
        THwSup_nominal) "Prescribed HW return temperature"
    annotation (Placement(transformation(extent={{-210,110},{-190,130}})));
  Buildings.Controls.OBC.CDL.Reals.Max max2
    "Limit prescribed HWRT"
    annotation (Placement(transformation(extent={{-170,110},{-150,130}})));
  Buildings.Controls.OBC.CDL.Reals.Min min1
    "Limit prescribed CHWRT"
    annotation (Placement(transformation(extent={{-170,150},{-150,170}})));
  Buildings.Fluid.FixedResistances.PressureDrop pipHw(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mHw_flow_nominal,
    final dp_nominal=dpHwLocSet_max - dpHwRemSet_max)
    "Piping"
    annotation (Placement(transformation(extent={{80,-290},{60,-270}})));
  Buildings.Fluid.FixedResistances.PressureDrop pipChw(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mChw_flow_nominal,
    final dp_nominal=dpChwLocSet_max - dpChwRemSet_max)
    "Piping"
    annotation (Placement(transformation(extent={{80,-90},{60,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(
    k=293.15) "Constant limiting prescribed return temperature"
    annotation (Placement(transformation(extent={{-260,130},{-240,150}})));
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
    annotation (Placement(transformation(extent={{-190,-84},{-170,-64}})));
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
    annotation (Placement(transformation(extent={{-260,-170},{-240,-150}})));
  Sensors.TemperatureTwoPort TChwSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=hp.mEva_flow_nominal,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    T_start=TChwSup_nominal) "CHW supply temperature"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Sensors.TemperatureTwoPort THwSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=hp.mCon_flow_nominal,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    T_start=THwSup_nominal) "HW supply temperature"
    annotation (Placement(transformation(extent={{-100,-250},{-80,-230}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSupSet[2](k={
        THwSup_nominal,TChwSup_nominal}) "Supply temperature setpoints"
    annotation (Placement(transformation(extent={{-260,0},{-240,20}})));
  Sources.Boundary_pT pChwRet(
    redeclare final package Medium = Medium,
    p=Buildings.Templates.Data.Defaults.pChiWat_rel_nominal + 101325,
    nPorts=1) "Pressure boundary conditions at HP inlet" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-180,-120})));
  Sources.Boundary_pT pHwRet(
    redeclare final package Medium = Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=1) "Pressure boundary condition at HP inlet" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-180,-160})));
  Actuators.Valves.TwoWayTable  valHwIso(
    redeclare final package Medium = Medium,
    final m_flow_nominal=hp.mCon_flow_nominal,
    flowCharacteristics=hp.chaValHwIso,
    dpValve_nominal=hp.dpValIso_nominal,
    init=Modelica.Blocks.Types.Init.InitialState,
    dpFixed_nominal=hp.dpHw_nominal)
    "HW isolation valve"
    annotation (Placement(transformation(extent={{-150,-250},{-130,-230}})));
  Actuators.Valves.TwoWayTable  valChwIso(
    redeclare final package Medium = Medium,
    final m_flow_nominal=hp.mEva_flow_nominal,
    dpValve_nominal=hp.dpValIso_nominal,
    init=Modelica.Blocks.Types.Init.InitialState,
    dpFixed_nominal=hp.dpChw_nominal,
    flowCharacteristics=hp.chaValChwIso) "CHW isolation valve"
    annotation (Placement(transformation(extent={{-150,-50},{-130,-30}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum sumNumUni(nin=3)
    "Total number of enabled modules"
    annotation (Placement(transformation(extent={{-260,-210},{-240,-190}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(message="Number of enabled modules exceeds number of modules")
    "Assert condition on number of enabled modules"
             annotation (Placement(transformation(extent={{-232,-250},{-212,-230}})));
  Buildings.Controls.OBC.CDL.Integers.LessEqualThreshold intLesEquThr(t=hp.nUni)
    "True if number of enabled modules lower or equal to number of modules"
    annotation (Placement(transformation(extent={{-232,-210},{-212,-190}})));
  Sensors.RelativePressure dpChwHea(redeclare final package Medium = Medium)
    "Module CHW header differential pressure" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-100,-60})));
  Sensors.RelativePressure dpHwHea(redeclare final package Medium = Medium)
    "Mpdule HW header differential pressure" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-100,-260})));
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
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpHeaSet[2](k={hp.dpHw_nominal,
        hp.dpChw_nominal}) "Module header dp setpoint"
    annotation (Placement(transformation(extent={{-260,40},{-240,60}})));
  Templates.Plants.Controls.Utilities.PIDWithEnable ctlValChwByp(
    k=1,
    Ti=60,
    r=hp.dpChw_nominal,
    y_reset=1,
    y_neutral=1)
    "CHW minimum flow bypass valve controller"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpRemSet[2](k={
        dpHwRemSet_max,dpChwRemSet_max}) "Remote dp setpoint"
    annotation (Placement(transformation(extent={{-260,80},{-240,100}})));
  Sensors.TemperatureTwoPort THwRetPla(redeclare final package Medium = Medium,
      final m_flow_nominal=hp.mCon_flow_nominal) "Plant HW return temperature"
    annotation (Placement(transformation(extent={{-110,-290},{-130,-270}})));
  Sensors.TemperatureTwoPort TChwRetPla(redeclare final package Medium = Medium,
      final m_flow_nominal=hp.mEva_flow_nominal) "Plant CHW return temperature"
    annotation (Placement(transformation(extent={{-110,-90},{-130,-70}})));
  Actuators.Valves.TwoWayLinear valHwByp(
    redeclare final package Medium = Medium,
    final m_flow_nominal=hp.mCon_flow_nominal/hp.nUni,
    from_dp=true,
    dpValve_nominal=hp.dpHw_nominal,
    init=Modelica.Blocks.Types.Init.InitialState)
    "HW minimum flow bypass valve" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={40,-260})));
  Templates.Plants.Controls.Utilities.PIDWithEnable ctlValHwByp(
    k=1,
    Ti=60,
    r=hp.dpHw_nominal,
    y_reset=1,
    y_neutral=1)
    "HW minimum flow bypass valve controller"
    annotation (Placement(transformation(extent={{-60,-210},{-40,-190}})));
  Sensors.TemperatureTwoPort TChwRet(redeclare final package Medium = Medium,
      final m_flow_nominal=hp.mEva_flow_nominal) "CHW return temperature"
    annotation (Placement(transformation(extent={{170,-90},{150,-70}})));
  Sensors.TemperatureTwoPort THwRet(redeclare final package Medium = Medium,
      final m_flow_nominal=hp.mCon_flow_nominal) "HW return temperature"
    annotation (Placement(transformation(extent={{170,-290},{150,-270}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold valChwReq(t=1E-1, h=5E-2)
    "CHW plant request from terminal valve"
    annotation (Placement(transformation(extent={{120,170},{100,190}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold valHwReq(t=1E-1, h=5E-2)
    "HW plant request from terminal valve"
    annotation (Placement(transformation(extent={{120,210},{100,230}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger reqHea
    "Heating plant request"
    annotation (Placement(transformation(extent={{90,210},{70,230}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger reqCoo
    "Cooling plant request"
    annotation (Placement(transformation(extent={{92,170},{72,190}})));
  Buildings.Controls.OBC.CDL.Logical.Or on "HP commanded on"
    annotation (Placement(transformation(extent={{10,190},{-10,210}})));
  Buildings.Controls.OBC.CDL.Logical.And onAndHea
    "HP commanded on and heating enabled"
    annotation (Placement(transformation(extent={{-30,210},{-50,230}})));
  Buildings.Controls.OBC.CDL.Logical.And onAndCoo
    "HP commanded on and cooling enabled"
    annotation (Placement(transformation(extent={{-30,170},{-50,190}})));
  Templates.Plants.Controls.Enabling.Enable enaHea(typ=Buildings.Templates.Plants.Controls.Types.Application.Heating,
      TOutLck=295.15) "Enable heating"
    annotation (Placement(transformation(extent={{50,210},{30,230}})));
  Templates.Plants.Controls.Enabling.Enable enaCoo(typ=Buildings.Templates.Plants.Controls.Types.Application.Cooling,
      TOutLck=290.15) "Enable cooling"
    annotation (Placement(transformation(extent={{50,170},{30,190}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger intModCoo(integerTrue
      =2) "Cast to integer for operating mode command"
    annotation (Placement(transformation(extent={{-90,170},{-110,190}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger intModHea(integerTrue
      =1) "Cast to integer for operating mode command"
    annotation (Placement(transformation(extent={{-90,210},{-110,230}})));
  Buildings.Controls.OBC.CDL.Integers.Add mode "Operating mode"
    annotation (Placement(transformation(extent={{-130,210},{-150,230}})));
  Templates.Components.Routing.SingleToMultiple inlPumChwPri(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final nPorts=pumChwPri.nPum,
    final m_flow_nominal=hp.mEva_flow_nominal)
    "Primary CHW pumps suction header"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Templates.Components.Pumps.Multiple pumChwPri(
    redeclare final package Medium=Medium,
    final energyDynamics=energyDynamics,
    dat(
      m_flow_nominal=fill(hp.mEva_flow_nominal / pumChwPri.nPum, pumChwPri.nPum),
      dp_nominal=fill(dpChwLocSet_max + hp.dpChw_nominal, pumChwPri.nPum),
      rho_default=Medium.d_const),
    final nPum=hp.nUni) "Primary CHW pumps"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Templates.Components.Routing.MultipleToSingle outPumChwPri(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final nPorts=pumChwPri.nPum,
    final m_flow_nominal=hp.mEva_flow_nominal)
    "Primary CHW pumps discharge header"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Templates.Plants.Controls.Pumps.Generic.ControlDifferentialPressure
    ctlPumChwPri(
    have_senDpRemWir=true,
    nPum=pumChwPri.nPum,
    nSenDpRem=1,
    k=0.1) "Primary CHW pump control"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Templates.Components.Interfaces.Bus busPumChwPri
    "Primary CHW pump control bus" annotation (Placement(transformation(extent={
            {-70,36},{-30,76}}), iconTransformation(extent={{-230,-40},{-190,0}})));
  Sensors.VolumeFlowRate VChwPri(redeclare final package Medium = Medium,
      final m_flow_nominal=hp.mEva_flow_nominal)
    "Primary CHW flow (plant side)"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Templates.Plants.Controls.Pumps.Generic.StagingHeadered staPumChwPri(
    is_pri=true,
    is_hdr=true,
    is_ctlDp=true,
    have_valInlIso=false,
    have_valOutIso=true,
    nEqu=hp.nUni,
    nPum=pumChwPri.nPum,
    nSenDp=1,
    V_flow_nominal=hp.mEva_flow_nominal/Medium.d_const,
    dtRun=5*60) "Primary CHW pump staging"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Templates.Components.Routing.SingleToMultiple inlPumHwPri(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final nPorts=pumHwPri.nPum,
    final m_flow_nominal=hp.mCon_flow_nominal)
    "Primary HW pumps suction header"
    annotation (Placement(transformation(extent={{-40,-250},{-20,-230}})));
  Templates.Components.Pumps.Multiple pumHwPri(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    dat(
      m_flow_nominal=fill(hp.mCon_flow_nominal/pumHwPri.nPum, pumHwPri.nPum),
      dp_nominal=fill(dpHwLocSet_max + hp.dpHw_nominal, pumHwPri.nPum),
      rho_default=Medium.d_const),
    final nPum=hp.nUni) "Primary HW pumps"
    annotation (Placement(transformation(extent={{-20,-250},{0,-230}})));
  Templates.Components.Routing.MultipleToSingle outPumHwPri(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final nPorts=pumHwPri.nPum,
    final m_flow_nominal=hp.mCon_flow_nominal)
    "Primary HW pumps discharge header"
    annotation (Placement(transformation(extent={{0,-250},{20,-230}})));
  Sensors.VolumeFlowRate VChwPri1(redeclare final package Medium = Medium,
      final m_flow_nominal=hp.mEva_flow_nominal)
    "Primary CHW flow (plant side)"
    annotation (Placement(transformation(extent={{-60,-250},{-40,-230}})));
  Templates.Plants.Controls.Pumps.Generic.ControlDifferentialPressure ctlPumHwPri(
    have_senDpRemWir=true,
    nPum=pumHwPri.nPum,
    nSenDpRem=1,
    k=0.1) "Primary HW pump control"
    annotation (Placement(transformation(extent={{-60,-180},{-40,-160}})));
  Templates.Plants.Controls.Pumps.Generic.StagingHeadered staPumHwPri(
    is_pri=true,
    is_hdr=true,
    is_ctlDp=true,
    have_valInlIso=false,
    have_valOutIso=true,
    nEqu=hp.nUni,
    nPum=pumHwPri.nPum,
    nSenDp=1,
    V_flow_nominal=hp.mCon_flow_nominal/Medium.d_const,
    dtRun=5*60) "Primary HW pump staging"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));
  Templates.Components.Interfaces.Bus busPumHwPri "Primary HW pump control bus"
    annotation (Placement(transformation(extent={{-70,-164},{-30,-124}}),
        iconTransformation(extent={{-230,-40},{-190,0}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyPumHwPri(nin=pumHwPri.nPum)
    "True if any primary HW pump is proven on"
    annotation (Placement(transformation(extent={{-26,-124},{-6,-104}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyPumChwPri(nin=pumChwPri.nPum)
    "True if any primary CHW pump is proven on"
    annotation (Placement(transformation(extent={{-26,76},{-6,96}})));
equation
  connect(loaChw.port_b, valDisChw.port_a)
    annotation (Line(points={{130,-40},{150,-40}},
                                                 color={0,127,255}));
  connect(loaHw.port_b, valDisHw.port_a)
    annotation (Line(points={{130,-240},{150,-240}},
                                                   color={0,127,255}));
  connect(valDisChw.port_b, mChw_flow.port_a)
    annotation (Line(points={{170,-40},{200,-40},{200,-50}},color={0,127,255}));
  connect(valDisHw.port_b, mHw_flow.port_a)
    annotation (Line(points={{170,-240},{200,-240},{200,-250}},color={0,127,255}));
  connect(mHw_flow.m_flow, norFlo[1].u)
    annotation (Line(points={{211,-260},{220,-260},{220,-12}},color={0,0,127}));
  connect(mChw_flow.m_flow, norFlo[2].u)
    annotation (Line(points={{211,-60},{220,-60},{220,-12}},color={0,0,127}));
  connect(norFlo.y, ctlEquZon.u_m)
    annotation (Line(points={{220,12},{220,40},{100,40},{100,98}},
                                                                color={0,0,127}));
  connect(ctlEquZon[2].y, valDisChw.y)
    annotation (Line(points={{112,110},{160,110},{160,-28}},
      color={0,0,127}));
  connect(ctlEquZon[1].y, valDisHw.y)
    annotation (Line(points={{112,110},{140,110},{140,-220},{160,-220},{160,-228}},
      color={0,0,127}));
  connect(TChwRetPre.y, min1.u1) annotation (Line(points={{-188,160},{-180,160},
          {-180,166},{-172,166}}, color={0,0,127}));
  connect(min1.y, loaChw.TSet)
    annotation (Line(points={{-148,160},{24,160},{24,-32},{108,-32}},
                                                                 color={0,0,127}));
  connect(max2.y, loaHw.TSet)
    annotation (Line(points={{-148,120},{22,120},{22,-232},{108,-232}},
                                                                   color={0,0,127}));
  connect(con.y, min1.u2)
    annotation (Line(points={{-238,140},{-180,140},{-180,154},{-172,154}},
                                                                     color={0,0,127}));
  connect(con.y, max2.u1)
    annotation (Line(points={{-238,140},{-180,140},{-180,126},{-172,126}},
                                                                     color={0,0,127}));
  connect(THwRetPre.y, max2.u2) annotation (Line(points={{-188,120},{-180,120},{
          -180,114},{-172,114}},
                         color={0,0,127}));
  connect(weaDat.weaBus, hp.weaBus) annotation (Line(
      points={{-240,-30},{-180,-30},{-180,-64}},
      color={255,204,51},
      thickness=0.5));
  connect(ratFlo.y, ctlEquZon.u_s)
    annotation (Line(points={{-238,180},{-140,180},{-140,110},{88,110}},
                                                   color={0,0,127}));
  connect(TSupSet[1].y, hp.THwSet) annotation (Line(points={{-238,10},{-220,10},
          {-220,-70},{-192,-70}},color={0,0,127}));
  connect(TSupSet[2].y, hp.TChwSet) annotation (Line(points={{-238,10},{-220,10},
          {-220,-74},{-192,-74}},color={0,0,127}));
  connect(dpChwRem.port_a, loaChw.port_a)
    annotation (Line(points={{100,-50},{100,-40},{110,-40}},
                                                          color={0,127,255}));
  connect(dpChwRem.port_b, pipChw.port_a)
    annotation (Line(points={{100,-70},{100,-80},{80,-80}},color={0,127,255}));
  connect(dpHwRem.port_b, pipHw.port_a) annotation (Line(points={{100,-270},{100,
          -280},{80,-280}},
                     color={0,127,255}));
  connect(dpHwRem.port_a, loaHw.port_a) annotation (Line(points={{100,-250},{100,
          -240},{110,-240}},
                      color={0,127,255}));
  connect(pHwRet.ports[1], hp.port_a1) annotation (Line(points={{-190,-160},{-200,
          -160},{-200,-68},{-190,-68}},color={0,127,255}));
  connect(hp.port_b1, valHwIso.port_a) annotation (Line(points={{-170,-68},{-160,
          -68},{-160,-240},{-150,-240}},
                                       color={0,127,255}));
  connect(valHwIso.port_b, THwSup.port_a)
    annotation (Line(points={{-130,-240},{-100,-240}},
                                                     color={0,127,255}));
  connect(hp.yValHwIso, valHwIso.y) annotation (Line(points={{-172,-63},{-172,-60},
          {-140,-60},{-140,-228}},    color={0,0,127}));
  connect(valChwIso.port_b, TChwSup.port_a)
    annotation (Line(points={{-130,-40},{-80,-40}},color={0,127,255}));
  connect(hp.port_b2, valChwIso.port_a) annotation (Line(points={{-190,-80},{-210,
          -80},{-210,-40},{-150,-40}},     color={0,127,255}));
  connect(hp.yValChwIso, valChwIso.y) annotation (Line(points={{-188,-85},{-188,
          -88},{-154,-88},{-154,-22},{-140,-22},{-140,-28}},
                                                           color={0,0,127}));
  connect(sumNumUni.y,intLesEquThr. u)
    annotation (Line(points={{-238,-200},{-234,-200}},
                                             color={255,127,0}));
  connect(intLesEquThr.y,assMes. u)
    annotation (Line(points={{-210,-200},{-206,-200},{-206,-220},{-240,-220},{-240,
          -240},{-234,-240}},                color={255,0,255}));
  connect(hp.nUniShc, sumNumUni.u[1]) annotation (Line(points={{-183,-86},{-183,
          -90},{-270,-90},{-270,-202.333},{-262,-202.333}},   color={255,127,0}));
  connect(hp.nUniCoo, sumNumUni.u[2]) annotation (Line(points={{-180,-86},{-180,
          -90},{-270,-90},{-270,-200},{-262,-200}},   color={255,127,0}));
  connect(hp.nUniHea, sumNumUni.u[3]) annotation (Line(points={{-177,-86},{-177,
          -90},{-270,-90},{-270,-197.667},{-262,-197.667}},   color={255,127,0}));
  connect(dpHeaSet[2].y, ctlValChwByp.u_s)
    annotation (Line(points={{-238,50},{-80,50},{-80,0},{-62,0}},
                                                  color={0,0,127}));
  connect(ctlValChwByp.y, valChwByp.y) annotation (Line(points={{-38,0},{-30,0},
          {-30,-60},{28,-60}},color={0,0,127}));
  connect(dpChwHea.p_rel, ctlValChwByp.u_m) annotation (Line(points={{-91,-60},{
          -84,-60},{-84,-16},{-50,-16},{-50,-12}},
                                                color={0,0,127}));
  connect(pChwRet.ports[1], hp.port_a2)
    annotation (Line(points={{-170,-120},{-170,-80}}, color={0,127,255}));
  connect(pipHw.port_b, THwRetPla.port_a)
    annotation (Line(points={{60,-280},{-110,-280}},color={0,127,255}));
  connect(THwRetPla.port_b, hp.port_a1) annotation (Line(points={{-130,-280},{-200,
          -280},{-200,-68},{-190,-68}},      color={0,127,255}));
  connect(pipChw.port_b, TChwRetPla.port_a)
    annotation (Line(points={{60,-80},{-110,-80}},color={0,127,255}));
  connect(TChwRetPla.port_b, hp.port_a2)
    annotation (Line(points={{-130,-80},{-170,-80}},color={0,127,255}));
  connect(dpHwHea.p_rel, ctlValHwByp.u_m) annotation (Line(points={{-91,-260},{-74,
          -260},{-74,-220},{-50,-220},{-50,-212}},     color={0,0,127}));
  connect(ctlValHwByp.y, valHwByp.y) annotation (Line(points={{-38,-200},{-30,-200},
          {-30,-260},{28,-260}},      color={0,0,127}));
  connect(dpHeaSet[1].y, ctlValHwByp.u_s) annotation (Line(points={{-238,50},{-80,
          50},{-80,-200},{-62,-200}},     color={0,0,127}));
  connect(valHwByp.port_b, THwRetPla.port_a) annotation (Line(points={{40,-270},
          {40,-280},{-110,-280}},color={0,127,255}));
  connect(valChwByp.port_b, TChwRetPla.port_a)
    annotation (Line(points={{40,-70},{40,-80},{-110,-80}},color={0,127,255}));
  connect(dpChwHea.port_a, TChwRetPla.port_a) annotation (Line(points={{-100,-70},
          {-100,-80},{-110,-80}},
                                color={0,127,255}));
  connect(valChwIso.port_b, dpChwHea.port_b) annotation (Line(points={{-130,-40},
          {-100,-40},{-100,-50}},
                                color={0,127,255}));
  connect(dpHwHea.port_a, THwRetPla.port_a) annotation (Line(points={{-100,-270},
          {-100,-280},{-110,-280}},
                                  color={0,127,255}));
  connect(valHwIso.port_b, dpHwHea.port_b) annotation (Line(points={{-130,-240},
          {-100,-240},{-100,-250}},
                                  color={0,127,255}));
  connect(mChw_flow.port_b, TChwRet.port_a) annotation (Line(points={{200,-70},{
          200,-80},{170,-80}},  color={0,127,255}));
  connect(TChwRet.port_b, pipChw.port_a)
    annotation (Line(points={{150,-80},{80,-80}}, color={0,127,255}));
  connect(mHw_flow.port_b, THwRet.port_a) annotation (Line(points={{200,-270},{200,
          -280},{170,-280}},     color={0,127,255}));
  connect(THwRet.port_b, pipHw.port_a)
    annotation (Line(points={{150,-280},{80,-280}}, color={0,127,255}));
  connect(TChwSup.T, TChwRetPre.u) annotation (Line(points={{-70,-29},{-70,-20},
          {-218,-20},{-218,160},{-212,160}}, color={0,0,127}));
  connect(THwSup.T, THwRetPre.u) annotation (Line(points={{-90,-229},{-90,-180},
          {-216,-180},{-216,120},{-212,120}},          color={0,0,127}));
  connect(valDisChw.y_actual, valChwReq.u) annotation (Line(points={{165,-33},{170,
          -33},{170,180},{122,180}}, color={0,0,127}));
  connect(valDisHw.y_actual, valHwReq.u) annotation (Line(points={{165,-233},{176,
          -233},{176,220},{122,220}}, color={0,0,127}));
  connect(on.y, hp.on) annotation (Line(points={{-12,200},{-224,200},{-224,-76},
          {-192,-76}}, color={255,0,255}));
  connect(valHwReq.y, reqHea.u)
    annotation (Line(points={{98,220},{92,220}},   color={255,0,255}));
  connect(valChwReq.y, reqCoo.u)
    annotation (Line(points={{98,180},{94,180}},   color={255,0,255}));
  connect(reqHea.y, enaHea.nReqPla)
    annotation (Line(points={{68,220},{52,220}},  color={255,127,0}));
  connect(reqCoo.y, enaCoo.nReqPla)
    annotation (Line(points={{70,180},{52,180}},  color={255,127,0}));
  connect(con.y, enaHea.TOut) annotation (Line(points={{-238,140},{60,140},{60,216},
          {52,216}},          color={0,0,127}));
  connect(con.y, enaCoo.TOut) annotation (Line(points={{-238,140},{60,140},{60,176},
          {52,176}},          color={0,0,127}));
  connect(enaHea.y1, on.u1) annotation (Line(points={{28,220},{20,220},{20,200},
          {12,200}}, color={255,0,255}));
  connect(enaCoo.y1, on.u2) annotation (Line(points={{28,180},{20,180},{20,192},
          {12,192}}, color={255,0,255}));
  connect(enaHea.y1, onAndHea.u1)
    annotation (Line(points={{28,220},{-28,220}},color={255,0,255}));
  connect(on.y, onAndHea.u2) annotation (Line(points={{-12,200},{-20,200},{-20,212},
          {-28,212}},color={255,0,255}));
  connect(enaCoo.y1, onAndCoo.u1)
    annotation (Line(points={{28,180},{-28,180}},color={255,0,255}));
  connect(on.y, onAndCoo.u2) annotation (Line(points={{-12,200},{-20,200},{-20,172},
          {-28,172}},color={255,0,255}));
  connect(onAndHea.y, intModHea.u)
    annotation (Line(points={{-52,220},{-88,220}}, color={255,0,255}));
  connect(onAndCoo.y, intModCoo.u)
    annotation (Line(points={{-52,180},{-88,180}}, color={255,0,255}));
  connect(intModHea.y, mode.u1) annotation (Line(points={{-112,220},{-120,220},{
          -120,226},{-128,226}},
                               color={255,127,0}));
  connect(intModCoo.y, mode.u2) annotation (Line(points={{-112,180},{-120,180},{
          -120,214},{-128,214}},
                               color={255,127,0}));
  connect(mode.y, hp.mode) annotation (Line(points={{-152,220},{-226,220},{-226,
          -78},{-192,-78}}, color={255,127,0}));

  connect(inlPumChwPri.ports_b, pumChwPri.ports_a)
    annotation (Line(points={{-20,-40},{-20,-40}}, color={0,127,255}));
  connect(pumChwPri.ports_b, outPumChwPri.ports_a)
    annotation (Line(points={{0,-40},{0,-40}}, color={0,127,255}));
  connect(outPumChwPri.port_b, loaChw.port_a)
    annotation (Line(points={{20,-40},{110,-40}}, color={0,127,255}));
  connect(outPumChwPri.port_b, valChwByp.port_a)
    annotation (Line(points={{20,-40},{40,-40},{40,-50}}, color={0,127,255}));
  connect(ctlPumChwPri.y, busPumChwPri.y) annotation (Line(points={{-38,30},{-32,
          30},{-32,52},{-42,52},{-42,56},{-50,56}}, color={0,0,127}));
  connect(busPumChwPri, pumChwPri.bus) annotation (Line(
      points={{-50,56},{-10,56},{-10,-30}},
      color={255,204,51},
      thickness=0.5));
  connect(busPumChwPri.y1_actual, ctlPumChwPri.y1_actual) annotation (Line(
      points={{-50,56},{-72,56},{-72,38},{-62,38}},
      color={255,204,51},
      thickness=0.5));
  connect(TChwSup.port_b, VChwPri.port_a)
    annotation (Line(points={{-60,-40},{-60,-40}}, color={0,127,255}));
  connect(VChwPri.port_b, inlPumChwPri.port_a)
    annotation (Line(points={{-40,-40},{-40,-40}}, color={0,127,255}));
  connect(dpRemSet[2].y, ctlPumChwPri.dpRemSet[1]) annotation (Line(points={{-238,
          90},{-78,90},{-78,34},{-62,34}}, color={0,0,127}));
  connect(dpChwRem.p_rel, ctlPumChwPri.dpRem[1]) annotation (Line(points={{91,-60},
          {80,-60},{80,48},{-66,48},{-66,30},{-62,30}}, color={0,0,127}));
  connect(staPumChwPri.y1, busPumChwPri.y1) annotation (Line(points={{-38,80},{-32,
          80},{-32,60},{-50,60},{-50,56}}, color={255,0,255}));
  connect(hp.y1ValChwIso, staPumChwPri.u1ValOutIso) annotation (Line(points={{-186,
          -85},{-186,-86},{-156,-86},{-156,84},{-62,84}},
                                    color={255,0,255}));
  connect(VChwPri.V_flow, staPumChwPri.V_flow) annotation (Line(points={{-50,-29},
          {-50,-18},{-86,-18},{-86,78},{-62,78}}, color={0,0,127}));
  connect(dpRemSet[2].y, staPumChwPri.dpSet[1]) annotation (Line(points={{-238,90},
          {-78,90},{-78,76},{-62,76}}, color={0,0,127}));
  connect(busPumChwPri.y1_actual, staPumChwPri.u1Pum_actual) annotation (Line(
      points={{-50,56},{-72,56},{-72,80},{-62,80}},
      color={255,204,51},
      thickness=0.5));
  connect(busPumChwPri.y, staPumChwPri.y) annotation (Line(
      points={{-50,56},{-50,56.2162},{-72,56.2162},{-72,72},{-62,72}},
      color={255,204,51},
      thickness=0.5));
  connect(dpChwRem.p_rel, staPumChwPri.dp[1]) annotation (Line(points={{91,-60},
          {80,-60},{80,48},{-66,48},{-66,74},{-62,74}},                   color
        ={0,0,127}));
  connect(inlPumHwPri.ports_b, pumHwPri.ports_a)
    annotation (Line(points={{-20,-240},{-20,-240}}, color={0,127,255}));
  connect(pumHwPri.ports_b, outPumHwPri.ports_a)
    annotation (Line(points={{0,-240},{0,-240}}, color={0,127,255}));
  connect(inlPumHwPri.port_a, VChwPri1.port_b)
    annotation (Line(points={{-40,-240},{-40,-240}}, color={0,127,255}));
  connect(THwSup.port_b, VChwPri1.port_a)
    annotation (Line(points={{-80,-240},{-60,-240}}, color={0,127,255}));
  connect(ctlPumHwPri.y, busPumHwPri.y) annotation (Line(points={{-38,-170},{-32,
          -170},{-32,-148},{-42,-148},{-42,-144},{-50,-144}}, color={0,0,127}));
  connect(staPumHwPri.y1, busPumHwPri.y1) annotation (Line(points={{-38,-120},{-32,
          -120},{-32,-140},{-50,-140},{-50,-144}}, color={255,0,255}));
  connect(busPumHwPri, pumHwPri.bus) annotation (Line(
      points={{-50,-144},{-10,-144},{-10,-230}},
      color={255,204,51},
      thickness=0.5));
  connect(busPumHwPri.y1_actual, ctlPumHwPri.y1_actual) annotation (Line(
      points={{-50,-144},{-70,-144},{-70,-162},{-62,-162}},
      color={255,204,51},
      thickness=0.5));
  connect(busPumHwPri.y, staPumHwPri.y) annotation (Line(
      points={{-50,-144},{-70,-144},{-70,-130},{-62,-130},{-62,-128}},
      color={255,204,51},
      thickness=0.5));
  connect(busPumHwPri.y1_actual, staPumHwPri.u1Pum_actual) annotation (Line(
      points={{-50,-144},{-70,-144},{-70,-120},{-62,-120}},
      color={255,204,51},
      thickness=0.5));
  connect(hp.y1ValHwIso, staPumHwPri.u1ValOutIso) annotation (Line(points={{-174,
          -63},{-174,-58},{-138,-58},{-138,-116},{-62,-116}}, color={255,0,255}));
  connect(VChwPri1.V_flow, staPumHwPri.V_flow) annotation (Line(points={{-50,-229},
          {-50,-224},{-68,-224},{-68,-122},{-62,-122}}, color={0,0,127}));
  connect(outPumHwPri.port_b, loaHw.port_a)
    annotation (Line(points={{20,-240},{110,-240}}, color={0,127,255}));
  connect(outPumHwPri.port_b, valHwByp.port_a) annotation (Line(points={{20,-240},
          {40,-240},{40,-250}}, color={0,127,255}));
  connect(dpHwRem.p_rel, ctlPumHwPri.dpRem[1]) annotation (Line(points={{91,-260},
          {80,-260},{80,-154},{-66,-154},{-66,-170},{-62,-170}}, color={0,0,127}));
  connect(dpHwRem.p_rel, staPumHwPri.dp[1]) annotation (Line(points={{91,-260},{
          80,-260},{80,-154},{-66,-154},{-66,-126},{-62,-126}}, color={0,0,127}));
  connect(dpRemSet[1].y, staPumHwPri.dpSet[1]) annotation (Line(points={{-238,90},
          {-78,90},{-78,-124},{-62,-124}}, color={0,0,127}));
  connect(dpRemSet[1].y, ctlPumHwPri.dpRemSet[1]) annotation (Line(points={{-238,
          90},{-78,90},{-78,-166},{-62,-166}}, color={0,0,127}));
  connect(staPumHwPri.y1_actual, anyPumHwPri.u)
    annotation (Line(points={{-38,-114},{-28,-114}}, color={255,0,255}));
  connect(anyPumHwPri.y, ctlValHwByp.uEna) annotation (Line(points={{-4,-114},{0,
          -114},{0,-94},{-74,-94},{-74,-216},{-54,-216},{-54,-212}}, color={255,
          0,255}));
  connect(staPumChwPri.y1_actual, anyPumChwPri.u)
    annotation (Line(points={{-38,86},{-28,86}}, color={255,0,255}));
  connect(anyPumChwPri.y, ctlValChwByp.uEna) annotation (Line(points={{-4,86},{0,
          86},{0,106},{-76,106},{-76,-14},{-54,-14},{-54,-12}}, color={255,0,255}));
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
        extent={{-280,-300},{280,300}})));
end TableData2DLoadDepSHCDetailed;
