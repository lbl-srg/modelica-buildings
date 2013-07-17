within Districts.Electrical.AC.AC3ph.Lines;
model TwoPortResistance
  extends Districts.Electrical.Transmission.Base.PartialTwoPortResistance(
      redeclare package PhaseSystem_p =
        Districts.Electrical.PhaseSystems.ThreePhase_dq,
      redeclare package PhaseSystem_n =
        Districts.Electrical.PhaseSystems.ThreePhase_dq,
      redeclare Interfaces.Terminal_n terminal_n,
      redeclare Interfaces.Terminal_p terminal_p);
equation
  Connections.branch(terminal_p.theta, terminal_n.theta);
  terminal_p.theta = terminal_n.theta;

  terminal_p.v - terminal_n.v = terminal_p.i*diagonal(ones(PhaseSystem_p.n)*R_actual);

  annotation (Diagram(graphics={
          Rectangle(extent={{-70,30},{70,-30}}, lineColor={0,0,0}),
          Line(points={{-90,0},{-70,0}}, color={0,0,0}),
          Line(points={{70,0},{90,0}}, color={0,0,0})}),     Icon(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                                  graphics={
          Text(
            extent={{-144,97},{156,57}},
            textString="%name",
            lineColor={0,0,255})}));
end TwoPortResistance;
