within Buildings.Fluid.HeatExchangers.Validation;
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
    nPorts=3,
    T=273.15 + 10) "Boundary condition"
    annotation (Placement(transformation(extent={{-64,10},
            {-44,30}})));
  Buildings.Fluid.Sources.Boundary_pT sou_2(
    redeclare package Medium = Medium2,
    use_Xi_in=true,
    T=273.15 + 5,
    use_p_in=true,
    use_T_in=true,
    nPorts=3) "Boundary condition"
    annotation (Placement(transformation(extent={{10,-10},
            {-10,10}}, origin={72,-10})));
    Modelica.Blocks.Sources.Ramp TWat(
    height=10,
    duration=60,
    offset=273.15 + 30,
    startTime=60) "Water temperature"
                 annotation (Placement(transformation(extent={{-100,44},{-80,64}})));
  Modelica.Blocks.Sources.Constant TDb(k=293.15) "Drybulb temperature"
    annotation (Placement(transformation(extent={{60,-78},{80,-58}})));
    Modelica.Blocks.Sources.Constant POut(k=101325)
      annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Buildings.Fluid.Sources.Boundary_pT sin_1(
    redeclare package Medium = Medium1,
    use_p_in=true,
    nPorts=3,
    p=300000,
    T=273.15 + 25)
    "Boundary condition" annotation (Placement(transformation(extent={{80,40},
            {60,60}})));
  Buildings.Fluid.Sources.Boundary_pT sou_1(
    redeclare package Medium = Medium1,
    p=300000 + 5000,
    T=273.15 + 50,
    use_T_in=true,
    nPorts=3)
    "Boundary condition" annotation (Placement(transformation(extent={{-62,40},
            {-42,60}})));

  Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU hexCou(
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
    T_a2_nominal=293.15)
    "Heat exchanger"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  WetEffectivenessNTU_Fuzzy_V2_2_4                       hexWetNtu(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    dp1_nominal=500,
    dp2_nominal=10,
    m1_flow_nominal=m1_flow,
    m2_flow_nominal=m2_flow,
    UA_nominal=13854.5,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CrossFlowStream1UnmixedStream2Mixed,
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
    UA_nominal=13854.5) "Heat exchanger"
    annotation (Placement(transformation(extent={{-10,-26},{10,-6}})));
    Modelica.Blocks.Sources.Ramp XIn1(
    height=30*1e-3,
    duration=60,
    offset=2*1e-3,
    startTime=360) "humidity boundary condition"
                 annotation (Placement(transformation(extent={{60,-46},{80,-26}})));
    Modelica.Blocks.Sources.Ramp PIn(
    height=200,
    duration=60,
    offset=101325,
    startTime=100) "Pressure boundary condition"
                 annotation (Placement(transformation(extent={{60,-106},{80,-86}})));
equation
  connect(TDb.y, sou_2.T_in) annotation (Line(points={{81,-68},{92,-68},{92,-6},
          {84,-6}},  color={0,0,127}));
  connect(TWat.y, sou_1.T_in)
    annotation (Line(points={{-79,54},{-64,54}}, color={0,0,127}));
  connect(POut.y, sin_2.p_in) annotation (Line(
      points={{-79,20},{-69.5,20},{-69.5,28},{-66,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hexCou.port_a1, sou_1.ports[1]) annotation (Line(
      points={{-10,16},{-24,16},{-24,52.6667},{-42,52.6667}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hexWetNtu.port_a1, sou_1.ports[2]) annotation (Line(
      points={{-10,-42},{-28,-42},{-28,50},{-42,50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hexCou.port_b2, sin_2.ports[1]) annotation (Line(
      points={{-10,4},{-32,4},{-32,22.6667},{-44,22.6667}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hexWetNtu.port_b2, sin_2.ports[2]) annotation (Line(
      points={{-10,-54},{-36,-54},{-36,20},{-44,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hexCou.port_b1, sin_1.ports[1]) annotation (Line(
      points={{10,16},{34,16},{34,52.6667},{60,52.6667}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hexWetNtu.port_b1, sin_1.ports[2]) annotation (Line(
      points={{10,-42},{38,-42},{38,50},{60,50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hexCou.port_a2, sou_2.ports[1]) annotation (Line(
      points={{10,4},{36,4},{36,-7.33333},{62,-7.33333}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hexWetNtu.port_a2, sou_2.ports[2]) annotation (Line(
      points={{10,-54},{32,-54},{32,-10},{62,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(trapezoid.y, sin_1.p_in) annotation (Line(
      points={{61,80},{92,80},{92,58},{82,58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou_1.ports[3], hexFVM.port_a1) annotation (Line(points={{-42,47.3333},
          {-20,47.3333},{-20,-10},{-10,-10}}, color={0,127,255}));
  connect(sin_2.ports[3], hexFVM.port_b2) annotation (Line(points={{-44,17.3333},
          {-28,17.3333},{-28,-22},{-10,-22}}, color={0,127,255}));
  connect(hexFVM.port_a2, sou_2.ports[3]) annotation (Line(points={{10,-22},{38,
          -22},{38,-12.6667},{62,-12.6667}}, color={0,127,255}));
  connect(hexFVM.port_b1, sin_1.ports[3]) annotation (Line(points={{10,-10},{36,
          -10},{36,47.3333},{60,47.3333}}, color={0,127,255}));
  connect(PIn.y, sou_2.p_in) annotation (Line(points={{81,-96},{102,-96},{102,
          -2},{84,-2}}, color={0,0,127}));
  connect(XIn1.y, sou_2.Xi_in[1]) annotation (Line(points={{81,-36},{96,-36},{
          96,-14},{84,-14}}, color={0,0,127}));
  annotation(experiment(Tolerance=1e-6, StopTime=360),
__Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Validation/WetCoilEffectivenessNTU.mos"
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
</html>"));
end WetCoilEffectivenessNTU_FVM;
