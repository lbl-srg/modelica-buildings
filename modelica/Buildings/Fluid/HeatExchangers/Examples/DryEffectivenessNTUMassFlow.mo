within Buildings.Fluid.HeatExchangers.Examples;
model DryEffectivenessNTUMassFlow
  "Model of epsilon-NTU dry coil that tests variable mass flow rates"
  import Buildings;
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
    T_a2_nominal=T_a2_nominal)
                             annotation (Placement(transformation(extent={{40,20},
            {60,40}},     rotation=0)));

equation
  connect(sou_1.ports[1], hex.port_a1) annotation (Line(
      points={{18,62},{28,62},{28,36},{40,36}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hex.port_b1, sin_1.ports[1]) annotation (Line(
      points={{60,36},{90,36},{90,60},{120,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hex.port_a2, sou_2.ports[1]) annotation (Line(
      points={{60,24},{118,24}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin_2.ports[1], hex.port_b2) annotation (Line(
      points={{-22,24},{40,24}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senRelHum.port, hex.port_b2) annotation (Line(
      points={{10,-16},{40,-16},{40,24}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{200,200}}), graphics), Commands(file=
          "DryEffectivenessNTUMassFlow.mos" "run"));
end DryEffectivenessNTUMassFlow;
