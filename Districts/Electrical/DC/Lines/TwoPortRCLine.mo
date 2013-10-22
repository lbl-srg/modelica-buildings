within Districts.Electrical.DC.Lines;
model TwoPortRCLine
  extends Districts.Electrical.Transmission.Base.PartialTwoPortRC(
    redeclare package PhaseSystem_p =
        Districts.Electrical.PhaseSystems.TwoConductor,
    redeclare package PhaseSystem_n =
        Districts.Electrical.PhaseSystems.TwoConductor,
      redeclare Districts.Electrical.DC.Interfaces.Terminal_n
                                                           terminal_n,
      redeclare Districts.Electrical.DC.Interfaces.Terminal_p
                                                           terminal_p);

equation
  terminal_p.v[1] - (V+terminal_p.v[2]) = terminal_p.i[1]*R_actual/2;
  terminal_n.v[1] - (V+terminal_p.v[2]) = terminal_n.i[1]*R_actual/2;

  C*der(V) = terminal_p.i[1] + terminal_n.i[1];

  terminal_p.v[2] = terminal_n.v[2];
  terminal_p.i[2] + terminal_n.i[2] = 0;

  annotation (Diagram(graphics={
          Rectangle(extent={{-70,30},{70,-30}}, lineColor={0,0,255}),
          Line(points={{-90,0},{-70,0}}, color={0,0,255}),
          Line(points={{70,0},{90,0}},   color={0,0,255})}), Icon(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                                  graphics={
          Text(
            extent={{-144,97},{156,57}},
            textString="%name",
            lineColor={0,0,255}),
          Line(points={{-90,0},{-70,0}}, color={0,0,255}),
          Line(points={{70,0},{90,0}},   color={0,0,255}),
        Rectangle(
          extent={{-70,30},{70,-30}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end TwoPortRCLine;
