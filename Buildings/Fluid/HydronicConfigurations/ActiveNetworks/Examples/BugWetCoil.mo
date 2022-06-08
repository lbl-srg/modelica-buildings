within Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples;
model BugWetCoil
  extends Modelica.Icons.Example;
  replaceable package MediumAir = Buildings.Media.Air
    "Medium model for air";
  package MediumLiq = Buildings.Media.Water
    "Medium model for hot water";


  parameter Modelica.Units.SI.MassFlowRate mLiq_flow_nominal = 10
    "Liquid mass flow rate at design conditions";
  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal=6.8
    "Air mass flow rate at design conditions";
  parameter Modelica.Units.SI.Temperature TAirEnt_nominal=25.6 + 273.15
    "Air entering temperature at design conditions";
  parameter Modelica.Units.SI.MassFraction phiAirEnt_nominal = 0.5
    "Air entering relative humidity at design conditions";
  final parameter Modelica.Units.SI.MassFraction XAirEnt_nominal=
    Buildings.Utilities.Psychrometrics.Functions.X_pTphi(
      MediumAir.p_default, TAirEnt_nominal, phiAirEnt_nominal)
    "Air entering water mass fraction at design conditions (kg/kg air)";
  final parameter Modelica.Units.SI.MassFraction xAirEnt_nominal=
    XAirEnt_nominal / (1 - XAirEnt_nominal)
    "Air entering humidity ratio at design conditions (kg/kg dry air)";
  parameter Modelica.Units.SI.Temperature TLiqEnt_nominal=4.4 + 273.15
    "CHW entering temperature at design conditions";
  parameter Modelica.Units.SI.Temperature TLiqLvg_nominal=13.5 + 273.15
    "CHW leaving temperature at design conditions";
  final parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal=
    (TLiqEnt_nominal - TLiqLvg_nominal) * mLiq_flow_nominal * 4186
    "Coil capacity at design conditions"
    annotation(Evaluate=true);

  Sources.MassFlowSource_T ref4(
    redeclare final package Medium = MediumLiq,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1)
    "Pressure and temperature boundary condition"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-40,-80})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSupVal2(
    height=+2,
    duration=50,
    offset=TLiqEnt_nominal,
    startTime=50,
    y(final unit="K", displayUnit="degC")) "Supply temperature"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));
  Sources.Boundary_pT ref5(
    redeclare final package Medium = MediumLiq,
    nPorts=2)
    "Pressure and temperature boundary condition"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={100,-80})));
  Sensors.TemperatureTwoPort TSup2(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal,
    tau=0)
    "Supply temperature sensor"
    annotation (Placement(
        transformation(
        extent={{-10,-90},{10,-70}},
        rotation=0)));
  Sensors.TemperatureTwoPort TRet2(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal,
    tau=0)
    "Return temperature sensor"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={60,-80})));
  HeatExchangers.WetCoilCounterFlow cooCoi(
    redeclare final package Medium1 = MediumLiq,
    redeclare final package Medium2 = MediumAir,
    m1_flow_nominal=mLiq_flow_nominal,
    m2_flow_nominal=mAir_flow_nominal,
    dp1_nominal=0,
    dp2_nominal=0,
    UA_nominal=1.2*9000,
    nEle=10,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    tau_m=0)
    "Cooling coil discretized"
    annotation (Placement(transformation(extent={{20,-24},{40,-44}})));
  Sources.MassFlowSource_T souAir(
    redeclare final package Medium = MediumAir,
    final X={XAirEnt_nominal,1 - XAirEnt_nominal},
    final m_flow=mAir_flow_nominal,
    final T=TAirEnt_nominal,
    nPorts=1) "Source for entering air"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={100,-20})));
  Sensors.TemperatureTwoPort TAirSup(
    redeclare final package Medium = MediumAir,
    final m_flow_nominal=mAir_flow_nominal,
    tau=0)
    "Supply air temperature sensor"
    annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={0,-28})));
  Sources.Boundary_pT outAir(redeclare final package Medium = MediumAir, nPorts=2)
    "Pressure boundary condition at coil outlet"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-40,-16})));
  Buildings.Controls.OBC.CDL.Continuous.PID conPID(
    k=1,
    Ti=0.5,
    reverseActing=false)
           annotation (Placement(transformation(extent={{-130,-30},{-110,-10}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=11.66 + 273.15)
    annotation (Placement(transformation(extent={{-150,10},{-130,30}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter scaMas(k=
        mLiq_flow_nominal)
    "Scale mass flow"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Sources.MassFlowSource_T souAir1(
    redeclare final package Medium = MediumAir,
    final X={XAirEnt_nominal,1 - XAirEnt_nominal},
    final m_flow=mAir_flow_nominal,
    final T=TAirEnt_nominal,
    nPorts=1) "Source for entering air"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={100,80})));
  HeatExchangers.WetCoilEffectivenessNTU hexWetNtu(
    redeclare final package Medium1 = MediumLiq,
    redeclare final package Medium2 = MediumAir,
    m1_flow_nominal=mLiq_flow_nominal,
    m2_flow_nominal=mAir_flow_nominal,
    dp1_nominal=0,
    dp2_nominal=0,
    use_Q_flow_nominal=false,
    UA_nominal=cooCoi.UA_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Cooling coil discretized"
    annotation (Placement(transformation(extent={{20,76},{40,56}})));
  Sources.MassFlowSource_T ref1(
    redeclare final package Medium = MediumLiq,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1)
    "Pressure and temperature boundary condition"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-40,60})));
  Sensors.TemperatureTwoPort TAirSup1(
    redeclare final package Medium = MediumAir,
    final m_flow_nominal=mAir_flow_nominal,
    tau=0)
    "Supply air temperature sensor"
    annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={0,72})));
