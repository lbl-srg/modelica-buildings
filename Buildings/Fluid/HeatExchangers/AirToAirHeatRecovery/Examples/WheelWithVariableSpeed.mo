within Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.Examples;
model WheelWithVariableSpeed
  "Test model for the air-to-air thermal wheel with a variable speed drive"
  extends Modelica.Icons.Example;
  package Medium1 = Buildings.Media.Air
    "Medium model for the supply air";
  package Medium2 = Buildings.Media.Air
    "Medium model for the exhaust air";
  Buildings.Fluid.Sources.Boundary_pT sin_2(
    redeclare package Medium = Medium2,
    p(displayUnit="Pa") = 101325,
    T(displayUnit="K") = 273.15 + 10,
    use_p_in=false,
    nPorts=1)
    "Sink of the exhaust air"
    annotation (Placement(transformation(extent={{-58,-10},{-38,10}})));
  Buildings.Fluid.Sources.Boundary_pT sou_2(
    redeclare package Medium = Medium2,
    p(displayUnit="Pa") = 101325 + 100,
    T(displayUnit="K") = 293.15,
    use_p_in=false,
    use_T_in=false,
    nPorts=1) "Source of the exhaust air"
    annotation (Placement(transformation(extent={{40,-70},
    {60,-50}})));
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
    use_p_in=false,
    p(displayUnit="Pa") = 101325 - 100,
    nPorts=1)
    "Sink of the supply air"
    annotation (Placement(transformation(extent={{84,2},{
    64,22}})));
  Buildings.Fluid.Sources.Boundary_pT sou_1(
    redeclare package Medium = Medium1,
    T=273.15 + 50,
    X={0.012,1 - 0.012},
    use_T_in=true,
    p(displayUnit="Pa") = 101325,
    nPorts=1)
    "Source of the supply air"
    annotation (Placement(transformation(extent={{-60,40},
    {-40,60}})));
  Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.WheelWithVariableSpeed
    whe(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    m1_flow_nominal=5,
    m2_flow_nominal=5,
    dp1_nominal=100,
    dp2_nominal=100,
    epsLatCoo_nominal=0.7,
    epsLatCoo_ParLoa=0.6,
    epsLatHea_nominal=0.7,
    epsLatHea_ParLoa=0.6) "Wheel"
    annotation (Placement(transformation(extent={{6,-4},{26,16}})));
    Modelica.Blocks.Sources.Ramp WheSpe(
    height=0.3,
    duration=160,
    offset=0.7,
    startTime=200)
    "Wheel speed"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
equation
  connect(TSup.y, sou_1.T_in)
    annotation (Line(points={{-73,54},{-62,54}}, color={0,0,127}));
  connect(sou_1.ports[1],whe. port_a1)
    annotation (Line(
      points={{-40,50},{0,50},{0,12},{6,12}},
      color={0,127,255}));
  connect(whe.port_a2, sou_2.ports[1])
    annotation (Line(
      points={{26,5.55112e-16},{32,5.55112e-16},{32,-20},{70,-20},{70,-60},{60,
      -60}},color={0,127,255}));
  connect(whe.port_b1, sin_1.ports[1])
    annotation (Line(
      points={{26,12},{45,12},{45,12},{64,12}},
      color={0,127,255}));
  connect(whe.port_b2, sin_2.ports[1])
    annotation (Line(
      points={{6,5.55112e-16},{-18,5.55112e-16},{-18,0},{-38,0}},
      color={0,127,255}));
  connect(WheSpe.y, whe.wheSpe) annotation (Line(points={{-59,-30},{-28,-30},{-28,
      6},{4,6}}, color={0,0,127}));
 annotation(experiment(Tolerance=1e-6, StopTime=360),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/AirToAirHeatRecovery/Examples/WheelWithVariableSpeed.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Example for using the block
<a href=\"modelica://Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.WheelWithVariableSpeed\">
Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.WheelWithVariableSpeed</a>.
</p>
<p>
The input signals are configured as follows:
</p>
<ul>
<li>
The temperature of the supply air, <i>TSup</i>, changes from <i>273.15 + 30 K</i> to <i>273.15 + 40 K</i> 
during the period from <i>60s</i> to <i>120s</i>.
On the other hand, the temperature of the exhaust air is constant;
</li>
</ul>
<ul>
<li>
The wheel spead ratio, <i>wheSpe</i>, changes from <i>0.7</i> to <i>1</i> 
during the period from <i>200s</i> to <i>360s</i>;
</li>
</ul>
<ul>
<li>
The supply air flow rate and the exhaust air flow rate are constant.
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
end WheelWithVariableSpeed;
