within Buildings.Templates.Plants.HeatPumps.Validation;
model AirToWater_Buffalo_nonTemplate
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
        nPumHeaWatSec=1,
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
        nPumChiWatSec=1,
        have_valChiWatMinByp=false,
        have_pumChiWatPriVar=false,
        typTanChiWat=Buildings.Templates.Components.Types.IntegrationPoint.None,

        typPumChiWatSec=Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized,

        have_senDpChiWatRemWir=true,
        nSenDpChiWatRem=1,
        have_inpSch=true),
      ctl(THeaWatSup_nominal=333.15, TChiWatSup_nominal=279.85),
      hp(
        mHeaWatHp_flow_nominal=0.3*58/2,
        capHeaHp_nominal=0.55*2.7e6/2,
        THeaWatSupHp_nominal=333.15,
        mChiWatHp_flow_nominal=0.3*68,
        capCooHp_nominal=0.3*2.4e6/2,
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
    dpValve_nominal=0.01*3E4,
    dpFixed_nominal=0.01*(datAll.pla.ctl.dpChiWatRemSet_max[1] - 3E4))
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
    controllerType={Buildings.Controls.OBC.CDL.Types.SimpleController.PID,
        Buildings.Controls.OBC.CDL.Types.SimpleController.PID},
    k={0.1,0.1},
    Ti={30,60},
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
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant cst[4](
    each k=10)
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
    timeScale=1)
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

  Components.ValvesIsolation valIso(
    redeclare final package Medium = Medium,
    final nHp=2,
    final have_chiWat=true,
    final have_valHpInlIso=true,
    final have_valHpOutIso=true,
    final have_pumChiWatPriDed=false,
    final mHeaWatHp_flow_nominal=fill(datAll.pla.hp.mHeaWatHp_flow_nominal,
        valIso.nHp),
    final dpHeaWatHp_nominal=fill(datAll.pla.hp.dpHeaWatHp_nominal, valIso.nHp),
    final dpBalHeaWatHp_nominal=fill(0, valIso.nHp),
    final mChiWatHp_flow_nominal=fill(datAll.pla.hp.mChiWatHp_flow_nominal,
        valIso.nHp),
    final dpBalChiWatHp_nominal=fill(0, valIso.nHp),
    final allowFlowReversal=true,
    linearized=true)
    "Heat pump isolation valves"
    annotation (Placement(transformation(extent={{-678,-160},{-420,-106}})));

  Components.HeatPumpGroups.AirToWater                                      hp(
    redeclare final package MediumHeaWat = Medium,
    redeclare final package MediumAir = MediumAir,
    final nHp=2,
    final is_rev=true,
    dat=datAll.pla.hp,
    final energyDynamics=energyDynamics,
    final have_dpChiHeaWatHp=false,
    final have_dpSou=false,
    final allowFlowReversal=allowFlowReversal,
    final allowFlowReversalSou=false)
    "Heat pump group"
    annotation (Placement(transformation(extent={{-838,-340},{-358,-260}})));
  Fluid.Movers.Preconfigured.SpeedControlled_y mov[2](
    redeclare package Medium = Medium,
    m_flow_nominal=datAll.pla.pumHeaWatPri.m_flow_nominal,
    dp_nominal=datAll.pla.pumHeaWatPri.dp_nominal) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-508,-188})));
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
    QHeaCoo_flow_nominal=20000,
    QCoo_flow_nominal=-30000,
    redeclare model RefrigerantCycleHeatPumpHeating =
        Fluid.HeatPumps.ModularReversible.RefrigerantCycle.ConstantCarnotEffectiveness
        (
        redeclare
          Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.NoFrosting
          iceFacCal,
        TAppCon_nominal=0,
        TAppEva_nominal=0),
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
    dpCon_nominal(displayUnit="Pa") = 6000,
    use_conCap=false,
    CCon=0,
    GConOut=0,
    GConIns=0,
    TEvaCoo_nominal=283.15,
    dTEva_nominal=6,
    dTCon_nominal=20,
    dpEva_nominal(displayUnit="Pa") = 6000,
    use_evaCap=false,
    CEva=0,
    GEvaOut=0,
    GEvaIns=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    show_T=true,
    QHea_flow_nominal=30000,
    TEvaHea_nominal=298.15,
    TConHea_nominal=313.15,
    TConHeaCoo_nominal=323.15,
    TEvaHeaCoo_nominal=283.15,
    con1(T_start=298.15),
    con(T_start=313.15),
    eva(T_start=283.15))    "Modular reversible 4pipe heat pump instance"
    annotation (Placement(transformation(extent={{-146,-426},{-126,-446}})));