equation
  connect(TSupVal2.y,ref4. T_in) annotation (Line(points={{-118,-80},{-52,-80},{
          -52,-84}},       color={0,0,127}));
  connect(ref4.ports[1],TSup2. port_a)
    annotation (Line(points={{-30,-80},{-10,-80}}, color={0,127,255}));
  connect(ref5.ports[1],TRet2. port_b)
    annotation (Line(points={{90,-79},{80,-79},{80,-80},{70,-80}},
                                                 color={0,127,255}));
  connect(souAir.ports[1],cooCoi. port_a2)
    annotation (Line(points={{90,-20},{60,-20},{60,-28},{40,-28}},
                                                 color={0,127,255}));
  connect(cooCoi.port_b2,TAirSup. port_a)
    annotation (Line(points={{20,-28},{10,-28}}, color={0,127,255}));
  connect(TAirSup.port_b,outAir. ports[1]) annotation (Line(points={{-10,-28},{
          -20,-28},{-20,-17},{-30,-17}},
                                     color={0,127,255}));
  connect(realExpression1.y,conPID. u_s)
    annotation (Line(points={{-129,20},{-120,20},{-120,0},{-140,0},{-140,-20},{-132,
          -20}},                                    color={0,0,127}));
  connect(TAirSup.T,conPID. u_m) annotation (Line(points={{0,-39},{0,-50},{-120,
          -50},{-120,-32}},               color={0,0,127}));
  connect(conPID.y, scaMas.u) annotation (Line(points={{-108,-20},{-102,-20}},
                           color={0,0,127}));
  connect(scaMas.y, ref4.m_flow_in)
    annotation (Line(points={{-78,-20},{-70,-20},{-70,-88},{-52,-88}},
                                                             color={0,0,127}));
  connect(TSup2.port_b, cooCoi.port_a1)
    annotation (Line(points={{10,-80},{20,-80},{20,-40}}, color={0,127,255}));
  connect(cooCoi.port_b1, TRet2.port_a)
    annotation (Line(points={{40,-40},{40,-80},{50,-80}}, color={0,127,255}));
  connect(souAir1.ports[1], hexWetNtu.port_a2) annotation (Line(points={{90,80},
          {60,80},{60,72},{40,72}}, color={0,127,255}));
  connect(hexWetNtu.port_b1, ref5.ports[2]) annotation (Line(points={{40,60},{
          80,60},{80,-81},{90,-81}},
                                  color={0,127,255}));
  connect(ref1.ports[1], hexWetNtu.port_a1)
    annotation (Line(points={{-30,60},{20,60}}, color={0,127,255}));
  connect(scaMas.y, ref1.m_flow_in) annotation (Line(points={{-78,-20},{-70,-20},
          {-70,52},{-52,52}}, color={0,0,127}));
  connect(TSupVal2.y, ref1.T_in) annotation (Line(points={{-118,-80},{-64,-80},{
          -64,56},{-52,56}}, color={0,0,127}));
  connect(hexWetNtu.port_b2, TAirSup1.port_a)
    annotation (Line(points={{20,72},{10,72}}, color={0,127,255}));
  connect(TAirSup1.port_b, outAir.ports[2]) annotation (Line(points={{-10,72},{
          -20,72},{-20,-15},{-30,-15}}, color={0,127,255}));
  annotation (
  experiment(
    StopTime=100,
    Tolerance=1e-6),
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-160,-140},{160,140}})));
end BugWetCoil;
