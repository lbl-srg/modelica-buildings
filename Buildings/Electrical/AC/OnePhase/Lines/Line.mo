within Buildings.Electrical.AC.OnePhase.Lines;
model Line
  extends Buildings.Electrical.Transmission.Base.PartialLine(
    redeclare package PhaseSystem_p = PhaseSystems.OnePhase,
    redeclare package PhaseSystem_n = PhaseSystems.OnePhase,
    redeclare Interfaces.Terminal_n terminal_n(redeclare package PhaseSystem =
          PhaseSystem_n),
    redeclare Interfaces.Terminal_p terminal_p(redeclare package PhaseSystem =
          PhaseSystem_p),
    final voltageLevel=Types.VoltageLevel.Low,
    final commercialCable_med=Buildings.Electrical.Transmission.Functions.selectCable_med(P_nominal, V_nominal));
protected
  replaceable TwoPortRL line(
    useHeatPort=true,
    mode=modelMode,
    M=M,
    T_ref=T_ref,
    V_nominal=V_nominal,
    R=R/3,
    L=L/3)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  connect(cableTemp.port, line.heatPort)       annotation (Line(
      points={{-40,22},{-28,22},{-28,-10},{4.44089e-16,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(line.terminal_n, terminal_n)       annotation (Line(
      points={{-10,4.44089e-16},{-48,4.44089e-16},{-48,0},{-100,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(terminal_p, line.terminal_p)       annotation (Line(
      points={{100,0},{56,0},{56,4.44089e-16},{10,4.44089e-16}},
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
