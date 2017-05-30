within Buildings.ChillerWSE.BaseClasses;
model PartialIntegratedPrimary
  "Integrated WSE for Primary Chilled Water System"
  extends Buildings.ChillerWSE.BaseClasses.PartialChillerWSE;

  Fluid.Movers.SpeedControlled_y fan
    annotation (Placement(transformation(extent={{-60,-70},{-80,-50}})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage val3
    annotation (Placement(transformation(extent={{-20,-90},{-40,-70}})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage val1
    annotation (Placement(transformation(extent={{-20,-50},{-40,-30}})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage val2
    annotation (Placement(transformation(extent={{40,-50},{20,-30}})));
equation
  connect(port_a2, val2.port_a) annotation (Line(points={{100,-60},{60,-60},{60,
          -40},{40,-40}}, color={0,127,255}));
  connect(wse.port_a2, val2.port_a) annotation (Line(points={{40,-6},{60,-6},{
          60,-40},{40,-40}}, color={0,127,255}));
  connect(wse.port_b2, val1.port_a) annotation (Line(points={{20,-6},{0,-6},{0,
          -40},{-20,-40}}, color={0,127,255}));
  connect(val2.port_b, val1.port_a)
    annotation (Line(points={{20,-40},{0,-40},{-20,-40}}, color={0,127,255}));
  connect(val1.port_b, fan.port_a) annotation (Line(points={{-40,-40},{-50,-40},
          {-50,-60},{-60,-60}}, color={0,127,255}));
  connect(fan.port_b, port_b2)
    annotation (Line(points={{-80,-60},{-100,-60}}, color={0,127,255}));
  connect(chiPar.port_b2, fan.port_a) annotation (Line(points={{-40,-6},{-50,-6},
          {-50,-60},{-60,-60}}, color={0,127,255}));
  connect(TSet, wse.TSet) annotation (Line(points={{-120,-20},{-92,-20},{-70,
          -20},{-70,20},{4,20},{4,-1.4},{18,-1.4}}, color={0,0,127}));
  connect(wse.port_b2, chiPar.port_a2)
    annotation (Line(points={{20,-6},{0,-6},{-20,-6}}, color={0,127,255}));
  connect(val1.port_a, val3.port_a) annotation (Line(points={{-20,-40},{-8,-40},
          {0,-40},{0,-80},{-20,-80}}, color={0,127,255}));
  connect(val3.port_b, port_b2) annotation (Line(points={{-40,-80},{-86,-80},{
          -86,-60},{-100,-60},{-100,-60}}, color={0,127,255}));
end PartialIntegratedPrimary;
