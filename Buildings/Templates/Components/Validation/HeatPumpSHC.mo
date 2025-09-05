within Buildings.Templates.Components.Validation;
model HeatPumpSHC
  "Example of a primary-only plant with simultaneous heating and cooling (SHC) air-to-water heat pumps"
  extends Modelica.Icons.Example;
  package Medium=Buildings.Media.Water
    "Main medium (common for CHW and HW)";
  parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal=1500E3
    "Heating heat flow rate"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal=-1500E3
    "Cooling heat flow rate"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mHw_flow_nominal=
    abs(QHea_flow_nominal / (THwSup_nominal - THwRet_nominal)) /
    Buildings.Utilities.Psychrometrics.Constants.cpWatLiq
    "HW mass flow rate"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mChw_flow_nominal=
    abs(QCoo_flow_nominal / (TChwSup_nominal - TChwRet_nominal)) /
    Buildings.Utilities.Psychrometrics.Constants.cpWatLiq
    "CHW mass flow rate"
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
  parameter Data.HeatPumpSHC datHpSHC(
    final cpHeaWat_default=hpSHC.cpHeaWat_default,
    final cpSou_default=hpSHC.cpSou_default,
    final typ=hpSHC.typ,
    final is_rev=hpSHC.is_rev,
    mChiWat_flow_nominal=71.7017,
    dpChiWat_nominal(displayUnit="Pa") = 40E3,
    capCoo_nominal=1500E3,
    TChiWatSup_nominal=Buildings.Templates.Data.Defaults.TChiWatSup,
    TSouCoo_nominal=Buildings.Templates.Data.Defaults.TOutHpCoo,
    perSHC(
      fileNameHea=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_Heating.txt"),
      fileNameCoo=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_Cooling.txt"),
      fileNameShc=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_SHC.txt")),
    mHeaWat_flow_nominal=44.8136,
    dpHeaWat_nominal(displayUnit="Pa") = 30E3,
    capHea_nominal=1500E3,
    THeaWatSup_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    TSouHea_nominal=Buildings.Templates.Data.Defaults.TOutHpHeaLow,
    dpSouWwHea_nominal(displayUnit="Pa"))
    "Simultaneous heating and cooling (SHC) air-to-water heat pump record"
    annotation (Placement(transformation(extent={{-260,-138},{-240,-118}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    "Outdoor conditions"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={-250,-10})));
  Buildings.Fluid.HeatExchangers.SensibleCooler_T loaHw(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mHw_flow_nominal,
    show_T=true,
    final dp_nominal=0,
    final energyDynamics=energyDynamics,
    tau=300,
    QMin_flow=-QHea_flow_nominal)
    "HW system approximated by prescribed return temperature"
    annotation (Placement(transformation(extent={{110,-230},{130,-210}})));
  Buildings.Fluid.HeatExchangers.Heater_T loaChw(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mChw_flow_nominal,
    show_T=true,
    final dp_nominal=0,
    final energyDynamics=energyDynamics,
    tau=300,
    QMax_flow=-QCoo_flow_nominal)
    "CHW system system approximated by prescribed return temperature"
    annotation (Placement(transformation(extent={{110,-30},{130,-10}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valDisHw(
    redeclare final package Medium=Medium,
    m_flow_nominal=mHw_flow_nominal,
    dpValve_nominal=3E4,
    y_start=0,
    dpFixed_nominal=dpHwRemSet_max - 3E4)
    "Distribution system approximated by variable flow resistance"
    annotation (Placement(transformation(extent={{150,-230},{170,-210}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valDisChw(
    redeclare final package Medium=Medium,
    m_flow_nominal=mChw_flow_nominal,
    dpValve_nominal=3E4,
    y_start=0,
    dpFixed_nominal=dpChwRemSet_max - 3E4)
    "Distribution system approximated by variable flow resistance"
    annotation (Placement(transformation(extent={{150,-30},{170,-10}})));
  Buildings.Fluid.Sensors.RelativePressure dpHwRem(
    redeclare final package Medium = Medium)
    "HW differential pressure at one remote location"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={100,-240})));
  Buildings.Fluid.Sensors.RelativePressure dpChwRem(
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
  Buildings.Fluid.Sensors.MassFlowRate mChw_flow(
    redeclare final package Medium=Medium)
    "CHW mass flow rate"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={200,-40})));
  Buildings.Fluid.Sensors.MassFlowRate mHw_flow(
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
  Buildings.Templates.Components.HeatPumps.AirToWaterSHC hpSHC(
    redeclare package MediumHeaWat = Medium,
    redeclare package MediumSou = Medium,
    is_rev=false,
    final energyDynamics=energyDynamics,
    final dat=datHpSHC,
    nUni=3) "Simultaneous heating and cooling (SHC) air-to-water heat pump"
    annotation (Placement(transformation(extent={{-194,-60},{-174,-40}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TChwSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=hpSHC.hp.mEva_flow_nominal,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    T_start=TChwSup_nominal) "CHW supply temperature"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort THwSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=hpSHC.hp.mCon_flow_nominal,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    T_start=THwSup_nominal) "HW supply temperature"
    annotation (Placement(transformation(extent={{-100,-230},{-80,-210}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSupSet[2](k={
        THwSup_nominal,TChwSup_nominal}) "Supply temperature setpoints"
    annotation (Placement(transformation(extent={{-260,20},{-240,40}})));
  Buildings.Fluid.Sources.Boundary_pT pChwRet(
    redeclare final package Medium = Medium,
    p=Buildings.Templates.Data.Defaults.pChiWat_rel_nominal + 101325,
    nPorts=1) "Pressure boundary conditions at HP inlet" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-180,-100})));
  Buildings.Fluid.Sources.Boundary_pT pHwRet(
    redeclare final package Medium = Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=1) "Pressure boundary condition at HP inlet" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-180,-140})));
  Buildings.Fluid.Actuators.Valves.TwoWayTable valHwIso(
    redeclare final package Medium = Medium,
    final m_flow_nominal=hpSHC.hp.mCon_flow_nominal,
    flowCharacteristics=hpSHC.hp.chaValHwIso,
    dpValve_nominal=hpSHC.hp.dpValIso_nominal,
    init=Modelica.Blocks.Types.Init.InitialState,
    dpFixed_nominal=hpSHC.hp.dpHw_nominal)
    "Equivalent actuator for modules' condenser barrels and HW isolation valves"
    annotation (Placement(transformation(extent={{-150,-230},{-130,-210}})));
  Buildings.Fluid.Actuators.Valves.TwoWayTable valChwIso(
    redeclare final package Medium = Medium,
    final m_flow_nominal=hpSHC.hp.mEva_flow_nominal,
    dpValve_nominal=hpSHC.hp.dpValIso_nominal,
    init=Modelica.Blocks.Types.Init.InitialState,
    dpFixed_nominal=hpSHC.hp.dpChw_nominal,
    flowCharacteristics=hpSHC.hp.chaValChwIso)
    "Equivalent actuator for modules' evaporator barrels and CHW isolation valves"
    annotation (Placement(transformation(extent={{-150,-30},{-130,-10}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum sumNumUni(nin=3)
    "Total number of enabled modules"
    annotation (Placement(transformation(extent={{-260,-190},{-240,-170}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(message="Number of enabled modules exceeds number of modules")
    "Assert condition on number of enabled modules"
             annotation (Placement(transformation(extent={{-232,-230},{-212,
            -210}})));
  Buildings.Controls.OBC.CDL.Integers.LessEqualThreshold intLesEquThr(t=hpSHC.nUni)
    "True if number of enabled modules lower or equal to number of modules"
    annotation (Placement(transformation(extent={{-232,-190},{-212,-170}})));
  Buildings.Fluid.Sensors.RelativePressure dpChwHea(redeclare final package Medium =
        Medium) "Module CHW header differential pressure" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-100,-40})));
  Buildings.Fluid.Sensors.RelativePressure dpHwHea(redeclare final package Medium =
        Medium) "Module HW header differential pressure" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-100,-240})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear valChwByp(
    redeclare final package Medium = Medium,
    final m_flow_nominal=hpSHC.hp.mEva_flow_nominal/hpSHC.nUni,
    from_dp=true,
    dpValve_nominal=hpSHC.hp.dpChw_nominal,
    init=Modelica.Blocks.Types.Init.InitialState)
    "CHW minimum flow bypass valve" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={38,-40})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpHeaSet[2](k={hpSHC.hp.dpHw_nominal,
        hpSHC.hp.dpChw_nominal}) "Module header dp setpoint"
    annotation (Placement(transformation(extent={{-260,60},{-240,80}})));
  Buildings.Templates.Plants.Controls.Utilities.PIDWithEnable ctlValChwByp(
    k=1,
    Ti=60,
    r=hpSHC.hp.dpChw_nominal,
    y_reset=1,
    y_neutral=1) "CHW minimum flow bypass valve controller"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpRemSet[2](k={
        dpHwRemSet_max,dpChwRemSet_max}) "Remote dp setpoint"
    annotation (Placement(transformation(extent={{-260,100},{-240,120}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort THwRetPla(redeclare final package
      Medium = Medium, final m_flow_nominal=hpSHC.hp.mCon_flow_nominal)
    "Plant HW return temperature"
    annotation (Placement(transformation(extent={{-110,-270},{-130,-250}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TChwRetPla(redeclare final package
      Medium = Medium, final m_flow_nominal=hpSHC.hp.mEva_flow_nominal)
    "Plant CHW return temperature"
    annotation (Placement(transformation(extent={{-110,-70},{-130,-50}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear valHwByp(
    redeclare final package Medium = Medium,
    final m_flow_nominal=hpSHC.hp.mCon_flow_nominal/hpSHC.nUni,
    from_dp=true,
    dpValve_nominal=hpSHC.hp.dpHw_nominal,
    init=Modelica.Blocks.Types.Init.InitialState)
    "HW minimum flow bypass valve" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={40,-240})));
  Buildings.Templates.Plants.Controls.Utilities.PIDWithEnable ctlValHwByp(
    k=1,
    Ti=60,
    r=hpSHC.hp.dpHw_nominal,
    y_reset=1,
    y_neutral=1) "HW minimum flow bypass valve controller"
    annotation (Placement(transformation(extent={{-60,-190},{-40,-170}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TChwRet(redeclare final package
      Medium = Medium, final m_flow_nominal=hpSHC.hp.mEva_flow_nominal)
    "CHW return temperature"
    annotation (Placement(transformation(extent={{170,-70},{150,-50}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort THwRet(redeclare final package
      Medium = Medium, final m_flow_nominal=hpSHC.hp.mCon_flow_nominal)
    "HW return temperature"
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
  Buildings.Templates.Plants.Controls.Enabling.Enable enaHea(typ=Buildings.Templates.Plants.Controls.Types.Application.Heating,
      TOutLck=295.15) "Enable heating"
    annotation (Placement(transformation(extent={{50,230},{30,250}})));
  Buildings.Templates.Plants.Controls.Enabling.Enable enaCoo(typ=Buildings.Templates.Plants.Controls.Types.Application.Cooling,
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
  Buildings.Templates.Components.Routing.SingleToMultiple inlPumChwPri(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final nPorts=pumChwPri.nPum,
    final m_flow_nominal=hpSHC.hp.mEva_flow_nominal)
    "Primary CHW pumps suction header"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Buildings.Templates.Components.Pumps.Multiple pumChwPri(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    dat(
      m_flow_nominal=fill(hpSHC.hp.mEva_flow_nominal/pumChwPri.nPum, pumChwPri.nPum),
      dp_nominal=fill(dpChwLocSet_max + valChwIso.dpFixed_nominal + valChwIso.dpValve_nominal,
          pumChwPri.nPum) .+ pumChwPri.dpValChe_nominal,
      rho_default=Medium.d_const),
    final nPum=hpSHC.hp.nUni) "Primary CHW pumps"
    annotation (Placement(transformation(extent={{-20,2},{0,22}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumChwPri(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final nPorts=pumChwPri.nPum,
    final m_flow_nominal=hpSHC.hp.mEva_flow_nominal)
    "Primary CHW pumps discharge header"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Buildings.Templates.Plants.Controls.Pumps.Generic.ControlDifferentialPressure
    ctlPumChwPri(
    have_senDpRemWir=true,
    nPum=pumChwPri.nPum,
    nSenDpRem=1,
    k=0.1) "Primary CHW pump control"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChwPri
    "Primary CHW pump control bus" annotation (Placement(transformation(extent={{-70,56},
            {-30,96}}),          iconTransformation(extent={{-230,-40},{-190,0}})));
  Buildings.Fluid.Sensors.VolumeFlowRate VChwPri(redeclare final package Medium
      = Medium, final m_flow_nominal=hpSHC.hp.mEva_flow_nominal)
    "Primary CHW flow (plant side)"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Buildings.Templates.Plants.Controls.Pumps.Generic.StagingHeadered
    staPumChwPri(
    is_pri=true,
    is_hdr=true,
    is_ctlDp=true,
    have_valInlIso=false,
    have_valOutIso=true,
    nEqu=hpSHC.hp.nUni,
    nPum=pumChwPri.nPum,
    nSenDp=1,
    V_flow_nominal=hpSHC.hp.mEva_flow_nominal/Medium.d_const,
    dtRun=5*60) "Primary CHW pump staging"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Templates.Components.Routing.SingleToMultiple inlPumHwPri(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final nPorts=pumHwPri.nPum,
    final m_flow_nominal=hpSHC.hp.mCon_flow_nominal)
    "Primary HW pumps suction header"
    annotation (Placement(transformation(extent={{-40,-230},{-20,-210}})));
  Buildings.Templates.Components.Pumps.Multiple pumHwPri(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    dat(
      m_flow_nominal=fill(hpSHC.hp.mCon_flow_nominal/pumHwPri.nPum, pumHwPri.nPum),
      dp_nominal=fill(dpHwLocSet_max + valHwIso.dpFixed_nominal + valHwIso.dpFixed_nominal,
          pumHwPri.nPum) .+ pumHwPri.dpValChe_nominal,
      rho_default=Medium.d_const),
    final nPum=hpSHC.hp.nUni) "Primary HW pumps"
    annotation (Placement(transformation(extent={{-20,-230},{0,-210}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumHwPri(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final nPorts=pumHwPri.nPum,
    final m_flow_nominal=hpSHC.hp.mCon_flow_nominal)
    "Primary HW pumps discharge header"
    annotation (Placement(transformation(extent={{0,-230},{20,-210}})));
  Buildings.Fluid.Sensors.VolumeFlowRate VHwPri(redeclare final package Medium
      = Medium, final m_flow_nominal=hpSHC.hp.mCon_flow_nominal)
    "Primary HW flow (plant side)"
    annotation (Placement(transformation(extent={{-60,-230},{-40,-210}})));
  Buildings.Templates.Plants.Controls.Pumps.Generic.ControlDifferentialPressure ctlPumHwPri(
    have_senDpRemWir=true,
    nPum=pumHwPri.nPum,
    nSenDpRem=1,
    k=0.1) "Primary HW pump control"
    annotation (Placement(transformation(extent={{-60,-160},{-40,-140}})));
  Buildings.Templates.Plants.Controls.Pumps.Generic.StagingHeadered staPumHwPri(
    is_pri=true,
    is_hdr=true,
    is_ctlDp=true,
    have_valInlIso=false,
    have_valOutIso=true,
    nEqu=hpSHC.nUni,
    nPum=pumHwPri.nPum,
    nSenDp=1,
    V_flow_nominal=hpSHC.hp.mCon_flow_nominal/Medium.d_const,
    dtRun=5*60) "Primary HW pump staging"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));
  Buildings.Templates.Components.Interfaces.Bus busPumHwPri "Primary HW pump control bus"
    annotation (Placement(transformation(extent={{-70,-144},{-30,-104}}),
        iconTransformation(extent={{-230,-40},{-190,0}})));
  Buildings.Templates.Components.Interfaces.Bus busHpSHC
    "SHC air-to-water heat pump control bus" annotation (Placement(
        transformation(extent={{-200,10},{-160,50}}), iconTransformation(extent
          ={{-230,-40},{-190,0}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyPumHwPri(nin=pumHwPri.nPum)
    "True if any primary HW pump is proven on"
    annotation (Placement(transformation(extent={{-26,-104},{-6,-84}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyPumChwPri(nin=pumChwPri.nPum)
    "True if any primary CHW pump is proven on"
    annotation (Placement(transformation(extent={{-26,96},{-6,116}})));
  Buildings.Fluid.FixedResistances.Junction junChwBypSup(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final m_flow_nominal=mChw_flow_nominal*{1,-1,-1},
    final dp_nominal=fill(0, 3)) "CHW bypass supply junction"
    annotation (Placement(transformation(extent={{30,-30},{50,-10}})));
  Buildings.Fluid.FixedResistances.Junction junChwBypRet(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final m_flow_nominal=mChw_flow_nominal*{1,-1,1},
    final dp_nominal=fill(0, 3)) "CHW bypass return junction"
    annotation (Placement(transformation(extent={{50,-50},{30,-70}})));
  Buildings.Fluid.FixedResistances.Junction junHwBypSup(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final m_flow_nominal=mHw_flow_nominal*{1,-1,-1},
    final dp_nominal=fill(0, 3)) "HW bypass supply junction"
    annotation (Placement(transformation(extent={{30,-230},{50,-210}})));
  Buildings.Fluid.FixedResistances.Junction junHwBypRet(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final m_flow_nominal=mHw_flow_nominal*{1,-1,1},
    final dp_nominal=fill(0, 3)) "HW bypass return junction"
    annotation (Placement(transformation(extent={{50,-250},{30,-270}})));

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
    annotation (Line(points={{-148,180},{22,180},{22,-12},{108,-12}},
                                                                 color={0,0,127}));
  connect(max2.y, loaHw.TSet)
    annotation (Line(points={{-148,140},{20,140},{20,-212},{108,-212}},
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
  connect(ratFlo.y, ctlEquZon.u_s)
    annotation (Line(points={{-238,200},{-140,200},{-140,130},{88,130}},
                                                   color={0,0,127}));
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
  connect(valHwIso.port_b, THwSup.port_a)
    annotation (Line(points={{-130,-220},{-100,-220}},
                                                     color={0,127,255}));
  connect(valChwIso.port_b, TChwSup.port_a)
    annotation (Line(points={{-130,-20},{-80,-20}},color={0,127,255}));
  connect(sumNumUni.y,intLesEquThr. u)
    annotation (Line(points={{-238,-180},{-234,-180}},
                                             color={255,127,0}));
  connect(intLesEquThr.y,assMes. u)
    annotation (Line(points={{-210,-180},{-206,-180},{-206,-200},{-240,-200},{
          -240,-220},{-234,-220}},           color={255,0,255}));
  connect(dpHeaSet[2].y, ctlValChwByp.u_s)
    annotation (Line(points={{-238,70},{-80,70},{-80,20},{-62,20}},
                                                  color={0,0,127}));
  connect(ctlValChwByp.y, valChwByp.y) annotation (Line(points={{-38,20},{-30,
          20},{-30,-40},{26,-40}},
                              color={0,0,127}));
  connect(dpChwHea.p_rel, ctlValChwByp.u_m) annotation (Line(points={{-91,-40},
          {-84,-40},{-84,4},{-50,4},{-50,8}},   color={0,0,127}));
  connect(dpHwHea.p_rel, ctlValHwByp.u_m) annotation (Line(points={{-91,-240},{
          -74,-240},{-74,-200},{-50,-200},{-50,-192}}, color={0,0,127}));
  connect(ctlValHwByp.y, valHwByp.y) annotation (Line(points={{-38,-180},{-30,
          -180},{-30,-240},{28,-240}},color={0,0,127}));
  connect(dpHeaSet[1].y, ctlValHwByp.u_s) annotation (Line(points={{-238,70},{
          -80,70},{-80,-180},{-62,-180}}, color={0,0,127}));
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

  connect(ctlPumChwPri.y, busPumChwPri.y) annotation (Line(points={{-38,50},{
          -32,50},{-32,72},{-42,72},{-42,76},{-50,76}},
                                                    color={0,0,127}));
  connect(busPumChwPri, pumChwPri.bus) annotation (Line(
      points={{-50,76},{-10,76},{-10,22}},
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
  connect(VHwPri.V_flow, staPumHwPri.V_flow) annotation (Line(points={{-50,-209},
          {-50,-204},{-68,-204},{-68,-102},{-62,-102}}, color={0,0,127}));
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
  connect(valChwByp.port_a, junChwBypSup.port_3)
    annotation (Line(points={{38,-30},{40,-30}}, color={0,127,255}));
  connect(outPumChwPri.port_b, junChwBypSup.port_1)
    annotation (Line(points={{20,-20},{30,-20}}, color={0,127,255}));
  connect(junChwBypSup.port_2, loaChw.port_a)
    annotation (Line(points={{50,-20},{110,-20}}, color={0,127,255}));
  connect(pipChw.port_b, junChwBypRet.port_1)
    annotation (Line(points={{60,-60},{50,-60}}, color={0,127,255}));
  connect(junChwBypRet.port_3, valChwByp.port_b)
    annotation (Line(points={{40,-50},{38,-50}}, color={0,127,255}));
  connect(junChwBypRet.port_2, TChwRetPla.port_a)
    annotation (Line(points={{30,-60},{-110,-60}}, color={0,127,255}));
  connect(outPumHwPri.port_b, junHwBypSup.port_1)
    annotation (Line(points={{20,-220},{30,-220}}, color={0,127,255}));
  connect(valHwByp.port_a, junHwBypSup.port_3)
    annotation (Line(points={{40,-230},{40,-230}}, color={0,127,255}));
  connect(junHwBypSup.port_2, loaHw.port_a)
    annotation (Line(points={{50,-220},{110,-220}}, color={0,127,255}));
  connect(valHwByp.port_b, junHwBypRet.port_3)
    annotation (Line(points={{40,-250},{40,-250}}, color={0,127,255}));
  connect(pipHw.port_b, junHwBypRet.port_1)
    annotation (Line(points={{60,-260},{50,-260}}, color={0,127,255}));
  connect(junHwBypRet.port_2, THwRetPla.port_a)
    annotation (Line(points={{30,-260},{-110,-260}}, color={0,127,255}));
  connect(inlPumChwPri.ports_b, pumChwPri.ports_a)
    annotation (Line(points={{-20,-20},{-20,12}}, color={0,127,255}));
  connect(outPumChwPri.ports_a, pumChwPri.ports_b)
    annotation (Line(points={{0,-20},{0,12}}, color={0,127,255}));
  connect(pHwRet.ports[1], hpSHC.port_a) annotation (Line(points={{-190,-140},{-200,
          -140},{-200,-50},{-194,-50}}, color={0,127,255}));
  connect(hpSHC.port_b, valHwIso.port_a) annotation (Line(points={{-174,-50},{-160,
          -50},{-160,-220},{-150,-220}}, color={0,127,255}));
  connect(hpSHC.port_bSou, valChwIso.port_a) annotation (Line(points={{-194,-60},
          {-210,-60},{-210,-20},{-150,-20}}, color={0,127,255}));
  connect(weaDat.weaBus, hpSHC.busWea) annotation (Line(
      points={{-240,-10},{-190,-10},{-190,-40}},
      color={255,204,51},
      thickness=0.5));
  connect(busHpSHC, hpSHC.bus) annotation (Line(
      points={{-180,30},{-180,-40},{-184,-40}},
      color={255,204,51},
      thickness=0.5));
  connect(pChwRet.ports[1], hpSHC.port_aSou) annotation (Line(points={{-170,-100},
          {-170,-80},{-170,-60},{-174,-60}}, color={0,127,255}));
  connect(THwRetPla.port_b, hpSHC.port_a) annotation (Line(points={{-130,-260},{
          -200,-260},{-200,-50},{-194,-50}}, color={0,127,255}));
  connect(TChwRetPla.port_b, hpSHC.port_aSou)
    annotation (Line(points={{-130,-60},{-174,-60}}, color={0,127,255}));

  connect(TSupSet[2].y, busHpSHC.TChwSet)
    annotation (Line(points={{-238,30},{-180,30}}, color={0,0,127}));
  connect(TSupSet[1].y, busHpSHC.THwSet)
    annotation (Line(points={{-238,30},{-180,30}}, color={0,0,127}));
  connect(valHwIso.y, busHpSHC.yValHwIso) annotation (Line(points={{-140,-208},
          {-140,-40},{-162,-40},{-162,30},{-180,30}}, color={0,0,127}));
  connect(valChwIso.y, busHpSHC.yValChwIso)
    annotation (Line(points={{-140,-8},{-140,30},{-180,30}}, color={0,0,127}));
  connect(sumNumUni.u[1], busHpSHC.nUniShc) annotation (Line(points={{-262,
          -182.333},{-272,-182.333},{-272,-60},{-224,-60},{-224,30},{-180,30}},
        color={255,127,0}));
  connect(sumNumUni.u[2], busHpSHC.nUniCoo) annotation (Line(points={{-262,-180},
          {-268,-180},{-268,-60},{-224,-60},{-224,30},{-180,30}}, color={255,
          127,0}));
  connect(sumNumUni.u[3], busHpSHC.nUniHea) annotation (Line(points={{-262,
          -177.667},{-268,-177.667},{-268,-58},{-222,-58},{-222,30},{-180,30}},
        color={255,127,0}));
  connect(on.y, busHpSHC.y1) annotation (Line(points={{-12,220},{-220,220},{-220,
          30},{-180,30}}, color={255,0,255}));
  connect(mode.y, busHpSHC.mode) annotation (Line(points={{-152,240},{-224,240},
          {-224,30},{-180,30}}, color={255,127,0}));
  connect(staPumChwPri.u1ValOutIso, busHpSHC.y1ChwValIsoPumPri) annotation (
      Line(points={{-62,104},{-180,104},{-180,30}}, color={255,0,255}));
  connect(staPumHwPri.u1ValOutIso, busHpSHC.y1HwValIsoPumPri) annotation (Line(
        points={{-62,-96},{-158,-96},{-158,30},{-180,30}}, color={255,0,255}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Components/Validation/HeatPumpSHC.mos"
        "Simulate and plot"),
    experiment(
      Tolerance=1e-6,
      StopTime=86400.0),
    Documentation(
      info="<html>
<p>This model validates 
<a href=\"modelica://Buildings.Templates.Components.HeatPumps.AirToWaterSHC\"> 
Buildings.Templates.Components.HeatPumps.AirToWaterSHC</a>
in a primary-only heating and cooling plant over a 24-hour period with overlapping heating and cooling demands. 
In this scenario, the heating loads reach their peak first, followed by the cooling loads reaching theirs later.</p>
</html>",
      revisions="<html>
<ul>
<li>September 1, 2025, by Xing Lu, Karthik Devaprasad:<br>First implementation. </li>
</ul>
</html>"),
    Diagram(
      coordinateSystem(
        extent={{-280,-300},{280,300}}, grid={2,2})));
end HeatPumpSHC;
