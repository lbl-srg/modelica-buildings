within Buildings.Templates.Plants.HeatPumps.Validation;
model Buffalo_hybridDedicated_nonTemplate
  "Validation of AWHP plant template"
  extends Modelica.Icons.Example;
  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Main medium (common for CHW and HW)";
  replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Main medium (common for CHW and HW)";
  parameter Real mHeaWatPri_flow_nominal=datAll.pla.hp.mHeaWatHp_flow_nominal;
  parameter Real mChiWatPri_flow_nominal=datAll.pla.hp.mChiWatHp_flow_nominal;
  parameter Boolean have_chiWat=true
    "Set to true if the plant provides CHW"
    annotation (Evaluate=true,
    Dialog(group="Configuration"));
  inner parameter UserProject.Data.AllSystems datAll(pla(
      cfg(
        typ=Buildings.Templates.Components.Types.HeatPump.AirToWater,
        typMod=Buildings.Templates.Components.Types.HeatPumpModel.EquationFit,
        have_heaWat=true,
        have_hotWat=false,
        have_chiWat=true,
        have_hrc=false,
        nHp=2,
        is_rev=true,
        have_valHpInlIso=true,
        have_valHpOutIso=true,
        typCtl=Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater,
        nAirHan=1,
        nEquZon=1,
        rhoHeaWat_default(displayUnit="kg/m3") = 1000,
        cpHeaWat_default=4200,
        rhoChiWat_default(displayUnit="kg/m3") = 1000,
        cpChiWat_default=4200,
        rhoSou_default(displayUnit="kg/m3") = 1.225,
        cpSou_default=1005,
        typPumHeaWatPri=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Constant,
        nPumHeaWatPri=2,
        nPumHeaWatSec=pumHeaWatSec.nPum,
        have_valHeaWatMinByp=false,
        typArrPumPri=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
        have_pumHeaWatPriVar=false,
        typTanHeaWat=Buildings.Templates.Components.Types.IntegrationPoint.None,
        typPumHeaWatSec=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized,
        typDis=Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Variable2,
        have_senDpHeaWatRemWir=true,
        nSenDpHeaWatRem=1,
        have_pumChiWatPriDed=false,
        typPumChiWatPri=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Constant,
        nPumChiWatPri=2,
        nPumChiWatSec=pumChiWatSec.nPum,
        have_valChiWatMinByp=false,
        have_pumChiWatPriVar=false,
        typTanChiWat=Buildings.Templates.Components.Types.IntegrationPoint.None,
        typPumChiWatSec=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized,
        have_senDpChiWatRemWir=true,
        nSenDpChiWatRem=1,
        have_inpSch=true),
      ctl(THeaWatSup_nominal=333.15, TChiWatSup_nominal=279.85),
      hp(
        mHeaWatHp_flow_nominal=0.15*58,
        capHeaHp_nominal=0.45*2.7e6,
        THeaWatSupHp_nominal=333.15,
        mChiWatHp_flow_nominal=0.35*68,
        capCooHp_nominal=0.35*2.4e6,
        TChiWatSupHp_nominal=279.85)))
    "Plant parameters"
    annotation (Placement(transformation(extent={{160,158},{180,178}})));

  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation (Dialog(tab="Assumptions"),
    Evaluate=true);
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,
    Dialog(tab="Dynamics",group="Conservation equations"));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/Resources/weatherdata/USA_NY_Buffalo-Greater.Buffalo.Intl.AP.725280_TMY3.mos"))
    "Outdoor conditions"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={-490,190})));
  Fluid.HeatExchangers.SensibleCooler_T loaHeaWat(
    redeclare final package Medium=Medium,
    final m_flow_nominal=3*datAll.pla.hp.mHeaWatHp_flow_nominal,
    show_T=true,
    final dp_nominal=0,
    final energyDynamics=energyDynamics,
    tau=300,
    QMin_flow=-3*datAll.pla.hp.capHeaHp_nominal)
    "HW system approximated by prescribed return temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={172,-532})));
  Fluid.HeatExchangers.Heater_T loaChiWat(
    redeclare final package Medium=Medium,
    final m_flow_nominal=3*datAll.pla.hp.mChiWatHp_flow_nominal,
    show_T=true,
    final dp_nominal=0,
    final energyDynamics=energyDynamics,
    tau=300,
    QMax_flow=3*datAll.pla.hp.capCooHp_nominal)
    if have_chiWat
    "CHW system system approximated by prescribed return temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={120,-76})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage valDisHeaWat(
    redeclare final package Medium=Medium,
    m_flow_nominal=3*datAll.pla.hp.mHeaWatHp_flow_nominal,
    dpValve_nominal=0.1*3E4,
    dpFixed_nominal=0.1*(datAll.pla.ctl.dpHeaWatRemSet_max[1] - 3E4))
    "Distribution system approximated by variable flow resistance"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={172,-568})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage valDisChiWat(
    redeclare final package Medium=Medium,
    m_flow_nominal=3*datAll.pla.hp.mChiWatHp_flow_nominal,
    dpValve_nominal=1*3E4,
    dpFixed_nominal=1*(datAll.pla.ctl.dpChiWatRemSet_max[1] - 3E4))
    if have_chiWat
    "Distribution system approximated by variable flow resistance"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={120,-110})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TDum(
    k=293.15)
    "Placeholder signal for request generator"
    annotation (Placement(transformation(extent={{140,150},{120,170}})));
  Fluid.Sensors.RelativePressure dpHeaWatRem[1](
    redeclare each final package Medium=Medium)
    "HW differential pressure at one remote location"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={70,-530})));
  Fluid.Sensors.RelativePressure dpChiWatRem[1](
    redeclare each final package Medium=Medium)
    if have_chiWat
    "CHW differential pressure at one remote location"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=180,
      origin={30,-110})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.PlantRequests reqPlaRes(
    final heaCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased, final
      cooCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased)
    "Plant and reset request"
    annotation (Placement(transformation(extent={{90,122},{70,142}})));
  Buildings.Controls.OBC.CDL.Reals.PID ctlEquZon[2](
    controllerType={Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
        Buildings.Controls.OBC.CDL.Types.SimpleController.PI},
    k={0.1,0.1},
    Ti={45,120},
    Td={100,1e-9},
    reverseActing=fill(true,2)) "Zone equipment controller"
    annotation (Placement(transformation(extent={{70,90},{90,110}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter norFlo[2](k={1/(3*datAll.pla.hp.mHeaWatHp_flow_nominal),
        1/(3*datAll.pla.hp.mChiWatHp_flow_nominal)})
                                                   "Normalize flow rate"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={180,0})));
  Fluid.Sensors.MassFlowRate mChiWat_flow(
    redeclare final package Medium=Medium)
    if have_chiWat
    "CHW mass flow rate"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=180,
      origin={50,-140})));
  Fluid.Sensors.MassFlowRate mHeaWat_flow(
    redeclare final package Medium=Medium)
    "HW mass flow rate"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=180,
      origin={114,-588})));
  Buildings.Controls.OBC.CDL.Integers.Multiply mulInt[4]
    "Importance multiplier"
    annotation (Placement(transformation(extent={{0,122},{-20,142}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant cst[4](k={20,20,10,10})
    "Constant"
    annotation (Placement(transformation(extent={{40,170},{20,190}})));
  Buildings.Fluid.FixedResistances.PressureDrop pipHeaWat(
    redeclare final package Medium=Medium,
    final m_flow_nominal=3*datAll.pla.hp.mHeaWatHp_flow_nominal,
    final dp_nominal=Buildings.Templates.Data.Defaults.dpHeaWatLocSet_max - max(datAll.pla.ctl.dpHeaWatRemSet_max))
    "Piping"
    annotation (Placement(transformation(extent={{20,-598},{0,-578}})));
  Buildings.Fluid.FixedResistances.PressureDrop pipChiWat(
    redeclare final package Medium=Medium,
    final m_flow_nominal=3*datAll.pla.hp.mChiWatHp_flow_nominal,
    final dp_nominal=Buildings.Templates.Data.Defaults.dpChiWatLocSet_max - max(datAll.pla.ctl.dpChiWatRemSet_max))
    if have_chiWat
    "Piping"
    annotation (Placement(transformation(extent={{-2,-150},{-22,-130}})));
  Modelica.Blocks.Sources.CombiTimeTable datRea(
    final fileName=ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/Resources/Data/Templates/HeatPumpPlant/Validation/AirToWater_Buffalo.dat"),
    final tableOnFile=true,
    final columns=2:8,
    final tableName="EnergyPlus",
    final smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    timeScale=1,
    shiftTime=12355200)
    "Reader for EnergyPlus example results"
    annotation (Placement(transformation(extent={{-180,90},{-160,110}})));

  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter norFlo1[2](k={1/(3*
        datAll.pla.hp.mHeaWatHp_flow_nominal),1/(3*datAll.pla.hp.mChiWatHp_flow_nominal)})
                                                   "Normalize flow rate"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={28,100})));
  HeatPumps_PNNL.Components.Controls.RequiredFlowrate reqFloHea(has_minTemp=true)
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  HeatPumps_PNNL.Components.Controls.RequiredFlowrate reqFloCoo
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
  Fluid.Sensors.TemperatureTwoPort senTemCooSup(redeclare package Medium =
        Medium, m_flow_nominal=3*datAll.pla.hp.mChiWatHp_flow_nominal)
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Fluid.Sensors.TemperatureTwoPort senTemHeaSup(redeclare package Medium =
        Medium, m_flow_nominal=3*datAll.pla.hp.mHeaWatHp_flow_nominal)
    annotation (Placement(transformation(extent={{130,-520},{150,-500}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(p=273.15)
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar1(p=273.15)
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));

  Fluid.Movers.Preconfigured.SpeedControlled_y mov(
    redeclare package Medium = Medium,
    addPowerToMedium=false,
    m_flow_nominal=4*datAll.pla.pumChiWatPri.m_flow_nominal[1],
    dp_nominal=datAll.pla.pumChiWatPri.dp_nominal[1])
                                                   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-510,-190})));
  Buildings.Templates.Components.Routing.Junction junChiWatBypSup1(
    redeclare final package Medium = Medium,
    final m_flow_nominal=datAll.pla.hp.mChiWatHp_flow_nominal*{1,-1,1},
    final energyDynamics=energyDynamics,
    dp_nominal=fill(0, 3),
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Fluid junction"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={-146,-92})));
  Buildings.Templates.Components.Routing.Junction junChiWatBypSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=datAll.pla.hp.mChiWatHp_flow_nominal*{1,-1,-1},
    final energyDynamics=energyDynamics,
    dp_nominal=fill(0, 3),
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Fluid junction"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={-72,-92})));
  Buildings.Templates.Components.Routing.Junction junChiWatBypRet1(
    redeclare final package Medium = Medium,
    final m_flow_nominal=datAll.pla.hp.mChiWatHp_flow_nominal*{1,-1,-1},
    final energyDynamics=energyDynamics,
    dp_nominal=fill(0, 3),
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    icon_pipe1=Buildings.Templates.Components.Types.IntegrationPoint.Return,
    icon_pipe3=Buildings.Templates.Components.Types.IntegrationPoint.Supply)
                   "Fluid junction" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-146,-140})));
  Buildings.Templates.Components.Routing.Junction junHeaWatBypSup1(
    redeclare final package Medium = Medium,
    final m_flow_nominal=datAll.pla.hp.mHeaWatHp_flow_nominal*{1,-1,1},
    final energyDynamics=energyDynamics,
    dp_nominal=fill(0, 3),
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Fluid junction"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={-168,-528})));
  Buildings.Templates.Components.Routing.Junction junHeaWatBypSup2(
    redeclare final package Medium = Medium,
    final m_flow_nominal=datAll.pla.hp.mHeaWatHp_flow_nominal*{1,-1,-1},
    final energyDynamics=energyDynamics,
    dp_nominal=fill(0, 3),
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Fluid junction"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},rotation=0,
      origin={-168,-588})));
  Buildings.Templates.Components.Routing.Junction junHeaWatBypSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=datAll.pla.hp.mHeaWatHp_flow_nominal*{1,-1,-1},
    final energyDynamics=energyDynamics,
    dp_nominal=fill(0, 3),
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Fluid junction"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={-72,-508})));
  Buildings.Templates.Components.Routing.Junction junHeaWatBypRet(
    redeclare final package Medium = Medium,
    final m_flow_nominal=datAll.pla.hp.mHeaWatHp_flow_nominal*{1,-1,1},
    final energyDynamics=energyDynamics,
    dp_nominal=fill(0, 3),
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    icon_pipe1=Buildings.Templates.Components.Types.IntegrationPoint.Return,
    icon_pipe3=Buildings.Templates.Components.Types.IntegrationPoint.Supply)
                   "Fluid junction" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={-72,-588})));
  Buildings.Templates.Components.Routing.Junction junChiWatBypRet(
    redeclare final package Medium = Medium,
    final m_flow_nominal=datAll.pla.hp.mChiWatHp_flow_nominal*{1,-1,1},
    final energyDynamics=energyDynamics,
    dp_nominal=fill(0, 3),
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    icon_pipe1=Buildings.Templates.Components.Types.IntegrationPoint.Return,
    icon_pipe3=Buildings.Templates.Components.Types.IntegrationPoint.Supply)
                   "Fluid junction" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={-72,-140})));
  Fluid.HeatPumps.ModularReversible.Modular4Pipe           hp1(
    redeclare package MediumCon = Medium,
    redeclare package MediumCon1 = MediumAir,
    redeclare package MediumEva = Medium,
    use_rev=true,
    allowDifferentDeviceIdentifiers=true,
    use_intSafCtr=false,
    mCon_flow_nominal=datAll.pla.hp.mHeaWatHp_flow_nominal,
    dTCon1_nominal=40,
    dpCon1_nominal=6000,
    use_con1Cap=false,
    mEva_flow_nominal=datAll.pla.hp.mChiWatHp_flow_nominal,
    QHeaCoo_flow_nominal=datAll.pla.hp.capHeaHp_nominal,
    QCoo_flow_nominal=-datAll.pla.hp.capCooHp_nominal,
    redeclare model RefrigerantCycleHeatPumpHeating =
        Fluid.HeatPumps.ModularReversible.RefrigerantCycle.ConstantCarnotEffectiveness
        (TAppCon_nominal=0, TAppEva_nominal=0),
    redeclare model RefrigerantCycleHeatPumpCooling =
        Fluid.Chillers.ModularReversible.RefrigerantCycle.TableData2D (
        redeclare
          Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.NoFrosting
          iceFacCal,
        mCon_flow_nominal=hp1.mCon_flow_nominal,
        mEva_flow_nominal=hp1.mEva_flow_nominal,
        datTab=
            Buildings.Fluid.Chillers.ModularReversible.Data.TableData2D.EN14511.Vitocal251A08()),
    redeclare model RefrigerantCycleHeatPumpHeatingCooling =
        Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData2D2 (
        redeclare
          Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.NoFrosting
          iceFacCal,
        mCon_flow_nominal=hp1.mCon1_flow_nominal,
        mEva_flow_nominal=hp1.mEva_flow_nominal,
        datTab=
            Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2D.EN14511.Vitocal251A08()),
    redeclare model RefrigerantCycleInertia =
        Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Inertias.VariableOrder
        (
        refIneFreConst=1/300,
        nthOrd=1,
        initType=Modelica.Blocks.Types.Init.InitialState),
    TConCoo_nominal=308.15,
    dpCon_nominal(displayUnit="Pa") = 0.75*datAll.pla.pumChiWatPri.dp_nominal[1],
    use_conCap=false,
    CCon=0,
    GConOut=0,
    GConIns=0,
    TEvaCoo_nominal=279.95,
    dTEva_nominal=6,
    dTCon_nominal=20,
    dpEva_nominal(displayUnit="Pa") = 0.75*datAll.pla.pumChiWatPri.dp_nominal[1],
    use_evaCap=false,
    CEva=0,
    GEvaOut=0,
    GEvaIns=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    show_T=true,
    QHea_flow_nominal=datAll.pla.hp.capHeaHp_nominal,
    TEvaHea_nominal=273.15,
    TConHea_nominal=313.15,
    TConHeaCoo_nominal=333.15,
    TEvaHeaCoo_nominal=279.95,
    con1(T_start=298.15),
    con(T_start=313.15),
    eva(T_start=283.15))    "Modular reversible 4pipe heat pump instance"
    annotation (Placement(transformation(extent={{-146,-426},{-126,-446}})));
