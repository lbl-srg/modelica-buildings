within Buildings.Templates.ChilledWaterPlant.Components.ChillerSection;
model Parallel "Model for chillers in parallel"
  extends
    Buildings.Templates.ChilledWaterPlant.Components.ChillerSection.Interfaces.PartialChillerSection(
     final typ=Buildings.Templates.ChilledWaterPlant.Components.Types.ChillerSection.ChillerParallel,
     final typValChiWatChiSer=pumPri.typValChiWatChiPar,
     final have_VChiWatRet_flow=pumPri.have_floSen and not pumPri.have_supFloSen);

  inner replaceable Buildings.Templates.ChilledWaterPlant.Components.PrimaryPumps.HeaderedParallel
    pumPri constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.PrimaryPumps.Interfaces.PartialPrimaryPump(
      redeclare final package Medium = MediumChiWat,
      final dat=datPumPri)
    "Chilled water primary pumps"
    annotation (Placement(transformation(extent={{-50,30},{-70,50}})));

  Buildings.Fluid.Delays.DelayFirstOrder volChiWat(
    redeclare final package Medium = MediumChiWat,
    final m_flow_nominal=dat.m2_flow_nominal,
    nPorts=nChi+1)
    "Chilled water side mixing volume"
    annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},rotation=270,origin={90,0})));

initial equation
  assert(typPumPri <> Buildings.Templates.ChilledWaterPlant.Components.Types.PrimaryPump.HeaderedSeries,
    "In "+ getInstanceName() + ": "+
    "The primary pump type selected is incompatible with chillers in parallel." +
    "Compatible primary pump types are Dedicated or Headered (Parallel)");

equation

  connect(busCon, pumPri.busCon)
    annotation (Line(
      points={{0,100},{0,80},{-60,80},{-60,50}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));

  connect(splChiByp.port_2, volChiWat.ports[1])
    annotation (Line(points={{-70,-60},{-80,-60},{-80,-20},{66,-20},{66,0},{80,0}},
      color={0,127,255}));
  connect(chi.port_a2, volChiWat.ports[2:nChi+1])
    annotation (Line(points={{20,36},{66,36},{66,0},{80,0}},
      color={0,127,255}));

  connect(pumPri.port_byp, mixByp.port_3)
    annotation (Line(points={{-60,30},{-60,0},{60,0},{60,-50}},
      color={0,127,255}));
  connect(splChiByp.port_3, pumPri.port_ChiByp)
    annotation (Line(points={{-60,-50},{-60,-40},{-40,-40},{-40,34},{-50,34}},
      color={0,127,255}));
  connect(chi.port_b2, pumPri.ports_a)
    annotation (Line(points={{-20,36},{-36,36},{-36,40},{-50,40}},
      color={0,127,255}));
  connect(pumPri.port_b, port_b2)
    annotation (Line(points={{-70,40},{-86,40},{-86,-60},{-100,-60}},
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
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-66},{-56,-54}},
          lineColor={0,0,127},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid)}));
end Parallel;
