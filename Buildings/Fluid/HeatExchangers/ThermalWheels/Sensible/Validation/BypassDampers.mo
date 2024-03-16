within Buildings.Fluid.HeatExchangers.ThermalWheels.Sensible.Validation;
model BypassDampers
  "Test model for the sensible heat recovery wheel with bypass dampers"
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
    annotation (Placement(transformation(extent={{-80,-44},{-60,-24}})));
  Buildings.Fluid.Sources.Boundary_pT sou_2(
    redeclare package Medium = Medium2,
    p(displayUnit="Pa") = 101325 + 500,
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
    annotation (Placement(transformation(extent={{-80,64},{-60,84}})));
  Buildings.Fluid.Sources.Boundary_pT sin_1(
    redeclare package Medium = Medium1,
    T=273.15 + 30,
    X={0.012,1 - 0.012},
    p(displayUnit="Pa") = 101325 - 500,
    nPorts=1)
    "Supply air sink"
    annotation (Placement(transformation(extent={{90,20},{70,40}})));
  Buildings.Fluid.Sources.Boundary_pT sou_1(
    redeclare package Medium = Medium1,
    T=273.15 + 50,
    X={0.012,1 - 0.012},
    use_T_in=true,
    p(displayUnit="Pa") = 101325,
    nPorts=1)
    "Supply air source"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Fluid.HeatExchangers.ThermalWheels.Sensible.BypassDampers whe(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    m1_flow_nominal=5,
    m2_flow_nominal=5,
    dp1_nominal(displayUnit="Pa"),
    dp2_nominal(displayUnit="Pa"),
    P_nominal=100) "Wheel"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Sources.Ramp bypDamPos(
    height=0.2,
    duration=160,
    offset=0,
    startTime=200)
    "Bypass damper position"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse opeSig(
    width=0.8,
    period=400,
    shift=72) "Operating signal"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senExhTem(
    redeclare package Medium = Medium2,
    m_flow_nominal=5)
    "Temperature of the exhaust air"
    annotation (Placement(transformation(extent={{-30,-44},{-50,-24}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senSupTem(
    redeclare package Medium = Medium1,
    m_flow_nominal=5)
    "Temperature of the supply air"
    annotation (Placement(transformation(extent={{60,20},{40,40}})));
equation
  connect(TSup.y, sou_1.T_in)
    annotation (Line(points={{-59,74},{-42,74}}, color={0,0,127}));
  connect(sou_1.ports[1],whe.port_a1)
    annotation (Line(points={{-20,70},{-14,70},{-14,6},{0,6}},
    color={0,127,255}));
  connect(whe.port_a2, sou_2.ports[1])
    annotation (Line(points={{20,-6},{40,-6},{40,-30},{60,-30}}, color={0,127,255}));
  connect(bypDamPos.y, whe.uBypDamPos) annotation (Line(points={{-59,0},{-2,0}},
    color={0,0,127}));
  connect(opeSig.y, whe.uRot) annotation (Line(points={{-58,30},{-10,30},{-10,8},
          {-2,8}}, color={255,0,255}));
  connect(whe.port_b2, senExhTem.port_a) annotation (Line(points={{0,-6},{-20,-6},
          {-20,-34},{-30,-34}}, color={0,127,255}));
  connect(senExhTem.port_b, sin_2.ports[1])
    annotation (Line(points={{-50,-34},{-60,-34}}, color={0,127,255}));
  connect(senSupTem.port_a, sin_1.ports[1])
    annotation (Line(points={{60,30},{70,30}}, color={0,127,255}));
  connect(senSupTem.port_b, whe.port_b1) annotation (Line(points={{40,30},{30,30},
          {30,6},{20,6}}, color={0,127,255}));
annotation(experiment(Tolerance=1e-6, StopTime=360),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/ThermalWheels/Sensible/Validation/BypassDampers.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Example for using the block
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ThermalWheels.Sensible.BypassDampers\">
Buildings.Fluid.HeatExchangers.ThermalWheels.Sensible.BypassDampers</a>.
</p>
<p>
The input signals are configured as follows:
</p>
<ul>
<li>
The operating signal <i>opeSig</i> changes from <code>false</code> to <code>true</code> at 72 seconds.
</li>
<li>
The supply air temperature <i>TSup</i> changes from <i>273.15 + 30 K</i> to
<i>273.15 + 40 K</i> during the period from 60 seconds to 120 seconds.
The exhaust air temperature remains constant.
</li>
<li>
The bypass damper position <i>uBypDamPos</i> changes from <i>0</i> to <i>0.2</i> 
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
The sensible heat exchanger effectiveness <code>eps</code> is 0 at the beginning.
They become positive at 72 seconds and keep constant until 200 seconds.
After the 200 seconds, it decrease.
</li>
<li>
Before 72 seconds, the temperature of the leaving supply air is equal to <i>TSup</i>.
Likewise, the temperature of the leaving exhaust air is equal to that of the entering exhaust
air temperature.
The temperatures of the leaving supply air and the leaving exhaust air 
follow the change of <i>TSup</i> during the period from 72 seconds to 200 seconds.
After 200 seconds, the leaving supply air temperature increases and the
leaving exhaust air temperature decreases.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
January 8, 2024, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end BypassDampers;
