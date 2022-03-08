within Buildings.Templates.ChilledWaterPlant.Components.ChillerGroup;
model ChillerParallel
  extends
    Buildings.Templates.ChilledWaterPlant.Components.ChillerGroup.Interfaces.PartialChillerGroup(
      dat(final typ=Buildings.Templates.ChilledWaterPlant.Components.Types.ChillerGroup.ChillerParallel,
        chi(redeclare each replaceable Buildings.Fluid.Chillers.Data.ElectricEIR.Generic per)));

  inner replaceable
    Buildings.Templates.ChilledWaterPlant.Components.Chiller.ElectricChiller
    chi[nChi] constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.Chiller.Interfaces.PartialChiller(
    dat=dat.chi,
    redeclare each final package Medium1 = MediumCW,
    redeclare each final package Medium2 = MediumCHW)
    "Chillers"
      annotation (Placement(transformation(extent={{
            -20,-20},{20,20}}, rotation=0)));

  Fluid.Delays.DelayFirstOrder volCHW(
    redeclare final package Medium = MediumCHW,
    final m_flow_nominal=dat.m2_flow_nominal,
    final nPorts=nChi+1)
    "Chilled water side mixing volume"
    annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},rotation=90,origin={8,-60})));
  Fluid.Delays.DelayFirstOrder volCW(
    redeclare final package Medium = MediumCW,
    final m_flow_nominal=dat.m1_flow_nominal,
    final nPorts=1+nChi) if not isAirCoo
    "Condenser water side mixing volume"
    annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},rotation=0,origin={60,80})));

  // FIXME: Bind have_sen to configuration parameter.
  Buildings.Templates.Components.Sensors.Temperature TCHWRetChi[nChi](
    redeclare each final package Medium = MediumCHW,
    each final have_sen=true,
    each final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    each final m_flow_nominal=dat.m2_flow_nominal/nChi) "Chiller CHW return temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,-40})));
  // FIXME: Bind have_sen to configuration parameter.
  Buildings.Templates.Components.Sensors.Temperature TCHWSupChi[nChi](
    redeclare each final package Medium = MediumCHW,
    each final have_sen=true,
    each final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    each final m_flow_nominal=dat.m2_flow_nominal/nChi)
    "Chiller CHW supply temperature"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-60,-20})));
equation
  connect(TCHWRetChi.y, busCon.TCHWRetChi);
  connect(TCHWSupChi.y, busCon.TCHWSupChi);

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
  connect(volCW.ports[1], port_b1)
    annotation (Line(points={{60,70},{60,60},{100,60}},
    color={0,127,255}));
  connect(chi.port_b1, volCW.ports[2:3])
    annotation (Line(points={{20,12},{60,12},{60,70}},
    color={0,127,255}));
  connect(TCHWRetChi.port_b, chi.port_a2)
    annotation (Line(points={{40,-30},{40,-12},{20,-12}}, color={0,127,255}));
  connect(TCHWRetChi.port_a, volCHW.ports[2:nChi+1])
    annotation (Line(points={{40,-50},{40,-60},{18,-60}}, color={0,127,255}));
  connect(chi.port_b2, TCHWSupChi.port_a)
    annotation (Line(points={{-20,-12},{-40,-12},{-40,-20},{-50,-20}},
                                                   color={0,127,255}));
  connect(chi.port_a1, ports_a1) annotation (Line(points={{-20,12},{-60,12},{
          -60,60},{-100,60}}, color={0,127,255}));
  connect(TCHWSupChi.port_b, ports_b2) annotation (Line(points={{-70,-20},{-86,
          -20},{-86,0},{-100,0}}, color={0,127,255}));
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
