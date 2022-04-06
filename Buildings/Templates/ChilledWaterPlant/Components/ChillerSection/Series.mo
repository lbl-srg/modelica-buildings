within Buildings.Templates.ChilledWaterPlant.Components.ChillerSection;
model Series "Model for chillers in series"
  extends
    Buildings.Templates.ChilledWaterPlant.Components.ChillerSection.Interfaces.PartialChillerSection(
     final typ=Buildings.Templates.ChilledWaterPlant.Components.Types.ChillerSection.ChillerSeries);

  inner replaceable Buildings.Templates.Components.Valves.TwoWayModulating valChiWatChi[nChi]
    constrainedby
    Buildings.Templates.Components.Valves.Interfaces.PartialValve(
    redeclare each final package Medium = MediumChiWat,
    each final m_flow_nominal=dat.m2_flow_nominal/nChi,
    each final dpValve_nominal=dat.dpChiWatChiValve_nominal)
    "Chiller chilled water-side isolation valves"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={0,-60})));

  Fluid.FixedResistances.Junction splChi[nChi](
    redeclare package Medium = MediumChiWat,
    each energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    each final m_flow_nominal=fill(dat.m2_flow_nominal, 3),
    each final dp_nominal=fill(0, 3))
    "Chiller splitter"              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={60,-60})));
  Fluid.FixedResistances.Junction mixChi[nChi](
    redeclare package Medium = MediumChiWat,
    each energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    each final m_flow_nominal=fill(dat.m2_flow_nominal, 3),
    each final dp_nominal=fill(0, 3)) "Chiller mixer"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-60,-60})));

equation

  connect(chi.port_a2,splChi. port_3)
    annotation (Line(points={{20,-12},{60,-12},{60,-50}},
      color={0,127,255}));
  connect(chi.port_b2, mixChi.port_3)
    annotation (Line(points={{-20,-12},{-60,-12},{-60,-50}},
      color={0,127,255}));
  connect(valChiWatChi.port_b, mixChi.port_2)
    annotation (Line(points={{-10,-60},{-50,-60}}, color={0,127,255}));
  connect(valChiWatChi.port_a, splChi.port_2)
    annotation (Line(points={{10,-60},{50,-60}}, color={0,127,255}));
  connect(port_a2,splChi[1].port_1)
    annotation (Line(points={{100,-60},{70,-60}}, color={0,127,255}));
  connect(mixChi[nChi].port_1, port_b2)
    annotation (Line(points={{-70,-60},{-100,-60}}, color={0,127,255}));

  for i in 2:nChi loop
    connect(mixChi[i - 1].port_1, splChi[i].port_1)
      annotation (Line(
        points={{-70,-60},{-80,-60},{-80,-80},{80,-80},{80,-60},{70,-60}},
        color={0,127,255}));
  end for;

  connect(valChiWatChi.bus, busCon.valChiWatChi)
    annotation (Line(
      points={{0,-50},{0,-40},{40,-40},{40,60},{0.1,60},{0.1,100.1}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));

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
