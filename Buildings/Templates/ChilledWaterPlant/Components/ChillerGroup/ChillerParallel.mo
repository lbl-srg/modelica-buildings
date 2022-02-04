within Buildings.Templates.ChilledWaterPlant.Components.ChillerGroup;
model ChillerParallel
  extends
    Buildings.Templates.ChilledWaterPlant.Components.ChillerGroup.Interfaces.PartialChillerGroup(
      final typ=Buildings.Templates.ChilledWaterPlant.Components.Types.ChillerGroup.ChillerParallel);

  inner replaceable
    Buildings.Templates.ChilledWaterPlant.Components.Chiller.ElectricChiller
    chi[nChi](
    each final m1_flow_nominal=m1_flow_nominal/nChi,
    each final m2_flow_nominal=m2_flow_nominal/nChi,
    each final dp1_nominal=dp1_nominal,
    each final dp2_nominal=dp2_nominal,
    each final per=per) constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.Chiller.Interfaces.PartialChiller(
    redeclare each final package Medium1 = MediumCW,
    redeclare each final package Medium2 = MediumCHW)
    "Chillers"
      annotation (Placement(transformation(extent={{
            -20,-20},{20,20}}, rotation=0)));

  Fluid.Delays.DelayFirstOrder volCHW(
    redeclare final package Medium = MediumCHW,
    final m_flow_nominal=m2_flow_nominal,
    final nPorts=1+nChi)
    "Chilled water side mixing volume"
    annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},rotation=90,origin={8,-60})));
  Fluid.Delays.DelayFirstOrder volCW(
    redeclare final package Medium = MediumCW,
    final m_flow_nominal=m1_flow_nominal,
    final nPorts=1+nChi) if not isAirCoo
    "Condenser water side mixing volume"
    annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},rotation=0,origin={60,80})));
  inner replaceable Buildings.Templates.Components.Valves.TwoWayModulating valCHWChi[nChi]
    if not have_CHWDedPum
    constrainedby Buildings.Templates.Components.Valves.Interfaces.PartialValve(
    redeclare each final package Medium = MediumCHW,
    each final m_flow_nominal=m2_flow_nominal/nChi,
    each final dpValve_nominal=dpCHWValve_nominal)
    "Chiller chilled water-side isolation valves"
    annotation (Placement(transformation(
      extent={{10,-10},{-10,10}},rotation=0,origin={-70,0})));
  Buildings.Templates.BaseClasses.PassThroughFluid pasCHW[nChi](
    redeclare each final package Medium = MediumCHW) if have_CHWDedPum
    "Chilled water passthrough"
    annotation (Placement(transformation(extent={{-60,-30},{-80,-10}})));
  inner replaceable Buildings.Templates.Components.Valves.TwoWayTwoPosition valCWChi[nChi]
    if not have_CWDedPum and not isAirCoo
    constrainedby Buildings.Templates.Components.Valves.TwoWayTwoPosition(
    redeclare each final package Medium = MediumCW,
    each final m_flow_nominal=m1_flow_nominal/nChi,
    each final dpValve_nominal=dpCWValve_nominal)
    "Chiller condenser water-side isolation valves" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,60})),
      choices(
        choice(redeclare replaceable Buildings.Templates.Components.Valves.TwoWayModulating valCWChi
          "Modulating"),
        choice(redeclare replaceable Buildings.Templates.Components.Valves.TwoWayTwoPosition valCWChi
          "Two-positions")));
  Buildings.Templates.BaseClasses.PassThroughFluid pasCW[nChi](
    redeclare each final package Medium = MediumCW)
    if have_CWDedPum and not isAirCoo
    "Condenser water passthrough"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
equation

  connect(busCon.chi, chi.bus) annotation (Line(
      points={{0.1,100.1},{0.1,100},{0,100},{0,20}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(port_a2, volCHW.ports[1])
    annotation (Line(points={{100,-60},{18,-60}},
    color={0,127,255}));
  connect(volCHW.ports[2:(nChi+1)], chi.port_a2)
    annotation (Line(points={{18,-60},{18,-58},{40,-58},{40,-12},{20,-12}},
    color={0,127,255}));
  connect(volCW.ports[1], port_b1)
    annotation (Line(points={{60,70},{60,60},{100,60}},
    color={0,127,255}));
  connect(chi.port_b1, volCW.ports[2:3])
    annotation (Line(points={{20,12},{60,12},{60,70}},
    color={0,127,255}));
  connect(chi.port_b2, valCHWChi.port_a)
    annotation (Line(points={{-20,-12},{-30,-12},{-30,0},{-60,0}},
    color={0,127,255}));
  connect(valCHWChi.port_b, ports_b2)
    annotation (Line(points={{-80,0},{-100,0}}, color={0,127,255}));
  connect(chi.port_b2, pasCHW.port_a) annotation (Line(points={{-20,-12},{-30,-12},
          {-30,0},{-48,0},{-48,-20},{-60,-20}}, color={0,127,255}));
  connect(pasCHW.port_b, ports_b2) annotation (Line(points={{-80,-20},{-90,-20},
          {-90,0},{-100,0}}, color={0,127,255}));
  connect(valCHWChi.bus, busCon.valCHWChi) annotation (Line(
      points={{-70,10},{-70,30},{0.1,30},{0.1,100.1}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(ports_a1, valCWChi.port_a)
    annotation (Line(points={{-100,60},{-80,60}},
    color={0,127,255}));
  connect(valCWChi.port_b, chi.port_a1)
    annotation (Line(points={{-60,60},{-30,60},{-30,12},{-20,12}},
    color={0,127,255}));
  connect(ports_a1, pasCW.port_a)
    annotation (Line(points={{-100,60},{-90,60},{-90,40},{-80,40}},
    color={0,127,255}));
  connect(pasCW.port_b, chi.port_a1)
    annotation (Line(points={{-60,40},{-48,40},{-48,60},{-30,60},{-30,12},{-20,12}},
    color={0,127,255}));
  connect(busCon.valCWChi, valCWChi.bus)
    annotation (Line(
      points={{0.1,100.1},{0.1,80},{-70,80},{-70,70}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
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
end ChillerParallel;
