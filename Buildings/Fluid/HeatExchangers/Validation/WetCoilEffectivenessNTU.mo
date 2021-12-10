within Buildings.Fluid.HeatExchangers.Validation;
model WetCoilEffectivenessNTU
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
    nPorts=2)
    "Air sink"
    annotation (Placement(transformation(extent={{-180,-32},{-160,-12}})));
  Sources.MassFlowSource_T souAir(
    redeclare package Medium = Medium_A,
    m_flow=m2_flow_nominal,
    T=T_a2_nominal,
    use_Xi_in=true,
    nPorts=1)
    "Air source"
    annotation (Placement(transformation(extent={{140,-30},{120,-10}})));
  Buildings.Fluid.Sources.Boundary_pT sinWat(
    redeclare package Medium = Medium_W,
    nPorts=2)
    "Sink for water"
    annotation (Placement(transformation(extent={{50,50},{30,70}})));
  Buildings.Utilities.Psychrometrics.ToTotalAir conversion
    annotation (Placement(transformation(extent={{190,-50},{170,-30}})));
  Sensors.RelativeHumidityTwoPort relHumIn(redeclare package Medium = Medium_A,
      m_flow_nominal=m2_flow_nominal) "Inlet relative humidity"
    annotation (Placement(transformation(extent={{40,-30},{20,-10}})));
  Sensors.TemperatureTwoPort TDryBulIn(redeclare package Medium = Medium_A,
      m_flow_nominal=m2_flow_nominal) "Inlet dry bulb temperature"
    annotation (Placement(transformation(extent={{70,-30},{50,-10}})));
  Modelica.Blocks.Sources.RealExpression pAir(y=pAtm) "Air pressure"
    annotation (Placement(transformation(extent={{140,-2},{120,22}})));
  Buildings.Utilities.Psychrometrics.TWetBul_TDryBulXi wetBulIn(redeclare package
              Medium = Medium_A) "Computation of wet bulb temperature"
    annotation (Placement(transformation(extent={{120,30},{140,50}})));
  Sensors.MassFractionTwoPort senMasFraIn(redeclare package Medium = Medium_A,
      m_flow_nominal=m2_flow_nominal) "Water mass fraction of entering air"
    annotation (Placement(transformation(extent={{110,-30},{90,-10}})));
  Sensors.MassFractionTwoPort senMasFraOut(redeclare package Medium = Medium_A,
      m_flow_nominal=m2_flow_nominal) "Water mass fraction of leaving air"
    annotation (Placement(transformation(extent={{-110,30},{-130,50}})));
  Sensors.TemperatureTwoPort TDryBulOut(redeclare package Medium = Medium_A,
      m_flow_nominal=m2_flow_nominal) "Dry bulb temperature of leaving air"
    annotation (Placement(transformation(extent={{-50,30},{-70,50}})));
  Buildings.Utilities.Psychrometrics.TWetBul_TDryBulXi wetBulOut(redeclare package
              Medium = Medium_A) "Computation of wet bulb temperature"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Modelica.Blocks.Sources.RealExpression pAir1(y=pAtm) "Air pressure"
    annotation (Placement(transformation(extent={{-100,-72},{-80,-48}})));
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
    annotation (Placement(transformation(extent={{-30,44},{-10,64}})));
  Sources.MassFlowSource_T souWat1(
    redeclare package Medium = Medium_W,
    m_flow=m1_flow_nominal,
    T=T_a1_nominal,
    nPorts=1)
    "Source for water"
    annotation (Placement(transformation(extent={{-180,50},{-160,70}})));
  Sensors.RelativeHumidityTwoPort relHumOut_eps(redeclare package Medium =
        Medium_A, m_flow_nominal=m2_flow_nominal) "Outlet relative humidity"
    annotation (Placement(transformation(extent={{-80,30},{-100,50}})));
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
    annotation (Placement(transformation(extent={{-30,-4},{-10,16}})));
  Sources.MassFlowSource_T souAir1(
    redeclare package Medium = Medium_A,
    m_flow=m2_flow_nominal,
    T=T_a2_nominal,
    use_Xi_in=true,
    nPorts=1)
    "Air source"
    annotation (Placement(transformation(extent={{140,-70},{120,-50}})));
  Sources.MassFlowSource_T souWat2(
    redeclare package Medium = Medium_W,
    m_flow=m1_flow_nominal,
    T=T_a1_nominal,
    nPorts=1)
    "Source for water"
    annotation (Placement(transformation(extent={{-180,10},{-160,30}})));
  Modelica.Blocks.Sources.CombiTimeTable w_a2(table=[0,0.0035383; 1,0.01765],
      timeScale=1000)
                     "Absolute humidity of entering air"
    annotation (Placement(transformation(extent={{196,6},{176,26}})));
