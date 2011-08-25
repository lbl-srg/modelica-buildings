within Buildings.Examples.TestProblems;
model Suite2
  "Model of a suite consisting of five rooms of the MIT system model"
  package Medium = Modelica.Media.Air.SimpleAir;
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{260,160},{280,180}})));
  Fluid.MixingVolumes.MixingVolume           ple(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    V=1,
    nPorts=2) "Plenum volume"
                          annotation (extent=[-10,-70; 10,-50], Placement(
        transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={10,0})));
  Fluid.FixedResistances.FixedResistanceDpM r(
    redeclare package Medium = Medium,
    dp_nominal=20,
    from_dp=true,
    m_flow_nominal=1,
    linearized=false,
    allowFlowReversal=true)
                   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={20,42})));
  Fluid.MixingVolumes.MixingVolume           vol(
    redeclare package Medium = Medium,
    nPorts=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=1,
    V=1) "Room volume"    annotation (extent=[-10,-10; 10,10], Placement(
        transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={10,82})));
  Fluid.FixedResistances.FixedResistanceDpM r11(
    redeclare package Medium = Medium,
    dp_nominal=20,
    from_dp=true,
    m_flow_nominal=1,
    linearized=false,
    allowFlowReversal=true)
                   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,130})));
  Fluid.FixedResistances.FixedResistanceDpM r12(
    redeclare package Medium = Medium,
    dp_nominal=20,
    from_dp=true,
    m_flow_nominal=1,
    linearized=false,
    allowFlowReversal=true)
                   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={52,140})));
  Fluid.FixedResistances.FixedResistanceDpM r13(
    redeclare package Medium = Medium,
    dp_nominal=20,
    from_dp=true,
    m_flow_nominal=1,
    linearized=false,
    allowFlowReversal=true)
                   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,140})));
  Fluid.FixedResistances.SplitterFixedResistanceDpM spl(
    redeclare package Medium = Medium,
    m_flow_nominal={1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    dynamicBalance=false,
    dp_nominal=20*{1,1,1}) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={20,-40})));
equation
  connect(vol.ports[1], r.port_a)     annotation (Line(
      points={{20,80},{20,66},{20,52},{20,52}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(r13.port_b, r11.port_b) annotation (Line(
      points={{0,140},{20,140}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(r11.port_b, r12.port_b) annotation (Line(
      points={{20,140},{42,140}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(r11.port_a, vol.ports[2]) annotation (Line(
      points={{20,120},{20,84}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(r.port_b, ple.ports[1]) annotation (Line(
      points={{20,32},{20,15},{20,15},{20,-2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ple.ports[2], spl.port_3) annotation (Line(
      points={{20,2},{20,-30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(spl.port_2, r13.port_a) annotation (Line(
      points={{10,-40},{-40,-40},{-40,140},{-20,140}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(spl.port_1, r12.port_a) annotation (Line(
      points={{30,-40},{80,-40},{80,140},{62,140}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{300,200}}), graphics),
                       Icon(
      Rectangle(extent=[-98,-38; 284,-42],   style(
          color=69,
          gradient=2,
          fillColor=69)),
      Rectangle(extent=[-102,122; 284,118],  style(
          color=69,
          gradient=2,
          fillColor=69)),
      Rectangle(extent=[-18,22; 284,18],     style(
          color=69,
          gradient=2,
          fillColor=69)),
      Rectangle(extent=[-20,118; -16,-38],
                                         style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=69,
          rgbfillColor={0,128,255})),
      Rectangle(extent=[40,118; 44,-38], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=69,
          rgbfillColor={0,128,255})),
      Rectangle(extent=[102,118; 106,-38], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=69,
          rgbfillColor={0,128,255})),
      Rectangle(extent=[160,118; 164,20], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=69,
          rgbfillColor={0,128,255})),
      Rectangle(extent=[220,120; 224,22], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=69,
          rgbfillColor={0,128,255})),
      Rectangle(extent=[220,-20; 224,-38], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=69,
          rgbfillColor={0,128,255})),
      Rectangle(extent=[160,-8; 164,-38], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=69,
          rgbfillColor={0,128,255})),
      Rectangle(extent=[220,18; 224,-10], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=69,
          rgbfillColor={0,128,255})),
      Rectangle(extent=[160,20; 164,0], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=69,
          rgbfillColor={0,128,255})),
      Rectangle(extent=[162,4; 194,0],       style(
          color=69,
          gradient=2,
          fillColor=69)),
      Rectangle(extent=[190,-18; 224,-22],   style(
          color=69,
          gradient=2,
          fillColor=69)),
      Rectangle(extent=[160,-8; 224,-12],    style(
          color=69,
          gradient=2,
          fillColor=69)),
      Rectangle(extent=[190,2; 194,-20], style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=69,
          rgbfillColor={0,128,255})),
      Text(
        extent=[-140,234; -96,192],
        style(color=3, rgbcolor={0,0,255}),
        string="PAtm"),
      Line(points=[-136,180; 190,180; 252,180],style(color=3, rgbcolor={0,0,255})),
      Line(points=[192,180; 192,40; 222,20], style(color=3, rgbcolor={0,0,255})),
      Rectangle(extent=[216,78; 230,58], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=74,
          rgbfillColor={0,0,127})),
      Rectangle(extent=[156,78; 170,58], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=74,
          rgbfillColor={0,0,127})),
      Rectangle(extent=[96,78; 110,58],  style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=74,
          rgbfillColor={0,0,127})),
      Rectangle(extent=[34,78; 48,58], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=74,
          rgbfillColor={0,0,127})),
      Rectangle(extent=[-26,78; -12,58],
                                       style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=74,
          rgbfillColor={0,0,127})),
      Line(points=[132,180; 132,40; 162,20], style(color=3, rgbcolor={0,0,255})),
      Line(points=[72,180; 72,40; 102,20],   style(color=3, rgbcolor={0,0,255})),
      Line(points=[12,180; 12,40; 42,20], style(color=3, rgbcolor={0,0,255})),
      Line(points=[-48,180; -48,40; -18,20],style(color=3, rgbcolor={0,0,255})),
      Rectangle(extent=[280,120; 284,-40],style(
          color=3,
          rgbcolor={0,0,255},
          gradient=1,
          fillColor=69,
          rgbfillColor={0,128,255})),
      Rectangle(extent=[276,78; 290,58], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=74,
          rgbfillColor={0,0,127})),
      Line(points=[252,180; 252,40; 282,20], style(color=3, rgbcolor={0,0,255})),
      Text(
        extent=[296,158; 340,84],
        style(color=3, rgbcolor={0,0,255}),
        string="dPSup"),
      Text(
        extent=[38,222; 166,190],
        style(color=3, rgbcolor={0,0,255}),
        string="%name"),
      Text(
        extent=[298,66; 342,-8],
        style(color=3, rgbcolor={0,0,255}),
        string="yDam"),
      Text(
        extent=[296,230; 340,156],
        style(color=3, rgbcolor={0,0,255}),
        string="dPRoo")),
    Documentation(info="<html>
<p>
Model of a suite consisting of five rooms for the MIT system model.
</p></html>", revisions="<html>
<ul>
<li>
July 20, 2007 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    Coordsys(extent=[-100,-100; 300,200],
      grid=[2,2],
      scale=2));
end Suite2;
