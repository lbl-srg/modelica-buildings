within Buildings.Fluid.HeatExchangers.Examples;
model DryCoilCounterFlowMassFlow
  "Model of a cooling coil that tests variable mass flow rates"
  extends Modelica.Icons.Example;
  extends
    Buildings.Fluid.HeatExchangers.Examples.BaseClasses.EffectivenessNTUMassFlow(
    sou_1(nPorts=1),
    sin_1(nPorts=1),
    sou_2(nPorts=1),
    sin_2(nPorts=1));

  DryCoilCounterFlow hex(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    show_T=true,
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
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
                             annotation (Placement(transformation(extent={{70,20},
            {90,40}})));

  Sensors.RelativeHumidityTwoPort senRelHum(         redeclare package Medium
      = Medium2, m_flow_nominal=m2_flow_nominal)
    annotation (Placement(transformation(extent={{60,14},{40,34}})));
equation
  connect(sou_1.ports[1], hex.port_a1) annotation (Line(
      points={{18,62},{60,62},{60,36},{70,36}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hex.port_b1, sin_1.ports[1]) annotation (Line(
      points={{90,36},{90,60},{120,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hex.port_a2, sou_2.ports[1]) annotation (Line(
      points={{90,24},{118,24}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senRelHum.port_a, hex.port_b2) annotation (Line(
      points={{60,24},{70,24}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senRelHum.port_b, sin_2.ports[1]) annotation (Line(
      points={{40,24},{32,24},{32,24},{20,24}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{200,200}})),
experiment(StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Examples/DryCoilCounterFlowMassFlow.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This model demonstrates the use of
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DryCoilCounterFlow\">
Buildings.Fluid.HeatExchangers.DryCoilCounterFlow</a>
for different inlet conditions.
</p>
</html>", revisions="<html>
<ul>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
May 27, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end DryCoilCounterFlowMassFlow;
