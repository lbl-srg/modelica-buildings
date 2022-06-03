within Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples;
model TestVariableSupply
  extends Modelica.Icons.Example;
  replaceable package MediumAir = Buildings.Media.Air
    "Medium model for air";
  package MediumLiq = Buildings.Media.Water
    "Medium model for hot water";
  parameter Modelica.Units.SI.Pressure p_min=200000
    "Circuit minimum pressure";

  BaseClasses.LoadTwoWayValveControl loa(
    redeclare final package MediumLiq=MediumLiq,
    k=10,
    Ti=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    annotation (Placement(transformation(extent={{20,68},{40,88}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant fraLoa(k=1)
    "Load modulating signal"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));
  Sources.Boundary_pT ref(
    redeclare final package Medium = MediumLiq,
    final p=p_min + 10*(loa.dpTer_nominal + loa.dpValve_nominal),
    use_T_in=true,
    nPorts=1)
    "Pressure and temperature boundary condition"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-30,78})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSupVal(
    height=-8,
    duration=50,
    offset=loa.TLiqEnt_nominal,
    startTime=50,
    y(final unit="K", displayUnit="degC")) "Supply temperature"
    annotation (Placement(transformation(extent={{-80,68},{-60,88}})));
  Sources.Boundary_pT ref1(
    redeclare final package Medium = MediumLiq,
    final p=p_min,
    nPorts=1)
    "Pressure and temperature boundary condition"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={80,78})));
  Sensors.TemperatureTwoPort TSup(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=loa.mLiq_flow_nominal,
    tau=0,
    T_start=loa.TLiqEnt_nominal)
    "Supply temperature sensor"
    annotation (Placement(
        transformation(
        extent={{-10,68},{10,88}},
        rotation=0)));
  Sensors.TemperatureTwoPort TRet(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=loa.mLiq_flow_nominal,
    tau=0,
    T_start=loa.TLiqLvg_nominal)
    "Return temperature sensor"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={54,78})));
  BaseClasses.LoadTwoWayValveControl loa1(
    redeclare final package MediumLiq = MediumLiq,
    mLiq_flow_nominal=2.46,
    mAir_flow_nominal=6.8,
    TAirEnt_nominal=298.75,
    phiAirEnt_nominal=0.4,
    TLiqEnt_nominal=277.55,
    TLiqLvg_nominal=286.65,
    k=10,
    Ti=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    annotation (Placement(transformation(extent={{20,8},{40,28}})));
  Sources.Boundary_pT ref2(
    redeclare final package Medium = MediumLiq,
    final p=p_min + 10*(loa1.dpTer_nominal + loa1.dpValve_nominal),
    use_T_in=true,
    nPorts=1)
    "Pressure and temperature boundary condition"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-30,18})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSupVal1(
    height=+4,
    duration=50,
    offset=loa1.TLiqEnt_nominal,
    startTime=50,
    y(final unit="K", displayUnit="degC")) "Supply temperature"
    annotation (Placement(transformation(extent={{-80,8},{-60,28}})));
  Sources.Boundary_pT ref3(
    redeclare final package Medium = MediumLiq,
    final p=p_min,
    nPorts=1)
    "Pressure and temperature boundary condition"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={80,18})));
  Sensors.TemperatureTwoPort TSup1(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=loa.mLiq_flow_nominal,
    tau=0,
    T_start=loa1.TLiqEnt_nominal)
    "Supply temperature sensor"
    annotation (Placement(
        transformation(
        extent={{-10,8},{10,28}},
        rotation=0)));
  Sensors.TemperatureTwoPort TRet1(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=loa.mLiq_flow_nominal,
    tau=0,
    T_start=loa1.TLiqLvg_nominal)
    "Return temperature sensor"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={54,18})));
  Sources.Boundary_pT ref4(
    redeclare final package Medium = MediumLiq,
    final p=p_min + 10*(con.dp2_nominal + con.dpValve_nominal),
    use_T_in=true,
    nPorts=1)
    "Pressure and temperature boundary condition"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-30,-100})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSupVal2(
    height=+4,
    duration=50,
    offset=4.44 + 273.15,
    startTime=50,
    y(final unit="K", displayUnit="degC")) "Supply temperature"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  Sources.Boundary_pT ref5(
    redeclare final package Medium = MediumLiq,
    final p=p_min,
    nPorts=1)
    "Pressure and temperature boundary condition"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={80,-100})));
  Sensors.TemperatureTwoPort TSup2(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=cooCoi.m1_flow_nominal,
    tau=0,
    T_start=(4.44 + 273.15) + 273.15)
    "Supply temperature sensor"
    annotation (Placement(
        transformation(
        extent={{-10,-110},{10,-90}},
        rotation=0)));
  Sensors.TemperatureTwoPort TRet2(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=cooCoi.m1_flow_nominal,
    tau=0,
    T_start=(4.44 + 273.15) + 273.15)
    "Return temperature sensor"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={54,-100})));
  HeatExchangers.WetCoilCounterFlow cooCoi(
    redeclare final package Medium1 = MediumLiq,
    redeclare final package Medium2 = MediumAir,
    m1_flow_nominal=2.46,
    m2_flow_nominal=6.8,
    dp1_nominal=0,
    dp2_nominal=0,
    UA_nominal=1.2 * 9000,
    nEle=20,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Cooling coil discretized"
    annotation (Placement(transformation(extent={{20,-48},{40,-68}})));
  Throttle con(m2_flow_nominal=cooCoi.m1_flow_nominal, dp2_nominal=3e4,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));
  Sources.MassFlowSource_T souAir(
    redeclare final package Medium = MediumAir,
    X={0.00825,1 - 0.00825},
    final m_flow=cooCoi.m2_flow_nominal,
    T=298.71,
    nPorts=1) "Source for entering air"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={80,-52})));
  Sensors.TemperatureTwoPort TAirSup(
    redeclare final package Medium = MediumAir,
    final m_flow_nominal=cooCoi.m2_flow_nominal,
    tau=0,
    T_start=284.81)
    "Supply air temperature sensor"
    annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={0,-52})));
  Sources.Boundary_pT outAir(
    redeclare final package Medium = MediumAir, nPorts=1)
    "Pressure boundary condition at coil outlet"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-40,-40})));
  Buildings.Controls.OBC.CDL.Continuous.PID conPID(
    k=1,
    Ti=1,
    reverseActing=false)
           annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=11.66 + 273.15)
    annotation (Placement(transformation(extent={{-130,-50},{-110,-30}})));
