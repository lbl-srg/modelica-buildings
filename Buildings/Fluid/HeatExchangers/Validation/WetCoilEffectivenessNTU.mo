within Buildings.Fluid.HeatExchangers.Validation;
model WetCoilEffectivenessNTU
  "Model that validates the wet coil effectiveness-NTU model"
  extends Modelica.Icons.Example;

  package Medium_W = Buildings.Media.Water;
  package Medium_A = Buildings.Media.Air;

  constant Modelica.SIunits.AbsolutePressure pAtm = 101325
    "Atmospheric pressure";
  parameter Modelica.SIunits.Temperature T_a1_nominal=
    Modelica.SIunits.Conversions.from_degF(42)
    "Inlet water temperature";
  parameter Modelica.SIunits.Temperature T_a2_nominal=
    Modelica.SIunits.Conversions.from_degF(80)
    "Inlet air temperature";
  parameter Modelica.SIunits.ThermalConductance UA_nominal = 4748
    "Total thermal conductance at nominal flow, from textbook";
  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal = 3.78
    "Nominal mass flow rate of water";
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal = 2.646
    "Nominal mass flow rate of air";
  parameter Types.HeatExchangerConfiguration hexCon=
    Types.HeatExchangerConfiguration.CrossFlowStream1MixedStream2Unmixed
    "Heat exchanger configuration";
  Buildings.Fluid.Sources.Boundary_pT sinAir(
    redeclare package Medium = Medium_A,
    use_p_in=false,
    nPorts=2)
    "Air sink"
    annotation (Placement(transformation(extent={{-180,-50},{-160,-30}})));
  Sources.MassFlowSource_T souAir(
    redeclare package Medium = Medium_A,
    m_flow=m2_flow_nominal,
    T=T_a2_nominal,
    use_Xi_in=true,
    nPorts=1)
    "Air source"
    annotation (Placement(transformation(extent={{140,-90},{120,-70}})));
  Buildings.Fluid.Sources.Boundary_pT sinWat(
    redeclare package Medium = Medium_W,
    nPorts=2)
    "Sink for water"
    annotation (Placement(transformation(extent={{80,10},{60,30}})));
  Modelica.Blocks.Sources.CombiTimeTable X_w2(
    table=[0,0.0035383; 1,0.01765],
    timeScale=100) "Water mass fraction of entering air"
    annotation (Placement(transformation(extent={{190,-90},{170,-70}})));
  Sensors.RelativeHumidityTwoPort RelHumIn(redeclare package Medium = Medium_A,
      m_flow_nominal=m2_flow_nominal) "Inlet relative humidity"
    annotation (Placement(transformation(extent={{30,-90},{10,-70}})));
  Sensors.TemperatureTwoPort TDryBulIn(redeclare package Medium = Medium_A,
      m_flow_nominal=m2_flow_nominal) "Inlet dry bulb temperature"
    annotation (Placement(transformation(extent={{70,-90},{50,-70}})));
  Modelica.Blocks.Sources.RealExpression pAir(y=pAtm) "Air pressure"
    annotation (Placement(transformation(extent={{140,-52},{120,-28}})));
  Buildings.Utilities.Psychrometrics.TWetBul_TDryBulXi wetBulIn(redeclare
      package Medium = Medium_A) "Computation of wet bulb temperature"
    annotation (Placement(transformation(extent={{120,-20},{140,0}})));
  Sensors.MassFractionTwoPort senMasFraIn(redeclare package Medium = Medium_A,
      m_flow_nominal=m2_flow_nominal) "Water mass fraction of entering air"
    annotation (Placement(transformation(extent={{110,-90},{90,-70}})));
  Sensors.MassFractionTwoPort senMasFraOut(redeclare package Medium = Medium_A,
      m_flow_nominal=m2_flow_nominal) "Water mass fraction of leaving air"
    annotation (Placement(transformation(extent={{-110,-30},{-130,-50}})));
  Sensors.TemperatureTwoPort TDryBulOut(redeclare package Medium = Medium_A,
      m_flow_nominal=m2_flow_nominal) "Dry bulb temperature of leaving air"
    annotation (Placement(transformation(extent={{-70,-30},{-90,-50}})));
  Buildings.Utilities.Psychrometrics.TWetBul_TDryBulXi wetBulOut(redeclare
      package Medium = Medium_A) "Computation of wet bulb temperature"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
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
    show_T=true) "Effectiveness-NTU coil model"
    annotation (Placement(transformation(extent={{-40,-4},{-20,16}})));
  Sources.MassFlowSource_T souWat1(
    redeclare package Medium = Medium_W,
    m_flow=m1_flow_nominal,
    T=T_a1_nominal,
    nPorts=1)
    "Source for water"
    annotation (Placement(transformation(extent={{-180,2},{-160,22}})));
  WetCoilCounterFlow hexDis(
    redeclare package Medium1 = Medium_W,
    redeclare package Medium2 = Medium_A,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    dp2_nominal=0,
    allowFlowReversal1=true,
    allowFlowReversal2=true,
    dp1_nominal=0,
    UA_nominal=UA_nominal,
    show_T=true,
    nEle=30,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    tau1=0.1,
    tau2=0.1,
    tau_m=0.1)
    "Discretized coil model"
    annotation (Placement(transformation(extent={{-40,36},{-20,56}})));
  Sources.MassFlowSource_T souWat2(
    redeclare package Medium = Medium_W,
    m_flow=m1_flow_nominal,
    T=T_a1_nominal,
    nPorts=1)
    "Source for water"
    annotation (Placement(transformation(extent={{-180,42},{-160,62}})));
  Sources.MassFlowSource_T souAir2(
    redeclare package Medium = Medium_A,
    m_flow=m2_flow_nominal,
    T=T_a2_nominal,
    use_Xi_in=true,
    nPorts=1)
    "Air source"
    annotation (Placement(transformation(extent={{140,30},{120,50}})));
