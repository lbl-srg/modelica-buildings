within Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.BaseClasses.Validation;
model HeatExchagerWithInputEffectiveness
    "Test model for the heat exchanger with input effectiveness"
  extends Modelica.Icons.Example;

  package Medium1 = Buildings.Media.Air
     "Medium of the supply air";
  package Medium2 = Buildings.Media.Air
     "Medium of the exhaust air";

  Buildings.Fluid.Sources.Boundary_pT sin_2(
    redeclare package Medium = Medium2,
    T=273.15 + 10,
    use_p_in=true,
    nPorts=1)
     "Sink that represents the ambient environment"
    annotation (Placement(transformation(extent={{-58,-10}, {-38,10}})));
  Modelica.Blocks.Sources.Constant PIn(
    k=101325 + 100)
     "Pressure of the exhaust air"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Buildings.Fluid.Sources.Boundary_pT sou_2(
    redeclare package Medium = Medium2,
    T=273.15 + 5,
    use_p_in=true,
    use_T_in=true,
    nPorts=1)
     "Source of the exhuast air"
    annotation (Placement(transformation(extent={{40,-70}, {60,-50}})));
  Modelica.Blocks.Sources.Ramp TSup(
    height=10,
    duration=60,
    offset=273.15 + 30,
    startTime=120) "Temperature of the supply air"
    annotation (Placement(transformation(extent={{-100,44},{-80,64}})));
  Modelica.Blocks.Sources.Constant TDb(k=293.15)
    "Drybulb temperature of the exhaust air"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
  Modelica.Blocks.Sources.Constant POut(k=101325)
     "Pressure of the ambient environment"
      annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Buildings.Fluid.Sources.Boundary_pT sin_1(
    redeclare package Medium = Medium1,
    T=273.15 + 30,
    X={0.012,1 - 0.012},
    use_p_in=true,
    p=300000,
    nPorts=1)
     "Sink of the supply air"
    annotation (Placement(transformation(extent={{84,2},{64,22}})));
  Buildings.Fluid.Sources.Boundary_pT sou_1(
    redeclare package Medium = Medium1,
    T=273.15 + 50,
    X={0.012,1 - 0.012},
    use_T_in=true,
    p=100000,
    nPorts=1)
     "Source of the supply air"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Sources.Constant PSin_1(
    k=1E5 - 110)
    "Pressure of the exhaust air"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.BaseClasses.HeatExchagerWithInputEffectiveness hex(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    m1_flow(start=5),
    m2_flow(start=5),
    m1_flow_nominal=5,
    m2_flow_nominal=5,
    dp1_nominal=100,
    dp2_nominal=100,
    show_T=true)
     "Heat exchanger"
    annotation (Placement(transformation(extent={{6,-4},{26,16}})));
  Modelica.Blocks.Sources.Ramp epsS(
    height=0.1,
    duration=60,
    offset=0.7,
    startTime=120)
     "Sensible heat exchanger effectiveness"
    annotation (Placement(transformation(extent={{20,60},{0,80}})));
  Modelica.Blocks.Sources.Ramp epsL(
    height=0.1,
    duration=60,
    offset=0.7,
    startTime=60)
     "Latent heat exchanger effectiveness"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
equation
  connect(PIn.y,sou_2. p_in) annotation (Line(
      points={{1,-40},{20,-40},{20,-52},{38,-52}},
      color={0,0,127}));
  connect(TDb.y, sou_2.T_in) annotation (Line(points={{1,-80},{20,-80},{20,-56},
          {38,-56}}, color={0,0,127}));
  connect(TSup.y, sou_1.T_in)
    annotation (Line(points={{-79,54},{-62,54}}, color={0,0,127}));
  connect(PSin_1.y, sin_1.p_in) annotation (Line(points={{61,70},{90,70},{90,20},
          {86,20}},     color={0,0,127}));
  connect(sou_1.ports[1], hex.port_a1) annotation (Line(
      points={{-40,50},{0,50},{0,12},{6,12}},
      color={0,127,255}));
  connect(hex.port_a2, sou_2.ports[1]) annotation (Line(
      points={{26,5.55112e-16},{32,5.55112e-16},{32,-20},{70,-20},{70,-60},{60,
          -60}},
      color={0,127,255}));
  connect(POut.y, sin_2.p_in) annotation (Line(
      points={{-79,10},{-68,10},{-68,8},{-60,8}},
      color={0,0,127}));
  connect(hex.port_b1, sin_1.ports[1]) annotation (Line(
      points={{26,12},{45,12},{45,12},{64,12}},
      color={0,127,255}));
  connect(hex.port_b2, sin_2.ports[1]) annotation (Line(
      points={{6,5.55112e-16},{-18,5.55112e-16},{-18,6.66134e-16},{-38,
          6.66134e-16}},
      color={0,127,255}));
  connect(epsS.y, hex.epsS) annotation (Line(points={{-1,70},{-24,70},{-24,10},
          {4,10}}, color={0,0,127}));
  connect(hex.epsL, epsL.y) annotation (Line(points={{4,2},{-32,2},{-32,-50},{-39,
          -50}}, color={0,0,127}));
 annotation(experiment(Tolerance=1e-6, StopTime=360),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/AirToAirHeatRecovery/BaseClasses/Validation/HeatExchagerWithInputEffectiveness.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.BaseClasses.HeatExchagerWithInputEffectiveness\">
Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.BaseClasses.HeatExchagerWithInputEffectiveness</a>.
</p>
<p>
The input signals are configured as follows:
</p>
<ul>
<li>
Temperature of the supply air, <i>TSup</i>, changes from <i>273.15 + 30 K</i>
to <i>273.15 + 40 K</i> during the period from <i>120s</i> to <i>180s</i>.
</li>
<li>
Sensible heat exchanger effectiveness, <i>epsS</i>, changes from <i>0.7</i>
to <i>0.8</i> during the period from <i>120s</i> to <i>180s</i>.
</li>
<li>
Latent heat exchanger effectiveness, <i>epsL</i>, changes from <i>0.7</i> to
<i>0.8</i> during the period from <i>60s</i> to <i>120s</i>.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
September 29, 2023, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end HeatExchagerWithInputEffectiveness;
