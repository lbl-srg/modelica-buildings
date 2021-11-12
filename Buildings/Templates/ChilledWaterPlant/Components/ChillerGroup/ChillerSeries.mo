within Buildings.Templates.ChilledWaterPlant.Components.ChillerGroup;
model ChillerSeries
  extends
    Buildings.Templates.ChilledWaterPlant.Components.ChillerGroup.Interfaces.ChillerGroup(
    final typ=Buildings.Templates.ChilledWaterPlant.Components.Types.ChillerGroup.ChillerSeries);

  inner replaceable
    Buildings.Templates.ChilledWaterPlant.Components.Chiller.ElectricChiller
    chi[nChi] constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.Chiller.Interfaces.Chiller(
    redeclare each final package Medium1 = Medium1,
    redeclare each final package Medium2 = Medium2,
    final is_airCoo=is_airCoo) annotation (Placement(transformation(extent={{
            -20,-20},{20,20}}, rotation=0)));

  Fluid.FixedResistances.Junction splChi[nChi](redeclare package Medium = Medium,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Chiller splitter"              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={60,-60})));
  Fluid.FixedResistances.Junction mixChi[nChi](redeclare package Medium = Medium,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) "Chiller mixer"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-60,-60})));
  Fluid.Actuators.Valves.TwoWayLinear valChi[nChi] if has_byp "Chiller valve"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={0,-60})));
  Fluid.MixingVolumes.MixingVolume volCW(nPorts=3) if not is_airCoo
    "Condenser water side mixing volume" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={10,60})));
equation

  connect(busCon.chi, chi.busCon) annotation (Line(
      points={{0.1,100.1},{0.1,80},{80,80},{80,30},{0,30},{0,20}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(chi.port_a2,splChi. port_3)
    annotation (Line(points={{20,-12},{60,-12},{60,-50}}, color={0,127,255}));
  connect(chi.port_b2, mixChi.port_3) annotation (Line(points={{-20,-12},{-60,-12},
          {-60,-50}}, color={0,127,255}));
  connect(valChi.port_b, mixChi.port_2)
    annotation (Line(points={{-10,-60},{-50,-60}}, color={0,127,255}));
  connect(valChi.port_a,splChi. port_2)
    annotation (Line(points={{10,-60},{50,-60}}, color={0,127,255}));
  connect(port_a2,splChi [1].port_1)
    annotation (Line(points={{100,-60},{70,-60}}, color={0,127,255}));
  connect(mixChi[nChi].port_1, port_b2)
    annotation (Line(points={{-70,-60},{-100,-60}}, color={0,127,255}));
  for i in 2:nChi loop
    connect(mixChi.port_1[i - 1], splChi.port_1[i]) annotation (Line(points={{-70,
            -60},{-80,-60},{-80,-80},{80,-80},{80,-60},{70,-60}}, color={0,127,
            255}));
  end for;
  connect(ports_a1, chi.port_a1) annotation (Line(points={{-100,60},{-40,60},{
          -40,12},{-20,12}}, color={0,127,255}));
  connect(port_b1, volCW.ports[1]) annotation (Line(points={{100,60},{20,60},{
          20,57.3333}}, color={0,127,255}));
  connect(chi.port_b1, volCW.ports[2:3]) annotation (Line(points={{20,12},{40,
          12},{40,62.6667},{20,62.6667}},
                                color={0,127,255}));
  connect(busCon.valChi, valChi.y) annotation (Line(
      points={{0,100},{0,80},{-30,80},{-30,-40},{0,-40},{0,-48}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
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
end ChillerSeries;
