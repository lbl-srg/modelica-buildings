within Buildings.Examples.Tutorial.SimpleHouse;
model SimpleHouse6 "Free cooling model"
  extends SimpleHouse5(zone(nPorts=2),
    mAir_flow_nominal=0.1,
    A_win=6);

  parameter Modelica.Units.SI.PressureDifference dpAir_nominal=200
    "Pressure drop at nominal mass flow rate for air loop";

  Buildings.Fluid.Actuators.Dampers.Exponential
                                vavDam(
    redeclare package Medium = MediumAir,
    from_dp=true,
    m_flow_nominal=mAir_flow_nominal,
    dpDamper_nominal=dpAir_nominal)
    "Damper" annotation (Placement(transformation(extent={{-10,10},{10,
            -10}}, origin={50,110})));
  Buildings.Fluid.Movers.FlowControlled_dp
                           fan(
    redeclare package Medium = MediumAir,
    show_T=true,
    dp_nominal=dpAir_nominal,
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    nominalValuesDefineDefaultPressureCurve=true,
    m_flow_nominal=mAir_flow_nominal)
                 "Constant head fan" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        origin={-50,110})));
  Modelica.Blocks.Sources.Constant const_dp(k=dpAir_nominal) "Pressure head"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
  Buildings.Fluid.HeatExchangers.ConstantEffectiveness
                                       hexRec(
    redeclare package Medium1 = MediumAir,
    redeclare package Medium2 = MediumAir,
    dp1_nominal=10,
    dp2_nominal=10,
    m1_flow_nominal=mAir_flow_nominal,
    m2_flow_nominal=mAir_flow_nominal,
    eps=0.85)      "Heat exchanger for heat recuperation"
    annotation (Placement(transformation(extent={{-80,104},{-110,136}})));
  Buildings.Fluid.Sources.Boundary_pT
                      bouAir(
    redeclare package Medium = MediumAir,
    use_T_in=true,
    nPorts=2)      "Air boundary with constant temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={-130,130})));
  Modelica.Blocks.Logical.Hysteresis hysAir(uLow=273.15 + 23, uHigh=273.15 + 25)
    "Hysteresis controller for damper"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal1
                                                   "Boolean to real"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
equation
  connect(const_dp.y,fan. dp_in) annotation (Line(points={{-69,80},{-50,80},{
          -50,98}},                                  color={0,0,127}));
  connect(hexRec.port_a1, zone.ports[1]) annotation (Line(points={{-80,129.6},{97,
          129.6},{97,130},{100,130}},     color={0,127,255}));
  connect(bouAir.T_in, weaBus.TDryBul) annotation (Line(points={{-142,134},{
          -150,134},{-150,-10}},color={0,0,127}));
  connect(hexRec.port_b2, fan.port_a) annotation (Line(points={{-80,110.4},{-69,
          110.4},{-69,110},{-60,110}}, color={0,127,255}));
  connect(vavDam.port_b, zone.ports[2]) annotation (Line(points={{60,110},{100,110},
          {100,130}}, color={0,127,255}));
  connect(booleanToReal1.y, vavDam.y)
    annotation (Line(points={{41,80},{50,80},{50,98}}, color={0,0,127}));
  connect(hysAir.y, booleanToReal1.u)
    annotation (Line(points={{1,80},{18,80}}, color={255,0,255}));
  connect(vavDam.port_a, fan.port_b)
    annotation (Line(points={{40,110},{-40,110}}, color={0,127,255}));
  connect(hysAir.u, hysRad.u) annotation (Line(points={{-22,80},{-30,80},{-30,
          160},{-230,160},{-230,-100},{-82,-100}}, color={0,0,127}));
  connect(bouAir.ports[1], hexRec.port_b1) annotation (Line(points={{-120,129},
          {-119,129},{-119,129.6},{-110,129.6}}, color={0,127,255}));
  connect(bouAir.ports[2], hexRec.port_a2) annotation (Line(points={{-120,131},
          {-120,110.4},{-110,110.4}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,
            -220},{200,200}})),
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
from <i>2 m<sup>2</sup> <b>to <i>6 m<sup>2</sup></i></b>.
</p>
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
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ConstantEffectiveness\">
Buildings.Fluid.HeatExchangers.ConstantEffectiveness</a>
</li>
<li>
<a href=\"modelica://Buildings.Fluid.Movers.FlowControlled_dp\">
Buildings.Fluid.Movers.FlowControlled_dp</a>
</li>
<li>
<a href=\"modelica://Buildings.Fluid.Actuators.Dampers.Exponential\">
Buildings.Fluid.Actuators.Dampers.Exponential</a>
</li>
</ul>
<h4>Connection instructions</h4>
<p>
Connect the components such that they exchange mass (and therefore also energy)
with the <code>MixingVolume</code> representing the zone air.
Add a <code>boundary_pT</code> to draw air from the environment.
Enable its temperature input and connect it to the <i>TDryBul</i> variable in the weather data reader.
Also reconsider the nominal mass flow rate parameter value in the <code>MixingVolume</code>
given the flow rate information of the ventilation system.
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
