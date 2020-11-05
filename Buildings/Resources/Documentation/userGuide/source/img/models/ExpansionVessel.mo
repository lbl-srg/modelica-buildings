within models;
model ExpansionVessel
  extends PartialFluidLoop(vol(nPorts=3));
  Buildings.Fluid.Storage.ExpansionVessel exp
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
equation
  connect(vol.ports[2], fan.port_a) annotation (Line(
      points={{30,20},{30,20},{30,10},{-60,10},{-60,-40},{-20,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res.port_b, vol.ports[3]) annotation (Line(
      points={{40,-40},{60,-40},{60,10},{32,10},{32,20},{30,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(exp.port_a, vol.ports[1]) annotation (Line(
      points={{0,30},{0,14},{28,14},{28,20},{30,20}},
      color={0,127,255},
      smooth=Smooth.None));

end ExpansionVessel;
