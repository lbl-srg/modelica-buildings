within Buildings.Fluid.Storage.Ice.Examples;
model DistrictCoolingIceTank
  "Example that tests the ice tank model for a simplified district cooling application"
  extends Modelica.Icons.Example;
  package MediumGly = Buildings.Media.Antifreeze.PropyleneGlycolWater (
    property_T=273.15,
    X_a=0.30,
    T_default=273.15) "Fluid medium";
  package MediumWat = Buildings.Media.Water(T_default=279.15) "Fluid medium";
  constant Modelica.Units.SI.SpecificEnergy Hf = 333550 "Fusion of heat of ice";
  parameter Real TChiWatSet_nominal(
    final unit="K",
    displayUnit="degC")=279.15
    "Nominal chilled water supply temperature";
  parameter Real COPWat_nominal = 4 "COP of water chiller at design conditions";
  parameter Real COPGly_nominal = 3 "COP of glycol chiller at design conditions";
  parameter Modelica.Units.SI.HeatFlowRate QDis_flow_nominal = -900E3 "District cooling coil load";
  final parameter Modelica.Units.SI.HeatFlowRate QWatChi_flow_nominal = 0.66*QDis_flow_nominal "Water chiller size";
  final parameter Modelica.Units.SI.HeatFlowRate QGly_flow_nominal = 0.66*QDis_flow_nominal "Glycol chiller size, assumed 66% of design day peak load";
  parameter Modelica.Units.SI.Time tSto = 2*6*3600 "Time for a full discharge of the storage at design load if storage serves all load";
  parameter Modelica.Units.SI.Mass mIceTan = -QDis_flow_nominal*tSto/Hf
    "Mass of ice in single storage tank";
  parameter Modelica.Units.SI.TemperatureDifference dTHex_nominal = 6 "Nominal temperature change across heat exchanger";
  parameter Modelica.Units.SI.MassFlowRate mDis_flow_nominal=-QDis_flow_nominal / cpWat / dTHex_nominal
    "Nominal mass flow rate of water through the district loop";
  final parameter Modelica.Units.SI.MassFlowRate mWatChi_flow_nominal=-QWatChi_flow_nominal / cpWat /dTHex_nominal
    "Nominal mass flow rate of water through the water chiller circuit";
  final parameter Modelica.Units.SI.MassFlowRate mWatHex_flow_nominal=-QGly_flow_nominal / cpWat /dTHex_nominal
    "Nominal mass flow rate of water through the water heat exchanger circuit";
  final parameter Modelica.Units.SI.MassFlowRate mWatChiCon_flow_nominal=mWatChi_flow_nominal * (1+1/COPWat_nominal)
    "Nominal mass flow rate of air through the chiller condenser coil";
  final parameter Modelica.Units.SI.MassFlowRate mGlyChiCon_flow_nominal=mGly_flow_nominal * (1+1/COPGly_nominal) * cpGly/cpWat
    "Nominal mass flow rate of air through the chiller condenser coil";
  final parameter Modelica.Units.SI.MassFlowRate mGly_flow_nominal=-QGly_flow_nominal / cpGly / dTHex_nominal
    "Nominal mass flow rate of glycol through the glycol circuit";
  final parameter Modelica.Units.SI.SpecificHeatCapacity cpWat = MediumWat.cp_const "Isobaric specific heat capacity";
  final parameter Modelica.Units.SI.SpecificHeatCapacity cpGly = MediumGly.cp_const "Isobaric specific heat capacity";
  parameter Buildings.Fluid.Storage.Ice.Data.Tank.Generic perIceTan(
    mIce_max=mIceTan,
    coeCha={1.76953858E-04,0,0,0,0,0},
    dtCha=10,
    coeDisCha={5.54E-05,-1.45679E-04,9.28E-05,1.126122E-03,-1.1012E-03,3.00544E-04},
    dtDisCha=10) "Tank performance data"
    annotation (Placement(transformation(extent={{-280,140},{-260,160}})));
  Buildings.Fluid.Storage.Ice.Tank iceTan(
    allowFlowReversal=allowFlowReversal,
    show_T=true,
    redeclare package Medium = MediumGly,
    m_flow_nominal=mGly_flow_nominal,
    dp_nominal=10000,
    SOC_start=0.1,
    per=perIceTan,
    energyDynamicsHex=Modelica.Fluid.Types.Dynamics.FixedInitial)
                   "Ice tank" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-240,10})));
  Chillers.Carnot_TEva                             chiGly(
    show_T=true,
    redeclare package Medium1 = MediumWat,
    redeclare package Medium2 = MediumGly,
    m1_flow_nominal=mGlyChiCon_flow_nominal,
    m2_flow_nominal=mGly_flow_nominal,
    QEva_flow_nominal=QGly_flow_nominal,
    etaCarnot_nominal=0.3,
    dp1_nominal=16000,
    dp2_nominal=16000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    QEva_flow_min=QGly_flow_nominal)                           annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-70,10})));
  Chillers.Carnot_TEva                             chiWat(
    show_T=true,
    redeclare package Medium1 = MediumWat,
    redeclare package Medium2 = MediumWat,
    m1_flow_nominal=mWatChiCon_flow_nominal,
    m2_flow_nominal=mWatChi_flow_nominal,
    QEva_flow_nominal=QWatChi_flow_nominal,
    etaCarnot_nominal=0.3,
    dp1_nominal=16000,
    dp2_nominal=16000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    QEva_flow_min=QWatChi_flow_nominal)                        "Water chiller"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={192,10})));
  HeatExchangers.PlateHeatExchangerEffectivenessNTU
                                       hex(
    allowFlowReversal1=allowFlowReversal,
    allowFlowReversal2=allowFlowReversal,
    show_T=true,
    redeclare package Medium1 = MediumGly,
    redeclare package Medium2 = MediumWat,
    m1_flow_nominal=mGly_flow_nominal,
    m2_flow_nominal=mWatHex_flow_nominal,
    dp2_nominal=16000,
    dp1_nominal=16000,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    use_Q_flow_nominal=true,
    Q_flow_nominal=QGly_flow_nominal,
    T_a1_nominal=TChiWatSet_nominal - dTHex_nominal,
    T_a2_nominal=TChiWatSet_nominal + dTHex_nominal/4)
                       "Heat exchanger"
    annotation (Placement(transformation(extent={{10,-10},
            {-10,10}},                                                                              rotation=90,origin={60,10})));
  HeatExchangers.HeaterCooler_u disCooCoi(
    redeclare package Medium = MediumWat,
    allowFlowReversal=false,
    m_flow_nominal=mDis_flow_nominal,
    show_T=true,
    dp_nominal=16000+500*2*200,
    tau=3600,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=-QDis_flow_nominal)
    "District cooling coil, with dp for 500 m district (supply and return) at 200 Pa/m each" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={320,10})));
  Actuators.Valves.TwoWayLinear valStoDis(
    redeclare package Medium = MediumGly,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=mGly_flow_nominal,
    dpValve_nominal=6000,
    dpFixed_nominal=0,
    y_start=0,
    use_inputFilter=false) "Control valve for glycol loop" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-240,-130})));
  Actuators.Valves.TwoWayLinear valStoCha(
    redeclare package Medium = MediumGly,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=mGly_flow_nominal,
    dpValve_nominal=6000,
    dpFixed_nominal=0,
    y_start=0,
    use_inputFilter=false) "Control valve for glycol loop" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-190,-98})));
  Movers.FlowControlled_m_flow pumHexPri(
    redeclare package Medium = MediumGly,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=mGly_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true)
                                      "Pump" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={40,-50})));
  Movers.FlowControlled_m_flow pumHexSec(
    redeclare package Medium = MediumWat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=false,
    m_flow_nominal=mWatHex_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true)
                                      "Pump" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={100,-50})));
  Movers.FlowControlled_m_flow pumChiWat(
    redeclare package Medium = MediumWat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=false,
    m_flow_nominal=mWatChiCon_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true)
                                      "Pump" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={160,-50})));
  Movers.FlowControlled_m_flow pumLoa(
    redeclare package Medium = MediumWat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=false,
    m_flow_nominal=mDis_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true)
                                      "Pump" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={320,-50})));
  Movers.FlowControlled_m_flow pumSto(
    redeclare package Medium = MediumGly,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=mGly_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    final use_inputFilter=true)       "Pump" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-240,-50})));
  Movers.FlowControlled_m_flow pumChiGly(
    redeclare package Medium = MediumGly,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=mGly_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true)
                                      "Pump" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-100,-50})));
  Sources.MassFlowSource_T           souWatChiCon(
    use_T_in=true,
    nPorts=1,
    redeclare package Medium = MediumWat,
    m_flow=mWatChiCon_flow_nominal) "Weather data" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={220,50})));
  Sources.Boundary_pT sin1(redeclare package Medium = MediumWat,
    nPorts=1) "Pressure source"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={220,-50})));
  Sources.Boundary_pT preSouWat(redeclare package Medium = MediumWat, nPorts=1)
    "Source for pressure and to account for thermal expansion of water"
    annotation (Placement(transformation(extent={{70,-190},{90,-170}})));
  Sources.MassFlowSource_T           souGlyChiCon(
    use_T_in=true,
    nPorts=1,
    redeclare package Medium = MediumWat,
    m_flow=mGlyChiCon_flow_nominal) "Weather data" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-36,50})));
  Sources.Boundary_pT sin2(redeclare package Medium = MediumWat,
    nPorts=1) "Pressure source"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={-50,-50})));
  Sources.Boundary_pT preSouGly(redeclare package Medium = MediumGly,
    p=ppar,                                                           nPorts=1)
    "Source for pressure and to account for thermal expansion of glycol"
    annotation (Placement(transformation(extent={{-270,-190},{-250,-170}})));
  FixedResistances.Junction jun(
    redeclare package Medium = MediumGly,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mGly_flow_nominal*{1,1,1},
    dp_nominal={0,0,0})
    annotation (Placement(transformation(extent={{-110,90},{-90,110}})));
  FixedResistances.Junction junGlySecSup(
    redeclare package Medium = MediumGly,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mGly_flow_nominal*{1,1,1},
    dp_nominal={0,0,0}) "Junction for secondary loop glycol"
    annotation (Placement(transformation(extent={{-30,90},{-10,110}})));
  FixedResistances.Junction junSecGlyRet(
    redeclare package Medium = MediumGly,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mGly_flow_nominal*{1,1,1},
    dp_nominal={0,0,0}) "Junction for secondary loop return"
    annotation (Placement(transformation(extent={{-30,-170},{-10,-190}})));
  FixedResistances.Junction jun3(
    redeclare package Medium = MediumGly,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mGly_flow_nominal*{1,1,1},
    dp_nominal={0,0,0})
    annotation (Placement(transformation(extent={{-110,-170},{-90,-190}})));
  FixedResistances.Junction junSecRet(
    redeclare package Medium = MediumWat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mDis_flow_nominal*{1,1,1},
    dp_nominal={0,0,0}) "Junction for secondary return"
    annotation (Placement(transformation(extent={{250,-170},{270,-190}})));
  FixedResistances.Junction junWatChiIn(
    redeclare package Medium = MediumWat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mDis_flow_nominal*{1,1,1},
    dp_nominal={0,0,0}) "Junction for water chiller inlet"
    annotation (Placement(transformation(extent={{150,-170},{170,-190}})));
  FixedResistances.Junction junWatChiOut(
    redeclare package Medium = MediumWat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mDis_flow_nominal*{1,1,1},
    dp_nominal={0,0,0}) "Junction for water chiller outlet"
    annotation (Placement(transformation(extent={{150,90},{170,110}})));
  FixedResistances.Junction junSecSup(
    redeclare package Medium = MediumWat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mDis_flow_nominal*{1,1,1},
    dp_nominal={0,0,0}) "Junction for secondary supply"
    annotation (Placement(transformation(extent={{250,90},{270,110}})));
  FixedResistances.Junction jun8(
    redeclare package Medium = MediumGly,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mGly_flow_nominal*{1,1,1},
    dp_nominal={0,0,0})
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-100,50})));
  Sensors.TemperatureTwoPort senTemHexWat(
    redeclare package Medium = MediumWat,
    allowFlowReversal=false,
    m_flow_nominal=mWatHex_flow_nominal,
    tau=0)
    "Heat exchanger outlet temperature on water side" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={100,60})));
  Controls.OBC.CDL.Continuous.MultiplyByParameter gaiGlyPumHex(
    k=mGly_flow_nominal) "Gain for glycol pump mass flow rate"
    annotation (Placement(transformation(extent={{-320,10},{-300,30}})));
  Controls.OBC.CDL.Continuous.MultiplyByParameter gaiPumWatHex(
    k=mWatHex_flow_nominal) "Gain for water flow rate of water pumps"
    annotation (Placement(transformation(extent={{40,250},{60,270}})));
  BaseClasses.ControlClosedLoop con "Controller"
    annotation (Placement(transformation(extent={{-420,218},{-404,246}})));
  Controls.OBC.CDL.Continuous.MultiplyByParameter gaiPumSec(
    k=mDis_flow_nominal) "Gain for water flow rate of water pumps"
    annotation (Placement(transformation(extent={{380,-60},{360,-40}})));
  Controls.OBC.CDL.Continuous.MultiplyByParameter gaiPumWatChi(
    k=mWatChi_flow_nominal) "Gain for water flow rate of water pumps"
    annotation (Placement(transformation(extent={{40,282},{60,302}})));
  Controls.OBC.CDL.Continuous.MultiplyByParameter gaiGlyPumChi(
    k=mGly_flow_nominal) "Gain for glycol pump mass flow rate"
    annotation (Placement(transformation(extent={{-320,-28},{-300,-8}})));
  Controls.OBC.CDL.Continuous.MultiplyByParameter gaiGlyPumSto(
    k=mGly_flow_nominal) "Gain for glycol pump mass flow rate"
    annotation (Placement(transformation(extent={{-320,-60},{-300,-40}})));
  Controls.OBC.CDL.Continuous.Sources.Constant chiWatTSet(k=TChiWatSet_nominal)
    "Set point for secondary chilled water temperature"
    annotation (Placement(transformation(extent={{-520,284},{-500,304}})));
  Controls.OBC.CDL.Integers.Sources.Constant powMod1(k=Integer(Buildings.Fluid.Storage.Ice.Examples.BaseClasses.OperationModes.LowPower))
    "Power mode of plant low mode"
    annotation (Placement(transformation(extent={{-582,150},{-562,170}})));
  BaseClasses.ControlDemandLevel conDemLev(k=0.07,Ti=120,
    waitTime=120)
    "Controller that outputs the demand level"
    annotation (Placement(transformation(extent={{-480,280},{-460,300}})));
  Sensors.TemperatureTwoPort senTemSupSec(
    redeclare package Medium =MediumWat,
    m_flow_nominal=mDis_flow_nominal)
    "Water supply temperature to load" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={292,100})));
  Controls.OBC.CDL.Continuous.Sources.Constant TConMin(k=273.15 + 15)
    "Minimum condensor water entering temperature"
    annotation (Placement(transformation(extent={{-400,330},{-380,350}})));
  Controls.OBC.CDL.Continuous.Max TCon "Condenser water entering temperature"
    annotation (Placement(transformation(extent={{-320,350},{-300,370}})));
  Controls.OBC.CDL.Continuous.AddParameter TConEntNoFre(p=4)
    "Condenser entering temperature without freeze protection"
    annotation (Placement(transformation(extent={{-360,360},{-340,380}})));
  Sensors.TemperatureTwoPort senTemHexWat1(
    redeclare package Medium = MediumWat,
    allowFlowReversal=false,
    m_flow_nominal=mWatHex_flow_nominal,
    tau=0)
    "Heat exchanger outlet temperature on water side" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={160,60})));
  Modelica.Blocks.Sources.CombiTimeTable loadBlock(
    tableOnFile=true,
    tableName="tab1",
    fileName=ModelicaServices.ExternalReferences.loadResource(
        "modelica://Buildings/Resources/Data/Fluid/Storage/Ice/Examples/LoadBlockData.txt"),
    columns=2:5,
    timeScale=1,
    offset={0,0,-288,0})
    "Data columns are t = y[0], Tdb = y[1], Twb = y[2], QCoo_flow = y[3], and CO2e = y[4]"
    annotation (Placement(transformation(extent={{482,202},{462,222}})));
  Modelica.Thermal.HeatTransfer.Celsius.ToKelvin toKelvin
    "Convert Twb from Celsius to Kelvin"
    annotation (Placement(transformation(extent={{318,378},{298,398}})));
  Controls.OBC.CDL.Continuous.MultiplyByParameter norLoa(k=1/QDis_flow_nominal)
    "Normalize load"
    annotation (Placement(transformation(extent={{430,110},{410,130}})));
  Controls.OBC.CDL.Integers.Switch intSwi
    annotation (Placement(transformation(extent={{-514,172},{-494,192}})));
  Controls.OBC.CDL.Integers.Switch intSwi1
    annotation (Placement(transformation(extent={{-456,178},{-436,198}})));
  Controls.OBC.CDL.Integers.Sources.Constant powMod2(k=Integer(Buildings.Fluid.Storage.Ice.Examples.BaseClasses.OperationModes.Efficiency))
    "Power mode of plant efficiency mode"
    annotation (Placement(transformation(extent={{-580,190},{-560,210}})));
  Controls.OBC.CDL.Integers.Sources.Constant powMod3(k=Integer(Buildings.Fluid.Storage.Ice.Examples.BaseClasses.OperationModes.HighPower))
    "Power mode of plant High mode"
    annotation (Placement(transformation(extent={{-580,230},{-560,250}})));
  Controls.OBC.CDL.Continuous.Less lesThr(h=50)
    annotation (Placement(transformation(extent={{-550,168},{-530,188}})));
  Controls.OBC.CDL.Continuous.Less lesThr1(h=50)
    annotation (Placement(transformation(extent={{-482,178},{-462,198}})));
  Controls.OBC.CDL.Continuous.MovingAverage movAve1(delta=3600*24*15)
    annotation (Placement(transformation(extent={{-580,110},{-560,130}})));
  parameter Boolean allowFlowReversal=true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal";
  parameter Modelica.Media.Interfaces.Types.AbsolutePressure ppar=MediumGly.p_default*
      2 "Fixed value of pressure";
