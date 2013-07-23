within Districts.Electrical.DC.Lines;
model TwoPortResistance
  extends Districts.Electrical.Transmission.Base.PartialTwoPortResistance(
    redeclare package PhaseSystem_p =
        Districts.Electrical.PhaseSystems.TwoConductor,
    redeclare package PhaseSystem_n =
        Districts.Electrical.PhaseSystems.TwoConductor,
      redeclare Districts.Electrical.DC.Interfaces.Terminal_n
                                                           terminal_n,
      redeclare Districts.Electrical.DC.Interfaces.Terminal_p
                                                           terminal_p);

equation
  //terminal_p.v - terminal_n.v = terminal_p.i*diagonal(ones(PhaseSystem_p.n)*R_actual);
  terminal_p.v[1] - terminal_n.v[1] = terminal_p.i[1]*R_actual;
  terminal_p.v[2] = terminal_n.v[2];
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
          Text(
            extent={{-142,-30},{144,-62}},
            lineColor={0,0,0},
          textString="R=%R"),
          Line(points={{-90,0},{-70,0}}, color={0,0,255}),
          Line(points={{70,0},{90,0}},   color={0,0,255}),
        Rectangle(
          extent={{-70,30},{70,-30}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end TwoPortResistance;
