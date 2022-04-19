within Buildings.Templates.ChilledWaterPlant.Components.ChillerSection;
model Series "Model for chillers in series"
  extends
    Buildings.Templates.ChilledWaterPlant.Components.ChillerSection.Interfaces.PartialChillerSection(
     final typ=Buildings.Templates.ChilledWaterPlant.Components.Types.ChillerSection.ChillerSeries,
     final typValChiWatChiSer=valChiWatChi.typ,
     final have_VChiWatRet_flow=pumPri.have_floSen and not pumPri.have_supFloSen);

  inner replaceable Buildings.Templates.ChilledWaterPlant.Components.PrimaryPumps.HeaderedSeries
    pumPri constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.PrimaryPumps.Interfaces.PartialPrimaryPump(
      redeclare final package Medium = MediumChiWat,
      final dat=datPumPri)
    "Chilled water primary pumps"
    annotation (Placement(transformation(extent={{-70,-10},{-90,10}})),
      choices(
        choice(redeclare Buildings.Templates.ChilledWaterPlant.Components.PrimaryPumps.HeaderedSeries
          pumPri "Headered")));

  inner replaceable Buildings.Templates.Components.Valves.TwoWayModulating valChiWatChi[nChi]
    constrainedby Buildings.Templates.Components.Valves.Interfaces.PartialValve(
      redeclare each final package Medium = MediumChiWat,
      final dat=dat.valChiWatChi)
    "Chiller chilled water-side isolation valves"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}})),
      choices(
        choice(redeclare Buildings.Templates.Components.Valves.TwoWayModulating
          valChiWatChi[nChi] "Modulating"),
        choice(redeclare Buildings.Templates.Components.Valves.TwoWayTwoPosition
          valChiWatChi[nChi] "Two-positions")));

  Buildings.Fluid.FixedResistances.Junction splChi[nChi](
    redeclare package Medium = MediumChiWat,
    each energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    each final m_flow_nominal=fill(dat.m2_flow_nominal, 3),
    each final dp_nominal=fill(0, 3))
    "Chiller splitter"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={30,0})));
  Buildings.Fluid.FixedResistances.Junction mixChi[nChi](
    redeclare package Medium = MediumChiWat,
    each energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    each final m_flow_nominal=fill(dat.m2_flow_nominal, 3),
    each final dp_nominal=fill(0, 3)) "Chiller mixer"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-30,0})));

initial equation
  assert(typPumPri == Buildings.Templates.ChilledWaterPlant.Components.Types.PrimaryPump.HeaderedSeries,
        "In "+ getInstanceName() + ": "+
    "The primary pump type selected is incompatible with chillers in series." +
    "The only compatible primary pump type is Headered (Series)");

equation

  connect(valChiWatChi.bus, busCon.valChiWatChi)
    annotation (Line(
      points={{0,10},{0,20},{40,20},{40,80},{0.1,80},{0.1,100.1}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(busCon, pumPri.busCon)
    annotation (Line(
      points={{0,100},{0,80},{-80,80},{-80,10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));

  connect(chi.port_a2,splChi. port_3)
    annotation (Line(points={{20,36},{30,36},{30,10}}, color={0,127,255}));
  connect(chi.port_b2, mixChi.port_3)
    annotation (Line(points={{-20,36},{-30,36},{-30,10}}, color={0,127,255}));
  connect(valChiWatChi.port_b, mixChi.port_2)
    annotation (Line(points={{-10,0},{-20,0}}, color={0,127,255}));
  connect(valChiWatChi.port_a, splChi.port_2)
    annotation (Line(points={{10,0},{15,0},{20,0}}, color={0,127,255}));

  for i in 2:nChi loop
    connect(mixChi[i - 1].port_1, splChi[i].port_1)
      annotation (Line(
        points={{-40,0},{-50,0},{-50,-20},{50,-20},{50,0},{40,0}},
        color={0,127,255}));
  end for;

  connect(splChiByp.port_2, splChi[1].port_1)
    annotation (Line(points={{-70,-60},{-80,-60},{-80,-40},{80,-40},{80,0},{40,0}},
      color={0,127,255}));
  connect(mixByp.port_3, pumPri.port_byp)
    annotation (Line(points={{60,-50},{60,-30},{-80,-30},{-80,-10}},
      color={0,127,255}));
  connect(pumPri.port_ChiByp, splChiByp.port_3)
    annotation (Line(points={{-70,-6},{-60,-6},{-60,-50}},
      color={0,127,255}));
  connect(pumPri.port_a, mixChi[nChi].port_1)
    annotation (Line(points={{-70,0},{-40,0}}, color={0,127,255}));
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
          extent={{58,-54},{100,-66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-66},{-56,-54}},
          lineColor={0,0,127},
          pattern=LinePattern.None,
          fillColor={0,0,127},
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
end Series;