public
  Fluid.FixedResistances.CheckValve cheVal(
    redeclare package Medium = Medium,
    m_flow_nominal=datAll.pla.hp.mHeaWatHp_flow_nominal,
    dpValve_nominal=200)
    annotation (Placement(transformation(extent={{-210,-456},{-190,-436}})));
  Fluid.Movers.Preconfigured.SpeedControlled_y     mov1(redeclare package
      Medium = Medium, m_flow_nominal=datAll.pla.hp.mHeaWatHp_flow_nominal,
    dp_nominal=2*hp1.dpCon_nominal)
    annotation (Placement(transformation(extent={{-182,-436},{-162,-456}})));
  Fluid.Movers.Preconfigured.SpeedControlled_y     mov2(redeclare package
      Medium = Medium, m_flow_nominal=datAll.pla.hp.mChiWatHp_flow_nominal,
    dp_nominal=2*hp1.dpEva_nominal)
    annotation (Placement(transformation(extent={{-90,-436},{-110,-416}})));
  Fluid.FixedResistances.CheckValve cheVal1(
    redeclare package Medium = Medium,
    m_flow_nominal=datAll.pla.hp.mChiWatHp_flow_nominal,
    dpValve_nominal=200)
    annotation (Placement(transformation(extent={{-52,-436},{-72,-416}})));
  Fluid.Movers.Preconfigured.SpeedControlled_y mov3(
    redeclare package Medium = Medium,
    m_flow_nominal=datAll.pla.ctl.VChiWatSec_flow_nominal*Buildings.Media.Water.d_const,

    dp_nominal=3*ctl.dpChiWatRemSet_max[1])
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-38,-90})));

  Fluid.Movers.Preconfigured.SpeedControlled_y mov4(
    redeclare package Medium = Medium,
    m_flow_nominal=datAll.pla.ctl.VHeaWatSec_flow_nominal*Buildings.Media.Water.d_const,

    dp_nominal=2*ctl.dpHeaWatRemSet_max[1])
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,-510})));

  Controls.HeatPumps.AirToWater_hybridPlant                ctl(
    have_heaWat=true,
    have_chiWat=true,
    have_hrc_select=true,
    have_valHpInlIso=true,
    have_valHpOutIso=true,
    have_pumChiWatPriDed_select=true,
    have_pumPriHdr=false,
    is_priOnl=false,
    have_pumHeaWatPriVar_select=false,
    have_pumChiWatPriVar_select=false,
    have_senVHeaWatPri_select=false,
    have_senVChiWatPri_select=false,
    have_senTHeaWatPriRet_select=false,
    have_senTChiWatPriRet_select=false,
    nHp=3,
    is_heaRec={false,false,true},
    nPumHeaWatSec=1,
    nPumChiWatSec=1,
    have_senDpHeaWatRemWir=true,
    nSenDpHeaWatRem=1,
    have_senDpChiWatRemWir=true,
    nSenDpChiWatRem=1,
    final THeaWatSup_nominal=333.15,
    THeaWatSupSet_min=318.15,
    TOutHeaWatLck=303.15,
    VHeaWatHp_flow_nominal=1.1*fill(ctl.VHeaWatSec_flow_nominal/ctl.nHp, ctl.nHp),
    VHeaWatHp_flow_min=0.6*ctl.VHeaWatHp_flow_nominal,
    final VHeaWatSec_flow_nominal=3*datAll.pla.hp.mHeaWatHp_flow_nominal/1000,
    capHeaHp_nominal=fill(datAll.pla.hp.capHeaHp_nominal, ctl.nHp),
    dpHeaWatRemSet_max={7E4},
    final TChiWatSup_nominal=279.95,
    TChiWatSupSet_max=288.15,
    TOutChiWatLck=283.15,
    VChiWatHp_flow_nominal=1.1*fill(ctl.VChiWatSec_flow_nominal/ctl.nHp, ctl.nHp),
    VChiWatHp_flow_min=0.6*ctl.VChiWatHp_flow_nominal,
    final VChiWatSec_flow_nominal=3*datAll.pla.hp.mChiWatHp_flow_nominal/1000,
    capCooHp_nominal=fill(datAll.pla.hp.capCooHp_nominal, ctl.nHp),
    yPumHeaWatPriSet=0.8,
    yPumChiWatPriSet=0.7,
    dpChiWatRemSet_max={1E6},
    staEquCooHea=[0,0,1; 1/2,1/2,1; 1,1,1],
    staEquOneMod=[1/2,1/2,0; 1,1,0; 1,1,1],
    idxEquAlt={1,2},
    kCtlDpHeaWat=100,
    TiCtlDpHeaWat=1e-3,
    TChiWatSupHrc_min=277.15,
    THeaWatSupHrc_max=333.15,
    COPHeaHrc_nominal=2.8,
    capCooHrc_min=ctl.capHeaHrc_min*(1 - 1/ctl.COPHeaHrc_nominal),
    capHeaHrc_min=0.3*0.5*sum(ctl.capHeaHp_nominal),
    ctlPumHeaWatSec(ctlDpRem(y(start=1))))
    "Plant controller"
    annotation (Placement(transformation(extent={{-380,-30},{-340,42}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(k=Buildings.Fluid.HeatPumps.ModularReversible.Types.Modes.AmbientCooling)
    annotation (Placement(transformation(extent={{-410,-486},{-390,-466}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu2
    annotation (Placement(transformation(extent={{-370,-486},{-350,-466}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(k=Buildings.Fluid.HeatPumps.ModularReversible.Types.Modes.AmbientHeating)
    annotation (Placement(transformation(extent={{-410,-516},{-390,-496}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1
    annotation (Placement(transformation(extent={{-370,-516},{-350,-496}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    annotation (Placement(transformation(extent={{-330,-406},{-310,-386}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    annotation (Placement(transformation(extent={{-330,-366},{-310,-346}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea3
    annotation (Placement(transformation(extent={{-300,-366},{-280,-346}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea4
    annotation (Placement(transformation(extent={{-300,-406},{-280,-386}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul1
    annotation (Placement(transformation(extent={{-260,-416},{-240,-396}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul
    annotation (Placement(transformation(extent={{-260,-366},{-240,-346}})));
  Buildings.Controls.OBC.CDL.Reals.PID conPIDCoo(reverseActing=false)
    annotation (Placement(transformation(extent={{-180,-340},{-200,-320}})));
  Buildings.Controls.OBC.CDL.Reals.Add add2
    annotation (Placement(transformation(extent={{-230,-386},{-210,-366}})));
  Buildings.Controls.OBC.CDL.Reals.PID conPIDHea
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
  Interfaces.Bus                                      bus
    "Plant control bus"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},rotation=90,
      origin={-520,-46}),
      iconTransformation(extent={{-20,-20},{20,20}},rotation=90,origin={-100,0})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr3[2](t=0.05, h=0.02)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-490,-230})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr4(t=0.05, h=0.02)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-30,-610})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr5(t=0.05, h=0.02)
    annotation (Placement(transformation(extent={{-42,-30},{-62,-10}})));
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
        origin={-400,-180})));
  Buildings.Controls.OBC.CDL.Logical.Or or2[2] annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-400,-150})));
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
      m_flow_nominal=3*datAll.pla.hp.mChiWatHp_flow_nominal)
    annotation (Placement(transformation(extent={{-106,-102},{-86,-82}})));
  Fluid.Sensors.TemperatureTwoPort senTem3(redeclare package Medium = Medium,
      m_flow_nominal=3*datAll.pla.hp.mChiWatHp_flow_nominal) annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-122,-140})));
  Fluid.Sensors.VolumeFlowRate senVolFlo1(redeclare package Medium = Medium,
      m_flow_nominal=3*datAll.pla.hp.mChiWatHp_flow_nominal)
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
        transformation(extent={{-542,-20},{-502,20}}), iconTransformation(
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
    annotation (Placement(transformation(extent={{-570,-192},{-550,-172}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre
    annotation (Placement(transformation(extent={{-360,70},{-380,90}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre1
    annotation (Placement(transformation(extent={{-336,50},{-356,70}})));
  Fluid.Sources.Outside out(redeclare package Medium = MediumAir, nPorts=2)
    annotation (Placement(transformation(extent={{-260,-450},{-240,-430}})));
  Fluid.Movers.Preconfigured.SpeedControlled_y     mov5(
    redeclare package Medium = MediumAir,
    m_flow_nominal=hp1.mCon1_flow_nominal,
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
protected
  Buildings.Templates.Components.Interfaces.Bus busHp[2]
    "Heat pump control bus" annotation (Placement(transformation(extent={{-522,84},
            {-482,124}}), iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValHeaWatHpInlIso[2]
    "Heat pump inlet HW isolation valve control bus" annotation (Placement(
        transformation(extent={{-526,44},{-486,84}}), iconTransformation(extent
          ={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValHeaWatHpOutIso[2]
    "Heat pump outlet HW isolation valve control bus" annotation (Placement(
        transformation(extent={{-522,8},{-482,48}}), iconTransformation(extent={
            {-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatHpInlIso[2]
    "Heat pump inlet CHW isolation valve control bus" annotation (Placement(
        transformation(extent={{-484,-46},{-444,-6}}), iconTransformation(
          extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatHpOutIso[2]
    "Heat pump outlet CHW isolation valve control bus" annotation (Placement(
        transformation(extent={{-484,-86},{-444,-46}}), iconTransformation(
          extent={{-466,50},{-426,90}})));
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
  connect(datRea.y[2], addPar1.u) annotation (Line(points={{-159,100},{-132,100},
          {-132,0},{-122,0}}, color={0,0,127}));
  connect(addPar1.y, loaChiWat.TSet)
    annotation (Line(points={{-98,0},{128,0},{128,-64}},
                                                       color={0,0,127}));
  connect(datRea.y[6], reqFloCoo.TSupRef) annotation (Line(points={{-159,100},{
          -132,100},{-132,38},{-122,38}}, color={0,0,127}));
  connect(datRea.y[2], reqFloCoo.TRetRef) annotation (Line(points={{-159,100},{
          -132,100},{-132,34},{-122,34}}, color={0,0,127}));
  connect(datRea.y[3], reqFloCoo.mRef_flow) annotation (Line(points={{-159,100},
          {-132,100},{-132,30},{-122,30}}, color={0,0,127}));
  connect(senTemCooSup.T, reqFloCoo.TSupMea) annotation (Line(points={{50,-49},
          {50,4},{-90,4},{-90,46},{-130,46},{-130,26},{-122,26}}, color={0,0,
          127}));
  connect(hp.ports_bChiHeaWat, valIso.ports_aChiHeaWatHp) annotation (Line(
        points={{-648,-260},{-648,-242},{-650,-242},{-650,-156},{-575.875,-156},
          {-575.875,-160}},                                               color
        ={0,127,255}));
  connect(valIso.ports_bChiHeaWatHp, mov.port_a) annotation (Line(points={{-522.125,
          -160},{-524,-160},{-524,-168},{-508,-168},{-508,-178}},
                                          color={0,127,255}));
  connect(hp.ports_aChiHeaWat, mov.port_b) annotation (Line(points={{-548,-260},
          {-548,-212},{-508,-212},{-508,-198}}, color={0,127,255}));
  connect(weaDat.weaBus, hp.busWea) annotation (Line(
      points={{-480,190},{-472,190},{-472,148},{-572,148},{-572,-108},{-616,-108},
          {-616,-252},{-618,-252},{-618,-260}},
      color={255,204,51},
      thickness=0.5));
  connect(valIso.port_bHeaWat, junHeaWatBypSup1.port_3) annotation (Line(points={{-678,
          -133},{-678,-206},{-676,-206},{-676,-560},{-168,-560},{-168,-538}},
                                                                      color={0,127,
          255}));
  connect(junHeaWatBypSup.port_3, junHeaWatBypRet.port_3)
    annotation (Line(points={{-72,-518},{-72,-578}}, color={0,127,255}));
  connect(junHeaWatBypSup2.port_3, cheVal.port_a) annotation (Line(points={{-168,
          -578},{-154,-578},{-154,-472},{-212,-472},{-212,-464},{-220,-464},{-220,
          -446},{-210,-446}}, color={0,127,255}));
  connect(cheVal.port_b, mov1.port_a)
    annotation (Line(points={{-190,-446},{-182,-446}}, color={0,127,255}));
  connect(mov1.port_b, hp1.port_a1)
    annotation (Line(points={{-162,-446},{-146,-446}}, color={0,127,255}));
  connect(junHeaWatBypSup2.port_2, valIso.port_aHeaWat) annotation (Line(points={{-178,
          -588},{-690,-588},{-690,-117.571},{-678,-117.571}},       color={0,127,
          255}));
  connect(junChiWatBypSup.port_3, junChiWatBypRet.port_3)
    annotation (Line(points={{-72,-102},{-72,-130}}, color={0,127,255}));
  connect(valIso.port_bChiWat, junChiWatBypSup1.port_1) annotation (Line(points={{-420,
          -109.857},{-164,-109.857},{-164,-92},{-156,-92}},
                  color={0,127,255}));
  connect(junChiWatBypRet1.port_2, valIso.port_aChiWat) annotation (Line(points={{-156,
          -140},{-168,-140},{-168,-125.286},{-420,-125.286}},
                      color={0,127,255}));
  connect(cheVal1.port_b, mov2.port_a)
    annotation (Line(points={{-72,-426},{-90,-426}}, color={0,127,255}));
  connect(mov2.port_b, hp1.port_a2)
    annotation (Line(points={{-110,-426},{-126,-426}}, color={0,127,255}));
  connect(junChiWatBypRet1.port_3, cheVal1.port_a) annotation (Line(points={{-146,
          -150},{-146,-264},{-44,-264},{-44,-426},{-52,-426}},color={0,127,255}));
  connect(junChiWatBypSup.port_2, mov3.port_a) annotation (Line(points={{-62,-92},
          {-56,-92},{-56,-90},{-48,-90}},  color={0,127,255}));
  connect(mov3.port_b, senTemCooSup.port_a) annotation (Line(points={{-28,-90},{
          -20,-90},{-20,-60},{40,-60}}, color={0,127,255}));
  connect(junChiWatBypRet.port_1, pipChiWat.port_b) annotation (Line(points={{-62,
          -140},{-22,-140}},                                             color={
          0,127,255}));
  connect(junHeaWatBypRet.port_1, pipHeaWat.port_b) annotation (Line(points={{-62,
          -588},{0,-588}},                                           color={0,127,
          255}));
  connect(mov4.port_b, senTemHeaSup.port_a) annotation (Line(points={{40,-510},
          {130,-510}},                                 color={0,127,255}));
  connect(mov4.port_b, dpHeaWatRem[1].port_a) annotation (Line(points={{40,-510},
          {70,-510},{70,-520}},                                  color={0,127,255}));
  connect(junHeaWatBypSup.port_2, mov4.port_a) annotation (Line(points={{-62,-508},
          {12,-508},{12,-510},{20,-510}},                          color={0,127,
          255}));
  connect(conInt.y, extIndInt.u)
    annotation (Line(points={{-498,-490},{-482,-490}},
                                                 color={255,127,0}));
  connect(ctl.yMod[3], extIndInt.index) annotation (Line(points={{-338,36.6667},
          {-316,36.6667},{-316,144},{-564,144},{-564,-112},{-604,-112},{-604,
          -512},{-470,-512},{-470,-502}},                  color={255,127,0}));
  connect(ctl.y1HeaHp[1:2], busHp.y1Hea) annotation (Line(points={{-338,38},{-324,
          38},{-324,136},{-504,136},{-504,104},{-502,104}}, color={255,127,0}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(ctl.y1Hp[1:2], busHp.y1) annotation (Line(points={{-338,40},{-328,40},
          {-328,104},{-502,104}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(ctl.TSupSet[1:2], busHp.TSet) annotation (Line(points={{-338,-12},{-320,
          -12},{-320,140},{-536,140},{-536,104},{-502,104}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(busHp.y1_actual, ctl.u1Hp_actual[1:2]) annotation (Line(
      points={{-502,104},{-396,104},{-396,36.2},{-382,36.2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));

  connect(busHp, bus.hp) annotation (Line(
      points={{-502,104},{-544,104},{-544,-16},{-520,-16},{-520,-46}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(bus, hp.bus) annotation (Line(
      points={{-520,-46},{-520,-208},{-598,-208},{-598,-260}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(bus, valIso.bus) annotation (Line(
      points={{-520,-46},{-520,-76},{-549,-76},{-549,-117.571}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));

  connect(busValHeaWatHpInlIso, bus.valHeaWatHpInlIso) annotation (Line(
      points={{-506,64},{-508,64},{-508,-16},{-488,-16},{-488,-48},{-520,-48},{-520,
          -46}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(busValHeaWatHpOutIso, bus.valHeaWatHpOutIso) annotation (Line(
      points={{-502,28},{-556,28},{-556,-48},{-520,-48},{-520,-46}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(busValChiWatHpInlIso, bus.valChiWatHpInlIso) annotation (Line(
      points={{-464,-26},{-464,-28},{-520,-28},{-520,-46}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(busValChiWatHpOutIso, bus.valChiWatHpOutIso) annotation (Line(
      points={{-464,-66},{-464,-48},{-520,-48},{-520,-46}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
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
  connect(intEqu2.y, and1.u1) annotation (Line(points={{-348,-476},{-344,-476},{
          -344,-478},{-340,-478},{-340,-356},{-332,-356}}, color={255,0,255}));
  connect(intEqu1.y, and3.u1) annotation (Line(points={{-348,-506},{-348,-508},{
          -336,-508},{-336,-396},{-332,-396}}, color={255,0,255}));
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
  connect(ctl.y1ValHeaWatHpInlIso[1:2], busValHeaWatHpInlIso[:].y1) annotation (Line(
        points={{-338,34},{-328,34},{-328,-48},{-424,-48},{-424,64},{-506,64}},
        color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(ctl.y1ValHeaWatHpOutIso[1:2], busValHeaWatHpOutIso[:].y1) annotation (Line(
        points={{-338,32},{-324,32},{-324,-52},{-428,-52},{-428,28},{-502,28}},
        color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(ctl.y1ValChiWatHpOutIso[1:2], busValChiWatHpOutIso[:].y1) annotation (Line(
        points={{-338,28},{-316,28},{-316,-64},{-432,-64},{-432,-68},{-464,-68},
          {-464,-66}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(ctl.y1ValChiWatHpInlIso[1:2], busValChiWatHpInlIso[:].y1) annotation (Line(
        points={{-338,30},{-312,30},{-312,-48},{-320,-48},{-320,-56},{-432,-56},
          {-432,-28},{-464,-28},{-464,-26}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(booToRea3.y, mul.u1) annotation (Line(points={{-278,-356},{-268,-356},
          {-268,-350},{-262,-350}}, color={0,0,127}));
  connect(booToRea4.y, mul1.u1) annotation (Line(points={{-278,-396},{-276,-400},
          {-262,-400}}, color={0,0,127}));
  connect(mov.y_actual, greThr3.u) annotation (Line(points={{-501,-199},{-501,-200},
          {-490,-200},{-490,-218}},
                        color={0,0,127}));
  connect(greThr3[:].y, ctl.u1PumHeaWatPri_actual[1:2]) annotation (Line(points={{-490,
          -242},{-490,-252},{-440,-252},{-440,34.2},{-382,34.2}},
                                                color={255,0,255}));
  connect(greThr3[:].y, ctl.u1PumChiWatPri_actual[1:2]) annotation (Line(points={{-490,
          -242},{-490,-252},{-440,-252},{-440,32.2},{-382,32.2}},
                                                color={255,0,255}));
  connect(mov4.y_actual, greThr4.u) annotation (Line(points={{41,-503},{50,-503},
          {50,-610},{-18,-610}}, color={0,0,127}));
  connect(mov3.y_actual, greThr5.u) annotation (Line(points={{-27,-83},{-16,-83},
          {-16,-20},{-40,-20}},
        color={0,0,127}));
  connect(greThr.y, ctl.u1PumChiWatPri_actual[3]) annotation (Line(points={{-142,
          -406},{-262,-406},{-262,32.2},{-382,32.2}}, color={255,0,255}));
  connect(greThr1.y, ctl.u1PumHeaWatPri_actual[3]) annotation (Line(points={{-202,
          -510},{-264,-510},{-264,34.2},{-382,34.2}}, color={255,0,255}));
  connect(and3.y, booToRea4.u)
    annotation (Line(points={{-308,-396},{-302,-396}}, color={255,0,255}));
  connect(and1.y, booToRea3.u)
    annotation (Line(points={{-308,-356},{-302,-356}}, color={255,0,255}));
  connect(conPIDCoo.y, mul.u2) annotation (Line(points={{-202,-330},{-268,-330},
          {-268,-344},{-272,-344},{-272,-362},{-262,-362}}, color={0,0,127}));
  connect(mul.y, add2.u1) annotation (Line(points={{-238,-356},{-232,-356},{-232,
          -370}}, color={0,0,127}));
  connect(mul1.y, add2.u2) annotation (Line(points={{-238,-406},{-236,-406},{-236,
          -392},{-232,-392},{-232,-382}}, color={0,0,127}));
  connect(add2.y, hp1.ySet) annotation (Line(points={{-208,-376},{-147.1,-376},{
          -147.1,-437.9}}, color={0,0,127}));
  connect(ctl.TSupSet[3], conPIDCoo.u_s) annotation (Line(points={{-338,
          -11.3333},{-274,-11.3333},{-274,-306},{-170,-306},{-170,-330},{-178,
          -330}},
        color={0,0,127}));
  connect(ctl.TSupSet[3], conPIDHea.u_s) annotation (Line(points={{-338,
          -11.3333},{-220,-11.3333},{-220,-476},{-102,-476}},
                                                    color={0,0,127}));
  connect(hp1.port_b2, senTem.port_a) annotation (Line(points={{-146,-426},{-160,
          -426},{-160,-370}}, color={0,127,255}));
  connect(senTem.port_b, junChiWatBypSup1.port_3) annotation (Line(points={{-160,
          -350},{-160,-112},{-146,-112},{-146,-102}}, color={0,127,255}));
  connect(junHeaWatBypSup1.port_1, senTem1.port_b) annotation (Line(points={{-178,
          -528},{-188,-528},{-188,-548},{0,-548},{0,-440},{-44,-440},{-44,-444},
          {-96,-444},{-96,-446},{-104,-446}}, color={0,127,255}));
  connect(senTem1.port_a, hp1.port_b1)
    annotation (Line(points={{-124,-446},{-126,-446}}, color={0,127,255}));
  connect(conPIDHea.y, mul1.u2) annotation (Line(points={{-78,-476},{-68,-476},{
          -68,-496},{-272,-496},{-272,-412},{-262,-412}}, color={0,0,127}));
  connect(intEqu2.y, swi.u2) annotation (Line(points={{-348,-476},{-340,-476},{-340,
          -296},{-110,-296},{-110,-330},{-102,-330}}, color={255,0,255}));
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
  connect(ctl.y1PumChiWatPri[3], booToRea.u) annotation (Line(points={{-338,22},
          {-136,22},{-136,52},{-8,52},{-8,76},{104,76},{104,-96},{140,-96},{140,
          -386},{-8,-386}}, color={255,0,255}));
  connect(ctl.y1Hp[3], and1.u2) annotation (Line(points={{-338,40.6667},{-334,
          40.6667},{-334,-364},{-332,-364}},
                                    color={255,127,0}));
  connect(ctl.y1Hp[3], and3.u2) annotation (Line(points={{-338,40.6667},{-338,
          -185},{-332,-185},{-332,-404}},
                                    color={255,127,0}));
  connect(ctl.y1PumHeaWatPri[3], booToRea1.u) annotation (Line(points={{-338,24},
          {-312,24},{-312,88},{-188,88},{-188,200},{200,200},{200,-456},{-8,-456}},
        color={255,0,255}));
  connect(ctl.y1PumChiWatSec[1], booToRea2.u) annotation (Line(points={{-338,16},
          {-230,16},{-230,-40},{-142,-40}}, color={255,0,255}));
  connect(ctl.y1PumHeaWatSec[1], booToRea5.u) annotation (Line(points={{-338,18},
          {-176,18},{-176,-76},{-164,-76},{-164,-212},{12,-212},{12,-470},{18,-470}},
        color={255,0,255}));
  connect(booToRea6.y, mov.y) annotation (Line(points={{-400,-192},{-400,-200},{
          -488,-200},{-488,-188},{-496,-188}}, color={0,0,127}));
  connect(or2.y, booToRea6.u)
    annotation (Line(points={{-400,-162},{-400,-168}}, color={255,0,255}));
  connect(ctl.y1PumHeaWatPri[1:2], or2.u1) annotation (Line(points={{-338,24},{-320,
          24},{-320,-136},{-400,-136},{-400,-138}}, color={255,0,255}));
  connect(ctl.y1PumChiWatPri[1:2], or2.u2) annotation (Line(points={{-338,22},{-328,
          22},{-328,-132},{-408,-132},{-408,-138}}, color={255,0,255}));
  connect(booToRea2.y, mul2.u1) annotation (Line(points={{-118,-40},{-118,-34},{
          -92,-34}}, color={0,0,127}));
  connect(ctl.yPumChiWatSec, mul2.u2) annotation (Line(points={{-338,2},{-204,2},
          {-204,-60},{-100,-60},{-100,-46},{-92,-46}}, color={0,0,127}));
  connect(booToRea5.y, mul3.u1)
    annotation (Line(points={{42,-470},{58,-470},{58,-474}}, color={0,0,127}));
  connect(ctl.yPumHeaWatSec, mul3.u2) annotation (Line(points={{-338,4},{-194,4},
          {-194,-486},{58,-486}}, color={0,0,127}));
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
  connect(weaBus.TDryBul, ctl.TOut) annotation (Line(
      points={{-400.815,175.175},{-410,175.175},{-410,12},{-382,12}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(busSen, busSen2) annotation (Line(
      points={{62,-234},{64,-234},{64,-204},{-540,-204},{-540,0},{-522,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busSen2.THeaWatRetPri, ctl.THeaWatPriRet) annotation (Line(
      points={{-522,0},{-452,0},{-452,8},{-382,8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(busSen2.TChiWatSupPri, ctl.TChiWatPriSup) annotation (Line(
      points={{-522,0},{-452,0},{-452,4},{-382,4}},
      color={255,204,51},
      thickness=0.5));
  connect(busSen2.THeaWatSupPri, ctl.THeaWatPriSup) annotation (Line(
      points={{-522,0},{-452,0},{-452,10},{-382,10}},
      color={255,204,51},
      thickness=0.5));
  connect(busSen2.VHeaWatPri_flow, ctl.VHeaWatPri_flow) annotation (Line(
      points={{-522,0},{-452,0},{-452,6},{-382,6}},
      color={255,204,51},
      thickness=0.5));
  connect(busSen2.TChiWatRetPri, ctl.TChiWatPriRet) annotation (Line(
      points={{-522,0},{-452,0},{-452,2},{-382,2}},
      color={255,204,51},
      thickness=0.5));
  connect(busSen2.VChiWatPri_flow, ctl.VChiWatPri_flow) annotation (Line(
      points={{-522,0},{-382,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busSen2.THeaWatSupSec, ctl.THeaWatSecSup) annotation (Line(
      points={{-522,0},{-452,0},{-452,-2},{-382,-2}},
      color={255,204,51},
      thickness=0.5));
  connect(busSen2.THeaWatRetSec, ctl.THeaWatSecRet) annotation (Line(
      points={{-522,0},{-452,0},{-452,-4},{-382,-4}},
      color={255,204,51},
      thickness=0.5));
  connect(busSen2.VHeaWatSec_flow, ctl.VHeaWatSec_flow) annotation (Line(
      points={{-522,0},{-452,0},{-452,-8},{-382,-8}},
      color={255,204,51},
      thickness=0.5));
  connect(busSen2.THeaWatRetSec, ctl.THeaWatRetUpsHrc) annotation (Line(
      points={{-522,0},{-452,0},{-452,-6},{-382,-6}},
      color={255,204,51},
      thickness=0.5));
  connect(busSen2.TChiWatSupSec, ctl.TChiWatSecSup) annotation (Line(
      points={{-522,0},{-452,0},{-452,-10},{-382,-10}},
      color={255,204,51},
      thickness=0.5));
  connect(busSen2.TChiWatRetSec, ctl.TChiWatSecRet) annotation (Line(
      points={{-522,0},{-452,0},{-452,-12},{-382,-12}},
      color={255,204,51},
      thickness=0.5));
  connect(busSen2.VChiWatSec_flow, ctl.VChiWatSec_flow) annotation (Line(
      points={{-522,0},{-452,0},{-452,-16},{-382,-16}},
      color={255,204,51},
      thickness=0.5));
  connect(busSen2.TChiWatRetSec, ctl.TChiWatRetUpsHrc) annotation (Line(
      points={{-522,0},{-452,0},{-452,-14},{-382,-14}},
      color={255,204,51},
      thickness=0.5));
  connect(dpChiWatRem[1].p_rel, busSen.dpChiWatRem) annotation (Line(points={{30,-101},
          {30,-112},{12,-112},{12,-208},{32,-208},{32,-234},{62,-234}},
                                                color={0,0,127}));
  connect(dpHeaWatRem[1].p_rel, busSen.dpHeaWatRem) annotation (Line(points={{61,
          -530},{61,-532},{4,-532},{4,-384},{62,-384},{62,-234}}, color={0,0,127}));
  connect(busSen2.dpHeaWatRem, ctl.dpHeaWatRem[1]) annotation (Line(
      points={{-522,0},{-452,0},{-452,-18},{-382,-18}},
      color={255,204,51},
      thickness=0.5));
  connect(busSen2.dpChiWatRem, ctl.dpChiWatRem[1]) annotation (Line(
      points={{-522,0},{-452,0},{-452,-24},{-382,-24}},
      color={255,204,51},
      thickness=0.5));
  connect(greThr2.y, busSen.y1HRC_actual) annotation (Line(points={{-8,-420},{62,
          -420},{62,-234}}, color={255,0,255}));
  connect(busSen2.y1HRC_actual, ctl.u1Hp_actual[3]) annotation (Line(
      points={{-522,0},{-464,0},{-464,44},{-396,44},{-396,36.8667},{-382,
          36.8667}},
      color={255,204,51},
      thickness=0.5));

  connect(busSen2.y1HRC_actual, ctl.u1Hrc_actual) annotation (Line(
      points={{-522,0},{-464,0},{-464,44},{-396,44},{-396,36},{-392,36},{-392,26.2},
          {-382,26.2}},
      color={255,204,51},
      thickness=0.5));
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
  connect(bou.ports, mov.port_a) annotation (Line(points={{-550,-182},{-528,
          -182},{-528,-172},{-508,-172},{-508,-178}}, color={0,127,255}));
  connect(dpChiWatRem[1].port_a, senTemCooSup.port_b) annotation (Line(points={
          {40,-110},{40,-88},{68,-88},{68,-60},{60,-60}}, color={0,127,255}));
  connect(dpChiWatRem[1].port_b, pipChiWat.port_b) annotation (Line(points={{20,
          -110},{20,-128},{4,-128},{4,-124},{-32,-124},{-32,-140},{-22,-140}},
        color={0,127,255}));
  connect(dpHeaWatRem[1].port_b, pipHeaWat.port_b) annotation (Line(points={{70,
          -540},{70,-572},{-8,-572},{-8,-588},{0,-588}}, color={0,127,255}));
  connect(mul3.y, mov4.y) annotation (Line(points={{82,-480},{92,-480},{92,-500},
          {48,-500},{48,-492},{30,-492},{30,-498}}, color={0,0,127}));
  connect(mul2.y, mov3.y)
    annotation (Line(points={{-68,-40},{-38,-40},{-38,-78}}, color={0,0,127}));
  connect(greThr5.y, busSen.y1PumChiWatSec_actual) annotation (Line(points={{-64,
          -20},{-72,-20},{-72,-4},{-8,-4},{-8,-120},{8,-120},{8,-240},{36,-240},
          {36,-234},{62,-234}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(greThr4.y, busSen.y1PumHeaWatSec_actual) annotation (Line(points={{-42,
          -610},{-52,-610},{-52,-448},{-80,-448},{-80,-368},{60,-368},{60,-264},
          {62,-264},{62,-234}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(ctl.y1PumHeaWatSec[1], pre.u) annotation (Line(points={{-338,18},{-308,
          18},{-308,80},{-358,80}}, color={255,0,255}));
  connect(pre.y, ctl.u1PumHeaWatSec_actual[1]) annotation (Line(points={{-382,80},
          {-400,80},{-400,30.2},{-382,30.2}}, color={255,0,255}));
  connect(reqPlaRes.yChiWatResReq, mulInt[1].u2) annotation (Line(points={{68,
          140},{12,140},{12,126},{2,126}}, color={255,127,0}));
  connect(reqPlaRes.yChiPlaReq, mulInt[2].u2)
    annotation (Line(points={{68,135},{68,126},{2,126}}, color={255,127,0}));
  connect(reqPlaRes.yHotWatResReq, mulInt[3].u2) annotation (Line(points={{68,
          129},{12,129},{12,126},{2,126}}, color={255,127,0}));
  connect(reqPlaRes.yHotWatPlaReq, mulInt[4].u2) annotation (Line(points={{68,
          124},{12,124},{12,126},{2,126}}, color={255,127,0}));
  connect(mulInt[1].y, ctl.nReqResChiWat) annotation (Line(points={{-22,132},{
          -442,132},{-442,14},{-382,14}}, color={255,127,0}));
  connect(mulInt[2].y, ctl.nReqPlaChiWat) annotation (Line(points={{-22,132},{
          -444,132},{-444,16},{-392,16},{-392,18},{-382,18}}, color={255,127,0}));
  connect(mulInt[3].y, ctl.nReqResHeaWat) annotation (Line(points={{-22,132},{
          -444,132},{-444,16},{-382,16}}, color={255,127,0}));
  connect(mulInt[4].y, ctl.nReqPlaHeaWat) annotation (Line(points={{-22,132},{
          -444,132},{-444,16},{-392,16},{-392,20},{-382,20}}, color={255,127,0}));
  connect(pre1.y, ctl.u1PumChiWatSec_actual[1]) annotation (Line(points={{-358,
          60},{-392,60},{-392,28.2},{-382,28.2}}, color={255,0,255}));
  connect(ctl.y1PumChiWatSec[1], pre1.u) annotation (Line(points={{-338,16},{
          -326,16},{-326,60},{-334,60}}, color={255,0,255}));
  connect(booToRea.y, mov2.y) annotation (Line(points={{-32,-386},{-32,-388},{-100,
          -388},{-100,-414}}, color={0,0,127}));
  connect(booToRea1.y, mov1.y) annotation (Line(points={{-32,-456},{-102,-456},{
          -102,-458},{-172,-458}}, color={0,0,127}));
  connect(weaDat.weaBus, out.weaBus) annotation (Line(
      points={{-480,190},{-472,190},{-472,208},{-700,208},{-700,-172},{-584,-172},
          {-584,-216},{-504,-216},{-504,-212},{-348,-212},{-348,-439.8},{-260,-439.8}},
      color={255,204,51},
      thickness=0.5));

  connect(out.ports[1], hp1.port_b3) annotation (Line(points={{-240,-441},{-236,
          -441},{-236,-424},{-224,-424},{-224,-420},{-152,-420},{-152,-423.9},{-136,
          -423.9}}, color={0,127,255}));
  connect(out.ports[2], mov5.port_a) annotation (Line(points={{-240,-439},{-236,
          -439},{-236,-424},{-268,-424},{-268,-484},{-258,-484}}, color={0,127,255}));
  connect(mov5.port_b, hp1.port_a3) annotation (Line(points={{-238,-484},{-136,-484},
          {-136,-448}}, color={0,127,255}));
  connect(xor.y, booToRea7.u)
    annotation (Line(points={{-298,-480},{-296,-480}}, color={255,0,255}));
  connect(booToRea7.y, mov5.y) annotation (Line(points={{-272,-480},{-260,-480},
          {-260,-472},{-248,-472}}, color={0,0,127}));
  connect(booToRea.u, xor.u1) annotation (Line(points={{-8,-386},{-164,-386},{-164,
          -480},{-322,-480}}, color={255,0,255}));
  connect(booToRea1.u, xor.u2) annotation (Line(points={{-8,-456},{-4,-456},{-4,
          -512},{-56,-512},{-56,-560},{-164,-560},{-164,-552},{-332,-552},{-332,
          -488},{-322,-488}}, color={255,0,255}));
  connect(reqFloCoo.mReq_flow, norFlo1[2].u) annotation (Line(points={{-98,34},{
          -60,34},{-60,36},{-20,36},{-20,100},{16,100}}, color={0,0,127}));
  connect(TDum1.y, reqFloHea.TMinRef) annotation (Line(points={{-138,170},{-136,
          170},{-136,84},{-128,84},{-128,92},{-122,92}}, color={0,0,127}));
  connect(reqFloHea.mReq_flow, norFlo1[1].u) annotation (Line(points={{-98,104},
          {-20,104},{-20,100},{16,100}}, color={0,0,127}));
  connect(reqFloHea.TRet, loaHeaWat.TSet) annotation (Line(points={{-98,96},{8,96},
          {8,80},{164,80},{164,-508},{180,-508},{180,-520}}, color={0,0,127}));
  connect(reqFloHea.TRet, busSen.THeaWatRetSec) annotation (Line(points={{-98,96},
          {8,96},{8,80},{164,80},{164,-232},{100,-232},{100,-204},{62,-204},{62,
          -234}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/HeatPumps/Validation/AirToWater.mos"
        "Simulate and plot"),
    experiment(
      StartTime=15638400,
      StopTime=16156800,
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
end AirToWater_Buffalo_nonTemplate;
