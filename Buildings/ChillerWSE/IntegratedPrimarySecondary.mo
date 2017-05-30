within Buildings.ChillerWSE;
model IntegratedPrimarySecondary
  "Integrated chiller and WSE for primary-secondary chilled water system"
  extends Buildings.ChillerWSE.BaseClasses.PartialChillerWSE;

  Fluid.Actuators.Valves.TwoWayEqualPercentage val2
    annotation (Placement(transformation(extent={{40,-70},{20,-50}})));
  Fluid.Movers.SpeedControlled_y pum
    annotation (Placement(transformation(extent={{-60,-70},{-80,-50}})));
equation
  connect(port_a2, val2.port_a)
    annotation (Line(points={{100,-60},{70,-60},{40,-60}}, color={0,127,255}));
  connect(val2.port_b, chiPar.port_a2) annotation (Line(points={{20,-60},{-10,
          -60},{-10,-6},{-20,-6}}, color={0,127,255}));
  connect(wse.port_a2, port_a2) annotation (Line(points={{40,-6},{60,-6},{60,
          -60},{100,-60}}, color={0,127,255}));
  connect(wse.port_b2, chiPar.port_a2)
    annotation (Line(points={{20,-6},{0,-6},{-20,-6}}, color={0,127,255}));
  connect(chiPar.port_a2, port_b2) annotation (Line(points={{-20,-6},{-10,-6},{
          -10,-8},{-10,-80},{-86,-80},{-86,-60},{-100,-60}}, color={0,127,255}));
  connect(pum.port_b, port_b2)
    annotation (Line(points={{-80,-60},{-100,-60}}, color={0,127,255}));
  connect(chiPar.port_b2, pum.port_a) annotation (Line(points={{-40,-6},{-50,-6},
          {-50,-60},{-60,-60}}, color={0,127,255}));
  connect(TSet, wse.TSet) annotation (Line(points={{-120,-20},{-86,-20},{-70,
          -20},{-70,22},{4,22},{4,-1.4},{18,-1.4}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end IntegratedPrimarySecondary;
