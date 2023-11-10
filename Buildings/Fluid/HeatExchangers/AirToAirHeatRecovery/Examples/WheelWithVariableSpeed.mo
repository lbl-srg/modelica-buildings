within Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.Examples;
model WheelWithVariableSpeed
  "Test model for the air-to-air thermal wheel with a variable speed drive"
  extends Modelica.Icons.Example;
  package Medium1 = Buildings.Media.Air
    "Medium model for supply air";
  package Medium2 = Buildings.Media.Air
    "Medium model for exhaust air";
  Buildings.Fluid.Sources.Boundary_pT sin_2(
    redeclare package Medium = Medium2,
    p(displayUnit="Pa") = 101325,
    T(displayUnit="K") = 273.15 + 10,
    use_p_in=false,
    nPorts=1)
    "Sink of exhaust air"
    annotation (Placement(transformation(extent={{-58,-10},
            {-38,10}})));
    Modelica.Blocks.Sources.Ramp PIn(
    height=200,
    duration=60,
    offset=101330)
    "Pressure of exhaust air"
    annotation (Placement(transformation(extent={{0,-62},{20,-42}})));
  Buildings.Fluid.Sources.Boundary_pT sou_2(
    redeclare package Medium = Medium2,
    T(displayUnit="K") = 293.15,
    use_p_in=true,
    use_T_in=false,
    nPorts=1)
    "Source of exhaust air"
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
    use_p_in=true,
    p=300000,
    nPorts=1)
    "Sink of supply air"
    annotation (Placement(transformation(extent={{84,2},{
            64,22}})));
  Buildings.Fluid.Sources.Boundary_pT sou_1(
    redeclare package Medium = Medium1,
    T=273.15 + 50,
    X={0.012,1 - 0.012},
    use_T_in=true,
    p=100000,
    nPorts=1)
    "Source of supply air"
    annotation (Placement(transformation(extent={{-60,40},
            {-40,60}})));
    Modelica.Blocks.Sources.Ramp PSin_1(
    duration=60,
    startTime=240,
    height=100,
    offset=1E5 - 110)
    "Pressure of the supply air"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
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
    height=0.1,
    duration=60,
    offset=0.7,
    startTime=60)
    "Wheel speed"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
equation
  connect(PIn.y,sou_2. p_in) annotation (Line(
      points={{21,-52},{38,-52}},
      color={0,0,127}));
  connect(TSup.y, sou_1.T_in)
    annotation (Line(points={{-73,54},{-62,54}}, color={0,0,127}));
  connect(PSin_1.y, sin_1.p_in) annotation (Line(points={{61,70},{90,70},{90,20},
          {86,20}},     color={0,0,127}));
  connect(sou_1.ports[1],whe. port_a1) annotation (Line(
      points={{-40,50},{0,50},{0,12},{6,12}},
      color={0,127,255}));
  connect(whe.port_a2, sou_2.ports[1]) annotation (Line(
      points={{26,5.55112e-16},{32,5.55112e-16},{32,-20},{70,-20},{70,-60},{60,
          -60}},
      color={0,127,255}));
  connect(whe.port_b1, sin_1.ports[1]) annotation (Line(
      points={{26,12},{45,12},{45,12},{64,12}},
      color={0,127,255}));
  connect(whe.port_b2, sin_2.ports[1]) annotation (Line(
      points={{6,5.55112e-16},{-18,5.55112e-16},{-18,6.66134e-16},{-38,
          6.66134e-16}},
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
The test condition is the same as <a href=\"modelica://Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.Examples.WheelWithBypassDamper\">
Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.Examples.WheelWithBypassDamper</a></p>
<b>Note:</b> This problem may fails to translate in Dymola 2012 due to an error in Dymola's support
of stream connector.
</html>", revisions="<html>
<ul>
<li>
September 29, 2023, by Sen Huang:<br/>
First implementation<br/>
</li>
</ul>
</html>"));
end WheelWithVariableSpeed;
