within Buildings.Fluid.HeatExchangers.H_Example.DummyExample;
model RetreiveUA_nominal_Textbook
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
    nPorts=2)
    "Sink for water"
    annotation (Placement(transformation(extent={{100,30},{80,50}})));

  Modelica.Blocks.Sources.RealExpression X_w2(y=0.0173)
    "Water mass fraction of entering air"
    annotation (Placement(transformation(extent={{248,-104},{184,-66}})));
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
    annotation (Placement(transformation(extent={{-100,-112},{-80,-88}})));
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
    annotation (Placement(transformation(extent={{-50,60},{-30,80}})));
  Sources.MassFlowSource_T souWat1(
    redeclare package Medium = Medium_W,
    m_flow=m1_flow_nominal,
    T=T_a1_nominal,
    nPorts=1)
    "Source for water"
    annotation (Placement(transformation(extent={{-180,64},{-160,84}})));
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
    nEle=5,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    tau1=0.1,
    tau2=0.1,
    tau_m=0.1)
    "Discretized coil model"
    annotation (Placement(transformation(extent={{-40,104},{-20,124}})));
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
    annotation (Placement(transformation(extent={{140,92},{120,112}})));
  Real isDryHexDis[hexDis.nEle];
  Real dryFraHexDis = sum(isDryHexDis) / hexDis.nEle;
  Sensors.TemperatureTwoPort TWatIn(redeclare package Medium = Medium_W,
      m_flow_nominal=m1_flow_nominal) "Inlet water temperature" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-104,74})));
  Sensors.TemperatureTwoPort TWatOut(redeclare package Medium = Medium_W,
      m_flow_nominal=m1_flow_nominal) "outlet water temperature" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={18,66})));
  UA_nominalFromOperatingCondition uA_nominalFromOperatingCondition(
    TAirIn=T_a2_nominal,
    TAirOut=286.7305,
    wAirIn=0.0173,
    TWatIn=T_a1_nominal,
    TWatOut=284.2178,
    mAir_flow=m2_flow_nominal,
    mWat_flow=m1_flow_nominal)
    annotation (Placement(transformation(extent={{-106,-326},{10,-236}})));
  Modelica.Blocks.Sources.CombiTimeTable X_w1(table=[0,0.017; 1,0.01765],
      timeScale=100) "Water mass fraction of entering air"
    annotation (Placement(transformation(extent={{218,-174},{174,-130}})));
  WetEffectivenessNTU_Fuzzy_V3_UA_nominalEstim
                                   hexWetNTU1(
    redeclare package Medium1 = Medium_W,
    redeclare package Medium2 = Medium_A,
    UA_nominal=UA_nominal,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    dp2_nominal=0,
    dp1_nominal=0,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    show_T=true) "Heat exchanger coil"
    annotation (Placement(transformation(extent={{-34,-186},{-14,-166}})));

  Sources.MassFlowSource_T souWat3(
    redeclare package Medium = Medium_W,
    m_flow=m1_flow_nominal,
    T=T_a1_nominal,
    nPorts=1)
    "Source for water"
    annotation (Placement(transformation(extent={{-180,-180},{-160,-160}})));
  Sources.Boundary_pT                 sinWat1(redeclare package Medium =
        Medium_W, nPorts=1)
    "Sink for water"
    annotation (Placement(transformation(extent={{70,-176},{50,-156}})));
  Sources.MassFlowSource_T souAir1(
    redeclare package Medium = Medium_A,
    m_flow=m2_flow_nominal,
    T=T_a2_nominal,
    use_Xi_in=true,
    nPorts=1)
    "Air source"
    annotation (Placement(transformation(extent={{128,-236},{108,-216}})));