equation
  connect(pumSto.port_b, iceTan.port_a)
    annotation (Line(points={{-240,-40},{-240,0}}, color={0,127,255}));
  connect(pumChiGly.port_b, chiGly.port_a2) annotation (Line(points={{-100,-40},
          {-100,-6},{-76,-6},{-76,-1.77636e-15}},
                                color={0,127,255}));
  connect(pumSto.port_a, valStoCha.port_b) annotation (Line(points={{-240,-60},{
          -240,-98},{-200,-98}},  color={0,127,255}));
  connect(pumChiWat.port_b, chiWat.port_a2)
    annotation (Line(points={{160,-40},{160,-20},{186,-20},{186,-1.77636e-15}},
                                                 color={0,127,255}));
  connect(pumHexSec.port_b, hex.port_a2) annotation (Line(points={{100,-40},{100,
          -12},{66,-12},{66,0}},                    color={0,127,255}));
  connect(souGlyChiCon.ports[1], chiGly.port_a1) annotation (Line(points={{-36,40},
          {-36,28},{-64,28},{-64,20}}, color={0,127,255}));
  connect(chiGly.port_b1, sin2.ports[1]) annotation (Line(points={{-64,-5.32907e-15},
          {-64,-50},{-60,-50}},color={0,127,255}));
  connect(souWatChiCon.ports[1], chiWat.port_a1) annotation (Line(points={{220,40},
          {220,24},{198,24},{198,20}}, color={0,127,255}));
  connect(chiWat.port_b1, sin1.ports[1])
    annotation (Line(points={{198,-5.32907e-15},{198,-50},{210,-50}},
                                                          color={0,127,255}));
  connect(disCooCoi.port_b, pumLoa.port_a)
    annotation (Line(points={{320,0},{320,-40}},   color={0,127,255}));
  connect(pumHexPri.port_a, hex.port_b1) annotation (Line(points={{40,-40},{40,-12},
          {54,-12},{54,0}},      color={0,127,255}));
  connect(iceTan.port_b, jun.port_1) annotation (Line(points={{-240,20},{-240,100},
          {-110,100}}, color={0,127,255}));
  connect(valStoDis.port_b, pumSto.port_a)
    annotation (Line(points={{-240,-120},{-240,-60}}, color={0,127,255}));
  connect(jun8.port_2, chiGly.port_b2) annotation (Line(points={{-100,40},{-100,
          32},{-76,32},{-76,20}}, color={0,127,255}));
  connect(jun8.port_1, jun.port_3)
    annotation (Line(points={{-100,60},{-100,90}}, color={0,127,255}));
  connect(jun8.port_3, valStoCha.port_a) annotation (Line(points={{-110,50},{-160,
          50},{-160,-98},{-180,-98}},      color={0,127,255}));
  connect(valStoDis.port_a, jun3.port_1) annotation (Line(points={{-240,-140},{-240,
          -180},{-110,-180}},      color={0,127,255}));
  connect(jun3.port_3, pumChiGly.port_a)
    annotation (Line(points={{-100,-170},{-100,-60}}, color={0,127,255}));
  connect(jun3.port_2, junSecGlyRet.port_1)
    annotation (Line(points={{-90,-180},{-30,-180}}, color={0,127,255}));
  connect(junSecGlyRet.port_3, junGlySecSup.port_3)
    annotation (Line(points={{-20,-170},{-20,90}}, color={0,127,255}));
  connect(junGlySecSup.port_2, hex.port_a1)
    annotation (Line(points={{-10,100},{54,100},{54,20}}, color={0,127,255}));
  connect(jun.port_2, junGlySecSup.port_1)
    annotation (Line(points={{-90,100},{-30,100}}, color={0,127,255}));
  connect(pumHexPri.port_b, junSecGlyRet.port_2) annotation (Line(points={{40,-60},
          {40,-180},{-10,-180}}, color={0,127,255}));
  connect(pumHexSec.port_a, junWatChiIn.port_1) annotation (Line(points={{100,-60},
          {100,-180},{150,-180}}, color={0,127,255}));
  connect(junWatChiOut.port_2, junSecSup.port_1)
    annotation (Line(points={{170,100},{250,100}}, color={0,127,255}));
  connect(pumChiWat.port_a, junWatChiIn.port_3)
    annotation (Line(points={{160,-60},{160,-170}}, color={0,127,255}));
  connect(junSecSup.port_3, junSecRet.port_3)
    annotation (Line(points={{260,90},{260,-170}}, color={0,127,255}));
  connect(pumLoa.port_b, junSecRet.port_2) annotation (Line(points={{320,-60},{
          320,-180},{270,-180}}, color={0,127,255}));
  connect(junSecRet.port_1, junWatChiIn.port_2)
    annotation (Line(points={{250,-180},{170,-180}}, color={0,127,255}));
  connect(preSouWat.ports[1], junWatChiIn.port_1)
    annotation (Line(points={{90,-180},{150,-180}}, color={0,127,255}));
  connect(preSouGly.ports[1], jun3.port_1)
    annotation (Line(points={{-250,-180},{-110,-180}}, color={0,127,255}));
  connect(hex.port_b2, senTemHexWat.port_a) annotation (Line(points={{66,20},{66,
          24},{100,24},{100,50}}, color={0,127,255}));
  connect(senTemHexWat.port_b, junWatChiOut.port_1) annotation (Line(points={{100,70},
          {100,100},{150,100}},         color={0,127,255}));
  connect(gaiPumWatHex.y, pumHexSec.m_flow_in) annotation (Line(points={{62,260},
          {120,260},{120,-50},{112,-50}}, color={0,0,127}));
  connect(con.TChiWatSet, chiWat.TSet) annotation (Line(points={{-403.333,
          243.76},{201,243.76},{201,22}},
                                   color={0,0,127}));
  connect(con.TChiGlySet, chiGly.TSet) annotation (Line(points={{-403.333,
          241.52},{-61,241.52},{-61,22}},
                              color={0,0,127}));
  connect(con.yStoOn, valStoDis.y) annotation (Line(points={{-403.333,239.28},{
          -340,239.28},{-340,-130},{-252,-130}},                        color={
          0,0,127}));
  connect(con.yStoByp, valStoCha.y) annotation (Line(points={{-403.333,237.04},
          {-346,237.04},{-346,-80},{-190,-80},{-190,-86}},
        color={0,0,127}));
  connect(gaiPumSec.y, pumLoa.m_flow_in)
    annotation (Line(points={{358,-50},{332,-50}}, color={0,0,127}));
  connect(gaiPumWatChi.y, pumChiWat.m_flow_in) annotation (Line(points={{62,292},
          {140,292},{140,-50},{148,-50}}, color={0,0,127}));
  connect(gaiGlyPumSto.y, pumSto.m_flow_in)
    annotation (Line(points={{-298,-50},{-252,-50}}, color={0,0,127}));
  connect(gaiGlyPumChi.y, pumChiGly.m_flow_in) annotation (Line(points={{-298,-18},
          {-140,-18},{-140,-50},{-112,-50}}, color={0,0,127}));
  connect(gaiGlyPumHex.y, pumHexPri.m_flow_in) annotation (Line(points={{-298,20},
          {-282,20},{-282,-14},{12,-14},{12,-50},{28,-50}}, color={0,0,127}));
  connect(gaiGlyPumSto.u, con.yPumSto) annotation (Line(points={{-322,-50},{
          -360,-50},{-360,228.08},{-403.333,228.08}},
                                                 color={0,0,127}));
  connect(gaiGlyPumHex.u, con.yPumGlyHex) annotation (Line(points={{-322,20},{
          -366,20},{-366,223.6},{-403.333,223.6}},
                                              color={0,0,127}));
  connect(gaiGlyPumChi.u, con.yPumGlyChi) annotation (Line(points={{-322,-18},{
          -374,-18},{-374,225.728},{-403.333,225.728}},
                                                   color={0,0,127}));
  connect(con.yPumWatHex, gaiPumWatHex.u) annotation (Line(points={{-403.333,
          221.36},{-181.667,221.36},{-181.667,260},{38,260}},
                                                      color={0,0,127}));
  connect(con.yPumWatChi, gaiPumWatChi.u) annotation (Line(points={{-403.333,
          219.12},{-176,219.12},{-176,292},{38,292}},
                                              color={0,0,127}));
  connect(con.SOC, iceTan.SOC) annotation (Line(points={{-420.667,222.48},{-430,
          222.48},{-430,40},{-244,40},{-244,21}}, color={0,0,127}));
  connect(con.THexWatLea, senTemHexWat.T) annotation (Line(points={{-420.667,
          226.848},{-428,226.848},{-428,180},{80,180},{80,60},{89,60}},
                                                               color={0,0,127}));
  connect(con.TSetLoa, chiWatTSet.y) annotation (Line(points={{-420.667,232.56},
          {-420.667,232},{-486,232},{-486,294},{-498,294}},
                                                color={0,0,127}));
  connect(conDemLev.y, con.demLev) annotation (Line(points={{-458,296},{-452,
          296},{-452,243.76},{-420.667,243.76}},                       color={
          255,127,0}));
  connect(conDemLev.u_s, chiWatTSet.y) annotation (Line(points={{-482,295},{-482,
          294},{-498,294}},                 color={0,0,127}));
  connect(junSecSup.port_2, senTemSupSec.port_a)
    annotation (Line(points={{270,100},{282,100}}, color={0,127,255}));
  connect(senTemSupSec.port_b, disCooCoi.port_a) annotation (Line(points={{302,
          100},{320,100},{320,20}}, color={0,127,255}));
  connect(senTemSupSec.T,conDemLev. u_m) annotation (Line(points={{292,111},{292,
          124},{-486,124},{-486,284},{-482,284},{-482,285}},
                                                      color={0,0,127}));
  connect(TConMin.y, TCon.u2) annotation (Line(points={{-378,340},{-360,340},{-360,
          354},{-322,354}}, color={0,0,127}));
  connect(TCon.u1, TConEntNoFre.y) annotation (Line(points={{-322,366},{-328,366},
          {-328,370},{-338,370}}, color={0,0,127}));
  connect(TCon.y, souWatChiCon.T_in)
    annotation (Line(points={{-298,360},{216,360},{216,62}}, color={0,0,127}));
  connect(TCon.y, souGlyChiCon.T_in)
    annotation (Line(points={{-298,360},{-40,360},{-40,62}}, color={0,0,127}));
  connect(junWatChiOut.port_3, senTemHexWat1.port_b)
    annotation (Line(points={{160,90},{160,70}}, color={0,127,255}));
  connect(senTemHexWat1.port_a, chiWat.port_b2) annotation (Line(points={{160,50},
          {160,40},{186,40},{186,20}}, color={0,127,255}));
  connect(conDemLev.yDemLev2, con.yDemLev2) annotation (Line(points={{-458,284},
          {-454,284},{-454,239.168},{-420.667,239.168}},
        color={0,0,127}));
  connect(con.yDemLev1,conDemLev. yDemLev1) annotation (Line(points={{-420.667,
          241.408},{-420.667,242},{-448,242},{-448,290},{-458,290}},
        color={0,0,127}));
  connect(loadBlock.y[2], toKelvin.Celsius) annotation (Line(points={{461,212},{
          332,212},{332,388},{320,388}},  color={0,0,127}));
  connect(toKelvin.Kelvin, TConEntNoFre.u) annotation (Line(points={{297,388},{
          -380,388},{-380,370},{-362,370}}, color={0,0,127}));
  connect(loadBlock.y[3], norLoa.u) annotation (Line(points={{461,212},{440,212},
          {440,120},{432,120}}, color={0,0,127}));
  connect(norLoa.y, disCooCoi.u)
    annotation (Line(points={{408,120},{326,120},{326,22}}, color={0,0,127}));
  connect(norLoa.y, gaiPumSec.u) annotation (Line(points={{408,120},{400,120},{
          400,-50},{382,-50}}, color={0,0,127}));
  connect(powMod1.y, intSwi.u3) annotation (Line(points={{-560,160},{-516,160},{
          -516,174}},  color={255,127,0}));
  connect(powMod2.y, intSwi.u1) annotation (Line(points={{-558,200},{-524,200},{
          -524,190},{-516,190}},  color={255,127,0}));
  connect(powMod3.y, intSwi1.u1) annotation (Line(points={{-558,240},{-460,240},
          {-460,196},{-458,196}}, color={255,127,0}));
  connect(intSwi.y, intSwi1.u3)
    annotation (Line(points={{-492,182},{-476,182},{-476,180},{-458,180}},
                                                     color={255,127,0}));
  connect(lesThr.y, intSwi.u2) annotation (Line(points={{-528,178},{-522,178},{-522,
          182},{-516,182}},      color={255,0,255}));
  connect(intSwi1.y, con.powMod) annotation (Line(points={{-434,188},{-436,188},
          {-436,235.92},{-420.667,235.92}}, color={255,127,0}));
  connect(intSwi1.u2, lesThr1.y)
    annotation (Line(points={{-458,188},{-460,188}}, color={255,0,255}));
  connect(loadBlock.y[4], movAve1.u) annotation (Line(points={{461,212},{461,322},
          {-590,322},{-590,120},{-582,120}}, color={0,0,127}));
  connect(movAve1.y, lesThr.u2) annotation (Line(points={{-558,120},{-548,120},{
          -548,156},{-552,156},{-552,170}}, color={0,0,127}));
  connect(movAve1.y, lesThr1.u2) annotation (Line(points={{-558,120},{-528,120},
          {-528,122},{-490,122},{-490,180},{-484,180}}, color={0,0,127}));
  connect(loadBlock.y[4], lesThr.u1) annotation (Line(points={{461,212},{461,
          312},{-552,312},{-552,178}}, color={0,0,127}));
  connect(lesThr1.u1, lesThr.u1) annotation (Line(points={{-484,188},{-518,188},
          {-518,222},{-552,222},{-552,178}}, color={0,0,127}));
  annotation (
    experiment(
      StopTime=31536000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Radau"),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Ice/Examples/DistrictCoolingIceTank.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>
System model for a district cooling that is served by a water chiller, a glycol chiller, and an ice tank.
</p>
<p align=\"center\">
<img alt=\"image of ice system\" width=\"750\" src=\"modelica://Buildings/Resources/Images/Fluid/Storage/IceSystem.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
November 10, 2022, by Ettore Zanetti:<br/>
Refactored implementation and added new control modes.
</li>
<li>
September 8, 2022, by Michael Wetter:<br/>
Refactored implementation.
</li>
<li>
March 1, 2022, by Dre Helmns:<br/>
Implementation of ice tank in a simplified district cooling system.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-600,-320},{500,400}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end DistrictCoolingIceTank;
