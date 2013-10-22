within Districts.Electrical.AC.ThreePhasesBalanced.Lines;
model Line
  extends Districts.Electrical.AC.OnePhase.Lines.Line(
      redeclare Interfaces.Terminal_n terminal_n,
      redeclare Interfaces.Terminal_p terminal_p,
      redeclare TwoPortRL lineRL,
      final useC = false);
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
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
