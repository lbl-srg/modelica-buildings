within Buildings.Fluid.HeatExchangers.ThermalWheels.Validation;
model SpeedControlled
  "Test model for the air-to-air thermal wheel with a variable speed drive"
  extends Modelica.Icons.Example;
  package Medium1 = Buildings.Media.Air
    "Supply air";
  package Medium2 = Buildings.Media.Air
    "Exhaust air";
  Buildings.Fluid.Sources.Boundary_pT sin_2(
    redeclare package Medium = Medium2,
    p(displayUnit="Pa") = 101325,
    T(displayUnit="K") = 273.15 + 10,
    nPorts=1)
    "Exhaust air sink"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Buildings.Fluid.Sources.Boundary_pT sou_2(
    redeclare package Medium = Medium2,
    p(displayUnit="Pa") = 101325 + 100,
    T(displayUnit="K") = 293.15,
    nPorts=1)
    "Exhaust air source"
    annotation (Placement(transformation(extent={{80,-40},{60,-20}})));
  Modelica.Blocks.Sources.Ramp TSup(
    height=10,
    duration=60,
    offset=273.15 + 30,
    startTime=60)
    "Supply air temperature"
    annotation (Placement(transformation(extent={{-80,24},{-60,44}})));
  Buildings.Fluid.Sources.Boundary_pT sin_1(
    redeclare package Medium = Medium1,
    T=273.15 + 30,
    X={0.012,1 - 0.012},
    p(displayUnit="Pa") = 101325 - 100,
    nPorts=1)
    "Supply air sink"
    annotation (Placement(transformation(extent={{80,20},{60,40}})));
  Buildings.Fluid.Sources.Boundary_pT sou_1(
    redeclare package Medium = Medium1,
    T=273.15 + 50,
    X={0.012,1 - 0.012},
    use_T_in=true,
    p(displayUnit="Pa") = 101325,
    nPorts=1)
    "Supply air source"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Fluid.HeatExchangers.ThermalWheels.SpeedControlled
    whe(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    m1_flow_nominal=5,
    m2_flow_nominal=5,
    dp1_nominal=100,
    dp2_nominal=100,
    P_nominal=100,
    epsLatCoo_nominal=0.7,
    epsLatCooPL=0.6,
    epsLatHea_nominal=0.7,
    epsLatHeaPL=0.6)
    "Wheel"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Sources.Ramp wheSpe(
    height=0.3,
    duration=160,
    offset=0.7,
    startTime=200)
    "Wheel speed"
    annotation (Placement(transformation(extent={{-78,-10},{-58,10}})));
equation
  connect(TSup.y, sou_1.T_in)
    annotation (Line(points={{-59,34},{-42,34}}, color={0,0,127}));
  connect(sou_1.ports[1],whe. port_a1)
    annotation (Line(points={{-20,30},{-10,30},{-10,6},{0,6}}, color={0,127,255}));
  connect(whe.port_a2, sou_2.ports[1])
    annotation (Line(points={{20,-6},{40,-6},{40,-30},{60,-30}}, color={0,127,255}));
  connect(whe.port_b1, sin_1.ports[1])
    annotation (Line(points={{20,6},{40,6},{40,30},{60,30}}, color={0,127,255}));
  connect(whe.port_b2, sin_2.ports[1])
    annotation (Line(points={{0,-6},{-8,-6},{-8,-30},{-20,-30}},
                                               color={0,127,255}));
  connect(wheSpe.y, whe.uSpe)
    annotation (Line(points={{-57,0},{-2,0}},                       color={0,0,127}));

annotation(experiment(Tolerance=1e-6, StopTime=360),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/ThermalWheels/Validation/SpeedControlled.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
Example for using the block
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ThermalWheels.SpeedControlled\">
Buildings.Fluid.HeatExchangers.ThermalWheels.SpeedControlled</a>.
</p>
<p>
The input signals are configured as follows:
</p>
<ul>
<li>
The supply air temperature <i>TSup</i> changes from <i>273.15 + 30 K</i> to
<i>273.15 + 40 K</i> during the period from 60 seconds to 120 seconds.
The exhaust air temperature remains constant.
</li>
<li>
The wheel speed <i>uSpe</i> changes from <i>0.7</i> to <i>1</i> 
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
<code>epsLat</code>, keep constant before the 200 seconds.
After 200 seconds, both <code>epsSen</code> and <code>epsLat</code> increase.
</li>
<li>
The leaving supply air temperature and the leaving exhaust air temperature 
follow the change of <i>TSup</i> before the 200 seconds.
After 200 seconds, the leaving supply air temperature decreases
and the leaving exhaust air temperature increases.
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
end SpeedControlled;
