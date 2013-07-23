within Districts.Electrical.AC.AC3ph.Lines;
model Line
  extends Districts.Electrical.Transmission.Base.PartialLine(
      redeclare package PhaseSystem_p =
        Districts.Electrical.PhaseSystems.ThreePhase_dq,
      redeclare package PhaseSystem_n =
        Districts.Electrical.PhaseSystems.ThreePhase_dq,
      redeclare Interfaces.Terminal_n terminal_n,
      redeclare Interfaces.Terminal_p terminal_p);
  TwoPortResistance             lineR(useHeatPort=true, R=R)
    annotation (Placement(transformation(extent={{-10,10},{10,-10}})));
  TwoPortInductance             lineL(L=L, mode=Districts.Electrical.Types.Assumption.FixedZ_steady_state)
    annotation (Placement(transformation(extent={{24,-10},{44,10}})));

equation
  connect(lineR.terminal_n, terminal_n) annotation (Line(
      points={{-10,0},{-100,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(cableTemp.port, lineR.heatPort) annotation (Line(
      points={{-40,22},{0,22},{0,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(lineR.terminal_p, lineL.terminal_n) annotation (Line(
      points={{10,0},{24,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(lineL.terminal_p, terminal_p) annotation (Line(
      points={{44,0},{100,0}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(graphics={
        Ellipse(
          extent={{-70,10},{-50,-10}},
          lineColor={0,0,0},
          fillColor={11,193,87},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,10},{60,-10}},
          fillColor={11,193,87},
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
          smooth=Smooth.None),
          Text(
            extent={{-148,-45},{152,-85}},
            lineColor={0,0,0},
          textString="%name")}));
end Line;
