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
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Buildings.Fluid.Sources.Boundary_pT sou_2(
    redeclare package Medium = Medium2,
    p(displayUnit="Pa") = 101325 + 100,
    T=566.3,
    nPorts=1)
    "Exhaust air source"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Modelica.Blocks.Sources.Ramp TSup(
    height=10,
    duration=60,
    offset=273.15 + 30,
    startTime=120)
    "Supply air temperature"
    annotation (Placement(transformation(extent={{-80,54},{-60,74}})));
  Buildings.Fluid.Sources.Boundary_pT sin_1(
    redeclare package Medium = Medium1,
    T(displayUnit="K") = 273.15 + 30,
    X={0.012,1 - 0.012},
    p(displayUnit="Pa") = 1E5 - 110,
    nPorts=1)
    "Supply air sink"
    annotation (Placement(transformation(extent={{80,30},{60,50}})));
  Buildings.Fluid.Sources.Boundary_pT sou_1(
    redeclare package Medium = Medium1,
    T=273.15 + 50,
    X={0.012,1 - 0.012},
    use_T_in=true,
    p(displayUnit="Pa") = 100000,
    nPorts=1)
    "Supply air source"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
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
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Modelica.Blocks.Sources.Ramp epsLat(
    height=0.1,
    duration=60,
    offset=0.7,
    startTime=60)
    "Latent heat exchanger effectiveness"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
equation
  connect(TSup.y, sou_1.T_in)
    annotation (Line(points={{-59,64},{-42,64}}, color={0,0,127}));
  connect(sou_1.ports[1], hex.port_a1)
    annotation (Line(points={{-20,60},{-10,60},{-10,12},{6,12}},
                                                               color={0,127,255}));
  connect(hex.port_a2, sou_2.ports[1])
    annotation (Line(points={{26,5.55112e-16},{60,5.55112e-16},{60,-40},{40,-40}},
                           color={0,127,255}));
  connect(hex.port_b1, sin_1.ports[1])
    annotation (Line(points={{26,12},{40,12},{40,40},{60,40}}, color={0,127,255}));
  connect(hex.port_b2, sin_2.ports[1])
    annotation (Line(points={{6,0},{-10,0},{-10,-20},{-20,-20}}, color={0,127,255}));
  connect(epsSen.y, hex.epsSen)
    annotation (Line(points={{-59,20},{-20,20},{-20,10},{4,10}},
                                                               color={0,0,127}));
  connect(hex.epsLat, epsLat.y)
    annotation (Line(points={{4,2},{-50,2},{-50,-40},{-59,-40}}, color={0,0,127}));

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
The supply air temperature <i>TSup</i> changes from <i>273.15 + 30 K</i> to
<i>273.15 + 40 K</i> during the period from 120 seconds to 180 seconds.
</li>
<li>
The sensible heat exchanger effectiveness <i>epsSen</i> changes from <i>0.7</i>
to <i>0.8</i> during the period from 120 seconds to 180 seconds.
</li>
<li>
The latent heat exchanger effectiveness <i>epsLat</i> changes from <i>0.7</i>
to <i>0.8</i> during the period from 60 seconds to 120 seconds.
</li>
</ul>
<p>
The expected outputs are:
</p>
<ul>
<li>
During the period from 60 seconds to 120 seconds, the leaving supply air humidity
decreases while the leaving exhaust air humidity increases.
</li>
<li>
During the period from 120 seconds to 180 seconds, the leaving supply air temperature
increases while the leaving exhaust air temperature decreases.
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
