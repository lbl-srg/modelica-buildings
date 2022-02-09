within Buildings.Fluid.HeatExchangers.Validation;
model WetCoilEffectivenessNTUCounterFlow
  "Model that validates the wet coil effectiveness-NTU model"
  extends Modelica.Icons.Example;

  package Medium_W = Buildings.Media.Water;
  package Medium_A = Buildings.Media.Air;

  constant Modelica.Units.SI.AbsolutePressure pAtm=101325
    "Atmospheric pressure";

  parameter Modelica.Units.SI.Temperature T_a1_nominal=
      Modelica.Units.Conversions.from_degF(42) "Inlet water temperature";
  parameter Modelica.Units.SI.Temperature T_a2_nominal=
      Modelica.Units.Conversions.from_degF(80) "Inlet air temperature";
  parameter Modelica.Units.SI.Temperature T_b1_nominal=273.15 + 11.0678
    "Outlet water temperature in fully wet conditions";
  parameter Modelica.Units.SI.Temperature T_b2_nominal=273.15 + 13.5805
    "Outlet air temperature in fully wet conditions";
  final parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal=m1_flow_nominal
      *4186*(T_a1_nominal - T_b1_nominal);
  parameter Real X_w_a2_nominal = 0.0173
    "Inlet water mass fraction in fully wet conditions";
  parameter Modelica.Units.SI.ThermalConductance UA_nominal=4748
    "Total thermal conductance at nominal flow, from textbook";
  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal=3.78
    "Nominal mass flow rate of water";
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal=2.646
    "Nominal mass flow rate of air";
  parameter Types.HeatExchangerConfiguration hexCon=
    Types.HeatExchangerConfiguration.CounterFlow
    "Heat exchanger configuration";
  Buildings.Fluid.Sources.Boundary_pT sinAir(
    redeclare package Medium = Medium_A,
    use_p_in=false,
    nPorts=3)
    "Air sink"
    annotation (Placement(transformation(extent={{-180,-72},{-160,-52}})));
  Sources.MassFlowSource_T souAir(
    redeclare package Medium = Medium_A,
    m_flow=m2_flow_nominal,
    T=T_a2_nominal,
    use_Xi_in=true,
    nPorts=1)
    "Air source"
    annotation (Placement(transformation(extent={{140,-70},{120,-50}})));
  Buildings.Fluid.Sources.Boundary_pT sinWat(
    redeclare package Medium = Medium_W,
    nPorts=3)
    "Sink for water"
    annotation (Placement(transformation(extent={{50,10},{30,30}})));
  Buildings.Utilities.Psychrometrics.ToTotalAir conversion
    annotation (Placement(transformation(extent={{190,-90},{170,-70}})));
  Sensors.RelativeHumidityTwoPort relHumIn(redeclare package Medium = Medium_A,
      m_flow_nominal=m2_flow_nominal) "Inlet relative humidity"
    annotation (Placement(transformation(extent={{40,-70},{20,-50}})));
  Sensors.TemperatureTwoPort TDryBulIn(redeclare package Medium = Medium_A,
      m_flow_nominal=m2_flow_nominal) "Inlet dry bulb temperature"
    annotation (Placement(transformation(extent={{70,-70},{50,-50}})));
  Modelica.Blocks.Sources.RealExpression pAir(y=pAtm) "Air pressure"
    annotation (Placement(transformation(extent={{140,-42},{120,-18}})));
  Buildings.Utilities.Psychrometrics.TWetBul_TDryBulXi wetBulIn(redeclare
      package Medium = Medium_A) "Computation of wet bulb temperature"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));
  Sensors.MassFractionTwoPort senMasFraIn(redeclare package Medium = Medium_A,
      m_flow_nominal=m2_flow_nominal) "Water mass fraction of entering air"
    annotation (Placement(transformation(extent={{110,-70},{90,-50}})));
  Sensors.MassFractionTwoPort senMasFraOut(redeclare package Medium = Medium_A,
      m_flow_nominal=m2_flow_nominal) "Water mass fraction of leaving air"
    annotation (Placement(transformation(extent={{-110,-10},{-130,10}})));
  Sensors.TemperatureTwoPort TDryBulOut(redeclare package Medium = Medium_A,
      m_flow_nominal=m2_flow_nominal) "Dry bulb temperature of leaving air"
    annotation (Placement(transformation(extent={{-50,-10},{-70,10}})));
  Buildings.Utilities.Psychrometrics.TWetBul_TDryBulXi wetBulOut(redeclare
      package Medium = Medium_A) "Computation of wet bulb temperature"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Modelica.Blocks.Sources.RealExpression pAir1(y=pAtm) "Air pressure"
    annotation (Placement(transformation(extent={{-100,-112},{-80,-88}})));
  Buildings.Fluid.HeatExchangers.WetCoilEffectivenessNTU hexWetNTU(
    redeclare package Medium1 = Medium_W,
    redeclare package Medium2 = Medium_A,
    UA_nominal=UA_nominal,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    dp2_nominal=0,
    dp1_nominal=0,
    configuration=hexCon,
    show_T=true) "Effectiveness-NTU coil model (parameterized with nominal UA)"
    annotation (Placement(transformation(extent={{-30,4},{-10,24}})));
  Sources.MassFlowSource_T souWat1(
    redeclare package Medium = Medium_W,
    m_flow=m1_flow_nominal,
    T=T_a1_nominal,
    nPorts=1)
    "Source for water"
    annotation (Placement(transformation(extent={{-180,10},{-160,30}})));
  WetCoilCounterFlow hexDis(
    redeclare package Medium1 = Medium_W,
    redeclare package Medium2 = Medium_A,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    dp2_nominal=0,
    allowFlowReversal1=false,
    allowFlowReversal2=false,
    dp1_nominal=0,
    UA_nominal=UA_nominal,
    show_T=true,
    nEle=30,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau1=0.1,
    tau2=0.1,
    tau_m=0.1)
    "Discretized coil model"
    annotation (Placement(transformation(extent={{-30,56},{-10,76}})));
  Sources.MassFlowSource_T souWat(
    redeclare package Medium = Medium_W,
    m_flow=m1_flow_nominal,
    T=T_a1_nominal,
    nPorts=1) "Source for water"
    annotation (Placement(transformation(extent={{-180,70},{-160,90}})));
  Sources.MassFlowSource_T souAir2(
    redeclare package Medium = Medium_A,
    m_flow=m2_flow_nominal,
    T=T_a2_nominal,
    use_Xi_in=true,
    nPorts=1)
    "Air source"
    annotation (Placement(transformation(extent={{140,30},{120,50}})));
  Sensors.MassFractionTwoPort senMasFraOut1(redeclare package Medium = Medium_A,
      m_flow_nominal=m2_flow_nominal) "Water mass fraction of leaving air"
    annotation (Placement(transformation(extent={{-110,50},{-130,70}})));
  Sensors.TemperatureTwoPort TDryBulOut1(redeclare package Medium = Medium_A,
      m_flow_nominal=m2_flow_nominal) "Dry bulb temperature of leaving air"
    annotation (Placement(transformation(extent={{-50,50},{-70,70}})));
  Sensors.RelativeHumidityTwoPort relHumOut_eps(redeclare package Medium =
        Medium_A, m_flow_nominal=m2_flow_nominal) "Outlet relative humidity"
    annotation (Placement(transformation(extent={{-80,-10},{-100,10}})));
  Sensors.RelativeHumidityTwoPort relHumOut_dis(redeclare package Medium =
        Medium_A, m_flow_nominal=m2_flow_nominal) "Outlet relative humidity"
    annotation (Placement(transformation(extent={{-80,50},{-100,70}})));
  Buildings.Fluid.HeatExchangers.WetCoilEffectivenessNTU hexWetNTU_TX(
    redeclare package Medium1 = Medium_W,
    redeclare package Medium2 = Medium_A,
    use_Q_flow_nominal=true,
    Q_flow_nominal=Q_flow_nominal,
    T_a2_nominal=T_a2_nominal,
    w_a2_nominal=X_w_a2_nominal/(1 - X_w_a2_nominal),
    T_a1_nominal=T_a1_nominal,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    dp2_nominal=0,
    dp1_nominal=0,
    configuration=hexCon,
    show_T=true)
    "Effectiveness-NTU coil model (parameterized with nominal T and X)"
    annotation (Placement(transformation(extent={{-30,-44},{-10,-24}})));
  Sources.MassFlowSource_T souAir1(
    redeclare package Medium = Medium_A,
    m_flow=m2_flow_nominal,
    T=T_a2_nominal,
    use_Xi_in=true,
    nPorts=1)
    "Air source"
    annotation (Placement(transformation(extent={{140,-110},{120,-90}})));
  Sources.MassFlowSource_T souWat2(
    redeclare package Medium = Medium_W,
    m_flow=m1_flow_nominal,
    T=T_a1_nominal,
    nPorts=1)
    "Source for water"
    annotation (Placement(transformation(extent={{-180,-30},{-160,-10}})));
  Modelica.Blocks.Sources.CombiTimeTable w_a2(table=[0,0.0035383; 1,0.01765],
      timeScale=1000)
                     "Absolute humidity of entering air"
    annotation (Placement(transformation(extent={{196,-34},{176,-14}})));
