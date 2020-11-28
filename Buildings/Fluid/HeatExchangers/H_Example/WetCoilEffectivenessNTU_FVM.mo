within Buildings.Fluid.HeatExchangers.H_Example;
model WetCoilEffectivenessNTU_FVM
  "Model that demonstrates use of a heat exchanger with condensation that uses the epsilon-NTU relation"
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

  Buildings.Fluid.Sources.Boundary_pT sin_2(
    redeclare package Medium = Medium2,
    use_p_in=true,
    nPorts=4,
    T=273.15 + 10) "Boundary condition"
    annotation (Placement(transformation(extent={{-64,10},
            {-44,30}})));
  Buildings.Fluid.Sources.Boundary_pT sou_2(
    redeclare package Medium = Medium2,
    use_Xi_in=true,
    T=273.15 + 5,
    use_p_in=true,
    use_T_in=true,
    nPorts=4) "Boundary condition"
    annotation (Placement(transformation(extent={{10,-10},
            {-10,10}}, origin={72,-10})));
    Modelica.Blocks.Sources.Ramp TWat(
    height=10,
    duration=60,
    offset=5 + 273.15,
    startTime=60) "Water temperature"
                 annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Modelica.Blocks.Sources.Constant TDb(k=30 + 273.15)
                                                 "Drybulb temperature"
    annotation (Placement(transformation(extent={{60,-90},{80,-70}})));
    Modelica.Blocks.Sources.Constant POut(k=101325)
      annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Buildings.Fluid.Sources.Boundary_pT sin_1(
    redeclare package Medium = Medium1,
    use_p_in=true,
    nPorts=4,
    p=300000,
    T=273.15 + 25)
    "Boundary condition" annotation (Placement(transformation(extent={{80,40},
            {60,60}})));
  Buildings.Fluid.Sources.Boundary_pT sou_1(
    redeclare package Medium = Medium1,
    p=300000 + 5000,
    T=273.15 + 50,
    use_T_in=true,
    nPorts=4)
    "Boundary condition" annotation (Placement(transformation(extent={{-62,40},
            {-42,60}})));

  Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU hexDry(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    dp1_nominal=500,
    dp2_nominal=10,
    m1_flow_nominal=m1_flow,
    m2_flow_nominal=m2_flow,
    use_Q_flow_nominal=true,
    Q_flow_nominal=m2_flow*cp2*(24 - 20),
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    show_T=true,
    T_a1_nominal=303.15,
    T_a2_nominal=293.15) "Dry coil"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  WetEffectivenessNTU_Fuzzy_V3                           hexWetNtu(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    dp1_nominal=500,
    dp2_nominal=10,
    m1_flow_nominal=m1_flow,
    m2_flow_nominal=m2_flow,
    UA_nominal=13854.5,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    show_T=true)
    "Heat exchanger"
    annotation (Placement(transformation(extent={{-10,-58},{10,-38}})));
  Modelica.Blocks.Sources.Trapezoid trapezoid(
    amplitude=5000,
    rising=10,
    width=100,
    falling=10,
    period=3600,
    offset=300000)
    "Pressure boundary condition"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  WetCoilCounterFlow hexFVM(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    dp1_nominal=500,
    dp2_nominal=10,
    m1_flow_nominal=m1_flow,
    m2_flow_nominal=m2_flow,
    show_T=true,
    UA_nominal=13854.5,
    nEle=60)            "Heat exchanger"
    annotation (Placement(transformation(extent={{-10,-26},{10,-6}})));
    Modelica.Blocks.Sources.Ramp XIn1(
    height=30*1e-3,
    duration=60,
    offset=2*1e-3,
    startTime=360) "Humidity boundary condition"
                 annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
    Modelica.Blocks.Sources.Ramp PIn(
    height=200,
    duration=60,
    offset=101325,
    startTime=100) "Pressure boundary condition"
                 annotation (Placement(transformation(extent={{60,-132},{80,
            -112}})));
  WetCoilEffectivesnessNTU hexWetIBPSA(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    show_T=true,
    dp1_nominal=500,
    dp2_nominal=10,
    m1_flow_nominal=m1_flow,
    m2_flow_nominal=m2_flow,
    T_a1_nominal=303.15,
    T_a2_nominal=293.15,
    Q_flow_nominal=m2_flow*cp2*(24 - 20),
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CrossFlowStream1UnmixedStream2Mixed)
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  Real isDryHexDis[hexFVM.nEle];
  Real dryFraHexDis = sum(isDryHexDis) / hexFVM.nEle;



