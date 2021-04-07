within Buildings.Fluid.HeatExchangers.Validation;
model WetCoilEffectivenessNTUHeating
  "Model that validates the wet coil effectiveness-NTU model in heating conditions"
  extends Modelica.Icons.Example;

  package Medium_W = Buildings.Media.Water;
  package Medium_A = Buildings.Media.Air;

  constant Modelica.SIunits.AbsolutePressure pAtm = 101325
    "Atmospheric pressure";

  parameter Modelica.SIunits.Temperature T_a1_nominal=50+273.15
    "Inlet water temperature";

  parameter Modelica.SIunits.Temperature T_b1_nominal=45+273.15
    "Outlet water temperature";

  parameter Modelica.SIunits.Temperature T_a2_nominal=273.15
    "Inlet air temperature";

  final parameter Modelica.SIunits.Temperature T_b2_nominal=
    T_a2_nominal + Q_flow_nominal / m2_flow_nominal / 1010
    "Outlet air temperature";

  final parameter Modelica.SIunits.ThermalConductance CMin_flow_nominal=
    min(m1_flow_nominal * 4186, m2_flow_nominal * 1010)
    "Minimal capacity flow rate at nominal condition";

  final parameter Modelica.SIunits.ThermalConductance CMax_flow_nominal=
    max(m1_flow_nominal * 4186, m2_flow_nominal * 1010)
    "Minimal capacity flow rate at nominal condition";

  final parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal=
    m1_flow_nominal * 4186 * (T_a1_nominal - T_b1_nominal);

  final parameter Real eps_nominal=
    abs(Q_flow_nominal/((T_a1_nominal - T_a2_nominal) * CMin_flow_nominal))
    "Nominal effectiveness";

  parameter Modelica.SIunits.ThermalConductance UA_nominal=
    Buildings.Fluid.HeatExchangers.BaseClasses.ntu_epsilonZ(
      eps=eps_nominal,
      Z=CMin_flow_nominal/CMax_flow_nominal,
      flowRegime=Integer(hexCon)) * CMin_flow_nominal
    "Total thermal conductance at nominal flow";

  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal = 3.78
    "Nominal mass flow rate of water";
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal = 2.646
    "Nominal mass flow rate of air";
  parameter Types.HeatExchangerConfiguration hexCon=
    Types.HeatExchangerConfiguration.CounterFlow
    "Heat exchanger configuration";
  Buildings.Fluid.Sources.Boundary_pT sinAir(
    redeclare package Medium = Medium_A,
    use_p_in=false,
    nPorts=3)
    "Air sink"
    annotation (Placement(transformation(extent={{-180,-68},{-160,-48}})));
  Sources.MassFlowSource_T souAir(
    redeclare package Medium = Medium_A,
    m_flow=m2_flow_nominal,
    use_T_in=true,
    T=T_a2_nominal,
    nPorts=1)
    "Air source"
    annotation (Placement(transformation(extent={{140,-10},{120,10}})));
  Buildings.Fluid.Sources.Boundary_pT sinWat(
    redeclare package Medium = Medium_W,
    nPorts=3)
    "Sink for water"
    annotation (Placement(transformation(extent={{82,30},{62,50}})));
  Sensors.RelativeHumidityTwoPort relHumIn(redeclare package Medium = Medium_A,
      m_flow_nominal=m2_flow_nominal) "Inlet relative humidity"
    annotation (Placement(transformation(extent={{40,-10},{20,10}})));
  Sensors.TemperatureTwoPort TDryBulIn(redeclare package Medium = Medium_A,
      m_flow_nominal=m2_flow_nominal) "Inlet dry bulb temperature"
    annotation (Placement(transformation(extent={{70,-10},{50,10}})));
  Sensors.MassFractionTwoPort senMasFraIn(redeclare package Medium = Medium_A,
      m_flow_nominal=m2_flow_nominal) "Water mass fraction of entering air"
    annotation (Placement(transformation(extent={{110,-10},{90,10}})));
  Sensors.MassFractionTwoPort senMasFraOut(redeclare package Medium = Medium_A,
      m_flow_nominal=m2_flow_nominal) "Water mass fraction of leaving air"
    annotation (Placement(transformation(extent={{-110,-10},{-130,10}})));
  Sensors.TemperatureTwoPort TDryBulOut(redeclare package Medium = Medium_A,
      m_flow_nominal=m2_flow_nominal) "Dry bulb temperature of leaving air"
    annotation (Placement(transformation(extent={{-50,-10},{-70,10}})));
  Sources.MassFlowSource_T souWat1(
    redeclare package Medium = Medium_W,
    m_flow=m1_flow_nominal,
    T=T_a1_nominal,
    nPorts=1)
    "Source for water"
    annotation (Placement(transformation(extent={{-180,10},{-160,30}})));
  DryCoilCounterFlow hexDis(
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
    use_T_in=true,
    T=T_a2_nominal,
    nPorts=1)
    "Air source"
    annotation (Placement(transformation(extent={{140,50},{120,70}})));
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
  Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU hexDryNTU_T(
    redeclare package Medium1 = Medium_W,
    redeclare package Medium2 = Medium_A,
    Q_flow_nominal=Q_flow_nominal,
    T_a2_nominal=T_a2_nominal,
    T_a1_nominal=T_a1_nominal,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    dp2_nominal=0,
    dp1_nominal=0,
    configuration=hexCon,
    show_T=true)
    "Effectiveness-NTU coil model (parameterized with nominal T and X)"
    annotation (Placement(transformation(extent={{-30,-64},{-10,-44}})));
  Sources.MassFlowSource_T souAir1(
    redeclare package Medium = Medium_A,
    m_flow=m2_flow_nominal,
    use_T_in=true,
    T=T_a2_nominal,
    nPorts=1)
    "Air source"
    annotation (Placement(transformation(extent={{140,-70},{120,-50}})));
  Sources.MassFlowSource_T souWat2(
    redeclare package Medium = Medium_W,
    m_flow=m1_flow_nominal,
    T=T_a1_nominal,
    nPorts=1)
    "Source for water"
    annotation (Placement(transformation(extent={{-180,-30},{-160,-10}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp T_a2(
    height=15,
    duration=1000,
    offset=273.15) "Air inlet temperature"
    annotation (Placement(transformation(extent={{190,-10},{170,10}})));
  Buildings.Fluid.HeatExchangers.WetCoilEffectivenessNTU hexWetNTU_TX(
    redeclare package Medium1 = Medium_W,
    redeclare package Medium2 = Medium_A,
    use_Q_flow_nominal=true,
    Q_flow_nominal=Q_flow_nominal,
    T_a2_nominal=T_a2_nominal,
    w_a2_nominal=0.001,
    T_a1_nominal=T_a1_nominal,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    dp2_nominal=0,
    dp1_nominal=0,
    configuration=hexCon,
    show_T=true)
    "Effectiveness-NTU coil model (parameterized with nominal T and X)"
    annotation (Placement(transformation(extent={{-30,10},{-10,30}})));
equation
  connect(senMasFraOut.port_b, sinAir.ports[1])
    annotation (Line(points={{-130,0},{-140,0},{-140,-55.3333},{-160,-55.3333}},
                                                     color={0,127,255}));
  connect(souAir.ports[1], senMasFraIn.port_a)
    annotation (Line(points={{120,0},{110,0}},     color={0,127,255}));
  connect(senMasFraIn.port_b, TDryBulIn.port_a)
    annotation (Line(points={{90,0},{70,0}},     color={0,127,255}));
  connect(TDryBulIn.port_b, relHumIn.port_a)
    annotation (Line(points={{50,0},{40,0}},     color={0,127,255}));
  connect(souWat.ports[1], hexDis.port_a1) annotation (Line(points={{-160,80},{-40,
          80},{-40,72},{-30,72}}, color={0,127,255}));
  connect(hexDis.port_b1, sinWat.ports[1]) annotation (Line(points={{-10,72},{
          10,72},{10,42.6667},{62,42.6667}}, color={0,127,255}));
  connect(souAir2.ports[1], hexDis.port_a2) annotation (Line(points={{120,60},{
          -10,60}},                    color={0,127,255}));
  connect(hexDis.port_b2, TDryBulOut1.port_a)
    annotation (Line(points={{-30,60},{-50,60}}, color={0,127,255}));
  connect(senMasFraOut1.port_b, sinAir.ports[2]) annotation (Line(points={{-130,60},
          {-150,60},{-150,-58},{-160,-58}},             color={0,127,255}));
  connect(TDryBulOut.port_b, relHumOut_eps.port_a) annotation (Line(points={{
          -70,0},{-76,0},{-76,0},{-80,0}}, color={0,127,255}));
  connect(relHumOut_eps.port_b, senMasFraOut.port_a)
    annotation (Line(points={{-100,0},{-110,0}}, color={0,127,255}));
  connect(TDryBulOut1.port_b, relHumOut_dis.port_a)
    annotation (Line(points={{-70,60},{-80,60}}, color={0,127,255}));
  connect(relHumOut_dis.port_b, senMasFraOut1.port_a)
    annotation (Line(points={{-100,60},{-110,60}}, color={0,127,255}));
  connect(hexDryNTU_T.port_b1, sinWat.ports[2]) annotation (Line(points={{-10,-48},
          {10,-48},{10,40},{62,40}}, color={0,127,255}));
  connect(souAir1.ports[1], hexDryNTU_T.port_a2)
    annotation (Line(points={{120,-60},{-10,-60}}, color={0,127,255}));
  connect(sinAir.ports[3], hexDryNTU_T.port_b2) annotation (Line(points={{-160,
          -60.6667},{-138,-60.6667},{-138,-60},{-30,-60}},
                                                 color={0,127,255}));
  connect(souWat2.ports[1], hexDryNTU_T.port_a1) annotation (Line(points={{-160,
          -20},{-40,-20},{-40,-48},{-30,-48}}, color={0,127,255}));
  connect(T_a2.y, souAir2.T_in) annotation (Line(points={{168,0},{160,0},{160,
          64},{142,64}}, color={0,0,127}));
  connect(T_a2.y, souAir.T_in) annotation (Line(points={{168,0},{160,0},{160,4},
          {142,4}}, color={0,0,127}));
  connect(T_a2.y, souAir1.T_in) annotation (Line(points={{168,0},{160,0},{160,
          -56},{142,-56}}, color={0,0,127}));
  connect(souWat1.ports[1], hexWetNTU_TX.port_a1) annotation (Line(points={{-160,
          20},{-96,20},{-96,26},{-30,26}}, color={0,127,255}));
  connect(hexWetNTU_TX.port_b1, sinWat.ports[3]) annotation (Line(points={{-10,26},
          {10,26},{10,37.3333},{62,37.3333}}, color={0,127,255}));
  connect(relHumIn.port_b, hexWetNTU_TX.port_a2) annotation (Line(points={{20,0},{
          4,0},{4,14},{-10,14}},    color={0,127,255}));
  connect(hexWetNTU_TX.port_b2, TDryBulOut.port_a) annotation (Line(points={{-30,
          14},{-40,14},{-40,0},{-50,0}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true,
    extent={{-200,-120},{200,120}})),
    experiment(
      StopTime=1000,
      Tolerance=1e-06),
    __Dymola_Commands(
    file="Resources/Scripts/Dymola/Fluid/HeatExchangers/Validation/WetCoilEffectivenessNTUHeating.mos"
  "Simulate and plot"),
  Documentation(info="<html>
<p>
This model duplicates an example from Mitchell and Braun 2012, example SM-2-1
(Mitchell and Braun 2012) to validate a single case for the
<a href=\"modelica://Buildings.Fluid.HeatExchangers.WetCoilEffectivenessNTU\">
Buildings.Fluid.HeatExchangers.WetCoilEffectivenessNTU</a>
model.
</p>
<h4>Validation</h4>
<p>
The example simulates a wet coil with constant air
and water inlet temperature and mass flow rate, and an increasing air inlet
humidity which triggers the transition from a fully-dry to a fully-wet regime.
The reference used for validation is the published experimental data.
A discretized wet coil model is also simulated for comparison. 
To provide an accurate reference, the latter model is configured with 30 elements.
Under steady-state modeling assumptions, this creates a large system of 
non-linear equations. To alleviate this effect, dynamics are considered but
the simulation time is increased to 1000 s to reproduce quasi steady-state 
conditions.
</p>
<p>
Note that the outlet air relative humidity may slightly exceed 100% when using
the epsilon-NTU model.
</p>
<h4>References</h4>
<p>
Mitchell, John W., and James E. Braun. 2012.
\"Supplementary Material Chapter 2: Heat Exchangers for Cooling Applications\".
Excerpt from <i>Principles of heating, ventilation, and air conditioning in buildings</i>.
Hoboken, N.J.: Wiley. Available online:
<a href=\"http://bcs.wiley.com/he-bcs/Books?action=index&amp;itemId=0470624574&amp;bcsId=7185\">
http://bcs.wiley.com/he-bcs/Books?action=index&amp;itemId=0470624574&amp;bcsId=7185</a>
</p>
</html>", revisions="<html>
<ul>
<li>
April 19, 2017, by Michael Wetter:<br/>
Revised model to avoid mixing textual equations and connect statements.
</li>
<li>
March 17, 2017, by Michael O'Keefe:<br/>
First implementation. See
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/622\">
issue 622</a> for more information.
</li>
</ul>
</html>"));
end WetCoilEffectivenessNTUHeating;
