within Districts.Electrical.DC.Lines;
model Line
  extends Districts.Electrical.Transmission.Base.PartialLine(
      redeclare package PhaseSystem_p =
        Districts.Electrical.PhaseSystems.TwoConductor,
      redeclare package PhaseSystem_n =
        Districts.Electrical.PhaseSystems.TwoConductor,
      redeclare Districts.Electrical.DC.Interfaces.Terminal_n
                                                           terminal_n,
      redeclare Districts.Electrical.DC.Interfaces.Terminal_p
                                                           terminal_p);

  TwoPortRCLine lineRC(
    useHeatPort=true,
    R=R,
    V_nominal=V_nominal) if useC
    annotation (Placement(transformation(extent={{-10,10},{10,-10}})));
  TwoPortResistance lineR(useHeatPort=true, R=R) if not useC
    annotation (Placement(transformation(extent={{-26,-16},{-6,-38}})));
equation

  if useC then
    connect(lineRC.terminal_n, terminal_n)
                                        annotation (Line(
      points={{-10,0},{-100,0}},
      color={0,0,0},
      smooth=Smooth.None));
    connect(lineRC.terminal_p, terminal_p)
                                        annotation (Line(
      points={{10,0},{100,0}},
      color={0,0,0},
      smooth=Smooth.None));
    connect(cableTemp.port, lineRC.heatPort)
                                          annotation (Line(
      points={{-40,22},{0,22},{0,10}},
      color={191,0,0},
      smooth=Smooth.None));
  else
    connect(cableTemp.port, lineR.heatPort) annotation (Line(
      points={{-40,22},{-16,22},{-16,-16}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(terminal_n, lineR.terminal_n) annotation (Line(
      points={{-100,0},{-64,0},{-64,-27},{-26,-27}},
      color={0,0,255},
      smooth=Smooth.None));
    connect(lineR.terminal_p, terminal_p) annotation (Line(
      points={{-6,-27},{44,-27},{44,0},{100,0}},
      color={0,0,255},
      smooth=Smooth.None));
  end if
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(graphics={
        Ellipse(
          extent={{-70,10},{-50,-10}},
          lineColor={0,0,0},
          fillColor={96,107,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,10},{60,-10}},
          fillColor={96,107,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{50,10},{70,-10}},
          lineColor={0,0,0},
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-70,0},{-90,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-60,10},{60,10}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-60,-10},{60,-10}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{96,0},{60,0}},
          color={0,0,0},
          smooth=Smooth.None)}));

end Line;
