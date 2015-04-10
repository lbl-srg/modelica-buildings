within Buildings.Fluid.HeatExchangers.Examples;
model DryEffectivenessNTUMassFlow
  "Model of epsilon-NTU dry coil that tests variable mass flow rates"
  extends Modelica.Icons.Example;
  extends
    Buildings.Fluid.HeatExchangers.Examples.BaseClasses.EffectivenessNTUMassFlow(
    sou_1(nPorts=1),
    sin_1(nPorts=1),
    sou_2(nPorts=1),
    sin_2(nPorts=1));

  Buildings.Fluid.HeatExchangers.DryEffectivenessNTU hex(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    dp2_nominal(displayUnit="Pa") = 200,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    allowFlowReversal1=true,
    allowFlowReversal2=true,
    dp1_nominal(displayUnit="Pa") = 3000,
    Q_flow_nominal=Q_flow_nominal,
    T_a1_nominal=T_a1_nominal,
    T_a2_nominal=T_a2_nominal,
    show_T=true)             annotation (Placement(transformation(extent={{82,20},
            {102,40}})));

  Buildings.Fluid.Sensors.RelativeHumidityTwoPort senRelHum(
                                                     redeclare package Medium
      = Medium2, m_flow_nominal=m2_flow_nominal,
    initType=Modelica.Blocks.Types.Init.InitialState)
    annotation (Placement(transformation(extent={{60,14},{40,34}})));
equation
  connect(sou_1.ports[1], hex.port_a1) annotation (Line(
      points={{18,62},{74,62},{74,36},{82,36}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hex.port_b1, sin_1.ports[1]) annotation (Line(
      points={{102,36},{112,36},{112,60},{120,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hex.port_a2, sou_2.ports[1]) annotation (Line(
      points={{102,24},{118,24}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senRelHum.port_a, hex.port_b2) annotation (Line(
      points={{60,24},{82,24}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senRelHum.port_b, sin_2.ports[1]) annotation (Line(
      points={{40,24},{20,24}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{200,200}})),
experiment(StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Examples/DryEffectivenessNTUMassFlow.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This model tests
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DryEffectivenessNTU\">
Buildings.Fluid.HeatExchangers.DryEffectivenessNTU</a>
for different mass flow rates.
</p>
</html>", revisions="<html>
<ul>
<li>
February 12, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end DryEffectivenessNTUMassFlow;
