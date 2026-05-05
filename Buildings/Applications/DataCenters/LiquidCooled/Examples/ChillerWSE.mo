within Buildings.Applications.DataCenters.LiquidCooled.Examples;
model ChillerWSE
  "Example model of a simple liquid cooled data center with chiller and water-side economizer"
  extends Modelica.Icons.Example;

  package MediumChi = Buildings.Media.Water "Medium for chilled water loop";
  package MediumRac = Buildings.Media.Antifreeze.PropyleneGlycolWater(
    T_default=303.15,
    property_T=303.15,
    X_a=Buildings.Media.Antifreeze.Functions.PropyleneGlycolWater.volumeToMassFraction(
        phi=0.25,
        T=293.15))
    "Medium for rack";

  parameter Modelica.Units.SI.Power PRac = 1E6
    "Total rack design power";
  parameter Real fraWSE = 0.9 "Fraction of peak load covered by water side economizer";
  parameter Real fraChi = 1-fraWSE "Fraction of peak load covered by chiller";

  parameter Modelica.Units.SI.TemperatureDifference dTRac_nominal(max=0) = -5
    "Temperature difference rack loop";

  parameter Modelica.Units.SI.TemperatureDifference dTPla_nominal(max=0) = -5
    "Temperature difference cooling plant loop";
  final parameter Modelica.Units.SI.TemperatureDifference dTTow_nominal(max=0) =
    dTPla_nominal
    "Temperature difference tower water loop (same as chilled water loop, as it is assumed for TSetCooTowOut_nominal";

  parameter Modelica.Units.SI.Temperature TRacSup_nominal=273.15 + 45
    "Supply coolant temperature to rack at design conditions";
  parameter Modelica.Units.SI.Temperature TRacRet_nominal=TRacSup_nominal-dTRac_nominal
    "Return coolant temperature from rack at design conditions";
  parameter Modelica.Units.SI.Temperature TPlaSup_nominal=TRacSup_nominal - 6
    "Temperature from cooling plant to CDU at design conditions";
  parameter Modelica.Units.SI.Temperature TPlaRet_nominal=TPlaSup_nominal -
      dTPla_nominal
    "Temperature from CDU to cooling plant at design conditions";
  parameter Modelica.Units.SI.Temperature TTowSup_nominal=TPlaSup_nominal+5
    "Supply temperature to cooling tower";
  parameter Modelica.Units.SI.Temperature TTowRet_nominal=TTowSup_nominal+dTTow_nominal
    "Supply temperature to cooling tower";

  parameter Modelica.Units.SI.MassFlowRate mRac_flow_nominal=PRac/(
      TRacRet_nominal - TRacSup_nominal)/MediumRac.cp_const
    "Rack mass flow rate at design conditions";
  parameter Modelica.Units.SI.MassFlowRate mPla_flow_nominal=PRac/(
      TPlaRet_nominal -TPlaSup_nominal) /MediumChi.cp_const
    "Cooling loop water mass flow rate at design conditions";


  parameter Modelica.Units.SI.PressureDifference dpVal_nominal(
    displayUnit="Pa")=20000
    "Valve design pressure drop";
   parameter Modelica.Units.SI.PressureDifference dpHexChi_nominal=80000
    "Heat exchanger design pressure drop on chiller side";
  parameter Modelica.Units.SI.PressureDifference dPRac_nominal = 60000
    "Rack design pressure drop";
  parameter Buildings.Applications.DataCenters.LiquidCooled.Racks.Data.OCP_1kW_OAM_PG25 datTheRes
    "Thermal resistance data"
    annotation (Placement(transformation(extent={{60,-98},{80,-78}})));

  parameter Real COPc_nominal=5 "Chiller COP";
  parameter Real epsWSE_nominal(min=0.5, max=0.95) = 0.9
    "Effectiveness of water side economizer";

  parameter Modelica.Units.SI.Temperature TSetCooTowOut_nominal =
      TPlaRet_nominal - (TPlaRet_nominal-TPlaSup_nominal)/epsWSE_nominal - 3
    "Set point for cooling tower outlet temperature to meet design load with WSE";

  final parameter Modelica.Units.SI.HeatFlowRate QCon_flow_nominal =
    (1-fraWSE) * PRac * (1/COPc_nominal+1)
    "Design heat flow rate of condenser";
  final parameter Modelica.Units.SI.HeatFlowRate QWSE_flow_nominal = PRac
    "Design heat flow rate of condenser, designed for full load (when temperatures allow)";
  final parameter Modelica.Units.SI.MassFlowRate mEva_flow_nominal(min=0)=mPla_flow_nominal
    "Nominal mass flow rate at condenser water, sized to circulate all water through it to meet set point when trim chiller is needed";
  final parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal(min=0)=mWSE_flow_nominal
    "Nominal mass flow rate at condenser water";
  final parameter Modelica.Units.SI.MassFlowRate mWSE_flow_nominal(min=0)=mPla_flow_nominal
    "Nominal mass flow rate at condenser water";
  parameter CDUs.Data.Generic_2MW datCDU(
    TApp_nominal=TRacSup_nominal - TPlaRet_nominal,
    TRacOut_nominal=TRacSup_nominal,
    medPla=Buildings.Applications.DataCenters.LiquidCooled.Types.Media.Water,
    phiGlyPla=0,
    medRac=Buildings.Applications.DataCenters.LiquidCooled.Types.Media.PropyleneGlycol,
    phiGlyRac=0.25,
    Q_flow_nominal=-PRac,
    mPla_flow_nominal=mPla_flow_nominal,
    mRac_flow_nominal=mRac_flow_nominal,
    dpHexPla_nominal=dpHexChi_nominal,
    dpPum_nominal=dPRac_nominal) "Data record for CDU"
    annotation (Placement(transformation(extent={{60,62},{80,82}})));
  parameter Fluid.HeatExchangers.CoolingTowers.Data.DryCooler.Generic datCooTow(
    Q_flow_nominal=-PRac,
    TCooIn_nominal=TTowSup_nominal,
    TCooOut_nominal=TTowRet_nominal,
    dp_nominal=80000)
    "Performance data for cooling tower"
    annotation (Placement(transformation(extent={{20,580},{40,600}})));

  Controls.OBC.CDL.Reals.Sources.Constant uti(k=0.6)
    "Utilization of hardware"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Applications.DataCenters.LiquidCooled.Racks.ColdPlateR_P rac(
    redeclare package Medium = MediumRac,
    allowFlowReversal=false,
    Q_flow_nominal=PRac,
    m_flow_nominal=mRac_flow_nominal,
    datTheRes=datTheRes,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Rack with cold plate heat exchangers, modeled for simplicity as one large rack"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = MediumChi,
    p(displayUnit="Pa") = 300000,
      nPorts=1) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{292,110},{272,130}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTCDU_a(
    redeclare package Medium = MediumChi,
    allowFlowReversal=false,
    m_flow_nominal=mPla_flow_nominal,
    tau=0) "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-50,110},{-30,130}})));

  Buildings.Applications.DataCenters.LiquidCooled.CDUs.CDU_epsNTU cdu(
    redeclare package MediumPla = MediumChi,
    redeclare package MediumRac = MediumRac,
    final dat=datCDU,
    allowFlowReversalPla=false,
    allowFlowReversalRac=false,
    yPum_start=1) "CDU, modeled for simplicity as one large CDU"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Fluid.Sensors.TemperatureTwoPort senTCDU_b(
    redeclare package Medium = MediumChi,
    allowFlowReversal=false,
    m_flow_nominal=mPla_flow_nominal,
    tau=0) "Outlet temperature"
    annotation (Placement(transformation(extent={{30,110},{50,130}})));
  Fluid.Sensors.TemperatureTwoPort senTRac_a(
    redeclare package Medium = MediumRac,
    allowFlowReversal=false,
    m_flow_nominal=mRac_flow_nominal,
    tau=0) "Rack inlet temperature"
    annotation (Placement(transformation(extent={{-30,24},{-50,44}})));
  Fluid.Sensors.TemperatureTwoPort senTRac_b(
    redeclare package Medium = MediumRac,
    allowFlowReversal=false,
    m_flow_nominal=mRac_flow_nominal,
    tau=0) "Rack outlet temperature"
    annotation (Placement(transformation(extent={{50,24},{30,44}})));
  Fluid.Sources.Boundary_pT preSou(
    redeclare package Medium = MediumRac,
    nPorts=1)
    "Pressure boundary condition"
    annotation (Placement(transformation(extent={{110,-70},{90,-50}})));
  Controls.OBC.CDL.Reals.Sources.Constant yPum(k=1)
    "Pump control signal"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Controls.OBC.CDL.Reals.PID conVal(
    u_s(final unit="K",
        displayUnit="degC"),
    u_m(final unit="K",
        displayUnit="degC"),
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    Ti=120,
    r=10,
    xi_start=1,
    reverseActing=false) "Controller for valve"
    annotation (Placement(transformation(extent={{-50,60},{-30,80}})));
  Controls.OBC.CDL.Reals.Sources.Constant TSetRacIn(y(final unit="K",
        displayUnit="degC"), k(
      final unit="K",
      displayUnit="degC") = TRacSup_nominal)
    "Set point for rack inlet temperature"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Fluid.HeatExchangers.ConstantEffectiveness wse(
    redeclare package Medium1 = MediumChi,
    redeclare package Medium2 = MediumChi,
    m1_flow_nominal=mWSE_flow_nominal,
    m2_flow_nominal=mWSE_flow_nominal,
    show_T=true,
    eps=epsWSE_nominal,
    dp2_nominal=dpHexChi_nominal,
    dp1_nominal=dpHexChi_nominal)
                   "Water side economizer (Heat exchanger)"
    annotation (Placement(transformation(extent={{120,321},{100,341}})));
  Fluid.Chillers.Carnot_TEva chi(
    redeclare package Medium1 = MediumChi,
    redeclare package Medium2 = MediumChi,
    m1_flow_nominal=mCon_flow_nominal,
    m2_flow_nominal=mEva_flow_nominal,
    show_T=true,
    QEva_flow_nominal=-(1-fraWSE)*PRac,
    dTEva_nominal=TPlaSup_nominal -TPlaRet_nominal,
    dTCon_nominal=-dTTow_nominal,
    dp2_nominal=dpHexChi_nominal,
    dp1_nominal=dpHexChi_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Chiller"
    annotation (Placement(transformation(extent={{-120,321},{-140,341}})));
  Fluid.HeatExchangers.CoolingTowers.DryCooler cooTow(
    redeclare package Medium = MediumChi,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dat=datCooTow)
    "Cooling tower"
    annotation (Placement(
        transformation(
        extent={{-9.5,-9.5},{9.5,9.5}},
        origin={-0.5,619.5})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaData(filNam=
        ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    annotation (Placement(transformation(extent={{-122,640},{-102,660}})));
  BoundaryConditions.WeatherData.Bus weaBus
    annotation (Placement(transformation(extent={{-72,640},{-52,660}}),
        iconTransformation(extent={{-176,140},{-156,160}})));
  Fluid.Movers.Preconfigured.SpeedControlled_y pumEva(
    redeclare package Medium = MediumChi,
    addPowerToMedium=false,
    m_flow_nominal=mEva_flow_nominal,
    dp_nominal=dpHexChi_nominal) "Pump chiller evaporator"    annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-80,290})));
  Fluid.Movers.Preconfigured.SpeedControlled_y pumWSEChi(
    redeclare package Medium = MediumChi,
    addPowerToMedium=false,
    m_flow_nominal=mWSE_flow_nominal,
    dp_nominal=dpHexChi_nominal) "Pump for water-side economizer" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={160,290})));
  Fluid.Movers.Preconfigured.SpeedControlled_y pumTow(
    redeclare package Medium = MediumChi,
    allowFlowReversal=false,
    addPowerToMedium=false,
    riseTime=5,
    m_flow_nominal=mWSE_flow_nominal,
    dp_nominal=dpHexChi_nominal) "Pump for tower loop" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-220,600})));
  Fluid.Sensors.TemperatureTwoPort senTWSE_b2(
    redeclare package Medium = MediumChi,
    m_flow_nominal=mWSE_flow_nominal,
    tau=0) "Chilled water outlet temperature of water side economizer"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={60,290})));
  Fluid.Movers.Preconfigured.SpeedControlled_y pumCon(
    redeclare package Medium = MediumChi,
    addPowerToMedium=false,
    m_flow_nominal=mCon_flow_nominal,
    dp_nominal=dpHexChi_nominal) "Pump for chiller condenser" annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-80,420})));
  Fluid.Sensors.TemperatureTwoPort senTTow_b(
    redeclare package Medium = MediumChi,
    allowFlowReversal=false,
    m_flow_nominal=mWSE_flow_nominal,
    tau=0) "Outlet water temperature of tower"
    annotation (Placement(transformation(extent={{60,610},{80,630}})));
  Fluid.FixedResistances.Junction jun1(
    redeclare package Medium = MediumChi,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mWSE_flow_nominal*{1,1,1},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={160,540})));
  Fluid.FixedResistances.Junction jun2(redeclare package Medium = MediumChi,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mPla_flow_nominal*{1,1,fraWSE},
    dp_nominal={0,0,0})   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={60,220})));
  Fluid.FixedResistances.Junction jun3(redeclare package Medium = MediumChi,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mPla_flow_nominal*{1,1,fraWSE},
    dp_nominal={0,0,0})   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={160,220})));
  Fluid.Sensors.TemperatureTwoPort senTEvaIn(
    redeclare package Medium = MediumChi,
    allowFlowReversal=false,
    m_flow_nominal=mPla_flow_nominal,
    tau=0) "Chiller inlet temperature to evaporator"
    annotation (Placement(transformation(extent={{0,210},{-20,230}})));
  Fluid.FixedResistances.Junction jun4(redeclare package Medium = MediumChi,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mPla_flow_nominal*{1,1,fraChi},
    dp_nominal={0,0,0})   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-80,220})));
  Fluid.FixedResistances.Junction jun5(redeclare package Medium = MediumChi,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mPla_flow_nominal*{1,1,fraChi},
    dp_nominal={0,0,0})   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-180,220})));
  Fluid.Sensors.TemperatureTwoPort senTEvaOut(
    redeclare package Medium = MediumChi,
    m_flow_nominal=mEva_flow_nominal,
    tau=0) "Chilled water outlet temperature of chiller" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-180,290})));
  Fluid.Sensors.TemperatureTwoPort senTChi_b1(
    redeclare package Medium = MediumChi,
    m_flow_nominal=mCon_flow_nominal,
    tau=0) "Cooling tower water outlet temperature of chiller" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-180,370})));
  Fluid.Sensors.TemperatureTwoPort senTWSE_b1(
    redeclare package Medium = MediumChi,
    m_flow_nominal=mWSE_flow_nominal,
    tau=0) "Cooling tower water outlet temperature of water side economizer"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={60,370})));
  Fluid.Movers.Preconfigured.SpeedControlled_y pumWSECW(
    redeclare package Medium = MediumChi,
    addPowerToMedium=false,
    m_flow_nominal=mWSE_flow_nominal,
    dp_nominal=dpHexChi_nominal)
    "Pump for water side economizer on cooling tower side" annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={160,420})));
  Fluid.Movers.Preconfigured.FlowControlled_dp pumCDU(
    redeclare package Medium = MediumChi,
    allowFlowReversal=false,
    addPowerToMedium=false,
    use_riseTime=false,
    m_flow_nominal=mPla_flow_nominal,
    dp_nominal=dpHexChi_nominal) "Pump chilled water circuit" annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={220,170})));
  Fluid.FixedResistances.Junction jun6(
    redeclare package Medium = MediumChi,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mWSE_flow_nominal*{1,1,1},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={60,540})));
  Fluid.FixedResistances.Junction jun7(
    redeclare package Medium = MediumChi,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mWSE_flow_nominal*{1,1,1},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-80,540})));
  Fluid.FixedResistances.Junction jun8(
    redeclare package Medium = MediumChi,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mWSE_flow_nominal*{1,1,1},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-180,540})));
  Controls.OBC.CDL.Reals.PID conTow(
    k=1,
    yMax=1,
    yMin=0.1,
    u_s(final unit="K", displayUnit="degC"),
    u_m(final unit="K", displayUnit="degC"),
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    Ti=120,
    r=1,
    xi_start=1,
    reverseActing=false) "Controller for tower fan and pump"
    annotation (Placement(transformation(extent={{60,700},{80,720}})));
  Controls.OBC.CDL.Reals.Sources.Constant TSetEva(y(final unit="K", displayUnit
        ="degC"), k(
      final unit="K",
      displayUnit="degC") =TPlaSup_nominal)
    "Set point temperature for evaporator outlet temperature"
    annotation (Placement(transformation(extent={{-560,340},{-540,360}})));
  Controls.OBC.CDL.Reals.Sources.Constant pSetChiWatPum(
    y(final unit="Pa"),
    k(final unit="Pa") = dpHexChi_nominal)
    "Pressure setpoint for chilled water pump"
    annotation (Placement(transformation(extent={{160,160},{180,180}})));
  Controls.OBC.CDL.Reals.Hysteresis hysChi(
    uLow=1.1,
    uHigh=1.2,
    u(final unit="K")) "Hysteresis for chiller staging"
    annotation (Placement(transformation(extent={{-400,250},{-380,270}})));
  Controls.OBC.CDL.Reals.Subtract TAppWSE1(
    u1(final unit="K", displayUnit="degC"),
    u2(final unit="K", displayUnit="degC"),
    y(final unit="K"))
   "Approach temperature for economizer"
    annotation (Placement(transformation(extent={{-440,200},{-420,220}})));
  Controls.OBC.CDL.Conversions.BooleanToReal yPumChi(y(final unit="kg/s"),
      realTrue(final unit="kg/s"))
    "Control signal for chiller circulation pumps"
    annotation (Placement(transformation(extent={{-300,250},{-280,270}})));
  Fluid.Sources.Boundary_pT bou1(
    redeclare package Medium = MediumChi,
    p(displayUnit="Pa") = 300000,
    nPorts=1)   "Pressure boundary condition"
    annotation (Placement(transformation(extent={{248,610},{228,630}})));
  Controls.OBC.CDL.Reals.AddParameter TOffSet(p=0)
    "Offset for set point (for testing only)"
    annotation (Placement(transformation(extent={{-530,340},{-510,360}})));
  Modelica.Blocks.Sources.RealExpression PFan(y(final unit="W") = cooTow.PFan)
    "Power consumption of tower fans"
    annotation (Placement(transformation(extent={{360,48},{380,68}})));
  Modelica.Blocks.Sources.RealExpression PPum(y(final unit="W") = cdu.P +
      pumWSEChi.P + pumWSECW.P + pumEva.P + pumCon.P + pumTow.P)
    "Power consumption of pumps"
    annotation (Placement(transformation(extent={{360,8},{380,28}})));
  Modelica.Blocks.Sources.RealExpression PChi(y(final unit="W") = chi.P)
    "Power consumption of chiller"
    annotation (Placement(transformation(extent={{360,-32},{380,-12}})));
  Modelica.Blocks.Sources.RealExpression PIT(y(final unit="W") = rac.P)
    "Power consumption of IT"
    annotation (Placement(transformation(extent={{360,-72},{380,-52}})));
  model ElectricalEnergyMeter
    extends Modelica.Blocks.Continuous.Integrator(
      u(final unit="W"),
      y(final unit="J",
        displayUnit="Wh"),
      final k = 1,
      final use_reset=false,
      final initType=Modelica.Blocks.Types.Init.InitialState,
      y_start=0);
  end ElectricalEnergyMeter;
  ElectricalEnergyMeter EFan "Energy meter"
    annotation (Placement(transformation(extent={{400,48},{420,68}})));
  ElectricalEnergyMeter EPum "Energy meter"
    annotation (Placement(transformation(extent={{400,8},{420,28}})));
  ElectricalEnergyMeter EChi "Energy meter"
    annotation (Placement(transformation(extent={{400,-32},{420,-12}})));
  ElectricalEnergyMeter EPIT(y_start=1E-10)
                             "Energy meter"
    annotation (Placement(transformation(extent={{400,-72},{420,-52}})));
  Modelica.Blocks.Math.MultiSum EFac(nu=4) "Electricity for facility"
    annotation (Placement(transformation(extent={{454,12},{466,24}})));
  Modelica.Blocks.Math.Division PUE
    "Power use effectiveness (not taking into account electrical losses)"
    annotation (Placement(transformation(extent={{500,-42},{520,-22}})));
  Fluid.Sensors.TemperatureTwoPort senTWSEMix(
    redeclare package Medium = MediumChi,
    allowFlowReversal=false,
    m_flow_nominal=mWSE_flow_nominal,
    tau=0) "Water temperature cooling tower loop after WSE"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-10,540})));
  Fluid.Actuators.Valves.TwoWayLinear valByp(
    redeclare package Medium = MediumChi,
    m_flow_nominal=mCon_flow_nominal,
    final dpValve_nominal=dpVal_nominal,
    strokeTime=30)                       "Valve for condenser loop bypass"
    annotation (Placement(transformation(extent={{-140,450},{-120,470}})));
  Fluid.Actuators.Valves.TwoWayLinear valThr(
    redeclare package Medium = MediumChi,
    m_flow_nominal=mCon_flow_nominal,
    final dpValve_nominal=dpVal_nominal,
    strokeTime=30,
    y_start=0) "Valve for condenser loop from cooling tower" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-80,500})));
  Fluid.FixedResistances.Junction jun9(
    redeclare package Medium = MediumChi,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mCon_flow_nominal*{1,1,1},
    dp_nominal={0,0,0}) "Junction at condenser loop["
                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-80,460})));
  Fluid.FixedResistances.Junction jun10(
    redeclare package Medium = MediumChi,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mCon_flow_nominal*{1,1,1},
    dp_nominal={0,0,0}) "Junction at condenser loop["
                        annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-180,460})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTChi_a1(
    redeclare package Medium = MediumChi,
    m_flow_nominal=mCon_flow_nominal,
    tau=0) "Cooling tower water inlet temperature of chiller" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-80,370})));
  Controls.OBC.CDL.Reals.PIDWithReset conPIDCon(
    Ti=60,
    r=1,
    reverseActing=false,
    u_s(
      final unit="K",
      displayUnit="degC"),
    u_m(
      final unit="K",
      displayUnit="degC"))
    "Controller for minimum chiller lift"
    annotation (Placement(transformation(extent={{-360,420},{-340,440}})));
  Controls.OBC.CDL.Reals.AddParameter TLifMin(p(
      unit="K",
    displayUnit="K") = 10,
    u(final unit="K",
      displayUnit="degC"),
    y(final unit="K",
      displayUnit="degC"))
                          "Minimum lift of chiller"
    annotation (Placement(transformation(extent={{-400,420},{-380,440}})));
  Controls.OBC.CDL.Reals.MultiplyByParameter invValSig(k=-1)
    "Invert valve signal"
    annotation (Placement(transformation(extent={{-320,470},{-300,490}})));
  Controls.OBC.CDL.Reals.AddParameter invValSig2(p=1)
    "Invert valve control signal"
    annotation (Placement(transformation(extent={{-280,470},{-260,490}})));
  Controls.OBC.CDL.Reals.Sources.Ramp ram(
    height=-0.7,
    duration(displayUnit="d") = 31536000,
    offset=1)
    annotation (Placement(transformation(extent={{-140,-6},{-120,14}})));
  Fluid.Sensors.TemperatureTwoPort senTTow_a(
    redeclare package Medium = MediumChi,
    allowFlowReversal=false,
    m_flow_nominal=mWSE_flow_nominal,
    tau=0) "Inlet water temperature of tower"
    annotation (Placement(transformation(extent={{-80,610},{-60,630}})));

  Controls.OBC.CDL.Reals.AddParameter TOffSetWSE(p=-2)
    "Offset for set point for WSE control"
    annotation (Placement(transformation(extent={{20,700},{40,720}})));
  Fluid.Sensors.MassFlowRate senMasFloByEco(redeclare package Medium =
        MediumChi) "Mass flow rate sensor in economizer bypass" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={108,220})));
  Controls.OBC.CDL.Reals.PID conEcoPla(
    k=0.1,
    yMin=0.1,
    u_s(final unit="kg/s"),
    u_m(final unit="kg/s"),
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    Ti=60,
    r=mWSE_flow_nominal,
    xi_start=1,
    reverseActing=false) "Controller for economizer pump on facility level"
    annotation (Placement(transformation(extent={{240,260},{260,280}})));
  Controls.OBC.CDL.Reals.Sources.Constant zer(
      k = 0) "Zero as a set point"
    annotation (Placement(transformation(extent={{200,260},{220,280}})));
  Fluid.Sensors.MassFlowRate senMasFlo3(redeclare package Medium = MediumChi)
    "Mass flow rate sensor" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={110,540})));
  Controls.OBC.CDL.Reals.Limiter yPumTow(uMax=1, uMin=0.1)
    "Pump control signal"
    annotation (Placement(transformation(extent={{-400,590},{-380,610}})));
  Controls.OBC.CDL.Reals.Sources.Constant zer1(k=0)
             "Zero as a set point"
    annotation (Placement(transformation(extent={{180,460},{200,480}})));
  Controls.OBC.CDL.Reals.PID conEcoTow(
    k=0.1,
    yMin=0.1,
    u_s(final unit="kg/s"),
    u_m(final unit="kg/s"),
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    Ti=60,
    r=mWSE_flow_nominal,
    xi_start=1,
    reverseActing=false) "Controller for economizer pump on tower loop"
    annotation (Placement(transformation(extent={{220,460},{240,480}})));
  Controls.OBC.CDL.Reals.Sources.Constant TSetTowRet(y(final unit="K",
        displayUnit="degC"), k(
      final unit="K",
      displayUnit="degC") = TTowRet_nominal)
    "Set point temperature for tower return temperature"
    annotation (Placement(transformation(extent={{-20,700},{0,720}})));
  Controls.OBC.CDL.Reals.PID conPumTow(
    k=1,
    yMax=2,
    yMin=0,
    u_s(final unit="K", displayUnit="degC"),
    u_m(final unit="K", displayUnit="degC"),
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    Ti=120,
    r=1,
    xi_start=1,
    reverseActing=false) "Controller for tower pump"
    annotation (Placement(transformation(extent={{-480,590},{-460,610}})));