equation
  connect(pAir.y, wetBulIn.p) annotation (Line(points={{119,10},{112,10},{112,
          32},{119,32}},       color={0,0,127}));
  connect(pAir1.y, wetBulOut.p) annotation (Line(points={{-79,-60},{-50,-60},{
          -50,-48},{-41,-48}},color={0,0,127}));
  connect(senMasFraOut.port_b, sinAir.ports[1])
    annotation (Line(points={{-130,40},{-140,40},{-140,-20},{-160,-20}},
                                                     color={0,127,255}));
  connect(TDryBulOut.T, wetBulOut.TDryBul)
    annotation (Line(points={{-60,51},{-60,54},{-44,54},{-44,-32},{-41,-32}},
                                                             color={0,0,127}));
  connect(senMasFraOut.X, wetBulOut.Xi[1]) annotation (Line(points={{-120,51},{
          -120,54},{-134,54},{-134,-40},{-41,-40}},   color={0,0,127}));
  connect(souAir.ports[1], senMasFraIn.port_a)
    annotation (Line(points={{120,-20},{110,-20}}, color={0,127,255}));
  connect(senMasFraIn.port_b, TDryBulIn.port_a)
    annotation (Line(points={{90,-20},{70,-20}}, color={0,127,255}));
  connect(senMasFraIn.X, wetBulIn.Xi[1])
    annotation (Line(points={{100,-9},{100,40},{119,40}},  color={0,0,127}));
  connect(TDryBulIn.T, wetBulIn.TDryBul)
    annotation (Line(points={{60,-9},{60,48},{119,48}},color={0,0,127}));
  connect(TDryBulIn.port_b, relHumIn.port_a)
    annotation (Line(points={{50,-20},{40,-20}}, color={0,127,255}));
  connect(souWat1.ports[1], hexWetNTU.port_a1) annotation (Line(points={{-160,60},
          {-30,60}},                         color={0,127,255}));
  connect(hexWetNTU.port_b1, sinWat.ports[1]) annotation (Line(points={{-10,60},
          {16,60},{16,62},{30,62}},
                                  color={0,127,255}));
  connect(hexWetNTU.port_b2, TDryBulOut.port_a) annotation (Line(points={{-30,48},
          {-40,48},{-40,40},{-50,40}},  color={0,127,255}));
  connect(hexWetNTU.port_a2, relHumIn.port_b) annotation (Line(points={{-10,48},
          {10,48},{10,-20},{20,-20}},
                                  color={0,127,255}));
  connect(TDryBulOut.port_b, relHumOut_eps.port_a) annotation (Line(points={{-70,40},
          {-80,40}},                       color={0,127,255}));
  connect(relHumOut_eps.port_b, senMasFraOut.port_a)
    annotation (Line(points={{-100,40},{-110,40}},
                                                 color={0,127,255}));
  connect(hexWetNTU_TX.port_b1, sinWat.ports[2]) annotation (Line(points={{-10,12},
          {20,12},{20,58},{30,58}},            color={0,127,255}));
  connect(souAir1.ports[1], hexWetNTU_TX.port_a2) annotation (Line(points={{120,-60},
          {0,-60},{0,0},{-10,0}},            color={0,127,255}));
  connect(sinAir.ports[2], hexWetNTU_TX.port_b2) annotation (Line(points={{-160,
          -24},{-138,-24},{-138,0},{-30,0}},               color={0,127,255}));
  connect(souWat2.ports[1], hexWetNTU_TX.port_a1) annotation (Line(points={{-160,20},
          {-40,20},{-40,12},{-30,12}},         color={0,127,255}));
  connect(w_a2.y[1], conversion.XiDry) annotation (Line(points={{175,16},{172,
          16},{172,-10},{196,-10},{196,-40},{191,-40}},  color={0,0,127}));
  connect(conversion.XiTotalAir, souAir.Xi_in[1]) annotation (Line(points={{169,-40},
          {158,-40},{158,-24},{142,-24}},      color={0,0,127}));
  connect(conversion.XiTotalAir, souAir1.Xi_in[1]) annotation (Line(points={{169,-40},
          {154,-40},{154,-64},{142,-64}},            color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true,
    extent={{-200,-120},{200,120}})),
    experiment(
      StopTime=1000,
      Tolerance=1e-06),
    __Dymola_Commands(
    file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Validation/WetCoilEffectivenessNTU.mos"
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
First implementation.
</li>
</ul>
</html>"));
end WetCoilEffectivenessNTU;
