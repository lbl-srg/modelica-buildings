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
    each final per=per)
              constrainedby
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
      extent={{-10,-10},{10,10}},rotation=0,origin={60,84})));
  Fluid.Actuators.Valves.TwoWayLinear valChi[nChi](
    redeclare each final package Medium = MediumCHW,
    each final m_flow_nominal=m2_flow_nominal/nChi,
    each final dpValve_nominal=dpValve_nominal) if not has_dedPum
    "Chillers valves"
    annotation (Placement(transformation(
      extent={{10,-10},{-10,10}},rotation=0,origin={-70,20})));
  Buildings.Templates.BaseClasses.PassThroughFluid pas[nChi](
    redeclare each final package Medium = MediumCHW) if has_dedPum
    "Passthrough"
    annotation (Placement(transformation(extent={{-60,-30},{-80,-10}})));
equation

  connect(busCon.chi, chi.busCon) annotation (Line(
      points={{0.1,100.1},{0.1,100},{0,100},{0,20}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(port_a2, volCHW.ports[1]) annotation (Line(points={{100,-60},{18,-60}},
                          color={0,127,255}));
  connect(volCHW.ports[2:(nChi+1)], chi.port_a2) annotation (Line(points={{18,-60},
          {18,-58},{40,-58},{40,-12},{20,-12}}, color={0,127,255}));
  connect(ports_a1, chi.port_a1) annotation (Line(points={{-100,60},{-40,60},{
          -40,12},{-20,12}}, color={0,127,255}));
  connect(volCW.ports[1], port_b1) annotation (Line(points={{60,74},{60,60},{100,
          60}},      color={0,127,255}));
  connect(chi.port_b1, volCW.ports[2:3]) annotation (Line(points={{20,12},{60,12},
          {60,74}},                   color={0,127,255}));
  connect(chi.port_b2, valChi.port_a) annotation (Line(points={{-20,-12},{-40,-12},
          {-40,0},{-54,0},{-54,20},{-60,20}}, color={0,127,255}));
  connect(valChi.port_b, ports_b2) annotation (Line(points={{-80,20},{-86,20},{-86,
          0},{-100,0}}, color={0,127,255}));
  connect(chi.port_b2, pas.port_a) annotation (Line(points={{-20,-12},{-40,-12},
          {-40,0},{-54,0},{-54,-20},{-60,-20}}, color={0,127,255}));
  connect(pas.port_b, ports_b2) annotation (Line(points={{-80,-20},{-86,-20},{-86,
          0},{-100,0}}, color={0,127,255}));
  connect(busCon.yValChi, valChi.y) annotation (Line(
      points={{0.1,100.1},{0.1,78},{-70,78},{-70,32}},
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
