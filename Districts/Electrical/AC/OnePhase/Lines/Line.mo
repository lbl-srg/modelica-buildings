within Districts.Electrical.AC.OnePhase.Lines;
model Line
  extends Districts.Electrical.Transmission.Base.PartialLine(
      redeclare package PhaseSystem_p =
        Districts.Electrical.PhaseSystems.OnePhase,
      redeclare package PhaseSystem_n =
        Districts.Electrical.PhaseSystems.OnePhase,
      redeclare Interfaces.Terminal_n terminal_n,
      redeclare Interfaces.Terminal_p terminal_p,
      final useC = false);
protected
  replaceable TwoPortRL lineRL(
    useHeatPort=true,
    R=R,
    L=L,
    mode=Districts.Electrical.Types.Assumption.FixedZ_steady_state)
    annotation (Placement(transformation(extent={{-10,10},{10,-10}})));

equation
  connect(lineRL.terminal_n, terminal_n)
                                        annotation (Line(
      points={{-10,0},{-100,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(cableTemp.port, lineRL.heatPort)
                                          annotation (Line(
      points={{-40,22},{0,22},{0,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(lineRL.terminal_p, terminal_p) annotation (Line(
      points={{10,0},{100,0}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(graphics={
        Ellipse(
          extent={{-70,10},{-50,-10}},
          lineColor={0,0,0},
          fillColor={0,94,94},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,10},{60,-10}},
          fillColor={0,94,94},
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
