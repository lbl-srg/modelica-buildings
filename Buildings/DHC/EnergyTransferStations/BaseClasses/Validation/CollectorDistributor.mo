within Buildings.DHC.EnergyTransferStations.BaseClasses.Validation;
model CollectorDistributor
  "Validation of collector distributor model"
  extends Modelica.Icons.Example;
  package Medium=Buildings.Media.Water
    "Source side medium";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate";
  Fluid.Movers.FlowControlled_m_flow sou1(
    redeclare package Medium=Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    T_start=273.15+40,
    m_flow_nominal=m_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true)
    "Primary supply"
    annotation (Placement(transformation(extent={{-170,330},{-150,350}})));
  Fluid.Movers.FlowControlled_m_flow sou2_1(
    redeclare package Medium=Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    T_start=273.15+30,
    m_flow_nominal=m_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true)
    "Secondary pump"
    annotation (Placement(transformation(extent={{190,290},{170,310}})));
  Fluid.Sources.Boundary_pT bou1(
    redeclare package Medium=Medium,
    use_T_in=true,
    nPorts=2)
    "Boundary pressure"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-190,320})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp m1(
    height=1.1,
    duration=1000,
    startTime=0)
    "Primary flow"
    annotation (Placement(transformation(extent={{-240,370},{-220,390}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant T1(
    k=40+273.15)
    "Primary supply temperature"
    annotation (Placement(transformation(extent={{-240,270},{-220,290}})));
  Fluid.Sensors.TemperatureTwoPort senT2_1Sup(
    redeclare final package Medium=Medium,
    m_flow_nominal=m_flow_nominal)
    "Secondary supply temperature (measured)"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={60,340})));
  Fluid.Sensors.TemperatureTwoPort senT1_1Sup(
    redeclare final package Medium=Medium,
    m_flow_nominal=m_flow_nominal)
    "Primary supply temperature (measured)"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-100,340})));
  Fluid.Sensors.TemperatureTwoPort senT1_1Ret(
    redeclare final package Medium=Medium,
    m_flow_nominal=m_flow_nominal)
    "Primary return temperature (measured)"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={-100,300})));
  Fluid.Sensors.TemperatureTwoPort senT2_1Ret(
    redeclare final package Medium=Medium,
    m_flow_nominal=m_flow_nominal)
    "Secondary return temperature (measured)"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={60,300})));
  Fluid.Sensors.MassFlowRate senMasFlo1_1(
    redeclare final package Medium=Medium)
    "Primary mass flow rate (measured)"
    annotation (Placement(transformation(extent={{-140,330},{-120,350}})));
  Fluid.Sensors.MassFlowRate senMasFlo2_1(
    redeclare final package Medium=Medium)
    "Secondary mass flow rate (measured)"
    annotation (Placement(transformation(extent={{130,330},{150,350}})));
  Fluid.MixingVolumes.MixingVolume vol2_1(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=273.15+30,
    final prescribedHeatFlowRate=true,
    redeclare final package Medium=Medium,
    V=1,
    final mSenFac=1,
    final m_flow_nominal=m_flow_nominal,
    nPorts=2)
    "Volume for fluid stream"
    annotation (Placement(transformation(extent={{209,300},{229,280}})));
  Fluid.HeatExchangers.HeaterCooler_u coo(
    redeclare final package Medium=Medium,
    dp_nominal=1,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=-1E5)
    "Heat exchange with water stream"
    annotation (Placement(transformation(extent={{100,290},{80,310}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant T2_1Ret(
    k=30+273.15)
    "First secondary return temperature"
    annotation (Placement(transformation(extent={{60,370},{80,390}})));
  Buildings.Controls.OBC.CDL.Reals.PID conTChiWat1(
    k=0.1,
    Ti=10,
    yMax=1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    yMin=0,
    reverseActing=false)
    "PI controller for chilled water supply"
    annotation (Placement(transformation(extent={{90,370},{110,390}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp m2_1(
    height=0.5,
    duration=1000,
    offset=0.5,
    startTime=2000)
    "First secondary flow signal"
    annotation (Placement(transformation(extent={{220,370},{200,390}})));
  Fluid.Movers.FlowControlled_m_flow sou2_2(
    redeclare package Medium=Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    T_start=273.15+30,
    m_flow_nominal=m_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true)
    "Secondary pump"
    annotation (Placement(transformation(extent={{190,150},{170,170}})));
  Fluid.Sensors.TemperatureTwoPort senT2_2Sup(
    redeclare final package Medium=Medium,
    m_flow_nominal=m_flow_nominal)
    "Secondary supply temperature (measured)"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={60,200})));
  Fluid.Sensors.TemperatureTwoPort senT2_2Ret(
    redeclare final package Medium=Medium,
    m_flow_nominal=m_flow_nominal)
    "Secondary return temperature (measured)"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={60,160})));
  Fluid.Sensors.MassFlowRate senMasFlo2_2(
    redeclare final package Medium=Medium)
    "Secondary mass flow rate (measured)"
    annotation (Placement(transformation(extent={{130,190},{150,210}})));
  Fluid.MixingVolumes.MixingVolume vol2(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=273.15+30,
    final prescribedHeatFlowRate=true,
    redeclare final package Medium=Medium,
    V=1,
    final mSenFac=1,
    final m_flow_nominal=m_flow_nominal,
    nPorts=2)
    "Volume for fluid stream"
    annotation (Placement(transformation(extent={{209,160},{229,140}})));
  Fluid.HeatExchangers.HeaterCooler_u coo1(
    redeclare final package Medium=Medium,
    dp_nominal=1,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=-1E5)
    "Heat exchange with water stream"
    annotation (Placement(transformation(extent={{100,150},{80,170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant T2_2Ret(
    k=35+273.15)
    "Second secondary return temperature"
    annotation (Placement(transformation(extent={{60,230},{80,250}})));
  Buildings.Controls.OBC.CDL.Reals.PID conTChiWat2(
    k=0.1,
    Ti=10,
    yMax=1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    yMin=0,
    reverseActing=false)
    "PI controller for chilled water supply"
    annotation (Placement(transformation(extent={{90,230},{110,250}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant m2_2(
    k=0.5)
    "Second secondary mass flow rate signal"
    annotation (Placement(transformation(extent={{220,230},{200,250}})));
  Buildings.DHC.EnergyTransferStations.BaseClasses.CollectorDistributor colDis(
    redeclare final package Medium=Medium,
    mCon_flow_nominal=fill(
      m_flow_nominal,
      2),
    nCon=2)
    "Collector/distributor"
    annotation (Placement(transformation(extent={{-60,310},{-20,330}})));
  Fluid.Movers.FlowControlled_m_flow sou2(
    redeclare package Medium=Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    T_start=273.15+40,
    m_flow_nominal=m_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    dp_nominal=50E3)
    "Primary supply"
    annotation (Placement(transformation(extent={{-170,50},{-150,70}})));
  Fluid.Sources.Boundary_pT bou2(
    redeclare package Medium=Medium,
    use_T_in=true,
    nPorts=2)
    "Boundary pressure"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-190,40})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant T2(
    k=40+273.15)
    "Primary supply temperature"
    annotation (Placement(transformation(extent={{-240,-10},{-220,10}})));
  Fluid.Sensors.TemperatureTwoPort senT2_3Sup(
    redeclare final package Medium=Medium,
    m_flow_nominal=m_flow_nominal)
    "Secondary supply temperature (measured)"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={60,60})));
  Fluid.Sensors.TemperatureTwoPort senT1_2Sup(
    redeclare final package Medium=Medium,
    m_flow_nominal=m_flow_nominal)
    "Primary supply temperature (measured)"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-100,60})));
  Fluid.Sensors.TemperatureTwoPort senT1_2Ret(
    redeclare final package Medium=Medium,
    m_flow_nominal=m_flow_nominal)
    "Primary return temperature (measured)"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={-100,20})));
  Fluid.Sensors.TemperatureTwoPort senT2_3Ret(
    redeclare final package Medium=Medium,
    m_flow_nominal=m_flow_nominal)
    "Secondary return temperature (measured)"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={60,20})));
  Fluid.Sensors.MassFlowRate senMasFlo1_2(
    redeclare final package Medium=Medium)
    "Primary mass flow rate (measured)"
    annotation (Placement(transformation(extent={{-140,50},{-120,70}})));
  Fluid.Sensors.MassFlowRate senMasFlo2_3(
    redeclare final package Medium=Medium)
    "Secondary mass flow rate (measured)"
    annotation (Placement(transformation(extent={{130,50},{150,70}})));
  Fluid.MixingVolumes.MixingVolume vol2_2(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=273.15+30,
    final prescribedHeatFlowRate=true,
    redeclare final package Medium=Medium,
    V=1,
    final mSenFac=1,
    final m_flow_nominal=m_flow_nominal,
    nPorts=2)
    "Volume for fluid stream"
    annotation (Placement(transformation(extent={{209,20},{229,0}})));
  Fluid.HeatExchangers.HeaterCooler_u coo2(
    redeclare final package Medium=Medium,
    dp_nominal=1,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=-1E5)
    "Heat exchange with water stream"
    annotation (Placement(transformation(extent={{100,10},{80,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant T2_1Ret1(
    k=30+273.15)
    "First secondary return temperature"
    annotation (Placement(transformation(extent={{60,90},{80,110}})));
  Buildings.Controls.OBC.CDL.Reals.PID conTChiWat3(
    k=0.1,
    Ti=10,
    yMax=1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    yMin=0,
    reverseActing=false)
    "PI controller for chilled water supply"
    annotation (Placement(transformation(extent={{90,90},{110,110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp m2_3(
    height=0.5,
    duration=1000,
    offset=0.5,
    startTime=2000)
    "First secondary flow signal"
    annotation (Placement(transformation(extent={{220,90},{200,110}})));
  Fluid.Sensors.TemperatureTwoPort senT2_4Sup(
    redeclare final package Medium=Medium,
    m_flow_nominal=m_flow_nominal)
    "Secondary supply temperature (measured)"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={60,-80})));
  Fluid.Sensors.TemperatureTwoPort senT2_4Ret(
    redeclare final package Medium=Medium,
    m_flow_nominal=m_flow_nominal)
    "Secondary return temperature (measured)"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={60,-120})));
  Fluid.Sensors.MassFlowRate senMasFlo2_4(
    redeclare final package Medium=Medium)
    "Secondary mass flow rate (measured)"
    annotation (Placement(transformation(extent={{130,-90},{150,-70}})));
  Fluid.MixingVolumes.MixingVolume vol1(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=273.15+30,
    final prescribedHeatFlowRate=true,
    redeclare final package Medium=Medium,
    V=1,
    final mSenFac=1,
    final m_flow_nominal=m_flow_nominal,
    nPorts=2)
    "Volume for fluid stream"
    annotation (Placement(transformation(extent={{209,-120},{229,-140}})));
  Fluid.HeatExchangers.HeaterCooler_u coo3(
    redeclare final package Medium=Medium,
    dp_nominal=1,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=-1E5)
    "Heat exchange with water stream"
    annotation (Placement(transformation(extent={{100,-130},{80,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant T2_2Ret1(
    k=35+273.15)
    "Second secondary return temperature"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  Buildings.Controls.OBC.CDL.Reals.PID conTChiWat4(
    k=0.1,
    Ti=10,
    yMax=1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    yMin=0,
    reverseActing=false)
    "PI controller for chilled water supply"
    annotation (Placement(transformation(extent={{90,-50},{110,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant m2_4(
    k=0.5)
    "Second secondary mass flow rate signal"
    annotation (Placement(transformation(extent={{220,-50},{200,-30}})));
  Buildings.DHC.EnergyTransferStations.BaseClasses.CollectorDistributor colDis1(
    redeclare final package Medium=Medium,
    mCon_flow_nominal=fill(
      m_flow_nominal,
      2),
    nCon=2)
    "Collector/distributor"
    annotation (Placement(transformation(extent={{-60,30},{-20,50}})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage val2_1(
    redeclare package Medium=Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=3000,
    dpFixed_nominal=7000)
    "Secondary control valve"
    annotation (Placement(transformation(extent={{190,10},{170,30}})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage val2_2(
    redeclare package Medium=Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=3000,
    dpFixed_nominal=7000)
    "Secondary control valve"
    annotation (Placement(transformation(extent={{190,-130},{170,-110}})));
  Fluid.Movers.FlowControlled_m_flow sou2_3(
    redeclare package Medium=Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    T_start=273.15+30,
    m_flow_nominal=m_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true)
    "Secondary pump"
    annotation (Placement(transformation(extent={{190,-270},{170,-250}})));
  Fluid.Sources.Boundary_pT bou3(
    redeclare package Medium=Medium,
    use_T_in=true,
    nPorts=2)
    "Boundary pressure"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-190,-240})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant T3(
    k=40+273.15)
    "Primary supply temperature"
    annotation (Placement(transformation(extent={{-240,-290},{-220,-270}})));
  Fluid.Sensors.TemperatureTwoPort senT2_5Sup(
    redeclare final package Medium=Medium,
    m_flow_nominal=m_flow_nominal)
    "Secondary supply temperature (measured)"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={60,-220})));
  Fluid.Sensors.TemperatureTwoPort senT1_3Sup(
    redeclare final package Medium=Medium,
    m_flow_nominal=m_flow_nominal)
    "Primary supply temperature (measured)"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-100,-220})));
  Fluid.Sensors.TemperatureTwoPort senT1_3Ret(
    redeclare final package Medium=Medium,
    m_flow_nominal=m_flow_nominal)
    "Primary return temperature (measured)"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={-100,-260})));
  Fluid.Sensors.TemperatureTwoPort senT2_5Ret(
    redeclare final package Medium=Medium,
    m_flow_nominal=m_flow_nominal)
    "Secondary return temperature (measured)"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={60,-260})));
  Fluid.Sensors.MassFlowRate senMasFlo1_3(
    redeclare final package Medium=Medium)
    "Primary mass flow rate (measured)"
    annotation (Placement(transformation(extent={{-140,-230},{-120,-210}})));
  Fluid.Sensors.MassFlowRate senMasFlo2_5(
    redeclare final package Medium=Medium)
    "Secondary mass flow rate (measured)"
    annotation (Placement(transformation(extent={{130,-230},{150,-210}})));
  Fluid.MixingVolumes.MixingVolume vol2_3(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=273.15+30,
    final prescribedHeatFlowRate=true,
    redeclare final package Medium=Medium,
    V=1,
    final mSenFac=1,
    final m_flow_nominal=m_flow_nominal,
    nPorts=2)
    "Volume for fluid stream"
    annotation (Placement(transformation(extent={{209,-260},{229,-280}})));
  Fluid.HeatExchangers.HeaterCooler_u coo4(
    redeclare final package Medium=Medium,
    dp_nominal=1,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=-1E5)
    "Heat exchange with water stream"
    annotation (Placement(transformation(extent={{100,-270},{80,-250}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant T2_1Ret2(
    k=30+273.15)
    "First secondary return temperature"
    annotation (Placement(transformation(extent={{60,-190},{80,-170}})));
  Buildings.Controls.OBC.CDL.Reals.PID conTChiWat5(
    k=0.1,
    Ti=10,
    yMax=1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    yMin=0,
    reverseActing=false)
    "PI controller for chilled water supply"
    annotation (Placement(transformation(extent={{90,-190},{110,-170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp m2_5(
    height=0.5,
    duration=1000,
    offset=0.5,
    startTime=2000)
    "First secondary flow signal"
    annotation (Placement(transformation(extent={{220,-190},{200,-170}})));
  Fluid.Movers.FlowControlled_m_flow sou2_4(
    redeclare package Medium=Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    T_start=273.15+30,
    m_flow_nominal=m_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true)
    "Secondary pump"
    annotation (Placement(transformation(extent={{190,-410},{170,-390}})));
  Fluid.Sensors.TemperatureTwoPort senT2_6Sup(
    redeclare final package Medium=Medium,
    m_flow_nominal=m_flow_nominal)
    "Secondary supply temperature (measured)"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={60,-360})));
  Fluid.Sensors.TemperatureTwoPort senT2_6Ret(
    redeclare final package Medium=Medium,
    m_flow_nominal=m_flow_nominal)
    "Secondary return temperature (measured)"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={60,-400})));
  Fluid.Sensors.MassFlowRate senMasFlo2_6(
    redeclare final package Medium=Medium)
    "Secondary mass flow rate (measured)"
    annotation (Placement(transformation(extent={{130,-370},{150,-350}})));
  Fluid.MixingVolumes.MixingVolume vol3(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=273.15+30,
    final prescribedHeatFlowRate=true,
    redeclare final package Medium=Medium,
    V=1,
    final mSenFac=1,
    final m_flow_nominal=m_flow_nominal,
    nPorts=2)
    "Volume for fluid stream"
    annotation (Placement(transformation(extent={{209,-400},{229,-420}})));
  Fluid.HeatExchangers.HeaterCooler_u coo5(
    redeclare final package Medium=Medium,
    dp_nominal=1,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=-1E5)
    "Heat exchange with water stream"
    annotation (Placement(transformation(extent={{100,-410},{80,-390}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant T2_2Ret2(
    k=35+273.15)
    "Second secondary return temperature"
    annotation (Placement(transformation(extent={{60,-330},{80,-310}})));
  Buildings.Controls.OBC.CDL.Reals.PID conTChiWat6(
    k=0.1,
    Ti=10,
    yMax=1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    yMin=0,
    reverseActing=false)
    "PI controller for chilled water supply"
    annotation (Placement(transformation(extent={{90,-330},{110,-310}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant m2_6(
    k=0.5)
    "Second secondary mass flow rate signal"
    annotation (Placement(transformation(extent={{220,-330},{200,-310}})));
  Buildings.DHC.EnergyTransferStations.BaseClasses.CollectorDistributor colDis2(
    redeclare final package Medium=Medium,
    mCon_flow_nominal=fill(
      m_flow_nominal,
      2),
    nCon=2)
    "Collector/distributor"
    annotation (Placement(transformation(extent={{-60,-250},{-20,-230}})));
equation
  connect(m1.y,sou1.m_flow_in)
    annotation (Line(points={{-218,380},{-160,380},{-160,352}},color={0,0,127}));
  connect(senMasFlo1_1.port_b,senT1_1Sup.port_a)
    annotation (Line(points={{-120,340},{-110,340}},color={0,127,255}));
  connect(senT2_1Sup.port_b,senMasFlo2_1.port_a)
    annotation (Line(points={{70,340},{130,340}},color={0,127,255}));
  connect(sou1.port_b,senMasFlo1_1.port_a)
    annotation (Line(points={{-150,340},{-140,340}},color={0,127,255}));
  connect(coo.port_b,senT2_1Ret.port_a)
    annotation (Line(points={{80,300},{70,300}},color={0,127,255}));
  connect(T2_1Ret.y,conTChiWat1.u_s)
    annotation (Line(points={{82,380},{74,380},{74,384},{76,384},{76,380},{88,380}},color={0,0,127}));
  connect(conTChiWat1.y,coo.u)
    annotation (Line(points={{112,380},{120,380},{120,306},{102,306}},color={0,0,127}));
  connect(senT2_1Ret.T,conTChiWat1.u_m)
    annotation (Line(points={{60,311},{60,320},{100,320},{100,368}},color={0,0,127}));
  connect(vol2_1.ports[1],sou2_1.port_a)
    annotation (Line(points={{217,300},{190,300}},color={0,127,255}));
  connect(senMasFlo2_1.port_b,vol2_1.ports[2])
    annotation (Line(points={{150,340},{221,340},{221,300}},color={0,127,255}));
  connect(m2_1.y,sou2_1.m_flow_in)
    annotation (Line(points={{198,380},{180,380},{180,312}},color={0,0,127}));
  connect(bou1.ports[1],sou1.port_a)
    annotation (Line(points={{-180,322},{-180,340},{-170,340}},color={0,127,255}));
  connect(T1.y,bou1.T_in)
    annotation (Line(points={{-218,280},{-212,280},{-212,324},{-202,324}},color={0,0,127}));
  connect(senT2_2Sup.port_b,senMasFlo2_2.port_a)
    annotation (Line(points={{70,200},{130,200}},color={0,127,255}));
  connect(coo1.port_b,senT2_2Ret.port_a)
    annotation (Line(points={{80,160},{70,160}},color={0,127,255}));
  connect(T2_2Ret.y,conTChiWat2.u_s)
    annotation (Line(points={{82,240},{78,240},{78,244},{80,244},{80,240},{88,240}},color={0,0,127}));
  connect(conTChiWat2.y,coo1.u)
    annotation (Line(points={{112,240},{120,240},{120,166},{102,166}},color={0,0,127}));
  connect(senT2_2Ret.T,conTChiWat2.u_m)
    annotation (Line(points={{60,171},{60,180},{100,180},{100,228}},color={0,0,127}));
  connect(vol2.ports[1],sou2_2.port_a)
    annotation (Line(points={{217,160},{190,160}},color={0,127,255}));
  connect(senMasFlo2_2.port_b,vol2.ports[2])
    annotation (Line(points={{150,200},{221,200},{221,160}},color={0,127,255}));
  connect(sou2_2.port_b,coo1.port_a)
    annotation (Line(points={{170,160},{100,160}},color={0,127,255}));
  connect(senT1_1Ret.port_b,bou1.ports[2])
    annotation (Line(points={{-110,300},{-180,300},{-180,318}},color={0,127,255}));
  connect(sou2_1.port_b,coo.port_a)
    annotation (Line(points={{170,300},{100,300}},color={0,127,255}));
  connect(m2_2.y,sou2_2.m_flow_in)
    annotation (Line(points={{198,240},{180,240},{180,172}},color={0,0,127}));
  connect(senT1_1Sup.port_b,colDis.port_aDisSup)
    annotation (Line(points={{-90,340},{-80,340},{-80,320},{-60,320}},color={0,127,255}));
  connect(senT1_1Ret.port_a,colDis.port_bDisRet)
    annotation (Line(points={{-90,300},{-80,300},{-80,314},{-60,314}},color={0,127,255}));
  connect(colDis.ports_bCon[1],senT2_1Sup.port_a)
    annotation (Line(points={{-48,330},{-40,330},{-40,360},{44,360},{44,340},{50,340}},color={0,127,255}));
  connect(colDis.ports_bCon[2],senT2_2Sup.port_a)
    annotation (Line(points={{-56,330},{-56,356},{40,356},{40,200},{50,200}},color={0,127,255}));
  connect(senT2_1Ret.port_b,colDis.ports_aCon[1])
    annotation (Line(points={{50,300},{24,300},{24,340},{-14,340},{-14,330},{-24,330}},color={0,127,255}));
  connect(senT2_2Ret.port_b,colDis.ports_aCon[2])
    annotation (Line(points={{50,160},{20,160},{20,336},{-32,336},{-32,330}},color={0,127,255}));
  connect(colDis.port_bDisSup,colDis.port_aDisRet)
    annotation (Line(points={{-20,320},{0,320},{0,314},{-20,314}},color={0,127,255}));
  connect(senMasFlo1_2.port_b,senT1_2Sup.port_a)
    annotation (Line(points={{-120,60},{-110,60}},color={0,127,255}));
  connect(senT2_3Sup.port_b,senMasFlo2_3.port_a)
    annotation (Line(points={{70,60},{130,60}},color={0,127,255}));
  connect(sou2.port_b,senMasFlo1_2.port_a)
    annotation (Line(points={{-150,60},{-140,60}},color={0,127,255}));
  connect(coo2.port_b,senT2_3Ret.port_a)
    annotation (Line(points={{80,20},{70,20}},color={0,127,255}));
  connect(T2_1Ret1.y,conTChiWat3.u_s)
    annotation (Line(points={{82,100},{74,100},{74,104},{76,104},{76,100},{88,100}},color={0,0,127}));
  connect(conTChiWat3.y,coo2.u)
    annotation (Line(points={{112,100},{120,100},{120,26},{102,26}},color={0,0,127}));
  connect(senT2_3Ret.T,conTChiWat3.u_m)
    annotation (Line(points={{60,31},{60,40},{100,40},{100,88}},color={0,0,127}));
  connect(senMasFlo2_3.port_b,vol2_2.ports[1])
    annotation (Line(points={{150,60},{217,60},{217,20}},color={0,127,255}));
  connect(bou2.ports[1],sou2.port_a)
    annotation (Line(points={{-180,42},{-180,60},{-170,60}},color={0,127,255}));
  connect(T2.y,bou2.T_in)
    annotation (Line(points={{-218,0},{-212,0},{-212,44},{-202,44}},color={0,0,127}));
  connect(senT2_4Sup.port_b,senMasFlo2_4.port_a)
    annotation (Line(points={{70,-80},{130,-80}},color={0,127,255}));
  connect(coo3.port_b,senT2_4Ret.port_a)
    annotation (Line(points={{80,-120},{70,-120}},color={0,127,255}));
  connect(T2_2Ret1.y,conTChiWat4.u_s)
    annotation (Line(points={{82,-40},{78,-40},{78,-36},{80,-36},{80,-40},{88,-40}},color={0,0,127}));
  connect(conTChiWat4.y,coo3.u)
    annotation (Line(points={{112,-40},{120,-40},{120,-114},{102,-114}},color={0,0,127}));
  connect(senT2_4Ret.T,conTChiWat4.u_m)
    annotation (Line(points={{60,-109},{60,-100},{100,-100},{100,-52}},color={0,0,127}));
  connect(senMasFlo2_4.port_b,vol1.ports[1])
    annotation (Line(points={{150,-80},{217,-80},{217,-120}},color={0,127,255}));
  connect(senT1_2Ret.port_b,bou2.ports[2])
    annotation (Line(points={{-110,20},{-180,20},{-180,38}},color={0,127,255}));
  connect(senT1_2Sup.port_b,colDis1.port_aDisSup)
    annotation (Line(points={{-90,60},{-80,60},{-80,40},{-60,40}},color={0,127,255}));
  connect(senT1_2Ret.port_a,colDis1.port_bDisRet)
    annotation (Line(points={{-90,20},{-80,20},{-80,34},{-60,34}},color={0,127,255}));
  connect(colDis1.ports_bCon[1],senT2_3Sup.port_a)
    annotation (Line(points={{-48,50},{-40,50},{-40,80},{44,80},{44,60},{50,60}},color={0,127,255}));
  connect(colDis1.ports_bCon[2],senT2_4Sup.port_a)
    annotation (Line(points={{-56,50},{-56,76},{40,76},{40,-80},{50,-80}},color={0,127,255}));
  connect(senT2_3Ret.port_b,colDis1.ports_aCon[1])
    annotation (Line(points={{50,20},{24,20},{24,60},{-14,60},{-14,50},{-24,50}},color={0,127,255}));
  connect(senT2_4Ret.port_b,colDis1.ports_aCon[2])
    annotation (Line(points={{50,-120},{20,-120},{20,56},{-32,56},{-32,50}},color={0,127,255}));
  connect(vol2_2.ports[2],val2_1.port_a)
    annotation (Line(points={{221,20},{190,20}},color={0,127,255}));
  connect(val2_1.port_b,coo2.port_a)
    annotation (Line(points={{170,20},{100,20}},color={0,127,255}));
  connect(m2_3.y,val2_1.y)
    annotation (Line(points={{198,100},{180,100},{180,32}},color={0,0,127}));
  connect(vol1.ports[2],val2_2.port_a)
    annotation (Line(points={{221,-120},{190,-120}},color={0,127,255}));
  connect(val2_2.port_b,coo3.port_a)
    annotation (Line(points={{170,-120},{100,-120}},color={0,127,255}));
  connect(m2_4.y,val2_2.y)
    annotation (Line(points={{198,-40},{180,-40},{180,-108}},color={0,0,127}));
  connect(senMasFlo1_3.port_b,senT1_3Sup.port_a)
    annotation (Line(points={{-120,-220},{-110,-220}},color={0,127,255}));
  connect(senT2_5Sup.port_b,senMasFlo2_5.port_a)
    annotation (Line(points={{70,-220},{130,-220}},color={0,127,255}));
  connect(coo4.port_b,senT2_5Ret.port_a)
    annotation (Line(points={{80,-260},{70,-260}},color={0,127,255}));
  connect(T2_1Ret2.y,conTChiWat5.u_s)
    annotation (Line(points={{82,-180},{74,-180},{74,-176},{76,-176},{76,-180},{88,-180}},color={0,0,127}));
  connect(conTChiWat5.y,coo4.u)
    annotation (Line(points={{112,-180},{120,-180},{120,-254},{102,-254}},color={0,0,127}));
  connect(senT2_5Ret.T,conTChiWat5.u_m)
    annotation (Line(points={{60,-249},{60,-240},{100,-240},{100,-192}},color={0,0,127}));
  connect(vol2_3.ports[1],sou2_3.port_a)
    annotation (Line(points={{217,-260},{190,-260}},color={0,127,255}));
  connect(senMasFlo2_5.port_b,vol2_3.ports[2])
    annotation (Line(points={{150,-220},{221,-220},{221,-260}},color={0,127,255}));
  connect(m2_5.y,sou2_3.m_flow_in)
    annotation (Line(points={{198,-180},{180,-180},{180,-248}},color={0,0,127}));
  connect(T3.y,bou3.T_in)
    annotation (Line(points={{-218,-280},{-212,-280},{-212,-236},{-202,-236}},color={0,0,127}));
  connect(senT2_6Sup.port_b,senMasFlo2_6.port_a)
    annotation (Line(points={{70,-360},{130,-360}},color={0,127,255}));
  connect(coo5.port_b,senT2_6Ret.port_a)
    annotation (Line(points={{80,-400},{70,-400}},color={0,127,255}));
  connect(T2_2Ret2.y,conTChiWat6.u_s)
    annotation (Line(points={{82,-320},{78,-320},{78,-316},{80,-316},{80,-320},{88,-320}},color={0,0,127}));
  connect(conTChiWat6.y,coo5.u)
    annotation (Line(points={{112,-320},{120,-320},{120,-394},{102,-394}},color={0,0,127}));
  connect(senT2_6Ret.T,conTChiWat6.u_m)
    annotation (Line(points={{60,-389},{60,-380},{100,-380},{100,-332}},color={0,0,127}));
  connect(vol3.ports[1],sou2_4.port_a)
    annotation (Line(points={{217,-400},{190,-400}},color={0,127,255}));
  connect(senMasFlo2_6.port_b,vol3.ports[2])
    annotation (Line(points={{150,-360},{221,-360},{221,-400}},color={0,127,255}));
  connect(sou2_4.port_b,coo5.port_a)
    annotation (Line(points={{170,-400},{100,-400}},color={0,127,255}));
  connect(sou2_3.port_b,coo4.port_a)
    annotation (Line(points={{170,-260},{100,-260}},color={0,127,255}));
  connect(m2_6.y,sou2_4.m_flow_in)
    annotation (Line(points={{198,-320},{180,-320},{180,-388}},color={0,0,127}));
  connect(colDis2.ports_bCon[1],senT2_5Sup.port_a)
    annotation (Line(points={{-48,-230},{-40,-230},{-40,-200},{44,-200},{44,-220},{50,-220}},color={0,127,255}));
  connect(colDis2.ports_bCon[2],senT2_6Sup.port_a)
    annotation (Line(points={{-56,-230},{-56,-204},{40,-204},{40,-360},{50,-360}},color={0,127,255}));
  connect(senT2_5Ret.port_b,colDis2.ports_aCon[1])
    annotation (Line(points={{50,-260},{24,-260},{24,-220},{-14,-220},{-14,-230},{-24,-230}},color={0,127,255}));
  connect(senT2_6Ret.port_b,colDis2.ports_aCon[2])
    annotation (Line(points={{50,-400},{20,-400},{20,-224},{-32,-224},{-32,-230}},color={0,127,255}));
  connect(bou3.ports[1],senMasFlo1_3.port_a)
    annotation (Line(points={{-180,-238},{-180,-220},{-140,-220}},color={0,127,255}));
  connect(senT1_3Sup.port_b,colDis2.port_aDisSup)
    annotation (Line(points={{-90,-220},{-80,-220},{-80,-240},{-60,-240}},color={0,127,255}));
  connect(senT1_3Ret.port_a,colDis2.port_bDisRet)
    annotation (Line(points={{-90,-260},{-80,-260},{-80,-246},{-60,-246}},color={0,127,255}));
  connect(m1.y,sou2.m_flow_in)
    annotation (Line(points={{-218,380},{-140,380},{-140,80},{-160,80},{-160,72}},color={0,0,127}));
  connect(bou3.ports[2],senT1_3Ret.port_b)
    annotation (Line(points={{-180,-242},{-180,-260},{-110,-260}},color={0,127,255}));
  annotation (
    Documentation(
      info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.DHC.EnergyTransferStations.BaseClasses.CollectorDistributor\">
Buildings.DHC.EnergyTransferStations.BaseClasses.CollectorDistributor</a>
in a configuration where the model is used to connect
</p>
<ol>
<li>
an active primary circuit which mass flow rate varies from 0 to 1.1 times
<code>m_flow_nominal</code> and two active secondary circuits,
one with a mass flow rate varying from 0.5 to 1 times
<code>m_flow_nominal</code>,
another with a constant mass flow rate, equal to 0.5 times
<code>m_flow_nominal</code>: this case illustrates a typical supply-through
loop and the supply temperature drop in one secondary circuit resulting
from flow recirculation when the sum of the secondary mass flow rates
exceeds the primary mass flow rate;
</li>
<li>
an active primary circuit which mass flow rate varies from 0 to 1.1 times
<code>m_flow_nominal</code> (similar to the previous case) and
two passive secondary circuits, with no recirculation loop at the
end of the distribution line,
</li>
<li>
a passive primary circuit and two active secondary circuits,
both with a varying mass flow rate, with no recirculation loop at the
end of the distribution line.
</li>
</ol>
</html>",
      revisions="<html>
<ul>
<li>
November 15, 2022, by Michael Wetter:<br/>
Set pump head.
</li>
<li>
July 31, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-260,-440},{260,440}})),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/DHC/EnergyTransferStations/BaseClasses/Validation/CollectorDistributor.mos" "Simulate and plot"),
    experiment(
      StopTime=5000,
      Tolerance=1e-06));
end CollectorDistributor;