equation
  connect(pAir.y, wetBulIn.p) annotation (Line(points={{119,-30},{112,-30},{112,
          -8},{119,-8}},       color={0,0,127}));
  connect(pAir1.y, wetBulOut.p) annotation (Line(points={{-79,-100},{-50,-100},
          {-50,-88},{-41,-88}},
                              color={0,0,127}));
  connect(senMasFraOut.port_b, sinAir.ports[1])
    annotation (Line(points={{-130,0},{-140,0},{-140,-59.3333},{-160,-59.3333}},
                                                     color={0,127,255}));
  connect(TDryBulOut.T, wetBulOut.TDryBul)
    annotation (Line(points={{-60,11},{-60,14},{-44,14},{-44,-72},{-41,-72}},
                                                             color={0,0,127}));
  connect(senMasFraOut.X, wetBulOut.Xi[1]) annotation (Line(points={{-120,11},{
          -120,14},{-134,14},{-134,-80},{-41,-80}},   color={0,0,127}));
  connect(souAir.ports[1], senMasFraIn.port_a)
    annotation (Line(points={{120,-60},{110,-60}}, color={0,127,255}));
  connect(senMasFraIn.port_b, TDryBulIn.port_a)
    annotation (Line(points={{90,-60},{70,-60}}, color={0,127,255}));
  connect(senMasFraIn.X, wetBulIn.Xi[1])
    annotation (Line(points={{100,-49},{100,0},{119,0}},   color={0,0,127}));
  connect(TDryBulIn.T, wetBulIn.TDryBul)
    annotation (Line(points={{60,-49},{60,8},{119,8}}, color={0,0,127}));
  connect(TDryBulIn.port_b, relHumIn.port_a)
    annotation (Line(points={{50,-60},{40,-60}}, color={0,127,255}));
  connect(souWat1.ports[1], hexWetNTU.port_a1) annotation (Line(points={{-160,20},
          {-30,20}},                         color={0,127,255}));
  connect(hexWetNTU.port_b1, sinWat.ports[1]) annotation (Line(points={{-10,20},
          {16,20},{16,22.6667},{30,22.6667}},
                                  color={0,127,255}));
  connect(souWat.ports[1], hexDis.port_a1) annotation (Line(points={{-160,80},{-40,
          80},{-40,72},{-30,72}}, color={0,127,255}));
  connect(hexDis.port_b1, sinWat.ports[2]) annotation (Line(points={{-10,72},{20,
          72},{20,20},{30,20}},              color={0,127,255}));
  connect(souAir2.ports[1], hexDis.port_a2) annotation (Line(points={{120,40},{
          0,40},{0,60},{-10,60}},      color={0,127,255}));
  connect(hexWetNTU.port_b2, TDryBulOut.port_a) annotation (Line(points={{-30,8},
          {-40,8},{-40,0},{-50,0}},     color={0,127,255}));
  connect(hexWetNTU.port_a2, relHumIn.port_b) annotation (Line(points={{-10,8},
          {10,8},{10,-60},{20,-60}},
                                  color={0,127,255}));
  connect(hexDis.port_b2, TDryBulOut1.port_a)
    annotation (Line(points={{-30,60},{-50,60}}, color={0,127,255}));
  connect(senMasFraOut1.port_b, sinAir.ports[2]) annotation (Line(points={{-130,60},
          {-150,60},{-150,-62},{-160,-62}},             color={0,127,255}));
  connect(TDryBulOut.port_b, relHumOut_eps.port_a) annotation (Line(points={{
          -70,0},{-76,0},{-76,0},{-80,0}}, color={0,127,255}));
  connect(relHumOut_eps.port_b, senMasFraOut.port_a)
    annotation (Line(points={{-100,0},{-110,0}}, color={0,127,255}));
  connect(TDryBulOut1.port_b, relHumOut_dis.port_a)
    annotation (Line(points={{-70,60},{-80,60}}, color={0,127,255}));
  connect(relHumOut_dis.port_b, senMasFraOut1.port_a)
    annotation (Line(points={{-100,60},{-110,60}}, color={0,127,255}));
  connect(hexWetNTU_TX.port_b1, sinWat.ports[3]) annotation (Line(points={{-10,-28},
          {20,-28},{20,17.3333},{30,17.3333}}, color={0,127,255}));
  connect(souAir1.ports[1], hexWetNTU_TX.port_a2) annotation (Line(points={{120,
          -100},{0,-100},{0,-40},{-10,-40}}, color={0,127,255}));
  connect(sinAir.ports[3], hexWetNTU_TX.port_b2) annotation (Line(points={{-160,
          -64.6667},{-150,-64.6667},{-150,-64},{-138,-64},{-138,-40},{-30,-40}},
                                                           color={0,127,255}));
  connect(souWat2.ports[1], hexWetNTU_TX.port_a1) annotation (Line(points={{-160,
          -20},{-40,-20},{-40,-28},{-30,-28}}, color={0,127,255}));
  connect(w_a2.y[1], conversion.XiDry) annotation (Line(points={{175,-24},{172,
          -24},{172,-50},{196,-50},{196,-80},{191,-80}}, color={0,0,127}));
  connect(conversion.XiTotalAir, souAir.Xi_in[1]) annotation (Line(points={{169,
          -80},{158,-80},{158,-64},{142,-64}}, color={0,0,127}));
  connect(conversion.XiTotalAir, souAir1.Xi_in[1]) annotation (Line(points={{
          169,-80},{154,-80},{154,-104},{142,-104}}, color={0,0,127}));
  connect(conversion.XiTotalAir, souAir2.Xi_in[1]) annotation (Line(points={{
          169,-80},{158,-80},{158,36},{142,36}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true,
    extent={{-200,-120},{200,120}})),
    experiment(
      StopTime=1000,
      Tolerance=1e-06),
    __Dymola_Commands(
    file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Validation/WetCoilEffectivenessNTUCounterFlow.mos"
  "Simulate and plot"),
  Documentation(info="<html>
<p>
This model is similar to
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Validation.WetCoilEffectivenessNTU\">
Buildings.Fluid.HeatExchangers.Validation.WetCoilEffectivenessNTU</a>,
except that a discretized wet coil model is also simulated for comparison.
To provide an accurate reference, the latter model is configured with 30 elements.
Under steady-state modeling assumptions, this creates a large system of
non-linear equations. To alleviate this effect, dynamics are considered but
the simulation time is increased to 1000 s to reproduce quasi steady-state
conditions.
</p>
</html>", revisions="<html>
<ul>
<li>
April 19, 2017, by Michael Wetter:<br/>
Revised model to avoid mixing textual equations and connect statements.
</li>
<li>
March 17, 2017, by Michael O'Keefe:<br/>
First implementation.
</li>
</ul>
</html>"));
end WetCoilEffectivenessNTUCounterFlow;
