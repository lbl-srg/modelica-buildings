within Buildings.ChillerWSE;
model IntegratedPrimary
  "Integrated chiller and WSE only for primary chilled water system"
  extends Buildings.Fluid.Interfaces.PartialFourPort;
  constant Boolean primary_only
    "Flag, true if this model is used in primary chilled water system";

  Fluid.Chillers.ElectricEIR chi[nChi]
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-20,22})));
  Fluid.HeatExchangers.ConstantEffectiveness wse
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=180,
        origin={50,20})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage val1 annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={50,-40})));
  Fluid.Movers.SpeedControlled_y priPum
    annotation (Placement(transformation(extent={{-60,-50},{-80,-30}})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage valChi2 annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-46,-10})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage valWSE2 annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={20,-10})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage val2 annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-20,-40})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage val3 annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-20,-80})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage valChi1 annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={0,44})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage valWSE1 annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={80,44})));
equation
  for i in 1:nChi loop
  end for;
  connect(port_a2, wse.port_a2) annotation (Line(points={{100,-60},{100,-40},{
          80,-40},{80,14},{60,14}}, color={0,127,255}));
  connect(chi[1].port_a2, val1.port_b) annotation (Line(points={{-10,16},{0,16},
          {0,-40},{40,-40}}, color={0,127,255}));
  connect(val1.port_a, port_a2) annotation (Line(points={{60,-40},{60,-40},{100,
          -40},{100,-60}}, color={0,127,255}));
  connect(priPum.port_b, port_b2) annotation (Line(points={{-80,-40},{-90,-40},
          {-90,-60},{-100,-60}}, color={0,127,255}));
  connect(chi[1].port_b2, valChi2.port_a)
    annotation (Line(points={{-30,16},{-46,16},{-46,0}}, color={0,127,255}));
  connect(valChi2.port_b, priPum.port_a) annotation (Line(points={{-46,-20},{-46,
          -20},{-46,-36},{-46,-40},{-60,-40}}, color={0,127,255}));
  connect(wse.port_b2, valWSE2.port_a)
    annotation (Line(points={{40,14},{20,14},{20,0}}, color={0,127,255}));
  connect(valWSE2.port_b, val1.port_b)
    annotation (Line(points={{20,-20},{20,-40},{40,-40}}, color={0,127,255}));
  connect(val1.port_b, val2.port_a)
    annotation (Line(points={{40,-40},{20,-40},{-10,-40}}, color={0,127,255}));
  connect(val2.port_b, priPum.port_a) annotation (Line(points={{-30,-40},{-46,
          -40},{-60,-40}}, color={0,127,255}));
  connect(val1.port_b, val3.port_a) annotation (Line(points={{40,-40},{20,-40},
          {20,-80},{-10,-80}}, color={0,127,255}));
  connect(val3.port_b, port_b2) annotation (Line(points={{-30,-80},{-90,-80},{
          -90,-60},{-100,-60}}, color={0,127,255}));
  connect(port_a1, wse.port_a1) annotation (Line(points={{-100,60},{-80,60},{
          -80,80},{20,80},{20,26},{40,26}}, color={0,127,255}));
  connect(wse.port_b1, valWSE1.port_a)
    annotation (Line(points={{60,26},{80,26},{80,34}}, color={0,127,255}));
  connect(valWSE1.port_b, port_b1)
    annotation (Line(points={{80,54},{80,60},{100,60}}, color={0,127,255}));
  connect(chi[1].port_a1, port_a1) annotation (Line(points={{-30,28},{-46,28},{
          -46,80},{-80,80},{-80,60},{-100,60}},          color={0,127,255}));
  connect(chi[1].port_b1, valChi1.port_a) annotation (Line(points={{-10,28},{-6,
          28},{0,28},{0,34}}, color={0,127,255}));
  connect(valChi1.port_b, port_b1)
    annotation (Line(points={{0,54},{0,60},{100,60}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end IntegratedPrimary;
