within Buildings.Fluid.HeatPumps.ModularReversible.Examples;
model TableData2DLoadDepSHC1Only
  "Validation of SHC HP model in primary-only plant"
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
      origin={-250,-10})));
  Fluid.HeatExchangers.SensibleCooler_T loaHw(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mHw_flow_nominal,
    show_T=true,
    final dp_nominal=0,
    final energyDynamics=energyDynamics,
    tau=300,
    QMin_flow=-QHea_flow_nominal)
    "HW system approximated by prescribed return temperature"
    annotation (Placement(transformation(extent={{110,-230},{130,-210}})));
  Fluid.HeatExchangers.Heater_T loaChw(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mChw_flow_nominal,
    show_T=true,
    final dp_nominal=0,
    final energyDynamics=energyDynamics,
    tau=300,
    QMax_flow=-QCoo_flow_nominal)
    "CHW system system approximated by prescribed return temperature"
    annotation (Placement(transformation(extent={{110,-30},{130,-10}})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage valDisHw(
    redeclare final package Medium=Medium,
    m_flow_nominal=mHw_flow_nominal,
    dpValve_nominal=3E4,
    y_start=0,
    dpFixed_nominal=dpHwRemSet_max - 3E4)
    "Distribution system approximated by variable flow resistance"
    annotation (Placement(transformation(extent={{150,-230},{170,-210}})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage valDisChw(
    redeclare final package Medium=Medium,
    m_flow_nominal=mChw_flow_nominal,
    dpValve_nominal=3E4,
    y_start=0,
    dpFixed_nominal=dpChwRemSet_max - 3E4)
    "Distribution system approximated by variable flow resistance"
    annotation (Placement(transformation(extent={{150,-30},{170,-10}})));
  Fluid.Sensors.RelativePressure dpHwRem(
    redeclare final package Medium = Medium)
    "HW differential pressure at one remote location"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={100,-240})));
  Fluid.Sensors.RelativePressure dpChwRem(
    redeclare final package Medium = Medium)
    "CHW differential pressure at one remote location"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={100,-40})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable ratFlo(table=[0,0,0; 5,0,0;
        7,1,0; 12,0.4,0.4; 16,0,1; 22,0.1,0.1; 24,0,0],
    timeScale=3600)
    "Source signal for flow rate ratio – Index 1 for HW, 2 for CHW"
    annotation (Placement(transformation(extent={{-260,190},{-240,210}})));
  Buildings.Controls.OBC.CDL.Reals.PID ctlEquZon[2](
    each k=0.1,
    each Ti=60,
    each final reverseActing=true) "Zone equipment controller"
    annotation (Placement(transformation(extent={{90,120},{110,140}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter norFlo[2](
    k={1/mHw_flow_nominal,
        1/mChw_flow_nominal}) "Normalize flow rate" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={220,20})));
  Fluid.Sensors.MassFlowRate mChw_flow(
    redeclare final package Medium=Medium)
    "CHW mass flow rate"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={200,-40})));
  Fluid.Sensors.MassFlowRate mHw_flow(
    redeclare final package Medium=Medium)
    "HW mass flow rate"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={200,-240})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter TChwRetPre(p=TChwRet_nominal -
        TChwSup_nominal) "Prescribed CHW return temperature"
    annotation (Placement(transformation(extent={{-210,170},{-190,190}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter THwRetPre(p=THwRet_nominal -
        THwSup_nominal) "Prescribed HW return temperature"
    annotation (Placement(transformation(extent={{-210,130},{-190,150}})));
  Buildings.Controls.OBC.CDL.Reals.Max max2
    "Limit prescribed HWRT"
    annotation (Placement(transformation(extent={{-170,130},{-150,150}})));
  Buildings.Controls.OBC.CDL.Reals.Min min1
    "Limit prescribed CHWRT"
    annotation (Placement(transformation(extent={{-170,170},{-150,190}})));
  Buildings.Fluid.FixedResistances.PressureDrop pipHw(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mHw_flow_nominal,
    final dp_nominal=dpHwLocSet_max - dpHwRemSet_max)
    "Piping"
    annotation (Placement(transformation(extent={{80,-270},{60,-250}})));
  Buildings.Fluid.FixedResistances.PressureDrop pipChw(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mChw_flow_nominal,
    final dp_nominal=dpChwLocSet_max - dpChwRemSet_max)
    "Piping"
    annotation (Placement(transformation(extent={{80,-70},{60,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(
    k=293.15) "Constant limiting prescribed return temperature"
    annotation (Placement(transformation(extent={{-260,150},{-240,170}})));
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
    annotation (Placement(transformation(extent={{-190,-64},{-170,-44}})));
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
    annotation (Placement(transformation(extent={{-260,-150},{-240,-130}})));
  Sensors.TemperatureTwoPort TChwSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=hp.mEva_flow_nominal,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    T_start=TChwSup_nominal) "CHW supply temperature"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Sensors.TemperatureTwoPort THwSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=hp.mCon_flow_nominal,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    T_start=THwSup_nominal) "HW supply temperature"
    annotation (Placement(transformation(extent={{-100,-230},{-80,-210}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSupSet[2](k={
        THwSup_nominal,TChwSup_nominal}) "Supply temperature setpoints"
    annotation (Placement(transformation(extent={{-260,20},{-240,40}})));
  Sources.Boundary_pT pChwRet(
    redeclare final package Medium = Medium,
    p=Buildings.Templates.Data.Defaults.pChiWat_rel_nominal + 101325,
    nPorts=1) "Pressure boundary conditions at HP inlet" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-180,-100})));
  Sources.Boundary_pT pHwRet(
    redeclare final package Medium = Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=1) "Pressure boundary condition at HP inlet" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-180,-140})));
  Actuators.Valves.TwoWayTable  valHwIso(
    redeclare final package Medium = Medium,
    final m_flow_nominal=hp.mCon_flow_nominal,
    flowCharacteristics=hp.chaValHwIso,
    dpValve_nominal=hp.dpValIso_nominal,
    init=Modelica.Blocks.Types.Init.InitialState,
    dpFixed_nominal=hp.dpHw_nominal)
    "HW isolation valve"
    annotation (Placement(transformation(extent={{-150,-230},{-130,-210}})));
  Actuators.Valves.TwoWayTable  valChwIso(
    redeclare final package Medium = Medium,
    final m_flow_nominal=hp.mEva_flow_nominal,
    dpValve_nominal=hp.dpValIso_nominal,
    init=Modelica.Blocks.Types.Init.InitialState,
    dpFixed_nominal=hp.dpChw_nominal,
    flowCharacteristics=hp.chaValChwIso) "CHW isolation valve"
    annotation (Placement(transformation(extent={{-150,-30},{-130,-10}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum sumNumUni(nin=3)
    "Total number of enabled modules"
    annotation (Placement(transformation(extent={{-260,-190},{-240,-170}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(message="Number of enabled modules exceeds number of modules")
    "Assert condition on number of enabled modules"
             annotation (Placement(transformation(extent={{-232,-230},{-212,
            -210}})));
  Buildings.Controls.OBC.CDL.Integers.LessEqualThreshold intLesEquThr(t=hp.nUni)
    "True if number of enabled modules lower or equal to number of modules"
    annotation (Placement(transformation(extent={{-232,-190},{-212,-170}})));
  Sensors.RelativePressure dpChwHea(redeclare final package Medium = Medium)
    "Module CHW header differential pressure" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-100,-40})));
  Sensors.RelativePressure dpHwHea(redeclare final package Medium = Medium)
    "Mpdule HW header differential pressure" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-100,-240})));
  Actuators.Valves.TwoWayLinear valChwByp(
    redeclare final package Medium = Medium,
    final m_flow_nominal=hp.mEva_flow_nominal/hp.nUni,
    from_dp=true,
    dpValve_nominal=hp.dpChw_nominal,
    init=Modelica.Blocks.Types.Init.InitialState)
    "CHW minimum flow bypass valve" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={40,-40})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpHeaSet[2](k={hp.dpHw_nominal,
        hp.dpChw_nominal}) "Module header dp setpoint"
    annotation (Placement(transformation(extent={{-260,60},{-240,80}})));
  Templates.Plants.Controls.Utilities.PIDWithEnable ctlValChwByp(
    k=1,
    Ti=60,
    r=hp.dpChw_nominal,
    y_reset=1,
    y_neutral=1)
    "CHW minimum flow bypass valve controller"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpRemSet[2](k={
        dpHwRemSet_max,dpChwRemSet_max}) "Remote dp setpoint"
    annotation (Placement(transformation(extent={{-260,100},{-240,120}})));
  Sensors.TemperatureTwoPort THwRetPla(redeclare final package Medium = Medium,
      final m_flow_nominal=hp.mCon_flow_nominal) "Plant HW return temperature"
    annotation (Placement(transformation(extent={{-110,-270},{-130,-250}})));
  Sensors.TemperatureTwoPort TChwRetPla(redeclare final package Medium = Medium,
      final m_flow_nominal=hp.mEva_flow_nominal) "Plant CHW return temperature"
    annotation (Placement(transformation(extent={{-110,-70},{-130,-50}})));
  Actuators.Valves.TwoWayLinear valHwByp(
    redeclare final package Medium = Medium,
    final m_flow_nominal=hp.mCon_flow_nominal/hp.nUni,
    from_dp=true,
    dpValve_nominal=hp.dpHw_nominal,
    init=Modelica.Blocks.Types.Init.InitialState)
    "HW minimum flow bypass valve" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={40,-240})));
  Templates.Plants.Controls.Utilities.PIDWithEnable ctlValHwByp(
    k=1,
    Ti=60,
    r=hp.dpHw_nominal,
    y_reset=1,
    y_neutral=1)
    "HW minimum flow bypass valve controller"
    annotation (Placement(transformation(extent={{-60,-190},{-40,-170}})));
  Sensors.TemperatureTwoPort TChwRet(redeclare final package Medium = Medium,
      final m_flow_nominal=hp.mEva_flow_nominal) "CHW return temperature"
    annotation (Placement(transformation(extent={{170,-70},{150,-50}})));
  Sensors.TemperatureTwoPort THwRet(redeclare final package Medium = Medium,
      final m_flow_nominal=hp.mCon_flow_nominal) "HW return temperature"
    annotation (Placement(transformation(extent={{170,-270},{150,-250}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold valChwReq(t=1E-1, h=5E-2)
    "CHW plant request from terminal valve"
    annotation (Placement(transformation(extent={{120,190},{100,210}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold valHwReq(t=1E-1, h=5E-2)
    "HW plant request from terminal valve"
    annotation (Placement(transformation(extent={{120,230},{100,250}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger reqHea
    "Heating plant request"
    annotation (Placement(transformation(extent={{90,230},{70,250}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger reqCoo
    "Cooling plant request"
    annotation (Placement(transformation(extent={{92,190},{72,210}})));
  Buildings.Controls.OBC.CDL.Logical.Or on "HP commanded on"
    annotation (Placement(transformation(extent={{10,210},{-10,230}})));
  Buildings.Controls.OBC.CDL.Logical.And onAndHea
    "HP commanded on and heating enabled"
    annotation (Placement(transformation(extent={{-30,230},{-50,250}})));
  Buildings.Controls.OBC.CDL.Logical.And onAndCoo
    "HP commanded on and cooling enabled"
    annotation (Placement(transformation(extent={{-30,190},{-50,210}})));
  Templates.Plants.Controls.Enabling.Enable enaHea(typ=Buildings.Templates.Plants.Controls.Types.Application.Heating,
      TOutLck=295.15) "Enable heating"
    annotation (Placement(transformation(extent={{50,230},{30,250}})));
  Templates.Plants.Controls.Enabling.Enable enaCoo(typ=Buildings.Templates.Plants.Controls.Types.Application.Cooling,
      TOutLck=290.15) "Enable cooling"
    annotation (Placement(transformation(extent={{50,190},{30,210}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger intModCoo(integerTrue
      =2) "Cast to integer for operating mode command"
    annotation (Placement(transformation(extent={{-90,190},{-110,210}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger intModHea(integerTrue
      =1) "Cast to integer for operating mode command"
    annotation (Placement(transformation(extent={{-90,230},{-110,250}})));
  Buildings.Controls.OBC.CDL.Integers.Add mode "Operating mode"
    annotation (Placement(transformation(extent={{-130,230},{-150,250}})));
  Templates.Components.Routing.SingleToMultiple inlPumChwPri(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final nPorts=pumChwPri.nPum,
    final m_flow_nominal=hp.mEva_flow_nominal)
    "Primary CHW pumps suction header"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Templates.Components.Pumps.Multiple pumChwPri(
    redeclare final package Medium=Medium,
    final energyDynamics=energyDynamics,
    dat(
      m_flow_nominal=fill(hp.mEva_flow_nominal / pumChwPri.nPum, pumChwPri.nPum),
      dp_nominal=fill(dpChwLocSet_max + hp.dpChw_nominal, pumChwPri.nPum),
      rho_default=Medium.d_const),
    final nPum=hp.nUni) "Primary CHW pumps"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Templates.Components.Routing.MultipleToSingle outPumChwPri(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final nPorts=pumChwPri.nPum,
    final m_flow_nominal=hp.mEva_flow_nominal)
    "Primary CHW pumps discharge header"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Templates.Plants.Controls.Pumps.Generic.ControlDifferentialPressure
    ctlPumChwPri(
    have_senDpRemWir=true,
    nPum=pumChwPri.nPum,
    nSenDpRem=1,
    k=0.1) "Primary CHW pump control"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Templates.Components.Interfaces.Bus busPumChwPri
    "Primary CHW pump control bus" annotation (Placement(transformation(extent={{-70,56},
            {-30,96}}),          iconTransformation(extent={{-230,-40},{-190,0}})));
  Sensors.VolumeFlowRate VChwPri(redeclare final package Medium = Medium,
      final m_flow_nominal=hp.mEva_flow_nominal)
    "Primary CHW flow (plant side)"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
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
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Templates.Components.Routing.SingleToMultiple inlPumHwPri(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final nPorts=pumHwPri.nPum,
    final m_flow_nominal=hp.mCon_flow_nominal)
    "Primary HW pumps suction header"
    annotation (Placement(transformation(extent={{-40,-230},{-20,-210}})));
  Templates.Components.Pumps.Multiple pumHwPri(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    dat(
      m_flow_nominal=fill(hp.mCon_flow_nominal/pumHwPri.nPum, pumHwPri.nPum),
      dp_nominal=fill(dpHwLocSet_max + hp.dpHw_nominal, pumHwPri.nPum),
      rho_default=Medium.d_const),
    final nPum=hp.nUni) "Primary HW pumps"
    annotation (Placement(transformation(extent={{-20,-230},{0,-210}})));
  Templates.Components.Routing.MultipleToSingle outPumHwPri(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final nPorts=pumHwPri.nPum,
    final m_flow_nominal=hp.mCon_flow_nominal)
    "Primary HW pumps discharge header"
    annotation (Placement(transformation(extent={{0,-230},{20,-210}})));
  Sensors.VolumeFlowRate VHwPri(redeclare final package Medium = Medium, final
      m_flow_nominal=hp.mCon_flow_nominal) "Primary HW flow (plant side)"
    annotation (Placement(transformation(extent={{-60,-230},{-40,-210}})));
  Templates.Plants.Controls.Pumps.Generic.ControlDifferentialPressure ctlPumHwPri(
    have_senDpRemWir=true,
    nPum=pumHwPri.nPum,
    nSenDpRem=1,
    k=0.1) "Primary HW pump control"
    annotation (Placement(transformation(extent={{-60,-160},{-40,-140}})));
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
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));
  Templates.Components.Interfaces.Bus busPumHwPri "Primary HW pump control bus"
    annotation (Placement(transformation(extent={{-70,-144},{-30,-104}}),
        iconTransformation(extent={{-230,-40},{-190,0}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyPumHwPri(nin=pumHwPri.nPum)
    "True if any primary HW pump is proven on"
    annotation (Placement(transformation(extent={{-26,-104},{-6,-84}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyPumChwPri(nin=pumChwPri.nPum)
    "True if any primary CHW pump is proven on"
    annotation (Placement(transformation(extent={{-26,96},{-6,116}})));
equation
  connect(loaChw.port_b, valDisChw.port_a)
    annotation (Line(points={{130,-20},{150,-20}},
                                                 color={0,127,255}));
  connect(loaHw.port_b, valDisHw.port_a)
    annotation (Line(points={{130,-220},{150,-220}},
                                                   color={0,127,255}));
  connect(valDisChw.port_b, mChw_flow.port_a)
    annotation (Line(points={{170,-20},{200,-20},{200,-30}},color={0,127,255}));
  connect(valDisHw.port_b, mHw_flow.port_a)
    annotation (Line(points={{170,-220},{200,-220},{200,-230}},color={0,127,255}));
  connect(mHw_flow.m_flow, norFlo[1].u)
    annotation (Line(points={{211,-240},{220,-240},{220,8}},  color={0,0,127}));
  connect(mChw_flow.m_flow, norFlo[2].u)
    annotation (Line(points={{211,-40},{220,-40},{220,8}},  color={0,0,127}));
  connect(norFlo.y, ctlEquZon.u_m)
    annotation (Line(points={{220,32},{220,60},{100,60},{100,118}},
                                                                color={0,0,127}));
  connect(ctlEquZon[2].y, valDisChw.y)
    annotation (Line(points={{112,130},{160,130},{160,-8}},
      color={0,0,127}));
  connect(ctlEquZon[1].y, valDisHw.y)
    annotation (Line(points={{112,130},{140,130},{140,-200},{160,-200},{160,
          -208}},
      color={0,0,127}));
  connect(TChwRetPre.y, min1.u1) annotation (Line(points={{-188,180},{-180,180},
          {-180,186},{-172,186}}, color={0,0,127}));
  connect(min1.y, loaChw.TSet)
    annotation (Line(points={{-148,180},{24,180},{24,-12},{108,-12}},
                                                                 color={0,0,127}));
  connect(max2.y, loaHw.TSet)
    annotation (Line(points={{-148,140},{22,140},{22,-212},{108,-212}},
                                                                   color={0,0,127}));
  connect(con.y, min1.u2)
    annotation (Line(points={{-238,160},{-180,160},{-180,174},{-172,174}},
                                                                     color={0,0,127}));
  connect(con.y, max2.u1)
    annotation (Line(points={{-238,160},{-180,160},{-180,146},{-172,146}},
                                                                     color={0,0,127}));
  connect(THwRetPre.y, max2.u2) annotation (Line(points={{-188,140},{-180,140},
          {-180,134},{-172,134}},
                         color={0,0,127}));
  connect(weaDat.weaBus, hp.weaBus) annotation (Line(
      points={{-240,-10},{-180,-10},{-180,-44}},
      color={255,204,51},
      thickness=0.5));
  connect(ratFlo.y, ctlEquZon.u_s)
    annotation (Line(points={{-238,200},{-140,200},{-140,130},{88,130}},
                                                   color={0,0,127}));
  connect(TSupSet[1].y, hp.THwSet) annotation (Line(points={{-238,30},{-220,30},
          {-220,-50},{-192,-50}},color={0,0,127}));
  connect(TSupSet[2].y, hp.TChwSet) annotation (Line(points={{-238,30},{-220,30},
          {-220,-54},{-192,-54}},color={0,0,127}));
  connect(dpChwRem.port_a, loaChw.port_a)
    annotation (Line(points={{100,-30},{100,-20},{110,-20}},
                                                          color={0,127,255}));
  connect(dpChwRem.port_b, pipChw.port_a)
    annotation (Line(points={{100,-50},{100,-60},{80,-60}},color={0,127,255}));
  connect(dpHwRem.port_b, pipHw.port_a) annotation (Line(points={{100,-250},{
          100,-260},{80,-260}},
                     color={0,127,255}));
  connect(dpHwRem.port_a, loaHw.port_a) annotation (Line(points={{100,-230},{
          100,-220},{110,-220}},
                      color={0,127,255}));
  connect(pHwRet.ports[1], hp.port_a1) annotation (Line(points={{-190,-140},{
          -200,-140},{-200,-48},{-190,-48}},
                                       color={0,127,255}));
  connect(hp.port_b1, valHwIso.port_a) annotation (Line(points={{-170,-48},{
          -160,-48},{-160,-220},{-150,-220}},
                                       color={0,127,255}));
  connect(valHwIso.port_b, THwSup.port_a)
    annotation (Line(points={{-130,-220},{-100,-220}},
                                                     color={0,127,255}));
  connect(hp.yValHwIso, valHwIso.y) annotation (Line(points={{-172,-43},{-172,
          -40},{-140,-40},{-140,-208}},
                                      color={0,0,127}));
  connect(valChwIso.port_b, TChwSup.port_a)
    annotation (Line(points={{-130,-20},{-80,-20}},color={0,127,255}));
  connect(hp.port_b2, valChwIso.port_a) annotation (Line(points={{-190,-60},{
          -210,-60},{-210,-20},{-150,-20}},color={0,127,255}));
  connect(hp.yValChwIso, valChwIso.y) annotation (Line(points={{-188,-65},{-188,
          -68},{-154,-68},{-154,-2},{-140,-2},{-140,-8}},  color={0,0,127}));
  connect(sumNumUni.y,intLesEquThr. u)
    annotation (Line(points={{-238,-180},{-234,-180}},
                                             color={255,127,0}));
  connect(intLesEquThr.y,assMes. u)
    annotation (Line(points={{-210,-180},{-206,-180},{-206,-200},{-240,-200},{
          -240,-220},{-234,-220}},           color={255,0,255}));
  connect(hp.nUniShc, sumNumUni.u[1]) annotation (Line(points={{-183,-66},{-183,
          -70},{-270,-70},{-270,-182.333},{-262,-182.333}},   color={255,127,0}));
  connect(hp.nUniCoo, sumNumUni.u[2]) annotation (Line(points={{-180,-66},{-180,
          -70},{-270,-70},{-270,-180},{-262,-180}},   color={255,127,0}));
  connect(hp.nUniHea, sumNumUni.u[3]) annotation (Line(points={{-177,-66},{-177,
          -70},{-270,-70},{-270,-177.667},{-262,-177.667}},   color={255,127,0}));
  connect(dpHeaSet[2].y, ctlValChwByp.u_s)
    annotation (Line(points={{-238,70},{-80,70},{-80,20},{-62,20}},
                                                  color={0,0,127}));
  connect(ctlValChwByp.y, valChwByp.y) annotation (Line(points={{-38,20},{-30,
          20},{-30,-40},{28,-40}},
                              color={0,0,127}));
  connect(dpChwHea.p_rel, ctlValChwByp.u_m) annotation (Line(points={{-91,-40},
          {-84,-40},{-84,4},{-50,4},{-50,8}},   color={0,0,127}));
  connect(pChwRet.ports[1], hp.port_a2)
    annotation (Line(points={{-170,-100},{-170,-60}}, color={0,127,255}));
  connect(pipHw.port_b, THwRetPla.port_a)
    annotation (Line(points={{60,-260},{-110,-260}},color={0,127,255}));
  connect(THwRetPla.port_b, hp.port_a1) annotation (Line(points={{-130,-260},{
          -200,-260},{-200,-48},{-190,-48}}, color={0,127,255}));
  connect(pipChw.port_b, TChwRetPla.port_a)
    annotation (Line(points={{60,-60},{-110,-60}},color={0,127,255}));
  connect(TChwRetPla.port_b, hp.port_a2)
    annotation (Line(points={{-130,-60},{-170,-60}},color={0,127,255}));
  connect(dpHwHea.p_rel, ctlValHwByp.u_m) annotation (Line(points={{-91,-240},{
          -74,-240},{-74,-200},{-50,-200},{-50,-192}}, color={0,0,127}));
  connect(ctlValHwByp.y, valHwByp.y) annotation (Line(points={{-38,-180},{-30,
          -180},{-30,-240},{28,-240}},color={0,0,127}));
  connect(dpHeaSet[1].y, ctlValHwByp.u_s) annotation (Line(points={{-238,70},{
          -80,70},{-80,-180},{-62,-180}}, color={0,0,127}));
  connect(valHwByp.port_b, THwRetPla.port_a) annotation (Line(points={{40,-250},
          {40,-260},{-110,-260}},color={0,127,255}));
  connect(valChwByp.port_b, TChwRetPla.port_a)
    annotation (Line(points={{40,-50},{40,-60},{-110,-60}},color={0,127,255}));
  connect(dpChwHea.port_a, TChwRetPla.port_a) annotation (Line(points={{-100,
          -50},{-100,-60},{-110,-60}},
                                color={0,127,255}));
  connect(valChwIso.port_b, dpChwHea.port_b) annotation (Line(points={{-130,-20},
          {-100,-20},{-100,-30}},
                                color={0,127,255}));
  connect(dpHwHea.port_a, THwRetPla.port_a) annotation (Line(points={{-100,-250},
          {-100,-260},{-110,-260}},
                                  color={0,127,255}));
  connect(valHwIso.port_b, dpHwHea.port_b) annotation (Line(points={{-130,-220},
          {-100,-220},{-100,-230}},
                                  color={0,127,255}));
  connect(mChw_flow.port_b, TChwRet.port_a) annotation (Line(points={{200,-50},
          {200,-60},{170,-60}}, color={0,127,255}));
  connect(TChwRet.port_b, pipChw.port_a)
    annotation (Line(points={{150,-60},{80,-60}}, color={0,127,255}));
  connect(mHw_flow.port_b, THwRet.port_a) annotation (Line(points={{200,-250},{
          200,-260},{170,-260}}, color={0,127,255}));
  connect(THwRet.port_b, pipHw.port_a)
    annotation (Line(points={{150,-260},{80,-260}}, color={0,127,255}));
  connect(TChwSup.T, TChwRetPre.u) annotation (Line(points={{-70,-9},{-70,0},{
          -218,0},{-218,180},{-212,180}},    color={0,0,127}));
  connect(THwSup.T, THwRetPre.u) annotation (Line(points={{-90,-209},{-90,-160},
          {-216,-160},{-216,140},{-212,140}},          color={0,0,127}));
  connect(valDisChw.y_actual, valChwReq.u) annotation (Line(points={{165,-13},{
          170,-13},{170,200},{122,200}},
                                     color={0,0,127}));
  connect(valDisHw.y_actual, valHwReq.u) annotation (Line(points={{165,-213},{
          176,-213},{176,240},{122,240}},
                                      color={0,0,127}));
  connect(on.y, hp.on) annotation (Line(points={{-12,220},{-224,220},{-224,-56},
          {-192,-56}}, color={255,0,255}));
  connect(valHwReq.y, reqHea.u)
    annotation (Line(points={{98,240},{92,240}},   color={255,0,255}));
  connect(valChwReq.y, reqCoo.u)
    annotation (Line(points={{98,200},{94,200}},   color={255,0,255}));
  connect(reqHea.y, enaHea.nReqPla)
    annotation (Line(points={{68,240},{52,240}},  color={255,127,0}));
  connect(reqCoo.y, enaCoo.nReqPla)
    annotation (Line(points={{70,200},{52,200}},  color={255,127,0}));
  connect(con.y, enaHea.TOut) annotation (Line(points={{-238,160},{60,160},{60,
          236},{52,236}},     color={0,0,127}));
  connect(con.y, enaCoo.TOut) annotation (Line(points={{-238,160},{60,160},{60,
          196},{52,196}},     color={0,0,127}));
  connect(enaHea.y1, on.u1) annotation (Line(points={{28,240},{20,240},{20,220},
          {12,220}}, color={255,0,255}));
  connect(enaCoo.y1, on.u2) annotation (Line(points={{28,200},{20,200},{20,212},
          {12,212}}, color={255,0,255}));
  connect(enaHea.y1, onAndHea.u1)
    annotation (Line(points={{28,240},{-28,240}},color={255,0,255}));
  connect(on.y, onAndHea.u2) annotation (Line(points={{-12,220},{-20,220},{-20,
          232},{-28,232}},
                     color={255,0,255}));
  connect(enaCoo.y1, onAndCoo.u1)
    annotation (Line(points={{28,200},{-28,200}},color={255,0,255}));
  connect(on.y, onAndCoo.u2) annotation (Line(points={{-12,220},{-20,220},{-20,
          192},{-28,192}},
                     color={255,0,255}));
  connect(onAndHea.y, intModHea.u)
    annotation (Line(points={{-52,240},{-88,240}}, color={255,0,255}));
  connect(onAndCoo.y, intModCoo.u)
    annotation (Line(points={{-52,200},{-88,200}}, color={255,0,255}));
  connect(intModHea.y, mode.u1) annotation (Line(points={{-112,240},{-120,240},
          {-120,246},{-128,246}},
                               color={255,127,0}));
  connect(intModCoo.y, mode.u2) annotation (Line(points={{-112,200},{-120,200},
          {-120,234},{-128,234}},
                               color={255,127,0}));
  connect(mode.y, hp.mode) annotation (Line(points={{-152,240},{-226,240},{-226,
          -58},{-192,-58}}, color={255,127,0}));

  connect(inlPumChwPri.ports_b, pumChwPri.ports_a)
    annotation (Line(points={{-20,-20},{-20,-20}}, color={0,127,255}));
  connect(pumChwPri.ports_b, outPumChwPri.ports_a)
    annotation (Line(points={{0,-20},{0,-20}}, color={0,127,255}));
  connect(outPumChwPri.port_b, loaChw.port_a)
    annotation (Line(points={{20,-20},{110,-20}}, color={0,127,255}));
  connect(outPumChwPri.port_b, valChwByp.port_a)
    annotation (Line(points={{20,-20},{40,-20},{40,-30}}, color={0,127,255}));
  connect(ctlPumChwPri.y, busPumChwPri.y) annotation (Line(points={{-38,50},{
          -32,50},{-32,72},{-42,72},{-42,76},{-50,76}},
                                                    color={0,0,127}));
  connect(busPumChwPri, pumChwPri.bus) annotation (Line(
      points={{-50,76},{-10,76},{-10,-10}},
      color={255,204,51},
      thickness=0.5));
  connect(busPumChwPri.y1_actual, ctlPumChwPri.y1_actual) annotation (Line(
      points={{-50,76},{-72,76},{-72,58},{-62,58}},
      color={255,204,51},
      thickness=0.5));
  connect(TChwSup.port_b, VChwPri.port_a)
    annotation (Line(points={{-60,-20},{-60,-20}}, color={0,127,255}));
  connect(VChwPri.port_b, inlPumChwPri.port_a)
    annotation (Line(points={{-40,-20},{-40,-20}}, color={0,127,255}));
  connect(dpRemSet[2].y, ctlPumChwPri.dpRemSet[1]) annotation (Line(points={{-238,
          110},{-78,110},{-78,54},{-62,54}},
                                           color={0,0,127}));
  connect(dpChwRem.p_rel, ctlPumChwPri.dpRem[1]) annotation (Line(points={{91,-40},
          {80,-40},{80,68},{-66,68},{-66,50},{-62,50}}, color={0,0,127}));
  connect(staPumChwPri.y1, busPumChwPri.y1) annotation (Line(points={{-38,100},
          {-32,100},{-32,80},{-50,80},{-50,76}},
                                           color={255,0,255}));
  connect(hp.y1ValChwIso, staPumChwPri.u1ValOutIso) annotation (Line(points={{-186,
          -65},{-186,-66},{-156,-66},{-156,104},{-62,104}},
                                    color={255,0,255}));
  connect(VChwPri.V_flow, staPumChwPri.V_flow) annotation (Line(points={{-50,-9},
          {-50,2},{-86,2},{-86,98},{-62,98}},     color={0,0,127}));
  connect(dpRemSet[2].y, staPumChwPri.dpSet[1]) annotation (Line(points={{-238,
          110},{-78,110},{-78,96},{-62,96}},
                                       color={0,0,127}));
  connect(busPumChwPri.y1_actual, staPumChwPri.u1Pum_actual) annotation (Line(
      points={{-50,76},{-72,76},{-72,100},{-62,100}},
      color={255,204,51},
      thickness=0.5));
  connect(busPumChwPri.y, staPumChwPri.y) annotation (Line(
      points={{-50,76},{-50,76.2162},{-72,76.2162},{-72,92},{-62,92}},
      color={255,204,51},
      thickness=0.5));
  connect(dpChwRem.p_rel, staPumChwPri.dp[1]) annotation (Line(points={{91,-40},
          {80,-40},{80,68},{-66,68},{-66,94},{-62,94}},                   color
        ={0,0,127}));
  connect(inlPumHwPri.ports_b, pumHwPri.ports_a)
    annotation (Line(points={{-20,-220},{-20,-220}}, color={0,127,255}));
  connect(pumHwPri.ports_b, outPumHwPri.ports_a)
    annotation (Line(points={{0,-220},{0,-220}}, color={0,127,255}));
  connect(inlPumHwPri.port_a, VHwPri.port_b)
    annotation (Line(points={{-40,-220},{-40,-220}}, color={0,127,255}));
  connect(THwSup.port_b, VHwPri.port_a)
    annotation (Line(points={{-80,-220},{-60,-220}}, color={0,127,255}));
  connect(ctlPumHwPri.y, busPumHwPri.y) annotation (Line(points={{-38,-150},{
          -32,-150},{-32,-128},{-42,-128},{-42,-124},{-50,-124}},
                                                              color={0,0,127}));
  connect(staPumHwPri.y1, busPumHwPri.y1) annotation (Line(points={{-38,-100},{
          -32,-100},{-32,-120},{-50,-120},{-50,-124}},
                                                   color={255,0,255}));
  connect(busPumHwPri, pumHwPri.bus) annotation (Line(
      points={{-50,-124},{-10,-124},{-10,-210}},
      color={255,204,51},
      thickness=0.5));
  connect(busPumHwPri.y1_actual, ctlPumHwPri.y1_actual) annotation (Line(
      points={{-50,-124},{-70,-124},{-70,-142},{-62,-142}},
      color={255,204,51},
      thickness=0.5));
  connect(busPumHwPri.y, staPumHwPri.y) annotation (Line(
      points={{-50,-124},{-70,-124},{-70,-110},{-62,-110},{-62,-108}},
      color={255,204,51},
      thickness=0.5));
  connect(busPumHwPri.y1_actual, staPumHwPri.u1Pum_actual) annotation (Line(
      points={{-50,-124},{-70,-124},{-70,-100},{-62,-100}},
      color={255,204,51},
      thickness=0.5));
  connect(hp.y1ValHwIso, staPumHwPri.u1ValOutIso) annotation (Line(points={{-174,
          -43},{-174,-38},{-138,-38},{-138,-96},{-62,-96}},   color={255,0,255}));
  connect(VHwPri.V_flow, staPumHwPri.V_flow) annotation (Line(points={{-50,-209},
          {-50,-204},{-68,-204},{-68,-102},{-62,-102}}, color={0,0,127}));
  connect(outPumHwPri.port_b, loaHw.port_a)
    annotation (Line(points={{20,-220},{110,-220}}, color={0,127,255}));
  connect(outPumHwPri.port_b, valHwByp.port_a) annotation (Line(points={{20,-220},
          {40,-220},{40,-230}}, color={0,127,255}));
  connect(dpHwRem.p_rel, ctlPumHwPri.dpRem[1]) annotation (Line(points={{91,-240},
          {80,-240},{80,-134},{-66,-134},{-66,-150},{-62,-150}}, color={0,0,127}));
  connect(dpHwRem.p_rel, staPumHwPri.dp[1]) annotation (Line(points={{91,-240},
          {80,-240},{80,-134},{-66,-134},{-66,-106},{-62,-106}},color={0,0,127}));
  connect(dpRemSet[1].y, staPumHwPri.dpSet[1]) annotation (Line(points={{-238,
          110},{-78,110},{-78,-104},{-62,-104}},
                                           color={0,0,127}));
  connect(dpRemSet[1].y, ctlPumHwPri.dpRemSet[1]) annotation (Line(points={{-238,
          110},{-78,110},{-78,-146},{-62,-146}},
                                               color={0,0,127}));
  connect(staPumHwPri.y1_actual, anyPumHwPri.u)
    annotation (Line(points={{-38,-94},{-28,-94}},   color={255,0,255}));
  connect(anyPumHwPri.y, ctlValHwByp.uEna) annotation (Line(points={{-4,-94},{0,
          -94},{0,-74},{-74,-74},{-74,-196},{-54,-196},{-54,-192}},  color={255,
          0,255}));
  connect(staPumChwPri.y1_actual, anyPumChwPri.u)
    annotation (Line(points={{-38,106},{-28,106}},
                                                 color={255,0,255}));
  connect(anyPumChwPri.y, ctlValChwByp.uEna) annotation (Line(points={{-4,106},
          {0,106},{0,126},{-76,126},{-76,6},{-54,6},{-54,8}},   color={255,0,255}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/ModularReversible/Examples/TableData2DLoadDepSHC1Only.mos"
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
        extent={{-280,-300},{280,300}}, grid={2,2})));
end TableData2DLoadDepSHC1Only;
