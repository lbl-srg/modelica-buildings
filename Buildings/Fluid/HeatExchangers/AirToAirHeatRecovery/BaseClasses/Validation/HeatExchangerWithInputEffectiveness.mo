within Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.BaseClasses.Validation;
model HeatExchangerWithInputEffectiveness
  "Test model for the heat exchanger with input effectiveness"
  extends Modelica.Icons.Example;
  package Medium1 = Buildings.Media.Air
     "Supply air";
  package Medium2 = Buildings.Media.Air
     "Exhaust air";

  Buildings.Fluid.Sources.Boundary_pT sin_2(
    redeclare package Medium = Medium2,
    p(displayUnit="Pa") = 101325,
    T=273.15 + 10,
    nPorts=1)
    "Ambient"
    annotation (Placement(transformation(extent={{-54,-30},{-34,-10}})));
  Buildings.Fluid.Sources.Boundary_pT sou_2(
    redeclare package Medium = Medium2,
    p(displayUnit="Pa") = 101325 + 100,
    T=566.3,
    nPorts=1)
    "Exhaust air source"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
    Modelica.Blocks.Sources.Ramp TSup(
    height=10,
    duration=60,
    offset=273.15 + 30,
    startTime=120)
    "Supply air temperature"
    annotation (Placement(transformation(extent={{-90,54},{-70,74}})));
  Buildings.Fluid.Sources.Boundary_pT sin_1(
    redeclare package Medium = Medium1,
    T(displayUnit="K") = 273.15 + 30,
    X={0.012,1 - 0.012},
    p(displayUnit="Pa") = 1E5 - 110,
    nPorts=1)
    "Supply air sink"
    annotation (Placement(transformation(extent={{84,2},{64,22}})));
  Buildings.Fluid.Sources.Boundary_pT sou_1(
    redeclare package Medium = Medium1,
    T=273.15 + 50,
    X={0.012,1 - 0.012},
    use_T_in=true,
    p(displayUnit="Pa") = 100000,
    nPorts=1)
    "Supply air source"
    annotation (Placement(transformation(extent={{-48,50},{-28,70}})));
  Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.BaseClasses.HeatExchangerWithInputEffectiveness
    hex(
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
  Modelica.Blocks.Sources.Ramp epsSen(
    height=0.1,
    duration=60,
    offset=0.7,
    startTime=120)
    "Sensible heat exchanger effectiveness"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
  Modelica.Blocks.Sources.Ramp epsLat(
    height=0.1,
    duration=60,
    offset=0.7,
    startTime=60)
    "Latent heat exchanger effectiveness"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
equation
  connect(TSup.y, sou_1.T_in)
    annotation (Line(points={{-69,64},{-50,64}}, color={0,0,127}));
  connect(sou_1.ports[1], hex.port_a1)
    annotation (Line(
    points={{-28,60},{-2,60},{-2,12},{6,12}},
    color={0,127,255}));
  connect(hex.port_a2, sou_2.ports[1])
    annotation (Line(
    points={{26,5.55112e-16},{32,5.55112e-16},{32,-20},{70,-20},{70,-60},{60,
    -60}},color={0,127,255}));
  connect(hex.port_b1, sin_1.ports[1])
    annotation (Line(
    points={{26,12},{45,12},{45,12},{64,12}},
    color={0,127,255}));
  connect(hex.port_b2, sin_2.ports[1])
    annotation (Line(
    points={{6,0},{-26,0},{-26,-20},{-34,-20}},
    color={0,127,255}));
  connect(epsSen.y, hex.epsSen)
    annotation (Line(points={{-69,20},{-4,20},{-4,10},{4,
    10}}, color={0,0,127}));
  connect(hex.epsLat, epsLat.y) annotation (Line(points={{4,2},{-62,2},{-62,-40},{-69,
    -40}}, color={0,0,127}));
 annotation(experiment(Tolerance=1e-6, StopTime=360),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/AirToAirHeatRecovery/BaseClasses/Validation/HeatExchangerWithInputEffectiveness.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.BaseClasses.HeatExchangerWithInputEffectiveness\">
Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.BaseClasses.HeatExchangerWithInputEffectiveness</a>.
</p>
<p>
The input signals are configured as follows:
</p>
<ul>
<li>
Temperature of the supply air, <i>TSup</i>, changes from <i>273.15 + 30 K</i> to <i>273.15 + 40 K</i>
 during the period from <i>120s</i> to <i>180s</i>;
</li>
</ul>
<ul>
<li>Sensible heat exchanger effectiveness, <i>epsSen</i>, changes from <i>0.7</i> to <i>0.8</i>
during the period from <i>120s</i> to <i>180s</i>;
</li>
</ul>
<ul>
<li>
Latent heat exchanger effectiveness, <i>epsLat</i>, changes from <i>0.7</i> to <i>0.8</i>
during the period from <i>60s</i> to <i>120s</i>.
</li>
</ul>
<p>
The expected outputs are:
</p>
<ul>
<li>
The humidity of the supply air and that of the exhaust air leaving the exchanger changes 
during the period from <i>60s</i> to <i>120s</i>;
</li>
</ul>
<ul>
<li>
The temperature of the supply air and that of the exhaust air leaving the exchanger changes 
during the period from <i>120s</i> to <i>180s</i>.
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
end HeatExchangerWithInputEffectiveness;
