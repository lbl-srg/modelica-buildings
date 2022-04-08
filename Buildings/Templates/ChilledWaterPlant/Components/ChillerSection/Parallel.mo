within Buildings.Templates.ChilledWaterPlant.Components.ChillerSection;
model Parallel "Model for chillers in parallel"
  extends
    Buildings.Templates.ChilledWaterPlant.Components.ChillerSection.Interfaces.PartialChillerSection(
     final typ=Buildings.Templates.ChilledWaterPlant.Components.Types.ChillerSection.ChillerParallel);

  inner replaceable Buildings.Templates.Components.Valves.TwoWayModulating valChiWatChi[nChi]
    if not have_dedChiWatPum
    constrainedby Buildings.Templates.Components.Valves.Interfaces.PartialValve(
      redeclare each final package Medium = MediumChiWat,
      final dat = dat.valChiWatChi)
    "Chiller chilled water side isolation valves"
    annotation (Placement(
      transformation(extent={{10,-10},{-10,10}},origin={-70,-80})),
      choices(
        choice(redeclare replaceable
          Buildings.Templates.Components.Valves.TwoWayModulating
          valConWatChi "Modulating"),
        choice(redeclare replaceable
          Buildings.Templates.Components.Valves.TwoWayTwoPosition
          valConWatChi "Two-positions")));

  Buildings.Templates.BaseClasses.PassThroughFluid pasChiWatChi[nChi](
    redeclare each final package Medium = MediumChiWat)
    if have_dedChiWatPum
    "Chiller chilled water side passthrough"
    annotation (Placement(transformation(extent={{-60,-50},{-80,-30}})));

  Buildings.Fluid.Delays.DelayFirstOrder volChiWat(
    redeclare final package Medium = MediumChiWat,
    final m_flow_nominal=dat.m2_flow_nominal,
    nPorts=nChi+1)
    "Chilled water side mixing volume"
    annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},rotation=180,origin={40,-80})));

equation

  connect(port_a2, volChiWat.ports[1])
    annotation (Line(points={{100,-60},{40,-60},{40,-70}},
      color={0,127,255}));
  connect(chi.port_a2, volChiWat.ports[2:nChi+1])
    annotation (Line(points={{20,-12},{40,-12},{40,-70}},
      color={0,127,255}));

  connect(ports_b2, valChiWatChi.port_b) annotation (Line(points={{-100,-60},{-90,
          -60},{-90,-80},{-80,-80}}, color={0,127,255}));
  connect(valChiWatChi.port_a, chi.port_b2) annotation (Line(points={{-60,-80},{
          -50,-80},{-50,-60},{-40,-60},{-40,-12},{-20,-12}}, color={0,127,255}));
  connect(chi.port_b2, pasChiWatChi.port_a) annotation (Line(points={{-20,-12},{
          -40,-12},{-40,-60},{-50,-60},{-50,-40},{-60,-40}}, color={0,127,255}));
  connect(pasChiWatChi.port_b, ports_b2) annotation (Line(points={{-80,-40},{-90,
          -40},{-90,-60},{-100,-60}}, color={0,127,255}));
  connect(valChiWatChi.bus, busCon.valChiWatChi) annotation (Line(
      points={{-70,-70},{-70,-50},{-30,-50},{-30,40},{0.1,40},{0.1,100.1}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Icon(graphics={
        Rectangle(
          extent={{-70,80},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{58,-54},{100,-66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-68,-56},{-56,-92}},
          lineColor={0,0,127},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{58,54},{100,66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,52},{-40,12}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,2},{-52,12},{-32,12},{-42,2}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,2},{-52,-10},{-32,-10},{-42,2}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,-10},{-40,-50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{38,52},{42,-50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,-50},{58,-68}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{18,24},{62,-18}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,24},{22,-8},{58,-8},{40,24}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,66},{-56,54}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,52},{-40,12}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,2},{-52,12},{-32,12},{-42,2}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,2},{-52,-10},{-32,-10},{-42,2}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,-10},{-40,-50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{38,52},{42,-50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,70},{58,52}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{18,24},{62,-18}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,24},{22,-8},{58,-8},{40,24}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end Parallel;
