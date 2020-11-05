within models;
model NoPressureReference
  extends PartialFluidLoop(vol(nPorts=2));
equation
  connect(vol.ports[1], fan.port_a) annotation (Line(
      points={{30,20},{30,10},{-60,10},{-60,-40},{-20,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol.ports[2], res.port_b) annotation (Line(
      points={{30,20},{32,20},{32,10},{60,10},{60,-40},{40,-40}},
      color={0,127,255},
      smooth=Smooth.None));
end NoPressureReference;
