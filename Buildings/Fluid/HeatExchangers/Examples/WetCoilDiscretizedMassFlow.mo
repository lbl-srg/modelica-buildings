within Buildings.Fluid.HeatExchangers.Examples;
model WetCoilDiscretizedMassFlow
  "Model of a cooling coil that tests variable mass flow rates"
  extends Modelica.Icons.Example;
  extends
    Buildings.Fluid.HeatExchangers.Examples.BaseClasses.EffectivenessNTUMassFlow(
    sou_1(nPorts=1),
    sin_1(nPorts=1),
    sou_2(nPorts=1),
    sin_2(nPorts=1));

  WetCoilDiscretized hex(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    dp2_nominal(displayUnit="Pa") = 200,
    allowFlowReversal1=true,
    allowFlowReversal2=true,
    dp1_nominal(displayUnit="Pa") = 3000,
    UA_nominal=Q_flow_nominal/Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(
        T_a1_nominal,
        T_b1_nominal,
        T_a2_nominal,
        T_b2_nominal),
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{80,20}, {100,40}})));

  Sensors.RelativeHumidityTwoPort senRelHum(
    redeclare package Medium = Medium2,
    m_flow_nominal=m2_flow_nominal,
    initType=Modelica.Blocks.Types.Init.SteadyState)
    annotation (Placement(transformation(extent={{60,14},{40,34}})));

equation
  connect(sou_1.ports[1], hex.port_a1) annotation (Line(
      points={{18,62},{60,62},{60,36},{80,36}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hex.port_b1, sin_1.ports[1]) annotation (Line(
      points={{100,36},{108,36},{108,60},{120,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hex.port_a2, sou_2.ports[1]) annotation (Line(
      points={{100,24},{118,24}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hex.port_b2, senRelHum.port_a) annotation (Line(
      points={{80,24},{60,24}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senRelHum.port_b, sin_2.ports[1]) annotation (Line(
      points={{40,24},{20,24}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{200,200}})),
experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Examples/WetCoilDiscretizedMassFlow.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This model demonstrates the use of
<a href=\"modelica://Buildings.Fluid.HeatExchangers.WetCoilDiscretized\">
Buildings.Fluid.HeatExchangers.WetCoilDiscretized</a>
for different inlet conditions.
</p>
</html>", revisions="<html>
<ul>
<li>
November 21, 2020, by Michael Wetter:<br/>
Changed tolerance.
</li>
<li>
April 12, 2017, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end WetCoilDiscretizedMassFlow;
