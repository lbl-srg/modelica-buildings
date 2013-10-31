within Buildings.Electrical.DC.Lines;
model Line "Model of a DC electrical line"
  extends Buildings.Electrical.Transmission.Base.PartialLine(
    redeclare package PhaseSystem_p = PhaseSystems.TwoConductor,
    redeclare package PhaseSystem_n = PhaseSystems.TwoConductor,
    redeclare Interfaces.Terminal_n terminal_n,
    redeclare Interfaces.Terminal_p terminal_p,
    final modelMode=Types.Assumption.FixedZ_steady_state);

  TwoPortRCLine lineRC(
    useHeatPort=true,
    R=R,
    V_nominal=V_nominal,
    T_ref=T_ref,
    M=M,
    C=C,
    useC=useC)
    annotation (Placement(transformation(extent={{-10,10},{10,-10}})));
equation
  connect(terminal_n, lineRC.terminal_n) annotation (Line(
      points={{-100,0},{-10,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(lineRC.terminal_p, terminal_p) annotation (Line(
      points={{10,0},{100,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(cableTemp.port, lineRC.heatPort) annotation (Line(
      points={{-40,22},{0,22},{0,10}},
      color={191,0,0},
      smooth=Smooth.None));
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
