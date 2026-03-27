within Buildings.Applications.DataCenters.LiquidCooled.Examples;
model ChillerWSE
  "Example model of a simple liquid cooled data center with chiller and water-side economizer"
  extends Modelica.Icons.Example;

  package MediumChi = Buildings.Media.Water "Medium for chilled water loop";
  package MediumRac = Buildings.Media.Antifreeze.PropyleneGlycolWater(
    T_default=303.15,
    property_T=303.15,
    X_a=0.25)
    "Medium for rack";
  parameter Modelica.Units.SI.TemperatureDifference dTOffSet(max=0) = 0
    "Offset for cooling supply temperature (used to design model so it requires the chiller sometimes)";

  parameter Modelica.Units.SI.Power PRac = 1E6
    "Total rack design power";
  parameter Real fraWSE = 0.5 "Fraction of peak load covered by water side economizer";
  parameter Real fraChi = 1-fraWSE "Fraction of peak load covered by chiller";

  parameter Modelica.Units.SI.TemperatureDifference dTRac_nominal(max=0) = -5
    "Temperature difference rack loop";

  parameter Modelica.Units.SI.TemperatureDifference dTChw_nominal(max=0) = -5
    "Temperature difference chilled water loop";
  final parameter Modelica.Units.SI.TemperatureDifference dTTow_nominal(max=0) = dTChw_nominal
    "Temperature difference tower water loop (same as chilled water loop, as it is assumed for TSetCooTowOut_nominal";

  parameter Modelica.Units.SI.Temperature TRacSup_nominal=273.15 + 45 + dTOffSet
    "Supply coolant temperature to rack at design conditions";
  parameter Modelica.Units.SI.Temperature TRacRet_nominal=TRacSup_nominal-dTRac_nominal
    "Return coolant temperature from rack at design conditions";
  parameter Modelica.Units.SI.Temperature TChiSup_nominal=TRacSup_nominal - 6
    "Supply chilled water temperature to CDU at design conditions";
  parameter Modelica.Units.SI.Temperature TChiRet_nominal=TChiSup_nominal-dTChw_nominal
    "Return chilled temperature from CDU at design conditions";

  parameter Modelica.Units.SI.MassFlowRate mRac_flow_nominal=PRac/(
      TRacRet_nominal - TRacSup_nominal)/MediumRac.cp_const
    "Rack mass flow rate at design conditions";
  parameter Modelica.Units.SI.MassFlowRate mChi_flow_nominal=PRac/(
      TChiRet_nominal - TChiSup_nominal)/MediumChi.cp_const
    "Chilled water mass flow rate at design conditions";


  parameter Modelica.Units.SI.PressureDifference dpVal_nominal=20000
    "Valve design pressure drop";
   parameter Modelica.Units.SI.PressureDifference dpHexChi_nominal=80000
    "Heat exchanger design pressure drop on chiller side";
  parameter Modelica.Units.SI.PressureDifference dPRac_nominal = 60000
    "Rack design pressure drop";
  parameter Buildings.Applications.DataCenters.LiquidCooled.Racks.Data.OCP_1kW_OAM_PG25 datTheRes
    "Thermal resistance data"
    annotation (Placement(transformation(extent={{60,-108},{80,-88}})));

  parameter Modelica.Units.SI.TemperatureDifference dTCon_nominal=10
    "Temperature difference condenser outlet-inlet";

  parameter Real COPc_nominal=3 "Chiller COP";
  parameter Real epsWSE_nominal(min=0.5, max=0.95) = 0.9
    "Effectiveness of water side economizer";

  parameter Modelica.Units.SI.Temperature TSetCooTowOut_nominal =
    TChiRet_nominal - (TChiRet_nominal-TChiSup_nominal)/epsWSE_nominal
    "Set point for cooling tower outlet temperature to meet design load with WSE";

  parameter Modelica.Units.SI.MassFlowRate mCW_flow_nominal=
    PRac*(1/COPc_nominal+1)/(MediumChi.cp_const*dTCon_nominal)
    "Nominal mass flow rate at condenser water";
  Controls.OBC.CDL.Reals.Sources.Constant uti(k=0.6)
    "Utilization of hardware"
    annotation (Placement(transformation(extent={{-140,-40},{-120,-20}})));
  Buildings.Applications.DataCenters.LiquidCooled.Racks.ColdPlateR_P rac(
    redeclare package Medium = MediumRac,
    allowFlowReversal=false,
    Q_flow_nominal=PRac,
    m_flow_nominal=mRac_flow_nominal,
    datTheRes=datTheRes,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Rack with cold plate heat exchangers, modeled for simplicity as one large rack"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Buildings.Fluid.Sources.Boundary_pT bou(redeclare package Medium = MediumChi,
    p(displayUnit="Pa") = 300000,
      nPorts=1) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{292,110},{272,130}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTCDU_a(
    redeclare package Medium = MediumChi,
    allowFlowReversal=false,
    m_flow_nominal=mChi_flow_nominal,
    tau=0) "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-50,110},{-30,130}})));

  Buildings.Applications.DataCenters.LiquidCooled.CDUs.CDU_epsNTU cdu(
    redeclare package Medium1 = MediumChi,
    redeclare package Medium2 = MediumRac,
    allowFlowReversal1=false,
    allowFlowReversal2=false,
    m1_flow_nominal=mChi_flow_nominal,
    m2_flow_nominal=mRac_flow_nominal,
    Q_flow_nominal=-PRac,
    T_a1_nominal=TChiSup_nominal,
    T_a2_nominal=TRacSup_nominal,
    dpHex1_nominal=dpHexChi_nominal,
    dpPum_nominal=dPRac_nominal,
    yPum_start=1) "CDU, modeled for simplicity as one large CDU"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Fluid.Sensors.TemperatureTwoPort senTCDU_b(
    redeclare package Medium = MediumChi,
    allowFlowReversal=false,
    m_flow_nominal=mChi_flow_nominal,
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
    m1_flow_nominal=fraWSE*mCW_flow_nominal,
    m2_flow_nominal=fraWSE*mChi_flow_nominal,
    show_T=true,
    eps=epsWSE_nominal,
    dp2_nominal=dpHexChi_nominal,
    dp1_nominal=dpHexChi_nominal)
                   "Water side economizer (Heat exchanger)"
    annotation (Placement(transformation(extent={{120,321},{100,341}})));
  Fluid.Chillers.Carnot_TEva chi(
    redeclare package Medium1 = MediumChi,
    redeclare package Medium2 = MediumChi,
    m1_flow_nominal=fraChi*mCW_flow_nominal,
    m2_flow_nominal=fraChi*mChi_flow_nominal,
    show_T=true,
    QEva_flow_nominal=-fraChi*PRac,
    dTEva_nominal=TChiSup_nominal - TChiRet_nominal,
    dTCon_nominal=dTCon_nominal,
    dp2_nominal=dpHexChi_nominal,
    dp1_nominal=dpHexChi_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Chiller"
    annotation (Placement(transformation(extent={{-120,321},{-140,341}})));
  Fluid.HeatExchangers.CoolingTowers.Merkel   cooTow(
    redeclare package Medium = MediumChi,
    m_flow_nominal=mCW_flow_nominal,
    show_T=true,
    dp_nominal=dpHexChi_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    TWatIn_nominal=TSetCooTowOut_nominal + 5,
    TWatOut_nominal=TSetCooTowOut_nominal)
    "Cooling tower"
    annotation (Placement(
        transformation(
        extent={{-9.5,-9.5},{9.5,9.5}},
        origin={-0.5,619.5})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaData(filNam=
        ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    annotation (Placement(transformation(extent={{-240,650},{-220,670}})));
  BoundaryConditions.WeatherData.Bus weaBus
    annotation (Placement(transformation(extent={{-190,650},{-170,670}}),
        iconTransformation(extent={{-176,140},{-156,160}})));
  Fluid.Movers.Preconfigured.FlowControlled_m_flow pumEva(
    redeclare package Medium = MediumChi,
    allowFlowReversal=false,
    addPowerToMedium=false,
    use_riseTime=false,
    m_flow_nominal=fraChi*mChi_flow_nominal,
    dp_nominal=dpHexChi_nominal) "Pump chiller evaporator"    annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-80,290})));
  Fluid.Movers.Preconfigured.FlowControlled_m_flow pumWSEChi(
    redeclare package Medium = MediumChi,
    allowFlowReversal=false,
    addPowerToMedium=false,
    use_riseTime=false,
    m_flow_nominal=fraWSE*mChi_flow_nominal,
    dp_nominal=dpHexChi_nominal) "Pump for water-side economizer" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={160,290})));
  Fluid.Movers.Preconfigured.FlowControlled_m_flow pumTow(
    redeclare package Medium = MediumChi,
    allowFlowReversal=false,
    addPowerToMedium=false,
    use_riseTime=false,
    m_flow_nominal=mCW_flow_nominal,
    dp_nominal=dpHexChi_nominal) "Pump for tower loop" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-220,570})));
  Fluid.Sensors.TemperatureTwoPort senTWSE_b2(
    redeclare package Medium = MediumChi,
    allowFlowReversal=false,
    m_flow_nominal=fraWSE*mChi_flow_nominal,
    tau=0) "Chilled water outlet temperature of water side economizer"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={60,290})));
  Fluid.Movers.Preconfigured.FlowControlled_m_flow pumCon(
    redeclare package Medium = MediumChi,
    allowFlowReversal=false,
    addPowerToMedium=false,
    use_riseTime=false,
    final m_flow_nominal=fraChi*mCW_flow_nominal,
    dp_nominal=dpHexChi_nominal) "Pump for chiller condenser" annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-80,420})));
  Fluid.Sensors.TemperatureTwoPort senTTow_b(
    redeclare package Medium = MediumChi,
    allowFlowReversal=false,
    m_flow_nominal=mCW_flow_nominal,
    tau=0) "Outlet water temperature of tower"
    annotation (Placement(transformation(extent={{60,610},{80,630}})));
  Fluid.FixedResistances.Junction jun1(
    redeclare package Medium = MediumChi,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mCW_flow_nominal*{1,1,fraWSE},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={160,540})));
  Fluid.FixedResistances.Junction jun2(redeclare package Medium = MediumChi,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mChi_flow_nominal*{1,1,fraWSE},
    dp_nominal={0,0,0})   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={60,220})));
  Fluid.FixedResistances.Junction jun3(redeclare package Medium = MediumChi,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mChi_flow_nominal*{1,1,fraWSE},
    dp_nominal={0,0,0})   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={160,220})));
  Fluid.Sensors.TemperatureTwoPort senTEvaIn(
    redeclare package Medium = MediumChi,
    allowFlowReversal=false,
    m_flow_nominal=mChi_flow_nominal,
    tau=0) "Chiller inlet temperature to evaporator"
    annotation (Placement(transformation(extent={{0,210},{-20,230}})));
  Fluid.FixedResistances.Junction jun4(redeclare package Medium = MediumChi,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mChi_flow_nominal*{1,1,fraChi},
    dp_nominal={0,0,0})   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-80,220})));
  Fluid.FixedResistances.Junction jun5(redeclare package Medium = MediumChi,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mChi_flow_nominal*{1,1,fraChi},
    dp_nominal={0,0,0})   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-180,220})));
  Fluid.Sensors.TemperatureTwoPort senTEvaOut(
    redeclare package Medium = MediumChi,
    allowFlowReversal=false,
    m_flow_nominal=fraChi*mChi_flow_nominal,
    tau=0) "Chilled water outlet temperature of chiller" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-180,290})));
  Fluid.Sensors.TemperatureTwoPort senTChi_b1(
    redeclare package Medium = MediumChi,
    allowFlowReversal=false,
    m_flow_nominal=mCW_flow_nominal,
    tau=0) "Cooling tower water outlet temperature of chiller" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-180,370})));
  Fluid.Sensors.TemperatureTwoPort senTWSE_b1(
    redeclare package Medium = MediumChi,
    allowFlowReversal=false,
    m_flow_nominal=fraWSE*mCW_flow_nominal,
    tau=0) "Cooling tower water outlet temperature of water side economizer"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={60,390})));
  Fluid.Movers.Preconfigured.FlowControlled_m_flow pumWSECW(
    redeclare package Medium = MediumChi,
    allowFlowReversal=false,
    addPowerToMedium=false,
    use_riseTime=false,
    m_flow_nominal=fraWSE*mCW_flow_nominal,
    dp_nominal=dpHexChi_nominal)
    "Pump for water side economizer on cooling tower side" annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={160,390})));
  Fluid.Movers.Preconfigured.FlowControlled_dp pumCDU(
    redeclare package Medium = MediumChi,
    allowFlowReversal=false,
    addPowerToMedium=false,
    use_riseTime=false,
    m_flow_nominal=mChi_flow_nominal,
    dp_nominal=dpHexChi_nominal) "Pump chilled water circuit" annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={220,170})));
  Fluid.FixedResistances.Junction jun6(
    redeclare package Medium = MediumChi,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mCW_flow_nominal*{1,1,fraWSE},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={60,540})));
  Fluid.FixedResistances.Junction jun7(
    redeclare package Medium = MediumChi,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mCW_flow_nominal*{1,1,fraChi},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-80,540})));
  Fluid.FixedResistances.Junction jun8(
    redeclare package Medium = MediumChi,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mCW_flow_nominal*{1,1,fraChi},
    dp_nominal={0,0,0}) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-180,540})));
  Controls.OBC.CDL.Reals.Sources.Constant TTowOut(y(final unit="K", displayUnit
        ="degC"), k(
      final unit="K",
      displayUnit="degC") = TSetCooTowOut_nominal)
    "Tower water outlet temperature"
    annotation (Placement(transformation(extent={{-140,690},{-120,710}})));
  Controls.OBC.CDL.Reals.AddParameter TAppOff(p=10)
    "Offset for approach temperature"
    annotation (Placement(transformation(extent={{-140,650},{-120,670}})));
  Controls.OBC.CDL.Reals.Max TCooLvgSet
    "Set point for cooling tower leaving water temperature"
    annotation (Placement(transformation(extent={{-100,670},{-80,690}})));
  Controls.OBC.CDL.Reals.PID conTowFan(
    yMin=0.1,
    u_s(final unit="K", displayUnit="degC"),
    u_m(final unit="K", displayUnit="degC"),
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    Ti=120,
    r=1,
    xi_start=1,
    reverseActing=false) "Controller for tower fan"
    annotation (Placement(transformation(extent={{-60,670},{-40,690}})));
  Controls.OBC.CDL.Reals.Hysteresis hysWSE(
    uLow=4,
    uHigh=5,
    u(final unit="K")) "Hysteresis for water side economizer"
    annotation (Placement(transformation(extent={{320,460},{340,480}})));
  Controls.OBC.CDL.Reals.Subtract TAppWSE(
   u1(final unit="K",
      displayUnit="degC"),
   u2(final unit="K",
      displayUnit="degC"),
   y(final unit="K"))
   "Approach temperature for economizer"
    annotation (Placement(transformation(extent={{280,460},{300,480}})));
  Controls.OBC.CDL.Conversions.BooleanToReal mWSESet(
    y(final unit="kg/s"), realTrue(final unit="kg/s") = fraWSE*mCW_flow_nominal)
    "Flow rate set point for water side economizer"
    annotation (Placement(transformation(extent={{360,460},{380,480}})));
  Controls.OBC.CDL.Reals.Sources.Constant TSetEva(y(final unit="K", displayUnit
        ="degC"), k(
      final unit="K",
      displayUnit="degC") = TChiSup_nominal)
    "Set point temperature for evaporator outlet temperature"
    annotation (Placement(transformation(extent={{-560,340},{-540,360}})));
  Controls.OBC.CDL.Reals.Sources.Constant pSetChiWatPum(
    y(final unit="Pa"),
    k(final unit="Pa") = dpHexChi_nominal)
    "Pressure setpoint for chilled water pump"
    annotation (Placement(transformation(extent={{160,160},{180,180}})));
  Controls.OBC.CDL.Reals.Hysteresis hysChi(
    uLow=-1,
    uHigh=1,
    u(final unit="K")) "Hysteresis for chiller staging"
    annotation (Placement(transformation(extent={{-400,250},{-380,270}})));
  Controls.OBC.CDL.Reals.Subtract TAppWSE1(
    u1(final unit="K", displayUnit="degC"),
    u2(final unit="K", displayUnit="degC"),
    y(final unit="K"))
   "Approach temperature for economizer"
    annotation (Placement(transformation(extent={{-440,250},{-420,270}})));
  Controls.OBC.CDL.Conversions.BooleanToReal mEvaSet(y(final unit="kg/s"),
      realTrue(final unit="kg/s") = fraChi*mChi_flow_nominal)
    "Flow rate set point for evaporator"
    annotation (Placement(transformation(extent={{-300,250},{-280,270}})));
  Controls.OBC.CDL.Conversions.BooleanToReal mConSet(y(final unit="kg/s"),
      realTrue(final unit="kg/s") = fraChi*mCW_flow_nominal)
    "Flow rate set point for condenser"
    annotation (Placement(transformation(extent={{-300,290},{-280,310}})));
  Controls.OBC.CDL.Reals.Max mTowSet "Mass flow rate set point for tower"
    annotation (Placement(transformation(extent={{-280,560},{-260,580}})));
  Fluid.Sources.Boundary_pT bou1(
    redeclare package Medium = MediumChi,
    p(displayUnit="Pa") = 300000,
    nPorts=1)   "Pressure boundary condition"
    annotation (Placement(transformation(extent={{248,610},{228,630}})));
  Controls.OBC.CDL.Reals.AddParameter TOffSet(p=0)
    "Offset for set point (for testing only)"
    annotation (Placement(transformation(extent={{-530,340},{-510,360}})));
  Controls.OBC.CDL.Reals.Sources.Sin sin(
    y(final unit="K",
       displayUnit="degC"),
    amplitude=16,
    freqHz=2*3.14/(3600*24*3600),
    offset=273.15 + 36 - 8)
    annotation (Placement(transformation(extent={{-560,282},{-540,302}})));
  Modelica.Blocks.Sources.RealExpression PFan(y(final unit="W") = cooTow.PFan)
    "Power consumption of tower fans"
    annotation (Placement(transformation(extent={{360,410},{380,430}})));
  Modelica.Blocks.Sources.RealExpression PPum(y(final unit="W") = cdu.P +
      pumWSEChi.P + pumWSECW.P + pumEva.P + pumCon.P + pumTow.P)
    "Power consumption of pumps"
    annotation (Placement(transformation(extent={{360,370},{380,390}})));
  Modelica.Blocks.Sources.RealExpression PChi(y(final unit="W") = chi.P)
    "Power consumption of chiller"
    annotation (Placement(transformation(extent={{360,330},{380,350}})));
  Modelica.Blocks.Sources.RealExpression PIT(y(final unit="W") = rac.P)
    "Power consumption of IT"
    annotation (Placement(transformation(extent={{360,290},{380,310}})));
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
    annotation (Placement(transformation(extent={{400,410},{420,430}})));
  ElectricalEnergyMeter EPum "Energy meter"
    annotation (Placement(transformation(extent={{400,370},{420,390}})));
  ElectricalEnergyMeter EChi "Energy meter"
    annotation (Placement(transformation(extent={{400,330},{420,350}})));
  ElectricalEnergyMeter EPIT(y_start=1E-10)
                             "Energy meter"
    annotation (Placement(transformation(extent={{400,290},{420,310}})));
  Modelica.Blocks.Math.MultiSum EFac(nu=4) "Electricity for facility"
    annotation (Placement(transformation(extent={{454,374},{466,386}})));
  Modelica.Blocks.Math.Division PUE
    "Power use effectiveness (not taking into account electrical losses)"
    annotation (Placement(transformation(extent={{500,320},{520,340}})));
  Fluid.Sensors.TemperatureTwoPort senTWSEMix(
    redeclare package Medium = MediumChi,
    allowFlowReversal=false,
    m_flow_nominal=mCW_flow_nominal,
    tau=0) "Water temperature cooling tower loop after WSE"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-10,540})));
  Fluid.Actuators.Valves.TwoWayLinear valByp(
    redeclare package Medium = MediumChi,
    final m_flow_nominal=fraChi*mCW_flow_nominal,
    final dpValve_nominal=dpVal_nominal) "Valve for condenser loop bypass"
    annotation (Placement(transformation(extent={{-140,450},{-120,470}})));
  Fluid.Actuators.Valves.TwoWayLinear valThr(
    redeclare package Medium = MediumChi,
    final m_flow_nominal=fraChi*mCW_flow_nominal,
    final dpValve_nominal=dpVal_nominal,
    y_start=0) "Valve for condenser loop from cooling tower" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-80,500})));
  Fluid.FixedResistances.Junction jun9(
    redeclare package Medium = MediumChi,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=fraChi*mCW_flow_nominal*{1,1,1},
    dp_nominal={0,0,0}) "Junction at condenser loop["
                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-80,460})));
  Fluid.FixedResistances.Junction jun10(
    redeclare package Medium = MediumChi,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=fraChi*mCW_flow_nominal*{1,1,1},
    dp_nominal={0,0,0}) "Junction at condenser loop["
                        annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-180,460})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTChi_a1(
    redeclare package Medium = MediumChi,
    allowFlowReversal=false,
    m_flow_nominal=mCW_flow_nominal,
    tau=0) "Cooling tower water inlet temperature of chiller" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-80,370})));
  Controls.OBC.CDL.Reals.PIDWithReset conPIDCon(
    Ti=120,
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
  Controls.OBC.CDL.Reals.Sources.Constant yPum1(k=0.3)
    "Pump control signal"
    annotation (Placement(transformation(extent={{-78,630},{-58,650}})));
  Controls.OBC.CDL.Reals.Sources.Ramp ram(
    height=0.7,
    duration(displayUnit="d") = 31536000,
    offset=0.3)
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
equation
  connect(senTCDU_a.port_b, cdu.port_a1) annotation (Line(points={{-30,120},{-20,
          120},{-20,46},{-10,46}},color={0,127,255}));
  connect(cdu.port_b1, senTCDU_b.port_a) annotation (Line(points={{10,46},{20,46},
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
  connect(cdu.port_b2, senTRac_a.port_a)
    annotation (Line(points={{-10,34},{-30,34}}, color={0,127,255}));
  connect(senTRac_a.port_b, rac.port_a) annotation (Line(points={{-50,34},{-72,34},
          {-72,-60},{0,-60}}, color={0,127,255}));
  connect(rac.port_b, senTRac_b.port_a) annotation (Line(points={{20,-60},{70,-60},
          {70,34},{50,34}}, color={0,127,255}));
  connect(senTRac_b.port_b, cdu.port_a2) annotation (Line(points={{30,34},{22,34},
          {22,34},{10,34}}, color={0,127,255}));
  connect(rac.port_b, preSou.ports[1])
    annotation (Line(points={{20,-60},{90,-60}}, color={0,127,255}));
  connect(senTCDU_b.port_b, pumCDU.port_a) annotation (Line(points={{50,120},{220,
          120},{220,160}}, color={0,127,255}));
  connect(pumCDU.port_b, jun3.port_1) annotation (Line(points={{220,180},{220,220},
          {170,220}}, color={0,127,255}));
  connect(jun3.port_2, jun2.port_1)
    annotation (Line(points={{150,220},{70,220}}, color={0,127,255}));
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
    annotation (Line(points={{100,337},{60,337},{60,380}}, color={0,127,255}));
  connect(wse.port_a1, pumWSECW.port_b) annotation (Line(points={{120,337},{160,
          337},{160,380}}, color={0,127,255}));
  connect(chi.port_b1, senTChi_b1.port_a) annotation (Line(points={{-140,337},{-180,
          337},{-180,360}}, color={0,127,255}));
  connect(jun6.port_3, senTWSE_b1.port_b)
    annotation (Line(points={{60,530},{60,400}}, color={0,127,255}));
  connect(jun1.port_3, pumWSECW.port_a)
    annotation (Line(points={{160,530},{160,400}}, color={0,127,255}));
  connect(jun8.port_2, pumTow.port_a) annotation (Line(points={{-190,540},{-220,
          540},{-220,560}}, color={0,127,255}));
  connect(jun8.port_1, jun7.port_2)
    annotation (Line(points={{-170,540},{-90,540}}, color={0,127,255}));
  connect(jun6.port_1, jun1.port_2)
    annotation (Line(points={{70,540},{150,540}}, color={0,127,255}));
  connect(pumTow.port_b, cooTow.port_a) annotation (Line(points={{-220,580},{-220,
          619.5},{-10,619.5}}, color={0,127,255}));
  connect(cooTow.port_b, senTTow_b.port_a) annotation (Line(points={{9,619.5},{28.5,
          619.5},{28.5,620},{60,620}},
                                     color={0,127,255}));
  connect(senTTow_b.port_b, jun1.port_1) annotation (Line(points={{80,620},{180,
          620},{180,540},{170,540}}, color={0,127,255}));
  connect(weaBus, weaData.weaBus) annotation (Line(
      points={{-180,660},{-220,660}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{2,2},{2,5}},
      horizontalAlignment=TextAlignment.Left));
  connect(cooTow.TAir, weaBus.TWetBul) annotation (Line(points={{-11.9,623.3},{-179.95,
          623.3},{-179.95,660.05}},
                                  color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-2,2},{-2,5}},
      horizontalAlignment=TextAlignment.Right));
  connect(TAppOff.u, weaBus.TWetBul) annotation (Line(points={{-142,660},{-179.95,
          660},{-179.95,660.05}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-2,2},{-2,5}},
      horizontalAlignment=TextAlignment.Right));
  connect(TTowOut.y, TCooLvgSet.u1) annotation (Line(points={{-118,700},{-110,700},
          {-110,686},{-102,686}}, color={0,0,127}));
  connect(TAppOff.y, TCooLvgSet.u2) annotation (Line(points={{-118,660},{-110,660},
          {-110,674},{-102,674}}, color={0,0,127}));
  connect(senTTow_b.T, conTowFan.u_m) annotation (Line(points={{70,631},{70,650},
          {-50,650},{-50,668}}, color={0,0,127}));
  connect(hysWSE.u, TAppWSE.y)
    annotation (Line(points={{318,470},{302,470}}, color={0,0,127}));
  connect(hysWSE.y, mWSESet.u)
    annotation (Line(points={{342,470},{358,470}}, color={255,0,255}));
  connect(mWSESet.y, pumWSECW.m_flow_in) annotation (Line(points={{382,470},{400,
          470},{400,520},{240,520},{240,390},{172,390}}, color={0,0,127}));
  connect(mWSESet.y, pumWSEChi.m_flow_in) annotation (Line(points={{382,470},{400,
          470},{400,520},{240,520},{240,290},{172,290}}, color={0,0,127}));
  connect(pSetChiWatPum.y, pumCDU.dp_in)
    annotation (Line(points={{182,170},{208,170}}, color={0,0,127}));
  connect(hysChi.u, TAppWSE1.y)
    annotation (Line(points={{-402,260},{-418,260}}, color={0,0,127}));
  connect(hysChi.y, mEvaSet.u)
    annotation (Line(points={{-378,260},{-302,260}}, color={255,0,255}));
  connect(mEvaSet.y,pumEva. m_flow_in) annotation (Line(points={{-278,260},{-50,
          260},{-50,290},{-68,290}}, color={0,0,127}));
  connect(hysChi.y, mConSet.u) annotation (Line(points={{-378,260},{-356,260},{-356,
          300},{-302,300}}, color={255,0,255}));
  connect(mConSet.y, pumCon.m_flow_in) annotation (Line(points={{-278,300},{-240,
          300},{-240,388},{-56,388},{-56,420},{-68,420}}, color={0,0,127}));
  connect(mTowSet.y, pumTow.m_flow_in)
    annotation (Line(points={{-258,570},{-232,570}}, color={0,0,127}));
  connect(mConSet.y, mTowSet.u2) annotation (Line(points={{-278,300},{-240,300},
          {-240,548},{-296,548},{-296,564},{-282,564}}, color={0,0,127}));
  connect(mWSESet.y, mTowSet.u1) annotation (Line(points={{382,470},{400,470},{400,
          520},{-300,520},{-300,576},{-282,576}}, color={0,0,127}));
  connect(senTTow_b.port_b, bou1.ports[1])
    annotation (Line(points={{80,620},{228,620}}, color={0,127,255}));
  connect(senTCDU_b.T, TAppWSE.u1) annotation (Line(points={{40,131},{40,140},{260,
          140},{260,476},{278,476}}, color={0,0,127}));
  connect(senTTow_b.T, TAppWSE.u2) annotation (Line(points={{70,631},{70,650},{272,
          650},{272,464},{278,464}}, color={0,0,127}));
  connect(TOffSet.y, chi.TSet) annotation (Line(points={{-508,350},{-108,350},{-108,
          340},{-118,340}}, color={0,0,127}));
  connect(TOffSet.u, TSetEva.y)
    annotation (Line(points={{-532,350},{-538,350}}, color={0,0,127}));
  connect(PFan.y, EFan.u)
    annotation (Line(points={{381,420},{398,420}}, color={0,0,127}));
  connect(PPum.y, EPum.u)
    annotation (Line(points={{381,380},{398,380}}, color={0,0,127}));
  connect(PChi.y, EChi.u)
    annotation (Line(points={{381,340},{398,340}}, color={0,0,127}));
  connect(PIT.y, EPIT.u)
    annotation (Line(points={{381,300},{398,300}}, color={0,0,127}));
  connect(EChi.y, EFac.u[1]) annotation (Line(points={{421,340},{438,340},{438,378.425},
          {454,378.425}}, color={0,0,127}));
  connect(EPum.y, EFac.u[2]) annotation (Line(points={{421,380},{438,380},{438,379.475},
          {454,379.475}}, color={0,0,127}));
  connect(EFan.y, EFac.u[3]) annotation (Line(points={{421,420},{438,420},{438,380.525},
          {454,380.525}}, color={0,0,127}));
  connect(EFac.y, PUE.u1) annotation (Line(points={{467.02,380},{482,380},{482,336},
          {498,336}}, color={0,0,127}));
  connect(EPIT.y, PUE.u2) annotation (Line(points={{421,300},{458.5,300},{458.5,
          324},{498,324}}, color={0,0,127}));
  connect(EPIT.y, EFac.u[4]) annotation (Line(points={{421,300},{438,300},{438,380},
          {454,380},{454,381.575}}, color={0,0,127}));
  connect(jun7.port_1,senTWSEMix. port_b)
    annotation (Line(points={{-70,540},{-20,540}}, color={0,127,255}));
  connect(senTWSEMix.port_a, jun6.port_2)
    annotation (Line(points={{0,540},{50,540}}, color={0,127,255}));
  connect(jun7.port_3, valThr.port_a)
    annotation (Line(points={{-80,530},{-80,510}}, color={0,127,255}));
  connect(jun8.port_3, jun10.port_1)
    annotation (Line(points={{-180,530},{-180,470}}, color={0,127,255}));
  connect(jun10.port_2, senTChi_b1.port_b)
    annotation (Line(points={{-180,450},{-180,380}}, color={0,127,255}));
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
          370},{-100,404},{-350,404},{-350,418}}, color={0,0,127}));
  connect(senTEvaIn.T, TLifMin.u) annotation (Line(points={{-10,231},{-10,240},{
          -460,240},{-460,430},{-402,430}}, color={0,0,127}));
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
  connect(TTowOut.y, conTowFan.u_s) annotation (Line(points={{-118,700},{-70,700},
          {-70,680},{-62,680}}, color={0,0,127}));
  connect(conTowFan.y, cooTow.y) annotation (Line(points={{-38,680},{-26,680},{-26,
          627.1},{-11.9,627.1}},
                           color={0,0,127}));
  connect(senTEvaIn.T, TAppWSE1.u1) annotation (Line(points={{-10,231},{-10,240},
          {-460,240},{-460,266},{-442,266}}, color={0,0,127}));
  connect(ram.y, rac.u) annotation (Line(points={{-18,-40},{-10,-40},{-10,-54},{
          -1,-54}}, color={0,0,127}));
  connect(TOffSet.y, TAppWSE1.u2) annotation (Line(points={{-508,350},{-480,350},
          {-480,254},{-442,254}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-580,-120},{540,740}})),
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
