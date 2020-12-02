within Buildings.Fluid.HeatExchangers.H_Example.DummyExample;
model Wet_Retreive_Textbook
  "Model validation of the WetCoilEffNtu model compared with a reference"
  extends Modelica.Icons.Example;

  package Medium_W = Buildings.Media.Water;
  package Medium_A = Buildings.Media.Air;

  constant Modelica.SIunits.AbsolutePressure pAtm = 101325
    "Atmospheric pressure";

  parameter Modelica.SIunits.Temperature T_a2_nominal=
    Modelica.SIunits.Conversions.from_degF(80)
    "Inlet air temperature";
  parameter Modelica.SIunits.Temperature T_b2_nominal=
    Modelica.SIunits.Conversions.from_degF(53)
    "Outlet air temperature";
  parameter Modelica.SIunits.Temperature T_a1_nominal=
    Modelica.SIunits.Conversions.from_degF(42)
    "Inlet water temperature";
  parameter Modelica.SIunits.Temperature T_b1_nominal=
    Modelica.SIunits.Conversions.from_degF(47.72)
    "Outlet water temperature";
  parameter Real X_w2_nominal_dry(min=0,max=1) = 0.0035383
    "Inlet air humidity ratio: mass of water per mass of moist air";
  parameter Real X_w2_nominal_wet(min=0,max=1) = 0.01765
    "Inlet air humidity ratio: mass of water per mass of moist air";

  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal = 3.78
    "Nominal mass flow rate of water";
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal = 2.646
    "Nominal mass flow rate of air";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal=
    m1_flow_nominal * 4200 * abs(T_a1_nominal - T_b1_nominal)
    "Nominal heat transfer";
  parameter Modelica.SIunits.ThermalConductance UA_nominal = 9495.5 / 2
    "Total thermal conductance at nominal flow, used to compute heat capacity";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal_dry = 44234
    "Nominal heat transfer";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal_wet = 82722
    "Nominal heat transfer";
  parameter Types.HeatExchangerConfiguration hexCon=
    Types.HeatExchangerConfiguration.CrossFlowStream1UnmixedStream2Mixed
    "Heat exchanger configuration";

  Buildings.Fluid.Sources.Boundary_pT sinAir(
    redeclare package Medium = Medium_A,
    use_p_in=false,
    nPorts=3)
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
    nPorts=4)
    "Sink for water"
    annotation (Placement(transformation(extent={{60,30},{40,50}})));
  Sources.MassFlowSource_T souWat(
    redeclare package Medium = Medium_W,
    m_flow=m1_flow_nominal,
    T=T_a1_nominal,
    nPorts=1)
    "Source for water"
    annotation (Placement(transformation(extent={{-180,10},{-160,30}})));
  Modelica.SIunits.HeatFlowRate QTot1 = m1_flow_nominal * (h_b1 - h_a1)
    "Total heat transferred to the water";
  Modelica.SIunits.HeatFlowRate QTot2 = m2_flow_nominal * (h_b2 - h_a2)
    "Total heat tranferred to the air";
  Modelica.SIunits.SpecificEnthalpy h_a2=Medium_W.specificEnthalpy(
      Medium_W.setState_phX(
      p=hexWetNTU_IBPSA.port_a2.p,
      h=actualStream(hexWetNTU_IBPSA.port_a2.h_outflow),
      X={actualStream(hexWetNTU_IBPSA.port_a2.Xi_outflow[1]),1 - actualStream(
        hexWetNTU_IBPSA.port_a2.Xi_outflow[1])})) "Specific enthalpy";
  Modelica.SIunits.SpecificEnthalpy h_a1=Medium_W.specificEnthalpy(
      Medium_W.setState_ph(p=hexWetNTU_IBPSA.port_a1.p, h=actualStream(
      hexWetNTU_IBPSA.port_a1.h_outflow))) "Specific enthalpy";
  Modelica.SIunits.SpecificEnthalpy h_b2=Medium_W.specificEnthalpy(
      Medium_W.setState_phX(
      p=hexWetNTU_IBPSA.port_b2.p,
      h=actualStream(hexWetNTU_IBPSA.port_b2.h_outflow),
      X={actualStream(hexWetNTU_IBPSA.port_b2.Xi_outflow[1]),1 - actualStream(
        hexWetNTU_IBPSA.port_b2.Xi_outflow[1])})) "Specific enthalpy";
  Modelica.SIunits.SpecificEnthalpy h_b1=Medium_W.specificEnthalpy(
      Medium_W.setState_ph(p=hexWetNTU_IBPSA.port_b1.p, h=actualStream(
      hexWetNTU_IBPSA.port_b1.h_outflow))) "Specific enthalpy";
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
      package Medium = Medium_A)
    annotation (Placement(transformation(extent={{120,-18},{140,2}})));
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
      package Medium = Medium_A)
    annotation (Placement(transformation(extent={{-40,-98},{-20,-78}})));
  Modelica.Blocks.Sources.RealExpression pAir1(y=pAtm)  "Pressure"
    annotation (Placement(transformation(extent={{-118,-112},{-98,-88}})));
  WetEffectivenessNTU_Fuzzy_V3     hexWetNTU(
    redeclare package Medium1 = Medium_W,
    redeclare package Medium2 = Medium_A,
    UA_nominal=UA_nominal,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    dp2_nominal=0,
    dp1_nominal=0,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    show_T=true) "Heat exchanger coil"
    annotation (Placement(transformation(extent={{-40,64},{-20,84}})));
  Sources.MassFlowSource_T souWat1(
    redeclare package Medium = Medium_W,
    m_flow=m1_flow_nominal,
    T=T_a1_nominal,
    nPorts=1)
    "Source for water"
    annotation (Placement(transformation(extent={{-180,70},{-160,90}})));
  Sources.MassFlowSource_T souAir1(
    redeclare package Medium = Medium_A,
    m_flow=m2_flow_nominal,
    T=T_a2_nominal,
    use_Xi_in=true,
    nPorts=1)
    "Air source"
    annotation (Placement(transformation(extent={{140,50},{120,70}})));
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
    nEle=50,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    tau1=0.1,
    tau2=0.1,
    tau_m=0.1)
    "Discretized coil model"
    annotation (Placement(transformation(extent={{-40,104},{-20,124}})));
  WetEffectivenessNTU_Fuzzy_V3
                           hexWetNTU_IBPSA(
    redeclare package Medium1 = Medium_W,
    redeclare package Medium2 = Medium_A,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    dp2_nominal=0,
    dp1_nominal=0,
    UA_nominal=UA_nominal,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    show_T=true)
    "Epsilon-NTU coil model"
    annotation (Placement(transformation(extent={{-40,4},{-20,24}})));
  Sources.MassFlowSource_T souWat2(
    redeclare package Medium = Medium_W,
    m_flow=m1_flow_nominal,
    T=T_a1_nominal,
    nPorts=1)
    "Source for water"
    annotation (Placement(transformation(extent={{-180,110},{-160,130}})));
  Sources.MassFlowSource_T souAir2(
    redeclare package Medium = Medium_A,
    m_flow=m2_flow_nominal,
    T=T_a2_nominal,
    use_Xi_in=true,
    nPorts=1)
    "Air source"
    annotation (Placement(transformation(extent={{140,90},{120,110}})));
  Real isDryHexDis[hexDis.nEle];
  Real dryFraHexDis = sum(isDryHexDis) / hexDis.nEle;
  Sensors.TemperatureTwoPort TWatOut(redeclare package Medium = Medium_W,
      m_flow_nominal=m1_flow_nominal) "outlet water temperature" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={20,18})));
  Sensors.TemperatureTwoPort TWatIn(redeclare package Medium = Medium_W,
      m_flow_nominal=m1_flow_nominal) "Inlet water temperature" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-94,20})));
