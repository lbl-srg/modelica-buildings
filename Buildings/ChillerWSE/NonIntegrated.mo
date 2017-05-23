within Buildings.ChillerWSE;
model NonIntegrated
  "Non-integrated chilled and WSE cooling system for data centers"
  extends Buildings.ChillerWSE.BaseClasses.PartialChillerWSE;

equation
  connect(port_a2, wse.port_a2) annotation (Line(points={{100,-60},{80,-60},{60,
          -60},{60,-6},{40,-6}}, color={0,127,255}));
  connect(port_a2, chiPar.port_a2) annotation (Line(points={{100,-60},{-8,-60},{
          -8,-6},{-20,-6}}, color={0,127,255}));
  connect(wse.port_b2, port_b2) annotation (Line(points={{20,-6},{0,-6},{0,-50},
          {-80,-50},{-80,-60},{-100,-60}}, color={0,127,255}));
  connect(chiPar.port_b2, port_b2) annotation (Line(points={{-40,-6},{-60,-6},{-60,
          -50},{-80,-50},{-80,-60},{-100,-60}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end NonIntegrated;
