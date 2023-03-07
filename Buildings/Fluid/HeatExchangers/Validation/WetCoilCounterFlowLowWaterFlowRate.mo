within Buildings.Fluid.HeatExchangers.Validation;
model WetCoilCounterFlowLowWaterFlowRate
  "Model that tests a heat exchanger with prescribed boundary conditions, in terms of properties of inlet water and inlet air"
  extends Modelica.Icons.Example;
  package Medium1 = Buildings.Media.Water
   "Medium model for water";
  package Medium2 = Buildings.Media.Air
   "Medium model for air";

  parameter Modelica.Units.SI.MassFlowRate mWat_flow_nominal=0.44732114
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal=0.65844
    "Nominal mass flow rate";

  Buildings.Fluid.HeatExchangers.WetCoilCounterFlow
    hex(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    m1_flow_nominal=mWat_flow_nominal,
    m2_flow_nominal=mAir_flow_nominal,
    dp2_nominal(displayUnit="Pa") = 200,
    dp1_nominal(displayUnit="Pa") = 3000,
    UA_nominal=mWat_flow_nominal*4200*10/30,
    show_T=true,
    nEle=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Cooling coil"
    annotation(Placement(transformation(extent={{10,-12},{30,8}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou_w(
    redeclare package Medium = Medium1,
    use_Xi_in=false,
    m_flow=1E-4*mWat_flow_nominal,
    use_T_in=false,
    T=282.15,
    nPorts=1,
    use_m_flow_in=true)
    "Source for water"
    annotation (Placement(transformation(extent={{-58,10},{-38,30}})));
  Buildings.Fluid.Sources.Boundary_pT sin_w(
    redeclare package Medium = Medium1,
    use_p_in=false,
    T=293.15,
    nPorts=1)
    "sink for water"
    annotation (Placement(transformation(extent={{90,10},{70,30}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou_a(
    use_Xi_in=false,
    X={0.0086,1 - 0.0086},
    m_flow=mAir_flow_nominal,
    use_T_in=false,
    T=285.15,
    nPorts=1,
    redeclare package Medium = Medium2,
    use_m_flow_in=false)
    "Source for air"
    annotation (Placement(transformation(extent={{90,-50},{70,-30}})));
  Buildings.Fluid.Sources.Boundary_pT sin_a(
    redeclare package Medium = Medium2,
    use_p_in=false,
    T=293.15,
    nPorts=1)
    "sink for air"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp ram(
    height=-mWat_flow_nominal,
    duration=1800,
    offset=mWat_flow_nominal,
    startTime=900)
    annotation (Placement(transformation(extent={{-92,18},{-72,38}})));
  Sensors.TemperatureTwoPort senTemWatIn(
    redeclare package Medium = Medium1,
    allowFlowReversal=false,
    m_flow_nominal=mWat_flow_nominal,
    tau=0) "Temperature sensor"
    annotation (Placement(transformation(extent={{-30,10},{-10,30}})));
  Sensors.TemperatureTwoPort senTemWatOut(
    redeclare package Medium = Medium1,
    allowFlowReversal=false,
    m_flow_nominal=mWat_flow_nominal,
    tau=0) "Temperature sensor"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Sensors.TemperatureTwoPort senTemAirIn(
    redeclare package Medium = Medium2,
    allowFlowReversal=false,
    m_flow_nominal=mAir_flow_nominal,
    tau=0) "Temperature sensor"
    annotation (Placement(transformation(extent={{60,-50},{40,-30}})));

  Sensors.TemperatureTwoPort senTemAirOut(
    redeclare package Medium = Medium2,
    allowFlowReversal=false,
    m_flow_nominal=mAir_flow_nominal,
    tau=0) "Temperature sensor"
    annotation (Placement(transformation(extent={{-10,-50},{-30,-30}})));
equation
  connect(sou_w.m_flow_in, ram.y)
    annotation (Line(points={{-60,28},{-70,28}}, color={0,0,127}));
  connect(sou_w.ports[1], senTemWatIn.port_a)
    annotation (Line(points={{-38,20},{-30,20}}, color={0,127,255}));
  connect(senTemWatIn.port_b, hex.port_a1)
    annotation (Line(points={{-10,20},{0,20},{0,4},{10,4}},
                                                         color={0,127,255}));
  connect(sin_w.ports[1], senTemWatOut.port_b)
    annotation (Line(points={{70,20},{60,20}}, color={0,127,255}));
  connect(senTemWatOut.port_a, hex.port_b1) annotation (Line(points={{40,20},{34,
          20},{34,4},{30,4}},    color={0,127,255}));
  connect(sou_a.ports[1], senTemAirIn.port_a)
    annotation (Line(points={{70,-40},{60,-40}}, color={0,127,255}));
  connect(senTemAirIn.port_b, hex.port_a2) annotation (Line(points={{40,-40},{34,
          -40},{34,-8},{30,-8}}, color={0,127,255}));
  connect(sin_a.ports[1], senTemAirOut.port_b)
    annotation (Line(points={{-40,-40},{-30,-40}}, color={0,127,255}));
  connect(senTemAirOut.port_a, hex.port_b2) annotation (Line(points={{-10,-40},{
          0,-40},{0,-8},{10,-8}}, color={0,127,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=5000,
      Tolerance=1e-6),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Validation/WetCoilCounterFlowLowWaterFlowRate.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This is a validation case in which the air flow rate is about a third of the design flow rate,
and the water mass flow rate is ramped to zero.
The validation verifies that the outlet temperatures approach the inlet temperature of the air.
</p>
</html>", revisions="<html>
<ul>
<li>
July 5, 2022, by Antoine Gautier:<br/>
Modify air source boundary condition so air enters coil at 99.5% relative humidity.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3065\">issue 3065</a>.
</li>
<li>
May 26, 2022, by Michael Wetter:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3027\">issue 3027</a>.
</li>
</ul>
</html>"));
end WetCoilCounterFlowLowWaterFlowRate;
