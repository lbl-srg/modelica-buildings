within Buildings.Fluid.HeatPumps.ModularReversible.Examples;
model TableData2DLoadDepSHC1And2
  "Example of a primary-secondary plant with four-pipe heat pump"
  extends Modelica.Icons.Example;
  package Medium=Buildings.Media.Water
    "Main medium (common for CHW and HW)";
  parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal=1500E3
    "Heating heat flow rate"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal=-1500E3
    "Cooling heat flow rate"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mHwSec_flow_nominal=abs(
      QHea_flow_nominal/(THwSup_nominal - THwRet_nominal))/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq
    "Secondary HW mass flow rate"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mChwSec_flow_nominal=abs(
      QCoo_flow_nominal/(TChwSup_nominal - TChwRet_nominal))/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq
    "Secondary CHW mass flow rate"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mHwPri_flow_nominal=
    mHwSec_flow_nominal / 0.9
    "Primary HW mass flow rate"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mChwPri_flow_nominal=
    mChwSec_flow_nominal / 0.9
    "Primary CHW mass flow rate"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature THwSup_nominal=
    Buildings.Templates.Data.Defaults.THeaWatSupMed
    "HW supply temperature"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TChwSup_nominal=
    Buildings.Templates.Data.Defaults.TChiWatSup
    "CHW supply temperature"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature THwRet_nominal=
    Buildings.Templates.Data.Defaults.THeaWatRetMed
    "HW return temperature"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TChwRet_nominal=
    Buildings.Templates.Data.Defaults.TChiWatRet
    "CHW return temperature"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpHwRemSet_max=
    Buildings.Templates.Data.Defaults.dpHeaWatRemSet_max
    "Maximum HW differential pressure setpoint - At remote location"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpChwRemSet_max=
    Buildings.Templates.Data.Defaults.dpChiWatRemSet_max
    "Maximum CHW differential pressure setpoint - At remote location"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpHwLocSet_max=
    Buildings.Templates.Data.Defaults.dpHeaWatLocSet_max
    "Maximum HW differential pressure setpoint - local to the plant"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpChwLocSet_max=
    Buildings.Templates.Data.Defaults.dpChiWatLocSet_max
    "Maximum CHW differential pressure setpoint - local to the plant"
    annotation(Dialog(group="Nominal condition"));
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
    redeclare final package Medium = Medium,
    final m_flow_nominal=mHwSec_flow_nominal,
    show_T=true,
    final dp_nominal=0,
    final energyDynamics=energyDynamics,
    tau=300,
    QMin_flow=-QHea_flow_nominal)
    "HW system approximated by prescribed return temperature"
    annotation (Placement(transformation(extent={{190,-230},{210,-210}})));
  Fluid.HeatExchangers.Heater_T loaChw(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mChwSec_flow_nominal,
    show_T=true,
    final dp_nominal=0,
    final energyDynamics=energyDynamics,
    tau=300,
    QMax_flow=-QCoo_flow_nominal)
    "CHW system system approximated by prescribed return temperature"
    annotation (Placement(transformation(extent={{190,-30},{210,-10}})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage valDisHw(
    redeclare final package Medium = Medium,
    m_flow_nominal=mHwSec_flow_nominal,
    dpValve_nominal=3E4,
    y_start=0,
    dpFixed_nominal=dpHwRemSet_max - 3E4)
    "Distribution system approximated by variable flow resistance"
    annotation (Placement(transformation(extent={{230,-230},{250,-210}})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage valDisChw(
    redeclare final package Medium = Medium,
    m_flow_nominal=mChwSec_flow_nominal,
    dpValve_nominal=3E4,
    y_start=0,
    dpFixed_nominal=dpChwRemSet_max - 3E4)
    "Distribution system approximated by variable flow resistance"
    annotation (Placement(transformation(extent={{230,-30},{250,-10}})));
  Fluid.Sensors.RelativePressure dpHwRem(
    redeclare final package Medium = Medium)
    "HW differential pressure at one remote location"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={180,-240})));
  Fluid.Sensors.RelativePressure dpChwRem(
    redeclare final package Medium = Medium)
    "CHW differential pressure at one remote location"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={180,-40})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable ratFlo(table=[0,0,0; 5,0,0;
        7,1,0; 12,0.4,0.4; 16,0,1; 22,0.1,0.1; 24,0,0],
    timeScale=3600)
    "Source signal for flow rate ratio – Index 1 for HW, 2 for CHW"
    annotation (Placement(transformation(extent={{-260,190},{-240,210}})));
  Buildings.Controls.OBC.CDL.Reals.PID ctlEquZon[2](
    each k=0.1,
    each Ti=60,
    each final reverseActing=true) "Zone equipment controller"
    annotation (Placement(transformation(extent={{170,120},{190,140}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter norFlo[2](k={1/
        mHwSec_flow_nominal,1/mChwSec_flow_nominal}) "Normalize flow rate"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={300,20})));
  Fluid.Sensors.MassFlowRate mChw_flow(
    redeclare final package Medium=Medium)
    "CHW mass flow rate"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={280,-40})));
  Fluid.Sensors.MassFlowRate mHw_flow(
    redeclare final package Medium=Medium)
    "HW mass flow rate"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={280,-240})));
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
    redeclare final package Medium = Medium,
    final m_flow_nominal=mHwSec_flow_nominal,
    final dp_nominal=dpHwLocSet_max - dpHwRemSet_max) "Piping"
    annotation (Placement(transformation(extent={{160,-270},{140,-250}})));
  Buildings.Fluid.FixedResistances.PressureDrop pipChw(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mChwSec_flow_nominal,
    final dp_nominal=dpChwLocSet_max - dpChwRemSet_max) "Piping"
    annotation (Placement(transformation(extent={{160,-70},{140,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(
    k=293.15) "Constant limiting prescribed return temperature"
    annotation (Placement(transformation(extent={{-260,150},{-240,170}})));
  Buildings.Fluid.HeatPumps.ModularReversible.TableData2DLoadDepSHC hp(
    redeclare final package MediumCon = Medium,
    redeclare final package MediumEva = Medium,
    final energyDynamics=energyDynamics,
    final mCon_flow_nominal=mHwPri_flow_nominal,
    final mEva_flow_nominal=mChwPri_flow_nominal,
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
    dpChw_nominal=40000) "Modular heat pump"
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
    final m_flow_nominal=mChwSec_flow_nominal,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    T_start=TChwSup_nominal) "CHW supply temperature"
    annotation (Placement(transformation(extent={{130,-30},{150,-10}})));
  Sensors.TemperatureTwoPort THwSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mHwSec_flow_nominal,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    T_start=THwSup_nominal) "HW supply temperature"
    annotation (Placement(transformation(extent={{130,-230},{150,-210}})));
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
  Actuators.Valves.TwoWayTable valHwIso(
    redeclare final package Medium = Medium,
    final m_flow_nominal=hp.mCon_flow_nominal,
    flowCharacteristics=hp.chaValHwIso,
    dpValve_nominal=hp.dpValIso_nominal,
    init=Modelica.Blocks.Types.Init.InitialState,
    dpFixed_nominal=hp.dpHw_nominal)
    "Equivalent actuator for modules' condenser barrels and HW isolation valves"
    annotation (Placement(transformation(extent={{-150,-230},{-130,-210}})));
  Actuators.Valves.TwoWayTable valChwIso(
    redeclare final package Medium = Medium,
    final m_flow_nominal=hp.mEva_flow_nominal,
    dpValve_nominal=hp.dpValIso_nominal,
    init=Modelica.Blocks.Types.Init.InitialState,
    dpFixed_nominal=hp.dpChw_nominal,
    flowCharacteristics=hp.chaValChwIso)
    "Equivalent actuator for modules' evaporator barrels and CHW isolation valves"
    annotation (Placement(transformation(extent={{-150,-30},{-130,-10}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum sumNumUni(nin=3)
    "Total number of enabled modules"
    annotation (Placement(transformation(extent={{-260,-190},{-240,-170}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(
  message="Number of enabled modules exceeds number of modules")
    "Assert condition on number of enabled modules"
     annotation (Placement(transformation(extent={{-232,-230},{-212, -210}})));
  Buildings.Controls.OBC.CDL.Integers.LessEqualThreshold intLesEquThr(t=hp.nUni)
    "True if number of enabled modules lower or equal to number of modules"
    annotation (Placement(transformation(extent={{-232,-190},{-212,-170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpHeaSet[2](k={hp.dpHw_nominal,
        hp.dpChw_nominal}) "Module header dp setpoint"
    annotation (Placement(transformation(extent={{-260,60},{-240,80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpRemSet[2](k={
        dpHwRemSet_max,dpChwRemSet_max}) "Remote dp setpoint"
    annotation (Placement(transformation(extent={{-260,110},{-240,130}})));
  Sensors.TemperatureTwoPort THwRetPla(redeclare final package Medium = Medium,
      final m_flow_nominal=hp.mCon_flow_nominal) "Plant HW return temperature"
    annotation (Placement(transformation(extent={{-110,-270},{-130,-250}})));
  Sensors.TemperatureTwoPort TChwRetPla(redeclare final package Medium = Medium,
      final m_flow_nominal=hp.mEva_flow_nominal) "Plant CHW return temperature"
    annotation (Placement(transformation(extent={{-110,-70},{-130,-50}})));
  Sensors.TemperatureTwoPort TChwRet(redeclare final package Medium = Medium, final
      m_flow_nominal=mChwSec_flow_nominal)       "CHW return temperature"
    annotation (Placement(transformation(extent={{250,-70},{230,-50}})));
  Sensors.TemperatureTwoPort THwRet(redeclare final package Medium = Medium, final
      m_flow_nominal=mHwSec_flow_nominal)        "HW return temperature"
    annotation (Placement(transformation(extent={{250,-270},{230,-250}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold valChwReq(t=1E-1, h=5E-2)
    "CHW plant request from terminal valve"
    annotation (Placement(transformation(extent={{120,210},{100,230}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold valHwReq(t=1E-1, h=5E-2)
    "HW plant request from terminal valve"
    annotation (Placement(transformation(extent={{120,250},{100,270}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger reqHea
    "Heating plant request"
    annotation (Placement(transformation(extent={{90,250},{70,270}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger reqCoo
    "Cooling plant request"
    annotation (Placement(transformation(extent={{92,210},{72,230}})));
  Buildings.Controls.OBC.CDL.Logical.Or on "HP commanded on"
    annotation (Placement(transformation(extent={{10,230},{-10,250}})));
  Buildings.Controls.OBC.CDL.Logical.And onAndHea
    "HP commanded on and heating enabled"
    annotation (Placement(transformation(extent={{-30,250},{-50,270}})));
  Buildings.Controls.OBC.CDL.Logical.And onAndCoo
    "HP commanded on and cooling enabled"
    annotation (Placement(transformation(extent={{-30,210},{-50,230}})));
  Templates.Plants.Controls.Enabling.Enable enaHea(typ=Buildings.Templates.Plants.Controls.Types.Application.Heating,
      TOutLck=295.15) "Enable heating"
    annotation (Placement(transformation(extent={{50,250},{30,270}})));
  Templates.Plants.Controls.Enabling.Enable enaCoo(typ=Buildings.Templates.Plants.Controls.Types.Application.Cooling,
      TOutLck=290.15) "Enable cooling"
    annotation (Placement(transformation(extent={{50,210},{30,230}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger intModCoo(integerTrue
      =2) "Cast to integer for operating mode command"
    annotation (Placement(transformation(extent={{-90,210},{-110,230}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger intModHea(integerTrue
      =1) "Cast to integer for operating mode command"
    annotation (Placement(transformation(extent={{-90,250},{-110,270}})));
  Buildings.Controls.OBC.CDL.Integers.Add mode "Operating mode"
    annotation (Placement(transformation(extent={{-130,250},{-150,270}})));
  Templates.Components.Routing.SingleToMultiple inlPumChwPri(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final nPorts=pumChwPri.nPum,
    final m_flow_nominal=hp.mEva_flow_nominal)
    "Primary CHW pumps suction header"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Templates.Components.Pumps.Multiple pumChwPri(
    have_var=false,
    redeclare final package Medium=Medium,
    final energyDynamics=energyDynamics,
    dat(
      m_flow_nominal=fill(hp.mEva_flow_nominal/pumChwPri.nPum, pumChwPri.nPum),
      dp_nominal=fill(valChwIso.dpValve_nominal + valChwIso.dpFixed_nominal,
          pumChwPri.nPum) .+ pumChwPri.dpValChe_nominal,
      rho_default=Medium.d_const),
    final nPum=hp.nUni)
    "Primary CHW pumps"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Templates.Components.Interfaces.Bus busPumChwPri
    "Primary CHW pump control bus"
    annotation (Placement(transformation(extent={{-70,36}, {-30,76}}),
    iconTransformation(extent={{-230,-40},{-190,0}})));
  Templates.Plants.Controls.Pumps.Generic.StagingHeadered staPumChwPri(
    is_pri=true,
    is_hdr=true,
    is_ctlDp=false,
    have_valInlIso=false,
    have_valOutIso=true,
    nEqu=hp.nUni,
    nPum=pumChwPri.nPum,
    nSenDp=1,
    V_flow_nominal=hp.mEva_flow_nominal/Medium.d_const,
    dtRun=5*60)
    "Primary CHW pump staging"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Templates.Components.Routing.SingleToMultiple inlPumHwPri(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final nPorts=pumHwPri.nPum,
    final m_flow_nominal=hp.mCon_flow_nominal)
    "Primary HW pumps suction header"
    annotation (Placement(transformation(extent={{-40,-230},{-20,-210}})));
  Templates.Components.Pumps.Multiple pumHwPri(
    have_var=false,
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    dat(
      m_flow_nominal=fill(hp.mCon_flow_nominal/pumHwPri.nPum, pumHwPri.nPum),
      dp_nominal=fill(valHwIso.dpValve_nominal + valHwIso.dpFixed_nominal,
          pumHwPri.nPum) .+ pumHwPri.dpValChe_nominal,
      rho_default=Medium.d_const),
    final nPum=hp.nUni)
    "Primary HW pumps"
    annotation (Placement(transformation(extent={{-20,-230},{0,-210}})));
  Templates.Components.Routing.MultipleToSingle outPumHwPri(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final nPorts=pumHwPri.nPum,
    final m_flow_nominal=hp.mCon_flow_nominal)
    "Primary HW pumps discharge header"
    annotation (Placement(transformation(extent={{0,-230},{20,-210}})));
  Sensors.VolumeFlowRate VHwPri(redeclare final package Medium = Medium, final
      m_flow_nominal=hp.mCon_flow_nominal) "Primary HW flow"
    annotation (Placement(transformation(extent={{-70,-230},{-50,-210}})));
  Templates.Plants.Controls.Pumps.Generic.StagingHeadered staPumHwPri(
    is_pri=true,
    is_hdr=true,
    is_ctlDp=false,
    have_valInlIso=false,
    have_valOutIso=true,
    nEqu=hp.nUni,
    nPum=pumHwPri.nPum,
    nSenDp=1,
    V_flow_nominal=hp.mCon_flow_nominal/Medium.d_const,
    dtRun=5*60) "Primary HW pump staging"
    annotation (Placement(transformation(extent={{-60,-120},{-40,-100}})));
  Templates.Components.Interfaces.Bus busPumHwPri
  "Primary HW pump control bus"
    annotation (Placement(transformation(extent={{-70,-160},{-30,-120}}),
        iconTransformation(extent={{-230,-40},{-190,0}})));
  Templates.Components.Pumps.Multiple pumHwSec(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    dat(
      m_flow_nominal=fill(mHwSec_flow_nominal/pumHwSec.nPum, pumHwSec.nPum),
      dp_nominal=fill(dpHwLocSet_max, pumHwSec.nPum),
      rho_default=Medium.d_const),
    final nPum=hp.nUni)
    "Secondary HW pumps"
    annotation (Placement(transformation(extent={{60,-230},{80,-210}})));
  Templates.Plants.Controls.Pumps.Generic.ControlDifferentialPressure ctlPumHwSec(
    have_senDpRemWir=true,
    nPum=pumHwSec.nPum,
    nSenDpRem=1,
    k=0.1) "Secondary HW pump control"
    annotation (Placement(transformation(extent={{20,-160},{40,-140}})));
  Templates.Plants.Controls.Pumps.Generic.StagingHeadered staPumHwSec(
    is_pri=false,
    is_hdr=true,
    is_ctlDp=true,
    have_valInlIso=false,
    have_valOutIso=true,
    nEqu=hp.nUni,
    nPum=pumHwSec.nPum,
    nSenDp=1,
    V_flow_nominal=mHwSec_flow_nominal/Medium.d_const,
    dtRun=5*60) "Secondary HW pump staging"
    annotation (Placement(transformation(extent={{20,-110},{40,-90}})));
  Templates.Components.Interfaces.Bus busPumHwSec
    "Secondary HW pump control bus"
    annotation (Placement(transformation(extent={{10,-144},{50,-104}}),
                                   iconTransformation(extent={{-230,-40},{-190,0}})));
  Templates.Components.Routing.SingleToMultiple inlPumHwSec(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final nPorts=pumHwSec.nPum,
    final m_flow_nominal=mHwSec_flow_nominal)
    "Secondary HW pumps suction header"
    annotation (Placement(transformation(extent={{40,-230},{60,-210}})));
  Templates.Components.Routing.MultipleToSingle outPumHwSec(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final nPorts=pumHwSec.nPum,
    final m_flow_nominal=mHwSec_flow_nominal)
    "Secondary HW pumps discharge header"
    annotation (Placement(transformation(extent={{80,-230},{100,-210}})));
  Templates.Components.Routing.SingleToMultiple inlPumChwSec(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final nPorts=pumChwSec.nPum,
    final m_flow_nominal=mChwSec_flow_nominal)
    "Secondary CHW pumps suction header"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Templates.Components.Pumps.Multiple pumChwSec(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    dat(
      m_flow_nominal=fill(mChwSec_flow_nominal/pumChwSec.nPum, pumChwSec.nPum),
      dp_nominal=fill(dpChwLocSet_max, pumChwSec.nPum),
      rho_default=Medium.d_const),
    final nPum=hp.nUni) "Secondary CHW pumps"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  Templates.Components.Routing.MultipleToSingle outPumChwSec(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final nPorts=pumChwSec.nPum,
    final m_flow_nominal=mChwSec_flow_nominal)
    "Secondary CHW pumps discharge header"
    annotation (Placement(transformation(extent={{80,-30},{100,-10}})));
  Templates.Plants.Controls.Pumps.Generic.ControlDifferentialPressure
    ctlPumChwSec(
    have_senDpRemWir=true,
    nPum=pumChwSec.nPum,
    nSenDpRem=1,
    k=0.1) "Secondary CHW pump control"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Templates.Plants.Controls.Pumps.Generic.StagingHeadered staPumChwSec(
    is_pri=false,
    is_hdr=true,
    is_ctlDp=true,
    have_valInlIso=false,
    have_valOutIso=true,
    nEqu=hp.nUni,
    nPum=pumChwSec.nPum,
    nSenDp=1,
    V_flow_nominal=mChwSec_flow_nominal/Medium.d_const,
    dtRun=5*60) "Secondary CHW pump staging"
    annotation (Placement(transformation(extent={{20,90},{40,110}})));
  Templates.Components.Interfaces.Bus busPumChwPri1
    "Primary CHW pump control bus" annotation (Placement(transformation(extent={{10,56},
            {50,96}}),           iconTransformation(extent={{-230,-40},{-190,0}})));
  Sensors.VolumeFlowRate VChwSec(redeclare final package Medium = Medium,
      final m_flow_nominal=mChwSec_flow_nominal) "Secondary CHW flow"
    annotation (Placement(transformation(extent={{110,-30},{130,-10}})));
  Sensors.VolumeFlowRate VHwSec(redeclare final package Medium = Medium, final
      m_flow_nominal=mHwSec_flow_nominal) "Secondary HW flow (plant side)"
    annotation (Placement(transformation(extent={{110,-230},{130,-210}})));
  Sensors.VolumeFlowRate VChwPri(redeclare final package Medium = Medium,
      final m_flow_nominal=hp.mEva_flow_nominal) "Primary CHW flow"
    annotation (Placement(transformation(extent={{-70,-30},{-50,-10}})));
  Sensors.TemperatureTwoPort TChwSupPri(
    redeclare final package Medium = Medium,
    final m_flow_nominal=hp.mEva_flow_nominal,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    T_start=TChwSup_nominal) "Primary CHW supply temperature"
    annotation (Placement(transformation(extent={{-110,-30},{-90,-10}})));
  Sensors.TemperatureTwoPort THwSupPri(
    redeclare final package Medium = Medium,
    final m_flow_nominal=hp.mCon_flow_nominal,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    T_start=THwSup_nominal) "Primary HW supply temperature"
    annotation (Placement(transformation(extent={{-110,-230},{-90,-210}})));
  FixedResistances.Junction junChwBypSup(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final m_flow_nominal=mChwPri_flow_nominal*{1,-1,-1},
    final dp_nominal=fill(0, 3)) "CHW bypass supply junction"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  FixedResistances.Junction junChwBypRet(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final m_flow_nominal=mChwPri_flow_nominal*{1,-1,1},
    final dp_nominal=fill(0, 3)) "CHW bypass return junction"
    annotation (Placement(transformation(extent={{40,-50},{20,-70}})));
  FixedResistances.Junction junHwBypSup(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final m_flow_nominal=mHwPri_flow_nominal*{1,-1,-1},
    final dp_nominal=fill(0, 3)) "HW bypass supply junction"
    annotation (Placement(transformation(extent={{20,-230},{40,-210}})));
  FixedResistances.Junction junHwBypRet(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final m_flow_nominal=mHwPri_flow_nominal*{1,-1,1},
    final dp_nominal=fill(0, 3)) "HW bypass return junction"
    annotation (Placement(transformation(extent={{40,-250},{20,-270}})));
  Templates.Components.Routing.MultipleToSingle outPumChwPri(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final nPorts=pumChwPri.nPum,
    final m_flow_nominal=hp.mEva_flow_nominal)
    "Primary CHW pumps discharge header"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
equation
  connect(loaChw.port_b, valDisChw.port_a)
    annotation (Line(points={{210,-20},{230,-20}},
                                                 color={0,127,255}));
  connect(loaHw.port_b, valDisHw.port_a)
    annotation (Line(points={{210,-220},{230,-220}},
                                                   color={0,127,255}));
  connect(valDisChw.port_b, mChw_flow.port_a)
    annotation (Line(points={{250,-20},{280,-20},{280,-30}},color={0,127,255}));
  connect(valDisHw.port_b, mHw_flow.port_a)
    annotation (Line(points={{250,-220},{280,-220},{280,-230}},color={0,127,255}));
  connect(mHw_flow.m_flow, norFlo[1].u)
    annotation (Line(points={{291,-240},{300,-240},{300,8}},  color={0,0,127}));
  connect(mChw_flow.m_flow, norFlo[2].u)
    annotation (Line(points={{291,-40},{300,-40},{300,8}},  color={0,0,127}));
  connect(norFlo.y, ctlEquZon.u_m)
    annotation (Line(points={{300,32},{300,60},{180,60},{180,118}},
                                                                color={0,0,127}));
  connect(ctlEquZon[2].y, valDisChw.y)
    annotation (Line(points={{192,130},{240,130},{240,-8}},
      color={0,0,127}));
  connect(ctlEquZon[1].y, valDisHw.y)
    annotation (Line(points={{192,130},{220,130},{220,-200},{240,-200},{240,
          -208}},
      color={0,0,127}));
  connect(TChwRetPre.y, min1.u1) annotation (Line(points={{-188,180},{-180,180},
          {-180,186},{-172,186}}, color={0,0,127}));
  connect(min1.y, loaChw.TSet)
    annotation (Line(points={{-148,180},{164,180},{164,-12},{188,-12}},
                                                                 color={0,0,127}));
  connect(max2.y, loaHw.TSet)
    annotation (Line(points={{-148,140},{162,140},{162,-212},{188,-212}},
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
    annotation (Line(points={{-238,200},{-60,200},{-60,130},{168,130}},
                                                   color={0,0,127}));
  connect(TSupSet[1].y, hp.THwSet) annotation (Line(points={{-238,30},{-220,30},
          {-220,-50},{-192,-50}},color={0,0,127}));
  connect(TSupSet[2].y, hp.TChwSet) annotation (Line(points={{-238,30},{-220,30},
          {-220,-54},{-192,-54}},color={0,0,127}));
  connect(dpChwRem.port_a, loaChw.port_a)
    annotation (Line(points={{180,-30},{180,-20},{190,-20}},
                                                          color={0,127,255}));
  connect(dpChwRem.port_b, pipChw.port_a)
    annotation (Line(points={{180,-50},{180,-60},{160,-60}},
                                                           color={0,127,255}));
  connect(dpHwRem.port_b, pipHw.port_a) annotation (Line(points={{180,-250},{
          180,-260},{160,-260}},
                     color={0,127,255}));
  connect(dpHwRem.port_a, loaHw.port_a) annotation (Line(points={{180,-230},{
          180,-220},{190,-220}},
                      color={0,127,255}));
  connect(pHwRet.ports[1], hp.port_a1) annotation (Line(points={{-190,-140},{
          -200,-140},{-200,-48},{-190,-48}},
                                       color={0,127,255}));
  connect(hp.port_b1, valHwIso.port_a) annotation (Line(points={{-170,-48},{
          -160,-48},{-160,-220},{-150,-220}},
                                       color={0,127,255}));
  connect(hp.yValHwIso, valHwIso.y) annotation (Line(points={{-172,-43},{-172,
          -40},{-140,-40},{-140,-208}},
                                      color={0,0,127}));
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
  connect(pChwRet.ports[1], hp.port_a2)
    annotation (Line(points={{-170,-100},{-170,-60}}, color={0,127,255}));
  connect(THwRetPla.port_b, hp.port_a1) annotation (Line(points={{-130,-260},{
          -200,-260},{-200,-48},{-190,-48}}, color={0,127,255}));
  connect(TChwRetPla.port_b, hp.port_a2)
    annotation (Line(points={{-130,-60},{-170,-60}},color={0,127,255}));
  connect(mChw_flow.port_b, TChwRet.port_a) annotation (Line(points={{280,-50},
          {280,-60},{250,-60}}, color={0,127,255}));
  connect(TChwRet.port_b, pipChw.port_a)
    annotation (Line(points={{230,-60},{160,-60}},color={0,127,255}));
  connect(mHw_flow.port_b, THwRet.port_a) annotation (Line(points={{280,-250},{
          280,-260},{250,-260}}, color={0,127,255}));
  connect(THwRet.port_b, pipHw.port_a)
    annotation (Line(points={{230,-260},{160,-260}},color={0,127,255}));
  connect(TChwSup.T, TChwRetPre.u) annotation (Line(points={{140,-9},{140,0},{
          -218,0},{-218,180},{-212,180}},    color={0,0,127}));
  connect(THwSup.T, THwRetPre.u) annotation (Line(points={{140,-209},{140,-78},
          {-216,-78},{-216,140},{-212,140}},           color={0,0,127}));
  connect(valDisChw.y_actual, valChwReq.u) annotation (Line(points={{245,-13},{
          250,-13},{250,220},{122,220}},
                                     color={0,0,127}));
  connect(valDisHw.y_actual, valHwReq.u) annotation (Line(points={{245,-213},{
          256,-213},{256,260},{122,260}},
                                      color={0,0,127}));
  connect(on.y, hp.on) annotation (Line(points={{-12,240},{-224,240},{-224,-56},
          {-192,-56}}, color={255,0,255}));
  connect(valHwReq.y, reqHea.u)
    annotation (Line(points={{98,260},{92,260}},   color={255,0,255}));
  connect(valChwReq.y, reqCoo.u)
    annotation (Line(points={{98,220},{94,220}},   color={255,0,255}));
  connect(reqHea.y, enaHea.nReqPla)
    annotation (Line(points={{68,260},{52,260}},  color={255,127,0}));
  connect(reqCoo.y, enaCoo.nReqPla)
    annotation (Line(points={{70,220},{52,220}},  color={255,127,0}));
  connect(con.y, enaHea.TOut) annotation (Line(points={{-238,160},{60,160},{60,
          256},{52,256}},     color={0,0,127}));
  connect(con.y, enaCoo.TOut) annotation (Line(points={{-238,160},{60,160},{60,
          216},{52,216}},     color={0,0,127}));
  connect(enaHea.y1, on.u1) annotation (Line(points={{28,260},{20,260},{20,240},
          {12,240}}, color={255,0,255}));
  connect(enaCoo.y1, on.u2) annotation (Line(points={{28,220},{20,220},{20,232},
          {12,232}}, color={255,0,255}));
  connect(enaHea.y1, onAndHea.u1)
    annotation (Line(points={{28,260},{-28,260}},color={255,0,255}));
  connect(on.y, onAndHea.u2) annotation (Line(points={{-12,240},{-20,240},{-20,
          252},{-28,252}},
                     color={255,0,255}));
  connect(enaCoo.y1, onAndCoo.u1)
    annotation (Line(points={{28,220},{-28,220}},color={255,0,255}));
  connect(on.y, onAndCoo.u2) annotation (Line(points={{-12,240},{-20,240},{-20,
          212},{-28,212}},
                     color={255,0,255}));
  connect(onAndHea.y, intModHea.u)
    annotation (Line(points={{-52,260},{-88,260}}, color={255,0,255}));
  connect(onAndCoo.y, intModCoo.u)
    annotation (Line(points={{-52,220},{-88,220}}, color={255,0,255}));
  connect(intModHea.y, mode.u1) annotation (Line(points={{-112,260},{-120,260},
          {-120,266},{-128,266}},
                               color={255,127,0}));
  connect(intModCoo.y, mode.u2) annotation (Line(points={{-112,220},{-120,220},
          {-120,254},{-128,254}},
                               color={255,127,0}));
  connect(mode.y, hp.mode) annotation (Line(points={{-152,260},{-226,260},{-226,
          -58},{-192,-58}}, color={255,127,0}));

  connect(inlPumChwPri.ports_b, pumChwPri.ports_a)
    annotation (Line(points={{-20,-20},{-20,-20}}, color={0,127,255}));
  connect(busPumChwPri, pumChwPri.bus) annotation (Line(
      points={{-50,56},{-10,56},{-10,-10}},
      color={255,204,51},
      thickness=0.5));
  connect(staPumChwPri.y1, busPumChwPri.y1) annotation (Line(points={{-38,80},{
          -32,80},{-32,60},{-50,60},{-50,56}},
                                           color={255,0,255}));
  connect(hp.y1ChwValIsoPumPri, staPumChwPri.u1ValOutIso) annotation (Line(
        points={{-186,-65},{-186,-66},{-156,-66},{-156,84},{-62,84}}, color={
          255,0,255}));
  connect(busPumChwPri.y1_actual, staPumChwPri.u1Pum_actual) annotation (Line(
      points={{-50,56},{-72,56},{-72,80},{-62,80}},
      color={255,204,51},
      thickness=0.5));
  connect(inlPumHwPri.ports_b, pumHwPri.ports_a)
    annotation (Line(points={{-20,-220},{-20,-220}}, color={0,127,255}));
  connect(pumHwPri.ports_b, outPumHwPri.ports_a)
    annotation (Line(points={{0,-220},{0,-220}}, color={0,127,255}));
  connect(inlPumHwPri.port_a, VHwPri.port_b)
    annotation (Line(points={{-40,-220},{-50,-220}}, color={0,127,255}));
  connect(staPumHwPri.y1, busPumHwPri.y1) annotation (Line(points={{-38,-110},{
          -32,-110},{-32,-124},{-50,-124},{-50,-140}},
                                                   color={255,0,255}));
  connect(busPumHwPri, pumHwPri.bus) annotation (Line(
      points={{-50,-140},{-10,-140},{-10,-210}},
      color={255,204,51},
      thickness=0.5));
  connect(busPumHwPri.y1_actual, staPumHwPri.u1Pum_actual) annotation (Line(
      points={{-50,-140},{-70,-140},{-70,-110},{-62,-110}},
      color={255,204,51},
      thickness=0.5));
  connect(hp.y1HwValIsoPumPri, staPumHwPri.u1ValOutIso) annotation (Line(points
        ={{-174,-43},{-174,-38},{-138,-38},{-138,-106},{-62,-106}}, color={255,
          0,255}));
  connect(ctlPumHwSec.y, busPumHwSec.y) annotation (Line(points={{42,-150},{48,
          -150},{48,-128},{38,-128},{38,-124},{30,-124}},
                                                    color={0,0,127}));
  connect(staPumHwSec.y1, busPumHwSec.y1) annotation (Line(points={{42,-100},{
          48,-100},{48,-120},{30,-120},{30,-124}},
                                                color={255,0,255}));
  connect(busPumHwSec, pumHwSec.bus) annotation (Line(
      points={{30,-124},{70,-124},{70,-210}},
      color={255,204,51},
      thickness=0.5));
  connect(busPumHwSec.y1_actual, ctlPumHwSec.y1_actual) annotation (Line(
      points={{30,-124},{10,-124},{10,-142},{18,-142}},
      color={255,204,51},
      thickness=0.5));
  connect(busPumHwSec.y, staPumHwSec.y) annotation (Line(
      points={{30,-124},{10,-124},{10,-110},{18,-110},{18,-108}},
      color={255,204,51},
      thickness=0.5));
  connect(busPumHwSec.y1_actual, staPumHwSec.u1Pum_actual) annotation (Line(
      points={{30,-124},{10,-124},{10,-100},{18,-100}},
      color={255,204,51},
      thickness=0.5));
  connect(dpHwRem.p_rel, ctlPumHwSec.dpRem[1]) annotation (Line(points={{171,
          -240},{160,-240},{160,-134},{12,-134},{12,-150},{18,-150}},
                                                                color={0,0,127}));
  connect(dpHwRem.p_rel, staPumHwSec.dp[1]) annotation (Line(points={{171,-240},
          {160,-240},{160,-134},{12,-134},{12,-106},{18,-106}}, color={0,0,127}));
  connect(hp.y1HwValIsoPumPri, staPumHwPri.u1Pum) annotation (Line(points={{-174,
          -43},{-174,-38},{-138,-38},{-138,-108},{-62,-108}}, color={255,0,255}));
  connect(onAndHea.y, staPumHwSec.u1Pla) annotation (Line(points={{-52,260},{
          -82,260},{-82,-80},{12,-80},{12,-92},{18,-92}}, color={255,0,255}));
  connect(pumHwSec.ports_b, outPumHwSec.ports_a)
    annotation (Line(points={{80,-220},{80,-220}}, color={0,127,255}));
  connect(inlPumHwSec.ports_b, pumHwSec.ports_a)
    annotation (Line(points={{60,-220},{60,-220}}, color={0,127,255}));
  connect(inlPumChwSec.ports_b, pumChwSec.ports_a)
    annotation (Line(points={{60,-20},{60,-20}}, color={0,127,255}));
  connect(pumChwSec.ports_b, outPumChwSec.ports_a)
    annotation (Line(points={{80,-20},{80,-20}}, color={0,127,255}));
  connect(hp.y1ChwValIsoPumPri, staPumChwPri.u1Pum) annotation (Line(points={{-186,
          -65},{-186,-64.8387},{-156,-64.8387},{-156,82},{-62,82}}, color={255,
          0,255}));
  connect(ctlPumChwSec.y, busPumChwPri1.y) annotation (Line(points={{42,50},{48,
          50},{48,72},{38,72},{38,76},{30,76}}, color={0,0,127}));
  connect(busPumChwPri1.y1_actual,ctlPumChwSec. y1_actual) annotation (Line(
      points={{30,76},{8,76},{8,58},{18,58}},
      color={255,204,51},
      thickness=0.5));
  connect(dpChwRem.p_rel,ctlPumChwSec. dpRem[1]) annotation (Line(points={{171,-40},
          {160,-40},{160,68},{14,68},{14,50},{18,50}},  color={0,0,127}));
  connect(staPumChwSec.y1, busPumChwPri1.y1) annotation (Line(points={{42,100},
          {48,100},{48,80},{30,80},{30,76}},
                                        color={255,0,255}));
  connect(busPumChwPri1.y1_actual, staPumChwSec.u1Pum_actual) annotation (Line(
      points={{30,76},{8,76},{8,100},{18,100}},
      color={255,204,51},
      thickness=0.5));
  connect(busPumChwPri1.y, staPumChwSec.y) annotation (Line(
      points={{30,76},{30,76.2162},{8,76.2162},{8,92},{18,92}},
      color={255,204,51},
      thickness=0.5));
  connect(dpChwRem.p_rel, staPumChwSec.dp[1]) annotation (Line(points={{171,-40},
          {160,-40},{160,68},{14,68},{14,94},{18,94}}, color={0,0,127}));
  connect(outPumChwSec.port_b, VChwSec.port_a)
    annotation (Line(points={{100,-20},{110,-20}}, color={0,127,255}));
  connect(VChwSec.V_flow, staPumChwSec.V_flow) annotation (Line(points={{120,-9},
          {120,120},{14,120},{14,98},{18,98}}, color={0,0,127}));
  connect(outPumHwSec.port_b, VHwSec.port_a)
    annotation (Line(points={{100,-220},{110,-220}}, color={0,127,255}));
  connect(inlPumChwPri.port_a, VChwPri.port_b)
    annotation (Line(points={{-40,-20},{-50,-20}}, color={0,127,255}));
  connect(dpRemSet[2].y, staPumChwSec.dpSet[1]) annotation (Line(points={{-238,
          120},{2,120},{2,96},{18,96}},
                                   color={0,0,127}));
  connect(dpRemSet[2].y,ctlPumChwSec. dpRemSet[1]) annotation (Line(points={{-238,
          120},{2,120},{2,54},{18,54}}, color={0,0,127}));
  connect(dpRemSet[1].y, staPumHwSec.dpSet[1]) annotation (Line(points={{-238,
          120},{2,120},{2,-104},{18,-104}},
                                       color={0,0,127}));
  connect(dpRemSet[1].y, ctlPumHwSec.dpRemSet[1]) annotation (Line(points={{-238,
          120},{2,120},{2,-146},{18,-146}}, color={0,0,127}));
  connect(onAndCoo.y, staPumChwSec.u1Pla) annotation (Line(points={{-52,220},{
          -80,220},{-80,108},{18,108}},           color={255,0,255}));
  connect(busPumChwPri1, pumChwSec.bus) annotation (Line(
      points={{30,76},{70,76},{70,-10}},
      color={255,204,51},
      thickness=0.5));
  connect(VHwSec.V_flow, staPumHwSec.V_flow) annotation (Line(points={{120,-209},
          {120,-80},{14,-80},{14,-102},{18,-102}},   color={0,0,127}));
  connect(VChwSec.port_b, TChwSup.port_a)
    annotation (Line(points={{130,-20},{130,-20}}, color={0,127,255}));
  connect(TChwSup.port_b, loaChw.port_a)
    annotation (Line(points={{150,-20},{190,-20}}, color={0,127,255}));
  connect(VHwSec.port_b, THwSup.port_a)
    annotation (Line(points={{130,-220},{130,-220}}, color={0,127,255}));
  connect(THwSup.port_b, loaHw.port_a)
    annotation (Line(points={{150,-220},{190,-220}}, color={0,127,255}));
  connect(valChwIso.port_b, TChwSupPri.port_a)
    annotation (Line(points={{-130,-20},{-110,-20}}, color={0,127,255}));
  connect(TChwSupPri.port_b, VChwPri.port_a)
    annotation (Line(points={{-90,-20},{-70,-20}}, color={0,127,255}));
  connect(valHwIso.port_b, THwSupPri.port_a)
    annotation (Line(points={{-130,-220},{-110,-220}}, color={0,127,255}));
  connect(THwSupPri.port_b, VHwPri.port_a)
    annotation (Line(points={{-90,-220},{-70,-220}}, color={0,127,255}));
  connect(pipChw.port_b, junChwBypRet.port_1)
    annotation (Line(points={{140,-60},{40,-60}}, color={0,127,255}));
  connect(junChwBypRet.port_2, TChwRetPla.port_a)
    annotation (Line(points={{20,-60},{-110,-60}}, color={0,127,255}));
  connect(pumChwPri.ports_b, outPumChwPri.ports_a)
    annotation (Line(points={{0,-20},{0,-20}}, color={0,127,255}));
  connect(outPumHwPri.port_b, junHwBypSup.port_1)
    annotation (Line(points={{20,-220},{20,-220}}, color={0,127,255}));
  connect(inlPumHwSec.port_a, junHwBypSup.port_2)
    annotation (Line(points={{40,-220},{40,-220}}, color={0,127,255}));
  connect(outPumChwPri.port_b, junChwBypSup.port_1)
    annotation (Line(points={{20,-20},{20,-20}}, color={0,127,255}));
  connect(inlPumChwSec.port_a, junChwBypSup.port_2)
    annotation (Line(points={{40,-20},{40,-20}}, color={0,127,255}));
  connect(pipHw.port_b, junHwBypRet.port_1)
    annotation (Line(points={{140,-260},{40,-260}}, color={0,127,255}));
  connect(junHwBypRet.port_2, THwRetPla.port_a)
    annotation (Line(points={{20,-260},{-110,-260}}, color={0,127,255}));
  connect(junChwBypSup.port_3, junChwBypRet.port_3)
    annotation (Line(points={{30,-30},{30,-50}}, color={0,127,255}));
  connect(junHwBypSup.port_3, junHwBypRet.port_3)
    annotation (Line(points={{30,-230},{30,-250}}, color={0,127,255}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/ModularReversible/Examples/TableData2DLoadDepSHC1And2.mos"
        "Simulate and plot"),
    experiment(
      Tolerance=1e-6,
      StopTime=86400.0),
    Documentation(
      info="<html>
<p>
This model illustrates the use of
<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.TableData2DLoadDepSHC\">
Buildings.Fluid.HeatPumps.ModularReversible.TableData2DLoadDepSHC</a>
to model a primary-secondary heating and cooling plant.
The simulation covers a <i>24</i>-hour period with overlapping heating and
cooling loads.
The heating loads reach their peak value first, the cooling loads reach it last.
</p>
<p>
The plant model includes the following components.
</p>
<ul>
<li>
Modular four-pipe heat pump with three units
</li>
<li>
HW and CHW isolation valves represented by an equivalent actuator
</li>
<li>
Three headered constant-speed primary HW and CHW pumps
</li>
<li>
HW and CHW common legs
</li>
<li>
Three headered variable-speed secondary HW and CHW pumps
</li>
</ul>
<p>
A unique aggregated load is modeled on each loop by means of a cooling or heating component
controlled to maintain a constant &Delta;T and a modulating valve controlled to track
a prescribed flow rate.
</p>
<p>
The closed-loop controls use mostly the same logic as the one described in
<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.Examples.TableData2DLoadDepSHC1Only\">
Buildings.Fluid.HeatPumps.ModularReversible.Examples.TableData2DLoadDepSHC1Only</a>.
Only the logic that differs is presented below.
</p>
<ul>
<li>
Primary HW and CHW pump staging based on the number of modules enabled in each mode:
See
<a href=\"modelica://Buildings.Templates.Plants.Controls.Pumps.Generic.StagingHeadered\">
Buildings.Templates.Plants.Controls.Pumps.Generic.StagingHeadered</a>.
</li>
<li>
Secondary HW and CHW pumps controlled to maintain a remote differential pressure setpoint:
See
<a href=\"modelica://Buildings.Templates.Plants.Controls.Pumps.Generic.StagingHeadered\">
Buildings.Templates.Plants.Controls.Pumps.Generic.StagingHeadered</a>
for the staging and rotation logic, and
<a href=\"modelica://Buildings.Templates.Plants.Controls.Pumps.Generic.ControlDifferentialPressure\">
Buildings.Templates.Plants.Controls.Pumps.Generic.ControlDifferentialPressure</a>
for the control logic.
</li>
</ul>
<p>
Simulating this model shows how the plant responds to a varying load by
</p>
<ul>
<li>
enabling or disabling the heating and cooling plants,
and switching the heat pump operating mode accordingly,
</li>
<li>
staging or unstaging the heat pump modules in various modes,
</li>
<li>
actuating the corresponding isolation valves,
</li>
<li>
staging and rotating the primary pumps,
</li>
<li>
staging, rotating and controlling the secondary pumps to meet the
remote differential pressure setpoint.
</li>
</ul>
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
        extent={{-280,-300},{320,300}}, grid={2,2})));
end TableData2DLoadDepSHC1And2;
