within Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples;
model TestVariableSupply
  extends Modelica.Icons.Example;

  package MediumLiq = Buildings.Media.Water
    "Medium model for hot water";
  parameter Modelica.Units.SI.Pressure p_min=200000
    "Circuit minimum pressure";

  BaseClasses.LoadTwoWayValveControl loa(
    redeclare final package MediumLiq=MediumLiq,
    k=10,
    Ti=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant fraLoa(k=0.5)
    "Load modulating signal"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Sources.Boundary_pT ref(
    redeclare final package Medium = MediumLiq,
    final p=p_min + loa.dat.dp2_nominal + loa.dat.dpValve_nominal,
    use_T_in=true,
    nPorts=1)
    "Pressure and temperature boundary condition"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-30,0})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp      fraLoa1(
    height=-8,
    duration=100,
    offset=loa.TLiqEnt_nominal)          "Load modulating signal"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Sources.Boundary_pT ref1(
    redeclare final package Medium = MediumLiq,
    final p=p_min,
    nPorts=1)
    "Pressure and temperature boundary condition"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={80,0})));
  Sensors.TemperatureTwoPort TSup(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=loa.mLiq_flow_nominal,
    tau=0,
    T_start=loa.TLiqEnt_nominal)
    "Supply temperature sensor"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
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
        origin={54,0})));
  BaseClasses.LoadTwoWayValveControl loa1(
    redeclare final package MediumLiq = MediumLiq,
    TAirEnt_nominal=299.15,
    TLiqEnt_nominal=280.15,
    TLiqLvg_nominal=285.15,
    k=10,
    Ti=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Sources.Boundary_pT ref2(
    redeclare final package Medium = MediumLiq,
    final p=p_min + loa.dat.dp2_nominal + loa.dat.dpValve_nominal,
    use_T_in=true,
    nPorts=1)
    "Pressure and temperature boundary condition"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-30,-60})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp      fraLoa3(
    height=+3,
    duration=100,
    offset=loa1.TLiqEnt_nominal)         "Load modulating signal"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Sources.Boundary_pT ref3(
    redeclare final package Medium = MediumLiq,
    final p=p_min,
    nPorts=1)
    "Pressure and temperature boundary condition"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={80,-60})));
  Sensors.TemperatureTwoPort TSup1(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=loa.mLiq_flow_nominal,
    tau=0,
    T_start=loa1.TLiqEnt_nominal)
    "Supply temperature sensor"
    annotation (Placement(
        transformation(
        extent={{-10,-70},{10,-50}},
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
        origin={54,-60})));
equation
  connect(fraLoa.y, loa.u) annotation (Line(points={{-58,60},{10,60},{10,6},{18,
          6}}, color={0,0,127}));
  connect(fraLoa1.y, ref.T_in) annotation (Line(points={{-58,0},{-52,0},{-52,-4},
          {-42,-4}}, color={0,0,127}));
  connect(ref.ports[1], TSup.port_a)
    annotation (Line(points={{-20,0},{-10,0}}, color={0,127,255}));
  connect(TSup.port_b, loa.port_a)
    annotation (Line(points={{10,0},{20,0}}, color={0,127,255}));
  connect(ref1.ports[1], TRet.port_b)
    annotation (Line(points={{70,0},{64,0}}, color={0,127,255}));
  connect(TRet.port_a, loa.port_b)
    annotation (Line(points={{44,0},{40,0}}, color={0,127,255}));
  connect(fraLoa3.y, ref2.T_in) annotation (Line(points={{-58,-60},{-52,-60},{
          -52,-64},{-42,-64}}, color={0,0,127}));
  connect(ref2.ports[1], TSup1.port_a)
    annotation (Line(points={{-20,-60},{-10,-60}}, color={0,127,255}));
  connect(TSup1.port_b, loa1.port_a)
    annotation (Line(points={{10,-60},{20,-60}}, color={0,127,255}));
  connect(ref3.ports[1], TRet1.port_b)
    annotation (Line(points={{70,-60},{64,-60}}, color={0,127,255}));
  connect(TRet1.port_a, loa1.port_b)
    annotation (Line(points={{44,-60},{40,-60}}, color={0,127,255}));
  connect(fraLoa.y, loa1.u) annotation (Line(points={{-58,60},{10,60},{10,-54},
          {18,-54}}, color={0,0,127}));
end TestVariableSupply;
