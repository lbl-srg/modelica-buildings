within Buildings.Templates.BaseClasses.WatersideEconomizer;
model NoEconomizer
  extends Buildings.Templates.Interfaces.ChilledWaterReturnSection(
    final typ=Buildings.Templates.Types.WatersideEconomizer.NoEconomizer)
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
  PassThroughFluid pas2 "Passthrough for Medium2"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  PassThroughFluid pas1 "Passthrough for Medium1"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
equation
  connect(port_a2, pas2.port_b)
    annotation (Line(points={{100,-60},{10,-60}}, color={0,127,255}));
  connect(pas2.port_a, port_b2)
    annotation (Line(points={{-10,-60},{-100,-60}}, color={0,127,255}));
  connect(port_a1, pas1.port_a)
    annotation (Line(points={{-100,60},{-10,60}}, color={0,127,255}));
  connect(pas1.port_b, port_b1)
    annotation (Line(points={{10,60},{100,60}}, color={0,127,255}));
  annotation (Icon(graphics={Line(
          points={{-102,-60},{100,-60}},
          color={28,108,200},
          thickness=1), Line(
          points={{100,60},{-100,60}},
          color={28,108,200},
          thickness=1)}));
end NoEconomizer;
