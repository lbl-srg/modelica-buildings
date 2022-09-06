within Buildings.Templates.ChilledWaterPlants.Components.ChillerSection;
model Parallel "Model for chillers in parallel"
  extends
    Buildings.Templates.ChilledWaterPlants.Components.ChillerSection.Interfaces.PartialChillerSection(
    final typ=Buildings.Templates.ChilledWaterPlants.Components.Types.ChillerSection.ChillerParallel,
    final typValChiWatChiIso=pumPri.typValChiWatChiIso,
    final have_VChiWatRet_flow=pumPri.have_floSen and not pumPri.have_supFloSen);

  inner replaceable
    Buildings.Templates.ChilledWaterPlants.Components.PumpsPrimary.HeaderedParallel
    pumPri constrainedby
    Buildings.Templates.ChilledWaterPlants.Components.PumpsPrimary.Interfaces.PartialPrimaryPump(
    redeclare final package Medium = MediumChiWat,
    final nChi=nChi,
    final dat=datPumPri) "Primary pumps" annotation (Placement(transformation(
          extent={{-70,-10},{-90,10}})), choices(choice(redeclare
          Buildings.Templates.ChilledWaterPlants.Components.PumpsPrimary.Dedicated
          pumPri "Dedicated primary pumps"), choice(redeclare
          Buildings.Templates.ChilledWaterPlants.Components.PumpsPrimary.HeaderedParallel
          pumPri "Headered primary pumps")));

  Buildings.Fluid.Delays.DelayFirstOrder volChiWat(
    redeclare final package Medium = MediumChiWat,
    final m_flow_nominal=dat.m2_flow_nominal,
    final nPorts=nChi+1)
    "CHW side mixing volume"
    annotation (Placement(transformation(
      extent={{-10,10},{10,-10}},rotation=270,origin={50,0})));

initial equation
  assert(pumPri.typ <> Buildings.Templates.ChilledWaterPlants.Components.Types.PrimaryPump.HeaderedSeries,
    "In " + getInstanceName() + ": " +
    "The primary pump type selected is incompatible with chillers in parallel. "
     + "Compatible primary pump types are Dedicated or Headered (Parallel)");

equation

  connect(bus, pumPri.busCon) annotation (Line(
      points={{0,100},{0,80},{-80,80},{-80,10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));

  connect(splChiWatChiByp.port_2, volChiWat.ports[1])
    annotation (Line(points={{-70,-60},{-80,-60},{-80,-40},{80,-40},{80,0},{60,0},
          {60,-1.9984e-15}},
      color={0,127,255}));
  connect(chi.port_a2, volChiWat.ports[2:nChi+1])
    annotation (Line(points={{20,36},{80,36},{80,0},{70,0},{70,-1.9984e-15},{60,
          -1.9984e-15}},
      color={0,127,255}));

  connect(pumPri.port_minFloByp, mixMinFlowByp.port_3)
    annotation (Line(points={{-80,-10},{-80,-30},{60,-30},{60,-50}},
      color={0,127,255}));
  connect(splChiWatChiByp.port_3, pumPri.port_chiWatChiByp)
    annotation (Line(points={{-60,-50},{-60,-6},{-70,-6}},
      color={0,127,255}));
  connect(chi.port_b2, pumPri.ports_a)
    annotation (Line(points={{-20,36},{-30,36},{-30,0},{-70,0}},
      color={0,127,255}));
  connect(pumPri.port_b, port_b2)
    annotation (Line(points={{-90,0},{-94,0},{-94,-60},{-100,-60}},
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