public
  Fluid.FixedResistances.CheckValve cheVal(
    redeclare package Medium = Medium,
    m_flow_nominal=datAll.pla.hp.mHeaWatHp_flow_nominal,
    dpValve_nominal=1e-9)
    annotation (Placement(transformation(extent={{-210,-456},{-190,-436}})));
  Fluid.Movers.Preconfigured.SpeedControlled_y     mov1(redeclare package
      Medium = Medium, m_flow_nominal=datAll.pla.hp.mHeaWatHp_flow_nominal,
    dp_nominal=datAll.pla.pumChiWatPri.dp_nominal[1])
    annotation (Placement(transformation(extent={{-182,-436},{-162,-456}})));
  Fluid.Movers.Preconfigured.SpeedControlled_y     mov2(redeclare package
      Medium = Medium,
    addPowerToMedium=false,
    m_flow_nominal=4*datAll.pla.hp.mChiWatHp_flow_nominal,
    dp_nominal=datAll.pla.pumChiWatPri.dp_nominal[1])
    annotation (Placement(transformation(extent={{-90,-436},{-110,-416}})));
  Fluid.FixedResistances.CheckValve cheVal1(
    redeclare package Medium = Medium,
    m_flow_nominal=datAll.pla.hp.mChiWatHp_flow_nominal,
    dpValve_nominal=1e-9)
    annotation (Placement(transformation(extent={{-52,-436},{-72,-416}})));

  Controls.HeatPumps.AirToWater_hybridPlant ctlHea(
    have_heaWat=true,
    has_sort=false,
    have_chiWat=false,
    have_hrc_select=true,
    have_valHpInlIso=false,
    have_valHpOutIso=false,
    have_pumChiWatPriDed_select=true,
    have_pumPriHdr=false,
    is_priOnl=false,
    have_pumHeaWatPriVar_select=false,
    have_pumChiWatPriVar_select=false,
    have_senVHeaWatPri_select=false,
    have_senVChiWatPri_select=false,
    have_senTHeaWatPriRet_select=false,
    have_senTChiWatPriRet_select=false,
    nHp=2,
    is_heaRec={false,true},
    nPumHeaWatSec=4,
    nPumChiWatSec=1,
    have_senDpHeaWatRemWir=true,
    nSenDpHeaWatRem=1,
    have_senDpChiWatRemWir=true,
    nSenDpChiWatRem=1,
    final THeaWatSup_nominal=333.15,
    THeaWatSupSet_min=318.15,
    TOutHeaWatLck=303.15,
    VHeaWatHp_flow_nominal=1.1*fill(ctlHea.VHeaWatSec_flow_nominal/ctlHea.nHp,
        ctlHea.nHp),
    VHeaWatHp_flow_min=0.6*ctlHea.VHeaWatHp_flow_nominal,
    final VHeaWatSec_flow_nominal=ctlHea.nHp*datAll.pla.hp.mHeaWatHp_flow_nominal
        /1000,
    capHeaHp_nominal=fill(datAll.pla.hp.capHeaHp_nominal, ctlHea.nHp),
    dpHeaWatRemSet_max={7E4},
    final TChiWatSup_nominal=279.95,
    TChiWatSupSet_max=288.15,
    TOutChiWatLck=283.15,
    VChiWatHp_flow_nominal=1.1*fill(ctlHea.VChiWatSec_flow_nominal/ctlHea.nHp,
        ctlHea.nHp),
    VChiWatHp_flow_min=0.6*ctlHea.VChiWatHp_flow_nominal,
    final VChiWatSec_flow_nominal=ctlHea.nHp*datAll.pla.hp.mChiWatHp_flow_nominal
        /1000,
    capCooHp_nominal=fill(datAll.pla.hp.capCooHp_nominal, ctlHea.nHp),
    yPumHeaWatPriSet=0.8,
    yPumChiWatPriSet=0.7,
    dpChiWatRemSet_max={1E6},
    staEquCooHea=[0,1; 1,1],
    staEquOneMod=[1,0; 1,1],
    nEquAlt=2,
    idxEquAlt={1,2},
    kCtlDpHeaWat=100,
    TiCtlDpHeaWat=1e-3,
    TChiWatSupHrc_min=277.15,
    THeaWatSupHrc_max=333.15,
    COPHeaHrc_nominal=2.8,
    capCooHrc_min=ctlHea.capHeaHrc_min*(1 - 1/ctlHea.COPHeaHrc_nominal),
    capHeaHrc_min=0.3*0.5*sum(ctlHea.capHeaHp_nominal)) "Plant controller"
    annotation (Placement(transformation(extent={{-620,-4},{-580,68}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(k=Buildings.Fluid.HeatPumps.ModularReversible.Types.Modes.AmbientCooling)
    annotation (Placement(transformation(extent={{-410,-486},{-390,-466}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu2
    annotation (Placement(transformation(extent={{-370,-486},{-350,-466}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(k=Buildings.Fluid.HeatPumps.ModularReversible.Types.Modes.AmbientHeating)
    annotation (Placement(transformation(extent={{-410,-516},{-390,-496}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1
    annotation (Placement(transformation(extent={{-370,-516},{-350,-496}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    annotation (Placement(transformation(extent={{-420,-400},{-400,-380}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    annotation (Placement(transformation(extent={{-420,-370},{-400,-350}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea3
    annotation (Placement(transformation(extent={{-380,-370},{-360,-350}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea4
    annotation (Placement(transformation(extent={{-380,-400},{-360,-380}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul1
    annotation (Placement(transformation(extent={{-260,-416},{-240,-396}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul
    annotation (Placement(transformation(extent={{-260,-366},{-240,-346}})));
  Buildings.Controls.OBC.CDL.Reals.PIDWithReset
                                       conPIDCoo(
    k=0.2,
    Ti=15,                                       reverseActing=false)
    annotation (Placement(transformation(extent={{-180,-340},{-200,-320}})));
  Buildings.Controls.OBC.CDL.Reals.Add add2
    annotation (Placement(transformation(extent={{-230,-386},{-210,-366}})));
  Buildings.Controls.OBC.CDL.Reals.PIDWithReset
                                       conPIDHea(k=0.05, Ti=60)
    annotation (Placement(transformation(extent={{-100,-486},{-80,-466}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    annotation (Placement(transformation(extent={{-10,-396},{-30,-376}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr(t=0.05, h=0.02)
    annotation (Placement(transformation(extent={{-120,-416},{-140,-396}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr1(t=0.05, h=0.02)
    annotation (Placement(transformation(extent={{-180,-520},{-200,-500}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr2(t=50, h=10)
    annotation (Placement(transformation(extent={{-30,-430},{-10,-410}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
    annotation (Placement(transformation(extent={{-10,-466},{-30,-446}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerExtractor extIndInt(nin=3)
    annotation (Placement(transformation(extent={{-480,-500},{-460,-480}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[3](k={Buildings.Fluid.HeatPumps.ModularReversible.Types.Modes.AmbientCooling,
        Buildings.Fluid.HeatPumps.ModularReversible.Types.Modes.AmbientHeating,
        Buildings.Fluid.HeatPumps.ModularReversible.Types.Modes.HeatingCooling})
    annotation (Placement(transformation(extent={{-520,-500},{-500,-480}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr3(t=0.05, h=0.02)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-480,-190})));
  Fluid.Sensors.TemperatureTwoPort senTem(redeclare package Medium = Medium,
      m_flow_nominal=datAll.pla.hp.mChiWatHp_flow_nominal) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-160,-360})));
  Fluid.Sensors.TemperatureTwoPort senTem1(redeclare package Medium = Medium,
      m_flow_nominal=datAll.pla.hp.mHeaWatHp_flow_nominal) annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-114,-446})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    annotation (Placement(transformation(extent={{-100,-340},{-80,-320}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea2
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea5
    annotation (Placement(transformation(extent={{20,-480},{40,-460}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea6[2] annotation (
     Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-470,-150})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul2
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul3
    annotation (Placement(transformation(extent={{60,-490},{80,-470}})));
  Fluid.Sensors.TemperatureTwoPort senTem2(redeclare package Medium = Medium,
      m_flow_nominal=3*datAll.pla.hp.mChiWatHp_flow_nominal) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-122,-92})));
  Fluid.Sensors.VolumeFlowRate senVolFlo(redeclare package Medium = Medium,
      m_flow_nominal=2*datAll.pla.hp.mChiWatHp_flow_nominal)
    annotation (Placement(transformation(extent={{-106,-102},{-86,-82}})));
  Fluid.Sensors.TemperatureTwoPort senTem3(redeclare package Medium = Medium,
      m_flow_nominal=3*datAll.pla.hp.mChiWatHp_flow_nominal) annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-122,-140})));
  Fluid.Sensors.VolumeFlowRate senVolFlo1(redeclare package Medium = Medium,
      m_flow_nominal=2*datAll.pla.hp.mChiWatHp_flow_nominal)
    annotation (Placement(transformation(extent={{-88,-150},{-108,-130}})));
  Fluid.Sensors.TemperatureTwoPort senTem4(redeclare package Medium = Medium,
      m_flow_nominal=3*datAll.pla.hp.mHeaWatHp_flow_nominal) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-138,-528})));
  Fluid.Sensors.VolumeFlowRate senVolFlo2(redeclare package Medium = Medium,
      m_flow_nominal=3*datAll.pla.hp.mHeaWatHp_flow_nominal)
    annotation (Placement(transformation(extent={{-120,-538},{-100,-518}})));
  Fluid.Sensors.VolumeFlowRate senVolFlo3(redeclare package Medium = Medium,
      m_flow_nominal=3*datAll.pla.hp.mHeaWatHp_flow_nominal)
    annotation (Placement(transformation(extent={{-90,-598},{-110,-578}})));
  Fluid.Sensors.TemperatureTwoPort senTem5(redeclare package Medium = Medium,
      m_flow_nominal=3*datAll.pla.hp.mHeaWatHp_flow_nominal) annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-134,-588})));
  BoundaryConditions.WeatherData.Bus
      weaBus "Weather data bus" annotation (Placement(transformation(extent={{-438,
            140},{-364,210}}),   iconTransformation(extent={{-406,148},{-386,168}})));
  Buildings.Templates.Components.Interfaces.Bus busSen annotation (Placement(
        transformation(extent={{42,-254},{82,-214}}), iconTransformation(extent
          ={{-980,164},{-940,204}})));
  Buildings.Templates.Components.Interfaces.Bus busSen2 annotation (Placement(
        transformation(extent={{-672,-20},{-632,20}}), iconTransformation(
          extent={{-980,164},{-940,204}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter norFlo2(k=1/1000)
    "Normalize flow rate" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={80,-184})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter norFlo3(k=1/1000)
    "Normalize flow rate" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={120,-290})));
  Fluid.Sources.Boundary_pT bou(redeclare package Medium = Medium, nPorts=2)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-560,-140})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre[pumHeaWatSec.nPum]
    annotation (Placement(transformation(extent={{-600,100},{-620,120}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre1[pumChiWatSec.nPum]
    annotation (Placement(transformation(extent={{-350,0},{-370,20}})));
  Fluid.Sources.Outside out(redeclare package Medium = MediumAir, nPorts=3)
    annotation (Placement(transformation(extent={{-640,-340},{-620,-320}})));
  Fluid.Movers.Preconfigured.SpeedControlled_y     mov5(
    redeclare package Medium = MediumAir,
    addPowerToMedium=false,
    m_flow_nominal=10*hp1.mCon1_flow_nominal,
    dp_nominal=2*hp1.dpCon_nominal)
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-248,-484})));
  Buildings.Controls.OBC.CDL.Logical.Xor xor
    annotation (Placement(transformation(extent={{-320,-490},{-300,-470}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea7
    annotation (Placement(transformation(extent={{-294,-490},{-274,-470}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TDum1(k=30)
    "Placeholder signal for request generator"
    annotation (Placement(transformation(extent={{-160,160},{-140,180}})));
  Buildings.Templates.Components.HeatPumps.AirToWater hpDed(
    redeclare package MediumHeaWat = Medium,
    redeclare package MediumAir = MediumAir,
    is_rev=false,
    dat(
      mHeaWat_flow_nominal=datAll.pla.hp.mHeaWatHp_flow_nominal,
      dpHeaWat_nominal(displayUnit="Pa") = 0.75*datAll.pla.pumChiWatPri.dp_nominal[
        1],
      capHea_nominal=datAll.pla.hp.capHeaHp_nominal,
      THeaWatSup_nominal=333.15,
      TSouHea_nominal=283.15,
      perFit=datAll.pla.hp.perFitHp))
    annotation (Placement(transformation(extent={{-580,-280},{-560,-260}})));
  Buildings.Templates.Components.Chillers.Compression chiDed(
    redeclare package MediumChiWat = Medium,
    redeclare package MediumCon = MediumAir,
    dat=datChi,
    typ=Buildings.Templates.Components.Types.Chiller.AirCooled)
    annotation (Placement(transformation(extent={{-500,-260},{-480,-280}})));
  parameter
    Fluid.Chillers.Data.ElectricReformulatedEIR.ReformEIRChiller_York_YT_1396kW_7_35COP_Vanes
    datChiPerFit
    annotation (Placement(transformation(extent={{-658,-98},{-638,-78}})));
  Fluid.Movers.Preconfigured.SpeedControlled_y     mov6(
    redeclare package Medium = MediumAir,
    addPowerToMedium=false,
    m_flow_nominal=10*datChi.mCon_flow_nominal,
    dp_nominal=2*hp1.dpCon_nominal)
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-520,-300})));
  Fluid.Movers.Preconfigured.SpeedControlled_y mov7(
    redeclare package Medium = Medium,
    m_flow_nominal=datAll.pla.pumHeaWatPri.m_flow_nominal[1],
    dp_nominal=datAll.pla.pumHeaWatPri.dp_nominal[1])
                                                   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-590,-190})));
  Controls.HeatPumps.AirToWater_hybridPlant ctlCoo(
    have_heaWat=false,
    has_sort=false,
    have_chiWat=true,
    have_hrc_select=true,
    have_valHpInlIso=false,
    have_valHpOutIso=false,
    have_pumChiWatPriDed_select=true,
    have_pumPriHdr=false,
    is_priOnl=false,
    have_pumHeaWatPriVar_select=false,
    have_pumChiWatPriVar_select=false,
    have_senVHeaWatPri_select=false,
    have_senVChiWatPri_select=false,
    have_senTHeaWatPriRet_select=false,
    have_senTChiWatPriRet_select=false,
    nHp=2,
    is_heaRec={false,true},
    nPumHeaWatSec=1,
    nPumChiWatSec=4,
    have_senDpHeaWatRemWir=true,
    nSenDpHeaWatRem=1,
    have_senDpChiWatRemWir=true,
    nSenDpChiWatRem=1,
    final THeaWatSup_nominal=333.15,
    THeaWatSupSet_min=318.15,
    TOutHeaWatLck=303.15,
    VHeaWatHp_flow_nominal=1.1*fill(ctlHea.VHeaWatSec_flow_nominal/ctlHea.nHp,
        ctlHea.nHp),
    VHeaWatHp_flow_min=0.6*ctlHea.VHeaWatHp_flow_nominal,
    final VHeaWatSec_flow_nominal=ctlHea.nHp*datAll.pla.hp.mHeaWatHp_flow_nominal
        /1000,
    capHeaHp_nominal=fill(datAll.pla.hp.capHeaHp_nominal, ctlHea.nHp),
    dpHeaWatRemSet_max={7E4},
    final TChiWatSup_nominal=279.95,
    TChiWatSupSet_max=283.15,
    TOutChiWatLck=283.15,
    VChiWatHp_flow_nominal=1.1*fill(ctlHea.VChiWatSec_flow_nominal/ctlHea.nHp,
        ctlHea.nHp),
    VChiWatHp_flow_min=0.6*ctlHea.VChiWatHp_flow_nominal,
    final VChiWatSec_flow_nominal=ctlHea.nHp*datAll.pla.hp.mChiWatHp_flow_nominal
        /1000,
    capCooHp_nominal=fill(datAll.pla.hp.capCooHp_nominal, ctlCoo.nHp),
    yPumHeaWatPriSet=0.8,
    yPumChiWatPriSet=0.7,
    dpChiWatRemSet_max={1E5},
    staEquCooHea=[0,1; 1,1],
    staEquOneMod=[1,0; 1,1],
    nEquAlt=2,
    idxEquAlt={1,2},
    kCtlDpHeaWat=100,
    TiCtlDpHeaWat=1e-3,
    kCtlDpChiWat=100,
    TiCtlDpChiWat=1e-3,
    TChiWatSupHrc_min=277.15,
    THeaWatSupHrc_max=333.15,
    COPHeaHrc_nominal=2.8,
    capCooHrc_min=ctlHea.capHeaHrc_min*(1 - 1/ctlHea.COPHeaHrc_nominal),
    capHeaHrc_min=0.3*0.5*sum(ctlHea.capHeaHp_nominal)) "Plant controller"
    annotation (Placement(transformation(extent={{-380,-86},{-340,-14}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr6(t=0.05, h=0.02)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-560,-190})));
  Buildings.Templates.Components.Interfaces.Bus busHP annotation (Placement(
        transformation(extent={{-660,-180},{-620,-140}}), iconTransformation(
          extent={{-980,164},{-940,204}})));
  Buildings.Templates.Components.Interfaces.Bus busChi annotation (Placement(
        transformation(extent={{-432,-174},{-392,-134}}), iconTransformation(
          extent={{-980,164},{-940,204}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt
    annotation (Placement(transformation(extent={{-540,80},{-520,100}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1
    annotation (Placement(transformation(extent={{-300,-10},{-280,10}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply mulInt1
    annotation (Placement(transformation(extent={{-500,80},{-480,100}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply mulInt2
    annotation (Placement(transformation(extent={{-260,-10},{-240,10}})));
  Buildings.Controls.OBC.CDL.Integers.Add addInt
    annotation (Placement(transformation(extent={{-380,80},{-360,100}})));
  parameter Buildings.Templates.Components.Data.Chiller datChi(
    use_datDes=true,
    mChiWat_flow_nominal=datAll.pla.hp.mChiWatHp_flow_nominal,
    cap_nominal=datAll.pla.hp.capCooHp_nominal,
    COP_nominal=datChiPerFit.COP_nominal,
    dpChiWat_nominal(displayUnit="Pa") = 0.75*datAll.pla.pumChiWatPri.dp_nominal[
      1],
    dpCon_nominal(displayUnit="Pa") = 3000,
    TChiWatSup_nominal=279.95,
    TConEnt_nominal=303.15,
    TConLvg_nominal=308.15,
    per=datChiPerFit)
    annotation (Placement(transformation(extent={{-520,-60},{-500,-40}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea8 annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-550,-250})));
  Buildings.Templates.Components.Pumps.Multiple pumHeaWatSec(
    have_valChe=true,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    redeclare final package Medium = Medium,
    final have_var=true,
    final have_varCom=true,
    nPum=4,
    dat=datAll.pla.pumHeaWatSec) "Secondary HHW pumps"
    annotation (Placement(transformation(extent={{8,-700},{28,-680}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumHeaWatSec(
    redeclare final package Medium = Medium,
    final nPorts=pumHeaWatSec.nPum,
    final m_flow_nominal=3*datAll.pla.hp.mHeaWatHp_flow_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    final icon_pipe=Buildings.Templates.Components.Types.IntegrationPoint.Supply,
    final icon_dy=300) "Secondary CHW pumps outlet manifold"
    annotation (Placement(transformation(extent={{34,-700},{54,-680}})));

  Buildings.Templates.Components.Routing.SingleToMultiple inlPumHeaWatSec(
    redeclare final package Medium = Medium,
    final nPorts=pumHeaWatSec.nPum,
    final m_flow_nominal=3*datAll.pla.hp.mHeaWatHp_flow_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    final icon_pipe=Buildings.Templates.Components.Types.IntegrationPoint.Supply,
    final icon_dy=300) "Secondary CHW pumps inlet manifold"
    annotation (Placement(transformation(extent={{-20,-700},{0,-680}})));

  Buildings.Templates.Components.Interfaces.Bus busPumSecHeaWat annotation (
      Placement(transformation(extent={{-350,90},{-310,130}}),
        iconTransformation(extent={{-980,164},{-940,204}})));
  Buildings.Templates.Components.Routing.SingleToMultiple inlPumChiWatSec(
    redeclare final package Medium = Medium,
    final nPorts=pumChiWatSec.nPum,
    final m_flow_nominal=3*datAll.pla.hp.mChiWatHp_flow_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    final icon_pipe=Buildings.Templates.Components.Types.IntegrationPoint.Supply,
    final icon_dy=300) "Secondary CHW pumps inlet manifold"
    annotation (Placement(transformation(extent={{-32,268},{-12,288}})));

  Buildings.Templates.Components.Pumps.Multiple pumChiWatSec(
    have_valChe=true,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    redeclare final package Medium = Medium,
    final have_var=true,
    final have_varCom=true,
    nPum=4,
    dat=datAll.pla.pumChiWatSec) "Secondary CHW pumps"
    annotation (Placement(transformation(extent={{-4,268},{16,288}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumChiWatSec(
    redeclare final package Medium = Medium,
    final nPorts=pumChiWatSec.nPum,
    final m_flow_nominal=3*datAll.pla.hp.mChiWatHp_flow_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    final icon_pipe=Buildings.Templates.Components.Types.IntegrationPoint.Supply,
    final icon_dy=300) "Secondary CHW pumps outlet manifold"
    annotation (Placement(transformation(extent={{22,268},{42,288}})));

  Buildings.Templates.Components.Interfaces.Bus busPumSecChiWat annotation (
      Placement(transformation(extent={{-360,164},{-320,204}}),
        iconTransformation(extent={{-980,164},{-940,204}})));
  Fluid.Sensors.VolumeFlowRate senVolFlo4(redeclare package Medium = Medium,
      m_flow_nominal=datAll.pla.hp.mChiWatHp_flow_nominal)
    annotation (Placement(transformation(extent={{-222,-102},{-202,-82}})));
  Fluid.Sensors.VolumeFlowRate senVolFlo5(redeclare package Medium = Medium,
      m_flow_nominal=datAll.pla.hp.mChiWatHp_flow_nominal)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-160,-182})));
  Fluid.Sensors.VolumeFlowRate senVolFlo6(redeclare package Medium = Medium,
      m_flow_nominal=2*datAll.pla.hp.mChiWatHp_flow_nominal)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-66,-116})));
  Fluid.Sensors.TemperatureTwoPort senTem6(redeclare package Medium = Medium,
      m_flow_nominal=datAll.pla.hp.mChiWatHp_flow_nominal)   annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-256,-92})));
  Fluid.Sensors.TemperatureTwoPort senTem7(redeclare package Medium = MediumAir,
      m_flow_nominal=datChi.mCon_flow_nominal)               annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-470,-310})));
  Fluid.Sources.Boundary_pT bou1(redeclare package Medium = MediumAir, nPorts=1)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-560,-320})));
  Fluid.Sensors.TemperatureTwoPort senTem8(redeclare package Medium = MediumAir,
      m_flow_nominal=datChi.mCon_flow_nominal)               annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-470,-332})));
  Modelica.Blocks.Sources.CombiTimeTable datRea1(
    final fileName=ModelicaServices.ExternalReferences.loadResource(
        "modelica://Buildings/Resources/Data/Templates/HeatPumpPlant/Validation/AirToWater_Buffalo.dat"),
    final tableOnFile=true,
    final columns=2:8,
    final tableName="EnergyPlus",
    final smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    timeScale=1,
    shiftTime=-3628800)
    "Reader for EnergyPlus example results"
    annotation (Placement(transformation(extent={{-240,140},{-220,160}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi
    annotation (Placement(transformation(extent={{-220,70},{-200,90}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt3(k=3)
    annotation (Placement(transformation(extent={{-320,80},{-300,100}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    annotation (Placement(transformation(extent={{-230,-30},{-210,-10}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu3
    annotation (Placement(transformation(extent={{-370,-620},{-350,-600}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt4(k=Buildings.Fluid.HeatPumps.ModularReversible.Types.Modes.HeatingCooling)
    annotation (Placement(transformation(extent={{-410,-620},{-390,-600}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    annotation (Placement(transformation(extent={{-300,-530},{-280,-510}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul5
    annotation (Placement(transformation(extent={{-320,-400},{-300,-380}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr4(t=278)
    annotation (Placement(transformation(extent={{-240,-280},{-260,-260}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea9
    annotation (Placement(transformation(extent={{-280,-280},{-300,-260}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul4
    annotation (Placement(transformation(extent={{-320,-370},{-300,-350}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold lesThr(t=273.15 + 70)
    annotation (Placement(transformation(extent={{-260,-630},{-240,-610}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea10
    annotation (Placement(transformation(extent={{-220,-630},{-200,-610}})));
equation
  if have_chiWat then
  end if;
  connect(loaChiWat.port_b, valDisChiWat.port_a)
    annotation (Line(points={{120,-86},{120,-100}},
                                                 color={0,127,255}));
  connect(loaHeaWat.port_b, valDisHeaWat.port_a)
    annotation (Line(points={{172,-542},{172,-558}},
                                                   color={0,127,255}));
  connect(TDum.y, reqPlaRes.TAirSup)
    annotation (Line(points={{118,160},{112,160},{112,140},{92,140}}, color={0,0,127}));
  connect(TDum.y, reqPlaRes.TAirSupSet)
    annotation (Line(points={{118,160},{112,160},{112,135},{92,135}}, color={0,0,127}));
  connect(valDisChiWat.y_actual, reqPlaRes.uCooCoiSet)
    annotation (Line(points={{127,-115},{127,-116},{156,-116},{156,129},{92,129}},
                                                                     color={0,0,127}));
  connect(valDisHeaWat.y_actual, reqPlaRes.uHeaCoiSet)
    annotation (Line(points={{179,-573},{184,-573},{184,-574},{208,-574},{208,
          20},{184,20},{184,68},{108,68},{108,120},{100,120},{100,124},{92,124}},
                                                                       color={0,0,127}));
  connect(valDisChiWat.port_b, mChiWat_flow.port_a)
    annotation (Line(points={{120,-120},{120,-140},{60,-140}},
                                                            color={0,127,255}));
  connect(valDisHeaWat.port_b, mHeaWat_flow.port_a)
    annotation (Line(points={{172,-578},{172,-588},{124,-588}},color={0,127,255}));
  connect(mHeaWat_flow.m_flow, norFlo[1].u)
    annotation (Line(points={{114,-599},{114,-608},{132,-608},{132,-516},{120,
          -516},{120,-392},{148,-392},{148,-160},{180,-160},{180,-12}},
                                                              color={0,0,127}));
  connect(mChiWat_flow.m_flow, norFlo[2].u)
    annotation (Line(points={{50,-151},{50,-160},{180,-160},{180,-12}},
                                                            color={0,0,127}));
  connect(norFlo.y, ctlEquZon.u_m)
    annotation (Line(points={{180,12},{180,60},{80,60},{80,88}},color={0,0,127}));
  connect(ctlEquZon[2].y, valDisChiWat.y)
    annotation (Line(points={{92,100},{100,100},{100,-136},{132,-136},{132,-110}},
      color={0,0,127}));
  connect(ctlEquZon[1].y, valDisHeaWat.y)
    annotation (Line(points={{92,100},{100,100},{100,-136},{204,-136},{204,-568},
          {184,-568}},
      color={0,0,127}));
  connect(cst.y, mulInt.u1)
    annotation (Line(points={{18,180},{6,180},{6,138},{2,138}},color={255,127,0}));
  connect(mChiWat_flow.port_b, pipChiWat.port_a)
    annotation (Line(points={{40,-140},{-2,-140}},           color={0,127,255}));
  connect(mHeaWat_flow.port_b, pipHeaWat.port_a)
    annotation (Line(points={{104,-588},{20,-588}},           color={0,127,255}));
  connect(norFlo1.y, ctlEquZon.u_s)
    annotation (Line(points={{40,100},{68,100}}, color={0,0,127}));
  connect(datRea.y[7], reqFloHea.TSupRef) annotation (Line(points={{-159,100},{
          -130,100},{-130,108},{-122,108}}, color={0,0,127}));
  connect(datRea.y[4], reqFloHea.TRetRef) annotation (Line(points={{-159,100},{
          -130,100},{-130,104},{-122,104}}, color={0,0,127}));
  connect(datRea.y[5], reqFloHea.mRef_flow) annotation (Line(points={{-159,100},
          {-132,100},{-132,100},{-122,100}},
                                           color={0,0,127}));
  connect(senTemCooSup.port_b, loaChiWat.port_a)
    annotation (Line(points={{60,-60},{120,-60},{120,-66}},
                                                 color={0,127,255}));
  connect(senTemHeaSup.port_b, loaHeaWat.port_a)
    annotation (Line(points={{150,-510},{172,-510},{172,-522}},
                                                   color={0,127,255}));
  connect(senTemHeaSup.T, reqFloHea.TSupMea) annotation (Line(points={{140,-499},
          {140,56},{-154,56},{-154,96},{-122,96}},                      color={
          0,0,127}));
  connect(datRea.y[4], addPar.u) annotation (Line(points={{-159,100},{-132,100},
          {-132,70},{-122,70}}, color={0,0,127}));
  connect(addPar1.y, loaChiWat.TSet)
    annotation (Line(points={{-98,0},{128,0},{128,-64}},
                                                       color={0,0,127}));
  connect(datRea.y[6], reqFloCoo.TSupRef) annotation (Line(points={{-159,100},{
          -132,100},{-132,38},{-122,38}}, color={0,0,127}));
  connect(datRea.y[2], reqFloCoo.TRetRef) annotation (Line(points={{-159,100},{
          -132,100},{-132,34},{-122,34}}, color={0,0,127}));
  connect(senTemCooSup.T, reqFloCoo.TSupMea) annotation (Line(points={{50,-49},
          {50,4},{-90,4},{-90,46},{-130,46},{-130,26},{-122,26}}, color={0,0,
          127}));
  connect(junHeaWatBypSup.port_3, junHeaWatBypRet.port_3)
    annotation (Line(points={{-72,-518},{-72,-578}}, color={0,127,255}));
  connect(junHeaWatBypSup2.port_3, cheVal.port_a) annotation (Line(points={{-168,
          -578},{-154,-578},{-154,-472},{-212,-472},{-212,-464},{-220,-464},{-220,
          -446},{-210,-446}}, color={0,127,255}));
  connect(cheVal.port_b, mov1.port_a)
    annotation (Line(points={{-190,-446},{-182,-446}}, color={0,127,255}));
  connect(mov1.port_b, hp1.port_a1)
    annotation (Line(points={{-162,-446},{-146,-446}}, color={0,127,255}));
  connect(cheVal1.port_b, mov2.port_a)
    annotation (Line(points={{-72,-426},{-90,-426}}, color={0,127,255}));
  connect(mov2.port_b, hp1.port_a2)
    annotation (Line(points={{-110,-426},{-126,-426}}, color={0,127,255}));
  connect(junChiWatBypRet1.port_3, cheVal1.port_a) annotation (Line(points={{-146,
          -150},{-146,-264},{-44,-264},{-44,-426},{-52,-426}},color={0,127,255}));
  connect(junChiWatBypRet.port_1, pipChiWat.port_b) annotation (Line(points={{-62,
          -140},{-22,-140}},                                             color={
          0,127,255}));
  connect(junHeaWatBypRet.port_1, pipHeaWat.port_b) annotation (Line(points={{-62,
          -588},{0,-588}},                                           color={0,127,
          255}));
  connect(conInt.y, extIndInt.u)
    annotation (Line(points={{-498,-490},{-482,-490}},
                                                 color={255,127,0}));

  connect(conInt2.y, intEqu2.u1)
    annotation (Line(points={{-388,-476},{-372,-476}}, color={255,127,0}));
  connect(conInt1.y, intEqu1.u1)
    annotation (Line(points={{-388,-506},{-372,-506}}, color={255,127,0}));
  connect(extIndInt.y, intEqu2.u2) annotation (Line(points={{-458,-490},{-452,-490},
          {-452,-456},{-380,-456},{-380,-484},{-372,-484}},
                              color={255,127,0}));
  connect(extIndInt.y, intEqu1.u2) annotation (Line(points={{-458,-490},{-424,-490},
          {-424,-524},{-372,-524},{-372,-514}},
                  color={255,127,0}));
  connect(mov2.y_actual, greThr.u) annotation (Line(points={{-111,-419},{-118,-419},
          {-118,-406}}, color={0,0,127}));
  connect(mov1.y_actual, greThr1.u) annotation (Line(points={{-161,-453},{-161,-452},
          {-156,-452},{-156,-510},{-178,-510}},                         color={0,
          0,127}));
  connect(hp1.P, greThr2.u) annotation (Line(points={{-125,-436},{-125,-464},{-96,
          -464},{-96,-452},{-40,-452},{-40,-420},{-32,-420}},
                                                   color={0,0,127}));
  connect(extIndInt.y, hp1.mod) annotation (Line(points={{-458,-490},{-456,-490},
          {-456,-488},{-452,-488},{-452,-456},{-224,-456},{-224,-424},{-156,-424},
          {-156,-433.9},{-147.1,-433.9}},                   color={255,127,0}));
  connect(and3.y, booToRea4.u)
    annotation (Line(points={{-398,-390},{-382,-390}}, color={255,0,255}));
  connect(and1.y, booToRea3.u)
    annotation (Line(points={{-398,-360},{-382,-360}}, color={255,0,255}));
  connect(conPIDCoo.y, mul.u2) annotation (Line(points={{-202,-330},{-268,-330},
          {-268,-344},{-272,-344},{-272,-362},{-262,-362}}, color={0,0,127}));
  connect(mul.y, add2.u1) annotation (Line(points={{-238,-356},{-232,-356},{-232,
          -370}}, color={0,0,127}));
  connect(mul1.y, add2.u2) annotation (Line(points={{-238,-406},{-236,-406},{-236,
          -392},{-232,-392},{-232,-382}}, color={0,0,127}));
  connect(add2.y, hp1.ySet) annotation (Line(points={{-208,-376},{-147.1,-376},{
          -147.1,-437.9}}, color={0,0,127}));
  connect(hp1.port_b2, senTem.port_a) annotation (Line(points={{-146,-426},{-160,
          -426},{-160,-370}}, color={0,127,255}));
  connect(junHeaWatBypSup1.port_1, senTem1.port_b) annotation (Line(points={{-178,
          -528},{-188,-528},{-188,-548},{0,-548},{0,-440},{-44,-440},{-44,-444},
          {-96,-444},{-96,-446},{-104,-446}}, color={0,127,255}));
  connect(senTem1.port_a, hp1.port_b1)
    annotation (Line(points={{-124,-446},{-126,-446}}, color={0,127,255}));
  connect(conPIDHea.y, mul1.u2) annotation (Line(points={{-78,-476},{-68,-476},{
          -68,-496},{-272,-496},{-272,-412},{-262,-412}}, color={0,0,127}));
  connect(senTem.T, swi.u1) annotation (Line(points={{-171,-360},{-180,-360},{-180,
          -380},{-120,-380},{-120,-322},{-102,-322}}, color={0,0,127}));
  connect(senTem1.T, swi.u3) annotation (Line(points={{-114,-457},{-116,-457},{-116,
          -480},{-224,-480},{-224,-460},{-228,-460},{-228,-404},{-156,-404},{-156,
          -388},{-102,-388},{-102,-338}}, color={0,0,127}));
  connect(swi.y, conPIDCoo.u_m) annotation (Line(points={{-78,-330},{-72,-330},{
          -72,-348},{-116,-348},{-116,-384},{-184,-384},{-184,-352},{-190,-352},
          {-190,-342}}, color={0,0,127}));
  connect(swi.y, conPIDHea.u_m) annotation (Line(points={{-78,-330},{-72,-330},{
          -72,-348},{-116,-348},{-116,-384},{-204,-384},{-204,-396},{-232,-396},
          {-232,-492},{-90,-492},{-90,-488}}, color={0,0,127}));
  connect(ctlHea.y1PumHeaWatSec[1], booToRea5.u) annotation (Line(points={{-578,
          43.25},{-176,43.25},{-176,-76},{-164,-76},{-164,-212},{12,-212},{12,-470},
          {18,-470}},
                  color={255,0,255}));
  connect(booToRea2.y, mul2.u1) annotation (Line(points={{-118,-40},{-118,-34},{
          -92,-34}}, color={0,0,127}));
  connect(booToRea5.y, mul3.u1)
    annotation (Line(points={{42,-470},{58,-470},{58,-474}}, color={0,0,127}));
  connect(ctlHea.yPumHeaWatSec, mul3.u2) annotation (Line(points={{-578,30},{-194,
          30},{-194,-486},{58,-486}}, color={0,0,127}));
  connect(junChiWatBypSup1.port_2, senTem2.port_a)
    annotation (Line(points={{-136,-92},{-132,-92}}, color={0,127,255}));
  connect(senTem2.port_b, senVolFlo.port_a)
    annotation (Line(points={{-112,-92},{-106,-92}}, color={0,127,255}));
  connect(senVolFlo.port_b, junChiWatBypSup.port_1)
    annotation (Line(points={{-86,-92},{-82,-92}}, color={0,127,255}));
  connect(senVolFlo1.port_a, junChiWatBypRet.port_2)
    annotation (Line(points={{-88,-140},{-82,-140}}, color={0,127,255}));
  connect(junChiWatBypRet1.port_1, senTem3.port_b)
    annotation (Line(points={{-136,-140},{-132,-140}}, color={0,127,255}));
  connect(senTem3.port_a, senVolFlo1.port_b)
    annotation (Line(points={{-112,-140},{-108,-140}}, color={0,127,255}));
  connect(junHeaWatBypSup1.port_2, senTem4.port_a)
    annotation (Line(points={{-158,-528},{-148,-528}}, color={0,127,255}));
  connect(senTem4.port_b, senVolFlo2.port_a)
    annotation (Line(points={{-128,-528},{-120,-528}}, color={0,127,255}));
  connect(senVolFlo2.port_b, junHeaWatBypSup.port_1) annotation (Line(points={{-100,
          -528},{-96,-528},{-96,-508},{-82,-508}}, color={0,127,255}));
  connect(junHeaWatBypRet.port_2, senVolFlo3.port_a)
    annotation (Line(points={{-82,-588},{-90,-588}}, color={0,127,255}));
  connect(senVolFlo3.port_b, senTem5.port_a)
    annotation (Line(points={{-110,-588},{-124,-588}}, color={0,127,255}));
  connect(senTem5.port_b, junHeaWatBypSup2.port_1)
    annotation (Line(points={{-144,-588},{-158,-588}}, color={0,127,255}));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-480,190},{-452,190},{-452,175},{-401,175}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(weaBus.TDryBul, ctlHea.TOut) annotation (Line(
      points={{-400.815,175.175},{-636,175.175},{-636,38},{-622,38}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(busSen, busSen2) annotation (Line(
      points={{62,-234},{64,-234},{64,-204},{-152,-204},{-152,-216},{-444,-216},
          {-444,-18},{-630,-18},{-630,0},{-652,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busSen2.THeaWatRetPri, ctlHea.THeaWatPriRet) annotation (Line(
      points={{-652,0},{-630,0},{-630,34},{-622,34}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(busSen2.THeaWatSupPri, ctlHea.THeaWatPriSup) annotation (Line(
      points={{-652,0},{-630,0},{-630,36},{-622,36}},
      color={255,204,51},
      thickness=0.5));
  connect(busSen2.THeaWatSupSec, ctlHea.THeaWatSecSup) annotation (Line(
      points={{-652,0},{-630,0},{-630,24},{-622,24}},
      color={255,204,51},
      thickness=0.5));
  connect(busSen2.VHeaWatSec_flow, ctlHea.VHeaWatSec_flow) annotation (Line(
      points={{-652,0},{-630,0},{-630,18},{-622,18}},
      color={255,204,51},
      thickness=0.5));
  connect(dpChiWatRem[1].p_rel, busSen.dpChiWatRem) annotation (Line(points={{30,-101},
          {30,-112},{12,-112},{12,-208},{32,-208},{32,-234},{62,-234}},
                                                color={0,0,127}));
  connect(dpHeaWatRem[1].p_rel, busSen.dpHeaWatRem) annotation (Line(points={{61,
          -530},{61,-532},{4,-532},{4,-384},{62,-384},{62,-234}}, color={0,0,127}));
  connect(busSen2.dpHeaWatRem, ctlHea.dpHeaWatRem[1]) annotation (Line(
      points={{-652,0},{-630,0},{-630,8},{-622,8}},
      color={255,204,51},
      thickness=0.5));
  connect(greThr2.y, busSen.y1HRC_actual) annotation (Line(points={{-8,-420},{62,
          -420},{62,-234}}, color={255,0,255}));

  connect(senTem2.T, busSen.TChiWatSupPri) annotation (Line(points={{-122,-81},{
          -122,-72},{-134,-72},{-134,-194},{62,-194},{62,-234}}, color={0,0,127}));
  connect(senTem3.T, busSen.TChiWatRetPri) annotation (Line(points={{-122,-129},
          {-122,-120},{-134,-120},{-134,-194},{62,-194},{62,-234}}, color={0,0,127}));
  connect(senVolFlo.V_flow, busSen.VChiWatPri_flow) annotation (Line(points={{-96,
          -81},{-96,-76},{-54,-76},{-54,-234},{62,-234}}, color={0,0,127}));
  connect(mChiWat_flow.m_flow, norFlo2.u) annotation (Line(points={{50,-151},{50,
          -160},{80,-160},{80,-172}}, color={0,0,127}));
  connect(norFlo2.y, busSen.VChiWatSec_flow)
    annotation (Line(points={{80,-196},{80,-234},{62,-234}}, color={0,0,127}));
  connect(addPar1.y, busSen.TChiWatRetSec) annotation (Line(points={{-98,0},{72,
          0},{72,-164},{104,-164},{104,-212},{96,-212},{96,-234},{62,-234}},
        color={0,0,127}));
  connect(senTemCooSup.T, busSen.TChiWatSupSec) annotation (Line(points={{50,-49},
          {50,-40},{76,-40},{76,-144},{112,-144},{112,-240},{92,-240},{92,-234},
          {62,-234}}, color={0,0,127}));
  connect(senTem4.T, busSen.THeaWatSupPri) annotation (Line(points={{-138,-517},
          {-140,-517},{-140,-508},{-100,-508},{-100,-512},{-92,-512},{-92,-528},
          {-4,-528},{-4,-536},{8,-536},{8,-392},{68,-392},{68,-264},{62,-264},{62,
          -234}}, color={0,0,127}));
  connect(senTem5.T, busSen.THeaWatRetPri) annotation (Line(points={{-134,-577},
          {-136,-577},{-136,-568},{104,-568},{104,-234},{62,-234}}, color={0,0,127}));
  connect(senVolFlo2.V_flow, busSen.VHeaWatPri_flow) annotation (Line(points={{-110,
          -517},{-112,-517},{-112,-512},{-96,-512},{-96,-532},{-92,-532},{-92,-552},
          {-76,-552},{-76,-556},{92,-556},{92,-504},{96,-504},{96,-234},{62,-234}},
        color={0,0,127}));
  connect(mHeaWat_flow.m_flow, norFlo3.u) annotation (Line(points={{114,-599},{
          114,-608},{132,-608},{132,-516},{120,-516},{120,-302}},
                                                              color={0,0,127}));
  connect(norFlo3.y, busSen.VHeaWatSec_flow) annotation (Line(points={{120,-278},
          {120,-234},{62,-234}}, color={0,0,127}));
  connect(senTemHeaSup.T, busSen.THeaWatSupSec) annotation (Line(points={{140,
          -499},{110,-499},{110,-234},{62,-234}},
                                            color={0,0,127}));
  connect(dpChiWatRem[1].port_a, senTemCooSup.port_b) annotation (Line(points={
          {40,-110},{40,-88},{68,-88},{68,-60},{60,-60}}, color={0,127,255}));
  connect(dpChiWatRem[1].port_b, pipChiWat.port_b) annotation (Line(points={{20,
          -110},{20,-128},{4,-128},{4,-124},{-32,-124},{-32,-140},{-22,-140}},
        color={0,127,255}));
  connect(dpHeaWatRem[1].port_b, pipHeaWat.port_b) annotation (Line(points={{70,
          -540},{70,-572},{-8,-572},{-8,-588},{0,-588}}, color={0,127,255}));
  connect(reqPlaRes.yChiWatResReq, mulInt[1].u2) annotation (Line(points={{68,
          140},{12,140},{12,126},{2,126}}, color={255,127,0}));
  connect(reqPlaRes.yChiPlaReq, mulInt[2].u2)
    annotation (Line(points={{68,135},{68,136},{12,136},{12,126},{2,126}},
                                                         color={255,127,0}));
  connect(reqPlaRes.yHotWatResReq, mulInt[3].u2) annotation (Line(points={{68,
          129},{12,129},{12,126},{2,126}}, color={255,127,0}));
  connect(reqPlaRes.yHotWatPlaReq, mulInt[4].u2) annotation (Line(points={{68,
          124},{12,124},{12,126},{2,126}}, color={255,127,0}));
  connect(mulInt[3].y, ctlHea.nReqResHeaWat) annotation (Line(points={{-22,132},
          {-334,132},{-334,136},{-644,136},{-644,42},{-622,42}}, color={255,127,
          0}));
  connect(mulInt[4].y, ctlHea.nReqPlaHeaWat) annotation (Line(points={{-22,132},
          {-332,132},{-332,130},{-640,130},{-640,46},{-622,46}}, color={255,127,
          0}));
  connect(booToRea.y, mov2.y) annotation (Line(points={{-32,-386},{-32,-388},{-100,
          -388},{-100,-414}}, color={0,0,127}));
  connect(booToRea1.y, mov1.y) annotation (Line(points={{-32,-456},{-102,-456},{
          -102,-458},{-172,-458}}, color={0,0,127}));
  connect(weaDat.weaBus, out.weaBus) annotation (Line(
      points={{-480,190},{-472,190},{-472,172},{-680,172},{-680,-330},{-640,-330},
          {-640,-329.8}},
      color={255,204,51},
      thickness=0.5));

  connect(out.ports[1], mov5.port_a) annotation (Line(points={{-620,-331.333},{
          -620,-430},{-268,-430},{-268,-484},{-258,-484}},        color={0,127,255}));
  connect(mov5.port_b, hp1.port_a3) annotation (Line(points={{-238,-484},{-136,-484},
          {-136,-448}}, color={0,127,255}));
  connect(xor.y, booToRea7.u)
    annotation (Line(points={{-298,-480},{-296,-480}}, color={255,0,255}));
  connect(booToRea7.y, mov5.y) annotation (Line(points={{-272,-480},{-260,-480},
          {-260,-472},{-248,-472}}, color={0,0,127}));
  connect(booToRea.u, xor.u1) annotation (Line(points={{-8,-386},{0,-386},{0,-300},
          {-334,-300},{-334,-480},{-322,-480}},
                              color={255,0,255}));
  connect(booToRea1.u, xor.u2) annotation (Line(points={{-8,-456},{-4,-456},{-4,
          -512},{-56,-512},{-56,-560},{-164,-560},{-164,-552},{-332,-552},{-332,
          -488},{-322,-488}}, color={255,0,255}));
  connect(TDum1.y, reqFloHea.TMinRef) annotation (Line(points={{-138,170},{-136,
          170},{-136,84},{-128,84},{-128,92},{-122,92}}, color={0,0,127}));
  connect(reqFloHea.TRet, loaHeaWat.TSet) annotation (Line(points={{-98,96},{8,96},
          {8,80},{164,80},{164,-508},{180,-508},{180,-520}}, color={0,0,127}));
  connect(reqFloHea.TRet, busSen.THeaWatRetSec) annotation (Line(points={{-98,96},
          {8,96},{8,80},{164,80},{164,-232},{100,-232},{100,-204},{62,-204},{62,
          -234}}, color={0,0,127}));
  connect(mov6.port_b, chiDed.port_a1) annotation (Line(points={{-510,-300},{-506,
          -300},{-506,-276},{-500,-276}}, color={0,127,255}));
  connect(out.ports[2], mov6.port_a) annotation (Line(points={{-620,-330},{-620,
          -300},{-530,-300}}, color={0,127,255}));
  connect(weaDat.weaBus, hpDed.busWea) annotation (Line(
      points={{-480,190},{-472,190},{-472,172},{-680,172},{-680,-332},{-580,-332},
          {-580,-328},{-576,-328},{-576,-260}},
      color={255,204,51},
      thickness=0.5));
  connect(junChiWatBypRet1.port_2, mov.port_a) annotation (Line(points={{-156,-140},
          {-324,-140},{-324,-128},{-520,-128},{-520,-190}}, color={0,127,255}));
  connect(mov7.port_b, hpDed.port_a) annotation (Line(points={{-580,-190},{-580,
          -270},{-580,-270}}, color={0,127,255}));
  connect(booToRea6[1].y, mov.y) annotation (Line(points={{-470,-162},{-470,-168},
          {-510,-168},{-510,-178}},
                        color={0,0,127}));
  connect(booToRea6[2].y, mov7.y) annotation (Line(points={{-470,-162},{-470,-168},
          {-590,-168},{-590,-178}},                                     color={0,
          0,127}));
  connect(hpDed.port_b, junHeaWatBypSup1.port_3) annotation (Line(points={{-560,
          -270},{-540,-270},{-540,-538},{-168,-538}}, color={0,127,255}));
  connect(mov7.port_a, junHeaWatBypSup2.port_2) annotation (Line(points={{-600,-190},
          {-600,-192},{-648,-192},{-648,-588},{-178,-588}}, color={0,127,255}));
  connect(mulInt[1].y, ctlCoo.nReqResChiWat) annotation (Line(points={{-22,132},
          {-400,132},{-400,-42},{-382,-42}}, color={255,127,0}));
  connect(mov.y_actual, greThr3.u) annotation (Line(points={{-499,-183},{-500,-183},
          {-500,-190},{-492,-190}}, color={0,0,127}));
  connect(mov7.y_actual, greThr6.u) annotation (Line(points={{-579,-183},{-580,-183},
          {-580,-190},{-572,-190}}, color={0,0,127}));
  connect(greThr3.y, ctlCoo.u1PumChiWatPri_actual[1]) annotation (Line(points={{-468,
          -190},{-468,-192},{-440,-192},{-440,-22},{-396,-22},{-396,-23.8},{
          -382,-23.8}},  color={255,0,255}));
  connect(greThr6.y, ctlHea.u1PumHeaWatPri_actual[1]) annotation (Line(points={{
          -548,-190},{-540,-190},{-540,-30},{-670,-30},{-670,60.2},{-622,60.2}},
        color={255,0,255}));
  connect(ctlCoo.y1PumChiWatSec[1], booToRea2.u) annotation (Line(points={{-338,
          -40.75},{-336,-40},{-142,-40}},
                                       color={255,0,255}));
  connect(ctlCoo.yPumChiWatSec, mul2.u2) annotation (Line(points={{-338,-54},{
          -148,-54},{-148,-60},{-100,-60},{-100,-46},{-92,-46}},
                                                            color={0,0,127}));
  connect(busChi, chiDed.bus) annotation (Line(
      points={{-412,-154},{-412,-288},{-490,-288},{-490,-280}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(busHP, hpDed.bus) annotation (Line(
      points={{-640,-160},{-640,-254},{-570,-254},{-570,-260}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(mulInt[2].y, ctlCoo.nReqPlaChiWat) annotation (Line(points={{-22,132},
          {-400,132},{-400,-40},{-392,-40},{-392,-38},{-382,-38}}, color={255,127,
          0}));
  connect(weaBus.TDryBul, ctlCoo.TOut) annotation (Line(
      points={{-400.815,175.175},{-400,175.175},{-400,128},{-404,128},{-404,-44},
          {-382,-44}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(busSen2.TChiWatSupPri, ctlCoo.TChiWatPriSup) annotation (Line(
      points={{-652,0},{-630,0},{-630,-18},{-444,-18},{-444,-52},{-382,-52}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(busSen2.TChiWatRetPri, ctlCoo.TChiWatPriRet) annotation (Line(
      points={{-652,0},{-630,0},{-630,-18},{-444,-18},{-444,-54},{-382,-54}},
      color={255,204,51},
      thickness=0.5));
  connect(busSen2.TChiWatSupSec, ctlCoo.TChiWatSecSup) annotation (Line(
      points={{-652,0},{-630,0},{-630,-18},{-444,-18},{-444,-66},{-382,-66}},
      color={255,204,51},
      thickness=0.5));
  connect(busSen2.VChiWatSec_flow, ctlCoo.VChiWatSec_flow) annotation (Line(
      points={{-652,0},{-630,0},{-630,-18},{-444,-18},{-444,-72},{-382,-72}},
      color={255,204,51},
      thickness=0.5));
  connect(busSen2.dpChiWatRem, ctlCoo.dpChiWatRem[1]) annotation (Line(
      points={{-652,0},{-630,0},{-630,-18},{-444,-18},{-444,-80},{-382,-80}},
      color={255,204,51},
      thickness=0.5));
  connect(ctlCoo.y1Hp[1], busChi.y1) annotation (Line(points={{-338,-16.5},{
          -320,-16.5},{-320,-124},{-412,-124},{-412,-154}},
                                                       color={255,127,0}));
  connect(ctlCoo.y1Hp[2], and1.u2) annotation (Line(points={{-338,-15.5},{-320,
          -15.5},{-320,-124},{-376,-124},{-376,-376},{-428,-376},{-428,-368},{
          -422,-368}},
        color={255,0,255}));
  connect(ctlHea.y1Hp[2], and3.u2) annotation (Line(points={{-578,66.5},{-576,
          66.5},{-576,64},{-472,64},{-472,-132},{-448,-132},{-448,-444},{-422,
          -444},{-422,-398}},
        color={255,127,0}));
  connect(ctlCoo.TSupSet[2], conPIDCoo.u_s) annotation (Line(points={{-338,
          -67.5},{-188,-67.5},{-188,-312},{-172,-312},{-172,-330},{-178,-330}},
                                                                         color={
          0,0,127}));
  connect(ctlHea.TSupSet[2], conPIDHea.u_s) annotation (Line(points={{-578,14.5},
          {-432,14.5},{-432,-534},{-228,-534},{-228,-476},{-102,-476}}, color={0,
          0,127}));
  connect(greThr.y, ctlCoo.u1PumChiWatPri_actual[2]) annotation (Line(points={{-142,
          -406},{-230,-406},{-230,-90},{-440,-90},{-440,-22},{-382,-22},{-382,
          -23.8}},
        color={255,0,255}));
  connect(greThr1.y, ctlHea.u1PumHeaWatPri_actual[2]) annotation (Line(points={{
          -202,-510},{-220,-510},{-220,-560},{-696,-560},{-696,42},{-660,42},{-660,
          60.2},{-622,60.2}}, color={255,0,255}));
  connect(busSen2.y1HRC_actual, ctlHea.u1Hp_actual[2]) annotation (Line(
      points={{-652,0},{-652,62.7},{-622,62.7}},
      color={255,204,51},
      thickness=0.5));
  connect(busSen2.y1HRC_actual, ctlCoo.u1Hp_actual[2]) annotation (Line(
      points={{-652,0},{-396,0},{-396,-19.3},{-382,-19.3}},
      color={255,204,51},
      thickness=0.5));
  connect(busHP.y1_actual, ctlHea.u1Hp_actual[1]) annotation (Line(
      points={{-640,-160},{-684,-160},{-684,60},{-676,60},{-676,64},{-622,64},{-622,
          61.7}},
      color={255,204,51},
      thickness=0.5));
  connect(busChi.y1_actual, ctlCoo.u1Hp_actual[1]) annotation (Line(
      points={{-412,-154},{-412,-120},{-408,-120},{-408,-28},{-392,-28},{-392,
          -20.3},{-382,-20.3}},
      color={255,204,51},
      thickness=0.5));
  connect(ctlHea.y1Hp[1], busHP.y1) annotation (Line(points={{-578,65.5},{-472,65.5},
          {-472,-88},{-628,-88},{-628,-128},{-640,-128},{-640,-160}}, color={255,
          0,255}));
  connect(ctlHea.TSupSet[1], busHP.TSet) annotation (Line(points={{-578,13.5},{-568,
          13.5},{-568,-108},{-608,-108},{-608,-160},{-640,-160}}, color={0,0,127}));
  connect(ctlCoo.y1PumChiWatPri[1], booToRea6[1].u) annotation (Line(points={{-338,
          -34},{-332,-34},{-332,-44},{-328,-44},{-328,-120},{-476,-120},{-476,
          -138},{-470,-138}},
                        color={255,0,255}));
  connect(ctlHea.y1PumHeaWatPri[1], booToRea6[2].u) annotation (Line(points={{-578,
          50},{-468,50},{-468,-120},{-476,-120},{-476,-138},{-470,-138}}, color
        ={255,0,255}));
  connect(ctlCoo.y1PumChiWatPri[2], booToRea.u) annotation (Line(points={{-338,
          -34},{-332,-34},{-332,-44},{-328,-44},{-328,-60},{-180,-60},{-180,
          -300},{0,-300},{0,-386},{-8,-386}},
                                     color={255,0,255}));
  connect(ctlHea.y1PumHeaWatPri[2], booToRea1.u) annotation (Line(points={{-578,
          50},{-468,50},{-468,-124},{-452,-124},{-452,-452},{-436,-452},{-436,-496},
          {-428,-496},{-428,-528},{-332,-528},{-332,-552},{-164,-552},{-164,-560},
          {-56,-560},{-56,-512},{-4,-512},{-4,-456},{-8,-456}}, color={255,0,255}));
  connect(booToInt.y, mulInt1.u1) annotation (Line(points={{-518,90},{-508,90},{
          -508,96},{-502,96}}, color={255,127,0}));
  connect(ctlHea.yMod[2], mulInt1.u2) annotation (Line(points={{-578,62.5},{-564,
          62.5},{-564,60},{-512,60},{-512,84},{-502,84}}, color={255,127,0}));
  connect(booToInt1.y, mulInt2.u1) annotation (Line(points={{-278,0},{-268,0},{-268,
          6},{-262,6}}, color={255,127,0}));
  connect(ctlCoo.yMod[2], mulInt2.u2) annotation (Line(points={{-338,-19.5},{
          -324,-19.5},{-324,-20},{-272,-20},{-272,-6},{-262,-6}},
                                                             color={255,127,0}));
  connect(mulInt1.y, addInt.u1) annotation (Line(points={{-478,90},{-392,90},{
          -392,96},{-382,96}},
                          color={255,127,0}));
  connect(mulInt2.y, addInt.u2) annotation (Line(points={{-238,0},{-232,0},{
          -232,52},{-392,52},{-392,84},{-382,84}},
                          color={255,127,0}));
  connect(mov.port_b, chiDed.port_a2) annotation (Line(points={{-500,-190},{-500,
          -252},{-472,-252},{-472,-264},{-480,-264}}, color={0,127,255}));
  connect(bou.ports[1], mov.port_a) annotation (Line(points={{-561,-150},{-561,-172},
          {-520,-172},{-520,-190}}, color={0,127,255}));
  connect(ctlCoo.y1EnaPla, ctlHea.u1EnaCoo) annotation (Line(points={{-338,-12},
          {-336,-12},{-336,72},{-564,72},{-564,80},{-622,80},{-622,70}}, color={
          255,0,255}));
  connect(ctlHea.y1EnaPla, ctlCoo.u1EnaHea) annotation (Line(points={{-578,70},
          {-580,70},{-580,84},{-548,84},{-548,68},{-396,68},{-396,4},{-382,4},{
          -382,-8}},
                color={255,0,255}));
  connect(booToRea8.y, mov6.y) annotation (Line(points={{-550,-262},{-552,-262},
          {-552,-276},{-520,-276},{-520,-288}}, color={0,0,127}));
  connect(busChi.y1, booToRea8.u) annotation (Line(
      points={{-412,-154},{-412,-188},{-436,-188},{-436,-212},{-440,-212},{-440,
          -232},{-550,-232},{-550,-238}},
      color={255,204,51},
      thickness=0.5));
  connect(bou.ports[2], mov7.port_a) annotation (Line(points={{-559,-150},{-559,
          -164},{-608,-164},{-608,-190},{-600,-190}}, color={0,127,255}));
  connect(datRea.y[5], norFlo1[1].u) annotation (Line(points={{-159,100},{-132,100},
          {-132,52},{-20,52},{-20,100},{16,100}}, color={0,0,127}));
  connect(pumHeaWatSec.ports_b,outPumHeaWatSec. ports_a)
    annotation (Line(points={{28,-690},{34,-690}}, color={0,127,255}));
  connect(inlPumHeaWatSec.ports_b,pumHeaWatSec. ports_a)
    annotation (Line(points={{0,-690},{8,-690}}, color={0,127,255}));
  connect(junHeaWatBypSup.port_2,inlPumHeaWatSec. port_a) annotation (Line(
        points={{-62,-508},{-20,-508},{-20,-592},{-12,-592},{-12,-672},{-28,-672},
          {-28,-690},{-20,-690}}, color={0,127,255}));
  connect(outPumHeaWatSec.port_b, senTemHeaSup.port_a) annotation (Line(points={
          {54,-690},{68,-690},{68,-576},{96,-576},{96,-572},{112,-572},{112,-510},
          {130,-510}}, color={0,127,255}));
  connect(dpHeaWatRem[1].port_a, senTemHeaSup.port_a) annotation (Line(points={{
          70,-520},{70,-510},{130,-510}}, color={0,127,255}));
  connect(busPumSecHeaWat,pumHeaWatSec. bus) annotation (Line(
      points={{-330,110},{-156,110},{-156,-680},{18,-680}},
      color={255,204,51},
      thickness=0.5));
  connect(ctlHea.y1PumHeaWatSec,busPumSecHeaWat.y1);
  connect(ctlHea.yPumHeaWatSec,busPumSecHeaWat.y);
  connect(ctlCoo.y1PumChiWatSec,busPumSecChiWat.y1);
  connect(ctlCoo.yPumChiWatSec,busPumSecChiWat.y);
//   connect(ctlHea.u1PumHeaWatSec_actual,busPumSecHeaWat.y1_actual);
  connect(ctlHea.y1PumHeaWatSec, pre.u) annotation (Line(points={{-578,44},{-568,
          44},{-568,110},{-598,110}}, color={255,0,255}));
  connect(pre.y, ctlHea.u1PumHeaWatSec_actual) annotation (Line(points={{-622,110},
          {-632,110},{-632,56.2},{-622,56.2}}, color={255,0,255}));
  connect(ctlHea.y1EnaPla, booToInt.u) annotation (Line(points={{-578,70},{-580,
          70},{-580,84},{-552,84},{-552,90},{-542,90}}, color={255,0,255}));
  connect(ctlCoo.y1EnaPla, booToInt1.u) annotation (Line(points={{-338,-12},{
          -336,-12},{-336,16},{-312,16},{-312,0},{-302,0}},
                                                       color={255,0,255}));
  connect(inlPumChiWatSec.ports_b, pumChiWatSec.ports_a)
    annotation (Line(points={{-12,278},{-4,278}}, color={0,127,255}));
  connect(pumChiWatSec.ports_b, outPumChiWatSec.ports_a)
    annotation (Line(points={{16,278},{22,278}}, color={0,127,255}));
  connect(junChiWatBypSup.port_2, inlPumChiWatSec.port_a) annotation (Line(
        points={{-62,-92},{-30,-92},{-30,260},{-40,260},{-40,278},{-32,278}},
        color={0,127,255}));
  connect(outPumChiWatSec.port_b, senTemCooSup.port_a) annotation (Line(points={
          {42,278},{50,278},{50,280},{56,280},{56,52},{28,52},{28,-60},{40,-60}},
        color={0,127,255}));
  connect(busPumSecChiWat, pumChiWatSec.bus) annotation (Line(
      points={{-340,184},{-340,300},{6,300},{6,288}},
      color={255,204,51},
      thickness=0.5));
  connect(ctlCoo.y1PumChiWatSec, pre1.u) annotation (Line(points={{-338,-40},{
          -328,-40},{-328,0},{-340,0},{-340,10},{-348,10}},
                                                       color={255,0,255}));
  connect(pre1.y, ctlCoo.u1PumChiWatSec_actual) annotation (Line(points={{-372,10},
          {-388,10},{-388,0},{-392,0},{-392,-27.8},{-382,-27.8}}, color={255,0,255}));
  connect(ctlCoo.TSupSet[1], busChi.TSupSet) annotation (Line(points={{-338,
          -68.5},{-336,-68.5},{-336,-64},{-316,-64},{-316,-152},{-380,-152},{
          -380,-156},{-412,-156},{-412,-154}}, color={0,0,127}));
  connect(senVolFlo4.port_b, junChiWatBypSup1.port_1)
    annotation (Line(points={{-202,-92},{-156,-92}}, color={0,127,255}));
  connect(senTem.port_b, senVolFlo5.port_a)
    annotation (Line(points={{-160,-350},{-160,-192}}, color={0,127,255}));
  connect(senVolFlo5.port_b, junChiWatBypSup1.port_3) annotation (Line(points={
          {-160,-172},{-160,-112},{-146,-112},{-146,-102}}, color={0,127,255}));
  connect(booToRea.u, conPIDCoo.trigger) annotation (Line(points={{-8,-386},{-8,
          -388},{0,-388},{0,-300},{-216,-300},{-216,-352},{-200,-352},{-200,
          -356},{-180,-356},{-180,-348},{-184,-348},{-184,-342}}, color={255,0,
          255}));
  connect(booToRea1.u, conPIDHea.trigger) annotation (Line(points={{-8,-456},{
          -4,-456},{-4,-498},{-50,-498},{-50,-488},{-96,-488}}, color={255,0,
          255}));
  connect(junChiWatBypRet.port_3, senVolFlo6.port_b) annotation (Line(points={{
          -72,-130},{-72,-126},{-66,-126}}, color={0,127,255}));
  connect(junChiWatBypSup.port_3, senVolFlo6.port_a) annotation (Line(points={{
          -72,-102},{-72,-106},{-66,-106}}, color={0,127,255}));
  connect(chiDed.port_b2, senTem6.port_a) annotation (Line(points={{-500,-264},
          {-530,-264},{-530,-92},{-266,-92}}, color={0,127,255}));
  connect(senTem6.port_b, senVolFlo4.port_a)
    annotation (Line(points={{-246,-92},{-222,-92}}, color={0,127,255}));
  connect(chiDed.port_b1, senTem7.port_a) annotation (Line(points={{-480,-276},
          {-470,-276},{-470,-300}}, color={0,127,255}));
  connect(senTem7.port_b, bou1.ports[1])
    annotation (Line(points={{-470,-320},{-550,-320}}, color={0,127,255}));
  connect(out.ports[3], senTem8.port_b) annotation (Line(points={{-620,-328.667},
          {-550,-328.667},{-550,-332},{-480,-332}}, color={0,127,255}));
  connect(senTem8.port_a, hp1.port_b3) annotation (Line(points={{-460,-332},{
          -346,-331.333},{-346,-288},{-152,-288},{-152,-423.9},{-136,-423.9}},
        color={0,127,255}));
  connect(reqFloCoo.mReq_flow, norFlo1[2].u) annotation (Line(points={{-98,34},
          {-36,34},{-36,52},{-20,52},{-20,100},{16,100}}, color={0,0,127}));
  connect(addInt.y, intSwi.u3) annotation (Line(points={{-358,90},{-350,90},{
          -350,74},{-292,74},{-292,72},{-222,72}}, color={255,127,0}));
  connect(conInt3.y, intSwi.u1) annotation (Line(points={{-298,90},{-240,90},{
          -240,88},{-222,88}}, color={255,127,0}));
  connect(ctlCoo.y1EnaPla, and2.u1) annotation (Line(points={{-338,-12},{-336,
          -12},{-336,16},{-312,16},{-312,-24},{-240,-24},{-240,-20},{-232,-20}},
        color={255,0,255}));
  connect(ctlHea.y1EnaPla, and2.u2) annotation (Line(points={{-578,70},{-580,70},
          {-580,84},{-548,84},{-548,68},{-396,68},{-396,36},{-192,36},{-192,-44},
          {-240,-44},{-240,-28},{-232,-28}}, color={255,0,255}));
  connect(and2.y, intSwi.u2) annotation (Line(points={{-208,-20},{-188,-20},{
          -188,64},{-232,64},{-232,80},{-222,80}}, color={255,0,255}));
  connect(datRea1.y[3], reqFloCoo.mRef_flow) annotation (Line(points={{-219,150},
          {-132,150},{-132,30},{-122,30}}, color={0,0,127}));
  connect(intSwi.y, extIndInt.index) annotation (Line(points={{-198,80},{-184,
          80},{-184,-148},{-240,-148},{-240,-220},{-436,-220},{-436,-440},{-528,
          -440},{-528,-516},{-470,-516},{-470,-502}}, color={255,127,0}));
  connect(conInt4.y, intEqu3.u1)
    annotation (Line(points={{-388,-610},{-372,-610}}, color={255,127,0}));
  connect(extIndInt.y, intEqu3.u2) annotation (Line(points={{-458,-490},{-440,
          -490},{-440,-628},{-372,-628},{-372,-618}}, color={255,127,0}));
  connect(intEqu3.y, or2.u2) annotation (Line(points={{-348,-610},{-348,-612},{
          -320,-612},{-320,-528},{-302,-528}}, color={255,0,255}));
  connect(mul5.y, mul1.u1) annotation (Line(points={{-298,-390},{-272,-390},{
          -272,-400},{-262,-400}}, color={0,0,127}));
  connect(booToRea4.y, mul5.u1) annotation (Line(points={{-358,-390},{-332,-390},
          {-332,-384},{-322,-384}}, color={0,0,127}));
  connect(senTem.T, greThr4.u) annotation (Line(points={{-171,-360},{-228,-360},
          {-228,-270},{-238,-270}}, color={0,0,127}));
  connect(greThr4.y, booToRea9.u)
    annotation (Line(points={{-262,-270},{-278,-270}}, color={255,0,255}));
  connect(booToRea9.y, mul5.u2) annotation (Line(points={{-302,-270},{-336,-270},
          {-336,-396},{-322,-396}}, color={0,0,127}));
  connect(mul4.y, mul.u1) annotation (Line(points={{-298,-360},{-280,-360},{
          -280,-350},{-262,-350}}, color={0,0,127}));
  connect(booToRea3.y, mul4.u1) annotation (Line(points={{-358,-360},{-332,-360},
          {-332,-354},{-322,-354}}, color={0,0,127}));
  connect(lesThr.y, booToRea10.u)
    annotation (Line(points={{-238,-620},{-222,-620}}, color={255,0,255}));
  connect(booToRea10.y, mul4.u2) annotation (Line(points={{-198,-620},{-192,
          -620},{-192,-556},{-444,-556},{-444,-448},{-420,-448},{-420,-412},{
          -348,-412},{-348,-376},{-332,-376},{-332,-366},{-322,-366}}, color={0,
          0,127}));
  connect(senTem1.T, lesThr.u) annotation (Line(points={{-114,-457},{-116,-457},
          {-116,-480},{-224,-480},{-224,-548},{-216,-548},{-216,-604},{-276,
          -604},{-276,-620},{-262,-620}}, color={0,0,127}));
  connect(datRea1.y[2], addPar1.u) annotation (Line(points={{-219,150},{-132,
          150},{-132,32},{-136,32},{-136,0},{-122,0}}, color={0,0,127}));
  connect(intEqu1.y, and3.u1) annotation (Line(points={{-348,-506},{-348,-508},
          {-340,-508},{-340,-416},{-416,-416},{-416,-408},{-428,-408},{-428,
          -390},{-422,-390}}, color={255,0,255}));
  connect(or2.y, and1.u1) annotation (Line(points={{-278,-520},{-272,-520},{
          -272,-500},{-336,-500},{-336,-484},{-332,-484},{-332,-404},{-340,-404},
          {-340,-356},{-352,-356},{-352,-344},{-428,-344},{-428,-360},{-422,
          -360}}, color={255,0,255}));
  connect(intEqu2.y, or2.u1) annotation (Line(points={{-348,-476},{-344,-476},{
          -344,-500},{-336,-500},{-336,-520},{-302,-520}}, color={255,0,255}));
  connect(or2.y, swi.u2) annotation (Line(points={{-278,-520},{-272,-520},{-272,
          -500},{-336,-500},{-336,-484},{-332,-484},{-332,-404},{-340,-404},{
          -340,-356},{-352,-356},{-352,-252},{-152,-252},{-152,-284},{-144,-284},
          {-144,-330},{-102,-330}}, color={255,0,255}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/HeatPumps/Validation/AirToWater.mos"
        "Simulate and plot"),
    experiment(
      StartTime=12355200,
      StopTime=12960000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
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
The user can toggle the top-level parameter <code>have_chiWat</code>
to switch between a cooling and heating system (the default setting)
to a heating-only system.
Advanced equipment and control options can be modified via the parameter
dialog of the plant component.
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
        extent={{-700,-640},{200,220}})),
    Icon(coordinateSystem(extent={{-700,-640},{200,220}})));
end Buffalo_hybridDedicated_nonTemplate;
