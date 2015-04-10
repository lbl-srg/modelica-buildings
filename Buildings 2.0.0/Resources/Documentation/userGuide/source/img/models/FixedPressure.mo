within models;
model FixedPressure
  extends PartialFluidLoop(vol(nPorts=3));
  Buildings.Fluid.Sources.FixedBoundary bou(nPorts=1)
    annotation (Placement(transformation(extent={{-32,30},{-12,50}})));
equation
  connect(vol.ports[1], bou.ports[1]) annotation (Line(
      points={{30,20},{30,20},{28,20},{28,20},{28,20},{28,14},{-4,14},{-4,40},{-12,
          40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol.ports[2], fan.port_a) annotation (Line(
      points={{30,20},{30,20},{30,10},{-60,10},{-60,-40},{-20,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res.port_b, vol.ports[3]) annotation (Line(
      points={{40,-40},{60,-40},{60,10},{32,10},{32,20},{30,20}},
      color={0,127,255},
      smooth=Smooth.None));
end FixedPressure;
