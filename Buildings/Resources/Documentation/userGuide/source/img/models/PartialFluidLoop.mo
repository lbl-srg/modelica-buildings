within models;
model PartialFluidLoop
  Buildings.Fluid.Movers.FlowControlled_m_flow fan
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Modelica.Blocks.Sources.Constant const
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Fluid.FixedResistances.PressureDrop res
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Buildings.Fluid.MixingVolumes.MixingVolume vol
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
equation
  connect(const.y, fan.m_flow_in) annotation (Line(
      points={{-19,-10},{-10,-10},{-10,-28},{-10.2,-28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fan.port_b, res.port_a) annotation (Line(
      points={{4.44089e-16,-40},{20,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-80,-60},
            {80,60}}),         graphics), Icon(coordinateSystem(extent={{-80,
            -60},{80,60}})));
end PartialFluidLoop;
