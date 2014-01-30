within Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines;
model Line
  extends Buildings.Electrical.Transmission.Base.PartialBaseLine;
  Interfaces.Terminal_n terminal_n
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Interfaces.Terminal_p terminal_p
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  OnePhase.Lines.TwoPortRLC phase1(
    useHeatPort=true,
    R=R/3,
    T_ref=T_ref,
    M=M,
    C=C/3,
    L=L/3,
    V_nominal=V_nominal,
    mode=modelMode)
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  OnePhase.Lines.TwoPortRLC phase2(
    useHeatPort=true,
    R=R/3,
    T_ref=T_ref,
    M=M,
    C=C/3,
    L=L/3,
    V_nominal=V_nominal,
    mode=modelMode)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  OnePhase.Lines.TwoPortRLC phase3(
    useHeatPort=true,
    R=R/3,
    T_ref=T_ref,
    M=M,
    C=C/3,
    L=L/3,
    V_nominal=V_nominal,
    mode=modelMode)
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
equation

  connect(cableTemp.port, phase1.heatPort) annotation (Line(
      points={{-40,22},{-26,22},{-26,10},{6.66134e-16,10},{6.66134e-16,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(cableTemp.port, phase2.heatPort) annotation (Line(
      points={{-40,22},{-26,22},{-26,-20},{0,-20},{0,-10},{4.44089e-16,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(cableTemp.port, phase3.heatPort) annotation (Line(
      points={{-40,22},{-26,22},{-26,-50},{0,-50},{0,-40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(terminal_n.phase[1], phase1.terminal_n) annotation (Line(
      points={{-100,0},{-20,0},{-20,30},{-10,30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(terminal_n.phase[2], phase2.terminal_n) annotation (Line(
      points={{-100,0},{-10,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(terminal_n.phase[3], phase3.terminal_n) annotation (Line(
      points={{-100,4.44089e-16},{-20,4.44089e-16},{-20,-30},{-10,-30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(phase1.terminal_p, terminal_p.phase[1]) annotation (Line(
      points={{10,30},{20,30},{20,4.44089e-16},{100,4.44089e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(phase2.terminal_p, terminal_p.phase[2]) annotation (Line(
      points={{10,0},{100,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(phase3.terminal_p, terminal_p.phase[3]) annotation (Line(
      points={{10,-30},{20,-30},{20,4.44089e-16},{100,4.44089e-16}},
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
          smooth=Smooth.None)}));
end Line;
