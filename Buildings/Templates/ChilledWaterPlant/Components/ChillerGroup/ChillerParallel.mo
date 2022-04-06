within Buildings.Templates.ChilledWaterPlant.Components.ChillerGroup;
model ChillerParallel
  extends
    Buildings.Templates.ChilledWaterPlant.Components.ChillerGroup.Interfaces.PartialChillerGroup(
      final typ=Buildings.Templates.ChilledWaterPlant.Components.Types.ChillerGroup.ChillerParallel);

  inner replaceable
    Buildings.Templates.ChilledWaterPlant.Components.Chiller.ElectricChiller
    chi[nChi] constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.Chiller.Interfaces.PartialChiller(
    dat=dat.chi,
    redeclare each final package Medium1 = MediumConWat,
    redeclare each final package Medium2 = MediumChiWat)
    "Chillers"
      annotation (Placement(transformation(extent={{
            -20,-20},{20,20}}, rotation=0)));

  Fluid.Delays.DelayFirstOrder volChiWat(
    redeclare final package Medium = MediumChiWat,
    final m_flow_nominal=dat.m2_flow_nominal,
    nPorts=nChi+1)
    "Chilled water side mixing volume"
    annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},rotation=180,
                                             origin={60,-80})));
  Fluid.Delays.DelayFirstOrder volConWat(
    redeclare final package Medium = MediumConWat,
    final m_flow_nominal=dat.m1_flow_nominal,
    final nPorts=1+nChi) if not isAirCoo
    "Condenser water side mixing volume"
    annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},rotation=0,origin={60,80})));

  // FIXME: Bind have_sen to configuration parameter.
  // FIXME: Bind have_sen to configuration parameter.
equation

  connect(busCon.chi, chi.bus) annotation (Line(
      points={{0.1,100.1},{0.1,100},{0,100},{0,20}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));

  connect(volConWat.ports[1], port_b1)
    annotation (Line(points={{60,70},{60,60},{100,60}},
    color={0,127,255}));
  connect(chi.port_b1, volConWat.ports[2:3])
    annotation (Line(points={{20,12},{60,12},{60,70}},
    color={0,127,255}));
  connect(chi.port_a1, ports_a1) annotation (Line(points={{-20,12},{-60,12},{
          -60,60},{-100,60}}, color={0,127,255}));
  connect(ports_b2, chi.port_b2) annotation (Line(points={{-100,0},{-60,0},{-60,
          -12},{-20,-12}}, color={0,127,255}));

  connect(port_a2, volChiWat.ports[1])
    annotation (Line(points={{100,-60},{60,-60},{60,-70}},
      color={0,127,255}));
  connect(chi.port_a2, volChiWat.ports[2:nChi+1])
    annotation (Line(points={{20,-12},{60,-12},{60,-70}},
      color={0,127,255}));
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
end ChillerParallel;
