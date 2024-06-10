within Buildings.Examples.Tutorial.SimpleHouse;
model SimpleHouse6 "Free cooling model"
  extends SimpleHouse5(
    zon(nPorts=2),
    mAir_flow_nominal=0.1,
    AWin=6);

  parameter Modelica.Units.SI.PressureDifference dpAir_nominal=200
    "Pressure drop at nominal mass flow rate for air loop";

  Buildings.Fluid.Actuators.Dampers.Exponential vavDam(
    redeclare package Medium = MediumAir,
    from_dp=true,
    m_flow_nominal=mAir_flow_nominal,
    dpDamper_nominal=dpAir_nominal)
    "Damper" annotation (Placement(transformation(extent={{-10,10},{10,
            -10}}, origin={110,130})));
  Fluid.Movers.Preconfigured.FlowControlled_dp fan(
    redeclare package Medium = MediumAir,
    show_T=true,
    dp_nominal=dpAir_nominal,
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=mAir_flow_nominal)
    "Constant head fan" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        origin={0,130})));

  Buildings.Fluid.HeatExchangers.ConstantEffectiveness hexRec(
    redeclare package Medium1 = MediumAir,
    redeclare package Medium2 = MediumAir,
    dp1_nominal=10,
    dp2_nominal=10,
    m1_flow_nominal=mAir_flow_nominal,
    m2_flow_nominal=mAir_flow_nominal,
    eps=0.85) "Heat exchanger for heat recuperation"
    annotation (Placement(transformation(extent={{-55,124},{-85,156}})));
  Buildings.Fluid.Sources.Boundary_pT bouAir(
    redeclare package Medium = MediumAir,
    use_T_in=true,
    nPorts=2) "Air boundary with constant temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={-110,140})));
  Modelica.Blocks.Logical.Hysteresis hysAir(uLow=273.15 + 23, uHigh=273.15 + 25)
    "Hysteresis controller for damper"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={50,110})));
  Modelica.Blocks.Math.BooleanToReal booRea2 "Boolean to real"
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Modelica.Blocks.Math.BooleanToReal booRea3(realTrue=dpAir_nominal)
    "Boolean to real"
    annotation (Placement(transformation(extent={{30,80},{10,100}})));
equation
  connect(hexRec.port_a1, zon.ports[1]) annotation (Line(points={{-55,149.6},{169,
          149.6},{169,50},{170,50}},     color={0,127,255}));
  connect(bouAir.T_in, weaBus.TDryBul) annotation (Line(points={{-122,144},{-130,
          144},{-130,0}},       color={0,0,127}));
  connect(vavDam.port_b, zon.ports[2]) annotation (Line(points={{120,130},{142,130},
          {142,50},{170,50}},
                           color={0,127,255}));
  connect(booRea2.y, vavDam.y)
    annotation (Line(points={{101,90},{110,90},{110,118}}, color={0,0,127}));
  connect(hysAir.y, booRea2.u)
    annotation (Line(points={{50,99},{50,90},{78,90}}, color={255,0,255}));
  connect(vavDam.port_a, fan.port_b)
    annotation (Line(points={{100,130},{10,130}}, color={0,127,255}));
  connect(bouAir.ports[1], hexRec.port_a2) annotation (Line(points={{-100,139},{
          -100,130.4},{-85,130.4}},   color={0,127,255}));
  connect(fan.port_a, hexRec.port_b2) annotation (Line(points={{-10,130},{-32,130},
          {-32,130.4},{-55,130.4}}, color={0,127,255}));
  connect(hexRec.port_b1, bouAir.ports[2]) annotation (Line(points={{-85,149.6},
          {-100,149.6},{-100,141}}, color={0,127,255}));
  connect(booRea1.y, pum.m_flow_in) annotation (Line(points={{21,-150},{100,
          -150},{100,-168}}, color={0,0,127}));
  connect(hysAir.u, hysRad.u) annotation (Line(points={{50,122},{50,170},{-210,
          170},{-210,-110},{-82,-110}}, color={0,0,127}));
  connect(booRea3.y, fan.dp_in)
    annotation (Line(points={{9,90},{0,90},{0,118}}, color={0,0,127}));
  connect(booRea3.u, hysAir.y)
    annotation (Line(points={{32,90},{50,90},{50,99}}, color={255,0,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,
            -220},{220,220}})),
    experiment(Tolerance=1e-6, StopTime=1e+06),
    Documentation(revisions="<html>
<ul>
<li>
September 4, 2023, by Jelger Jansen:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
For this last exercise, we first increase the <b>window size</b>
from <i>2 m<sup>2</sup></i> <b>to <i>6 m<sup>2</sup></i></b>.
</p>
<p>
We will add a ventilation model that allows to perform free cooling
using outside air when solar irradiation heats up the room too much.
The system consists of a fan, a damper, a controller with an air temperature setpoint
between <i>23°C</i> and <i>25°C</i>,
and a heat recovery unit with a constant effectiveness of <i>85%</i>.
The damper and fan have a nominal pressure drop/raise of <i>200 Pa</i>.
The heat recovery unit has a nominal pressure drop of <i>10 Pa</i> at both sides.
The nominal mass flow rate of the ventilation system is <i>0.1 kg/s</i>.
</p>
<h4>Required models</h4>
<ul>
<li>
<a href=\"modelica://Buildings.Fluid.Actuators.Dampers.Exponential\">
Buildings.Fluid.Actuators.Dampers.Exponential</a>
</li>
<li>
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ConstantEffectiveness\">
Buildings.Fluid.HeatExchangers.ConstantEffectiveness</a>
</li>
<li>
<a href=\"modelica://Buildings.Fluid.Movers.Preconfigured.FlowControlled_dp\">
Buildings.Fluid.Movers.Preconfigured.FlowControlled_dp</a>
</li>
<li>
<a href=\"modelica://Buildings.Fluid.Sources.Boundary_pT\">
Buildings.Fluid.Sources.Boundary_pT</a>
</li>
<li>
<a href=\"modelica://Modelica.Blocks.Logical.Hysteresis\">
Modelica.Blocks.Logical.Hysteresis</a>
</li>
<li>
<a href=\"modelica://Modelica.Blocks.Math.BooleanToReal\">
Modelica.Blocks.Math.BooleanToReal</a>
</li>
</ul>
<h4>Connection instructions</h4>
<p>
Connect the components such that they exchange mass (and therefore also energy)
with the <code>MixingVolume</code> representing the zone air.
Add a <code>boundary_pT</code> to draw air from the environment.
Enable its temperature input and connect it to the <code>TDryBul</code> variable in the weather data reader.
Also reconsider the nominal mass flow rate parameter value in the <code>MixingVolume</code>
given the flow rate information of the ventilation system.
Finally, make sure that the fan is only active when the damper is open.
</p>
<h4>Reference result</h4>
<p>
The figures below show the results.
</p>
<p align=\"center\">
<img alt=\"Air temperature as function of time.\"
src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/SimpleHouse/result6.png\" width=\"1000\"/>
</p>
<p align=\"center\">
<img alt=\"Ventilation control signal as function of time.\"
src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/SimpleHouse/result7.png\" width=\"1000\"/>
</p>
</html>"),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Examples/Tutorial/SimpleHouse/SimpleHouse6.mos"
        "Simulate and plot"));
end SimpleHouse6;