equation
  connect(pAir.y, wetBulIn.p) annotation (Line(points={{119,-40},{110,-40},{110,
          -18},{119,-18}},     color={0,0,127}));
  connect(pAir1.y, wetBulOut.p) annotation (Line(points={{-79,-100},{-44,-100},
          {-44,-98},{-41,-98}},
                              color={0,0,127}));
  connect(senMasFraOut.port_b, sinAir.ports[1])
    annotation (Line(points={{-130,-40},{-156,-40},{-156,-38},{-160,-38}},
                                                     color={0,127,255}));
  connect(TDryBulOut.port_b, senMasFraOut.port_a)
    annotation (Line(points={{-90,-40},{-110,-40}}, color={0,127,255}));
  connect(TDryBulOut.T, wetBulOut.TDryBul)
    annotation (Line(points={{-80,-51},{-80,-82},{-41,-82}}, color={0,0,127}));
  connect(senMasFraOut.X, wetBulOut.Xi[1]) annotation (Line(points={{-120,-51},
          {-120,-90},{-41,-90}},                      color={0,0,127}));
  connect(souAir.ports[1], senMasFraIn.port_a)
    annotation (Line(points={{120,-80},{110,-80}}, color={0,127,255}));
  connect(senMasFraIn.port_b, TDryBulIn.port_a)
    annotation (Line(points={{90,-80},{70,-80}}, color={0,127,255}));
  connect(senMasFraIn.X, wetBulIn.Xi[1])
    annotation (Line(points={{100,-69},{100,-10},{119,-10}},
                                                           color={0,0,127}));
  connect(TDryBulIn.T, wetBulIn.TDryBul)
    annotation (Line(points={{60,-69},{60,-2},{119,-2}},
                                                       color={0,0,127}));
  connect(TDryBulIn.port_b, RelHumIn.port_a)
    annotation (Line(points={{50,-80},{30,-80}}, color={0,127,255}));
  connect(souWat1.ports[1], hexWetNTU.port_a1) annotation (Line(points={{-160,12},
          {-40,12}},                         color={0,127,255}));
  connect(hexWetNTU.port_b1, sinWat.ports[1]) annotation (Line(points={{-20,12},
          {40,12},{40,18},{60,18},{60,22}},
                                  color={0,127,255}));
  connect(X_w2.y[1], souAir.Xi_in[1]) annotation (Line(points={{169,-80},{160,-80},
          {160,-84},{142,-84}}, color={0,0,127}));
  connect(souWat2.ports[1], hexDis.port_a1)
    annotation (Line(points={{-160,52},{-40,52}},   color={0,127,255}));
  connect(sinAir.ports[2], hexDis.port_b2) annotation (Line(points={{-160,-42},{
          -140,-42},{-140,40},{-40,40}},         color={0,127,255}));
  connect(hexDis.port_b1, sinWat.ports[2]) annotation (Line(points={{-20,52},{40,
          52},{40,20},{60,20},{60,18}},      color={0,127,255}));
  connect(X_w2.y[1], souAir2.Xi_in[1]) annotation (Line(points={{169,-80},{160,-80},
          {160,36},{142,36}}, color={0,0,127}));
  connect(souAir2.ports[1], hexDis.port_a2) annotation (Line(points={{120,40},{-20,
          40}},                        color={0,127,255}));
  connect(hexWetNTU.port_b2, TDryBulOut.port_a) annotation (Line(points={{-40,0},
          {-60,0},{-60,-40},{-70,-40}}, color={0,127,255}));
  connect(hexWetNTU.port_a2, RelHumIn.port_b) annotation (Line(points={{-20,0},{
          0,0},{0,-80},{10,-80}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true,
    extent={{-200,-120},{200,120}})),
    experiment(
      StopTime=100,
      Tolerance=1e-06),
    __Dymola_Commands(
    file="Resources/Scripts/Dymola/Fluid/HeatExchangers/Validation/WetCoilEffectivenessNTU.mos"
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
The example is a steady-state analysis of a wet coil with constant air
and water inlet temperature and mass flow rate, and an increasing air inlet
humidity which triggers the transition from a fully-dry to a fully-wet regime.
The reference used for validation is the published experimental data.
A discretized wet coil model is also simulated for comparison.
</p>
<p>
The slight deviations we find are believed due to differences in the tolerance
of the solver algorithms employed as well as differences in media property
calculations for air and water.
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
end WetCoilEffectivenessNTU;