equation
  for iEle in 1:hexDis.nEle loop
    isDryHexDis[iEle] = if abs(hexDis.ele[iEle].masExc.mWat_flow) < 1E-6 then 1 else 0;
  end for;
  connect(pAir.y, wetBulIn.p) annotation (Line(points={{119,-40},{110,-40},{110,
          -16},{119,-16}},     color={0,0,127}));
  connect(pAir1.y, wetBulOut.p) annotation (Line(points={{-79,-100},{-44,-100},{
          -44,-96},{-41,-96}},color={0,0,127}));
  connect(senMasFraOut.port_b, sinAir.ports[1])
    annotation (Line(points={{-130,-40},{-156,-40},{-156,-37.3333},{-160,
          -37.3333}},                                color={0,127,255}));
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
  connect(souWat2.ports[1], hexDis.port_a1)
    annotation (Line(points={{-160,120},{-40,120}}, color={0,127,255}));
  connect(sinAir.ports[2], hexDis.port_b2) annotation (Line(points={{-160,-40},
          {-140,-40},{-140,108},{-40,108}},      color={0,127,255}));
  connect(souAir2.ports[1], hexDis.port_a2) annotation (Line(points={{120,102},
          {20,102},{20,108},{-20,108}},color={0,127,255}));
  connect(hexDis.port_b1, sinWat.ports[1]) annotation (Line(points={{-20,120},{
          0,120},{0,38},{80,38},{80,42}},    color={0,127,255}));
  connect(TDryBulOut.port_a, hexWetNTU.port_b2) annotation (Line(points={{-70,-40},
          {-60,-40},{-60,64},{-50,64}}, color={0,127,255}));
  connect(RelHumIn.port_b, hexWetNTU.port_a2) annotation (Line(points={{10,-80},
          {-10,-80},{-10,64},{-30,64}}, color={0,127,255}));
  connect(souWat1.ports[1], TWatIn.port_a) annotation (Line(points={{-160,74},{
          -114,74}},                     color={0,127,255}));
  connect(TWatIn.port_b, hexWetNTU.port_a1)
    annotation (Line(points={{-94,74},{-72,74},{-72,76},{-50,76}},
                                                 color={0,127,255}));
  connect(hexWetNTU.port_b1, TWatOut.port_a) annotation (Line(points={{-30,76},
          {-13,76},{-13,66},{8,66}}, color={0,127,255}));
  connect(TWatOut.port_b, sinWat.ports[2]) annotation (Line(points={{28,66},{34,
          66},{34,38},{80,38}}, color={0,127,255}));
  connect(X_w2.y, souAir.Xi_in[1]) annotation (Line(points={{180.8,-85},{162.4,-85},
          {162.4,-84},{142,-84}}, color={0,0,127}));
  connect(X_w2.y, souAir2.Xi_in[1]) annotation (Line(points={{180.8,-85},{180.8,
          98},{142,98}}, color={0,0,127}));
  connect(sinAir.ports[3], hexWetNTU1.port_b2) annotation (Line(points={{-160,
          -42.6667},{-138,-42.6667},{-138,-182},{-34,-182}}, color={0,127,255}));
  connect(souWat3.ports[1], hexWetNTU1.port_a1)
    annotation (Line(points={{-160,-170},{-34,-170}}, color={0,127,255}));
  connect(sinWat1.ports[1], hexWetNTU1.port_b1) annotation (Line(points={{50,
          -166},{20,-166},{20,-170},{-14,-170}}, color={0,127,255}));
  connect(hexWetNTU1.port_a2, souAir1.ports[1]) annotation (Line(points={{-14,
          -182},{76,-182},{76,-226},{108,-226}}, color={0,127,255}));
  connect(X_w2.y, souAir1.Xi_in[1]) annotation (Line(points={{180.8,-85},{156,
          -85},{156,-230},{130,-230}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true,
    extent={{-200,-340},{200,140}})),
    experiment(
      StopTime=3600,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
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
    Icon(coordinateSystem(extent={{-200,-340},{200,140}})));
end RetreiveUA_nominal_Textbook;