equation
  for iEle in 1:hexDis.nEle loop
    isDryHexDis[iEle] = if abs(hexDis.ele[iEle].masExc.mWat_flow) < 1E-6 then 1 else 0;
  end for;
  connect(hexWetNTU_IBPSA.port_b1, sinWat.ports[1]) annotation (Line(points={{-20,20},
          {0,20},{0,43},{40,43}},          color={0,127,255}));
  connect(pAir.y, wetBulIn.p) annotation (Line(points={{119,-40},{110,-40},{110,
          -16},{119,-16}},     color={0,0,127}));
  connect(pAir1.y, wetBulOut.p) annotation (Line(points={{-97,-100},{-44,-100},
          {-44,-96},{-41,-96}},
                              color={0,0,127}));
  connect(senMasFraOut.port_b, sinAir.ports[1])
    annotation (Line(points={{-130,-40},{-156,-40},{-156,-37.3333},{-160,
          -37.3333}},                                color={0,127,255}));
  connect(hexWetNTU_IBPSA.port_b2, TDryBulOut.port_a) annotation (Line(points={{-40,8},
          {-60,8},{-60,-40},{-70,-40}},            color={0,127,255}));
  connect(TDryBulOut.port_b, senMasFraOut.port_a)
    annotation (Line(points={{-90,-40},{-110,-40}}, color={0,127,255}));
  connect(TDryBulOut.T, wetBulOut.TDryBul)
    annotation (Line(points={{-80,-51},{-80,-80},{-41,-80}}, color={0,0,127}));
  connect(senMasFraOut.X, wetBulOut.Xi[1]) annotation (Line(points={{-120,-51},{
          -120,-88},{-41,-88}},                       color={0,0,127}));
  connect(souAir.ports[1], senMasFraIn.port_a)
    annotation (Line(points={{120,-80},{110,-80}}, color={0,127,255}));
  connect(senMasFraIn.port_b, TDryBulIn.port_a)
    annotation (Line(points={{90,-80},{70,-80}}, color={0,127,255}));
  connect(senMasFraIn.X, wetBulIn.Xi[1])
    annotation (Line(points={{100,-69},{100,-8},{119,-8}}, color={0,0,127}));
  connect(TDryBulIn.T, wetBulIn.TDryBul)
    annotation (Line(points={{60,-69},{60,0},{119,0}}, color={0,0,127}));
  connect(TDryBulIn.port_b, RelHumIn.port_a)
    annotation (Line(points={{50,-80},{30,-80}}, color={0,127,255}));
  connect(souWat1.ports[1], hexWetNTU.port_a1) annotation (Line(points={{-160,80},
          {-40,80}},                         color={0,127,255}));
  connect(hexWetNTU.port_b1, sinWat.ports[2]) annotation (Line(points={{-20,80},
          {0,80},{0,41},{40,41}}, color={0,127,255}));
  connect(hexWetNTU_IBPSA.port_a2, RelHumIn.port_b) annotation (Line(points={{-20,8},
          {0,8},{0,-80},{10,-80}},      color={0,127,255}));
  connect(souAir1.ports[1], hexWetNTU.port_a2) annotation (Line(points={{120,60},
          {20,60},{20,68},{-20,68}},     color={0,127,255}));
  connect(hexWetNTU.port_b2, sinAir.ports[2]) annotation (Line(points={{-40,68},
          {-140,68},{-140,-40},{-160,-40}},   color={0,127,255}));
  connect(X_w2.y[1], souAir.Xi_in[1]) annotation (Line(points={{169,-80},{160,-80},
          {160,-84},{142,-84}}, color={0,0,127}));
  connect(X_w2.y[1], souAir1.Xi_in[1]) annotation (Line(points={{169,-80},{160,-80},
          {160,56},{142,56}}, color={0,0,127}));
  connect(souWat2.ports[1], hexDis.port_a1)
    annotation (Line(points={{-160,120},{-40,120}}, color={0,127,255}));
  connect(sinAir.ports[3], hexDis.port_b2) annotation (Line(points={{-160,
          -42.6667},{-140,-42.6667},{-140,108},{-40,108}},
                                                 color={0,127,255}));
  connect(souAir2.ports[1], hexDis.port_a2) annotation (Line(points={{120,100},{
          20,100},{20,108},{-20,108}}, color={0,127,255}));
  connect(hexDis.port_b1, sinWat.ports[3]) annotation (Line(points={{-20,120},{
          0,120},{0,38},{40,38},{40,39}},    color={0,127,255}));
  connect(X_w2.y[1], souAir2.Xi_in[1]) annotation (Line(points={{169,-80},{160,-80},
          {160,96},{142,96}}, color={0,0,127}));
  connect(souWat.ports[1], TWatIn.port_a)
    annotation (Line(points={{-160,20},{-104,20}}, color={0,127,255}));
  connect(TWatIn.port_b, hexWetNTU_IBPSA.port_a1) annotation (Line(points={{-84,
          20},{-62,20},{-62,20},{-40,20}}, color={0,127,255}));
  connect(hexWetNTU_IBPSA.port_b1, TWatOut.port_a) annotation (Line(points={{
          -20,20},{2,20},{2,18},{10,18}}, color={0,127,255}));
  connect(TWatOut.port_b, sinWat.ports[4]) annotation (Line(points={{30,18},{32,
          18},{32,30},{40,30},{40,37}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true,
    extent={{-200,-240},{200,140}})),
    experiment(
      StopTime=100,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(
    file="Resources/Scripts/Dymola/Fluid/HeatExchangers/Validation/WetCoilEffectivenessNTU.mos"
  "Simulate and plot"),
  Documentation(info="<html>
<p>
This example duplicates an example from Mitchell and Braun 2012, example SM-2-1
(Mitchell and Braun 2012) to validate a single case for the
<a href=\"modelica://Buildings.Fluid.HeatExchangers.WetEffectivenessNTU\">
Buildings.Fluid.HeatExchangers.WetEffectivenessNTU</a> model.
</p>

<h4>Validation</h4>

<p>
The example is a steady-state analysis of a partially wet coil with the inlet
conditions as specified in the model setup.
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
</html>"),
    Icon(coordinateSystem(extent={{-200,-240},{200,140}})));
end Wet_Retreive_Textbook;