equation
  connect(senTCDU_a.port_b, cdu.port_aPla) annotation (Line(points={{-30,120},{-20,
          120},{-20,46},{-10,46}},color={0,127,255}));
  connect(cdu.port_bPla, senTCDU_b.port_a) annotation (Line(points={{10,46},{20,46},
          {20,120},{30,120}},
                            color={0,127,255}));
  connect(senTCDU_b.port_b, bou.ports[1])
    annotation (Line(points={{50,120},{272,120}},
                                               color={0,127,255}));
  connect(yPum.y, cdu.yPum) annotation (Line(points={{-28,0},{-20,0},{-20,31},{-12,
          31}},      color={0,0,127}));
  connect(TSetRacIn.y, conVal.u_s)
    annotation (Line(points={{-78,70},{-52,70}}, color={0,0,127}));
  connect(senTRac_a.T, conVal.u_m)
    annotation (Line(points={{-40,45},{-40,58}},  color={0,0,127}));
  connect(conVal.y, cdu.yVal) annotation (Line(points={{-28,70},{-16,70},{-16,49},
          {-12,49}}, color={0,0,127}));
  connect(cdu.port_bRac, senTRac_a.port_a)
    annotation (Line(points={{-10,34},{-30,34}}, color={0,127,255}));
  connect(senTRac_a.port_b, rac.port_a) annotation (Line(points={{-50,34},{-72,34},
          {-72,-60},{0,-60}}, color={0,127,255}));
  connect(rac.port_b, senTRac_b.port_a) annotation (Line(points={{20,-60},{70,-60},
          {70,34},{50,34}}, color={0,127,255}));
  connect(senTRac_b.port_b, cdu.port_aRac) annotation (Line(points={{30,34},{22,34},
          {22,34},{10,34}}, color={0,127,255}));
  connect(rac.port_b, preSou.ports[1])
    annotation (Line(points={{20,-60},{90,-60}}, color={0,127,255}));
  connect(senTCDU_b.port_b, pumCDU.port_a) annotation (Line(points={{50,120},{220,
          120},{220,160}}, color={0,127,255}));
  connect(pumCDU.port_b, jun3.port_1) annotation (Line(points={{220,180},{220,220},
          {170,220}}, color={0,127,255}));
  connect(jun2.port_2, senTEvaIn.port_a)
    annotation (Line(points={{50,220},{0,220}}, color={0,127,255}));
  connect(senTEvaIn.port_b, jun4.port_1)
    annotation (Line(points={{-20,220},{-70,220}}, color={0,127,255}));
  connect(jun4.port_2, jun5.port_1) annotation (Line(points={{-90,220},{-170,220}},
                                  color={0,127,255}));
  connect(jun5.port_2, senTCDU_a.port_a) annotation (Line(points={{-190,220},{-220,
          220},{-220,120},{-50,120}}, color={0,127,255}));
  connect(jun4.port_3,pumEva. port_a)
    annotation (Line(points={{-80,230},{-80,280}}, color={0,127,255}));
  connect(pumEva.port_b, chi.port_a2) annotation (Line(points={{-80,300},{-80,308},
          {-152,308},{-152,325},{-140,325}},           color={0,127,255}));
  connect(chi.port_b2,senTEvaOut. port_a) annotation (Line(points={{-120,325},{-108,
          325},{-108,314},{-180,314},{-180,300}}, color={0,127,255}));
  connect(senTEvaOut.port_b, jun5.port_3)
    annotation (Line(points={{-180,280},{-180,230}}, color={0,127,255}));
  connect(jun3.port_3, pumWSEChi.port_a)
    annotation (Line(points={{160,230},{160,280}}, color={0,127,255}));
  connect(pumWSEChi.port_b, wse.port_a2) annotation (Line(points={{160,300},{160,
          310},{88,310},{88,325},{100,325}}, color={0,127,255}));
  connect(wse.port_b2, senTWSE_b2.port_a) annotation (Line(points={{120,325},{130,
          325},{130,314},{60,314},{60,300}}, color={0,127,255}));
  connect(senTWSE_b2.port_b, jun2.port_3)
    annotation (Line(points={{60,280},{60,230}}, color={0,127,255}));
  connect(wse.port_b1, senTWSE_b1.port_a)
    annotation (Line(points={{100,337},{60,337},{60,360}}, color={0,127,255}));
  connect(wse.port_a1, pumWSECW.port_b) annotation (Line(points={{120,337},{160,
          337},{160,410}}, color={0,127,255}));
  connect(chi.port_b1, senTChi_b1.port_a) annotation (Line(points={{-140,337},{-180,
          337},{-180,360}}, color={0,127,255}));
  connect(jun1.port_3, pumWSECW.port_a)
    annotation (Line(points={{160,530},{160,430}}, color={0,127,255}));
  connect(jun8.port_1, jun7.port_2)
    annotation (Line(points={{-170,540},{-90,540}}, color={0,127,255}));
  connect(cooTow.port_b, senTTow_b.port_a) annotation (Line(points={{9,619.5},{28.5,
          619.5},{28.5,620},{60,620}},
                                     color={0,127,255}));
  connect(senTTow_b.port_b, jun1.port_1) annotation (Line(points={{80,620},{180,
          620},{180,540},{170,540}}, color={0,127,255}));
  connect(weaBus, weaData.weaBus) annotation (Line(
      points={{-62,650},{-102,650}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{2,2},{2,5}},
      horizontalAlignment=TextAlignment.Left));
  connect(pSetChiWatPum.y, pumCDU.dp_in)
    annotation (Line(points={{182,170},{208,170}}, color={0,0,127}));
  connect(hysChi.y,yPumChi. u)
    annotation (Line(points={{-378,260},{-302,260}}, color={255,0,255}));
  connect(senTTow_b.port_b, bou1.ports[1])
    annotation (Line(points={{80,620},{228,620}}, color={0,127,255}));
  connect(TOffSet.y, chi.TSet) annotation (Line(points={{-508,350},{-108,350},{-108,
          340},{-118,340}}, color={0,0,127}));
  connect(TOffSet.u, TSetEva.y)
    annotation (Line(points={{-532,350},{-538,350}}, color={0,0,127}));
  connect(PFan.y, EFan.u)
    annotation (Line(points={{381,58},{398,58}},   color={0,0,127}));
  connect(PPum.y, EPum.u)
    annotation (Line(points={{381,18},{398,18}},   color={0,0,127}));
  connect(PChi.y, EChi.u)
    annotation (Line(points={{381,-22},{398,-22}}, color={0,0,127}));
  connect(PIT.y, EPIT.u)
    annotation (Line(points={{381,-62},{398,-62}}, color={0,0,127}));
  connect(EChi.y, EFac.u[1]) annotation (Line(points={{421,-22},{438,-22},{438,16.425},
          {454,16.425}},  color={0,0,127}));
  connect(EPum.y, EFac.u[2]) annotation (Line(points={{421,18},{438,18},{438,17.475},
          {454,17.475}},  color={0,0,127}));
  connect(EFan.y, EFac.u[3]) annotation (Line(points={{421,58},{438,58},{438,18.525},
          {454,18.525}},  color={0,0,127}));
  connect(EFac.y, PUE.u1) annotation (Line(points={{467.02,18},{482,18},{482,-26},
          {498,-26}}, color={0,0,127}));
  connect(EPIT.y, PUE.u2) annotation (Line(points={{421,-62},{458.5,-62},{458.5,
          -38},{498,-38}}, color={0,0,127}));
  connect(EPIT.y, EFac.u[4]) annotation (Line(points={{421,-62},{438,-62},{438,18},
          {454,18},{454,19.575}},   color={0,0,127}));
  connect(jun7.port_1,senTWSEMix. port_b)
    annotation (Line(points={{-70,540},{-20,540}}, color={0,127,255}));
  connect(senTWSEMix.port_a, jun6.port_2)
    annotation (Line(points={{0,540},{50,540}}, color={0,127,255}));
  connect(jun7.port_3, valThr.port_a)
    annotation (Line(points={{-80,530},{-80,510}}, color={0,127,255}));
  connect(jun8.port_3, jun10.port_1)
    annotation (Line(points={{-180,530},{-180,470}}, color={0,127,255}));
  connect(jun10.port_3, valByp.port_a)
    annotation (Line(points={{-170,460},{-140,460}}, color={0,127,255}));
  connect(valThr.port_b, jun9.port_1)
    annotation (Line(points={{-80,490},{-80,470}}, color={0,127,255}));
  connect(jun9.port_2, pumCon.port_a)
    annotation (Line(points={{-80,450},{-80,430}}, color={0,127,255}));
  connect(valByp.port_b, jun9.port_3)
    annotation (Line(points={{-120,460},{-90,460}}, color={0,127,255}));
  connect(chi.port_a1, senTChi_a1.port_b) annotation (Line(points={{-120,337},{-80,
          337},{-80,360}}, color={0,127,255}));
  connect(senTChi_a1.port_a, pumCon.port_b)
    annotation (Line(points={{-80,380},{-80,410}}, color={0,127,255}));
  connect(senTChi_a1.T, conPIDCon.u_m) annotation (Line(points={{-91,370},{-100,
          370},{-100,388},{-350,388},{-350,418}}, color={0,0,127}));
  connect(senTEvaIn.T, TLifMin.u) annotation (Line(points={{-10,231},{-10,240},{
          -470,240},{-470,430},{-402,430}}, color={0,0,127}));
  connect(hysChi.y, conPIDCon.trigger) annotation (Line(points={{-378,260},{-356,
          260},{-356,418}}, color={255,0,255}));
  connect(TLifMin.y, conPIDCon.u_s)
    annotation (Line(points={{-378,430},{-362,430}}, color={0,0,127}));
  connect(conPIDCon.y, valThr.y) annotation (Line(points={{-338,430},{-330,430},
          {-330,500},{-92,500}}, color={0,0,127}));
  connect(invValSig2.u, invValSig.y)
    annotation (Line(points={{-282,480},{-298,480}}, color={0,0,127}));
  connect(invValSig2.y, valByp.y) annotation (Line(points={{-258,480},{-130,480},
          {-130,472}}, color={0,0,127}));
  connect(invValSig.u, conPIDCon.y) annotation (Line(points={{-322,480},{-330,480},
          {-330,430},{-338,430}}, color={0,0,127}));
  connect(senTEvaIn.T, TAppWSE1.u1) annotation (Line(points={{-10,231},{-10,240},
          {-470,240},{-470,216},{-442,216}}, color={0,0,127}));
  connect(TOffSet.y, TAppWSE1.u2) annotation (Line(points={{-508,350},{-500,350},
          {-500,204},{-442,204}}, color={0,0,127}));
  connect(pumEva.y, yPumChi.y) annotation (Line(points={{-68,290},{-60,290},{-60,
          260},{-278,260}}, color={0,0,127}));
  connect(pumCon.y, yPumChi.y) annotation (Line(points={{-68,420},{-60,420},{-60,
          260},{-278,260}}, color={0,0,127}));
  connect(cooTow.port_a, senTTow_a.port_b) annotation (Line(points={{-10,619.5},
          {-35,619.5},{-35,620},{-60,620}}, color={0,127,255}));
  connect(senTTow_a.port_a, pumTow.port_b) annotation (Line(points={{-80,620},{
          -220,620},{-220,610}}, color={0,127,255}));
  connect(uti.y, rac.u) annotation (Line(points={{-18,-40},{-10,-40},{-10,-54},{
          -1,-54}}, color={0,0,127}));
  connect(cooTow.TDryBul, weaBus.TDryBul) annotation (Line(points={{-11.9,623.3},
          {-40,623.3},{-40,650},{-61.95,650},{-61.95,650.05}},   color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(jun3.port_2, senMasFloByEco.port_a)
    annotation (Line(points={{150,220},{118,220}}, color={0,127,255}));
  connect(senMasFloByEco.port_b, jun2.port_1)
    annotation (Line(points={{98,220},{70,220}}, color={0,127,255}));
  connect(senMasFloByEco.m_flow, conEcoPla.u_m) annotation (Line(points={{108,231},
          {108,240},{250,240},{250,258}},                     color={0,0,127}));
  connect(zer.y, conEcoPla.u_s)
    annotation (Line(points={{222,270},{238,270}}, color={0,0,127}));
  connect(conEcoPla.y, pumWSEChi.y) annotation (Line(points={{262,270},{280,270},
          {280,290},{172,290}}, color={0,0,127}));
  connect(yPumTow.y, pumTow.y)
    annotation (Line(points={{-378,600},{-232,600}}, color={0,0,127}));
  connect(jun6.port_1, senMasFlo3.port_b)
    annotation (Line(points={{70,540},{100,540}}, color={0,127,255}));
  connect(senMasFlo3.port_a, jun1.port_2)
    annotation (Line(points={{120,540},{150,540}}, color={0,127,255}));
  connect(zer1.y, conEcoTow.u_s)
    annotation (Line(points={{202,470},{218,470}}, color={0,0,127}));
  connect(conEcoTow.y, pumWSECW.y) annotation (Line(points={{242,470},{248,470},
          {248,420},{172,420}}, color={0,0,127}));
  connect(conEcoTow.u_m, senMasFlo3.m_flow) annotation (Line(points={{230,458},{
          230,448},{212,448},{212,560},{110,560},{110,551}}, color={0,0,127}));
  connect(jun8.port_2, pumTow.port_a) annotation (Line(points={{-190,540},{-220,
          540},{-220,590}}, color={0,127,255}));
  connect(jun6.port_3, senTWSE_b1.port_b)
    annotation (Line(points={{60,530},{60,380}}, color={0,127,255}));
  connect(jun10.port_2, senTChi_b1.port_b)
    annotation (Line(points={{-180,450},{-180,380}}, color={0,127,255}));
  connect(TOffSetWSE.y, conTow.u_s)
    annotation (Line(points={{42,710},{58,710}}, color={0,0,127}));
  connect(conTow.u_m, senTTow_b.T)
    annotation (Line(points={{70,698},{70,631}}, color={0,0,127}));
  connect(TSetTowRet.y, TOffSetWSE.u)
    annotation (Line(points={{2,710},{18,710}}, color={0,0,127}));
  connect(conTow.y, cooTow.y) annotation (Line(points={{82,710},{88,710},{88,670},
          {-28,670},{-28,627.1},{-11.9,627.1}}, color={0,0,127}));
  connect(conPumTow.u_s, TOffSet.y) annotation (Line(points={{-482,600},{-494,600},
          {-494,350},{-508,350}}, color={0,0,127}));
  connect(conPumTow.u_m, senTEvaIn.T) annotation (Line(points={{-470,588},{-470,
          240},{-10,240},{-10,231}}, color={0,0,127}));
  connect(conPumTow.y, hysChi.u) annotation (Line(points={{-458,600},{-450,600},
          {-450,260},{-402,260}}, color={0,0,127}));
  connect(conPumTow.y, yPumTow.u)
    annotation (Line(points={{-458,600},{-402,600}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-580,-120},{540,780}})),
    Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})),
    experiment(
      StopTime=31536000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
      __Dymola_Commands(
       file="modelica://Buildings/Resources/Scripts/Dymola/Applications/DataCenters/LiquidCooled/Examples/ChillerWSE.mos" "Simulate and plot"),
    Documentation(info="<html>
<p>
Example model of liquid cooled data center that is cooled with an economizer and a chiller.
</p>
<p>
The figure below shows the schematic diagram.
</p>
<p align=\"center\">
    <img src=\"modelica://Buildings/Resources/Images/Applications/DataCenters/LiquidCooled/Examples/ChillerWSE.png\"
         alt=\"Schematic diagram of cooling system.\"
         style=\"width: 100%; height: auto;\">
</p>
<p>
The IT load is cooled by a propylene glycol loop, which exchanges
heat through the CDU with a chilled water supply.
A PI controller regulates the chilled water flow rate through the control
valve in the CDU in order to track the propylene glycol temperature that is sent
to the IT rack.
The chilled water is cooled by an economizer -- if the temperatures permit --
and if the water temperature after the economizer is higher than a temperature set point,
the chiller is enabled. The chiller tracks a leaving water set point temperature.
Note that the control is quite simple, and multiple parallel equipment as is common in data centers
is here simplified with one component only.
</p>
<p>
The model has a parameter <code>dTOffSet</code> which can be used to shift the design temperatures
up or down. This allows to push the model into temperature regimes that need no chiller.
For example, if <code>dTOffSet=0</code>, the chiller never operates, and all cooling is done
through the economizer.
</p>
<p>
For more detailed chilled water plant
controls, see for example
<ul>
<li>
<a href=\"modelica://Buildings.Examples.ChillerPlant\">Buildings.Examples.ChillerPlant</a>,
</li>
<li>
<a href=\"modelica://Buildings.Applications.DataCenters.ChillerCooled.Examples\">Buildings.Applications.DataCenters.ChillerCooled.Examples</a>, or
</li>
<li>
the papers by Grahovac et al. (2023) or Wetter et al. (2014).
</li>
</ul>
</p>
<h4>References</h4>
<ul>
<li>
Milica Grahovac, Paul Ehrlich, Jianjun Hu and Michael Wetter.<br/>
Model-based Data Center Cooling Controls Comparative Co-design.<br/>
Science and Technology for the Built Environment, 30(4), P. 394-414, 2023.<br/>
<a href=\"https://doi.org/10.1080/23744731.2023.2276011\">doi:10.1080/23744731.2023.2276011</a>.
</li>
<li>
Michael Wetter, Wangda Zuo, Thierry S. Nouidui and Xiufeng Pang.<br/>
Modelica Buildings library.<br/>
Journal of Building Performance Simulation, 7(4):253-270, 2014.<br/>
<a href=\"https://dx.doi.org/10.1080/19401493.2013.765506\">doi:10.1080/19401493.2013.765506</a>.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
December 23, 2025, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ChillerWSE;
