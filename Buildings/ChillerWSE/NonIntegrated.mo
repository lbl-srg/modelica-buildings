within Buildings.ChillerWSE;
model NonIntegrated
  "Non-integrated chilled and WSE cooling system for data centers"
  extends Buildings.ChillerWSE.BaseClasses.PartialChillerWSE;

equation
  connect(port_a2, wse.port_a2) annotation (Line(points={{100,-60},{80,-60},{80,
          24},{60,24}},          color={0,127,255}));
  connect(port_a2, chiPar.port_a2) annotation (Line(points={{100,-60},{-8,-60},
          {-8,24},{-40,24}},color={0,127,255}));
  connect(wse.port_b2, port_b2) annotation (Line(points={{40,24},{0,24},{0,-50},
          {-72,-50},{-72,-60},{-100,-60}}, color={0,127,255}));
  connect(chiPar.port_b2, port_b2) annotation (Line(points={{-60,24},{-72,24},{
          -72,-60},{-100,-60}},                 color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end NonIntegrated;
