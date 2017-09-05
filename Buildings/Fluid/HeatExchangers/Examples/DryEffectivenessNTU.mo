within Buildings.Fluid.HeatExchangers.Examples;
model DryEffectivenessNTU
  "Model that demonstrates use of a heat exchanger without condensation that uses the epsilon-NTU relation"
  extends Modelica.Icons.Example;

 package Medium1 = Buildings.Media.Water;
 package Medium2 = Buildings.Media.Air;

 parameter Modelica.SIunits.SpecificHeatCapacity cp1=
 Medium1.specificHeatCapacityCp(
      Medium1.setState_pTX(Medium1.p_default, Medium1.T_default, Medium1.X_default))
    "Specific heat capacity of medium 2";
 parameter Modelica.SIunits.SpecificHeatCapacity cp2=
 Medium2.specificHeatCapacityCp(
      Medium2.setState_pTX(Medium2.p_default, Medium2.T_default, Medium2.X_default))
    "Specific heat capacity of medium 2";
 parameter Modelica.SIunits.MassFlowRate m1_flow = 5
    "Nominal mass flow rate medium 1";
 parameter Modelica.SIunits.MassFlowRate m2_flow = m1_flow*cp1/
      cp2 "Nominal mass flow rate medium 2";

  Buildings.Fluid.Sources.Boundary_pT sin_2(                       redeclare
      package Medium = Medium2,
    use_p_in=true,
    nPorts=5,
    T=273.15 + 10)        annotation (Placement(transformation(extent={{-64,10},
            {-44,30}})));
    Modelica.Blocks.Sources.Ramp PIn(
    height=200,
    duration=60,
    offset=101325,
    startTime=100)
                 annotation (Placement(transformation(extent={{60,-90},{80,-70}})));
  Buildings.Fluid.Sources.Boundary_pT sou_2(                       redeclare
      package Medium = Medium2, T=273.15 + 5,
    use_p_in=true,
    use_T_in=true,
    nPorts=5)             annotation (Placement(transformation(extent={{10,-10},
            {-10,10}}, origin={72,-10})));
    Modelica.Blocks.Sources.Ramp TWat(
    height=10,
    duration=60,
    offset=273.15 + 30,
    startTime=60) "Water temperature"
                 annotation (Placement(transformation(extent={{-100,44},{-80,64}})));
  Modelica.Blocks.Sources.Constant TDb(k=293.15) "Drybulb temperature"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
    Modelica.Blocks.Sources.Constant POut(k=101325)
      annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Buildings.Fluid.Sources.Boundary_pT sin_1(                       redeclare
      package Medium = Medium1,
    use_p_in=true,
    nPorts=5,
    p=300000,
    T=273.15 + 25)        annotation (Placement(transformation(extent={{80,40},
            {60,60}})));
  Buildings.Fluid.Sources.Boundary_pT sou_1(
    redeclare package Medium = Medium1,
    p=300000 + 5000,
    T=273.15 + 50,
    use_T_in=true,
    nPorts=5)             annotation (Placement(transformation(extent={{-62,40},
            {-42,60}})));
  Buildings.Fluid.HeatExchangers.DryEffectivenessNTU hexPar(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    dp1_nominal=500,
    dp2_nominal=10,
    m1_flow_nominal=m1_flow,
    m2_flow_nominal=m2_flow,
    Q_flow_nominal=m2_flow*cp2*(24 - 20),
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.ParallelFlow,
    show_T=true,
    T_a1_nominal=303.15,
    T_a2_nominal=293.15)
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));

  Buildings.Fluid.HeatExchangers.DryEffectivenessNTU hexCou(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    dp1_nominal=500,
    dp2_nominal=10,
    m1_flow_nominal=m1_flow,
    m2_flow_nominal=m2_flow,
    Q_flow_nominal=m2_flow*cp2*(24 - 20),
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    show_T=true,
    T_a1_nominal=303.15,
    T_a2_nominal=293.15)
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  Buildings.Fluid.HeatExchangers.DryEffectivenessNTU hexCroC1Mix(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    dp1_nominal=500,
    dp2_nominal=10,
    m1_flow_nominal=m1_flow,
    m2_flow_nominal=m2_flow,
    Q_flow_nominal=m2_flow*cp2*(24 - 20),
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CrossFlowStream1MixedStream2Unmixed,
    show_T=true,
    T_a1_nominal=303.15,
    T_a2_nominal=293.15)
    annotation (Placement(transformation(extent={{-10,-28},{10,-8}})));
  Buildings.Fluid.HeatExchangers.DryEffectivenessNTU hexCroC1Unm(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    dp1_nominal=500,
    dp2_nominal=10,
    m1_flow_nominal=m1_flow,
    m2_flow_nominal=m2_flow,
    Q_flow_nominal=m2_flow*cp2*(24 - 20),
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CrossFlowStream1UnmixedStream2Mixed,
    show_T=true,
    T_a1_nominal=303.15,
    T_a2_nominal=293.15)
    annotation (Placement(transformation(extent={{-10,-58},{10,-38}})));
  Buildings.Fluid.HeatExchangers.DryEffectivenessNTU hexCroUnm(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    dp1_nominal=500,
    dp2_nominal=10,
    m1_flow_nominal=m1_flow,
    m2_flow_nominal=m2_flow,
    Q_flow_nominal=m2_flow*cp2*(24 - 20),
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CrossFlowUnmixed,
    show_T=true,
    T_a1_nominal=303.15,
    T_a2_nominal=293.15)
    annotation (Placement(transformation(extent={{-10,-86},{10,-66}})));
  Modelica.Blocks.Sources.Trapezoid trapezoid(
    amplitude=5000,
    rising=10,
    width=100,
    falling=10,
    period=3600,
    offset=300000)
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
equation
  connect(PIn.y,sou_2. p_in) annotation (Line(
      points={{81,-80},{98,-80},{98,-2},{84,-2}},
      color={0,0,127}));
  connect(TDb.y, sou_2.T_in) annotation (Line(points={{81,-50},{92,-50},{92,-6},
          {84,-6}},  color={0,0,127}));
  connect(TWat.y, sou_1.T_in)
    annotation (Line(points={{-79,54},{-64,54}}, color={0,0,127}));
  connect(sou_1.ports[1], hexPar.port_a1)
                                       annotation (Line(
      points={{-42,53.2},{-25,53.2},{-25,56},{-10,56}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hexPar.port_a2, sou_2.ports[1])
                                       annotation (Line(
      points={{10,44},{30,44},{30,-6.8},{62,-6.8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(POut.y, sin_2.p_in) annotation (Line(
      points={{-79,20},{-69.5,20},{-69.5,28},{-66,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hexPar.port_b1, sin_1.ports[1])
                                       annotation (Line(
      points={{10,56},{34,56},{34,53.2},{60,53.2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin_2.ports[1], hexPar.port_b2)
                                       annotation (Line(
      points={{-44,23.2},{-32,23.2},{-32,44},{-10,44}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hexCou.port_a1, sou_1.ports[2]) annotation (Line(
      points={{-10,16},{-24,16},{-24,51.6},{-42,51.6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hexCroC1Mix.port_a1, sou_1.ports[3])   annotation (Line(
      points={{-10,-12},{-26,-12},{-26,50},{-42,50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hexCroC1Unm.port_a1, sou_1.ports[4])   annotation (Line(
      points={{-10,-42},{-28,-42},{-28,48.4},{-42,48.4}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hexCou.port_b2, sin_2.ports[2]) annotation (Line(
      points={{-10,4},{-32,4},{-32,21.6},{-44,21.6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hexCroC1Mix.port_b2, sin_2.ports[3])   annotation (Line(
      points={{-10,-24},{-34,-24},{-34,20},{-44,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hexCroC1Unm.port_b2, sin_2.ports[4])   annotation (Line(
      points={{-10,-54},{-36,-54},{-36,18.4},{-44,18.4}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hexCou.port_b1, sin_1.ports[2]) annotation (Line(
      points={{10,16},{34,16},{34,51.6},{60,51.6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hexCroC1Mix.port_b1, sin_1.ports[3])   annotation (Line(
      points={{10,-12},{36,-12},{36,50},{60,50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hexCroC1Unm.port_b1, sin_1.ports[4])   annotation (Line(
      points={{10,-42},{38,-42},{38,48.4},{60,48.4}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hexCou.port_a2, sou_2.ports[2]) annotation (Line(
      points={{10,4},{36,4},{36,-8.4},{62,-8.4}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hexCroC1Mix.port_a2, sou_2.ports[3])   annotation (Line(
      points={{10,-24},{30,-24},{30,-10},{62,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hexCroC1Unm.port_a2, sou_2.ports[4])   annotation (Line(
      points={{10,-54},{32,-54},{32,-11.6},{62,-11.6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hexCroUnm.port_a1, sou_1.ports[5]) annotation (Line(
      points={{-10,-70},{-30,-70},{-30,46.8},{-42,46.8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hexCroUnm.port_b2, sin_2.ports[5]) annotation (Line(
      points={{-10,-82},{-38,-82},{-38,16.8},{-44,16.8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hexCroUnm.port_b1, sin_1.ports[5]) annotation (Line(
      points={{10,-70},{42,-70},{42,46.8},{60,46.8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hexCroUnm.port_a2, sou_2.ports[5]) annotation (Line(
      points={{10,-82},{44,-82},{44,-13.2},{62,-13.2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(trapezoid.y, sin_1.p_in) annotation (Line(
      points={{61,80},{92,80},{92,58},{82,58}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation(experiment(Tolerance=1e-6, StopTime=360),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Examples/DryEffectivenessNTU.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This model tests
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DryEffectivenessNTU\">
Buildings.Fluid.HeatExchangers.DryEffectivenessNTU</a>
for different inlet conditions.
</p>
</html>", revisions="<html>
<ul>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
February 12, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end DryEffectivenessNTU;