equation
  connect(fraLoa.y, loa.u) annotation (Line(points={{-58,120},{10,120},{10,84},{
          18,84}},
               color={0,0,127}));
  connect(TSupVal.y, ref.T_in) annotation (Line(points={{-58,78},{-52,78},{-52,74},
          {-42,74}}, color={0,0,127}));
  connect(ref.ports[1], TSup.port_a)
    annotation (Line(points={{-20,78},{-10,78}},
                                               color={0,127,255}));
  connect(TSup.port_b, loa.port_a)
    annotation (Line(points={{10,78},{20,78}},
                                             color={0,127,255}));
  connect(ref1.ports[1], TRet.port_b)
    annotation (Line(points={{70,78},{64,78}},
                                             color={0,127,255}));
  connect(TRet.port_a, loa.port_b)
    annotation (Line(points={{44,78},{40,78}},
                                             color={0,127,255}));
  connect(TSupVal1.y, ref2.T_in) annotation (Line(points={{-58,18},{-52,18},{-52,
          14},{-42,14}},   color={0,0,127}));
  connect(ref2.ports[1], TSup1.port_a)
    annotation (Line(points={{-20,18},{-10,18}},   color={0,127,255}));
  connect(TSup1.port_b, loa1.port_a)
    annotation (Line(points={{10,18},{20,18}},   color={0,127,255}));
  connect(ref3.ports[1], TRet1.port_b)
    annotation (Line(points={{70,18},{64,18}},   color={0,127,255}));
  connect(TRet1.port_a, loa1.port_b)
    annotation (Line(points={{44,18},{40,18}},   color={0,127,255}));
  connect(fraLoa.y, loa1.u) annotation (Line(points={{-58,120},{10,120},{10,24},
          {18,24}},  color={0,0,127}));

  connect(TSupVal2.y,ref4. T_in) annotation (Line(points={{-58,-100},{-52,-100},
          {-52,-104},{-42,-104}},
                           color={0,0,127}));
  connect(ref4.ports[1],TSup2. port_a)
    annotation (Line(points={{-20,-100},{-10,-100}},
                                                   color={0,127,255}));
  connect(ref5.ports[1],TRet2. port_b)
    annotation (Line(points={{70,-100},{64,-100}},
                                                 color={0,127,255}));
  connect(con.port_b2, cooCoi.port_a1) annotation (Line(points={{24,-80},{20,-80},
          {20,-64}}, color={0,127,255}));
  connect(con.port_a2, cooCoi.port_b1) annotation (Line(points={{36,-80.2},{40,-80.2},
          {40,-64}},         color={0,127,255}));
  connect(TSup2.port_b, con.port_a1)
    annotation (Line(points={{10,-100},{24,-100}}, color={0,127,255}));
  connect(con.port_b1, TRet2.port_a)
    annotation (Line(points={{36,-100},{44,-100}}, color={0,127,255}));
  connect(souAir.ports[1], cooCoi.port_a2)
    annotation (Line(points={{70,-52},{40,-52}}, color={0,127,255}));
  connect(cooCoi.port_b2, TAirSup.port_a)
    annotation (Line(points={{20,-52},{10,-52}}, color={0,127,255}));
  connect(TAirSup.port_b, outAir.ports[1]) annotation (Line(points={{-10,-52},{-20,
          -52},{-20,-40},{-30,-40}}, color={0,127,255}));
  connect(realExpression1.y, conPID.u_s)
    annotation (Line(points={{-109,-40},{-92,-40}}, color={0,0,127}));
  connect(conPID.y, con.yVal) annotation (Line(points={{-68,-40},{-60,-40},{-60,
          -80},{10,-80},{10,-90},{18,-90}},     color={0,0,127}));
  connect(TAirSup.T, conPID.u_m) annotation (Line(points={{0,-41},{0,-20},{-54,-20},
          {-54,-60},{-80,-60},{-80,-52}}, color={0,0,127}));
annotation(experiment(
    StopTime=100,
    Tolerance=1e-6),
    Diagram(coordinateSystem(extent={{-140,-140},{140,140}})));
end TestVariableSupply;
