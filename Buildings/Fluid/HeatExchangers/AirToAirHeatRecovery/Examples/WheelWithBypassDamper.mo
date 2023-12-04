within Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.Examples;
model WheelWithBypassDamper
  "Test model for the air-to-air thermal wheel with bypass dampers"
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
    "Exhaust air sink"
    annotation (Placement(transformation(extent={{-58,-10},
    {-38,10}})));
  Buildings.Fluid.Sources.Boundary_pT sou_2(
    redeclare package Medium = Medium2,
    p(displayUnit="Pa") = 101325 + 100,
    T(displayUnit="K") = 293.15,
    nPorts=1)
    "Exhaust air source"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Modelica.Blocks.Sources.Ramp TSup(
    height=10,
    duration=60,
    offset=273.15 + 30,
    startTime=60)
    "Supply air temperature"
    annotation (Placement(transformation(extent={{-94,44},{-74,64}})));
  Buildings.Fluid.Sources.Boundary_pT sin_1(
    redeclare package Medium = Medium1,
    T=273.15 + 30,
    X={0.012,1 - 0.012},
    p(displayUnit="Pa") = 101325 - 100,
    nPorts=1)
    "Supply air sink"
    annotation (Placement(transformation(extent={{84,2},{64,22}})));
  Buildings.Fluid.Sources.Boundary_pT sou_1(
    redeclare package Medium = Medium1,
    T=273.15 + 50,
    X={0.012,1 - 0.012},
    use_T_in=true,
    p(displayUnit="Pa") = 101325,
    nPorts=1)
    "Supply air source"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.WheelWithBypassDamper whe(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    m1_flow_nominal=5,
    m2_flow_nominal=5,
    dp1_nominal(displayUnit="Pa") = 100,
    dp2_nominal(displayUnit="Pa") = 100,
    epsLatCoo_nominal=0.7,
    epsLatCooPL=0.6,
    epsLatHea_nominal=0.7,
    epsLatHeaPL=0.6)
    "Wheel"
    annotation (Placement(transformation(extent={{6,-4},{26,16}})));
  Modelica.Blocks.Sources.Ramp bypDamPos(
    height=0.2,
    duration=160,
    offset=0,
    startTime=200)
    "Bypass damper position"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
equation
  connect(TSup.y, sou_1.T_in)
    annotation (Line(points={{-73,54},{-62,54}}, color={0,0,127}));
  connect(sou_1.ports[1],whe.port_a1)
    annotation (Line(points={{-40,50},{0,50},{0,12},{6,12}}, color={0,127,255}));
  connect(whe.port_a2, sou_2.ports[1])
    annotation (Line(points={{26,0},{32,0},{32,-20},{70,-20},{70,-60},{60,-60}},
        color={0,127,255}));
  connect(whe.port_b1, sin_1.ports[1])
    annotation (Line(points={{26,12},{45,12},{45,12},{64,12}},
        color={0,127,255}));
  connect(whe.port_b2, sin_2.ports[1])
    annotation (Line(points={{6,0},{-18,0},{-18,6.66134e-16},{-38,6.66134e-16}},
        color={0,127,255}));
  connect(bypDamPos.y, whe.bypDamPos)
    annotation (Line(points={{-59,-30},{-28,-30},{-28,6},{4,6}},
        color={0,0,127}));

annotation(experiment(Tolerance=1e-6, StopTime=360),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/AirToAirHeatRecovery/Examples/WheelWithBypassDamper.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Example for using the block
<a href=\"modelica://Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.WheelWithBypassDamper\">
Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.WheelWithBypassDamper</a>.
</p>
<p>
The input signals are configured as follows:
</p>
<ul>
<li>
The supply air temperature <i>TSup</i> changes from <i>273.15 + 30 K</i> to
<i>273.15 + 40 K</i> during the period from 60 seconds to 120 seconds.
The exhaust air temperature keeps constant.
</li>
<li>
The bypass damper position <i>bypDamPos</i> changes from <i>0</i> to <i>0.2</i> 
during the period from 200 seconds to 360 seconds.
</li>
<li>
The supply air flow rate and the exhaust air flow rate are constant.
</li>
</ul>
<p>
The expected outputs are:
</p>
<ul>
<li>
The sensible effectiveness <code>epsSen</code> and the latent effectiveness 
<code>epsLat</code> keep constant in the first 200 seconds.
After the 200s</i>, both <code>epsSen</code> and <code>epsLat</code> decrease.
</li>
<li>
The temperatures of the leaving supply air and the leaving the exhaust air 
follows the change of <i>TSup</i> before 200 seconds.
After the 200 seconds, the leaving supply air temperature increases and the
leaving exhaust air temperature decreases.
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
end WheelWithBypassDamper;