equation
    for iEle in 1:hexFVM.nEle loop
    isDryHexDis[iEle] = if abs(hexFVM.ele[iEle].masExc.mWat_flow) < 1E-6 then 1 else 0;
  end for;

  connect(TDb.y, sou_2.T_in) annotation (Line(points={{81,-80},{100,-80},{100,
          -6},{84,-6}},
                     color={0,0,127}));
  connect(TWat.y, sou_1.T_in)
    annotation (Line(points={{-79,60},{-72,60},{-72,54},{-64,54}},
                                                 color={0,0,127}));
  connect(POut.y, sin_2.p_in) annotation (Line(
      points={{-79,20},{-72,20},{-72,28},{-66,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hexDry.port_a1, sou_1.ports[1]) annotation (Line(
      points={{-10,16},{-24,16},{-24,53},{-42,53}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hexWetNtu.port_a1, sou_1.ports[2]) annotation (Line(
      points={{-10,-42},{-28,-42},{-28,51},{-42,51}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hexDry.port_b2, sin_2.ports[1]) annotation (Line(
      points={{-10,4},{-32,4},{-32,23},{-44,23}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hexWetNtu.port_b2, sin_2.ports[2]) annotation (Line(
      points={{-10,-54},{-36,-54},{-36,21},{-44,21}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hexDry.port_b1, sin_1.ports[1]) annotation (Line(
      points={{10,16},{34,16},{34,53},{60,53}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hexWetNtu.port_b1, sin_1.ports[2]) annotation (Line(
      points={{10,-42},{38,-42},{38,51},{60,51}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hexDry.port_a2, sou_2.ports[1]) annotation (Line(
      points={{10,4},{36,4},{36,-7},{62,-7}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hexWetNtu.port_a2, sou_2.ports[2]) annotation (Line(
      points={{10,-54},{32,-54},{32,-9},{62,-9}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(trapezoid.y, sin_1.p_in) annotation (Line(
      points={{61,80},{92,80},{92,58},{82,58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou_1.ports[3], hexFVM.port_a1) annotation (Line(points={{-42,49},{-20,
          49},{-20,-10},{-10,-10}},           color={0,127,255}));
  connect(sin_2.ports[3], hexFVM.port_b2) annotation (Line(points={{-44,19},{-28,
          19},{-28,-22},{-10,-22}},           color={0,127,255}));
  connect(hexFVM.port_a2, sou_2.ports[3]) annotation (Line(points={{10,-22},{38,
          -22},{38,-11},{62,-11}},           color={0,127,255}));
  connect(hexFVM.port_b1, sin_1.ports[3]) annotation (Line(points={{10,-10},{36,
          -10},{36,49},{60,49}},           color={0,127,255}));
  connect(PIn.y, sou_2.p_in) annotation (Line(points={{81,-122},{102,-122},{102,
          -2},{84,-2}}, color={0,0,127}));
  connect(XIn1.y, sou_2.Xi_in[1]) annotation (Line(points={{81,-40},{96,-40},{
          96,-14},{84,-14}}, color={0,0,127}));
  connect(sou_2.ports[4], hexWetIBPSA.port_a2) annotation (Line(points={{62,-13},
          {40,-13},{40,-86},{10,-86}}, color={0,127,255}));
  connect(sin_2.ports[4], hexWetIBPSA.port_b2) annotation (Line(points={{-44,17},
          {-40,17},{-40,-86},{-10,-86}}, color={0,127,255}));
  connect(sou_1.ports[4], hexWetIBPSA.port_a1) annotation (Line(points={{-42,47},
          {-26,47},{-26,-74},{-10,-74}}, color={0,127,255}));
  connect(hexWetIBPSA.port_b1, sin_1.ports[4]) annotation (Line(points={{10,-74},
          {36,-74},{36,47},{60,47}}, color={0,127,255}));
  annotation(experiment(Tolerance=1e-6, StopTime=360),
__Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Validation/WetCoilEffectivenessNTU_FVM.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This model tests
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU\">
Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU</a>
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
</html>"),
    Diagram(coordinateSystem(extent={{-140,-180},{140,180}})));
end WetCoilEffectivenessNTU_FVM;
